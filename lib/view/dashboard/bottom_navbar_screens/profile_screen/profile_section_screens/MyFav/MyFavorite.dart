import 'dart:async';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/common_widgets/height.dart';
import 'package:real_estate_app/global/api_string.dart';
import 'package:real_estate_app/global/app_color.dart';
import 'package:real_estate_app/view/auth/login_screen/login_screen.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/CustomBottomNavBar.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/profile_screen/profile_controller.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/profile_screen/profile_section_screens/my_virtual_tour/GetScheduleBottomSheet.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/search_screen/searchController.dart';
import 'package:real_estate_app/view/property_screens/post_property_screen/NewChanges/post_property_start_page.dart';
import 'package:real_estate_app/view/property_screens/properties_controllers/post_property_controller.dart';
import 'package:real_estate_app/view/property_screens/recommended_properties_screen/properties_details_screen.dart';
import 'package:real_estate_app/view/property_screens/recommended_properties_screen/propertyCard.dart';
import 'package:real_estate_app/view/top_developer/top_developer_details.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../splash_screen/splash_screen.dart';
import '../../../../../top_developer/top_rated_developer_list_screen.dart';

class MyFavorite extends StatefulWidget {
  const MyFavorite({super.key});

  @override
  State<MyFavorite> createState() => _MyFavoriteState();
}

