// ignore_for_file: depend_on_referenced_packages, must_be_immutable

import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../../common_widgets/height.dart';
import '../../global/app_color.dart';
import '../../global/services/api_shorts_string.dart';
import '../../global/theme/app_text_style.dart';
import '../add_reel/controller/create_reel_controller.dart';
import '../shorts/controller/my_profile_controller.dart';

class PostVideoScreen extends StatefulWidget {
  var videoFile;
  var videoId;
  var editVideoData;
  bool fromEdit;

  PostVideoScreen(
      {super.key,
      this.videoFile,
      this.videoId,
      this.editVideoData,
      this.fromEdit = false});

  @override
  State<PostVideoScreen> createState() => _PostVideoScreenState();
}

class _PostVideoScreenState extends State<PostVideoScreen> {
  // final createReelController = Get.find<CreateReelController>();
  final createReelController =
      Get.put<CreateReelController>(CreateReelController());
  bool publicChecked = false;
  bool privateChecked = false;
  File? thumbnailFile;
  Uint8List? thumbnailData;
  String visibility = '';
  bool isApiCallProcessing = false;
  File? videoFile;
  TextEditingController textController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  @override
  void initState() {
    super.initState();

    if (widget.fromEdit == false) {
      createReelController.videoController =
          VideoPlayerController.networkUrl(Uri.parse(""));
      createThumbnailFile(widget.videoFile!);
    } else {
      textController.text =
          widget.editVideoData["video"]["video_caption"] ?? "";

      if (widget.editVideoData["video"]["visibility"]
              .toString()
              .toLowerCase() ==
          'private') {
        privateChecked = true;
        visibility = 'private';
        log("Visibility===");
        log(visibility);
        publicChecked = false;
      } else if (widget.editVideoData["video"]["visibility"]
              .toString()
              .toLowerCase() ==
          'public') {
        publicChecked = true;
        visibility = 'public';
        log("Visibility===");
        log(visibility);
        privateChecked = false;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.fromEdit == false) {
      createReelController.videoController.dispose();
    }
  }

  Future<void> createThumbnailFile(/*File*/ video) async {
    try {
      if (video != null) {
        thumbnailData = await VideoThumbnail.thumbnailData(
          // video: video.path,
          video: Uri.parse(video).path,
          imageFormat: ImageFormat.JPEG,
          maxWidth: 100,
          quality: 25,
        );
      }
      thumbnailFile = await createFileFromUint8List(thumbnailData!);
      setState(() {});
    } catch (e) {
      log("catch block of thumbnail create - $e");
    }
  }

  Future<File> createFileFromUint8List(Uint8List uint8List) async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    File tempFile =
        File('$tempPath/thumbnail${DateTime.now().microsecondsSinceEpoch}.jpg');
    await tempFile.writeAsBytes(thumbnailData as List<int>);
    return tempFile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Post Video',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          SizedBox(
            height: 200,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: 10,
                ),
              ),
              child: Center(
                child: thumbnailFile != null
                    ? Image.file(thumbnailFile!)
                    : widget.fromEdit == true &&
                            widget.editVideoData["video"]["thumbnail"]
                                .toString()
                                .isNotEmpty
                        ? Image.network(
                            "${APIShortsString.thumbnailBaseUrl}${widget.editVideoData["video"]["thumbnail"].toString()}",
                            width: 200,
                            height: 160.0,
                          )
                        : Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/png/video_icon.png',
                                  width: 200,
                                  height: 160.0,
                                ),
                                const Text(
                                  'Select Thumbnail',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
              ),
            ),
          ),
          ElevatedButton(
              onPressed: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.image,
                  // allowedExtensions: ['mp4'],
                  allowMultiple: false,
                );
                if (result != null) {
                  thumbnailFile = File(result.files.single.path!);
                  setState(() {});
                } else {
                  log('No file selected');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                padding: const EdgeInsets.symmetric(
                    horizontal: 35,
                    vertical: 12), // Adjust padding to change size
              ),
              child: const Text("CHANGE THUMBNAIL")),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            child:
            Card(
              elevation: 4.0,
              child: Column(children: [
                Container(
                  //height: 80,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white60,
                        blurRadius: 10.0,
                      ),
                    ],
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: TextField(
                      controller: textController,
                      style: const TextStyle(fontSize: 18, color: Colors.black,overflow: TextOverflow.ellipsis),
                      maxLines: null,
                      decoration: const InputDecoration(
                        hintText: "Add Suitable Caption",
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    String currentText = textController.text;
                    String newText = '$currentText#';
                    textController.text = newText;
                  },
                  child: Text('#TAG',
                      style: AppTextStyle.regular
                          .copyWith(fontSize: 18, color: AppColor.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 35,
                        vertical: 8), // Adjust padding to change size
                  ),
                ),
              ],),
            ),
          ),

          const SizedBox(
            height: 10,
          ),
          Get.find<MyProfileController>().userId.value == APIShortsString.admin_id?
          SizedBox(
            child:
            Card(
              elevation: 4.0,
              child: Column(children: [
                Container(
                  //height: 80,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white60,
                        blurRadius: 10.0,
                      ),
                    ],
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: TextField(
                      controller: cityController,
                      style: const TextStyle(fontSize: 18, color: Colors.black,overflow: TextOverflow.ellipsis),
                      maxLines: null,
                      decoration: const InputDecoration(
                        hintText: "Add City Name",
                      ),
                    ),
                  ),
                ),

              ],),
            ),
          ):const SizedBox(),

          const SizedBox(height: 10),
          Container(
            height: 50,
            width: 350,
            decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.white60,
                  blurRadius: 10.0,
                ),
              ],
            ),
            child: Container(
                padding: const EdgeInsets.all(8),
                child: const Text(
                  'Privacy Settings',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      color: Colors.black54,
                  ),
                ),
              ),
          ),
          Card(
            elevation: 4.0,
            child: Column(children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    publicChecked = true;
                    visibility = 'public';
                    log("Visibility===");
                    log(visibility);
                    privateChecked = false;
                  });
                },
                child: Container(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Public',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black),
                            ),
                            Icon(
                              publicChecked
                                  ? Icons.check_box
                                  : Icons.crop_square_sharp,
                              size: 30.0,
                            ),
                          ],
                        ),
                        const Text(
                          'Visible to Everyone',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    privateChecked = true;
                    visibility = 'private';
                    log("Visibility===");
                    log(visibility);
                    publicChecked = false;
                  });
                },
                child: Container(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Private',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black),
                            ),
                            Icon(
                              privateChecked
                                  ? Icons.check_box
                                  : Icons.crop_square_sharp,
                              size: 30.0,
                            ),
                          ],
                        ),
                        const Text(
                          'Not Visible to Everyone',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              boxW10(),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 35,
                        vertical: 12), // Adjust padding to change size
                  ),
                  child: const Text('BACK'),
                ),
              ),
              // ElevatedButton(
              //   onPressed: () {
              //     if(validation()==true){
              //       // PostVideoApi();
              //       createReelController.uploadReel(
              //           thumbnail: thumbnailFile,
              //           video: widget.videoFile,
              //           videoCaption: textController.text,
              //           visibility: visibility
              //       );
              //     }
              //     else{
              //       Fluttertoast.showToast(
              //         msg: "Please Select all field",
              //         backgroundColor: Colors.grey,
              //       );
              //     }
              //   },
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: Colors.orange,
              //     padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 12), // Adjust padding to change size
              //   ),
              //   child: const Text('SHARE'),
              // ),
              boxW10(),
              Expanded(child:
              ElevatedButton(
                onPressed: () {
                  if (validation() == true) {
                    // PostVideoApi();
                    if (widget.fromEdit == false) {
                      createReelController.uploadReel(
                          thumbnail: thumbnailFile,
                          video: widget.videoFile,
                          videoCaption: textController.text,
                          city: cityController.text,
                          visibility: visibility);
                    } else {
                      createReelController.updateReel(
                          thumbnail: thumbnailFile,
                          videoId: widget.videoId,
                          city: cityController.text,
                          videoCaption: textController.text,
                          visibility: visibility);
                    }
                  } else {
                    Fluttertoast.showToast(
                      msg: "Please Select all field",
                      backgroundColor: Colors.grey,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 35,
                      vertical: 12),
                ),
                child: const Text('SAVE'),
              ),),
              boxW10(),
            ],
          )
        ]),
      ),
    );
  }

  //Progrss bar
  void showprogressDialog(String msg) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
          backgroundColor: Colors.yellow[50],
          content: Wrap(children: <Widget>[
            SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    msg,
                    style: const TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Center(
                    child: CircularProgressIndicator(),
                  )
                ],
              ),
            )
          ])),
    );
  }

  //Validation
  bool validation() {
    if (textController.text.isEmpty || textController.text == '') {
      Fluttertoast.showToast(
        msg: "Please Enter Caption",
        backgroundColor: Colors.grey,
      );
      return false;
    }
    if (visibility == '' || visibility.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please Enter Visibility",
        backgroundColor: Colors.grey,
      );
      return false;
    }
    return true;
  }
}
