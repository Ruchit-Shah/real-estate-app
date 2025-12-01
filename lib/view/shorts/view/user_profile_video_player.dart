// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../global/app_color.dart';
import '../../../global/app_string.dart';
import '../../dashboard/deshboard_controllers/bottom_bar_controller.dart';
import '../controller/user_profile_controller.dart';
import '../controller/video_controller.dart';


class UserProfileVideos extends StatefulWidget {
  const UserProfileVideos({super.key});

  @override
  State<UserProfileVideos> createState() => _UserProfileVideosState();
}

class _UserProfileVideosState extends State<UserProfileVideos> {
  final userProfileController = Get.find<UserProfileController>();
  final UniqueKey chewieKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    userProfileController.startVideo();
    Get.lazyPut(() => BottomBarController());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(" currentPage >>>>> ${userProfileController.currentPage.value}");
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
        child: VisibilityDetector(
          key: const Key(AppString.profileVideosVisibilityKey),
          onVisibilityChanged: (visibilityInfo) async {

            if (visibilityInfo.visibleFraction > 0.0) {
              print("UserProfileVideos page visible ===> true");

              userProfileController.isUserProfileActive.value = !userProfileController.isUserProfileActive.value;
              if (userProfileController.userVideosDataList.isNotEmpty &&  userProfileController.isUserProfileActive.value) {
                await userProfileController.userVideosDataList[userProfileController.currentPage.value]["controller"]!.play();
              }
            } else {
              print("UserProfileVideos page visible ===> false");
              userProfileController.isUserProfileActive.value = !userProfileController.isUserProfileActive.value;
              if (userProfileController.userVideosDataList.isNotEmpty && !userProfileController.isUserProfileActive.value) {
                await userProfileController.userVideosDataList[userProfileController.currentPage.value]["controller"]!.pause();
              }
            }
          },
          child: Stack(
            children: [
              GetBuilder<UserProfileController>(
                init: UserProfileController(),
                builder: (profileController) {
                  return PageView.builder(
                    controller: profileController.pageController,
                    itemCount: profileController.userVideosDataList.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () async {
                          if (profileController.userVideosDataList[profileController.currentPage.value]["controller"] !=
                              null &&
                              profileController
                                  .userVideosDataList[profileController.currentPage.value]["controller"]!
                                  .value
                                  .isPlaying) {
                            profileController.isPlaying.value = true;
                            Future.delayed(const Duration(milliseconds: 400), () {
                              profileController.isPlaying.value = false;
                            });
                            await profileController.userVideosDataList[profileController.currentPage.value]["controller"]!.pause();
                          } else {
                            profileController.isPlaying.value = true;
                            Future.delayed(const Duration(milliseconds: 400), () {
                              profileController.isPlaying.value = false;
                            });
                            if (profileController.userVideosDataList[profileController.currentPage.value]["controller"]!.value.isInitialized) {
                              await profileController.userVideosDataList[profileController.currentPage.value]["controller"]!.play();
                            }
                          }
                        },
                        child: profileController.userVideosDataList[index]["controller"] != null
                            ? VideoController(
                          fromScreen: AppString.fromMyVideo,
                          videoData: profileController.userVideosDataList[index],
                          controller: profileController.userVideosDataList[index]["controller"]!,
                          indexVideo: index,
                          list: profileController.userVideosDataList,
                        )
                            : Container(
                          height: Get.height,
                          width: Get.width,
                          color: AppColor.black,
                          child: const Center(child: CircularProgressIndicator()),
                        ),
                      );
                    },
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15, right: 15, left: 10),
                child: BackButton(),
              ),
              Center(
                child: userProfileController.isPlaying.value == false
                    ? const SizedBox()
                    : userProfileController.userVideosDataList[userProfileController.currentPage.value]["controller"]!.value.isPlaying
                    ? Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.40),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.play_arrow_sharp,
                    size: 30,
                  ),
                )
                    : Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.40),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.pause,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


