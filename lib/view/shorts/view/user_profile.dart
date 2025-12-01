
import 'dart:developer';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dashed_circle/dashed_circle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/view/shorts/view/user_profile_video_player.dart';
import '../../../Routes/app_pages.dart';
import '../../../common_widgets/height.dart';
import '../../../global/AppBar.dart';
import '../../../global/app_color.dart';
import '../../../global/app_string.dart';
import '../../../global/services/api_shorts_string.dart';
import '../../../global/theme/app_text_style.dart';
import '../../../utils/common_snackbar.dart';
import '../../post_video/post_video_controller.dart';
import '../../routes/app_pages.dart';
import '../../splash_screen/splash_screen.dart';
import '../controller/follow_controller.dart';
import '../controller/my_profile_controller.dart';
import '../controller/user_profile_controller.dart';

class UserProfileScreen extends StatefulWidget {
  var userData;
  final bool fromStoryView;
  UserProfileScreen({super.key, this.userData, this.fromStoryView = false});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final userProfileController = Get.put(UserProfileController());
  final addStoryController = Get.put(AddStoryController());
  List<Color> colorizeColors = [
    Colors.white,
    Colors.yellow,
    Colors.white,
  ];

  TextStyle colorizeTextStyle = const TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w800,
  );

  @override
  void initState() {
    super.initState();
    getUserDatas();
  }

  getUserDatas() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        print("user_id " + widget.userData["_id"].toString());
        userProfileController.userProfileApi(
          profileId: widget.userData["_id"],

        );

        Future.delayed(
          const Duration(microseconds: 100),
          () {
            userProfileController.userVideosApi(
                isShowMoreCall: false,
                pageNumber: 1,
                profileId: widget.fromStoryView == true
                    ? widget.userData.userId
                    : widget.userData["_id"]);
          },
        );
      },
    );
  }

  getUserStory() {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   addStoryController.getUserStory(
    //       isViewerStory: true,
    //       otherUserId: widget.fromStoryView == true
    //           ? widget.userData.userId
    //           : widget.userData["_id"]);
    // });
  }

  onBackPressed() {
    Get.offAllNamed(Routes.BOTTOM_BAR);
  }

  @override
  Widget build(BuildContext context) {
    // return GetBuilder(
    //   init: MyProfileController(),
    //   builder: (followController) {
    return WillPopScope(
      onWillPop: () => onBackPressed(),
      child: Scaffold(
        backgroundColor: AppColor.white,
        appBar: appBar(titleName: 'Profile', onTap: () => onBackPressed()),
        body: SafeArea(
          child: Obx(() {
            return userProfileController.userProfileData.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      boxH05(),
                      Obx(() {
                        return Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(2),
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: InkWell(
                                  splashColor: AppColor.transparent,
                                  highlightColor: AppColor.transparent,
                                  onTap: () {},
                                  child: Obx(() => userProfileController.userProfileData.isNotEmpty &&
                                          userProfileController.userProfileData[
                                                  'user_data']["profile_image"] !=
                                              null &&
                                          userProfileController.userProfileData['user_data']
                                           ["profile_image"].toString().isNotEmpty
                                      ? ClipOval(
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                APIShortsString.profileImageBaseUrl +
                                                    userProfileController.
                                                    userProfileData['user_data']["profile_image"],
                                            fit: BoxFit.cover,
                                            height: 90,
                                            width: 90,
                                            errorWidget: (context, url, error) {
                                              return Container(
                                                color: AppColor.grey
                                                    .withOpacity(0.2),
                                                child: const Icon(
                                                  Icons.person,
                                                  color: AppColor.grey,
                                                  size: 90,
                                                ),
                                              );
                                            },
                                            placeholder: (context, url) {
                                              return Container(
                                                color: AppColor.grey
                                                    .withOpacity(0.2),
                                                child: const Icon(
                                                  Icons.person,
                                                  color: AppColor.grey,
                                                  size: 90,
                                                ),
                                              );
                                            },
                                          ),
                                        )
                                      : Container(
                                          color: AppColor.grey.withOpacity(0.2),
                                          child: const Icon(
                                            Icons.person,
                                            color: AppColor.grey,
                                            size: 90,
                                          ),
                                        )),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              left: 0,
                              child: userProfileController
                                          .liveStreamData.isNotEmpty &&
                                      userProfileController
                                              .liveStreamData["live_status"] ==
                                          true
                                  ? FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 20),
                                          decoration: const BoxDecoration(
                                            color: AppColor.red,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                          ),
                                          child: AnimatedTextKit(
                                            repeatForever: true,
                                            animatedTexts: [
                                              ColorizeAnimatedText(
                                                'Live',
                                                textStyle: colorizeTextStyle,
                                                colors: colorizeColors,
                                              ),
                                              ColorizeAnimatedText(
                                                'Live',
                                                textStyle: colorizeTextStyle,
                                                colors: colorizeColors,
                                              ),
                                              ColorizeAnimatedText(
                                                'Live',
                                                textStyle: colorizeTextStyle,
                                                colors: colorizeColors,
                                              ),
                                            ],
                                            isRepeatingAnimation: true,
                                            onTap: () {
                                              //print("userProfileController.liveStreamData[agora_token]   ${userProfileController.liveStreamData["agora_token"]}");
                                              showSnackbar(
                                                  message:
                                                      "Please wait to join the live broadcast");
                                            },
                                          )),
                                    )
                                  : const SizedBox(),
                            )
                          ],
                        );
                      }),
                      boxH20(),
                      userProfileController.userProfileData['user_data'] ==
                                  null ||
                              userProfileController
                                  .userProfileData['user_data'].isEmpty ||
                              userProfileController.userProfileData['user_data']
                                      ["full_name"] ==
                                  null ||
                              userProfileController
                                  .userProfileData['user_data']["full_name"].isEmpty
                          ? Text("", style:
                                  AppTextStyle.semiBold.copyWith(fontSize: 20))
                          : Text(
                              userProfileController.userProfileData['user_data']
                                      ["full_name"]
                                  .toString(),
                              style:
                                  AppTextStyle.semiBold.copyWith(fontSize: 20),
                            ),
                      boxH05(),
                      userProfileController.userProfileData['user_data'] == null ||
                      userProfileController.userProfileData['user_data'].isEmpty ||
                      userProfileController.userProfileData['user_data']["username"] == null ||
                      userProfileController.userProfileData['user_data']["username"].isEmpty
                          ? Text("",
                              style: AppTextStyle.regular.copyWith(fontSize: 15))
                          : Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 20),
                              decoration: BoxDecoration(
                                color: Colors.pink.shade50,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                              ),
                              child: Text(
                                '@' +
                                    userProfileController
                                        .userProfileData['user_data']
                                            ["username"]
                                        .toString(),
                                style:
                                    AppTextStyle.regular.copyWith(fontSize: 15),
                              ),
                            ),
                      boxH25(),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Obx(() {
                            return numberColumn(
                                title: "Posts",
                                count: userProfileController
                                            .userProfileData['post_uploaded'] ==
                                        null
                                    ? ""
                                    : "${userProfileController.userProfileData['post_uploaded']}");
                          }),
                          SizedBox(
                              height: 20,
                              child: VerticalDivider(
                                  color: AppColor.grey.shade400)),
                          Obx(
                            () => numberColumn(
                                title: "Followers",
                                count: userProfileController.userProfileData[
                                            'user_followers'] ==
                                        null
                                    ? ""
                                    : "${userProfileController.userProfileData['user_followers']}",
                                onTap: () {
                                  log("User Data:- ${widget.userData}");
                                  Get.toNamed(
                                    Routes.FOLLOWERS_SCREEN,
                                    arguments: {
                                      'user_id': widget.userData["_id"],
                                      // You can pass any data type as parameters
                                    },
                                  );
                                }),
                          ),

                          SizedBox(
                              height: 20,
                              child: VerticalDivider(
                                  color: AppColor.grey.shade400)),
                          Obx(() {
                            return numberColumn(
                                title: "Following",
                                count: userProfileController.userProfileData[
                                            'user_following'] ==
                                        null
                                    ? ""
                                    : "${userProfileController.userProfileData['user_following']}",
                                onTap: () => Get.toNamed(
                                        Routes.FOLLOWINGS_SCREEN,
                                        arguments: {
                                          'user_id': widget.userData["_id"],
                                        }));

                          }),

                        ],
                      ),
                      boxH15(),
                      // InkWell(
                      //   onTap: () {
                      //     if (isLogin == true) {
                      //       if (userProfileController
                      //               .userProfileData['followBack']
                      //               .toString() ==
                      //           "1") {
                      //         Get.find<FollowController>()
                      //             .followUnfollowUpdateList(
                      //                 followId: userProfileController
                      //                     .userProfileData['user_data']["_id"],
                      //                 status: "false");
                      //         userProfileController.userProfileData['followBack'] = "0";
                      //         var followers = userProfileController.userProfileData['user_followers'] - 1;
                      //         userProfileController.userProfileData['user_followers'] = followers.toString();
                      //         setState(() {});
                      //       } else {
                      //         Get.find<FollowController>().followUnfollowUpdateList(followId: userProfileController.userProfileData['user_data']["_id"], status: "true");
                      //         userProfileController.userProfileData['followBack'] = "1";
                      //         int followers = userProfileController.userProfileData['user_followers'] + 1;
                      //         userProfileController.userProfileData['user_followers'] = followers.toString();
                      //         setState(() {});
                      //       }
                      //     } else {
                      //       showSnackbar(message: "Login Required");
                      //     }
                      //   },
                      //   child: Container(
                      //     width: Get.width,
                      //     margin: const EdgeInsets.symmetric(horizontal: 80),
                      //     padding: const EdgeInsets.symmetric(vertical: 10),
                      //     decoration: BoxDecoration(
                      //       color: userProfileController.userProfileData['followBack'].toString() == "1"
                      //           ? AppColor.grey
                      //           : AppColor.blue,
                      //       border: Border.all(
                      //         color: AppColor.grey,
                      //         width: 1,
                      //       ),
                      //       borderRadius:
                      //           const BorderRadius.all(Radius.circular(5)),
                      //     ),
                      //     child: Center(
                      //       child: Text(
                      //         userProfileController.userProfileData['followBack'].toString() == "1"
                      //             ? "Following"
                      //             : "Follow",
                      //         style: AppTextStyle.regular.copyWith(
                      //             color: AppColor.white, fontSize: 20),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      Visibility(
                        visible: Get.find<MyProfileController>().userId.value!= userProfileController.userProfileData['user_data']["_id"],
                        child: InkWell(
                          onTap: () {
                              String userId = userProfileController.userProfileData['user_data']["_id"];
                            if (isLogin == true) {
                              String followBackStatus = userProfileController.userProfileData['followBack'].toString();
                              String userId = userProfileController.userProfileData['user_data']["_id"];

                              if (followBackStatus == "1") {
                                // Unfollow logic
                                Get.find<FollowController>().followUnfollowUpdateList(followId: userId, status: "false");
                                userProfileController.userProfileData['followBack'] = "0";
                                int followers = userProfileController.userProfileData['user_followers'] ?? 0;
                                followers -= 1;
                                userProfileController.userProfileData['user_followers'] = followers;
                                setState(() {});
                              } else {
                                // Follow logic
                                Get.find<FollowController>().followUnfollowUpdateList(followId: userId, status: "true");
                                userProfileController.userProfileData['followBack'] = "1";
                                int followers = userProfileController.userProfileData['user_followers'] ?? 0;
                                followers += 1;
                                userProfileController.userProfileData['user_followers'] = followers;
                                setState(() {});
                              }
                            } else {
                              showSnackbar(message: "Login Required");
                            }
                          },
                          child: Container(
                            width: Get.width,
                            margin: const EdgeInsets.symmetric(horizontal: 80),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: userProfileController.userProfileData['followBack'] == "1"
                                  ? AppColor.grey
                                  : AppColor.blue,
                              border: Border.all(
                                color: AppColor.grey,
                                width: 1,
                              ),
                              borderRadius: const BorderRadius.all(Radius.circular(5)),
                            ),
                            child: Center(
                              child: Text(
                                userProfileController.userProfileData['followBack'] == "1"
                                    ? "Following"
                                    : "Follow",
                                style: AppTextStyle.regular.copyWith(
                                    color: AppColor.white, fontSize: 20),
                              ),
                            ),
                          ),
                        ),
                      ),
                      boxH10(),
                      Expanded(
                          child: Obx(() => userProfileController
                                      .userVideosResponse.isEmpty ||
                                  userProfileController
                                      .userVideosDataList.isEmpty
                              ? const Center(
                                  child: Text('No Search Results Found'))
                              : SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      GridView.builder(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        shrinkWrap: true,
                                        // itemCount: controller.videoItems.length,
                                        itemCount: userProfileController
                                            .userVideosDataList.length,
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 3,
                                                mainAxisSpacing: 2,
                                                crossAxisSpacing: 2),
                                        itemBuilder: (context, index) {
                                          var data = userProfileController
                                              .userVideosDataList[index];
                                          return GestureDetector(
                                            onTap: () {
                                              userProfileController
                                                  .currentPage.value = index;
                                              // Get.toNamed(Routes.PROFILE_VIDEOS_SCREEN)!
                                              // Get.to(() => const ProfileVideos())!
                                              Get.to(() =>
                                                      const UserProfileVideos())!
                                                  .whenComplete(() async {
                                                if (userProfileController
                                                    .userVideosDataList
                                                    .isNotEmpty) {
                                                  userProfileController
                                                      .userVideosDataList[
                                                          userProfileController
                                                              .currentPage
                                                              .value]
                                                          ["controller"]!
                                                      .pause();
                                                }
                                                // data["controller"]!.pause();
                                              });
                                            },
                                            child: Stack(
                                              children: [
                                                Container(
                                                  height: Get.width * 0.3,
                                                  width: Get.width * 0.3,
                                                  decoration: BoxDecoration(
                                                      color: AppColor.grey,
                                                      image: DecorationImage(
                                                          image: NetworkImage(
                                                              "${APIShortsString.thumbnailBaseUrl}${data["video"]["thumbnail"]}"),
                                                          fit: BoxFit.cover)),
                                                ),
                                                Align(
                                                  alignment: Alignment.topRight,
                                                  child: IconButton(
                                                      onPressed: () {
                                                        videoOptions(data);
                                                      },
                                                      icon: CircleAvatar(
                                                        radius: 12,
                                                        backgroundColor:
                                                            AppColor
                                                                .grey.shade100
                                                                .withOpacity(
                                                                    0.3),
                                                        child: const Icon(
                                                          Icons.more_vert,
                                                          color: AppColor.white,
                                                          size: 14,
                                                        ),
                                                      )),
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                      const SizedBox(height: 10),
                                      userProfileController.currentPage
                                                  .toString() ==
                                              userProfileController.lastPage
                                                  .toString()
                                          ? const SizedBox()
                                          : userProfileController
                                                      .isApiCallProcessing
                                                      .value ==
                                                  true
                                              ? const Text(
                                                  "Please wait while loading")
                                              : InkWell(
                                                  onTap: () {
                                                    // controller.searchDataApi(
                                                    //     isShowMoreCall: true,
                                                    //     keyword: controller.searchController.value.text,
                                                    //     pageNumber: controller.nextPage.value);
                                                  },
                                                  child:
                                                      const Text("Show More")),
                                      const SizedBox(height: 40)
                                    ],
                                  ),
                                ))),
                      boxH02(),
                    ],
                  );
          }),
        ),
      ),
    );
    // },);
  }

  void videoOptions(data) {
    Get.dialog(
      Material(
          color: AppColor.transparent,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Container(
              width: Get.width * 0.75,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
              decoration: const BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppString.options.capitalize!,
                        style: AppTextStyle.bold.copyWith(fontSize: 18),
                      ),
                      IconButton(
                          padding: const EdgeInsets.only(right: 10),
                          onPressed: () => Get.back(),
                          icon: const Icon(Icons.close)),
                    ],
                  ),
                  boxH10(),
                ],
              ),
            ),
          )),
    );
  }

  btn({IconData? icon, String? title, void Function()? onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: Get.width,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
              color: AppColor.grey.shade400.withOpacity(0.5),
              borderRadius: const BorderRadius.all(Radius.circular(8))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
              ),
              icon == null ? const SizedBox() : boxW05(),
              Text(
                title!,
                style: AppTextStyle.regular.copyWith(
                    color: AppColor.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }

  numberColumn({String? title, String? count, void Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title!,
            style: AppTextStyle.regular.copyWith(
              fontSize: 14,
            ),
          ),
          boxH10(),
          Text(
            count!,
            style: AppTextStyle.medium.copyWith(
              fontSize: 22,
            ),
          ),
        ],
      ),
    );
  }
}

