//Holds the state of the application and provides an API to access/filter/manipulate that data.
// Its concern is data encapsulation and management.
// It contains logic to structure, validate or compare different pieces of data that we call Domain Logic.
// Model File : A perfect tool to make Models easily.
// https://app.quicktype.io/

// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../../global/services/api_shorts_string.dart';
import '../../../global/services/network_http.dart';
import '../../../utils/String_constant.dart';
import '../../../utils/common_snackbar.dart';
import '../../../utils/shared_preferences/shared_preferances.dart';
import '../view/video_item.dart';
import 'home_controller.dart';
import 'my_profile_controller.dart';

class ProfileVideosController extends GetxController {

RxBool isProfileVideoActive = false.obs;

  /// start video
  startVideo(){
    pageController = PageController(initialPage: currentPage.value);

    initializeVideoController(currentPage.value);

    pageController.addListener(() {
      int newPage = pageController.page!.toInt();
      if (newPage != currentPage.value) {
        myVideosDataList[currentPage.value]["controller"]!.pause();
        currentPage.value = newPage;
        initializeVideoController(newPage);

        if (myVideosDataList[newPage]["controller"] == null) {
          initializeVideoController(newPage);
        }
        else {
          if (myVideosDataList[newPage]["controller"]!.value.isInitialized) {
            myVideosDataList[newPage]["controller"]!.seekTo(Duration.zero);
            myVideosDataList[newPage]["controller"]!.play();
            update();
          }
        }
      }
    });
  }


  @override
  void onClose() {
    pageController.dispose();
    
    super.onClose();
  }

  /// video page
  late PageController pageController;
  RxBool isPlaying = false.obs;
  RxInt currentPage = 0.obs;
  

  Future<void> initializeVideoController(int nextPage) async {
    if (myVideosDataList[nextPage]["controller"] == null) {
      myVideosDataList[nextPage]["controller"] = VideoPlayerController.networkUrl(Uri.parse("${APIShortsString.videoBaseUrl}${myVideosDataList[nextPage]["video"]["video"]}"));
      await myVideosDataList[nextPage]["controller"]!.initialize().whenComplete(() {
        videoViewApi(videoId: myVideosDataList[nextPage]["video"]["_id"]);
        myVideosDataList[nextPage]["controller"]!.setLooping(true);
        if(isProfileVideoActive.value) {
          myVideosDataList[nextPage]["controller"]!.play();
        }
        else{
          myVideosDataList[nextPage]["controller"]!.pause();
        }
        update();
      });
    }
  }


  ///api videos
  RxBool isApiCallProcessing = true.obs;
  RxMap myVideosResponse = {}.obs;
  RxList searchResult = [].obs;
  RxList myVideosDataList = [].obs;
  RxInt lastPage = 0.obs;
  RxInt currentPageList = 1.obs;
  RxInt nextPage = 1.obs;
  final ScrollController scrollController = ScrollController();

  Future myVideosApi({
    int pageNumber = 1,
    int count = 4,
    bool isShowMoreCall = false,
  }) async {
    // showLoadingDialog();
    try {
      if(isShowMoreCall == false){
        myVideosDataList.clear();
      }
      String? userId = await SPManager.instance.getUserId(USER_ID);
      isApiCallProcessing.value = true;
      var response = await HttpHandler.postHttpMethod(
          url: APIShortsString.trending_videos, data: {
        "user_id": userId,
        "count": count,
        "page_no": pageNumber,
      });

      myVideosResponse.value = response;
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
              myVideosDataList.add(/*e*/d);
            });
            print("myVideosApi  add in existing $myVideosDataList");

          }
          else {
            respData["data"].forEach((element) {
              element["controller"] = null;
            });
            myVideosDataList.value = respData["data"];
            print("myVideosApi  replace $myVideosDataList");
          }

          // if(myVideosDataList.isNotEmpty){
          //   startVideo();
          // }
        } else if (response['body']['status'].toString() == "0") {
          myVideosDataList.value = [];
          //showSnackbar(message: response['body']['msg']);
        }
      }
      else if (response['error'] != null) {
        myVideosDataList.value = [];
      }
    }
    catch (e, s) {
      // hideLoadingDialog();
      debugPrint("myVideosApi Error -- $e  $s");
    }
  }

