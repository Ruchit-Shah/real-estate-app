import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/view/shorts/controller/profile_videos_controller.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../Routes/app_pages.dart';
import '../../../common_widgets/height.dart';
import '../../../global/app_asset.dart';
import '../../../global/app_color.dart';
import '../../../global/app_string.dart';
import '../../../global/services/api_shorts_string.dart';
import '../../../global/theme/app_text_style.dart';
import '../../../global/widgets/common_textfield.dart';
import '../../../utils/common_snackbar.dart';
import '../../dashboard/deshboard_controllers/bottom_bar_controller.dart';
import '../../look_book/view/look_book_view.dart';
import '../../routes/app_pages.dart';
import '../../splash_screen/splash_screen.dart';
import '../view/required_login.dart';
import '../view/user_profile.dart';
import 'follow_controller.dart';
import 'home_controller.dart';
import 'my_profile_controller.dart';


class VideoController extends StatefulWidget {
  final VideoPlayerController controller;
  final List list;
  final int indexVideo;
  var videoData;
  String fromScreen;
  //AppString.fromTrendingVideo , AppString.fromFollowingVideo , AppString.fromMyVideo

  VideoController({
    super.key,
    required this.controller,
    required this.list,
    required this.indexVideo,
    required this.videoData,
    required this.fromScreen,
  });

  @override
  State<VideoController> createState() => _VideoController();
}

class _VideoController extends State<VideoController> {
  final profileVideosController = Get.find<ProfileVideosController>();
  final homeController = Get.find<HomeController>();
  final bottomBarController = Get.find<BottomBarController>();