class _MyFavoriteState extends State<MyFavorite> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  ProfileController profileController = Get.find();
  final controller = Get.find<searchController>();
  final postPropertyController = Get.find<PostPropertyController>();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Initialize TabController based on userType
    _tabController = TabController(
      //length: profileController.userType.value.toLowerCase() == 'owner' ? 1 : 2,
      length:  2,
      vsync: this,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getFavorite();
      controller.getFavoriteProject();
      // if (profileController.userType.value.toLowerCase() != 'owner') {
      //   controller.getFavoriteProject();
      // }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "My Favorites",
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        elevation: 0.4,
        leadingWidth: 40,
        leading: Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.black,
                width: 0.1,
              ),
            ),
            child: InkWell(
              onTap: () {
                Get.back();
              },
              borderRadius: BorderRadius.circular(50),
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
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            const Tab(text: 'Properties'),
          //  if (profileController.userType.value.toLowerCase() != 'owner')
              const Tab(text: 'Projects'),
          ],
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppColor.primaryThemeColor,
          indicatorSize: TabBarIndicatorSize.tab,
        ),
      ),
      body:
          TabBarView(
        controller: _tabController,
        children: [
          _buildFavoriteProperties(),
         // if (profileController.userType.value.toLowerCase() != 'owner')
            _buildFavoriteProjects(),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
      // bottomNavigationBar: Padding(
      //   padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      //   child: ElevatedButton(
      //     onPressed: () {
      //       Get.to(start_page());
      //     },
      //     style: ElevatedButton.styleFrom(
      //       backgroundColor: const Color(0xFF52C672),
      //       padding: const EdgeInsets.symmetric(vertical: 12),
      //       shape: RoundedRectangleBorder(
      //         borderRadius: BorderRadius.circular(30),
      //       ),
      //     ),
      //     child: const Text(
      //       "Post New Property",
      //       style: TextStyle(color: Colors.white, fontSize: 16),
      //     ),
      //   ),
      // ),
    );
  }

  Widget _buildFavoriteProperties() {
    return Obx(() => controller.getFavoriteList.isEmpty
        ? const Center(child: Text('No favorite properties added yet...'))
        : ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: controller.getFavoriteList.length,
      itemBuilder: (context, index) {
        // return Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        //   child: propertyCard(index),
        // );
        return propertyCard(
          property_data: controller.getFavoriteList[index],
          index: index,
          propertyList: controller.getFavoriteList,);

      },
    ));
  }

  Widget _buildFavoriteProjects() {
    return Obx(() => controller.getFavoriteProjectList.isEmpty
        ? const Center(child: Text('No favorite projects added yet...'))
        : ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: controller.getFavoriteProjectList.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          child: projectCard(controller.getFavoriteProjectList[index]),
        );
      },
    ));
  }

  Widget property1Card(int index) {
    return GestureDetector(
      onTap: () => Get.to(PropertyDetailsScreen(
        id: controller.getFavoriteList[index]['_id'],
      )),
      child: Container(
        width: Get.width * 0.95,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          border: Border.all(color: AppColor.grey.shade200, width: 2),
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
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                    ),
                    itemCount: () {
                      final property = controller.getFavoriteList.isNotEmpty && index < controller.getFavoriteList.length
                          ? controller.getFavoriteList[index]
                          : null;
                      if (property == null || (property['property_images'] == null && property['cover_image'] == null)) {
                        return 1; // Show placeholder if no data
                      }
                      final images = property['property_images'] as List<dynamic>? ?? [];
                      return images.isNotEmpty ? images.length : 1; // Use images length or 1 for cover_image/placeholder
                    }(),
                    itemBuilder: (context, imageIndex, realIndex) {
                      final property = controller.getFavoriteList.isNotEmpty && index < controller.getFavoriteList.length
                          ? controller.getFavoriteList[index]
                          : null;

                      // If no property data, show grey placeholder
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
                      final coverImg = property['cover_image'] as String? ?? '';

                      // If no images and no cover image, show grey placeholder
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

                      // If images list is empty, show cover image
                      if (images.isEmpty) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              CachedNetworkImage(
                                imageUrl: coverImg,
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
                              imageUrl: images[imageIndex]['image'],
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
                Positioned(
                  top: 10,
                  left: 04,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      "${controller.getFavoriteList[index]['days_since_created'].toString() ?? '0'} Days on Houzza",
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                // Bottom controls container
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
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
                        // "FOR BUY/RENT" tag
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                          decoration:  BoxDecoration(
                            // color: Color(0xFF52C672),
                            color:controller.getFavoriteList[index]['property_category_type'].toString() =="Rent"?
                            AppColor.primaryThemeColor:AppColor.green,
                            borderRadius: BorderRadius.only(topRight: Radius.circular(10)),
                          ),
                          child: Text(
                            "FOR ${controller.getFavoriteList[index]['property_category_type'].toUpperCase()}",
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),

                        // Dots indicator
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            controller.getFavoriteList[index]['property_images']?.length ?? 1,
                                (dotIndex) => Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _currentIndex == dotIndex
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.5),
                              ),
                            ),
                          ),
                        ),

                        // "featured" tag
                        controller.getFavoriteList[index]['mark_as_featured']=="Yes"?
                        GestureDetector(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                            decoration: const BoxDecoration(
                              color: Color(0xfffeb204),
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(10)),
                            ),
                            child: const Text(
                              "Featured",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                          onTap: () {},
                        ):SizedBox(),
                      ],
                    ),
                  ),
                ),

                // Positioned(
                //   top: 10,
                //   right: 50,
                //   child: GestureDetector(
                //     onTap: () {},
                //     child: Container(
                //       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                //       decoration: BoxDecoration(
                //         color: Colors.black.withOpacity(0.5),
                //         borderRadius: BorderRadius.circular(15),
                //       ),
                //       child: Row(
                //         children: [
                //           Image.asset(
                //             "assets/image_rent/VirtualTour.png",
                //             width: 20,
                //             height: 20,
                //           ),
                //           const SizedBox(width: 5),
                //           const Text(
                //             "Virtual Tour",
                //             style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                //           ),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),


                controller.getFavoriteList[index]['virtual_tour_availability']=="Yes"?
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
                            name: controller.getFavoriteList[index]['connect_to_name'],
                            userType: controller.getFavoriteList[index]['user_type'],
                            tour_type: 'Property',
                            propertyID: controller.getFavoriteList[index]['_id'],
                            propertyOwnerID: controller.getFavoriteList[index]['user_id'],
                          ),
                        );
                      } else {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                      }
                    },
                    child: Container(
                      padding:
                      const EdgeInsets
                          .symmetric(
                          horizontal: 8,
                          vertical: 5),
                      decoration:
                      BoxDecoration(
                        color: Colors.black
                            .withOpacity(0.5),
                        borderRadius:
                        BorderRadius
                            .circular(15),
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                              "assets/image_rent/VirtualTour.png",
                              width: 20,
                              height: 20),
                          const SizedBox(
                              width: 5),
                          const Text(
                            "Virtual Tour",
                            style: TextStyle(
                                color: Colors
                                    .white,
                                fontWeight:
                                FontWeight
                                    .bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ):const SizedBox(),
                // Favorite Icon (Heart)
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: () {
                      controller.removeFavorite(
                        property_id: controller.getFavoriteList[index]['is_favorite'].toString(),
                        favorite_id: controller.getFavoriteList[index]['favorite_id'].toString(),
                      ).then((value) => controller.getFavorite());
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        controller.getFavoriteList[index]['is_favorite']
                            ? Icons.favorite
                            : Icons.favorite_outline_outlined,
                        color: controller.getFavoriteList[index]['is_favorite']
                            ? AppColor.red
                            : Colors.white,
                        size: 22,
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
                    /// Property Name and Share Button
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            controller.getFavoriteList[index]['property_name'],
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


                            shareProperty(controller.getFavoriteList[index]['_id']);
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

                    /// Price & BHK Type
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
                            const SizedBox(width: 6),
                            // Text(
                            //   postPropertyController
                            //       .formatIndianPrice(controller.getFavoriteList[index]['property_price'].toString() ?? '0'),
                            //   style: const TextStyle(
                            //     fontSize: 14,
                            //     fontWeight: FontWeight.bold,
                            //     color: AppColor.black87,
                            //   ),
                            // ),
                            controller.getFavoriteList[index]['property_category_type']=="Rent"?
                            Text(
                              // '${postPropertyController.formatIndianPrice( controller.getFavoriteList[index]['property_price'].toString())} / '
                                  '${postPropertyController.formatIndianPrice(controller.getFavoriteList[index]['rent'].toString())}/ Month',
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                                :
                            Text(
                              //   _postPropertyController.formatIndianPrice(property['rent']),
                              postPropertyController.formatIndianPrice( controller.getFavoriteList[index]['property_price'].toString()),
                              style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold),
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
                            const SizedBox(width: 6),
                            Text(
                              controller.getFavoriteList[index]['bhk_type'],
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

                    /// Area & Furnishing Status
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
                            const SizedBox(width: 6),
                            Text(
                              '${controller.getFavoriteList[index]['area']?.toString() ?? ''} ${controller.getFavoriteList[index]['area_in']?.toString() ?? ''}'.trim(),
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
                            const SizedBox(width: 6),
                            Text(
                              controller.getFavoriteList[index]['furnished_type'] ?? '',
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
                    Text(
                      '${controller.getFavoriteList[index]['building_type']} : ${controller.getFavoriteList[index]['property_type']}',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColor.black.withOpacity(0.6),fontWeight: FontWeight.bold
                      ),


                      overflow: TextOverflow.ellipsis,
                    ),
                    boxH10(),
                    /// Address & City Name
                    // Text(
                    //   '${controller.getFavoriteList[index]['address']},\n${controller.getFavoriteList[index]['city_name']}',
                    //   style: TextStyle(
                    //     fontSize: 14,
                    //     color: AppColor.black.withOpacity(0.6),
                    //   ),
                    //   maxLines: 2,
                    //   overflow: TextOverflow.ellipsis,
                    // ),

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
                            //controller.getFavoriteList[index]['address'] ?? "",
                            controller.getFavoriteList[index]['address_area'] ?? controller.getFavoriteList[index]['address'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: "Muli",
                            ),
                          ),
                        ),
                      ],
                    ),

                    boxH15(),

                    /// Owner Information
                    Row(
                      children: [
                        // CircleAvatar(
                        //   radius: 24,
                        //   backgroundColor: AppColor.grey.withOpacity(0.1),
                        //   child: ClipOval(
                        //     child: Image.asset(
                        //       'assets/image_rent/profile.png',
                        //       width: 30,
                        //       height: 30,
                        //       fit: BoxFit.cover,
                        //     ),
                        //   ),
                        // ),

                        CircleAvatar(
                          radius: 24,
                          backgroundImage: (controller.getFavoriteList[index].containsKey('property_owner_image') &&
                              controller.getFavoriteList[index]['property_owner_image'] != null &&
                              controller.getFavoriteList[index]['property_owner_image'].toString().isNotEmpty)
                              ? CachedNetworkImageProvider(
                            // controller.getRecommendedPropertyList[index]['profile_image'],
                            APIString.imageMediaBaseUrl+controller.getFavoriteList[index]['property_owner_image'],
                          )
                              : null,
                          backgroundColor: AppColor.grey.withOpacity(0.1),
                          child: (controller.getFavoriteList[index].containsKey('property_owner_image') &&
                              controller.getFavoriteList[index]['property_owner_image'] != null &&
                              controller.getFavoriteList[index]['property_owner_image'].toString().isNotEmpty)
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

                        boxW15(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.getFavoriteList[index]['connect_to_name'] ?? 'unknown',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              controller.getFavoriteList[index]['user_type'] ?? 'unknown',
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

  Widget projectCard(var project) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        Get.to(TopDevelopersDetails(
          projectID: project['_id'].toString(),
        ))?.then((value) {
          if (value != null) {
            setState(() {
              // If you're just updating isFavorite
              project['is_favorite'] = value;

              print("widget.property_data['isFavorite']--->");
              print(project['is_favorite']);
              print(value);


            });
          }
        });
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.60,
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        child: Stack(
          children: [
            // Main Image
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: project['cover_image'] != null && project['cover_image'].isNotEmpty
                  ? CachedNetworkImage(
                imageUrl: project['cover_image'],
                height: height * 0.4,
                width: width * 0.9,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => Image.asset(
                  'assets/image_rent/langAsiaCity.png',
                  height: height * 0.4,
                  width: width * 0.9,
                  fit: BoxFit.cover,
                ),
              )
                  : Image.asset(
                'assets/image_rent/langAsiaCity.png',
                height: height * 0.4,
                width: width * 0.9,
                fit: BoxFit.cover,
              ),
            ),

            // Overlay Content
            Positioned(
              bottom: 0,
              right: 20.0,
              left: 20.0,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top dark section with developer name
                      Container(
                        height: height * 0.15,
                        width: width * 0.9,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                          ),
                        ),
                        child: Stack(
                          children: [
                            // Blurred background image
                            if (project['cover_image'] != null && project['cover_image'].isNotEmpty)
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15),
                                ),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Image.network(
                                      project['cover_image'],
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          color: Colors.black.withOpacity(0.7),
                                        );
                                      },
                                    ),
                                    BackdropFilter(
                                      filter: ImageFilter.blur(sigmaX: 50.0, sigmaY: 50.0),
                                      child: Container(
                                        color: Colors.black.withOpacity(0.5),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            else
                              Container(
                                color: Colors.black.withOpacity(0.7),
                              ),

                            // Text content
                            Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 30),
                                child: Text(
                                  project['project_name']??"",
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Bottom white section with details
                      Container(
                        height: width * 0.35,
                        width: width * 0.9,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          ),
                          border: Border.all(
                            width: 0.5,
                            color: Colors.grey,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 10,
                        ),
                        child:Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            // Row(
                            //   crossAxisAlignment: CrossAxisAlignment.start,
                            //   children: [
                            //     Image.asset(
                            //       "assets/address-location.png",
                            //       height: 25,
                            //       width: 25,
                            //     ),
                            //     const SizedBox(width: 5),
                            //     Expanded(
                            //       child: Text(
                            //         project['address'],
                            //         maxLines: 3,
                            //         overflow: TextOverflow.ellipsis,
                            //         style: const TextStyle(
                            //           fontFamily: "Muli",
                            //         ),
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            Text(
                              project['congfigurations'].toString(),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              project['project_type'],
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            // Text(
                            //   project['address_area'] ?? project['address'],
                            //   style: const TextStyle(
                            //     fontSize: 14,
                            //     fontWeight: FontWeight.bold,
                            //     color: Colors.black54,
                            //     overflow: TextOverflow.ellipsis,
                            //   ),
                            //   maxLines: 1,
                            //   overflow: TextOverflow.ellipsis,
                            // ),

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
                                  child:  Text(
                                    // "city_name": "Nagpur",
                                    // "country": "India",
                                    // "state": "Maharashtra",
                                    project['city_name']+", " +project['state'],
                                    //project['address_area'] ?? project['address'],
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),


                            boxH05(),
                            Text(
                              postPropertyController.formatPriceRange(project['average_project_price']),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),

                          ],
                        ),
                      ),
                    ],
                  ),

                  // Circular logo image - Centered version
                  Positioned(
                    top: -(height * 0.058),
                    left: 0,
                    right: 0,
                    child: Center(
                      child: ClipOval(
                        child: SizedBox(
                          width: height * 0.12,
                          height: height * 0.12,
                          child: project['logo'] != null
                              ? CachedNetworkImage(
                            imageUrl: project['logo'],
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) => Image.asset(
                              'assets/image_rent/langAsiaCity.png',
                              fit: BoxFit.cover,
                            ),
                          )
                              : Image.asset(
                            'assets/image_rent/langAsiaCity.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Positioned(
            //   top: 10,
            //   right: 10,
            //   child: GestureDetector(
            //     onTap: () {
            //       controller.removeFavoriteProject(
            //         project_id: project['is_favorite'].toString(),
            //         favorite_id: project['favorite_id'].toString(),
            //       ).then((value) => controller.getFavoriteProject());
            //     },
            //     child: Container(
            //       padding: const EdgeInsets.all(5),
            //       decoration: const BoxDecoration(
            //         color: Colors.white,
            //         shape: BoxShape.circle,
            //       ),
            //       child: Icon(
            //         project['is_favorite'] ? Icons.favorite : Icons.favorite_outline_outlined,
            //         color: project['is_favorite'] ? AppColor.red : Colors.white,
            //         size: 22,
            //       ),
            //     ),
            //   ),
            // ),

            Positioned(
              top: 10,
              right: 10,
              child: Row(

                children: [
                  /// Favorite Icon
                  // GestureDetector(
                  //   onTap: () {
                  //     controller.removeFavoriteProject(
                  //       project_id: project['is_favorite'].toString(),
                  //       favorite_id: project['favorite_id'].toString(),
                  //     ).then((value) => controller.getFavoriteProject());
                  //   },
                  //   child: Container(
                  //     padding: const EdgeInsets.all(5),
                  //     decoration: const BoxDecoration(
                  //       color: Colors.white,
                  //       shape: BoxShape.circle,
                  //     ),
                  //     child: Icon(
                  //       project['is_favorite'] ? Icons.favorite : Icons.favorite_outline_outlined,
                  //       color: project['is_favorite'] ? AppColor.red : Colors.white,
                  //       size: 22,
                  //     ),
                  //   ),
                  // ),

                  Container(
                    height: 36,
                    width: 36,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.8),
                    ),
                    child: InkWell(
                      onTap: () {


                        if (isLogin == true) {
                          controller.removeFavoriteProject(
                            project_id: project['is_favorite'].toString(),
                            favorite_id: project['favorite_id'].toString(),
                          ).then((value) => controller.getFavoriteProject());
                        }

                      },
                      borderRadius: BorderRadius.circular(50),
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Icon(
                          (project['is_favorite'] == true) ? Icons.favorite : Icons.favorite_border,
                          color: (project['is_favorite'] == true) ? Colors.red : Colors.black.withOpacity(0.6),
                          size: 25.0,
                        ),
                      ),
                    ),
                  ),

                  /// Share Icon
                  Container(
                    height: 36,
                    width: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.8),
                    ),
                    child: InkWell(
                      onTap: () async {

                        shareProject(project['_id']);

                      },
                      borderRadius: BorderRadius.circular(50),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Image.asset(
                          "assets/image_rent/share.png",
                          height: 16,
                          width: 16,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}