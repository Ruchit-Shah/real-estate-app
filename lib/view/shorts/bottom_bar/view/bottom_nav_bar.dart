
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/view/dashboard/view/BottomNavbar.dart';
import 'package:real_estate_app/view/shorts/bottom_bar/controller/shorts_bottom_bar_controller.dart';
import '../../../../Routes/app_pages.dart';
import '../../../../global/app_asset.dart';
import '../../../../global/app_color.dart';
import '../../../../utils/common_snackbar.dart';
import '../../../add_reel/view/create_reel.dart';
import '../../../dashboard/deshboard_controllers/bottom_bar_controller.dart';
import '../../../post_video/post_video.dart';
import '../../../post_video/post_video_controller.dart';
import '../../../post_video/upload_video_screen.dart';
import '../../../search_screen/controller/trending_video_controller.dart';
import '../../../search_screen/view/trending_videos.dart';
import '../../../splash_screen/splash_screen.dart';
import '../../controller/home_controller.dart';
import '../../controller/my_profile_controller.dart';
import '../../controller/profile_videos_controller.dart';
import '../../view/home_view.dart';
import '../../view/my_profile_screen.dart';


class BottomScreen extends StatefulWidget {
  bool fromEditReel;
  BottomScreen({super.key,this.fromEditReel = false});

  @override
  _BottomScreenState createState() => _BottomScreenState();
}

