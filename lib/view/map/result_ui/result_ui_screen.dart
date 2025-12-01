import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/common_widgets/height.dart';
import 'package:real_estate_app/global/app_color.dart';
import 'package:real_estate_app/view/auth/login_screen/login_screen.dart';
import 'package:real_estate_app/view/property_screens/properties_controllers/post_property_controller.dart';
import '../../dashboard/bottom_navbar_screens/profile_screen/profile_section_screens/my_virtual_tour/GetScheduleBottomSheet.dart';
import '../../dashboard/bottom_navbar_screens/search_screen/searchController.dart';
import '../../property_screens/recommended_properties_screen/properties_details_screen.dart';
import '../../splash_screen/splash_screen.dart';

// class ResultUi extends StatefulWidget {
//   final RxList<dynamic> data;
//   const ResultUi({super.key, required this.data});
//
//   @override
//   State<ResultUi> createState() => _ResultUiState();
// }
//
// class _ResultUiState extends State<ResultUi> {
//   final searchController search_controller = Get.put(searchController());
//   final ScrollController _controllerOne = ScrollController();
//   final PostPropertyController controller = Get.find();
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       search_controller.getsessionData();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 90.0),
//       child: SizedBox(
//         height: Get.height * 0.30,
//         width: Get.width,
//         child: RawScrollbar(
//           thickness: 2,
//           thumbColor: AppColor.lightPurple,
//           trackColor: Colors.grey,
//           trackRadius: const Radius.circular(10),
//           controller: _controllerOne,
//           thumbVisibility: true,
//           child: Padding(
//             padding:
//             const EdgeInsets.only(left: 6, right: 6),
//             child: GridView.count(
//               childAspectRatio: 0.56,
//               crossAxisCount: 1,
//               crossAxisSpacing: 6,
//               mainAxisSpacing: 6,
//               physics: const ClampingScrollPhysics(),
//               scrollDirection: Axis.horizontal,
//               controller: _controllerOne,
//               children: List.generate(
//                   widget.data.length, (index) {
//
//
//                 final String propertyType = widget.data[index]['property_type']?.toString().toLowerCase() ?? '';
//
//                 final bool showBHK = [
//                   'apartment',
//                   'villa',
//                   'builder floor',
//                   'penthouse',
//                   'independent house',
//                 ].contains(propertyType);
//
//                 final bool showFurnishing = [
//                   'apartment',
//                   'villa',
//                   'builder floor',
//                   'penthouse',
//                   'independent house',
//                   'pg',
//                   'office space',
//                   'office space it/sez',
//                   'shop',
//                   'showroom',
//                   'co-working space',
//                 ].contains(propertyType);
//                 return InkWell(
//                   onTap: () {
//                     Get.to(PropertyDetailsScreen( id:  widget.data[index]['_id']));
//                   },
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Container(
//                       decoration: BoxDecoration(
//                         borderRadius:
//                         BorderRadius.circular(8),
//                         border: Border.all(
//                             color: AppColor.grey
//                                 .withOpacity(0.1)),
//                         color: AppColor.white,
//                       ),
//                       child: Row(
//                         crossAxisAlignment:
//                         CrossAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.circular(8),
//                               child: Stack(
//                                 children: [
//                                   // 🔹 Background Image
//                                   widget.data[index]['cover_image'] != null
//                                       ? CachedNetworkImage(
//                                     width: 120,
//                                     height: 200,
//                                     imageUrl: widget.data[index]['cover_image']?.toString().startsWith('http://13.127.244.70:4444/') ?? false
//                                         ? widget.data[index]['cover_image'].toString()
//                                         : 'http://13.127.244.70:4444/${widget.data[index]['cover_image']?.toString() ?? ''}',
//                                     fit: BoxFit.cover,
//                                     errorWidget: (context, url, error) => const Icon(Icons.error),
//                                   )
//                                       : Container(
//                                     width: 120,
//                                     height: 200,
//                                     color: Colors.grey[400],
//                                     child: const Center(
//                                       child: Icon(Icons.image_rounded),
//                                     ),
//                                   ),
//
//                                   // 🔹 Top-left "FOR [CATEGORY]" Tag
//                                   Positioned(
//                                     top: 0,
//                                     left: 0,
//                                     child: (widget.data[index]?['property_category_type']?.toString() ?? '').isNotEmpty
//                                         ? Container(
//                                       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
//                                       decoration: BoxDecoration(
//                                         color: widget.data[index]?['property_category_type']?.toString() == "Rent"
//                                             ? AppColor.primaryThemeColor
//                                             : AppColor.green,
//                                         borderRadius: const BorderRadius.only(bottomRight: Radius.circular(10)),
//                                       ),
//                                       child: Text(
//                                         "FOR ${widget.data[index]?['property_category_type']?.toString().toUpperCase() ?? ''}",
//                                         style: const TextStyle(
//                                           color: Colors.white,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     )
//                                         : const SizedBox.shrink(),
//                                   ),
//
//                                   // 🔹 Bottom-left "Featured" Tag
//                                   Positioned(
//                                     bottom: 0,
//                                     left: 0,
//                                     child: widget.data[index]?['mark_as_featured'] == "Yes"
//                                         ? Container(
//                                       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
//                                       decoration: const BoxDecoration(
//                                         color: Color(0xfffeb204),
//                                         borderRadius: BorderRadius.only(topRight: Radius.circular(10)),
//                                       ),
//                                       child: const Text(
//                                         "Featured",
//                                         style: TextStyle(
//                                           color: Colors.white,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     )
//                                         : const SizedBox.shrink(),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//
//
//
//
//
//
//                           boxW15(),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               children: [
//                                 boxH08(),
//                                  Text(
//                                   //'Ramanded Villa',
//                                   ' ${widget.data[index]['property_name']}',
//                                   maxLines: 1,
//                                   style: const TextStyle(
//                                     fontSize: 15.0,
//                                     fontWeight: FontWeight.bold,
//
//                                     color: Colors.black,
//                                   ),
//                                 ),
//                                 boxH10(),
//
//                                 widget.data[index]['property_category_type']=="Rent"?
//                                 Text(
//                                   // '${controller.formatIndianPrice( controller.getCommonPropertyList[index]['property_price'].toString())} /'
//                                   //     ' ${controller.formatIndianPrice(controller.getCommonPropertyList[index]['rent'].toString())} Month',
//                                   ' ${controller.formatIndianPrice(widget.data[index]['rent'].toString())}/ Month',
//                                   style: const TextStyle(
//                                     fontSize: 17,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 )
//                                     :
//                                 Text(
//                                   //   _postPropertyController.formatIndianPrice(property['rent']),
//                                   controller.formatIndianPrice( widget.data[index]['property_price'].toString()),
//                                   style: const TextStyle(
//                                       fontSize: 17,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                                 boxH05(),
//                                 Row(
//                                   mainAxisAlignment: (widget.data[index]['bhk_type'] != "" && widget.data[index]['furnished_type'] != "")
//                                       ? MainAxisAlignment.spaceBetween
//                                       : MainAxisAlignment.start,
//                                   children: [
//
//                                     if (showBHK)
//                                       Row(
//                                         children: [
//                                           Image.asset(
//                                             "assets/image_rent/house.png",
//                                             height: 24,
//                                             width: 24,
//                                           ),
//                                           const SizedBox(width: 6),
//                                           Text(
//                                             ' ${widget.data[index]['bhk_type']}',
//                                             style: const TextStyle(
//                                               fontSize: 15.0,
//                                               color: Colors.black,
//                                               fontWeight: FontWeight.normal,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//
//
//                                     if (showBHK && showFurnishing)
//                                       const SizedBox(width: 8),
//
//                                     if (showFurnishing)
//                                       Row(
//                                         children: [
//                                           Image.asset(
//                                             "assets/image_rent/squareft.png",
//                                             height: 24,
//                                             width: 24,
//                                           ),
//                                           const SizedBox(width: 6),
//                                           Text(
//                                             widget.data[index]['furnished_type']?.toString() ?? '',
//                                             style: const TextStyle(
//                                               fontSize: 14,
//                                               fontWeight: FontWeight.bold,
//                                               color: AppColor.black87,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                   ],
//                                 ),
//
//                                 boxH05(),
//                                 Text(
//                                   '${widget.data[index]['building_type']} : ${widget.data[index]['property_type']}',
//                                   style: TextStyle(
//                                       fontSize: 14,
//                                       color: AppColor.black.withOpacity(0.6),fontWeight: FontWeight.bold
//                                   ),
//
//
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//
//                                 // widget.data[index]['category_price_type']!='Sell'?
//                                 // Row(
//                                 //   children: [
//                                 //     Container(
//                                 //       width: 8.0,
//                                 //       height: 8.0,
//                                 //       decoration: BoxDecoration(
//                                 //         color: Colors.grey,  // Grey color for the bullet
//                                 //         shape: BoxShape.circle,  // Circular shape
//                                 //       ),
//                                 //     ),
//                                 //
//                                 //     Text(
//                                 //       ' ${widget.data[index]['bhk_type']}',
//                                 //       style: TextStyle(
//                                 //         fontSize: 15.0,
//                                 //         color: Colors.black,
//                                 //         fontWeight: FontWeight.normal,
//                                 //       ),
//                                 //     ),
//                                 //     const SizedBox(width: 10.0),
//                                 //
//                                 //   ],
//                                 // ):SizedBox(),
//                                 // boxH20(),
//                                 // Flexible(
//                                 //   child: Text(
//                                 //     '${widget.data[index]['address']}',
//                                 //     style: const TextStyle(
//                                 //       fontSize: 14.0,
//                                 //       fontWeight: FontWeight.normal,
//                                 //       color: Colors.black45,
//                                 //     ),
//                                 //   ),
//                                 // ),
//                                 Row(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Image.asset(
//                                       "assets/address-location.png",
//                                       height: 25,
//                                       width: 25,
//                                     ),
//                                     const SizedBox(width: 5),
//                                     Expanded(
//                                       child: Text(
//                                         //'${controller.getCommonPropertyList[index]['address']}',
//                                         widget.data[index]['address_area'] ?? widget.data[index]['address'],
//                                         maxLines: 2,
//                                         // maxLines: 3,
//                                         overflow: TextOverflow.ellipsis,
//                                         style: const TextStyle(
//                                           fontFamily: "Muli",
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               }),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

