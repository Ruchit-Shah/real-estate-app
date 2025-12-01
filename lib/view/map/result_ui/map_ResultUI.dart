import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/common_widgets/height.dart';
import 'package:real_estate_app/global/app_color.dart';
import 'package:real_estate_app/view/auth/login_screen/login_screen.dart';
import 'package:real_estate_app/view/property_screens/properties_controllers/post_property_controller.dart';
import '../../../global/api_string.dart';
import '../../../utils/network_http.dart';
import '../../dashboard/bottom_navbar_screens/profile_screen/profile_section_screens/my_virtual_tour/GetScheduleBottomSheet.dart';
import '../../dashboard/bottom_navbar_screens/search_screen/searchController.dart';
import '../../property_screens/recommended_properties_screen/properties_details_screen.dart';
import '../../splash_screen/splash_screen.dart';
class MapResultUi extends StatefulWidget {
  final bool isAPIcall;
  final bool clear;
  final String property_category_type;
  final String category_price_type;
  final String property_type;
  final String bhk_type;
  final String city_name;
  final String properties_latitude;
  final String properties_longitude;

  const MapResultUi({
    super.key,
    required this.isAPIcall,
    required this.clear,
    required this.property_category_type,
    required this.category_price_type,
    required this.property_type,
    required this.bhk_type,
    required this.city_name,
    required this.properties_latitude,
    required this.properties_longitude,
  });

  @override
  State<MapResultUi> createState() => _MapResultUiState();
}

class _MapResultUiState extends State<MapResultUi> {
  final ScrollController _controllerOne = ScrollController();
  final PostPropertyController controller = Get.find();
  final int _pageSize = 10;

