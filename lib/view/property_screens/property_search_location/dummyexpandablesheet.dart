import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/common_widgets/height.dart';
import 'package:real_estate_app/global/app_color.dart';
import 'package:real_estate_app/view/auth/login_screen/login_screen.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/profile_screen/profile_section_screens/my_virtual_tour/GetScheduleBottomSheet.dart';
import 'package:real_estate_app/view/property_screens/properties_controllers/post_property_controller.dart';
import 'package:real_estate_app/view/property_screens/recommended_properties_screen/properties_details_screen.dart';
import 'package:real_estate_app/view/property_screens/recommended_properties_screen/propertyCard.dart';

import '../../dashboard/bottom_navbar_screens/search_screen/searchController.dart';
import '../../splash_screen/splash_screen.dart';

// class ExpandableBottomSheet extends StatefulWidget {
//   final bool clear;
//   final String property_category_type;
//   final String category_price_type;
//   final String property_type;
//   final String bhk_type;
//   final String city_name;
//   final String properties_latitude;
//   final String properties_longitude;
//
//
//   const ExpandableBottomSheet({
//     super.key,
//
//     required this.clear,
//     required this.property_category_type,
//     required this.category_price_type,
//     required this.property_type,
//     required this.bhk_type,
//     required this.city_name,
//     required this.properties_latitude,
//     required this.properties_longitude,
//   });
//
//   @override
//   State<ExpandableBottomSheet> createState() => _ExpandableBottomSheetState();
// }
//
// class _ExpandableBottomSheetState extends State<ExpandableBottomSheet> {
//   final ScrollController _scrollController = ScrollController();
//   final PostPropertyController controller = Get.find();
//   final int _pageSize = 10;
//
//   @override
//   void initState() {
//     super.initState();
//     // Remove redundant API call; MapResultUi already handles initial data fetch
//     if (widget.clear) {
//       controller.clearSearchData();
//     }
//
//     _scrollController.addListener(() {
//       if (_scrollController.position.pixels >=
//           _scrollController.position.maxScrollExtent - 200 &&
//           !controller.isLoadingMap.value &&
//           controller.hasMoreDataMap.value) {
//         controller.getLocationSearchData(
//           widget.properties_latitude,
//           widget.properties_longitude,
//           controller.currentPageMap.toString(),
//           _pageSize.toString(),
//           widget.property_category_type,
//           widget.category_price_type,
//           widget.property_type,
//           widget.bhk_type,
//           widget.city_name,
//         );
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   @override
//
//
//   Widget build(BuildContext context) {
//     double _width = MediaQuery.sizeOf(context).width;
//     double _height = MediaQuery.sizeOf(context).height;
//
//     return DraggableScrollableSheet(
//       initialChildSize: 0.15,   // starts small (15% of screen height)
//       minChildSize: 0.15,       // minimum size it can shrink back to
//       maxChildSize: 1.0,        // expands to full screen on drag/tap
//       snap: true,
//       builder: (BuildContext context, ScrollController scrollController) {
//         return Container(
//           decoration: const BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black26,
//                 blurRadius: 10,
//                 spreadRadius: 1,
//               )
//             ],
//           ),
//           child: Obx(() => ListView.builder(
//             controller: scrollController, // ✅ use builder's controller
//             itemCount: controller.getSearchList.length +
//                 (controller.hasMoreDataMap.value ? 1 : 0) +
//                 3,
//             itemBuilder: (context, index) {
//               if (index == 0) {
//                 return Center(
//                   child: Container(
//                     width: 80,
//                     height: 5,
//                     margin: const EdgeInsets.symmetric(vertical: 10),
//                     decoration: BoxDecoration(
//                       color: Colors.grey[400],
//                       borderRadius: BorderRadius.circular(5),
//                     ),
//                   ),
//                 );
//               } else if (index == 1) {
//                 return Center(
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                     child: Text(
//                       '${controller.total_count_map.value} Results',
//                       style: const TextStyle(fontSize: 16),
//                     ),
//                   ),
//                 );
//               } else if (index == 2) {
//                 return const Divider(thickness: 1, height: 20);
//               } else if (index < controller.getSearchList.length + 3) {
//                 final dataIndex = index - 3;
//                 return PropertyCard(
//                   index: dataIndex,
//                   getFeaturedPropery: controller.getSearchList,
//                 );
//               } else {
//                 return Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Container(
//                     width: 120,
//                     alignment: Alignment.center,
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         const SizedBox(
//                           width: 20,
//                           height: 20,
//                           child: CircularProgressIndicator(strokeWidth: 2),
//                         ),
//                         const SizedBox(width: 8),
//                         Text(
//                           'Loading more...',
//                           style: TextStyle(
//                             fontSize: 12,
//                             color: AppColor.black.withOpacity(0.6),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               }
//             },
//           )),
//         );
//       },
//     );
//
//   }
//
//   Widget PropertyCard({
//     required int index,
//     required RxList<dynamic> getFeaturedPropery,
//   }) {
//     final property = getFeaturedPropery.isNotEmpty && index < getFeaturedPropery.length
//         ? getFeaturedPropery[index]
//         : null;
//
//     if (property == null) {
//       return const SizedBox.shrink();
//     }
//
//     return GestureDetector(
//       onTap: () {
//         Get.to(PropertyDetailsScreen(id: property['_id']));
//       },
//       child: Container(
//         width: Get.width * 0.6,
//         margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
//         decoration: BoxDecoration(
//           borderRadius: const BorderRadius.all(Radius.circular(20)),
//           border: Border.all(color: AppColor.grey.shade200),
//           color: AppColor.white,
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Stack(
//               children: [
//                 Center(
//                   child: CarouselSlider.builder(
//                     options: CarouselOptions(
//                       height: 250,
//                       autoPlay: true,
//                       enlargeCenterPage: true,
//                       viewportFraction: 1,
//                       aspectRatio: 16 / 9,
//                       enableInfiniteScroll: true,
//                       autoPlayInterval: const Duration(seconds: 3),
//                       autoPlayAnimationDuration: const Duration(milliseconds: 800),
//                       scrollDirection: Axis.horizontal,
//                     ),
//                     itemCount: () {
//                       final images = property['property_images'] as List<dynamic>? ?? [];
//                       return images.isNotEmpty ? images.length : (property['cover_image'] != null ? 1 : 1);
//                     }(),
//                     itemBuilder: (context, imageIndex, realIndex) {
//                       final images = property['property_images'] as List<dynamic>? ?? [];
//                       final coverImg = property['cover_image']?.toString() ?? '';
//
//                       if (images.isEmpty && coverImg.isEmpty) {
//                         return Container(
//                           decoration: BoxDecoration(
//                             color: Colors.grey[400],
//                             borderRadius: BorderRadius.circular(15),
//                           ),
//                           child: const Center(
//                             child: Icon(
//                               Icons.image_not_supported_outlined,
//                               color: Colors.white,
//                               size: 50,
//                             ),
//                           ),
//                         );
//                       }
//
//                       if (images.isEmpty) {
//                         return ClipRRect(
//                           borderRadius: BorderRadius.circular(15),
//                           child: Stack(
//                             fit: StackFit.expand,
//                             children: [
//                               CachedNetworkImage(
//                                 imageUrl: coverImg.startsWith('http://13.127.244.70:4444/')
//                                     ? coverImg
//                                     : 'http://13.127.244.70:4444/$coverImg',
//                                 fit: BoxFit.cover,
//                                 width: double.infinity,
//                                 placeholder: (context, url) => Container(
//                                   color: Colors.grey[300],
//                                   child: const Center(child: CircularProgressIndicator()),
//                                 ),
//                                 errorWidget: (context, url, error) => Container(
//                                   color: Colors.grey[400],
//                                   child: const Center(
//                                     child: Icon(Icons.image_rounded, color: Colors.white),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         );
//                       }
//
//                       return ClipRRect(
//                         borderRadius: BorderRadius.circular(15),
//                         child: Stack(
//                           fit: StackFit.expand,
//                           children: [
//                             CachedNetworkImage(
//                               imageUrl: images[imageIndex]['image'].toString().startsWith('http://13.127.244.70:4444/')
//                                   ? images[imageIndex]['image'].toString()
//                                   : 'http://13.127.244.70:4444/${images[imageIndex]['image']?.toString() ?? ''}',
//                               fit: BoxFit.cover,
//                               width: double.infinity,
//                               placeholder: (context, url) => Container(
//                                 color: Colors.grey[300],
//                                 child: const Center(child: CircularProgressIndicator()),
//                               ),
//                               errorWidget: (context, url, error) => Container(
//                                 color: Colors.grey[400],
//                                 child: const Center(
//                                   child: Icon(Icons.image_rounded, color: Colors.white),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 Positioned(
//                   top: 10,
//                   left: 4,
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                     decoration: BoxDecoration(
//                       color: Colors.black.withOpacity(0.3),
//                       borderRadius: BorderRadius.circular(15),
//                     ),
//                     child: Text(
//                       "${property['days_since_created']?.toString() ?? '0'} Days on Houzza",
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   bottom: 0,
//                   left: 0,
//                   right: 0,
//                   child: Container(
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         begin: Alignment.bottomCenter,
//                         end: Alignment.topCenter,
//                         colors: [
//                           Colors.black.withOpacity(0.7),
//                           Colors.transparent,
//                         ],
//                       ),
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         if ((property['property_category_type']?.toString() ?? '').isNotEmpty)
//                           Container(
//                             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
//                             decoration: BoxDecoration(
//                               color: property['property_category_type'].toString() == "Rent"
//                                   ? AppColor.primaryThemeColor
//                                   : AppColor.green,
//                               borderRadius: const BorderRadius.only(topRight: Radius.circular(10)),
//                             ),
//                             child: Text(
//                               "FOR ${property['property_category_type'].toString().toUpperCase()}",
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         if (property['mark_as_featured'] == "Yes")
//                           Container(
//                             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
//                             decoration: const BoxDecoration(
//                               color: Color(0xfffeb204),
//                               borderRadius: BorderRadius.only(topLeft: Radius.circular(10)),
//                             ),
//                             child: const Text(
//                               "Featured",
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 if (property['virtual_tour_availability'] == "Yes")
//                   Positioned(
//                     top: 10,
//                     right: 50,
//                     child: GestureDetector(
//                       onTap: () {
//                         if (isLogin == true) {
//                           showModalBottomSheet(
//                             context: context,
//                             isScrollControlled: true,
//                             shape: const RoundedRectangleBorder(
//                               borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//                             ),
//                             builder: (context) => GetScheduleBottomSheet(
//                               name: property['connect_to_name'],
//                               userType: property['user_type'],
//                               tour_type: 'Property',
//                               propertyID: property['_id'],
//                               propertyOwnerID: property['user_id'],
//                             ),
//                           );
//                         } else {
//                           Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
//                         }
//                       },
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
//                         decoration: BoxDecoration(
//                           color: Colors.black.withOpacity(0.5),
//                           borderRadius: BorderRadius.circular(15),
//                         ),
//                         child: Row(
//                           children: [
//                             Image.asset(
//                               "assets/image_rent/VirtualTour.png",
//                               width: 20,
//                               height: 20,
//                             ),
//                             const SizedBox(width: 5),
//                             const Text(
//                               "Virtual Tour",
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//             SizedBox(
//               height: Get.height * 0.35,
//               width: Get.width,
//               child: Padding(
//                 padding: const EdgeInsets.only(right: 16.0, left: 16.0, top: 8.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         Expanded(
//                           child: Text(
//                             property['property_name'],
//                             style: const TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                               color: AppColor.black87,
//                             ),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                         Container(
//                           width: 34,
//                           height: 34,
//                           decoration: const BoxDecoration(
//                             color: Colors.white,
//                             shape: BoxShape.circle,
//                           ),
//                           child: Center(
//                             child: Image.asset(
//                               "assets/image_rent/share.png",
//                               height: 18,
//                               width: 18,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     boxH08(),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             Image.asset(
//                               "assets/image_rent/money.png",
//                               height: 24,
//                               width: 24,
//                             ),
//                             boxW06(),
//                             property['property_category_type'] == "Rent"
//                                 ? Text(
//                               '${controller.formatIndianPrice(property['rent'].toString())}/ Month',
//                               style: const TextStyle(
//                                 fontSize: 17,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             )
//                                 : Text(
//                               controller.formatIndianPrice(property['property_price'].toString()),
//                               style: const TextStyle(
//                                 fontSize: 17,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             Image.asset(
//                               "assets/image_rent/house.png",
//                               height: 24,
//                               width: 24,
//                             ),
//                             boxW06(),
//                             Text(
//                               property['bhk_type'] ?? 'N/A',
//                               style: const TextStyle(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.bold,
//                                 color: AppColor.black87,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                     boxH08(),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Row(
//                           children: [
//                             Image.asset(
//                               "assets/image_rent/format-square.png",
//                               height: 24,
//                               width: 24,
//                             ),
//                             boxW06(),
//                             Text(
//                               property['area']?.toString() ?? 'N/A',
//                               style: const TextStyle(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.bold,
//                                 color: AppColor.black87,
//                               ),
//                             ),
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             Image.asset(
//                               "assets/image_rent/squareft.png",
//                               height: 24,
//                               width: 24,
//                             ),
//                             boxW06(),
//                             Text(
//                               property['furnished_type']?.toString() ?? 'N/A',
//                               style: const TextStyle(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.bold,
//                                 color: AppColor.black87,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                     boxH15(),
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Image.asset(
//                           "assets/address-location.png",
//                           height: 25,
//                           width: 25,
//                         ),
//                         boxW05(),
//                         Expanded(
//                           child: Text(
//                             property['address_area'] ?? property['address'] ?? 'N/A',
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                             style: const TextStyle(fontFamily: "Muli"),
//                           ),
//                         ),
//                       ],
//                     ),
//                     boxH15(),
//                     Row(
//                       children: [
//                         CircleAvatar(
//                           radius: 24,
//                           backgroundColor: AppColor.grey.withOpacity(0.1),
//                           child: ClipOval(
//                             child: Image.asset(
//                               'assets/image_rent/profile.png',
//                               width: 30,
//                               height: 30,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         ),
//                         boxW15(),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               property['connect_to_name'] ?? 'N/A',
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 16,
//                               ),
//                             ),
//                             Text(
//                               property['user_type'] ?? 'Owner',
//                               style: const TextStyle(
//                                 fontSize: 12,
//                                 color: Colors.grey,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Helper widgets for spacing
//   Widget boxH08() => const SizedBox(height: 8);
//   Widget boxH15() => const SizedBox(height: 15);
//   Widget boxW05() => const SizedBox(width: 5);
//   Widget boxW06() => const SizedBox(width: 6);
//   Widget boxW15() => const SizedBox(width: 15);
// }

///
class ExpandableResultScreen extends StatefulWidget {
  final bool isAPIcall;
  final bool clear;
  final String property_category_type;
  final String category_price_type;
  final String property_type;
  final String bhk_type;
  final String city_name;
  final String properties_latitude;
  final String properties_longitude;

  const ExpandableResultScreen({
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
  State<ExpandableResultScreen> createState() => _ExpandableResultScreenState();
}

class _ExpandableResultScreenState extends State<ExpandableResultScreen> {
  final PostPropertyController controller = Get.find();
  final ScrollController _scrollController = ScrollController();
  final int _pageSize = 10;

  @override
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // controller.clearSearchData();

      _scrollController.addListener(() {
        if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
            !controller.isLoadingMap.value &&
            controller.hasMoreDataMap.value) {
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
      });
    });
  }


  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text("${controller.total_count_map.value} Results")),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Obx(() => ListView.builder(
        controller: _scrollController,
        itemCount: controller.getSearchList.length +
            (controller.hasMoreDataMap.value ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < controller.getSearchList.length) {
            return PropertyCard(
              index: index,
              getFeaturedPropery: controller.getSearchList,
            );
          } else {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      )),
    );
  }


  Widget PropertyCard({
    required int index,
    required RxList<dynamic> getFeaturedPropery,
  }) {
    final property = getFeaturedPropery.isNotEmpty && index < getFeaturedPropery.length
        ? getFeaturedPropery[index]
        : null;

    if (property == null) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: () {
        Get.to(PropertyDetailsScreen(id: property['_id']));
      },
      child: Container(
        width: Get.width * 0.6,
        margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          border: Border.all(color: AppColor.grey.shade200),
          color: AppColor.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Center(
                  child: CarouselSlider.builder(
                    options: CarouselOptions(
                      height: 250,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      viewportFraction: 1,
                      aspectRatio: 16 / 9,
                      enableInfiniteScroll: true,
                      autoPlayInterval: const Duration(seconds: 3),
                      autoPlayAnimationDuration: const Duration(milliseconds: 800),
                      scrollDirection: Axis.horizontal,
                    ),
                    itemCount: () {
                      final images = property['property_images'] as List<dynamic>? ?? [];
                      return images.isNotEmpty ? images.length : (property['cover_image'] != null ? 1 : 1);
                    }(),
                    itemBuilder: (context, imageIndex, realIndex) {
                      final images = property['property_images'] as List<dynamic>? ?? [];
                      final coverImg = property['cover_image']?.toString() ?? '';

                      if (images.isEmpty && coverImg.isEmpty) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              color: Colors.white,
                              size: 50,
                            ),
                          ),
                        );
                      }

                      if (images.isEmpty) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              CachedNetworkImage(
                                imageUrl: coverImg.startsWith('http://13.127.244.70:4444/')
                                    ? coverImg
                                    : 'http://13.127.244.70:4444/$coverImg',
                                fit: BoxFit.cover,
                                width: double.infinity,
                                placeholder: (context, url) => Container(
                                  color: Colors.grey[300],
                                  child: const Center(child: CircularProgressIndicator()),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  color: Colors.grey[400],
                                  child: const Center(
                                    child: Icon(Icons.image_rounded, color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            CachedNetworkImage(
                              imageUrl: images[imageIndex]['image'].toString().startsWith('http://13.127.244.70:4444/')
                                  ? images[imageIndex]['image'].toString()
                                  : 'http://13.127.244.70:4444/${images[imageIndex]['image']?.toString() ?? ''}',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              placeholder: (context, url) => Container(
                                color: Colors.grey[300],
                                child: const Center(child: CircularProgressIndicator()),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: Colors.grey[400],
                                child: const Center(
                                  child: Icon(Icons.image_rounded, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      "${property['days_since_created']?.toString() ?? '0'} Days on Houzza",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if ((property['property_category_type']?.toString() ?? '').isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                            decoration: BoxDecoration(
                              color: property['property_category_type'].toString() == "Rent"
                                  ? AppColor.primaryThemeColor
                                  : AppColor.green,
                              borderRadius: const BorderRadius.only(topRight: Radius.circular(10)),
                            ),
                            child: Text(
                              "FOR ${property['property_category_type'].toString().toUpperCase()}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        if (property['mark_as_featured'] == "Yes")
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                            decoration: const BoxDecoration(
                              color: Color(0xfffeb204),
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(10)),
                            ),
                            child: const Text(
                              "Featured",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                if (property['virtual_tour_availability'] == "Yes")
                  Positioned(
                    top: 10,
                    right: 50,
                    child: GestureDetector(
                      onTap: () {
                        if (isLogin == true) {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                            ),
                            builder: (context) => GetScheduleBottomSheet(
                              name: property['connect_to_name'],
                              userType: property['user_type'],
                              tour_type: 'Property',
                              propertyID: property['_id'],
                              propertyOwnerID: property['user_id'],
                            ),
                          );
                        } else {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/image_rent/VirtualTour.png",
                              width: 20,
                              height: 20,
                            ),
                            const SizedBox(width: 5),
                            const Text(
                              "Virtual Tour",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(
              height: Get.height * 0.35,
              width: Get.width,
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0, left: 16.0, top: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            property['property_name'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColor.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          width: 34,
                          height: 34,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Image.asset(
                              "assets/image_rent/share.png",
                              height: 18,
                              width: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                    boxH08(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              "assets/image_rent/money.png",
                              height: 24,
                              width: 24,
                            ),
                            boxW06(),
                            property['property_category_type'] == "Rent"
                                ? Text(
                              '${controller.formatIndianPrice(property['rent'].toString())}/ Month',
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                                : Text(
                              controller.formatIndianPrice(property['property_price'].toString()),
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Image.asset(
                              "assets/image_rent/house.png",
                              height: 24,
                              width: 24,
                            ),
                            boxW06(),
                            Text(
                              property['bhk_type'] ?? 'N/A',
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
                    boxH08(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              "assets/image_rent/format-square.png",
                              height: 24,
                              width: 24,
                            ),
                            boxW06(),
                            Text(
                              property['area']?.toString() ?? 'N/A',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColor.black87,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Image.asset(
                              "assets/image_rent/squareft.png",
                              height: 24,
                              width: 24,
                            ),
                            boxW06(),
                            Text(
                              property['furnished_type']?.toString() ?? 'N/A',
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
                    boxH15(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          "assets/address-location.png",
                          height: 25,
                          width: 25,
                        ),
                        boxW05(),
                        Expanded(
                          child: Text(
                            property['address_area'] ?? property['address'] ?? 'N/A',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontFamily: "Muli"),
                          ),
                        ),
                      ],
                    ),
                    boxH15(),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: AppColor.grey.withOpacity(0.1),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/image_rent/profile.png',
                              width: 30,
                              height: 30,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        boxW15(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              property['connect_to_name'] ?? 'N/A',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              property['user_type'] ?? 'Owner',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widgets for spacing
  Widget boxH08() => const SizedBox(height: 8);
  Widget boxH15() => const SizedBox(height: 15);
  Widget boxW05() => const SizedBox(width: 5);
  Widget boxW06() => const SizedBox(width: 6);
  Widget boxW15() => const SizedBox(width: 15);
}
