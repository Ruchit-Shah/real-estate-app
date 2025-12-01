
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:real_estate_app/global/app_color.dart';
import 'package:real_estate_app/global/services/api_shorts_string.dart';
import 'package:video_player/video_player.dart';
import '../../../global/api_string.dart';
import '../../../global/services/api_response.dart';
import '../../../global/services/network_http.dart';
import '../../../utils/String_constant.dart';
import '../../../utils/shared_preferences/shared_preferances.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

class HomeController extends GetxController {
  ApiResponse getDummyApiResponse = ApiResponse.initial('Initial');
  RxBool isHomePgaeActive = false.obs;
  Rxn<DateTime> fromDate = Rxn<DateTime>();
  Rxn<DateTime> toDate = Rxn<DateTime>();


  @override
  void onInit() {
    super.onInit();
    fromDate.value = DateTime.now();
    toDate.value = DateTime.now().add(const Duration(days: 6));
  }

  @override
  void onClose() {
    pageController.dispose();
    if(homeVideosDataList.isNotEmpty) {
      homeVideosDataList.forEach((item) {
      item["controller"]?.dispose();
    });
    }
    super.onClose();
  }

  // Method to pause the current video
  void pauseCurrentVideo() {
    if (homeVideosDataList.isNotEmpty) {
      homeVideosDataList[currentPage.value]["controller"]?.pause();
    }
  }

  // Method to resume the current video
  void resumeCurrentVideo() {
    if (homeVideosDataList.isNotEmpty) {
      homeVideosDataList[currentPage.value]["controller"]?.play();
    }
  }

  Future<void> selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      initialDateRange: DateTimeRange(
        start: fromDate.value!,
        end: toDate.value!,
      ),
      helpText: 'Select a range (max 7 days)',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColor.lightPurple,
              secondary: Color(0xffD7A1F9),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final difference = picked.end.difference(picked.start).inDays + 1;

