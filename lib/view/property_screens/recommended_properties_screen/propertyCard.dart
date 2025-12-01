import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/common_widgets/height.dart';
import 'package:real_estate_app/global/api_string.dart';
import 'package:real_estate_app/global/app_color.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/search_screen/searchController.dart';
import 'package:real_estate_app/view/property_screens/properties_controllers/post_property_controller.dart';
import 'package:real_estate_app/view/property_screens/recommended_properties_screen/properties_details_screen.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../auth/login_screen/login_screen.dart';
import '../../dashboard/bottom_navbar_screens/profile_screen/profile_section_screens/my_virtual_tour/GetScheduleBottomSheet.dart';
import '../../splash_screen/splash_screen.dart';

class propertyCard extends StatefulWidget {
  final Map<String, dynamic> property_data;
  final int index;
  final RxList propertyList;

  const propertyCard({
    super.key,
    required this.property_data,
    required this.index,
    required this.propertyList,
  });

  @override
  State<propertyCard> createState() => _propertyCardState();
}
class _propertyCardState extends State<propertyCard> {
  final PostPropertyController postController = Get.find();
  final searchApiController = Get.find<searchController>();
  final RxInt _currentIndex = 0.obs;
  @override
  Widget build(BuildContext context) {


    final String propertyType = widget.property_data['property_type']?.toString().toLowerCase() ?? '';

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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PropertyDetailsScreen(
                id: widget.property_data['_id'],
              ),
            ),
          ).then((value) {
            if (value != null) {
              setState(() {
                // If you're just updating isFavorite
                widget.property_data['is_favorite'] = value;

                print("widget.property_data['isFavorite']--->");
                print(widget.property_data['is_favorite']);
                print(value);


              });
            }
          });
        },

        child: Container(
          width: Get.width * 0.9,
          margin: const EdgeInsets.symmetric(
              horizontal: 4, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: AppColor.grey.withOpacity(0.01)),
            color: AppColor.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Stack(
                children: [
                  // Carousel Slider


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
                        onPageChanged: (index, reason) {

                          _currentIndex.value = index;


                        },
                      ),
                      itemCount: () {
                        final property =widget.property_data.isNotEmpty &&
                            widget.index < widget.property_data.length
                            ?widget.property_data
                            : null;
                        if (property == null ||
                            (property['property_images'] == null && property['cover_image'] == null)) {
                          return 1;
                        }
                        final images = property['property_images'] as List<dynamic>? ?? [];
                        return images.isNotEmpty ? images.length : 1;
                      }(),
                      itemBuilder: (context, imageIndex, realIndex) {
                        final property = widget.property_data.isNotEmpty &&
                            widget.index < widget.property_data.length
                            ? widget.property_data
                            : null;

                        if (property == null) {
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
                                  imageUrl:property['cover_image']?.toString()?.toString().startsWith('http://13.127.244.70:4444/') ?? false
                                      ?property['cover_image'].toString()
                                      : 'http://13.127.244.70:4444/${property['cover_image']?.toString() ?? ''}',

                                  // getImageUrl(coverImg),
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
                                imageUrl: images[imageIndex]['image']?.toString().startsWith('http://13.127.244.70:4444/') ?? false
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
                  // "Days on Houzza" Banner
                  // Positioned(
                  //   top: 10,
                  //   left: 4,
                  //   child: Container(
                  //     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  //     decoration: BoxDecoration(
                  //       color: Colors.black.withOpacity(0.3),
                  //       borderRadius: BorderRadius.circular(15),
                  //     ),
                  //     child: Text(
                  //       "${widget.property_data['days_since_created']?.toString() ?? '0'} Days on Houzza",
                  //       style: const TextStyle(
                  //           color: Colors.white,
                  //           fontWeight: FontWeight.bold),
                  //     ),
                  //   ),
                  // ),
                  widget.property_data['created_at']!=null?
                  Positioned(
                    top: 10,
                    left: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child:Text(
                        '${postController.getTimeAgo(DateTime.parse(widget.property_data['created_at']))} on Houzza',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                    ),
                  ):SizedBox(),
                  // Bottom controls container

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
                          // "FOR BUY/SELL/RENT" tag
                          (widget.property_data['property_category_type']?.toString() ?? '').isNotEmpty
                              ? Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                            decoration:  BoxDecoration(
                              // color: Color(0xFF52C672),
                              color:widget.property_data['property_category_type'].toString() =="Rent"?
                              AppColor.primaryThemeColor:AppColor.green,
                              borderRadius: const BorderRadius.only(topRight: Radius.circular(10)),
                            ),
                            child: Text(
                              "FOR ${widget.property_data['property_category_type']?.toString().toUpperCase() ?? ''}",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          )
                              : const SizedBox.shrink(),

                          /// Dots indicator

                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                (widget.property_data['property_images'] as List?)?.length ?? 1,
                                    (dotIndex) => Obx(()=>
                                        Container(
                                          width: 8,
                                          height: 8,
                                          margin: const EdgeInsets.symmetric(horizontal: 3),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: _currentIndex.value == dotIndex
                                                ? Colors.white
                                                : Colors.white.withOpacity(0.5),
                                          ),
                                        ),
                                    ),
                              ),
                            ),

                          widget.property_data['mark_as_featured']=="Yes"?
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
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ):  Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                            decoration: const BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(10)),
                            ),
                            child: const Text(
                              "          ",

                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  widget.property_data['virtual_tour_availability']=="Yes"?
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
                              name: widget.property_data['connect_to_name'],
                              userType: widget.property_data['user_type'],
                              tour_type: 'Property',
                              propertyID:widget.property_data['_id'],
                              propertyOwnerID: widget.property_data['user_id'],
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
                                height: 20),
                            const SizedBox(width: 5),
                            const Text(
                              "Virtual Tour",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ):const SizedBox(),


                  Positioned(
                    top: 10,
                    right: 10,
                    child: GestureDetector(
                      onTap: () {
                        if (isLogin == true) {
                          if (!widget.property_data['is_favorite']) {
                            searchApiController
                                .addFavorite(property_id: widget.property_data['_id'])
                                .then((_) {
                              setState(() {
                                widget.property_data['is_favorite'] = true;
                              });
                            });
                          } else {
                            searchApiController
                                .removeFavorite(
                              property_id: widget.property_data['_id'],
                              favorite_id: widget.property_data['favorite_id'],
                            )
                                .then((_) {
                              setState(() {
                                widget.property_data['is_favorite'] = false;
                              });
                            });
                          }
                        } else {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.8),
                        ),
                        child: Icon(
                          widget.property_data['is_favorite']
                              ? Icons.favorite
                              : Icons.favorite_outline_outlined,
                          color: widget.property_data['is_favorite']
                              ? AppColor.red
                              : Colors.black.withOpacity(0.6),
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // Property Details
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [

                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.property_data['property_name'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColor.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        GestureDetector(
                          onTap: () async {

                            shareProperty(widget.property_data['_id']);

                          },
                          child: Container(
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
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    //
                    // Row(
                    //   mainAxisAlignment:
                    //   MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Row(
                    //       children: [
                    //         Image.asset(
                    //           "assets/image_rent/money.png",
                    //           height: 24,
                    //           width: 24,
                    //         ),
                    //         const SizedBox(width: 6),
                    //
                    //         widget.property_data['property_category_type']=="Rent"?
                    //         Text(
                    //           ' ${postController.formatIndianPrice(widget.property_data['rent'].toString())}/ Month',
                    //           style: const TextStyle(
                    //             fontSize: 17,
                    //             fontWeight: FontWeight.bold,
                    //           ),
                    //         )
                    //             :
                    //         Text(
                    //           postController.formatIndianPrice( widget.property_data['property_price'].toString()),
                    //           style: const TextStyle(
                    //               fontSize: 17,
                    //               fontWeight: FontWeight.bold),
                    //         ),
                    //       ],
                    //     ),
                    //     if (showBHK)
                    //       Row(
                    //         children: [
                    //           Image.asset(
                    //             "assets/image_rent/house.png",
                    //             height: 24,
                    //             width: 24,
                    //           ),
                    //           const SizedBox(width: 6),
                    //           Text(
                    //             widget.property_data['bhk_type'] ?? '',
                    //             style: const TextStyle(
                    //               fontSize: 14,
                    //               fontWeight: FontWeight.bold,
                    //               color: AppColor.black87,
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //   ],
                    // ),
                    //
                    // const SizedBox(height: 8),
                    //
                    // Row(
                    //   mainAxisAlignment:
                    //   MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Row(
                    //       children: [
                    //         Image.asset(
                    //           "assets/image_rent/format-square.png",
                    //           height: 24,
                    //           width: 24,
                    //         ),
                    //         const SizedBox(width: 6),
                    //         Text(
                    //               () {
                    //             final item =widget.property_data;
                    //             final rawArea = double.tryParse(item['area']?.toString() ?? '') ?? 0.0;
                    //             final unit = item['area_in']?.toString() ?? 'Sq Ft';
                    //             final convertedArea = postController.convertToSqFt(rawArea, unit);
                    //             return '${convertedArea.toStringAsFixed(0)} Sq Ft';
                    //           }(),
                    //           style: const TextStyle(
                    //             fontSize: 14,
                    //             fontWeight: FontWeight.bold,
                    //             color: AppColor.black87,
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //     if (showFurnishing)
                    //       Row(
                    //         children: [
                    //           Image.asset(
                    //             "assets/image_rent/squareft.png",
                    //             height: 24,
                    //             width: 24,
                    //           ),
                    //           const SizedBox(width: 6),
                    //           Text(
                    //             widget.property_data['furnished_type'] ?? '',
                    //             style: const TextStyle(
                    //               fontSize: 14,
                    //               fontWeight: FontWeight.bold,
                    //               color: AppColor.black87,
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //   ],
                    // ),


                    ///
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [


                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Image.asset("assets/image_rent/money.png", height: 24, width: 24),
                                const SizedBox(width: 6),
                                widget.property_data['property_category_type']=="Rent"?
                                Text(
                                  ' ${postController.formatIndianPrice(widget.property_data['rent'].toString())}/ Month',
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                                    :
                                Text(
                                  postController.formatIndianPrice( widget.property_data['property_price'].toString()),
                                  style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Image.asset("assets/image_rent/format-square.png", height: 24, width: 24),
                                const SizedBox(width: 6),
                                Text(
                                      () {
                                    final item =widget.property_data;
                                    final rawArea = double.tryParse(item['area']?.toString() ?? '') ?? 0.0;
                                    final unit = item['area_in']?.toString() ?? 'Sq Ft';
                                    final convertedArea = postController.convertToSqFt(rawArea, unit);
                                    return '${convertedArea.toStringAsFixed(0)} Sq Ft';
                                  }(),
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


                        if (showBHK || showFurnishing)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (showBHK)
                                Row(
                                  children: [
                                    Image.asset("assets/image_rent/house.png", height: 24, width: 24),
                                    const SizedBox(width: 6),
                                    Text(
                                      widget.property_data['bhk_type'] ?? '',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: AppColor.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              if (showBHK && showFurnishing)
                                const SizedBox(height: 8),
                              if (showFurnishing)
                                Row(
                                  children: [
                                    Image.asset("assets/image_rent/squareft.png", height: 24, width: 24),
                                    const SizedBox(width: 6),
                                    Text(
                                      widget.property_data['furnished_type'] ?? '',
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

                        /// If nothing to show on right, show area here next to price
                        if (!showBHK && !showFurnishing)
                          Row(
                            children: [
                              const SizedBox(width: 16),
                              Image.asset("assets/image_rent/format-square.png", height: 24, width: 24),
                              const SizedBox(width: 6),
                              Text(
                                    () {
                                  final item =widget.property_data;
                                  final rawArea = double.tryParse(item['area']?.toString() ?? '') ?? 0.0;
                                  final unit = item['area_in']?.toString() ?? 'Sq Ft';
                                  final convertedArea = postController.convertToSqFt(rawArea, unit);
                                  return '${convertedArea.toStringAsFixed(0)} Sq Ft';
                                }(),
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


                    const SizedBox(height: 8),
                    Text(
                      '${widget.property_data['building_type']} : ${widget.property_data['property_type']}',
                      style: TextStyle(
                          fontSize: 14,
                          color: AppColor.black.withOpacity(0.6),fontWeight: FontWeight.bold
                      ),


                      overflow: TextOverflow.ellipsis,
                    ),
                    boxH10(),


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
                            //'${controller.getCommonPropertyList[index]['address']}',
                            widget.property_data['address_area'] ?? widget.property_data['address'],
                            maxLines: 1,
                            // maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: "Muli",
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Owner Information
                    Row(
                      children: [

                        CircleAvatar(
                          radius: 24,
                          backgroundImage: (widget.property_data.containsKey('property_owner_image') &&
                              widget.property_data['property_owner_image'] != null &&
                              widget.property_data['property_owner_image'].toString().isNotEmpty)
                              ? CachedNetworkImageProvider(
                            // controller.getCommonPropertyList[index]['profile_image'],
                            APIString.imageMediaBaseUrl+widget.property_data['property_owner_image'],
                          )
                              : null,
                          backgroundColor: AppColor.grey.withOpacity(0.1),
                          child: (widget.property_data.containsKey('property_owner_image') &&
                              widget.property_data['property_owner_image'] != null &&
                              widget.property_data['property_owner_image'].toString().isNotEmpty)
                              ? null
                              : ClipOval(
                            child: Image.asset(
                              'assets/image_rent/profile.png',
                              width: 30,
                              height: 30,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.property_data['connect_to_name']?.toString() ?? 'unknown',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              widget.property_data['user_type']?.toString() ?? 'unknown',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        )
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
  }

  String getImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return "";
    }
    if (imagePath.startsWith("http://") || imagePath.startsWith("https://")) {
      return imagePath;
    }
    return "http://13.127.244.70:4444/$imagePath";
  }

}

Future<void> shareProperty(String propertyId) async {
  final propertyUrl = 'http://customer.houzza.in/propertydetails/$propertyId';
  final playStoreUrl = 'https://play.google.com/store/apps/details?id=com.houzzaapp&hl=en';

  final message = '''
Hey! 👋

I found this 🏠property on Houzza and thought you might like it:
$propertyUrl

Download the Houzza app to explore more properties and get a better experience:
$playStoreUrl
''';

  await Share.share(message);
}