//
  Future videoLikeApi({
    videoId,
    String likeStatus = "0",
    list,
    index
  }) async {
    try {
      var response = await HttpHandler.postHttpMethod(
          url: APIShortsString.video_like, data: {
        "user_id": Get.find<MyProfileController>().userId.value,
        "video_id": videoId,
        "like_status": likeStatus,
      });
      log("videoLikeApi  :: response  :: userId.value  :: ${Get.find<MyProfileController>().userId.value}");

      myVideosResponse.value = response;
      log("videoLikeApi  :: response  :: ${response["body"]}");

      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {

        } else if (response['body']['status'].toString() == "0") {

          //showSnackbar(message: response['body']['msg']);
        }
      }
      else if (response['error'] != null) {}
    }
    catch (e, s) {
      // hideLoadingDialog();
      debugPrint("videoLikeApi Error -- $e  $s");
    }
  }


  Future videoViewApi({
    videoId,
  }) async {
    print("videoViewApi  called");
    try {
      var response = await HttpHandler.postHttpMethod(
          url: APIShortsString.video_view, data: {
        "user_id": Get.find<MyProfileController>().userId.value,
        "video_id": videoId,
      });
      log("videoLikeApi  :: response  :: userId.value  :: ${Get.find<MyProfileController>().userId.value}");

      myVideosResponse.value = response;
      log("videoLikeApi  :: response  :: ${response["body"]}");

      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {

        } else if (response['body']['status'].toString() == "0") {

          //showSnackbar(message: response['body']['msg']);
        }
      }
      else if (response['error'] != null) {}
    }
    catch (e, s) {
      // hideLoadingDialog();
      debugPrint("videoLikeApi Error -- $e  $s");
    }
  }


  Future videoCommentApi({
    videoId,comment,
    list
  }) async {
    try {
      var response = await HttpHandler.postHttpMethod(
          url: APIShortsString.video_comment, data: {
        "user_id": Get.find<MyProfileController>().userId.value,
        "video_id": videoId,
        "comment":comment
      });
      log("videoLikeApi  :: response  :: userId.value  :: ${Get.find<MyProfileController>().userId.value}");

      myVideosResponse.value = response;
      log("videoLikeApi  :: response  :: ${response["body"]}");
      Get.find<HomeController>().commentController.clear();
      update();

      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          print("list $list");
          list.add({
            "comment_id": response['body']['data']['_id'],
            "user_id": Get.find<MyProfileController>().userId.value,
            "comment": comment
          });
        } else if (response['body']['status'].toString() == "0") {

          //showSnackbar(message: response['body']['msg']);
        }
      }
      else if (response['error'] != null) {}
    }
    catch (e, s) {
      // hideLoadingDialog();
      debugPrint("videoLikeApi Error -- $e  $s");
    }
  }


  Future deleteVideoCommentApi({
   String? commentId,
    List? list
  }) async {
    try {
      var response = await HttpHandler.postHttpMethod(
          url: APIShortsString.delete_video_comment, data: {
        "comment_id":commentId,
      });

      myVideosResponse.value = response;
      log("deleteVideoCommentApi  :: response  :: ${response["body"]}");
      Get.find<HomeController>().commentController.clear();
      update();

      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          print("list $list");
          list!.removeWhere((e) => e["comment_id"].toString() == commentId.toString(),);

          update();

        } else if (response['body']['status'].toString() == "0") {

          //showSnackbar(message: response['body']['msg']);
        }
      }
      else if (response['error'] != null) {}
    }
    catch (e, s) {
      // hideLoadingDialog();
      debugPrint("videoLikeApi Error -- $e  $s");
    }
  }

  final List<VideoItem> videoItems = [
    VideoItem(
        videoUrl: 'https://gruzen.in/videos/video1.mp4',
        thumbnail: "https://i.pinimg.com/236x/4b/b4/e0/4bb4e0f7794e06538543d0d474c7cb6c.jpg"
    ),
    VideoItem(
        videoUrl: 'https://gruzen.in/videos/video2.mp4',
        thumbnail: "https://i.pinimg.com/236x/4b/b4/e0/4bb4e0f7794e06538543d0d474c7cb6c.jpg"
    ),
    VideoItem(
        videoUrl: 'https://gruzen.in/videos/video3.mp4',
        thumbnail: "https://i.pinimg.com/236x/4b/b4/e0/4bb4e0f7794e06538543d0d474c7cb6c.jpg"
    ),
    VideoItem(
        videoUrl: 'https://gruzen.in/videos/video4.mp4',
        thumbnail: "https://i.pinimg.com/236x/4b/b4/e0/4bb4e0f7794e06538543d0d474c7cb6c.jpg"
    ),
    VideoItem(
        videoUrl: 'https://gruzen.in/videos/video1.mp4',
        thumbnail: "https://i.pinimg.com/236x/4b/b4/e0/4bb4e0f7794e06538543d0d474c7cb6c.jpg"
    ),
    VideoItem(
        videoUrl: 'https://gruzen.in/videos/video2.mp4',
        thumbnail: "https://i.pinimg.com/236x/4b/b4/e0/4bb4e0f7794e06538543d0d474c7cb6c.jpg"
    ),
    VideoItem(
        videoUrl: 'https://gruzen.in/videos/video3.mp4',
        thumbnail: "https://i.pinimg.com/236x/4b/b4/e0/4bb4e0f7794e06538543d0d474c7cb6c.jpg"
    ),
    VideoItem(
        videoUrl: 'https://gruzen.in/videos/video4.mp4',
        thumbnail: "https://i.pinimg.com/236x/4b/b4/e0/4bb4e0f7794e06538543d0d474c7cb6c.jpg"
    ),
    VideoItem(
        videoUrl: 'https://gruzen.in/videos/video1.mp4',
        thumbnail: "https://i.pinimg.com/236x/4b/b4/e0/4bb4e0f7794e06538543d0d474c7cb6c.jpg"
    ),
    VideoItem(
        videoUrl: 'https://gruzen.in/videos/video2.mp4',
        thumbnail: "https://i.pinimg.com/236x/4b/b4/e0/4bb4e0f7794e06538543d0d474c7cb6c.jpg"
    ),
    VideoItem(
        videoUrl: 'https://gruzen.in/videos/video3.mp4',
        thumbnail: "https://i.pinimg.com/236x/4b/b4/e0/4bb4e0f7794e06538543d0d474c7cb6c.jpg"
    ),
    VideoItem(
        videoUrl: 'https://gruzen.in/videos/video4.mp4',
        thumbnail: "https://i.pinimg.com/236x/4b/b4/e0/4bb4e0f7794e06538543d0d474c7cb6c.jpg"
    ),
    VideoItem(
        videoUrl: 'https://gruzen.in/videos/video1.mp4',
        thumbnail: "https://i.pinimg.com/236x/4b/b4/e0/4bb4e0f7794e06538543d0d474c7cb6c.jpg"
    ),
    VideoItem(
        videoUrl: 'https://gruzen.in/videos/video2.mp4',
        thumbnail: "https://i.pinimg.com/236x/4b/b4/e0/4bb4e0f7794e06538543d0d474c7cb6c.jpg"
    ),
    VideoItem(
        videoUrl: 'https://gruzen.in/videos/video3.mp4',
        thumbnail: "https://i.pinimg.com/236x/4b/b4/e0/4bb4e0f7794e06538543d0d474c7cb6c.jpg"
    ),
    VideoItem(
        videoUrl: 'https://gruzen.in/videos/video4.mp4',
        thumbnail: "https://i.pinimg.com/236x/4b/b4/e0/4bb4e0f7794e06538543d0d474c7cb6c.jpg"
    ),
  ];

}
