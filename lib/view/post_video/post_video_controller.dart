//Holds the state of the application and provides an API to access/filter/manipulate that data.
// Its concern is data encapsulation and management.
// It contains logic to structure, validate or compare different pieces of data that we call Domain Logic.
// Model File : A perfect tool to make Models easily.
// https://app.quicktype.io/

// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:async';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';


class AddStoryController extends GetxController {

    clearData(){
    print("called");
     selectedMediaType.value == '';
     imageFile.value = null;
     videoFile.value = null;
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

  Rx<File?> imageFile = Rx<File?>(null);
  Rx<File?> videoFile = Rx<File?>(null);
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


  Future<void> pickFile({bool onlyVideos = false,bool onlyImage = false,}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: onlyVideos == true ?['mp4', 'mov', 'avi']:onlyImage == true ?['jpg', 'jpeg', 'png']:['jpg', 'jpeg', 'png', 'mp4', 'mov', 'avi'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);

      if (isImage(file)) {
        print("it is image");
        // It's an image
        // setState(() {
          imageFile.value = file;
          videoFile.value = null;
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
          imageFile.value = null;
          videoFile.value = file;
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

  ///Api integration

  RxList userProfileStories = [].obs;

  RxList viewerStories = [].obs;

  RxList homePageStories = [].obs;

  RxList homePagelive = [].obs;


}
