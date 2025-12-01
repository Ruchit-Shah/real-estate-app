import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:real_estate_app/common_widgets/height.dart';
import 'package:real_estate_app/global/api_string.dart';
import 'package:real_estate_app/global/app_color.dart';
import 'package:real_estate_app/utils/text_style.dart';
import 'package:real_estate_app/view/auth/login_screen/login_screen.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/search_screen/searchController.dart';
import 'package:real_estate_app/view/property_screens/properties_controllers/post_property_controller.dart';
import 'package:real_estate_app/view/property_screens/recommended_properties_screen/properties_details_screen.dart';
import 'package:real_estate_app/view/property_screens/recommended_properties_screen/propertyCard.dart';
import 'package:real_estate_app/view/splash_screen/splash_screen.dart';

import '../profile_screen/profile_section_screens/my_virtual_tour/GetScheduleBottomSheet.dart';

class OfferDetailsScreen extends StatefulWidget {
  final Map<String,dynamic> property;
  const OfferDetailsScreen({super.key,required this.property});

  @override
  State<OfferDetailsScreen> createState() => _OfferDetailsScreenState();
}

class _OfferDetailsScreenState extends State<OfferDetailsScreen> {
  late final Map<String,dynamic> offer;
  late final Map<String,dynamic> propertyData;
  final PostPropertyController controller = Get.find();
  final searchApiController = Get.find<searchController>();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    getData();
    offer = widget.property ?? {};
    propertyData = widget.property['property_data'] ?? {};
  }

  void getData()  {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await controller.getOfferProperty(offerId: widget.property['_id'])
          .then((value) => print('data : ${controller.getOfferdPropertyList}'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Offer Details",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 46,
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
              onTap: () => Get.back(),
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
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Container(
                width: Get.width,
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColor.grey.withOpacity(0.1)),
                  color: AppColor.grey.shade50,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    Container(
                      width: double.infinity,
                      height: Get.height * 0.2,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                        color: AppColor.white,
                      ),
                      child: offer['offer_img'] != null
                          ? ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                        child: CachedNetworkImage(
                          imageUrl: APIString.imageBaseUrl + offer['offer_img'],
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              Container(color: Colors.grey[300]),
                          errorWidget: (context, url, error) =>
                          const Icon(Icons.error, color: Colors.grey),
                        ),
                      )
                          : const Center(
                        child: Icon(Icons.image_rounded, size: 50, color: Colors.grey),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            offer['offer_name'] ?? 'No Title',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            offer['offer_description'] ?? 'No description available',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              boxH05(),

              Obx(() {
                if (controller.getOfferdPropertyList.isEmpty) {
                  return const Center(child: Text('No property available for this offer'));
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.getOfferdPropertyList.length,
                  itemBuilder: (context, index) {

                    return propertyCard( property_data: controller.getOfferdPropertyList[index], index: index, propertyList: controller.getOfferdPropertyList,);

                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}