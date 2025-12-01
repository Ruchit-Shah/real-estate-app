import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/view/shorts/view/video_player_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../../global/app_color.dart';
import '../../../global/app_string.dart';
import '../../../global/widgets/dummy_reel_ui.dart';
import '../../dashboard/deshboard_controllers/bottom_bar_controller.dart';
import '../../splash_screen/splash_screen.dart';
import '../controller/home_controller.dart';
import '../controller/my_profile_controller.dart';
import '../controller/profile_videos_controller.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with WidgetsBindingObserver {
  final homeController = Get.find<HomeController>();
  final profileVideosController = Get.find<ProfileVideosController>();
  final myProfileController = Get.put(MyProfileController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Get.lazyPut(() => BottomBarController());
    homeController.homeVideosApi(
      isShowMoreCall: true,
      pageNumber: 1,
    ).then((value) {
      if (homeController.homeVideosDataList.isNotEmpty) {
        homeController.pageController = PageController(initialPage: homeController.currentPage.value);
        homeController.initializeVideoController(homeController.currentPage.value);

        Future.delayed(const Duration(seconds: 5), () {
          homeController.showProduct.value = true;
        });
      }
    });

    myProfileController.getProfileApi();

  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    //homeController.pageController.dispose();

    super.dispose();
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {

    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      _pauseCurrentVideo();
    }
  }

  void _pauseCurrentVideo() {
    if (homeController.homeVideosDataList.isNotEmpty) {
      homeController.homeVideosDataList[homeController.currentPage.value]["controller"]?.pause();
    }
  }

  void _handleVideoPageChange(int newPage) {
    homeController.homeVideosDataList[homeController.currentPage.value]["controller"]?.pause();
    homeController.currentPage.value = newPage;
    homeController.initializeVideoController(newPage);
    if (homeController.homeVideosDataList[newPage]["controller"] == null) {
      homeController.initializeVideoController(newPage);
    } else {
      if (homeController.homeVideosDataList[newPage]["controller"]!.value.isInitialized) {
        homeController.homeVideosDataList[newPage]["controller"]!.seekTo(Duration.zero);
        homeController.homeVideosDataList[newPage]["controller"]!.play();
      }
    }
  }

  // void getCartDetails() {
  //
  //   Future.delayed(const Duration(seconds: 5), () {
  //     if (isLogin == true) {
  //       Get.find<CartController>().getCartDetails();
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key(AppString.homePageVisibilityKey),
      onVisibilityChanged: (visibilityInfo) async {
        if (visibilityInfo.visibleFraction > 0.0) {
          // Home page becomes visible, resume video playback if necessary
          homeController.isHomeViewVisible.value = true;
          if (homeController.homeVideosDataList.isNotEmpty && homeController.isHomeViewVisible.value) {
            await homeController.homeVideosDataList[homeController.currentPage.value]["controller"]?.play();
          }
        } else {
          // Home page becomes invisible, pause video playback
          homeController.isHomeViewVisible.value = false;
          _pauseCurrentVideo();
        }
      },
      child: SafeArea(
        child: Stack(
          children: [
            GetBuilder<HomeController>(
              init: HomeController(),
              builder: (getController) {
                return homeController.homeVideosDataList.isEmpty
                    ? dummyReelUi() :
                PageView.builder(
                  controller: getController.pageController,
                  itemCount: getController.homeVideosDataList.length,
                  scrollDirection: Axis.vertical,
                  onPageChanged: (value) {
                    _handleVideoPageChange(value);
                    Get.find<HomeController>().showProduct.value = true;
                    profileVideosController.videoViewApi();
                  },
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () async {
                        _toggleVideoPlayback();
                      },
                      child: getController.homeVideosDataList[index]["controller"] != null
                          ? VisibilityDetector(
                        key: Key(getController.homeVideosDataList[index]["videoId"].toString()),
                        onVisibilityChanged: (visibilityInfo) {
                          if (visibilityInfo.visibleFraction == 1) {
                            getController.homeVideosDataList[index]["controller"]?.play();
                          } else {
                            getController.homeVideosDataList[index]["controller"]?.pause();
                          }
                        },
                        child: VideoPlayerItem(
                          fromScreen: AppString.fromFollowingVideo,
                          videoData: getController.homeVideosDataList[index],
                          controller: getController.homeVideosDataList[index]["controller"]!,
                          indexVideo: index,
                          list: getController.homeVideosDataList,
                        ),
                      )
                          : Container(
                        height: Get.height,
                        width: Get.width,
                        color: AppColor.grey,
                        child: const Center(child: CircularProgressIndicator(color: Colors.blue,)),
                      ),
                    );
                  },
                );
              },
            ),
            isLogin == false
                ? const SizedBox()
                : Column(
              children: [
                // Add your additional UI components here
                // Example: boxH02(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return VisibilityDetector(
  //     key: const Key(AppString.homePageVisibilityKey),
  //     onVisibilityChanged: (visibilityInfo) async {
  //       if (visibilityInfo.visibleFraction > 0.0) {
  //
  //         homeController.isHomeViewVisible.value = true;
  //         final currentVideo = homeController.homeVideosDataList[homeController.currentPage.value];
  //         if (currentVideo["controller"] != null) {
  //           await currentVideo["controller"]?.play();
  //         }
  //       } else {
  //
  //         homeController.isHomeViewVisible.value = false;
  //         final currentVideo = homeController.homeVideosDataList[homeController.currentPage.value];
  //         currentVideo["controller"]?.pause();
  //       }
  //     },
  //     child: SafeArea(
  //       child: Stack(
  //         children: [
  //           GetBuilder<HomeController>(
  //             init: HomeController(),
  //             builder: (getController) {
  //               return getController.homeVideosDataList.isEmpty
  //                   ? dummyReelUi()
  //                   : PageView.builder(
  //                 controller: getController.pageController,
  //                 itemCount: getController.homeVideosDataList.length,
  //                 scrollDirection: Axis.vertical,
  //                 onPageChanged: (value) {
  //                   _handleVideoPageChange(value);
  //                   Get.find<HomeController>().showProduct.value = true;
  //                   profileVideosController.videoViewApi();
  //                 },
  //                 itemBuilder: (context, index) {
  //                   final videoData = getController.homeVideosDataList[index];
  //                   return GestureDetector(
  //                     onTap: () async {
  //                       _toggleVideoPlayback();
  //                     },
  //                     child: videoData["controller"] != null
  //                         ? VideoPlayerItem(
  //                       fromScreen: AppString.fromFollowingVideo,
  //                       videoData: videoData,
  //                       controller: videoData["controller"]!,
  //                       indexVideo: index,
  //                       list: getController.homeVideosDataList,
  //                     )
  //                         : Container(
  //                       height: Get.height,
  //                       width: Get.width,
  //                       color: AppColor.black,
  //                       child: const Center(
  //                         child: CircularProgressIndicator(color: Colors.blue),
  //                       ),
  //                     ),
  //                   );
  //                 },
  //               );
  //             },
  //           ),
  //           if (!isLogin)
  //             const SizedBox()
  //           else
  //             Column(
  //               children: [
  //
  //               ],
  //             ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  void _toggleVideoPlayback() async {
    if (homeController.homeVideosDataList.isNotEmpty &&
        homeController.homeVideosDataList[homeController.currentPage.value]["controller"] != null) {
      if (homeController.homeVideosDataList[homeController.currentPage.value]["controller"]!.value.isPlaying) {

        await homeController.homeVideosDataList[homeController.currentPage.value]["controller"]!.pause();
      } else {

        if (homeController.homeVideosDataList[homeController.currentPage.value]["controller"]!.value.isInitialized) {
          await homeController.homeVideosDataList[homeController.currentPage.value]["controller"]!.play();
        }
      }
    }
  }
}

class VideoCache {
  static Future<void> saveVideoData(List videos) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('cached_videos', jsonEncode(videos));
  }

  static Future<List<Map<String, dynamic>>> getCachedVideos() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString('cached_videos');
    if (cachedData != null) {

      List<dynamic> decodedList = jsonDecode(cachedData);
      return decodedList.map((item) => Map<String, dynamic>.from(item)).toList();
    }
    return [];
  }

  static Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('cached_videos');
  }
}

