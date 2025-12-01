import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/view/search_screen/view/property_details_page.dart';
import 'package:real_estate_app/view/search_screen/view/video_player_item.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../../common_widgets/height.dart';
import '../../../global/app_color.dart';
import '../../../global/app_string.dart';
import '../../../global/services/api_shorts_string.dart';
import '../../../global/theme/app_text_style.dart';
import '../../../global/widgets/common_textfield.dart';
import '../../../global/widgets/dummy_reel_ui.dart';
import '../../shorts/controller/profile_videos_controller.dart';
import '../../shorts/view/user_profile.dart';
import '../controller/search_screen_controller.dart';
import '../controller/trending_video_controller.dart';

class TrendingVideos extends StatefulWidget {
  const TrendingVideos({super.key});

  @override
  State<TrendingVideos> createState() => _TrendingVideosState();
}

class _TrendingVideosState extends State<TrendingVideos> {
  final trendingVideoController = Get.find<TrendingVideoController>();
  final profileVideosController = Get.find<ProfileVideosController>();
  final controller = Get.find<SearchScreenController>();
  bool isTabActive = true;
  @override
  void initState() {
    super.initState();
    controller.psearchDataList.clear();
    trendingVideoController.isSearching.value=false;

    trendingVideoController.trendingVideosDataList.clear();
    trendingVideoController.trendingVideosApi(isShowMoreCall: true, pageNumber: 1,)
        .then((value) {
      if (trendingVideoController.trendingVideosDataList.isNotEmpty) {
        trendingVideoController.pageController = PageController(
            initialPage: trendingVideoController.currentPage.value);

        trendingVideoController.initializeVideoController(
            trendingVideoController.currentPage.value);

        trendingVideoController.pageController.addListener(() {
          int newPage = trendingVideoController.pageController.page!.toInt();
          if (newPage != trendingVideoController.currentPage.value) {
            trendingVideoController.trendingVideosDataList[

              trendingVideoController.currentPage.value]["controller"]
                ?.pause();
            trendingVideoController.currentPage.value = newPage;
            trendingVideoController.initializeVideoController(newPage);
            if (trendingVideoController.trendingVideosDataList[newPage]
                    ["controller"] ==
                null) {
              trendingVideoController.initializeVideoController(newPage);
            } else {
              if (trendingVideoController
                  .trendingVideosDataList[newPage]["controller"]!
                  .value
                  .isInitialized) {
                trendingVideoController.trendingVideosDataList[newPage]
                        ["controller"]!
                    .seekTo(Duration.zero);
                trendingVideoController.trendingVideosDataList[newPage]
                        ["controller"]!
                    .play();
                // update();
              }
            }
          }
        });

        Future.delayed(const Duration(seconds: 5),
            () => trendingVideoController.showProduct.value = true);
      }
    });
  }
  @override
  void dispose() {
    trendingVideoController.pageController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      // key: const Key('trending-page-visibility-key'),
      key: const Key(AppString.trendingPageVisibilityKey),
      onVisibilityChanged: (visibilityInfo) async{
        if(visibilityInfo.visibleFraction > 0.0){
          print("search trending page visible ===> true");

          if(trendingVideoController.trendingVideosDataList.isNotEmpty && isTabActive) {
            await trendingVideoController.trendingVideosDataList[trendingVideoController.currentPage.value]["controller"]!.play();
          }
        }else{
          print("search trending page visible ===> false");

          if(trendingVideoController.trendingVideosDataList.isNotEmpty) {
            await trendingVideoController.trendingVideosDataList[trendingVideoController.currentPage.value]["controller"]!.pause();
          }
        }
      },
      child:
      SafeArea(
        child: Stack(
          children: [
            // Video Player Section
            GetBuilder<TrendingVideoController>(
              init: TrendingVideoController(),
              builder: (getController) {
                return trendingVideoController.trendingVideosDataList.isEmpty
                    ? dummyReelUi()
                    : PageView.builder(

                  controller: getController.pageController,
                  itemCount: getController.trendingVideosDataList.length,
                  scrollDirection: Axis.vertical,
                  onPageChanged: (value) {
                    Get.find<TrendingVideoController>()
                        .showProduct
                        .value = true;
                    profileVideosController.videoViewApi();
                  },
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () async {
                        if (getController.trendingVideosDataList[
                        getController.currentPage.value]
                        ["controller"] !=
                            null &&
                            getController
                                .trendingVideosDataList[getController
                                .currentPage.value]["controller"]!
                                .value
                                .isPlaying) {
                          getController.isPlaying.value = true;
                          Future.delayed(
                              const Duration(milliseconds: 400), () {
                            getController.isPlaying.value = false;
                          });
                          await getController.trendingVideosDataList[
                          getController.currentPage.value]
                          ["controller"]!
                              .pause();
                        } else {
                          getController.isPlaying.value = true;
                          Future.delayed(
                              const Duration(milliseconds: 400), () {
                            getController.isPlaying.value = false;
                          });
                          if (getController
                              .trendingVideosDataList[getController
                              .currentPage.value]["controller"]!
                              .value
                              .isInitialized) {
                            await getController.trendingVideosDataList[getController.currentPage.value]["controller"]!.play();

                            ///don't remove this line
                            // getController.initializeVideoController(getController.currentPage.value + 1); // Initialize the next video
                          }
                        }
                      },
                      child: getController.trendingVideosDataList[index]
                      ["controller"] !=
                          null
                          ? TrendingVideoPlayerItem(
                        fromScreen: AppString.fromTrendingVideo,
                        videoData: getController
                            .trendingVideosDataList[index],
                        controller: getController
                            .trendingVideosDataList[index]
                        ["controller"]!,
                        indexVideo: index,
                        list: getController.trendingVideosDataList,
                      )
                          : Container(
                        height: Get.height,
                        width: Get.width,
                        color: AppColor.black,
                        child: const Center(
                            child: CircularProgressIndicator()),
                      ),
                    );
                  },
                );
              },
            ),

            // Search Results Section
            Obx(() {
              bool isSearching = trendingVideoController.isSearching.value;
              List searchDataList = controller.psearchDataList;

              return Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                   // color: isSearching  ?Colors.white:null ,
                  child:  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: isSearching
                            ?
                        EdgeInsets.only(left: 3.0,right:3.0,top: 8.0):  EdgeInsets.only(left: 3.0,right:3.0,top: 8.0),

                        child: CommonTextField(

                          hintText: "Search BHK type, city, user name",

                          suffixIcon:isSearching
                              ? InkWell(
                            onTap: (){
                              controller.psearchDataList.clear();
                              trendingVideoController.isSearching.value = false;
                              Get.find<TrendingVideoController>().trendingVideosDataList.forEach((videoData) {
                                if (videoData["controller"] != null && videoData["controller"]!.value.isPaused) {
                                  videoData["controller"]!.play();
                                }
                                  });
                                },

                              child: const Icon(Icons.cancel,color: Colors.black,size: 20,)):
                          const Icon(Icons.search,color: Colors.black,size: 20,),
                          onTap: () {
                            if (Get.find<TrendingVideoController>().trendingVideosDataList.isNotEmpty) {
                              Get.find<TrendingVideoController>().trendingVideosDataList.forEach((videoData) {
                                if (videoData["controller"] != null && videoData["controller"]!.value.isPlaying) {
                                  videoData["controller"]!.pause();
                                }
                              });
                            }
                          },
                          onChange: (value) {
                            setState(() {
                              controller.onPropertySearchTextChanged(value);
                            });
                            trendingVideoController.isSearching.value = true;
                            if (Get.find<TrendingVideoController>().trendingVideosDataList.isNotEmpty) {
                              Get.find<TrendingVideoController>().trendingVideosDataList.forEach((videoData) {
                                if (videoData["controller"] != null && videoData["controller"]!.value.isPlaying) {
                                  videoData["controller"]!.pause();
                                }
                              });
                            }
                          },
                        ),
                      ),
                      // boxH10(),
                      isSearching ?
                      Expanded(
                        child: searchDataList.isEmpty
                            ? const Center(child: Text('No Search Results Found'))
                            : ListView.builder(
                          controller: controller.scrollController,
                          itemCount: searchDataList.length,
                          itemBuilder: (context, i) {
                            var data = searchDataList[i];
                            return Padding(
                              padding: const EdgeInsets.only(left: 3.0,right: 3.0),
                              child: Container(
                                color: isSearching  ?Colors.white:Colors.transparent ,
                                child: Column(
                                  children: [
                                    data["product_name"] != null
                                        ? InkWell(
                                      onTap: () {
                                        if (Get.find<TrendingVideoController>().trendingVideosDataList.isNotEmpty) {
                                          Get.find<TrendingVideoController>().trendingVideosDataList.forEach((videoData) {
                                            if (videoData["controller"] != null && videoData["controller"]!.value.isPlaying) {
                                              videoData["controller"]!.pause();
                                            }
                                          });
                                        }
                                        Get.to(property_details(data: data));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          color: Colors.white,

                                          child: Row(
                                            children: [
                                              Container(
                                                height: 60,
                                                width: 60,
                                                margin: const EdgeInsets.only(right: 15),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.rectangle,
                                                  color: AppColor.grey,
                                                  borderRadius: BorderRadius.circular(20),
                                                ),
                                                child: data["product_image"][0]['product_images'] == null ||
                                                    data["product_image"][0]['product_images'].toString().isEmpty
                                                    ? const Icon(Icons.location_city)
                                                    : CachedNetworkImage(
                                                  imageUrl: APIShortsString.products_image + data["product_image"][0]['product_images'],
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      data["product_name"].toString(),
                                                      style: AppTextStyle.bold.copyWith(fontSize: 16),
                                                    ),
                                                    SizedBox(height: 2),
                                                    Text(
                                                      '₹${data["product_price"]}',
                                                      style: const TextStyle(color: Colors.blue, fontSize: 14, fontWeight: FontWeight.w600),
                                                    ),
                                                    SizedBox(height: 2),
                                                    if (data["city"] != null)
                                                      Row(
                                                        children: [
                                                          Icon(Icons.location_on, size: 15),
                                                          SizedBox(width: 5),
                                                          Text(
                                                            data["city"].toString(),
                                                            style: AppTextStyle.bold.copyWith(fontSize: 14),
                                                          ),
                                                        ],
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                        : InkWell(
                                      onTap: () {
                                        if (Get.find<TrendingVideoController>().trendingVideosDataList.isNotEmpty) {
                                          Get.find<TrendingVideoController>().trendingVideosDataList.forEach((videoData) {
                                            if (videoData["controller"] != null && videoData["controller"]!.value.isPlaying) {
                                              videoData["controller"]!.pause();
                                            }
                                          });
                                        }
                                        Get.to(() => UserProfileScreen(userData: data));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Container(
                                          color: Colors.white,

                                          child: Row(
                                            children: [
                                              Container(
                                                height: 60,
                                                width: 60,
                                                decoration: const BoxDecoration(
                                                    shape: BoxShape.circle, color: AppColor.grey),
                                                margin: const EdgeInsets.only(right: 15),
                                                child: data["profile_image"] == null || data["profile_image"].toString().isEmpty
                                                    ? const Icon(Icons.person)
                                                    : ClipOval(
                                                  child: CachedNetworkImage(
                                                    imageUrl: APIShortsString.profileImageBaseUrl + data["profile_image"],
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      data["full_name"].toString(),
                                                      style: AppTextStyle.bold.copyWith(fontSize: 18),
                                                    ),
                                                    boxH02(),
                                                    Text(
                                                      data["username"].toString(),
                                                      style: AppTextStyle.regular.copyWith(fontSize: 14),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Divider(thickness: 2),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ):SizedBox(),
                    ],
                  )
                ),
              );
            }),
          ],
        ),
      )
    );
  }
}
