// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../../global/app_color.dart';
import '../../../global/app_string.dart';
import '../controller/profile_videos_controller.dart';
import '../controller/video_controller.dart';

class ProfileVideos extends StatefulWidget {
  const ProfileVideos({super.key});

  @override
  State<ProfileVideos> createState() => _ProfileVideosState();
}

class _ProfileVideosState extends State<ProfileVideos> {
  VideoPlayerController? videoPlayerController;


  final controller = Get.find<ProfileVideosController>();
  final UniqueKey chewieKey = UniqueKey();
  @override
  void initState() {
    super.initState();
    controller.onInit();
    controller.startVideo();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(" currentPage >>>>> ${controller.currentPage.value}");
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
          child: Stack(
            children: [
              GetBuilder<ProfileVideosController>(
                init: ProfileVideosController(),
                builder: (profileController) {
                  return PageView.builder(
                    controller: profileController.pageController,
                    itemCount: profileController.myVideosDataList.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          onTap: () async {
                            if (profileController.myVideosDataList[profileController.currentPage.value]["controller"] != null &&
                                profileController.myVideosDataList[profileController.currentPage.value]["controller"]!.value.isPlaying) {
                              profileController.isPlaying.value = true;
                              Future.delayed(const Duration(milliseconds: 400),
                                  () {
                                profileController.isPlaying.value = false;
                                // setState(() {});
                              });
                              await profileController.myVideosDataList[profileController.currentPage.value]["controller"]!.pause();
                            } else {
                              profileController.isPlaying.value = true;
                              Future.delayed(const Duration(milliseconds: 400),
                                  () {
                                profileController.isPlaying.value = false;
                              });
                              if (profileController
                                  .myVideosDataList[profileController
                                      .currentPage.value]["controller"]!
                                  .value
                                  .isInitialized) {
                                await profileController.myVideosDataList[profileController.currentPage.value]["controller"]!.play();

                                ///don't remove this line
                                 profileController.initializeVideoController(profileController.currentPage.value + 1); // Initialize the next video
                              }
                            }
                          },
                          child: profileController.myVideosDataList[index]["controller"] != null
                              ? VideoController(
                            fromScreen: AppString.fromMyVideo,
                                  videoData: profileController.myVideosDataList[index],
                                  controller: profileController.myVideosDataList[index]["controller"]!,
                                  indexVideo: index,
                                  list: profileController.myVideosDataList,
                                )
                              : Container(
                                  height: Get.height,
                                  width: Get.width,
                                  color: AppColor.black,
                                  child: const Center(
                                      child: CircularProgressIndicator()),
                                ));
                    },
                  );
                },
              ),

              const Padding(
                padding: EdgeInsets.only(top: 15, right: 15, left: 10),
                child: BackButton(),
              ),
              Center(
                child: controller.isPlaying.value == false
                    ? const SizedBox()
                    : controller.videoItems[controller.currentPage.value].controller!.value.isPlaying
                        ? Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.40),
                                shape: BoxShape.circle),
                            child: const Icon(
                              Icons.play_arrow_sharp,
                              size: 30,
                            ),
                          )
                        : Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.40),
                                shape: BoxShape.circle),
                            child: const Icon(
                              Icons.pause,
                              size: 30,
                            ),
                          ),
              ),
              // Other UI elements
            ],
          ),
        ),
      // ),
    );
  }
}
