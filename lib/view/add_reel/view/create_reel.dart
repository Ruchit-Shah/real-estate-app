
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:video_player/video_player.dart';

import '../../../global/app_color.dart';
import '../../post_video/post_video.dart';
import '../../post_video/post_video_controller.dart';


class CreateReel extends StatefulWidget {
  const CreateReel({super.key});

  @override
  State<CreateReel> createState() => _CreateReelState();
}

class _CreateReelState extends State<CreateReel> {
  final addStoryController = Get.find<AddStoryController>();

@override
  void initState() {
    super.initState();

    addStoryController.videoController = VideoPlayerController.networkUrl(Uri.parse(""));

  }

  @override
  void dispose() {
    super.dispose();
    addStoryController.videoController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.black,
        body: FutureBuilder(
          future: addStoryController.cameraInitializeFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return buildCameraScreen();
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }

  Widget buildCameraScreen() {
    return Obx(() {
      return addStoryController.maxVideoDuration.value.isNegative
          ? const SizedBox()
          : Padding(
        padding: const EdgeInsets.all(0),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              bottom: 25,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () async {
                      await addStoryController.pickFile(onlyVideos: true);
                      if(addStoryController.videoFile != null){
                        print("controller.videoFile   ${addStoryController.videoFile}");
                        setState(() {});
                      routeUpload();
                      }
                    },
                    icon: const Icon(
                      Icons.image,
                      color: AppColor.white,
                      size: 30,
                    ),
                  ),
                  GestureDetector(

                    onTap: () async {
                      if (!addStoryController.isRecording.value) {
                        addStoryController.imageFile.value = null;
                        addStoryController.imageUrlController.clear();
                        addStoryController.videoFile.value = null;
                        addStoryController.videoUrlController.clear();
                        addStoryController.videoController.dispose();

                      }
                      else {

                        setState(() {});
                        // Future.delayed(Duration(seconds: 1),() {
                        //   if (controller.videoFile != null) {
                        //     routeUpload();
                        //   }
                        // },);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: addStoryController.isRecording.value ?AppColor.blue:AppColor.white,
                            width: addStoryController.isRecording.value ? 3:1
                          )),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: addStoryController.isRecording.value ?AppColor.blue:AppColor.white,
                        child: addStoryController.isRecording.value == false ? const SizedBox(): const Icon(Icons.stop,size: 35,color: AppColor.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(
                      Icons.close,
                      color: AppColor.white,
                      size: 30,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      );
    });
  }


  void routeUpload() {
    print("controller.videoFile!.path  ${addStoryController.videoFile.value!.path}");
    File file = File(addStoryController.videoFile.value!.path);
    Get.to(() => PostVideoScreen(
      videoFile: file.path,
    ));
  }
}
