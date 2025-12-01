// ignore_for_file: must_be_immutable

import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:real_estate_app/global/api_string.dart';
import '../../../Routes/app_pages.dart';
import '../../../common_widgets/height.dart';
import '../../../global/app_color.dart';
import '../../../global/app_string.dart';
import '../../../global/services/api_shorts_string.dart';
import '../../../global/theme/app_text_style.dart';
import '../../../global/widgets/common_textfield.dart';
import '../../../utils/shared_preferences/shared_preferances.dart';
import '../../all_products/view/related_products/add_related_products_for_video.dart';
import '../../auth/auth_controllers/registration_controller.dart';
import '../../dashboard/deshboard_controllers/bottom_bar_controller.dart';
import '../../post_video/post_video.dart';
import '../../routes/app_pages.dart';
import '../../splash_screen/splash_screen.dart';
import '../controller/my_profile_controller.dart';
import '../controller/profile_videos_controller.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen>{
  // final followController =  Get.put(FollowController());
  final myProfileController = Get.put(MyProfileController());
  final profileVideosController = Get.find<ProfileVideosController>();
  //final addStoryController = Get.find<AddStoryController>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      myProfileController.getProfileApi();
      getVideos();
      getUserStory();
    });
  }


  getVideos() {
    profileVideosController.myVideosApi(
      isShowMoreCall: false,
      pageNumber: 1,
    );
  }

  getUserStory() {
    //addStoryController.getUserStory(isViewerStory: false);
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
      onWillPop: () =>onBackPressed(),
      child: SafeArea(
        child: Obx(() {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Profile",
                        style: AppTextStyle.bold
                            .copyWith(color: AppColor.black, fontSize: 20),
                      ),
                    ],
                  ),
                ),

                boxH05(),
            
                 Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: InkWell(
                        splashColor: AppColor.transparent,
                        highlightColor: AppColor.transparent,
                        onTap: () {
                          // print("Get.find<StoryController>().currentMyStoryIndex.value  "
                          //     "  ${Get.find<StoryController>().currentMyStoryIndex.value}    ");
                          //
                          // Get.find<StoryController>().currentMyStoryIndex.value = 0;
                          // if (addStoryController.userProfileStories.isNotEmpty) {
                          //   Get.to(() => SingleUserStoryScreen(
                          //             fromMyProfile: true,
                          //             userData: {"user_name": myProfileController.myProfileData['user_data']["username"],
                          //               "image": myProfileController.myProfileData['user_data']["image"]},
                          //             // storyList: addStoryController.userProfileStories,
                          //           ))!
                          //       .whenComplete(() {
                          //     Get.find<StoryController>().stopTimer();
                          //     Get.find<StoryController>().currentMyStoryIndex.value = 0;
                          //     Get.find<StoryController>().progress.value = 1.0;
                          //   });
                          // }
                        },
                        child: Obx(() => myProfileController.myProfileData.isNotEmpty &&
                                myProfileController.myProfileData['user_data']["profile_image"] != null &&
                                myProfileController.myProfileData['user_data']["profile_image"].isNotEmpty
                            ? ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: "${APIString.imageBaseUrl}media/" + myProfileController.myProfileData['user_data']["profile_image"],
                                  fit: BoxFit.cover,
                                  height: 90,
                                  width: 90,
                                  errorWidget: (context, url, error) {
                                    return Container(
                                      color: AppColor.grey.withOpacity(0.2),
                                      child: const Icon(
                                        Icons.person,
                                        color: AppColor.grey,
                                        size: 90,
                                      ),
                                    );
                                  },
                                  placeholder: (context, url) {
                                //    print("object==>");
                                    http://13.127.244.70:4444/media/profile_images/Naruto_MO83t1B.jpg
                                //    http://13.127.244.70:4444/media/profile_images/Naruto_MO83t1B.jpg
                                   // print("${APIString.imageBaseUrl}media/" + myProfileController.myProfileData['user_data']["profile_image"],);
                                    return Container(
                                      color: AppColor.grey.withOpacity(0.2),
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

                boxH10(),
                        myProfileController.myProfileData['user_data'] == null ||
                        myProfileController.myProfileData['user_data'].isEmpty ||
                        myProfileController.myProfileData['user_data']["full_name"] == null ||
                        myProfileController.myProfileData['user_data']["full_name"].isEmpty
                    ? Text("", style: AppTextStyle.semiBold.copyWith(fontSize: 20))
                    : Text(myProfileController.myProfileData['user_data']["full_name"].toString(),
                        style: AppTextStyle.semiBold.copyWith(fontSize: 20),
                      ),
                boxH05(),
                        myProfileController.myProfileData['user_data'] == null ||
                        myProfileController.myProfileData['user_data'].isEmpty ||
                        myProfileController.myProfileData['user_data']["username"] == null ||
                        myProfileController.myProfileData['user_data']["username"].isEmpty
                    ? Text("", style: AppTextStyle.regular.copyWith(fontSize: 15),)
                    : Container(
                    padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 20),
                    decoration: BoxDecoration(
                    color: Colors.pink.shade50,
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                  ),
                      child: Text('@${myProfileController.myProfileData['user_data']["username"]}',
                          style: AppTextStyle.regular.copyWith(fontSize: 15),
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
                          count: myProfileController.myProfileData['post_uploaded'] == null ? ""
                                : "${myProfileController.myProfileData['post_uploaded']}");
                    }),
                    SizedBox(
                        height: 20,
                        child: VerticalDivider(color: AppColor.grey.shade400)),
                    Obx(() {
                      return numberColumn(
                          title: "Followers",
                          count: myProfileController.myProfileData['user_followers'] == null ? ""
                              : "${myProfileController.myProfileData['user_followers']}",
                          onTap: () => Get.toNamed(Routes.FOLLOWERS_SCREEN,arguments: {
                            'user_id':myProfileController.userId.value,
                          }));
                    }),
                    SizedBox(
                        height: 20,
                        child: VerticalDivider(color: AppColor.grey.shade400)),
                    Obx(() {
                      return numberColumn(
                          title: "Following",
                          count: myProfileController.myProfileData['user_following'] == null ? ""
                              : "${myProfileController.myProfileData['user_following']}",
                          onTap: () => Get.toNamed(Routes.FOLLOWINGS_SCREEN,arguments: {
                            'user_id':myProfileController.userId.value,
                            // You can pass any data type as parameters
                          }));
                    }),
                  ],
                ),
                boxH15(),
                Row(
                  children: [
                    boxW15(),
                    btn(
                      title: "Store",
                      icon: Icons.shopping_bag,
                      onTap: () {
                        Get.toNamed(Routes.STORE_PAGE);
                      },
                    ),
                    boxW15(),
                  ],
                ),
                boxH15(),
                Container(
                  width: Get.width,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(border: Border.all(color: AppColor.black, width: 1)),
                  child: Center(
                    child: Text(
                      "All Posts",
                      style: AppTextStyle.regular.copyWith(color: AppColor.black, fontSize: 20),
                    ),
                  ),
                ),
                boxH10(),
                Obx(() => myProfileController.profileVideosController!.myVideosResponse.isEmpty ||
                        myProfileController.profileVideosController!.myVideosDataList.isEmpty
                    ? const Center(child: Text('No Search Results Found'))
                    : Column(
                      children: [
                        GridView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          // itemCount: controller.videoItems.length,
                          itemCount: myProfileController
                              .profileVideosController!
                              .myVideosDataList
                              .length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  mainAxisSpacing: 2,
                                  crossAxisSpacing: 2),
                          itemBuilder: (context, index) {
                            var data = myProfileController.profileVideosController!.myVideosDataList[index];
                            return GestureDetector(
                              onTap: () {
                                myProfileController.profileVideosController!
                                    .currentPage.value = index;
                                Get.toNamed(Routes.PROFILE_VIDEOS_SCREEN)!
                                    .whenComplete(() async {
                                  if (myProfileController.profileVideosController!.myVideosDataList.isNotEmpty) {
                                    myProfileController.profileVideosController!
                                        .myVideosDataList[
                                            myProfileController
                                                .profileVideosController!
                                                .currentPage
                                                .value]["controller"]!.pause();
                                  }
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
                                            image: NetworkImage("${APIShortsString.thumbnailBaseUrl}${data["video"]["thumbnail"]}"),
                                            fit: BoxFit.cover)),
                                  ),
                                  data["video"]["approval_status"]=="Pending"?
                                  Container(
                                    height: Get.width * 0.3,
                                    width: Get.width * 0.3,
                                    color: Colors.black.withOpacity(0.6),
                                    child: const Center(
                                      child: Text(
                                        "Sent for approval",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ):SizedBox(),
                                  data["video"]["approval_status"]=="Disapproved"?
                                  Positioned(
                                    left: 0,
                                    top: 0,
                                    child: Container(
                                      color: Colors.black.withOpacity(0.6),
                                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      child: const Text(
                                        "Disapproved",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ):SizedBox(),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: IconButton(
                                        onPressed: () {
                                          videoOptions(data);
                                        },
                                        icon: CircleAvatar(
                                          radius: 12,
                                          backgroundColor: AppColor
                                              .grey.shade100
                                              .withOpacity(0.3),
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
                        myProfileController
                                    .profileVideosController!.currentPage
                                    .toString() ==
                                myProfileController
                                    .profileVideosController!.lastPage
                                    .toString()
                            ? const SizedBox()
                            : myProfileController.profileVideosController!
                                        .isApiCallProcessing.value ==
                                    true
                                ? const Text("Please wait while loading")
                                : InkWell(
                                    onTap: () {},
                                    child: const Text("Show More")),
                        const SizedBox(height: 40)
                      ],
                    )),
                boxH02(),
              ],
            ),
          );
        }),
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

                  GestureDetector(
                    onTap: () {
                      Get.to(() => PostVideoScreen(
                            fromEdit: true,
                            videoId: data["video"]["_id"],
                            editVideoData: data,
                          ));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                          color: AppColor.orange.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(Icons.edit, size: 14),
                          boxW20(),
                          Text(
                            AppString.editVideo.capitalize!,
                            style: AppTextStyle.bold.copyWith(fontSize: 14),
                          )
                        ],
                      ),
                    ),
                  ),
                  boxH10(),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => AllRelatedProductForVideo(
                            isFromScreen: AppString.fromMyProfile,
                            videoData: data["video"],
                          ));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                          color: AppColor.green.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(Icons.edit, size: 14),
                          boxW20(),
                          Text(
                            AppString.relatedProducts.capitalize!,
                            style: AppTextStyle.bold.copyWith(fontSize: 14),
                          )
                        ],
                      ),
                    ),
                  ),
                  boxH10(),
                  GestureDetector(
                    onTap: () {
                      // Get.to(() => AllRelatedProductForVideo(
                      //   isFromScreen: AppString.fromMyProfile,
                      //   videoData: data["video"],
                      // ));
                      myProfileController.deleteVideoApi(videoId:data["video"]["_id"]).whenComplete(() => getVideos());
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                          color: AppColor.red.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(Icons.delete, size: 14),
                          boxW20(),
                          Text(
                            AppString.deleteVideo.capitalize!,
                            style: AppTextStyle.bold.copyWith(fontSize: 14),
                          )
                        ],
                      ),
                    ),
                  ),
                  // boxH10(),
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
              boxW05(),
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

  void editProfileBottomSheet(context) async {
    myProfileController.usernameChangesStart.value = false;
    myProfileController.name.value.text = myProfileController.myProfileData['user_data']["full_name"].toString();
    myProfileController.city.value.text = myProfileController.myProfileData['user_data']["city"].toString();
    myProfileController.userNameController.text =
        myProfileController.myProfileData['user_data']["username"].toString();
    myProfileController.mobileController.text =
        myProfileController.myProfileData['user_data']["mobile_number"].toString();
    myProfileController.email.value.text =
        myProfileController.myProfileData['user_data']["email"].toString();
    // myProfileController.selectedGender.value =
    //     myProfileController.myProfileData['user_data']["gender"].toString();
    myProfileController.accountType.value = myProfileController
        .myProfileData['user_data']["account_type"]
        .toString();
    // myProfileController.selectedDate.value = DateTime.parse(
    //     myProfileController.myProfileData['user_data']["dob"] == null ||
    // myProfileController.myProfileData['user_data']["dob"].toString().isEmpty
    //         ? DateTime.now().toString()
    //         : myProfileController.myProfileData['user_data']["dob"].toString());
    showModalBottomSheet<void>(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        // return StatefulBuilder(builder: (context, state) {
        return GetBuilder<MyProfileController>(
          builder: (myProfileController) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                top: MediaQuery.of(context).viewInsets.top,
                right: 10,
                left: 10,
              ),
              child: Obx(() {
                return Container(
                  height: Get.height - 60,
                  color: Colors.white,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          // alignment: Alignment.centerRight,
                          children: [
                            Text(
                              "Edit Profile",
                              style:
                                  AppTextStyle.semiBold.copyWith(fontSize: 20),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.cancel,
                                size: 30,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            )
                          ],
                        ),
                        Center(
                          child: GetBuilder<MyProfileController>(
                            builder: (controller) {
                              return uploadLogoUi();
                            },
                          ),
                        ),
                        const Divider(thickness: 1, color: Colors.grey),
                        boxH05(),
                        textFieldTitle("Name"),
                        CommonTextField(
                            controller: myProfileController.name.value,
                            hintText: "Name"),
                        boxH05(),

                        ///
                        textFieldTitle("Username"),
                        CommonTextField(
                          bottomPadding: 3,
                          hintText: 'Username - min 3 character',
                          controller: myProfileController.userNameController,
                          onChange: (p0) {
                            myProfileController.userName.value =
                                myProfileController.userNameController.text;
                            myProfileController.usernameChangesStart.value =
                                true;
                            Get.find<RegistrationController>()
                                .checkUsernameAvailability(
                                    username:
                                      myProfileController.userName.value,
                                    fromProfileUpdate: true);
                          },
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          // child:controller.userNameController.text.isEmpty?const SizedBox():
                          child: Obx(() =>
                              myProfileController.usernameChangesStart.value == false
                                  ? const SizedBox()
                                  : myProfileController.userName.value.isEmpty
                                      ? Text(
                                          "Add Username",
                                          style: AppTextStyle.regular
                                              .copyWith(color: AppColor.red),
                                        )
                                      : myProfileController.isUsernameLoading.value == true
                                          ? const SizedBox(
                                              height: 10,
                                              width: 10,
                                              child: CircularProgressIndicator(
                                                  color: AppColor.blue),
                                            )
                                          : myProfileController.isUsernameValid.value == false
                                              ? Text(
                                                  "Username is not available",
                                                  style: AppTextStyle.regular
                                                      .copyWith(
                                                          color: AppColor.red),
                                                )
                                              : Text(
                                                  "Username is available",
                                                  style: AppTextStyle.regular
                                                      .copyWith(
                                                          color: AppColor.blue),
                                                )),),
                        boxH05(),
                        textFieldTitle("Mobile"),
                        CommonTextField(
                            controller: myProfileController.mobileController,
                            hintText: "Mobile",
                            // readOnly: true,
                            fillColor: AppColor.grey.shade200),
                        boxH05(),
                        textFieldTitle("Email Id"),
                        CommonTextField(
                            controller: myProfileController.email.value,
                            hintText: "Email Id"),

                        boxH05(),
                        textFieldTitle("City"),
                        CommonTextField(
                            controller: myProfileController.city.value,
                            hintText: "City Name"),

                        boxH05(),
                        textFieldTitle("D.O.B."),
                        Obx(() {
                          return CommonTextField(
                              onTap: () {
                                myProfileController.selectDate(context);
                              },
                              readOnly: true,
                              hintText: DateFormat('yyyy-MM-dd').format(myProfileController.selectedDate.value) /* controller: controller.email.value, "Email Id"*/);
                        }),
                        boxH05(),
                        textFieldTitle("Gender"),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Obx(() {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                selectGender(selectedValue: "male"),
                                selectGender(
                                  selectedValue: "female",
                                ),
                                selectGender(
                                  selectedValue: "prefer not to say",
                                )
                              ],
                            );
                          }),
                        ),
                        boxH05(),
                        Align(
                            alignment: AlignmentDirectional.topStart,
                            child: Text(
                              "Profile Privacy",
                              style: AppTextStyle.medium.copyWith(fontSize: 16),
                            )),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Obx(() {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                selectPrivacy(selectedValue: "public"),
                                selectPrivacy(selectedValue: "private",),
                              ],
                            );
                          }),
                        ),
                        boxH20(),
                        GestureDetector(
                          onTap: () {
                            if (myProfileController
                                    .mobileController.text.isNotEmpty &&
                                myProfileController
                                    .phoneCode.value.isNotEmpty &&
                                myProfileController
                                    .countryName.value.isNotEmpty &&
                                myProfileController
                                    .userNameController.text.isNotEmpty &&
                                myProfileController.isUsernameLoading.value ==
                                    false /*&& controller.isUsernameValid.value == true*/) {
                              myProfileController.updateProfile(
                                name: myProfileController.name.value.text,
                                mobileNo: myProfileController.mobileController.text,
                                countryCode: myProfileController.phoneCode.value,
                                country: myProfileController.countryName.value,
                                email: myProfileController.email.value.text,
                                city: myProfileController.city.value.text,
                                gender: myProfileController.selectedGender.value,
                                // image: controller.image.value,
                                image: iconImg,
                                dob: DateFormat('yyyy-MM-dd')
                                    .format(myProfileController.selectedDate.value).toString(),
                                username: myProfileController.userNameController.text,
                                token: "fcmToken",
                                privacy:myProfileController.accountType.value,
                              );
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration:
                                const BoxDecoration(color: AppColor.blueGrey),
                            child: Text('Save',
                                style: AppTextStyle.regular.copyWith(
                                    color: AppColor.white, fontSize: 16)),
                          ),
                        ),
                        boxH20(),
                      ],
                    ),
                  ),
                );
              }),
            );
          },
        );
      },
    );
  }

  Align textFieldTitle(String title) {
    return Align(
        alignment: AlignmentDirectional.topStart,
        child: Text(
          title,
          style: AppTextStyle.medium.copyWith(fontSize: 16),
        ));
  }

  Widget uploadLogoUi() {
    debugPrint(
        "controller.userProfileData[image]   ${myProfileController.myProfileData['user_data']["image"]}");
    return InkWell(
      // onTap: () => showImageDialog(),
      onTap: () {
        showImageDialog();
        // Get.to(() => CreateStory(forProfilePicture: true))!.whenComplete(() {
        //   if (addStoryController.imageFile.value != null) {
        //     cropImage(addStoryController.imageFile.value!);
        //   }
        //   // Get.find<AddStoryController>().clearData();
        // });
      },
      child: Stack(
        alignment: Alignment.topRight,
        children: <Widget>[
          Obx(() {
            return ClipOval(
                child: myProfileController.isIconSelected.value
                    ? Image.file(
                        File(iconImg!.path),
                        height: 100,
                        width: 100,
                      )
                    : myProfileController.myProfileData['user_data']["image"] !=
                                null &&
                            myProfileController
                                .myProfileData['user_data']["image"].isNotEmpty
                        ? CircleAvatar(
                            radius: 45,
                            backgroundImage: CachedNetworkImageProvider(
                              APIShortsString.profileImageBaseUrl +
                                  myProfileController.myProfileData['user_data']
                                      ["image"],
                            ),
                          )
                        : Image.asset('assets/user.png'));
          }),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                  color: AppColor.blueGrey, shape: BoxShape.circle),
              child: const Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  showImageDialog() async {
    return showDialog(
      // context: Get.context!,
      context: Get.context!,
      builder: (context) => AlertDialog(
          backgroundColor: Colors.white,
          content: SizedBox(
            height: 110,
            child: Column(
              children: <Widget>[
                const Text(
                  "Choose Profile Photo",
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextButton.icon(
                        onPressed: () {
                          getCameraImage();
                        },
                        icon: const Icon(
                          Icons.camera,
                          color: Colors.black54,
                          size: 20,
                        ),
                        label: const Text("Camera",
                            style: TextStyle(
                                color: Colors.black54, fontSize: 20))),
                    TextButton.icon(
                        onPressed: () {
                          getGalleryImage();
                        },
                        icon: const Icon(
                          Icons.image,
                          color: Colors.black54,
                          size: 20,
                        ),
                        label: const Text("Gallery",
                            style: TextStyle(
                                color: Colors.black54, fontSize: 20))),
                  ],
                )
              ],
            ),
          )),
    );
  }

  final ImagePicker picker = ImagePicker();

  // late File icon_img;
  File? iconImg;
  late XFile pickedImageFile;

  Future getCameraImage() async {
    try {
      Navigator.of(Get.context!).pop(false);
      XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);
      // var pickedFile = await picker.pickImage(source: ImageSource.camera,imageQuality: 20);

      if (pickedFile != null) {
        pickedImageFile = pickedFile;

        File selectedImg = File(pickedImageFile.path);

        cropImage(selectedImg);
      }
    } on Exception catch (e) {
      log("$e");
    }
  }

  Future getGalleryImage() async {
    Navigator.of(Get.context!).pop(false);
    var pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      pickedImageFile = pickedFile;

      File selectedImg = File(pickedImageFile.path);

      cropImage(selectedImg);
    }
  }

  cropImage(File icon) async {
    CroppedFile? croppedFile = (await ImageCropper()
        .cropImage(sourcePath: icon.path, aspectRatioPresets: [
      CropAspectRatioPreset.square,
      CropAspectRatioPreset.ratio3x2,
      CropAspectRatioPreset.original,
      CropAspectRatioPreset.ratio4x3,
      CropAspectRatioPreset.ratio16x9
    ], uiSettings: [
      AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
      IOSUiSettings(
        title: 'Cropper',
      ),
    ]));
    if (croppedFile != null) {
      //addStoryController.clearData();
      // if (mounted) {
      iconImg = File(croppedFile.path);
      myProfileController.isIconSelected.value = true;
      // }
    }
  }

  selectGender({required String selectedValue}) {
    return GestureDetector(
      onTap: () {
        myProfileController.selectedGender.value = selectedValue;
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
            border: Border.all(
                width: 2,
                color: myProfileController.selectedGender.value != selectedValue
                    ? AppColor.transparent
                    : AppColor.black),
            color: myProfileController.selectedGender.value == selectedValue
                ? AppColor.grey
                : AppColor.grey.withOpacity(0.5),
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: Center(
          child: Text(
            selectedValue.capitalize!,
            style: AppTextStyle.regular.copyWith(
                color: myProfileController.selectedGender.value == selectedValue
                    ? AppColor.white
                    : AppColor.black),
          ),
        ),
      ),
    );
  }

  selectPrivacy({required String selectedValue}) {
    return GestureDetector(
      onTap: () {
        myProfileController.accountType.value = selectedValue;
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
            border: Border.all(
                width: 2,
                color: myProfileController.accountType.value != selectedValue
                    ? AppColor.transparent
                    : AppColor.black),
            color: myProfileController.accountType.value == selectedValue
                ? AppColor.grey
                : AppColor.grey.withOpacity(0.5),
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: Center(
          child: Text(
            selectedValue.capitalize!,
            style: AppTextStyle.regular.copyWith(
                color: myProfileController.accountType.value == selectedValue
                    ? AppColor.white
                    : AppColor.black),
          ),
        ),
      ),
    );
  }

  logoutAlert() {
    return showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
          backgroundColor: Colors.yellow[50],
          title: Text('Are you sure?', style: AppTextStyle.regular),
          content: Wrap(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                      'You want to logout?',
                      style: AppTextStyle.regular),
                  boxH10(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          clearLocalStorage();
                          isLogin = false;
                          setState(() {});
                          Get.find<BottomBarController>()
                              .selectedBottomIndex
                              .value = 0;
                          Get.offAllNamed(Routes.login);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[200],
                          minimumSize: const Size(70, 30),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(2.0)),
                          ),
                        ),
                        child: Text("Yes",
                            style: AppTextStyle.regular.copyWith(fontSize: 13)),
                      ),
                      boxW10(),
                      ElevatedButton(
                        onPressed: () {
                         Get.back();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent[200],
                          minimumSize: const Size(70, 30),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(2.0)),
                          ),
                        ),
                        child: Text("No",
                            style: AppTextStyle.regular.copyWith(fontSize: 13)),
                      ),
                    ],
                  )
                ],
              )
            ],
          )),
    );
  }
}
