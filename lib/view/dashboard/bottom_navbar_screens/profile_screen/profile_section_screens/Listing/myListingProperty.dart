import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/common_widgets/height.dart';
import 'package:real_estate_app/global/app_color.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/profile_screen/profile_controller.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/profile_screen/profile_section_screens/Listing/LeadsPage.dart';
import 'package:real_estate_app/view/property_screens/post_property_screen/edit_property_screen.dart';
import 'package:real_estate_app/view/property_screens/recommended_properties_screen/properties_details_screen.dart';

class MyListingProperty extends StatefulWidget {
  const MyListingProperty({super.key});

  @override
  State<MyListingProperty> createState() => _MyListingPropertyState();
}

class _MyListingPropertyState extends State<MyListingProperty> {
  final List<String> stausTypes = [
    'All',
    'Leads',
    'Active',
    'Expired',
    'Under Review',
    'Rejected',
    'Deleted'
  ];

  int _selectedStatusIndex = 0;
  ProfileController profileController = Get.put(ProfileController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      profileController.getMyListingProperties(isfrom: "");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          if (false)
            Padding(
              padding: const EdgeInsets.only(right: 5.0, left: 5.0),
              child: SizedBox(
                height: 60,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: stausTypes.length,
                  itemBuilder: (context, index) {
                    bool isSelected = _selectedStatusIndex == index;
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedStatusIndex = index;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.linear,
                          width: 100,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                isSelected
                                    ? AppColor.blue.shade50
                                    : AppColor.grey.withOpacity(0.1),
                                isSelected
                                    ? AppColor.blue.shade50
                                    : AppColor.grey.withOpacity(0.1),
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(10.0),
                          child: Center(
                            child: Text(
                              stausTypes[index],
                              style: TextStyle(
                                color: isSelected ? AppColor.blue : AppColor.black87,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                overflow: TextOverflow.ellipsis,
                                fontFamily: 'Roboto',
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

          Expanded(
            child: Container(
              color: Colors.grey.shade100,
              width: MediaQuery.of(context).size.width * 1,
              child: Obx(
                    () => profileController.myListingPrperties.isEmpty
                    ? Center(
                  child: Text(
                    'No listings found',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blueGrey,
                    ),
                  ),
                )
                    : ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: profileController.myListingPrperties.length,
                  itemBuilder: (context, index) {
                    final property = profileController.myListingPrperties[index];
                    final propertyId = property['_id']?.toString() ?? '';
                    final coverImage = property['cover_image']?.toString();
                    final propertyName = property['property_name']?.toString() ?? 'Unnamed Property';
                    final activeStatus = property['active_status']?.toString() ?? 'Unknown';
                    final propertyType = property['property_type']?.toString() ?? '';
                    final bhkType = property['bhk_type']?.toString() ?? '';
                    final cityName = property['city_name']?.toString() ?? '';
                    final furnishedType = property['furnished_type']?.toString() ?? 'Not specified';
                    final categoryPriceType = property['category_price_type']?.toString() ?? '';
                    final propertyPrice = property['property_price']?.toString() ?? '0';
                    final safetyDeposit = property['safety_deposit']?.toString() ?? '0';
                    final propertyAddedDate = property['property_added_date']?.toString() ?? '';
                    final expiryDate = property['expiry_date']?.toString() ?? '';

                    return GestureDetector(
                      onTap: () {
                        if (propertyId.isNotEmpty) {
                          Get.to(PropertyDetailsScreen(id: propertyId));
                        }
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 1,
                        height: Get.width * 0.86,
                        child: Card(
                          elevation: 0.2,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const Spacer(),
                                    InkWell(
                                      onTap: () {
                                        if (propertyId.isNotEmpty) {
                                          showDeleteConfirmationDialog(context, propertyId);
                                        }
                                      },
                                      child: Icon(Icons.delete,
                                        color: Colors.red.shade300,
                                        size: 20,
                                      ),
                                    ),
                                    boxW08(),
                                    InkWell(
                                      onTap: () {
                                        Get.to(edit_property_screen(data: property));
                                      },
                                      child: const Icon(Icons.edit,
                                        color: Colors.blue,
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(
                                  height: 17,
                                  thickness: 0.8,
                                  color: Colors.grey.shade300,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: coverImage != null
                                          ? CachedNetworkImage(
                                        width: 120,
                                        height: 120,
                                        fit: BoxFit.cover,
                                        imageUrl: coverImage,
                                        placeholder: (context, url) => Container(
                                          width: 120,
                                          height: 120,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) => const Icon(Icons.error),
                                      )
                                          : Container(
                                        color: Colors.grey[400],
                                        child: const Center(
                                          child: Icon(Icons.image_rounded),
                                        ),
                                      ),
                                    ),
                                    boxW10(),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  propertyName,
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: activeStatus == 'Active'
                                                      ? Colors.green.withOpacity(0.2)
                                                      : Colors.red.withOpacity(0.2),
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: Text(
                                                  activeStatus,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: activeStatus == 'Active'
                                                        ? Colors.green
                                                        : Colors.red,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          boxH05(),
                                          Text(
                                            [propertyType, bhkType].where((s) => s.isNotEmpty).join(', '),
                                            style: const TextStyle(fontSize: 14, color: Colors.black),
                                          ),
                                          boxH05(),
                                          Text(
                                            cityName,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          boxH05(),
                                          Text(
                                            'Furnish Type: $furnishedType',
                                            style: const TextStyle(fontSize: 14, color: Colors.grey),
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                categoryPriceType == 'Rent'
                                                    ? 'Rent: ₹$propertyPrice'
                                                    : 'Sell: ₹$propertyPrice',
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blue,
                                                ),
                                              ),
                                              categoryPriceType == 'Rent'
                                                  ? Text(
                                                'Deposit: ₹$safetyDeposit',
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blueAccent,
                                                ),
                                              )
                                                  : const SizedBox(),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                boxH15(),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.blue.withOpacity(0.1),
                                  ),
                                  width: MediaQuery.of(context).size.width,
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Last Added',
                                            style: TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            propertyAddedDate,
                                            style: const TextStyle(
                                              color: Colors.black87,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          if (propertyId.isNotEmpty) {
                                            Get.to(propertyEnquiry(data: propertyId));
                                          }
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                            decoration: BoxDecoration(
                                              color: Colors.blue.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(color: Colors.blue, width: 0.5),
                                            ),
                                            child: const Center(
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 8.0),
                                                child: Text(
                                                  'Leads',
                                                  style: TextStyle(
                                                    color: Colors.blue,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Expiring On',
                                            style: TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                          boxH05(),
                                          Text(
                                            expiryDate,
                                            style: const TextStyle(
                                              color: Colors.black87,
                                              fontSize: 12,
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
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showDeleteConfirmationDialog(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          content: const Text(
            "Are you sure you want to delete this listing?",
            style: TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blueGrey,
                textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              child: const Text("Cancel"),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blueGrey,
                textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                if (id.isNotEmpty) {
                  profileController.deleteMyListing(id: id);
                }
                Navigator.of(context).pop();
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }
}