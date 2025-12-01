// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/global/services/api_shorts_string.dart';
import 'package:real_estate_app/view/shorts/controller/profile_videos_controller.dart';
import 'package:video_player/video_player.dart';

import '../../../global/services/network_http.dart';
import '../../../global/widgets/loading_dialog.dart';
import '../../../utils/common_snackbar.dart';
import 'my_profile_controller.dart';

class UserProfileController extends GetxController {

  RxBool isUserProfileActive = false.obs;
  /// start video
  startVideo(){
    print("step -------------------   1  ${currentPage.value}");
    pageController = PageController(initialPage: currentPage.value);
    print("step -------------------   2");

    initializeVideoController(currentPage.value);
    print("step -------------------   3");

    try {
      pageController.addListener(() {
        print("step -------------------   3");
        int newPage = pageController.page!.toInt();
        print("step -------------------   4");
        if (newPage != currentPage.value) {
          print("step -------------------   5");
          userVideosDataList[currentPage.value]["controller"]!.pause();
          print("step -------------------   6");
          currentPage.value = newPage;
          print("step -------------------   7");
          initializeVideoController(newPage);
          print("step -------------------   8");

          if (userVideosDataList[newPage]["controller"] == null) {
            print("step -------------------   9");
            initializeVideoController(newPage);
            print("step -------------------   10");
          }
          else {
            print("step -------------------   11");
            if (userVideosDataList[newPage]["controller"]!.value.isInitialized) {
              print("step -------------------   12");
              userVideosDataList[newPage]["controller"]!.seekTo(Duration.zero);
              userVideosDataList[newPage]["controller"]!.play();
              print("step -------------------   13");
              update();
              print("step -------------------   14");
            }
          }
          print("step -------------------   15");
        }
        print("step -------------------   16");
      });
    } on Exception catch (e) {
      print("step -------------------   $e");

    }
    print("step -------------------   17");
  }


  @override
  void onClose() {
    pageController.dispose();

    super.onClose();
  }


  Future<void> initializeVideoController(int nextPage) async {
    print("initializeVideoController       1");
    if (userVideosDataList[nextPage]["controller"] == null) {
      print("initializeVideoController       2");
      userVideosDataList[nextPage]["controller"] = VideoPlayerController.networkUrl(Uri.parse("${APIShortsString.videoBaseUrl}${userVideosDataList[nextPage]["video"]["video"]}"));
      print("initializeVideoController       3");
      await userVideosDataList[nextPage]["controller"]!.initialize().whenComplete(() {
        print("initializeVideoController       4");
        Get.find<ProfileVideosController>().videoViewApi(videoId: userVideosDataList[nextPage]["video"]["_id"]);
        print("initializeVideoController       5");
        userVideosDataList[nextPage]["controller"]!.setLooping(true);
        print("initializeVideoController       6");
        userVideosDataList[nextPage]["controller"]!.play();
        print("initializeVideoController       7");
        update();
        print("initializeVideoController       8");
      });
      print("initializeVideoController       9");
    }
    print("initializeVideoController       10");
  }


  /// video page
  late PageController pageController;
  RxBool isPlaying = false.obs;
  RxInt currentPage = 0.obs;
  RxMap userProfileData = {}.obs;
  RxMap liveStreamData = {}.obs;


  Future userProfileApi({profileId}) async {
    final myProfileController = Get.find<MyProfileController>();
    userProfileData.clear();
    print('userProfileApi userId.value  ${myProfileController.userId.value}');
    //print('userProfileApi userId.value  ${await getDataFromLocalStorage(dataType: LocalStorage.stringType, prefKey: LocalStorage.userID)}');
    try {
      var response =
          await HttpHandler.postHttpMethod(
              url: APIShortsString.get_other_user_profile, data: {
        "user_id": myProfileController.userId.value,
        "other_user_id":  profileId,

      });

      log("userProfileApi  :: response  :: ${response["body"]}");

      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          userProfileData.value = response['body']['data'];
          liveStreamData.value = response['body']['data']['live_data'] ?? {};

          print("userProfileData.value  after success :: $userProfileData");
        } else if (response['body']['status'].toString() == "0") {
          showSnackbar(message: response['body']['msg']);
        }
        // if (response['body']['status'].toString() == "1") {}
      } else if (response['error'] != null) {}
    } catch (e, s) {
      hideLoadingDialog();
      debugPrint("userProfileApi Error -- $e  $s");
    }
  }

  ///api videos
  RxBool isApiCallProcessing = true.obs;
  RxMap userVideosResponse = {}.obs;
  RxList searchResult = [].obs;
  RxList userVideosDataList = [].obs;
  RxInt lastPage = 0.obs;
  RxInt currentPageList = 1.obs;
  RxInt nextPage = 1.obs;
  final ScrollController scrollController = ScrollController();

  Future userVideosApi({
    int pageNumber = 1,
    int count = 10,
    bool isShowMoreCall = false,
    profileId
  }) async {
    try {
      if (isShowMoreCall == false) {
        userVideosDataList.clear();
      }
      isApiCallProcessing.value = true;
      var response = await HttpHandler.postHttpMethod(
          url: APIShortsString.other_user_videos,
          data: {
            "user_id": Get.find<MyProfileController>().userId.value,
            "other_user_id":profileId,
            "count": count,
            "page_no": pageNumber,
          });

      userVideosResponse.value = response;
      isApiCallProcessing.value = false;

      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          var respData = response['body'];
          lastPage.value = response['body']["last_page"];
          currentPageList.value = response['body']["current_page"];
          nextPage.value = currentPageList.value + 1;

          if (isShowMoreCall == true) {
            respData["data"].forEach((e) {
              e["controller"] = null;
              var d = e;
              userVideosDataList.add(/*e*/ d);
            });
            print("other_user_videos  add in existing $userVideosDataList");
          } else {
            respData["data"].forEach((element) {
              element["controller"] = null;
            });
            userVideosDataList.value = respData["data"];
            print("myVideosApi  replace $userVideosDataList");
          }

        } else if (response['body']['status'].toString() == "0") {
          userVideosDataList.value = [];
          showSnackbar(message: response['body']['msg']);
        }
      } else if (response['error'] != null) {
        userVideosDataList.value = [];
      }
    } catch (e, s) {
      // hideLoadingDialog();
      debugPrint("other_user_videos Error -- $e  $s");
    }
  }


}
