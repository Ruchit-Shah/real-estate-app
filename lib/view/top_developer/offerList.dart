import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:real_estate_app/common_widgets/height.dart';
import 'package:real_estate_app/global/AppBar.dart';
import 'package:real_estate_app/global/app_color.dart';
import 'package:real_estate_app/global/constant.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/CustomBottomNavBar.dart';
import 'package:real_estate_app/view/property_screens/properties_list_screen/properties_list_screen.dart';
import 'package:real_estate_app/view/property_screens/recommended_properties_screen/properties_details_screen.dart';
import 'package:real_estate_app/view/top_developer/top_developer_details.dart';
import 'package:real_estate_app/view/top_developer/upcoming_project_deatils.dart';

import '../../../common_widgets/loading_dart.dart';
import '../../../global/api_string.dart';
import '../../common_widgets/custom_textformfield.dart';
import '../../utils/text_style.dart';
import '../dashboard/bottom_navbar_screens/search_screen/offer_details_screen.dart';
import '../property_screens/properties_controllers/post_property_controller.dart';
import '../property_screens/recommended_properties_screen/properties_list_screen.dart';
import '../splash_screen/splash_screen.dart';


class offerList extends StatefulWidget {

  const offerList({super.key});

  @override
  State<offerList> createState() => _offerListState();
}

class _offerListState extends State<offerList> {
  bool isDialogShowing = false;
  final PostPropertyController controller = Get.put(PostPropertyController());
  @override

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getOffer(isfrom: 'search',page: '1');

    });
    controller.scrollController.addListener(() {
      if (controller.scrollController.position.pixels >= controller.scrollController.position.maxScrollExtent - 100 &&
          !controller.isPaginationLoading.value &&
          controller.hasMore.value) {
        loadMoreData();
      }
    });
  }
  void loadMoreData() {
    if (controller.hasMore.value && !controller.isPaginationLoading.value) {
      controller.isPaginationLoading.value = true;

      final nextPage = (controller.currentPage.value + 1).toString();

      controller.getOffer(page: nextPage);
    }
  }



  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("All Offers",style: TextStyle(fontSize: 17),),
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 46,
        leading: Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.black, // Border color
                width: 0.1, // Border width
              ),
            ),
            child: InkWell(
              onTap: () {
                Get.back();
              },
              borderRadius: BorderRadius.circular(
                  50),
              child: const Padding(
                padding: EdgeInsets.all(6),
                child: Icon(
                  Icons.arrow_back_outlined,
                  size: 18,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ),
      body: controller.getOfferList.isNotEmpty && controller.getOfferList.isNotEmpty?

      Obx(() {
        if (controller.filteredOfferList.isEmpty && controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
            onRefresh: () async {
              controller.getOffer(isfrom: 'search',page: '1');
            },
            child:LazyLoadScrollView(
              onEndOfPage: () {
                if (controller.hasMore.value && !controller.isPaginationLoading.value) {
                  loadMoreData(); // Your existing method
                }else{
                  print("LazyLoadScrollView==>");
                  print(controller.hasMore.value);
                  print(controller.isPaginationLoading.value);
                }
              },
              isLoading: controller.isPaginationLoading.value,
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                controller: controller.scrollController,
                itemCount: controller.getOfferList.length + (controller.isPaginationLoading.value ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == controller.getOfferList.length) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  return GestureDetector(
                      onTap: () {
                        Get.to(OfferDetailsScreen(property: controller.getOfferList[index]));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 18.0, left: 18.0, right: 18.0),
                        child: Container(
                          width: Get.width,
                          height: Get.width * 0.7,
                          // margin: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColor.grey.withOpacity(0.1)),
                            color: AppColor.grey.shade50,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                                child: controller.getOfferList[index]['offer_img'] != null
                                    ? CachedNetworkImage(
                                  imageUrl: APIString.imageBaseUrl + controller.getOfferList[index]['offer_img'],
                                  fit: BoxFit.cover,
                                  width: Get.width,
                                  height: 200,
                                  placeholder: (context, url) => Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                )
                                    : Container(
                                  color: Colors.grey[400],
                                  width: Get.width,
                                  child: const Center(
                                    child: Icon(Icons.image_rounded),
                                  ),
                                ),
                              ),
                              // Bottom Half: Details
                              Expanded(

                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        controller.getOfferList[index]['offer_name'],
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      // const SizedBox(height: 5),
                                      // Text(
                                      //   controller.getOfferList[index]['offer_description'],
                                      //   style: const TextStyle(
                                      //     fontSize: 14,
                                      //     color: Colors.grey,
                                      //   ),
                                      //   maxLines: 3,
                                      //   overflow: TextOverflow.ellipsis,
                                      // ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                  );
                },
              ),
            )

        );
      })
          :
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/data.png',
              height: 40,
              width: 40,
            ),
            boxH08(),
            const Text(
              'No data available',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
          ],
        ),
      ),


    //  bottomNavigationBar: const CustomBottomNavBar(),
    );
  }

}

