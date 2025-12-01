import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/view/post_video/post_video.dart';
import 'package:real_estate_app/view/post_video/post_video_controller.dart';

class upload_video_screen extends StatefulWidget {
  const upload_video_screen({super.key});

  @override
  State<upload_video_screen> createState() => _upload_video_screenState();
}

class _upload_video_screenState extends State<upload_video_screen> {
  final addStoryController = Get.find<AddStoryController>();
  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      body:  Center(
        child: ElevatedButton(
          onPressed: () async {
            await addStoryController.pickFile(onlyVideos: true);
            if (addStoryController.videoFile != null) {
              print("controller.videoFile   ${addStoryController.videoFile}");
              setState(() {});
              routeUpload();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            padding: EdgeInsets.symmetric(horizontal: 13, vertical: 5),
          ),
          child: Text(
            'Upload Video',
            style: TextStyle(fontSize: 15,color: Colors.white),
          ),
        ),
      ),
    );
  }
  void routeUpload() {
    print("controller.videoFile!.path  ${addStoryController.videoFile.value!.path}");
    File file = File(addStoryController.videoFile.value!.path);
    Get.to(() => PostVideoScreen(
      videoFile: file.path,
    ));
  }
}
