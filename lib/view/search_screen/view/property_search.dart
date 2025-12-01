// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/global/services/api_shorts_string.dart';
import 'package:real_estate_app/view/search_screen/view/property_details_page.dart';
import '../../../common_widgets/height.dart';
import '../../../global/app_color.dart';
import '../../../global/theme/app_text_style.dart';
import '../../../global/widgets/common_textfield.dart';
import '../../shorts/view/user_profile.dart';
import '../controller/search_screen_controller.dart';

class PropertySearchScreen extends GetWidget<SearchScreenController> {
  const PropertySearchScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              boxH05(),
              CommonTextField(
                hintText: "Search accounts, property...",
                onTap: () {
                  // Get.to(()=>SignupScreen());
                },
                onChange: controller.onPropertySearchTextChanged,
              ),
              boxH10(),
              Expanded(
                  child: Obx(() =>
                  controller.psearchResponse.isEmpty || controller.psearchDataList.isEmpty
                      ? const Center(child: Text('No Search Results Found'))
                      : SingleChildScrollView(
                    child: Column(
                      children: [
                        // Text("controller.searchDataList   ${controller.searchDataList}"),
                        SizedBox(
                          // height: MediaQuery.of(context).size.height * 0.75,
                          child: Scrollbar(
                            controller: controller.scrollController,
                            thickness: 10,
                            thumbVisibility: true,
                            trackVisibility: true,
                            child:ListView.builder(
                              controller: controller.scrollController,
                              shrinkWrap: true,
                              itemCount: controller.psearchDataList.length,
                              itemBuilder: (context, i) {
                                var data = controller.psearchDataList[i];
                                return Column(
                                  children: [
                                    data["product_name"]!=null?
                                    InkWell(
                                      onTap: () {
                                        Get.to(property_details(data: data));
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(top: 10),
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
                                              child: data["product_image"][0]['product_images'] == null || data["product_image"][0]['product_images'].toString().isEmpty ?
                                              const Icon(Icons.location_city)
                                                  : CachedNetworkImage(
                                                imageUrl: APIShortsString.products_image + data["product_image"][0]['product_images'],
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.start,
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
                                                  if (data["city"] != null) ...[
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
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ):
                                    InkWell(
                                      onTap: (){
                                        Get.to(()=>UserProfileScreen(userData: data));
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(top: 10),
                                        child: Row(
                                          children: [
                                            Container(
                                              height: 60,width: 60,
                                              decoration:const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: AppColor.grey
                                              ),
                                              margin: const EdgeInsets.only(right: 15),
                                              child: data["profile_image"] == null || data["profile_image"].toString().isEmpty?
                                              const Icon(Icons.person)
                                                  :ClipOval(child: CachedNetworkImage(imageUrl: APIShortsString.profileImageBaseUrl+data["profile_image"] ,
                                                fit: BoxFit.cover,)),
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    data["full_name"].toString(),
                                                    style:AppTextStyle.bold.copyWith(fontSize: 18),
                                                  ),
                                                  boxH02(),
                                                  Text(
                                                    data["username"].toString(),
                                                    style:AppTextStyle.regular.copyWith(fontSize: 14),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),

                                    const Divider(thickness: 2,),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        controller.currentPage.toString() ==
                            controller.lastPage.toString()
                            ? const SizedBox()
                            : controller.isApiCallProcessing.value == true
                            ? const Text("Please wait while loading")
                            : InkWell(
                            onTap: () {
                              controller.searchPropertyDataApi(
                                  isShowMoreCall: true,
                                  keyword: controller.searchController.value.text,
                                  pageNumber: controller.nextPage.value);
                            },
                            child: const Text("Show More")),
                        const SizedBox(height: 40)
                      ],
                    ),
                  ))
              ),
            ],
          ),
        ),
      ),
    );
  }

}
