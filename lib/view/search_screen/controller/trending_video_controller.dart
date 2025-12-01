import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../../../global/services/api_shorts_string.dart';
import '../../../global/services/network_http.dart';
import '../../../utils/common_snackbar.dart';
import '../../shorts/controller/my_profile_controller.dart';
import '../../shorts/controller/profile_videos_controller.dart';

class TrendingVideoController extends GetxController {
  late PageController pageController;
  RxBool isPlaying = false.obs;
  RxBool showProduct = false.obs;
  RxInt currentPage = 0.obs;
  RxBool isApiCallProcessing = true.obs;
  RxMap trendingVideosResponse = {}.obs;
  RxList trendingVideoResult = [].obs;
  RxList trendingVideosDataList = [].obs;
  RxInt trendingLastPage = 0.obs;
  RxInt trendingCurrentPageList = 1.obs;
  RxInt trendingNextPage = 1.obs;
  final ScrollController scrollController = ScrollController();
  RxBool isScreenViewVisible = false.obs;
  RxBool isSearching = false.obs;

  startVideo(){
    pageController = PageController(initialPage: currentPage.value);

    initializeVideoController(currentPage.value);

    pageController.addListener(() {
      int newPage = pageController.page!.toInt();
      if (newPage != currentPage.value) {
        trendingVideosDataList[currentPage.value]["controller"]!.pause();
        currentPage.value = newPage;
        initializeVideoController(newPage);

        if (trendingVideosDataList[newPage]["controller"] == null) {
          initializeVideoController(newPage);
        }
        else {
          if (trendingVideosDataList[newPage]["controller"]!.value.isInitialized) {
            trendingVideosDataList[newPage]["controller"]!.seekTo(Duration.zero);
            trendingVideosDataList[newPage]["controller"]!.play();
            update();
          }
        }
      }
    });
  }



  Future<void> initializeVideoController(int nextPage) async {
    if (trendingVideosDataList[nextPage]["controller"] == null) {
      print(APIShortsString.videoBaseUrl+trendingVideosDataList[nextPage]["video"]["video"]);
      trendingVideosDataList[nextPage]["controller"] = VideoPlayerController.networkUrl(Uri.parse("${APIShortsString.videoBaseUrl}${trendingVideosDataList[nextPage]["video"]["video"]}"));
      await trendingVideosDataList[nextPage]["controller"]!.initialize().whenComplete(() {
        Get.find<ProfileVideosController>().videoViewApi(videoId: trendingVideosDataList[nextPage]["video"]["_id"]);
        trendingVideosDataList[nextPage]["controller"]!.setLooping(true);
        if(isScreenViewVisible.value) {
          trendingVideosDataList[nextPage]["controller"]!.play();
        }
        else{
          trendingVideosDataList[nextPage]["controller"]!.pause();
        }
        update();
      });
    }
  }


  Future trendingVideosApi({
    int pageNumber = 1,
    int count = 10,
    bool isShowMoreCall = false,
  }) async {
    // showLoadingDialog();
    try {
      print('Get.find<MyProfileController>().userId.value   ==> ${Get.find<MyProfileController>().userId.value}');
      isApiCallProcessing.value = true;
      var response = await HttpHandler.postHttpMethod(
          url: APIShortsString.trending_videos, data: {
        "user_id": Get.find<MyProfileController>().userId.value,
        "count": count,
        "page_no": pageNumber,
      });
      log("trending_videos  :: response  :: userId.value  :: ${Get.find<MyProfileController>().userId.value}");
      log("trending_videos  :: response  :: count  :: $count");
      log("trending_videos  :: response  :: pageNumber  :: $pageNumber");
      trendingVideosResponse.value = response;
      isApiCallProcessing.value = false;
      log("trending_videos  :: response  :: ${response["body"]}");

      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          var respData = response['body'];
          print("trending_videos respData[last_page]   ${response['body']["last_page"]}");
          trendingLastPage.value = response['body']["last_page"];
          print("trending_videos respData[current_page]   ${response['body']["current_page"]}");
          trendingCurrentPageList.value = response['body']["current_page"];
          trendingNextPage.value = trendingCurrentPageList.value + 1;
          print("trending_videos isShowMoreCall   $isShowMoreCall");

          if (isShowMoreCall == true) {
            respData["data"].forEach((e) {
              print("e   +++++  $e");
              e["controller"] = null;
              var d = e;
              print("d   +++++  $d");
              // e["controller"]
              trendingVideosDataList.add(d);
            });
            print("trending_videos  add in existing $trendingVideosDataList");

          }
          else {
            respData["data"].forEach((element) {
              element["controller"] = null;
            });
            trendingVideosDataList.value = respData["data"];
            print("trending_videos  replace $trendingVideosDataList");
          }
        }
        else if (response['body']['status'].toString() == "0") {
          trendingVideosDataList.value = [];
          showSnackbar(message: response['body']['msg']);
        }
      } else if (response['error'] != null) {

        trendingVideosDataList.value = [];
      }
    }
    catch (e, s) {
      // hideLoadingDialog();
      debugPrint("myVideosApi Error -- $e  $s");
    }
  }

}
