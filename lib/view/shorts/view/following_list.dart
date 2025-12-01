import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/global/app_color.dart';
import 'package:real_estate_app/view/shorts/view/user_profile.dart';

import '../../../common_widgets/height.dart';
import '../../../global/AppBar.dart';
import '../../../global/api_string.dart';
import '../../../global/theme/app_text_style.dart';
import '../controller/follow_controller.dart';
import '../controller/my_profile_controller.dart';

class FollowingsScreen extends StatefulWidget {
  const FollowingsScreen({super.key});

  @override
  State<FollowingsScreen> createState() => _FollowingsScreenState();
}

class _FollowingsScreenState extends State<FollowingsScreen> {
  final followController = Get.find<FollowController>();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> params = Get.arguments;
    String user_id = params['user_id'];

    followController.getFollowingList(
        pageNumber: followController.currentFollowingPage.value,
        user_id: user_id);

    scrollController.addListener(() async {
      if (scrollController.position.maxScrollExtent ==
          scrollController.position.pixels) {
        if (followController.currentFollowingPage.value <
            followController.lastFollowingPage.value) {
          // followController.currentFollowingPage.value = followController.currentFollowingPage.value + 1;

          followController.getFollowingList(
              isShowMoreCall: true,
              pageNumber: followController.currentFollowingPage.value + 1,
              user_id: user_id);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: appBar(titleName: 'Followings'),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              String currentUserId =
                  Get.find<MyProfileController>().userId.value;
              var filteredFollowingList = followController.followingList
                  .where((data) => data["_id"] != currentUserId)
                  .toList();

              // return followController.followingList.isNotEmpty
              return filteredFollowingList.isNotEmpty
                  ? ListView.builder(
                      controller: scrollController,
                    //  itemCount: followController.followingList.length,
                itemCount: filteredFollowingList.length,
                      itemBuilder: (context, index) {
                        var data = followController.followingList[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 15),
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  //Get.toNamed(Routes.USER_PROFILE_SCREEN);
                                  Get.to(UserProfileScreen(
                                    userData: data,
                                  ));
                                },
                                highlightColor: AppColor.transparent,
                                splashColor: AppColor.transparent,
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 25,
                                      backgroundColor: AppColor.grey.shade300,
                                      child: ClipOval(
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              "${APIString.profileImageBaseUrl}${data["profile_image"]}",
                                          fit: BoxFit.fill,
                                          height: 60,
                                          width: 60,
                                          placeholder: (context, url) =>
                                              const Icon(Icons.person),
                                          errorWidget: (context, url, error) =>
                                              const Icon(
                                            Icons.person,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                    boxW10(),
                                    SizedBox(
                                      width: Get.width * 0.35,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${data["username"]}",
                                            style: AppTextStyle.medium
                                                .copyWith(fontSize: 16),
                                          ),
                                          boxH02(),
                                          Text(
                                            "${data["full_name"]}",
                                            style: AppTextStyle.regular
                                                .copyWith(
                                                    color: AppColor.grey,
                                                    fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                    InkWell(
                                      onTap: () {
                                        log("btn");
                                        updateFollowStatus(data);

                                        // followController.followUnfollowUpdateList(
                                        //     status: "", followId: "${data["_id"]}");
                                      },
                                      highlightColor: AppColor.transparent,
                                      splashColor: AppColor.transparent,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 15),
                                        decoration: BoxDecoration(
                                            color: AppColor.grey.shade400
                                                .withOpacity(0.5),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(8))),
                                        child: Center(
                                            child: Text(
                                          "Following",
                                          style: AppTextStyle.regular.copyWith(
                                              color: AppColor.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        )),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              index == 11
                                  ? boxH15()
                                  : Divider(
                                      color: AppColor.grey.shade300,
                                      thickness: 0.5,
                                    )
                            ],
                          ),
                        );
                      },
                    )
                  : SizedBox();
            }),
          )
        ],
      ),
    );
  }

  updateFollowStatus(data) {
    print("data ---..>  ${data}");
    if (data["is_following"] == "1") {
      Get.find<FollowController>().followUnfollowUpdateList(
          followId: data["user_data"]["_id"], status: "false");
      data["is_following"] = "false";
    } else {
      Get.find<FollowController>().followUnfollowUpdateList(
          followId: data["user_data"]["_id"], status: "true");
      data["is_following"] = "true";
    }
  }
}
