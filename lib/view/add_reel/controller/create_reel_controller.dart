//Holds the state of the application and provides an API to access/filter/manipulate that data.
// Its concern is data encapsulation and management.
// It contains logic to structure, validate or compare different pieces of data that we call Domain Logic.
// Model File : A perfect tool to make Models easily.
// https://app.quicktype.io/

// ignore_for_file: avoid_function_literals_in_foreach_calls, non_constant_identifier_names, unnecessary_null_comparison

import 'dart:async';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

import '../../../global/app_string.dart';
import '../../../global/services/api_shorts_string.dart';
import '../../../global/services/network_http.dart';
import '../../../global/widgets/loading_dialog.dart';
import '../../../utils/common_snackbar.dart';
import '../../all_products/view/related_products/add_related_products_for_video.dart';
import '../../dashboard/deshboard_controllers/bottom_bar_controller.dart';
import '../../shorts/bottom_bar/view/bottom_nav_bar.dart';
import '../../shorts/controller/my_profile_controller.dart';

class CreateReelController extends GetxController {

  clearData(){
    print("called");
     selectedMediaType.value == '';
     imageFile = null;
     videoFile = null;
     isVideoPlaying.value = false;
     isRecording.value = false;
     if(videoController != null) {
       videoController.dispose();
     }
     zoom.value = 1.0;
     scaleFactor.value = 1.0;
     imageUrlController.clear();
     videoUrlController.clear();
  }

  late Future<void> cameraInitializeFuture;

  RxBool isRecording = false.obs;
  RxInt maxVideoDuration = 10.obs;
  late Timer recordingTimer;

    RxDouble zoom = 1.0.obs;
  RxDouble scaleFactor = 1.0.obs;

  TextEditingController imageUrlController = TextEditingController();
  TextEditingController videoUrlController = TextEditingController();

  File? imageFile;
  File? videoFile;
  RxString selectedMediaType = ''.obs;

  late VideoPlayerController videoController;
  RxBool isVideoPlaying = false.obs;

  void playVideo() {
      isVideoPlaying.value = true;
      update();
      videoController.play();
  }

  void pauseVideo() {
      isVideoPlaying.value = false;
      update();
      videoController.pause();
  }

  void saveStory() {
    // Implement the save logic as before
    // ...
  }