  @override
  void initState() {
    super.initState();
    if (widget.clear) {
      controller.clearSearchData();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {

      if(widget.isAPIcall==true){
        controller.getLocationSearchData(
          widget.properties_latitude,
          widget.properties_longitude,
          "1",
          _pageSize.toString(),
          widget.property_category_type,
          widget.category_price_type,
          widget.property_type,
          widget.bhk_type,
          widget.city_name,

          reset: widget.clear,
        );
      }


    });

    if(widget.isAPIcall==true){
      _controllerOne.addListener(() {
        if (_controllerOne.position.pixels >=
            _controllerOne.position.maxScrollExtent - 200 &&
            !controller.isLoadingMap.value &&
            controller.hasMoreDataMap.value) {

          if(widget.isAPIcall==true){
            controller.getLocationSearchData(
              widget.properties_latitude,
              widget.properties_longitude,
              controller.currentPageMap.toString(),
              _pageSize.toString(),
              widget.property_category_type,
              widget.category_price_type,
              widget.property_type,
              widget.bhk_type,
              widget.city_name,
            );
          }

        }
      });
    }


  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height * 0.30,
      width: Get.width,
      child: RawScrollbar(
        thickness: 2,
        thumbColor: AppColor.lightPurple,
        trackColor: Colors.grey,
        trackRadius: const Radius.circular(10),
        controller: _controllerOne,
        thumbVisibility: true,
        child: Padding(
          padding: const EdgeInsets.only(left: 2, right: 2),
          child: Obx(() => GridView.count(
              childAspectRatio: 0.56,
              crossAxisCount: 1,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
              physics: const ClampingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              controller: _controllerOne,
              children: List.generate(
                controller.getSearchList.length +
                    (controller.hasMoreDataMap.value ? 1 : 0),
                    (index) {
                  if (index == controller.getSearchList.length &&
                      controller.hasMoreDataMap.value) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 120,
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Please wait',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColor.black.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final String propertyType = controller
                      .getSearchList[index]['property_type']
                      ?.toString()
                      .toLowerCase() ??
                      '';

                  final bool showBHK = [
                    'apartment',
                    'villa',
                    'builder floor',
                    'penthouse',
                    'independent house',
                  ].contains(propertyType);

                  final bool showFurnishing = [
                    'apartment',
                    'villa',
                    'builder floor',
                    'penthouse',
                    'independent house',
                    'pg',
                    'office space',
                    'office space it/sez',
                    'shop',
                    'showroom',
                    'co-working space',
                  ].contains(propertyType);

                  return InkWell(
                    onTap: () {
                      Get.to(PropertyDetailsScreen(
                          id: controller.getSearchList[index]['_id']));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: AppColor.grey.withOpacity(0.1)),
                          color: AppColor.white,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Stack(
                                  children: [
                                    controller.getSearchList[index]
                                    ['cover_image'] !=
                                        null
                                        ? CachedNetworkImage(
                                      width: 120,
                                      height: 200,
                                      imageUrl: controller
                                          .getSearchList[index]
                                      ['cover_image']
                                          .toString()
                                          .startsWith(
                                          'http://13.127.244.70:4444/')
                                          ? controller
                                          .getSearchList[index]
                                      ['cover_image']
                                          .toString()
                                          : 'http://13.127.244.70:4444/${controller.getSearchList[index]['cover_image']?.toString() ?? ''}',
                                      fit: BoxFit.cover,
                                      errorWidget:
                                          (context, url, error) =>
                                      const Icon(Icons.error),
                                    )
                                        : Container(
                                      width: 120,
                                      height: 200,
                                      color: Colors.grey[400],
                                      child: const Center(
                                        child:
                                        Icon(Icons.image_rounded),
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      left: 0,
                                      child: (controller.getSearchList[index]
                                      ?['property_category_type']
                                          ?.toString() ??
                                          '').isNotEmpty
                                          ? Container(
                                        padding: const EdgeInsets
                                            .symmetric(
                                            horizontal: 8,
                                            vertical: 5),
                                        decoration: BoxDecoration(
                                          color: controller
                                              .getSearchList[
                                          index]?[
                                          'property_category_type']
                                              ?.toString() ==
                                              "Rent"
                                              ? AppColor
                                              .primaryThemeColor
                                              : AppColor.green,
                                          borderRadius:
                                          const BorderRadius.only(
                                              bottomRight:
                                              Radius.circular(
                                                  10)),
                                        ),
                                        child: Text(
                                          "FOR ${controller.getSearchList[index]?['property_category_type']?.toString().toUpperCase() ?? ''}",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight:
                                            FontWeight.bold,
                                          ),
                                        ),
                                      )
                                          : const SizedBox.shrink(),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      child: controller.getSearchList[index]
                                      ?['mark_as_featured'] ==
                                          "Yes"
                                          ? Container(
                                        padding: const EdgeInsets
                                            .symmetric(
                                            horizontal: 8,
                                            vertical: 5),
                                        decoration: const BoxDecoration(
                                          color: Color(0xfffeb204),
                                          borderRadius:
                                          BorderRadius.only(
                                              topRight: Radius
                                                  .circular(10)),
                                        ),
                                        child: const Text(
                                          "Featured",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight:
                                            FontWeight.bold,
                                          ),
                                        ),
                                      )
                                          : const SizedBox.shrink(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            boxW15(),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  boxH08(),
                                  Text(
                                    ' ${controller.getSearchList[index]['property_name']}',
                                    maxLines: 1,
                                    style: const TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  boxH10(),
                                  controller.getSearchList[index]
                                  ['property_category_type'] ==
                                      "Rent"
                                      ? Text(
                                    ' ${controller.formatIndianPrice(controller.getSearchList[index]['rent'].toString())}/ Month',
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                      : Text(
                                    controller.formatIndianPrice(
                                        controller.getSearchList[index]
                                        ['property_price']
                                            .toString()),
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  boxH05(),
                                  Row(
                                    mainAxisAlignment: (controller
                                        .getSearchList[index]
                                    ['bhk_type'] !=
                                        "" &&
                                        controller.getSearchList[index]
                                        ['furnished_type'] !=
                                            "")
                                        ? MainAxisAlignment.spaceBetween
                                        : MainAxisAlignment.start,
                                    children: [
                                      if (showBHK)
                                        Row(
                                          children: [
                                            Image.asset(
                                              "assets/image_rent/house.png",
                                              height: 24,
                                              width: 24,
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              ' ${controller.getSearchList[index]['bhk_type']}',
                                              style: const TextStyle(
                                                fontSize: 15.0,
                                                color: Colors.black,
                                                fontWeight:
                                                FontWeight.normal,
                                              ),
                                            ),
                                          ],
                                        ),
                                      if (showBHK && showFurnishing)
                                        const SizedBox(width: 8),
                                      if (showFurnishing)
                                        Row(
                                          children: [
                                            Image.asset(
                                              "assets/image_rent/squareft.png",
                                              height: 24,
                                              width: 24,
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              controller.getSearchList[index]
                                              ['furnished_type']
                                                  ?.toString() ??
                                                  '',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: AppColor.black87,
                                              ),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                  boxH05(),
                                  Text(
                                    '${controller.getSearchList[index]['building_type']} : ${controller.getSearchList[index]['property_type']}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color:
                                      AppColor.black.withOpacity(0.6),
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Image.asset(
                                        "assets/address-location.png",
                                        height: 25,
                                        width: 25,
                                      ),
                                      const SizedBox(width: 5),
                                      Expanded(
                                        child: Text(
                                          controller.getSearchList[index]
                                          ['address_area'] ??
                                              controller.getSearchList[index]
                                              ['address'],
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontFamily: "Muli",
                                          ),
                                        ),
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
                  );
                },
              )),
          ),
        ),
      ),
    );
  }


}