class _BottomScreenState extends State<BottomScreen> with WidgetsBindingObserver{
  final bottomBarController = Get.put(ShortsBottomBarController());
  final homeController = Get.find<HomeController>();
  final SearchController = Get.find<TrendingVideoController>();
  final profileVideosController = Get.put(ProfileVideosController());
  final myProfileController = Get.find<MyProfileController>();
  final addStoryController = Get.find<AddStoryController>();
  final mainbottomBarController = Get.put(BottomBarController());
  ValueNotifier<bool> isOpenDial = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    if(widget.fromEditReel == true){
      bottomBarController.selectedBottomIndex.value = 3;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    homeController.pageController.dispose();
    SearchController.pageController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _pauseCurrentVideo();
    }
  }

  void _pauseCurrentVideo() {
    if (homeController.homeVideosDataList.isNotEmpty) {
      var currentVideoData = homeController.homeVideosDataList[homeController.currentPage.value];
      var videoController = currentVideoData["controller"];

      if (videoController != null && videoController.value.isInitialized) {
        print("video controller getting paused");
        videoController.pause();
      } else {
        print("video controller not initialized");
      }
    }
  }

  Future<bool> _onWillPop() async {
    if (bottomBarController.selectedBottomIndex.value != 0) {
      setState(() {
        bottomBarController.selectedBottomIndex.value = 0;
      });
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(

                child: bottomBarController.selectedBottomIndex.value == 0
                    ? const HomeView()
                    :bottomBarController.selectedBottomIndex.value == 1
                         ? const TrendingVideos()
                   :bottomBarController.selectedBottomIndex.value == 2
                            ? const upload_video_screen()
                            : bottomBarController.selectedBottomIndex.value == 3
                                ? const MyProfileScreen()
                                : const SizedBox(),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          height: 50,
          decoration: BoxDecoration(
            color: AppColor.grey.shade50,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                spreadRadius: 0,
                blurRadius: 8,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child:
            Obx(()=>
                BottomNavigationBar(
                  elevation: 0,
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: Colors.transparent,
                  selectedItemColor: AppColor.blueGrey,
                  unselectedItemColor: AppColor.black.withOpacity(0.5),
                  currentIndex: bottomBarController.selectedBottomIndex.value,
                  onTap: handleTabTap,
                  selectedLabelStyle: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColor.blueGrey,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.normal,
                    color: AppColor.black.withOpacity(0.5),
                  ),
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home, size: 20),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.search, size: 20),
                      label: 'Search',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.add_circle_outline, size: 20),
                      label: 'Add',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.video_collection, size: 20),
                      label: 'My Videos',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.backspace, size: 20),
                      label: 'Back',
                    ),
                  ],
                ),
            ),
        ),
      ),
    );
  }

  Widget buildSpeedDial() {
    return SpeedDial(
      icon: Icons.add,
      buttonSize: const Size(50.0, 50.0),
      activeIcon: Icons.close,
      backgroundColor: Colors.blueGrey,
      foregroundColor: Colors.white,
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      elevation: 8.0,
      spacing: 8.0,
      openCloseDial: isOpenDial,
      children: [
        SpeedDialChild(
          child: Image.asset(
            AppAsset.reel,
            height: 25,
            width: 25,
          ),
          backgroundColor: Colors.orange,
          label: 'Reel',
          labelStyle: const TextStyle(fontSize: 18.0),
          onTap: () {
            if (isLogin == false) {
              showSnackbar(message: "Login Required!");
            }
            else {
              setState(() {
                if(homeController.homeVideosDataList.isNotEmpty) {
                  homeController
                    .homeVideosDataList[homeController.currentPage.value]
                        ["controller"]!
                    .pause();
                }
                Get.to(() => const CreateReel())!.whenComplete(() {
                  if (bottomBarController.selectedBottomIndex.value == 0) {
                    if(homeController.homeVideosDataList.isNotEmpty) {
                      homeController
                        .homeVideosDataList[homeController.currentPage.value]
                            ["controller"]!
                        .play();
                    }
                  }
                });
              });
            }
          },
        ),
      ],
    );
  }

  void handleTabTap(int index) async {
    print('index  ====> $index');
    setState(() {
      bottomBarController.selectedBottomIndex.value = index;
    });
    if(bottomBarController.selectedBottomIndex.value==4){
      //homeController.homeVideosDataList[homeController.currentPage.value]["controller"]!.pause();
      Get.offAll(BottomNavbar());
      mainbottomBarController.fromPage.value='Home';
    }
    if (bottomBarController.selectedBottomIndex.value != 0)
    {
      if (homeController.homeVideosDataList.isNotEmpty) {
        print("Pausing video controller");
        homeController.homeVideosDataList[homeController.currentPage.value]["controller"]!.pause();
      }
    } else {
      homeController.currentPage.value = 0;
      if (homeController.pageController != null) {
        if (homeController.pageController.hasClients) {
          homeController.pageController.animateToPage(
            0,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          ).then((_) {
            if (homeController.homeVideosDataList.isNotEmpty) {
              homeController.homeVideosDataList[0]["controller"]?.play();
            }
          });
        }
        else {
          homeController.pageController.animateToPage(
            0,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      }
    }

    if (bottomBarController.selectedBottomIndex.value == 2) {
      if (isLogin == false) {
        showSnackbar(message: "Login Required!");
      } else {
        setState(() async {
          if (homeController.homeVideosDataList.isNotEmpty) {
            homeController.homeVideosDataList[homeController.currentPage.value]["controller"]!.pause();
          }
          await addStoryController.pickFile(onlyVideos: true);
          if (addStoryController.videoFile != null) {
            print("controller.videoFile   ${addStoryController.videoFile}");
            setState(() {});
            routeUpload();
          }
        });
      }
    }

    if (bottomBarController.selectedBottomIndex.value == 4) {
      profileVideosController.myVideosApi(
        isShowMoreCall: false,
        pageNumber: 1,
      );
    }

    if (isLogin == false) {
      showSnackbar(message: "Login Required");
      bottomBarController.selectedBottomIndex.value = 0;
      if (homeController.homeVideosDataList.isNotEmpty) {
        homeController.homeVideosDataList[homeController.currentPage.value]["controller"]!.pause();
      }
      Get.toNamed(Routes.login)!.whenComplete(() {
        bottomBarController.selectedBottomIndex.value = 0;
        if (homeController.homeVideosDataList.isNotEmpty) {
          homeController.homeVideosDataList[homeController.currentPage.value]["controller"]!.play();
        }
      });
    }
  }


  void routeUpload() {
    print("controller.videoFile!.path  ${addStoryController.videoFile.value!.path}");
    File file = File(addStoryController.videoFile.value!.path);
    Get.to(() => PostVideoScreen(
      videoFile: file.path,
    ));
  }
}