  @override
  Widget build(BuildContext context) {
    // debugPrint("videoData   ${widget.videoData}");
    return VisibilityDetector(
      key: const Key(AppString.profileVideosVisibilityKey),
      onVisibilityChanged: (visibilityInfo) async {
        if (visibilityInfo.visibleFraction < 0.8)
        {
          widget.controller.pause();
      }
        if (visibilityInfo.visibleFraction > 0.0) {
          print("profile screen is visible ");
profileVideosController.isProfileVideoActive.value = !profileVideosController.isProfileVideoActive.value;
          if (profileVideosController.myVideosDataList.isNotEmpty && profileVideosController.isProfileVideoActive.value) {
             profileVideosController.myVideosDataList[profileVideosController.currentPage.value]["controller"]!.play();

            widget.controller.play();

          }
        } else {
          // print("profile screen is invisible  ");

          if (profileVideosController.myVideosDataList.isNotEmpty   ) {
             profileVideosController.myVideosDataList[profileVideosController.currentPage.value]["controller"]!.pause();
            widget.controller.pause();
             print("profile screen is invisible ");
          }
        }
      },
      child: WillPopScope(
        onWillPop: () async {
          print("length of videos list : "+profileVideosController.myVideosDataList.length.toString());
          // widget.controller.dispose();
          return true;
        },
        child: Stack(
          children: [
            // widget.controller.value.isInitialized ? VideoPlayer(widget.controller)
            //     : const Center(child: CircularProgressIndicator()),
            widget.controller.value.isInitialized ?  SizedBox(
              width: 1080,
              height: 1920,
              child: AspectRatio(
                aspectRatio: 9 / 16,
                child: VideoPlayer(widget.controller),
              ),
            )
                : const Center(child: CircularProgressIndicator()),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: isLogin == true
                      ? const SizedBox()
                      : TextButton(
                      onPressed: () {
                        homeController.homeVideosDataList[homeController.currentPage.value]["controller"]!.pause();
                        Get.toNamed(Routes.login)!.whenComplete(() {
                          bottomBarController.selectedBottomIndex.value = 0;
                          homeController.homeVideosDataList[homeController
                              .currentPage.value]["controller"]!.play();
                        });
                      },
                      child: Text(
                        'Login',
                        style: AppTextStyle.regular
                            .copyWith(color: AppColor.white),
                      )),
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Column(
                      children: [
                     
                        Icon(
                            Icons.remove_red_eye,
                            size: 30,
                            color: AppColor.white
                        ),
                        Text(
                          widget.list[widget.indexVideo]["views"].toString(),
                          style: AppTextStyle.regular.copyWith(
                            fontSize: 12,
                            color: AppColor.white,
                          ),
                        ),
                        boxH20(),
                        Obx(() {
                          return InkWell(
                              onTap: () => applyLoginCheck(() {
                                print("isLogin");
                                print("like button pressed...");
                                print("${widget.list[widget.indexVideo]["self_like"]}");
                                if (widget.list[widget.indexVideo]
                                ["self_like"] ==
                                    null ||
                                    widget.list[widget.indexVideo]
                                    ["self_like"] ==
                                        "0") {
                                  profileVideosController.videoLikeApi(
                                      likeStatus: "1",
                                      index: widget.indexVideo,
                                      list: widget.list,
                                      videoId:
                                      widget.list[widget.indexVideo]
                                      ["video"]["_id"]);
                                  widget.list[widget.indexVideo]
                                  ["self_like"] = "1";
                                  widget.list[widget.indexVideo]
                                  ["likes"] = int.parse(widget
                                      .list[widget.indexVideo]["likes"]
                                      .toString()) +
                                      1;
                                } else if (widget.list[widget.indexVideo]
                                ["self_like"] ==
                                    "1") {
                                  profileVideosController.videoLikeApi(
                                      likeStatus: "0",
                                      index: widget.indexVideo,
                                      list: widget.list,
                                      videoId:
                                      widget.list[widget.indexVideo]
                                      ["video"]["_id"]);
                                  widget.list[widget.indexVideo]
                                  ["self_like"] = "0";
                                  widget.list[widget.indexVideo]
                                  ["likes"] = int.parse(widget
                                      .list[widget.indexVideo]["likes"]
                                      .toString()) -
                                      1;
                                }
                                setState(() {});
                              }),
                              child: Icon(
                                widget.list[widget.indexVideo]["self_like"] ==
                                    "0"
                                    ? Icons.favorite_outline
                                    : Icons.favorite,
                                size: 30,
                                color: widget.list[widget.indexVideo]
                                ["self_like"] ==
                                    "0"
                                    ? AppColor.white
                                    : Colors.red,
                              ));
                        }),
                        Text(
                          '${widget.list[widget.indexVideo]["likes"]}',
                          style: AppTextStyle.regular.copyWith(
                            fontSize: 12,
                            color: AppColor.white,
                          ),
                        ),
                        boxH20(),
                        GestureDetector(
                          onTap: () =>
                              applyLoginCheck(() {
                                print("isLogin");
                                widget.controller.pause();
                                commentBottomsheet(context)
                                    .whenComplete(() {
                                  widget.controller.play();
                                });
                              }),
                          child: const Icon(
                            Icons.comment_rounded,
                            size: 30,
                            color: AppColor.white,
                          ),
                        ),
                        Text(
                          "${widget.list[widget.indexVideo]["comment_by"].length}",
                          style: AppTextStyle.regular.copyWith(
                            fontSize: 12,
                            color: AppColor.white,
                          ),
                        ),
                        boxH20(),
                        GestureDetector(
                          onTap: () => applyLoginCheck(() {
                            print("isLogin");
                          }),
                          child: const Icon(
                            Icons.share_outlined,
                            color: Colors.white,
                            size: 30.0,
                          ),
                        ),
                        boxH20(),
                        
                        // const Icon(Icons.more_vert, color: AppColor.white,),
                        // boxH10(),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: goToUserProfile,
                        child: widget.videoData['user_data'] != null &&
                            widget.videoData['user_data'].isNotEmpty &&
                            widget.videoData['user_data']["image"] != null &&
                            widget.videoData['user_data']["image"].isNotEmpty
                            ? CircleAvatar(
                          radius: 18,
                          backgroundImage: CachedNetworkImageProvider(
                            APIShortsString.profileImageBaseUrl +
                                widget.videoData['user_data']["image"],
                          ),
                        )
                            : const CircleAvatar(
                          backgroundColor: AppColor.grey,
                          radius: 16,
                          child: Icon(
                            Icons.person,
                            size: 18,
                            color: AppColor.white,
                          ),
                        ),
                      ),
                      boxW10(),
                      GestureDetector(
                          onTap: goToUserProfile,
                          child: Text(
                              widget.videoData['user_data'] != null &&
                                  widget
                                      .videoData['user_data'].isNotEmpty &&
                                  widget.videoData['user_data']
                                  ["username"] !=
                                      null &&
                                  widget.videoData['user_data']["username"]
                                      .isNotEmpty
                                  ? "${widget.videoData['user_data']["username"]}"
                                  : '',
                              style: AppTextStyle.bold.copyWith(
                                  color: AppColor.white, fontSize: 14))),
                      boxW15(),
                      InkWell(
                        onTap: () {
                          openVideoDetails(context);
                        },
                        child: const Icon(
                          Icons.arrow_drop_up_outlined,
                          size: 25,
                          color: Colors.white,
                        ),
                      ),
                      boxW15(),
                      widget.fromScreen == AppString.fromMyVideo
                          ? const SizedBox()
                          : InkWell(
                        splashColor: AppColor.transparent,
                        hoverColor: AppColor.transparent,
                        onTap: () {
                          if (widget.videoData['user_data'] != null &&
                              widget.videoData['user_data'].isNotEmpty &&
                              widget.videoData['user_data']["_id"] !=
                                  null && widget.videoData['user_data']["_id"]
                              .isNotEmpty) {
                            updateFollowStatus();
                            setState(() {});
                          } else {
                            showSnackbar(message: "Error");
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                              border: Border.all(color: AppColor.white),
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(5))),
                          child: Text(
                            widget.videoData['followBack'] == null ||
                                widget.videoData['followBack'].toString().removeAllWhitespace.isEmpty ||
                                widget.videoData['followBack'].toString() == "0"
                                ? "Follow"
                                : 'Following',
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      widget.videoData['products'].isEmpty ?const SizedBox():  InkWell(
                        splashColor: AppColor.transparent,
                        hoverColor: AppColor.transparent,
                        onTap: () {
                          Get.find<HomeController>().showProduct.value =
                          !Get.find<HomeController>().showProduct.value;
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: AppColor.black.withOpacity(0.5),
                              borderRadius:
                              const BorderRadius.all(Radius.circular(5))),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 2, vertical: 1),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.shopping_bag,
                                size: 25,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 5),
                              Obx(() {
                                return Get.find<HomeController>()
                                    .showProduct
                                    .value ==
                                    true
                                    ? const Icon(
                                  Icons.arrow_drop_down_outlined,
                                  size: 25,
                                  color: Colors.white,
                                )
                                    : const Icon(
                                  Icons.arrow_drop_up_outlined,
                                  size: 25,
                                  color: Colors.white,
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                boxH10(),

                ///==========>?>?>?
                widget.videoData['products'].isEmpty ?const SizedBox(): Obx(() {
                  final showProduct = Get.find<HomeController>().showProduct.value;
                  return AnimatedOpacity(
                    opacity: showProduct ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 500),
                    child: showProduct
                        ? Container(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                          color: AppColor.black.withOpacity(0.5)),
                      height: 100,
                      child: ListView.builder(
                        padding: const EdgeInsets.only(left: 10),
                        scrollDirection: Axis.horizontal,
                        // itemCount: Get.find<HomeController>().productImages.length,
                        itemCount: widget.videoData['products'].length,
                        itemBuilder: (context, index) {
                          // var data = Get.find<HomeController>().productImages[index];
                          var data = widget.videoData['products'][index];
                          return GestureDetector(
                            onTap: () => applyLoginCheck(() {
                              print("isLogin");
                              widget.controller.pause();
                              print("widget.videoData[video][_id]    ${widget.videoData["video"]}");
                              Get.dialog(
                                LookBookUi(selectedProduct: index,userId: widget.videoData["video"]["user_id"],videoId: widget.videoData["video"]["_id"],productId: data["_id"]),
                                barrierDismissible: true,
                                useSafeArea: true,
                              ).whenComplete(
                                      () => widget.controller.play());
                            }),
                            child: Container(
                              margin: const EdgeInsets.only(right: 10),
                              height: 95,
                              width: 95,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(5)),
                                image: data["product_image"] == "" || (
                                    data["product_image"].isEmpty &&
                                        data["product_image"][0]["product_images"].toString().isEmpty)
                                    ? const DecorationImage(
                                  image: AssetImage(AppAsset.flutterLogo),
                                  fit: BoxFit.cover,
                                )
                                    : DecorationImage(
                                  image: NetworkImage("${APIShortsString.products_image}${data["product_image"][0]["product_images"].toString()}"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                        : const SizedBox(),
                  );
                })
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> commentBottomsheet(context) async {
    await showModalBottomSheet<void>(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      backgroundColor: AppColor.white,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SafeArea(
          child: StatefulBuilder(builder: (context, state) {
            return SizedBox(
              height: Get.height * 0.75,
              child: Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).viewInsets.top,
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                    right: 10,
                    left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        boxW25(),
                        Text('Comments',
                            style: AppTextStyle.regular.copyWith(fontSize: 16)),
                        IconButton(
                            onPressed: () => Get.back(),
                            icon: const Icon(
                              Icons.close,
                              size: 20,
                            ))
                      ],
                    ),
                    const Divider(
                      color: AppColor.black,
                    ),
                    Obx(
                          () {
                        return widget.list[widget.indexVideo]["comment_by"].isNotEmpty
                            ? Expanded(
                          child: ListView.builder(
                            // itemCount: dashboardController.CommentList.length,
                            itemCount: widget
                                .list[widget.indexVideo]["comment_by"]
                                .length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onLongPress: () {
                                  deleteComment(
                                    context,
                                    list: widget.list[widget.indexVideo]["comment_by"],
                                    commentId: widget.list[widget.indexVideo]["comment_by"][index]["comment_id"],
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 5),
                                  child: Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      const CircleAvatar(
                                        radius: 15,
                                        child: Icon(Icons.person),
                                      ),
                                      boxW05(),
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          widget.list[widget.indexVideo]["comment_by"][index]["username"]!=null?
                                          Text(
                                              "${widget.list[widget.indexVideo]["comment_by"][index]["username"]}"):
                                          Text(
                                              "${Get.find<MyProfileController>().commentuserName.value}"),
                                          Text(
                                              "${widget.list[widget.indexVideo]["comment_by"][index]["comment"]}"),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                            : Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 25),
                          child: Center(
                            child: Text(
                              'No Comment Available for this Post...',
                              style: AppTextStyle.regular
                                  .copyWith(fontSize: 15),
                            ),
                          ),
                        );
                      },
                    ),
                    Container(
                        height: 50,
                        margin: const EdgeInsets.only(bottom: 20),
                        child: CommonTextField(
                            controller:
                            Get.find<HomeController>().commentController,
                            hintText: "Add Your Comment",
                            suffixIcon: IconButton(
                              onPressed: () {
                                if (Get.find<HomeController>()
                                    .commentController
                                    .value
                                    .text
                                    .isNotEmpty) {
                                  profileVideosController
                                      .videoCommentApi(
                                      videoId:
                                      widget.list[widget.indexVideo]
                                      ["video"]["_id"],
                                      comment: Get.find<HomeController>()
                                          .commentController
                                          .text,
                                      list: widget.list[widget.indexVideo]
                                      ["comment_by"])
                                      .whenComplete(() => Get.back());
                                } else {
                                  showSnackbar(
                                      message: "Please Enter Comment...");
                                }
                              },
                              icon: const Icon(Icons.send, size: 30.0),
                              color: Colors.black,
                            ),
                            textInputType: TextInputType.text)),
                  ],
                ),
              ),
            );
          }),
        );
      },
    );
    // dashboardController.getCommentDataAPI(
    //   videoId: widget.data.id,
    // );
  }

  void openVideoDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isDismissible: true,
      builder: (BuildContext context) {
        return Container(
          height: Get.width * 0.6,
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () => Get.back(),
                    child: const CircleAvatar(
                        radius: 15,
                        backgroundColor: AppColor.grey,
                        child: Icon(
                          Icons.close,
                          color: AppColor.white,
                          size: 20,
                        )),
                  ),
                ),
                Row(
                  children: [
                    GestureDetector(
                      // onTap: () => Get.toNamed(Routes.USER_PROFILE_SCREEN),
                      onTap: goToUserProfile,
                      child: widget.videoData['user_data'] != null &&
                          widget.videoData['user_data'].isNotEmpty &&
                          widget.videoData['user_data']["image"] != null &&
                          widget.videoData['user_data']["image"].isNotEmpty
                          ? CircleAvatar(
                        radius: 18,
                        backgroundImage: CachedNetworkImageProvider(
                          APIShortsString.profileImageBaseUrl +
                              widget.videoData['user_data']["image"],
                        ),
                      )
                          : const CircleAvatar(
                        backgroundColor: AppColor.grey,
                        radius: 16,
                        child: Icon(
                          Icons.person,
                          size: 18,
                          color: AppColor.white,
                        ),
                      ),
                    ),
                    boxW10(),
                    GestureDetector(
                      // onTap: () => Get.toNamed(Routes.USER_PROFILE_SCREEN),
                      onTap: goToUserProfile,
                      child: Text(
                        widget.videoData['user_data'] != null &&
                            widget.videoData['user_data'].isNotEmpty &&
                            widget.videoData['user_data']["username"] !=
                                null &&
                            widget.videoData['user_data']["username"]
                                .isNotEmpty
                            ? "${widget.videoData['user_data']["username"]}"
                            : '',
                        style: AppTextStyle.bold.copyWith(),
                      ),
                    ),
                    boxW15(),
                    widget.fromScreen == AppString.fromMyVideo
                        ? const SizedBox()
                        : InkWell(
                      splashColor: AppColor.transparent,
                      hoverColor: AppColor.transparent,
                      onTap: () {
                        if (widget.videoData['user_data'] != null &&
                            widget.videoData['user_data'].isNotEmpty &&
                            widget.videoData['user_data']["_id"] !=
                                null &&
                            widget.videoData['user_data']["_id"]
                                .isNotEmpty) {
                          updateFollowStatus();
                          Get.back();
                          setState(() {});
                        } else {
                          showSnackbar(message: "Error");
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                            border: Border.all(color: AppColor.blue),
                            borderRadius: const BorderRadius.all(
                                Radius.circular(5))),
                        child: Text(widget.videoData['followBack'] == null ||
                            widget.videoData['followBack'].toString()
                                .removeAllWhitespace.isEmpty ||
                            widget.videoData['followBack'].toString() == "0"
                            ? "Follow"
                            : 'Following',
                          style: AppTextStyle.regular
                              .copyWith(color: AppColor.blue),
                        ),
                      ),
                    ),
                  ],
                ),
                boxH15(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.videoData['video'] != null &&
                            widget.videoData['video'].isNotEmpty &&
                            widget.videoData['video']["video_caption"] !=
                                null &&
                            widget.videoData['video']["video_caption"]
                                .isNotEmpty
                            ? "${widget.videoData['video']["video_caption"]}"
                            : '',
                        style: AppTextStyle.regular.copyWith(fontSize: 18),
                      ),
                    ),
                    // Expanded(
                    //   child: Text(
                    //     'Post Details...',
                    //     style: AppTextStyle.regular.copyWith(fontSize: 18),
                    //   ),
                    // ),
                    boxW15(),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.report_gmailerrorred,
                        color: AppColor.red,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void goToUserProfile() {
    if (widget.videoData['user_data'] != null) {
      widget.controller.pause();
      // Get.off(() =>
      Get.to(() => UserProfileScreen(userData: widget.videoData['user_data']))!
          .whenComplete(() => Get.back());
    }
  }

  updateFollowStatus() {
    if (widget.videoData["followBack"] == "1") {
      Get.find<FollowController>().followUnfollowUpdateList(
          followId: widget.videoData["user_data"]["_id"], status: "false");
      widget.videoData["followBack"] = "false";
    } else {
      Get.find<FollowController>().followUnfollowUpdateList(
          followId: widget.videoData["user_data"]["_id"], status: "true");
      widget.videoData["followBack"] = "true";
    }
  }

  Future<dynamic> deleteComment(BuildContext context,
      {String? commentId, List? list}) {
    final profileVideosController = Get.find<ProfileVideosController>();

    return showDialog(
      context: context,
      builder: (context) {
        return FittedBox(
          fit: BoxFit.scaleDown,
          child: Container(
            // height: Get.height * 0.5,
            width: Get.width * 0.8,
            padding: const EdgeInsets.all(25),
            decoration: const BoxDecoration(color: AppColor.white),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Delete Comment?"),
                  boxH20(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () {
                            print("commentId   $commentId");
                            profileVideosController.deleteVideoCommentApi(
                              list: list,
                              commentId: commentId,
                            );
                            Get.close(2);
                          },
                          child: Text(
                            "Yes",
                            style: AppTextStyle.regular
                                .copyWith(color: AppColor.red),
                          )),
                      TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: Text(
                            "No",
                            style: AppTextStyle.regular
                                .copyWith(color: AppColor.blue),
                          )),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}