      if (difference > 7) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a range of 7 days or less'),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 2),
          ),
        );

        await Future.delayed(const Duration(milliseconds: 0));
        await selectDateRange(context); // Reopen it
        return;
      }

      fromDate.value = picked.start;
      toDate.value = picked.end;
    }
  }


  /// video page
  late PageController pageController;
  RxBool isPlaying = false.obs;
  RxBool showProduct = false.obs;
  RxInt currentPage = 0.obs;
  RxBool isHomeViewVisible = false.obs;

  Future<void> initializeVideoController(int nextPage) async {
    final videoData = homeVideosDataList[nextPage];

    if (videoData["controller"] == null) {
      try {
        final controller = VideoPlayerController.network(
            "${APIString.videoBaseUrl}${videoData["video"]["video"]}");

        // Initialize the controller
        await controller.initialize();
        controller.setLooping(true);

        // Update the data list with the initialized controller
        videoData["controller"] = controller;

        // Manage playback state based on visibility
        if (isHomeViewVisible.value) {
          controller.play();
        } else {
          controller.pause();
        }

        // Notify listeners if needed
        update();
      } catch (e) {
        // Handle errors appropriately
        debugPrint("Error initializing video controller: $e");
      }
    }
  }
  ///
  final commentController = TextEditingController();
  RxBool likeButton = false.obs;


  RxList<Map<String,dynamic>> productImages = <Map<String,dynamic>>[
    {
      "images" :[
      "https://i.pinimg.com/236x/ef/af/5d/efaf5d571a19295c5735fdd49c88241b.jpg",
    "https://i.pinimg.com/236x/ad/ed/df/adeddf9547a994317fcec0fcf1ffbe9d.jpg",
    "https://i.pinimg.com/236x/e5/f2/31/e5f23187e4dab14bc0759d58f73f21f2.jpg",
    "https://i.pinimg.com/236x/1a/c9/83/1ac983c82295404fa862370376bfdc3f.jpg",
    "https://i.pinimg.com/236x/50/96/6d/50966d39333866b29b919ddf47ec8c0f.jpg",
    ]},
    {
      "images" :[
      "https://i.pinimg.com/236x/3d/c4/b1/3dc4b166117d8f665b5681bdbf4af4cc.jpg",
    "https://i.pinimg.com/236x/9f/98/8e/9f988e6241775a3e5669d75d2f08eaa3.jpg",
    "https://i.pinimg.com/236x/77/48/bb/7748bb4ea8f5e75c3163a0a64d5fa9f0.jpg",
    "https://i.pinimg.com/236x/35/d1/8d/35d18ddad8a430579e091e2f6e7f45b6.jpg",
    "https://i.pinimg.com/236x/5b/23/6a/5b236a1e14790d4dfdf5466bc6c6f875.jpg",
    ]},
    {
      "images" :[
      "https://i.pinimg.com/236x/53/80/3b/53803b662707583b9fa8c6f9515bf720.jpg",
    "https://i.pinimg.com/236x/53/4e/b7/534eb7c2b31964edb83bfa983003f358.jpg",
    "https://i.pinimg.com/236x/03/0b/48/030b48a6748336724be05e282e580e1a.jpg",
    "https://i.pinimg.com/236x/71/34/bb/7134bb5b8c283f933dc7a9dbac5c3f7c.jpg",
    "https://i.pinimg.com/236x/8f/1e/85/8f1e857bd58786383dae2b16f6682df9.jpg",
    ]},
    {
      "images" :[
      "https://i.pinimg.com/236x/07/90/49/079049b1eb75a6c5775f898e531aba2e.jpg",
    "https://i.pinimg.com/236x/c8/53/9d/c8539d1d7723bde93c5b8fea6aafa57e.jpg",
    "https://i.pinimg.com/236x/8f/a4/5a/8fa45a7c2fe972f03f828cf2c45d272c.jpg",
    "https://i.pinimg.com/236x/4a/6b/e5/4a6be565b0d53a5d06c92eff666bf9a7.jpg",
    "https://i.pinimg.com/236x/a0/52/1f/a0521faf4f05cbe5dabd0deeb26c0a33.jpg",
    ]},
    {
      "images" :[
      "https://i.pinimg.com/236x/f1/b7/49/f1b7491410f80817cbe98424c6feed85.jpg",
    "https://i.pinimg.com/236x/8e/04/02/8e04022054d9e8787aa96a56feb0ca02.jpg",
    "https://i.pinimg.com/236x/c7/ef/4f/c7ef4f03e6cc1ebd2cc3cf5faaf7f53a.jpg",
    "https://i.pinimg.com/236x/24/c9/77/24c97716aa2708e3c7df179c0331103c.jpg",
    "https://i.pinimg.com/236x/e6/62/a4/e662a449914a661a2485777ca016bfcb.jpg",
    ]},
  ].obs;


  ///api videos
  RxBool isApiCallProcessing = true.obs;
  RxMap homeVideosResponse = {}.obs;
  RxList homeVideoResult = [].obs;
  RxList homeVideosDataList = [].obs;
  RxInt homeLastPage = 0.obs;
  RxInt homeCurrentPageList = 1.obs;
  RxInt homeNextPage = 1.obs;
  final ScrollController scrollController = ScrollController();

  Future<void> homeVideosApi({
    int pageNumber = 1,
    int count = 4,
    bool isShowMoreCall = false,
  }) async {
    try {
      if (!isShowMoreCall) {
        homeVideosDataList.clear();
      }
      String? userId = await SPManager.instance.getUserId(USER_ID);
      isApiCallProcessing.value = true;

      var response = await HttpHandler.postHttpMethod(
        url: APIShortsString.trending_videos,
        data: {
          "user_id": userId,
          "count": count,
          "page_no": pageNumber,
        },
      );

      isApiCallProcessing.value = false;
      log("trending_videos API Response: ${response["body"]}");

      if (response['error'] == null && response['body']['status'].toString() == "1") {
        var respData = response['body'];
        homeLastPage.value = respData["last_page"];
        homeCurrentPageList.value = respData["current_page"];
        homeNextPage.value = homeCurrentPageList.value + 1;

        if (isShowMoreCall) {
          respData["data"].forEach((e) {
            e["controller"] = null; // Ensure new items have no controller
            homeVideosDataList.add(e);
          });
        } else {
          respData["data"].forEach((element) {
            element["controller"] = null; // Ensure new items have no controller
          });
          homeVideosDataList.value = respData["data"];
        }
      } else {
        homeVideosDataList.value = [];
        Fluttertoast.showToast(msg: response['body']['msg'] ?? 'No videos');
      }
    } catch (e, s) {
      isApiCallProcessing.value = false;
      debugPrint("API Error: $e, StackTrace: $s");
    }
  }






}