  Future<void> pickFile({bool onlyVideos = false}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: onlyVideos == true ?['mp4', 'mov', 'avi']:['jpg', 'jpeg', 'png', 'mp4', 'mov', 'avi'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);

      if (isImage(file)) {
        print("it is image");
        // It's an image
        // setState(() {
          imageFile = file;
          videoFile = null;
          selectedMediaType.value = 'image';
          imageUrlController.text = file.path;
          videoUrlController.clear();

        // });
        update();

      }
      else if (isVideo(file)) {
        print("it is video");
        // It's a video
        // setState(() {
          imageFile = null;
          videoFile = file;
          selectedMediaType.value = 'video';
          videoUrlController.text = file.path;
          imageUrlController.clear();
          videoController = VideoPlayerController.file(file)
            ..initialize().then((_) {
              videoController.setLooping(true);
              // setState(() {
                isVideoPlaying.value = false;
              });
            // });
        // update();
      // });
        update();
      }
    } else {
      // User canceled the picker
    }
  }

  bool isImage(File file) {
    return file.path.toLowerCase().endsWith('.jpg') ||
        file.path.toLowerCase().endsWith('.jpeg') ||
        file.path.toLowerCase().endsWith('.png');
  }

  bool isVideo(File file) {
    return file.path.toLowerCase().endsWith('.mp4') ||
        file.path.toLowerCase().endsWith('.mov') ||
        file.path.toLowerCase().endsWith('.avi');
  }

  ///upload reel
  uploadReel({String? visibility,String? videoCaption, String? city, var thumbnail,var video,}) async {
    try {
      String? City;
   if( Get.find<MyProfileController>().userId.value ==  APIShortsString.admin_id){
    City=city;
   }else{
     SharedPreferences prefs = await SharedPreferences.getInstance();
     City = prefs.getString('user_city');
   }
      showLoadingDialog();
      Get.focusScope!.unfocus();
      XFile? xFileThumbnail;
      XFile? xFileVideo;
      if( thumbnail != null){
        xFileThumbnail =  XFile(thumbnail.path);
      }
      if( video != null){
        xFileVideo =  XFile(Uri.parse(video).path);
      }
      print("user_id-    ${Get.find<MyProfileController>().userId.value}");
      print("visibility -   ${visibility}");
      print("video_caption -   ${videoCaption}");
      print("City -   ${City}");
      print("City -   ${APIShortsString.upload_video}");
      var response = await HttpHandler.formDataMethod(
        url: APIShortsString.upload_video,
        apiMethod: "POST",
        body: {
          "user_id":  Get.find<MyProfileController>().userId.value,
          "visibility": visibility!,
          "video_caption": videoCaption!,
          "city":City!,

        },
        imageListSeprateFile: [
          {"imageKey":"video",
            "filepath":xFileVideo?.path},
          {"imageKey":"thumbnail",
            "filepath":xFileThumbnail?.path},
        ],

      );

      hideLoadingDialog();
      if (response['error'] == null) {

        if(response['body']['status'].toString()=="1"){
          showSnackbar(message: response['body']['msg'].toString());
          print("  :: =====Added Video Response  :: =====\n${response['body']}\n=====  :: =====\n");
          // Get.close(3);
          Get.to(()=>AllRelatedProductForVideo(videoData: response['body']["data"],isFromScreen: AppString.fromReelUpload,))!.whenComplete(() {
            Get.close(2);
          });
        }
        else if(response['body']['status'].toString()=="0") {
          showSnackbar(message: response['body']['msg'].toString());
        }
      } else if (response['error'] != null) {}

    } catch (e, s) {
      hideLoadingDialog();
      showSnackbar(message: "Error");
      debugPrint("upload_video Error -- $e  $s");
    }
  }

  updateReel({String? videoId,String? visibility,String? city,String? videoCaption,var thumbnail}) async {
    try {
      String? City;
      if( Get.find<MyProfileController>().userId.value ==  APIShortsString.admin_id){
        City=city;
      }else{
        SharedPreferences prefs = await SharedPreferences.getInstance();
        City = prefs.getString('user_city');
      }
      showLoadingDialog();
      Get.focusScope!.unfocus();
      XFile? xFileThumbnail;
      if( thumbnail != null){
        xFileThumbnail =  XFile(thumbnail.path);
      }

      print("user_id    ${Get.find<MyProfileController>().userId.value}");
      var response = await HttpHandler.formDataMethod(
        url: APIShortsString.update_video,
        apiMethod: "POST",
        body: {
          "user_id":  Get.find<MyProfileController>().userId.value,
          "video_id": videoId!,
          "visibility": visibility!,
          "video_caption": videoCaption!,
          "city":City!,
        },
        imagePath: xFileThumbnail?.path,
        imageKey: "thumbnail",
      );

      hideLoadingDialog();
      if (response['error'] == null) {

        if(response['body']['status'].toString()=="1"){
          showSnackbar(message: response['body']['msg'].toString());
          print("  :: =====Updated Video Response  :: =====\n${response['body']}\n=====  :: =====\n");
          // Get.to(()=>AllRelatedProductForVideo(videoData: response['body']["data"],isFromScreen: AppString.fromReelUpload,))!.whenComplete(() {
          //   Get.close(3);
          // });
          Get.find<BottomBarController>().selectedBottomIndex.value = 4;
          Get.offAll(()=>  BottomScreen(fromEditReel: true,));
        }
        else if(response['body']['status'].toString()=="0") {
          showSnackbar(message: response['body']['msg'].toString());
        }
      } else if (response['error'] != null) {}

    } catch (e, s) {
      hideLoadingDialog();
      showSnackbar(message: "Error");
      debugPrint("update_video Error -- $e  $s");
    }
  }

}