/// houzza project user profile don't delete it
// class UserProfileScreen extends StatefulWidget {
//   var userData;
//   final bool fromStoryView;
//   UserProfileScreen({super.key, this.userData, this.fromStoryView = false});
//
//   @override
//   State<UserProfileScreen> createState() => _UserProfileScreenState();
// }
//
// class _UserProfileScreenState extends State<UserProfileScreen> {
//   final userProfileController = Get.put(UserProfileController());
//   //final addStoryController = Get.put(AddStoryController());
//
//   List<Color> colorizeColors = [
//     Colors.white,
//     Colors.yellow,
//     Colors.white,
//   ];
//
//   TextStyle colorizeTextStyle = const TextStyle(
//     fontSize: 16.0,
//     fontWeight: FontWeight.w800,
//   );
//
//   @override
//   void initState() {
//     super.initState();
//     getUserDatas();
//     // if (isLogin == true) {
//     // getUserStory();}
//   }
//
//   // getUserDatas() {
//   //   // print(widget.userData["_id"]);
//   //   WidgetsBinding.instance.addPostFrameCallback(
//   //     (_) {
//   //       userProfileController.userProfileApi(
//   //           // profileId:
//   //           // widget.fromStoryView == true
//   //           //     ? widget.userData.userId  :
//   //           //      widget.userData["_id"],
//   //              profileId: widget.userData["_id"],
//   //
//   //       );
//   //
//   //       Future.delayed(
//   //         const Duration(microseconds: 100),
//   //         () {
//   //           userProfileController.userVideosApi(
//   //               isShowMoreCall: false,
//   //               pageNumber: 1,
//   //               profileId: widget.userData.userId);
//   //               // widget. == true
//   //               //     ? widget.userData.userId
//   //               //     : widget.userData["_id"]);
//   //         },
//   //       );
//   //     },
//   //   );
//   // }
//     getUserDatas() {
//     WidgetsBinding.instance.addPostFrameCallback(
//           (_) {
//         userProfileController.userProfileApi(
//
//           // widget.fromStoryView == true
//           //     ? widget.userData.userId
//           profileId: widget.userData["_id"],
//         );
//
//         Future.delayed(
//           const Duration(microseconds: 100),
//               () {
//             userProfileController.userVideosApi(
//                 isShowMoreCall: false,
//                 pageNumber: 1,
//                 profileId: widget.fromStoryView == true
//                     ? widget.userData.userId
//                     : widget.userData["_id"]);
//           },
//         );
//       },
//     );
//   }
//
//   // getUserStory() {
//   // }
//
//   onBackPressed() {
//     Get.offAllNamed(Routes.BOTTOM_BAR);
//     // Get.offAndToNamed(Routes.BOTTOM_BAR);
//     // Get.back();
//     // Navigator.of(context).pop();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // return GetBuilder(
//     //   init: MyProfileController(),
//     //   builder: (followController) {
//     return WillPopScope(
//       onWillPop: () =>onBackPressed(),
//       child: Scaffold(
//         backgroundColor: AppColor.white,
//         appBar: appBar(titleName: 'Profile',onTap:()=> onBackPressed()),
//         body: SafeArea(
//           child: Obx(() {
//             return userProfileController.userProfileData.isEmpty
//                 ? const Center(child: CircularProgressIndicator())
//                 : Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       boxH05(),
//                       Obx(() {
//                         return Stack(
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.all(2),
//                               child: Padding(
//                                 padding: const EdgeInsets.all(6.0),
//                                 child: InkWell(
//                                   splashColor: AppColor.transparent,
//                                   highlightColor: AppColor.transparent,
//                                   onTap: () {
//                                     // if (addStoryController.viewerStories.isNotEmpty) {
//                                     //   // Get.to(() => SingleUserStoryScreen(
//                                     //   //       fromMyProfile: false,
//                                     //   //       userData: {
//                                     //   //         "user_name": userProfileController.userProfileData['user_data']["username"],
//                                     //   //         "image": userProfileController.userProfileData['user_data']["image"]
//                                     //   //       },
//                                     //   //     ));
//                                     // } else {
//                                     // }
//                                   },
//                                   child: Obx(() => userProfileController.userProfileData.isNotEmpty &&
//                                           userProfileController.userProfileData['user_data']["image"] != null &&
//                                           userProfileController.userProfileData['user_data']["image"].isNotEmpty
//                                       ? ClipOval(
//                                           child: CachedNetworkImage(
//                                             imageUrl: APIShortsString.profileImageBaseUrl +
//                                                 userProfileController.userProfileData['user_data']["image"],
//                                             fit: BoxFit.cover,
//                                             height: 90,
//                                             width: 90,
//                                             errorWidget: (context, url, error) {
//                                               return Container(
//                                                 color: AppColor.grey.withOpacity(0.2),
//                                                 child: const Icon(
//                                                   Icons.person,
//                                                   color: AppColor.grey,
//                                                   size: 90,
//                                                 ),
//                                               );
//                                             },
//                                             placeholder: (context, url) {
//                                               return Container(
//                                                 color: AppColor.grey.withOpacity(0.2),
//                                                 child: const Icon(
//                                                   Icons.person,
//                                                   color: AppColor.grey,
//                                                   size: 90,
//                                                 ),
//                                               );
//                                             },
//                                           ),
//                                         )
//                                       : Container(
//                                           color: AppColor.grey.withOpacity(0.2),
//                                           child: const Icon(
//                                             Icons.person,
//                                             color: AppColor.grey,
//                                             size: 90,
//                                           ),
//                                         )
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Positioned(
//                               bottom: 0,right: 0,left: 0,
//                               child: userProfileController.liveStreamData.isNotEmpty && userProfileController.liveStreamData["live_status"] == true
//                                 ?FittedBox(
//                                 fit: BoxFit.scaleDown,
//                                 child: Container(
//                                   padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 20),
//                                   decoration: const BoxDecoration(
//                                       color: AppColor.red,
//                                       borderRadius: BorderRadius.all(Radius.circular(5)),
//                                   ),
//                                   child: AnimatedTextKit(
//                                     repeatForever: true,
//                                     animatedTexts: [
//                                       ColorizeAnimatedText(
//                                         'Live',
//                                         textStyle: colorizeTextStyle,
//                                         colors: colorizeColors,
//                                       ),
//                                       ColorizeAnimatedText(
//                                         'Live',
//                                         textStyle: colorizeTextStyle,
//                                         colors: colorizeColors,
//                                       ),
//                                       ColorizeAnimatedText(
//                                         'Live',
//                                         textStyle: colorizeTextStyle,
//                                         colors: colorizeColors,
//                                       ),
//                                     ],
//                                     isRepeatingAnimation: true,
//                                     onTap: () {
//                                       // print("userProfileController.liveStreamData[agora_token]   ${userProfileController.liveStreamData["agora_token"]}");
//                                       // Get.to(()=>LiveScreen(isBroadcaster: false,
//                                       // token: userProfileController.liveStreamData["agora_token"],
//                                       //   appId: appId,
//                                       //   channelName: userProfileController.liveStreamData["channel_name"],
//                                       //   username: userProfileController.userProfileData['user_data']["username"],
//                                       // ));
//                                       // showSnackbar(message: "Please wait to join the live broadcast");
//                                     },
//                                   )),
//                                 )
//                                 :const SizedBox(),)
//                           ],
//                         );
//                       }),
//                       boxH20(),
//                       userProfileController.userProfileData['user_data'] == null ||
//                               userProfileController.userProfileData['user_data'].isEmpty ||
//                               userProfileController.userProfileData['user_data']["name"] == null ||
//                               userProfileController.userProfileData['user_data']["name"].isEmpty
//                           ? Text("", style: AppTextStyle.semiBold.copyWith(fontSize: 20))
//                           : Text(userProfileController.userProfileData['user_data']["name"].toString(),
//                               style: AppTextStyle.semiBold.copyWith(fontSize: 20),
//                             ),
//                       boxH05(),
//
//                       userProfileController.userProfileData['user_data'] == null ||
//                               userProfileController.userProfileData['user_data'].isEmpty ||
//                               userProfileController.userProfileData['user_data']["username"] == null ||
//                               userProfileController.userProfileData['user_data']["username"].isEmpty
//                           ? Text("", style: AppTextStyle.regular.copyWith(fontSize: 15))
//                           : Container(
//                         padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 20),
//                         decoration: BoxDecoration(
//                           color: Colors.pink.shade50,
//                           borderRadius: const BorderRadius.all(Radius.circular(5)),
//                         ),
//                             child: Text('@'+userProfileController.userProfileData['user_data']["username"].toString()  ,
//                                 style: AppTextStyle.regular.copyWith(fontSize: 15),),
//                           ),
//                       boxH25(),
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           Obx(() {
//                             return numberColumn(
//                                 title: "Posts",
//                                 count: userProfileController.userProfileData['post_uploaded'] == null
//                                     ? ""
//                                     : "${userProfileController.userProfileData['post_uploaded']}");
//                           }),
//                           SizedBox(
//                               height: 20,
//                               child:
//                                   VerticalDivider(color: AppColor.grey.shade400)),
//                           Obx(() {
//                             return numberColumn(
//                                 title: "Followers",
//                                 count: userProfileController.userProfileData['user_followers'] == null
//                                     ? ""
//                                     : "${userProfileController.userProfileData['user_followers']}",
//                                 onTap: () => Get.toNamed(Routes.FOLLOWERS_SCREEN,arguments: {
//                                   'user_id': widget.userData["_id"],
//                                   // You can pass any data type as parameters
//                                 },));
//                           }),
//                           SizedBox(
//                               height: 20,
//                               child:
//                                   VerticalDivider(color: AppColor.grey.shade400)),
//                           Obx(() {
//                             return numberColumn(
//                             title: "Following",
//                                 count: userProfileController.userProfileData['user_following'] == null ? ""
//                                     : "${userProfileController.userProfileData['user_following']}",
//                                 onTap: () =>
//                                     Get.toNamed(Routes.FOLLOWINGS_SCREEN, arguments: {
//                                      'user_id': widget.userData["_id"],
//                                     // You can pass any data type as parameters
//                                     }));
//                           }),
//                         ],
//                       ),
//                       boxH15(),
//                       InkWell(
//                         onTap: () {
//                       if (isLogin == true) {
//                           if (userProfileController.userProfileData['followBack'].toString() == "1") {
//                             Get.find<FollowController>().followUnfollowUpdateList(
//                                 followId: userProfileController
//                                     .userProfileData['user_data']["_id"], status: "false");
//                             userProfileController.userProfileData['followBack'] = "0";
//                             int followers= userProfileController.userProfileData['user_followers']-1;
//                             userProfileController.userProfileData['user_followers']=followers.toString();
//                             setState(() {});
//                           } else {
//                             Get.find<FollowController>().followUnfollowUpdateList(
//                                 followId: userProfileController.userProfileData['user_data']["_id"],
//                                 status: "true");
//                             userProfileController.userProfileData['followBack'] = "1";
//                             int followers= userProfileController.userProfileData['user_followers']+1;
//                             userProfileController.userProfileData['user_followers']=followers.toString();
//                             setState(() {});
//                           }}else{
//                         showSnackbar(message: "Login Required");
//                       }
//                         },
//                         child: Container(
//                           width: Get.width,
//                           margin: const EdgeInsets.symmetric(horizontal: 80),
//                           padding: const EdgeInsets.symmetric(vertical: 10),
//                           decoration: BoxDecoration(
//                               color: userProfileController.userProfileData['followBack'].toString() == "1"
//                                   ? AppColor.grey
//                                   : AppColor.blue,
//                               border: Border.all(color: AppColor.grey, width: 1,),
//                             borderRadius: const BorderRadius.all(Radius.circular(5)),
//                           ),
//
//                           child: Center(
//                             child: Text(
//                               userProfileController.userProfileData['followBack'].toString() == "1"
//                                   ? "Following"
//                                   : "Follow",
//                               style: AppTextStyle.regular.copyWith(
//                                   color: AppColor.white,
//                                   fontSize: 20),
//                             ),
//                           ),
//                         ),
//                       ),
//                       boxH10(),
//                       Expanded(
//                           child: Obx(() => userProfileController.userVideosResponse.isEmpty ||
//                                   userProfileController.userVideosDataList.isEmpty
//                               ? const Center(
//                                   child: Text('No Search Results Found'))
//                               : SingleChildScrollView(
//                                   child: Column(
//                                     children: [
//                                       Obx(() =>  GridView.builder(
//                                         padding: const EdgeInsets.symmetric(
//                                             horizontal: 5),
//                                         shrinkWrap: true,
//                                         // itemCount: controller.videoItems.length,
//                                         itemCount: userProfileController
//                                             .userVideosDataList.length,
//                                         gridDelegate:
//                                         const SliverGridDelegateWithFixedCrossAxisCount(
//                                             crossAxisCount: 3,
//                                             mainAxisSpacing: 2,
//                                             crossAxisSpacing: 2),
//                                         itemBuilder: (context, index) {
//                                           var data = userProfileController.userVideosDataList[index];
//                                           return GestureDetector(
//                                             onTap: () {
//
//                                               userProfileController
//                                                   .currentPage.value = index;
//                                               // Get.toNamed(Routes.PROFILE_VIDEOS_SCREEN)!
//                                               // Get.to(() => const ProfileVideos())!
//                                               Get.to(() =>
//                                               const UserProfileVideos())!
//                                                   .whenComplete(() async {
//                                                 if (userProfileController
//                                                     .userVideosDataList
//                                                     .isNotEmpty) {
//                                                   userProfileController
//                                                       .userVideosDataList[
//                                                   userProfileController
//                                                       .currentPage.value]
//                                                   ["controller"]!
//                                                       .pause();
//                                                 }
//                                                 // data["controller"]!.pause();
//                                               });
//                                             },
//                                             child: Stack(
//                                               children: [
//                                                 Container(
//                                                   height: Get.width * 0.3,
//                                                   width: Get.width * 0.3,
//                                                   decoration: BoxDecoration(
//                                                       color: AppColor.grey,
//                                                       image: DecorationImage(
//                                                           image: NetworkImage(
//                                                               "${APIShortsString.thumbnailBaseUrl}${data["video"]["thumbnail"]}"),
//                                                           fit: BoxFit.cover)),
//                                                 ),
//                                                 Align(
//                                                   alignment: Alignment.topRight,
//                                                   child: IconButton(
//                                                       onPressed: () {
//                                                         videoOptions(data);
//                                                       },
//                                                       icon: CircleAvatar(
//                                                         radius: 12,
//                                                         backgroundColor: AppColor
//                                                             .grey.shade100
//                                                             .withOpacity(0.3),
//                                                         child: const Icon(
//                                                           Icons.more_vert,
//                                                           color: AppColor.white,
//                                                           size: 14,
//                                                         ),
//                                                       )),
//                                                 )
//                                               ],
//                                             ),
//                                           );
//                                         },
//                                       ),),
//                                       const SizedBox(height: 10),
//                                       userProfileController.currentPage
//                                                   .toString() ==
//                                               userProfileController.lastPage
//                                                   .toString()
//                                           ? const SizedBox()
//                                           : userProfileController
//                                                       .isApiCallProcessing
//                                                       .value ==
//                                                   true
//                                               ? const Text(
//                                                   "Please wait while loading")
//                                               : InkWell(
//                                                   onTap: () {
//                                                     // controller.searchDataApi(
//                                                     //     isShowMoreCall: true,
//                                                     //     keyword: controller.searchController.value.text,
//                                                     //     pageNumber: controller.nextPage.value);
//                                                   },
//                                                   child: const Text("Show More")),
//                                       const SizedBox(height: 40)
//                                     ],
//                                   ),
//                                 ))),
//                       boxH02(),
//                     ],
//                   );
//           }),
//         ),
//       ),
//     );
//     // },);
//   }
//
//   void videoOptions(data) {
//     Get.dialog(
//       Material(
//           color: AppColor.transparent,
//           child: FittedBox(
//             fit: BoxFit.scaleDown,
//             child: Container(
//               width: Get.width * 0.75,
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
//               decoration: const BoxDecoration(
//                   color: AppColor.white,
//                   borderRadius: BorderRadius.all(Radius.circular(10))),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         AppString.options.capitalize!,
//                         style: AppTextStyle.bold.copyWith(fontSize: 18),
//                       ),
//                       IconButton(
//                           padding: const EdgeInsets.only(right: 10),
//                           onPressed: () => Get.back(),
//                           icon: const Icon(Icons.close)),
//                     ],
//                   ),
//                   boxH10(),
//                   GestureDetector(
//                     onTap: () {
//                       Get.dialog(FileDownload(videoUrl: "${APIShortsString.videoBaseUrl}${data["video"]["video"]}",fileName: data["video"]["video"],backTime: 2));
//                     },
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 10, vertical: 10),
//                       decoration: BoxDecoration(
//                           color: AppColor.orange.withOpacity(0.3),
//                           borderRadius: BorderRadius.circular(8)),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           const Icon(Icons.download, size: 14),
//                           boxW20(),
//                           Text(
//                             AppString.downloadVideo.capitalize!,
//                             style: AppTextStyle.bold.copyWith(fontSize: 14),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                   boxH10(),
//
//                   // boxH10(),
//                 ],
//               ),
//             ),
//           )),
//     );
//   }
//
//   btn({IconData? icon, String? title, void Function()? onTap}) {
//     return Expanded(
//       child: GestureDetector(
//         onTap: onTap,
//         child: Container(
//           width: Get.width,
//           padding: const EdgeInsets.symmetric(vertical: 10),
//           decoration: BoxDecoration(
//               color: AppColor.grey.shade400.withOpacity(0.5),
//               borderRadius: const BorderRadius.all(Radius.circular(8))),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(
//                 icon,
//                 size: 16,
//               ),
//               icon == null ? const SizedBox() : boxW05(),
//               Text(
//                 title!,
//                 style: AppTextStyle.regular.copyWith(
//                     color: AppColor.black,
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   numberColumn({String? title, String? count, void Function()? onTap}) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Text(
//             title!,
//             style: AppTextStyle.regular.copyWith(
//               fontSize: 14,
//             ),
//           ),
//           boxH10(),
//           Text(
//             count!,
//             style: AppTextStyle.medium.copyWith(
//               fontSize: 22,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