class ResultUi extends StatefulWidget {
  final RxList<dynamic> data;
  final Future<void> Function()? onLoadMore; // 👈 pagination callback

  const ResultUi({
    super.key,
    required this.data,
    this.onLoadMore,
  });

  @override
  State<ResultUi> createState() => _ResultUiState();
}

class _ResultUiState extends State<ResultUi> {
  final searchController search_controller = Get.put(searchController());
  final ScrollController _controllerOne = ScrollController();
  final PostPropertyController controller = Get.find();

  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      search_controller.getsessionData();
    });

    // 👇 Pagination listener
    _controllerOne.addListener(() async {
      if (_controllerOne.position.pixels >=
          _controllerOne.position.maxScrollExtent - 100 &&
          !_isLoadingMore &&
          widget.onLoadMore != null) {
        setState(() => _isLoadingMore = true);
        await widget.onLoadMore!.call();
        setState(() => _isLoadingMore = false);
      }
    });
  }

  @override
  void dispose() {
    _controllerOne.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 90.0),
      child: SizedBox(
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
            padding: const EdgeInsets.only(left: 6, right: 6),
            child: GridView.count(
              childAspectRatio: 0.56,
              crossAxisCount: 1,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
              physics: const ClampingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              controller: _controllerOne,
              children: List.generate(widget.data.length, (index) {
                final property = widget.data[index];
                final String propertyType =
                    property['property_type']?.toString().toLowerCase() ?? '';

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
                    Get.to(PropertyDetailsScreen(id: property['_id']));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColor.grey.withOpacity(0.1)),
                        color: AppColor.white,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // --- Image + Tags ---
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Stack(
                                children: [
                                  property['cover_image'] != null
                                      ? CachedNetworkImage(
                                    width: 120,
                                    height: 200,
                                    imageUrl: property['cover_image']
                                        ?.toString()
                                        .startsWith(
                                        'http://13.127.244.70:4444/') ??
                                        false
                                        ? property['cover_image']
                                        .toString()
                                        : 'http://13.127.244.70:4444/${property['cover_image']?.toString() ?? ''}',
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
                                      child: Icon(Icons.image_rounded),
                                    ),
                                  ),
                                  // Category Tag
                                  Positioned(
                                    top: 0,
                                    left: 0,
                                    child: (property['property_category_type']
                                        ?.toString() ??
                                        '')
                                        .isNotEmpty
                                        ? Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: property[
                                        'property_category_type']
                                            ?.toString() ==
                                            "Rent"
                                            ? AppColor.primaryThemeColor
                                            : AppColor.green,
                                        borderRadius:
                                        const BorderRadius.only(
                                            bottomRight:
                                            Radius.circular(10)),
                                      ),
                                      child: Text(
                                        "FOR ${property['property_category_type']?.toString().toUpperCase() ?? ''}",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                        : const SizedBox.shrink(),
                                  ),
                                  // Featured Tag
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    child:
                                    property['mark_as_featured'] == "Yes"
                                        ? Container(
                                      padding:
                                      const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 5),
                                      decoration: const BoxDecoration(
                                        color: Color(0xfffeb204),
                                        borderRadius:
                                        BorderRadius.only(
                                            topRight:
                                            Radius.circular(
                                                10)),
                                      ),
                                      child: const Text(
                                        "Featured",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
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
                          // --- Right Side Info ---
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                boxH08(),
                                Text(
                                  ' ${property['property_name']}',
                                  maxLines: 1,
                                  style: const TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                boxH10(),
                                property['property_category_type'] == "Rent"
                                    ? Text(
                                  ' ${controller.formatIndianPrice(property['rent'].toString())}/ Month',
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                                    : Text(
                                  controller.formatIndianPrice(
                                      property['property_price']
                                          .toString()),
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                boxH05(),
                                Row(
                                  mainAxisAlignment:
                                  (property['bhk_type'] != "" &&
                                      property['furnished_type'] != "")
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
                                            ' ${property['bhk_type']}',
                                            style: const TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
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
                                            property['furnished_type']
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
                                  '${property['building_type']} : ${property['property_type']}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColor.black.withOpacity(0.6),
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      "assets/address-location.png",
                                      height: 25,
                                      width: 25,
                                    ),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                        property['address_area'] ??
                                            property['address'],
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
              }),
            ),
          ),
        ),
      ),
    );
  }
}
