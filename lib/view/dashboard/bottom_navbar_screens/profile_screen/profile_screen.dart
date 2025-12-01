import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:real_estate_app/common_widgets/custom_textformfield.dart';
import 'package:real_estate_app/common_widgets/height.dart';
import 'package:real_estate_app/common_widgets/loading_dart.dart';
import 'package:real_estate_app/global/app_color.dart';
import 'package:real_estate_app/utils/common_snackbar.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/CustomBottomNavBar.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/profile_screen/profile_controller.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/profile_screen/profile_section_screens/MyFav/MyFavorite.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/profile_screen/profile_section_screens/MyProjects/MyProjects.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/save_screen/save_screen.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/profile_screen/profile_section_screens/my_virtual_tour/my_virtual_tour_screen.dart';

import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/search_screen/search_screen.dart';

import 'package:real_estate_app/view/dashboard/view/BottomNavbar.dart';
import 'package:real_estate_app/view/property_screens/post_property_screen/NewChanges/post_project_start_page.dart';
import 'package:real_estate_app/view/property_screens/post_property_screen/NewChanges/post_property_start_page.dart';
import 'package:real_estate_app/view/property_screens/properties_controllers/post_property_controller.dart';
import '../../../../utils/String_constant.dart';
import '../../../../utils/shared_preferences/shared_preferances.dart';
import '../../../auth/login_screen/login_screen.dart';
import '../../../splash_screen/splash_screen.dart';
import 'EditProfileFieldScreen.dart';
import 'about_us.dart';
import 'profile_section_screens/Advertisement/Advertisements.dart';
import 'profile_section_screens/My Properties/MyProperties.dart';
import 'profile_section_screens/MyLeads/MyLeads.dart';
import 'profile_section_screens/MyOffers/OffersProperties.dart';
import 'profile_section_screens/PlansAndSubscriptions/PlansAndSubscription.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String city = "Fetching city...";
  String isDeveloper = "";
  ProfileController profileController = Get.find();
  final PostPropertyController controller = Get.find();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_)async{
      await profileController.getProfile();
      print("user type :${profileController.userType.value}");
    });
    getData();
  }

  getData() async {

    isDeveloper =
        (await SPManager.instance.getTopDevelopers(TopDevelopers)) ?? "no";
    city = (await SPManager.instance.getCity(CITY))??"Pune";
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Profile",
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
                color: Colors.black, // Border color
                width: 0.1, // Border width
              ),
            ),
            child: InkWell(
              onTap: () {
                Get.offAll(const BottomNavbar());
              },
              borderRadius: BorderRadius.circular(
                  50), // Ensures ripple effect is circular
              child: const Padding(
                padding: EdgeInsets.all(6), // Adjust padding for better spacing
                child: Icon(
                  Icons.arrow_back_outlined,
                  size: 18, // Slightly increased for better visibility
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: isLogin == true
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  boxH05(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() {
                          return profileController.profileImage.isNotEmpty
                              ?  ClipOval(
                            child: (profileController.profileImage.isEmpty ||
                                profileController.profileImage.contains('default_profile'))
                                ?Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.purple[50],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipOval(
                                  child: Image.asset(
                                    'assets/image_rent/profileImg.png',
                                    fit: BoxFit.contain,
                                    width: 15,
                                    height: 15,
                                  ),
                                ),
                              ),
                            )
                                : Image.network(
                              profileController.profileImage.value,
                              fit: BoxFit.cover,
                              width: 50,
                              height: 50,
                              errorBuilder: (_, __, ___) => Image.asset(
                                'assets/image_rent/profileImg.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          )
                              : Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.purple[50],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ClipOval(
                                      child: Image.asset(
                                        'assets/image_rent/profileImg.png',
                                        fit: BoxFit.contain,
                                        width: 15,
                                        height: 15,
                                      ),
                                    ),
                                  ),
                                );
                        }),
                        const SizedBox(width: 15),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => Get.to(
                                    () => const EditProfileBottomSheet()),
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Obx(()=>
                                    Text(
                                        profileController.name.value ?? "",
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const Text(
                                      "View Profile",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Padding(
                                  padding: const EdgeInsets.only(right: 16.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      Get.to(
                                          () => const EditProfileBottomSheet());
                                    },
                                    child: const Icon(
                                      Icons.arrow_forward,
                                      color: Colors.black,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Obx(() => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                    child: profileController.userType.value.toLowerCase() != 'owner'
                        ? Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Get.to(const start_page(isFrom: 'myproperties'));
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Center(
                                    child: Image.asset(
                                      'assets/image_rent/profilePropertyImg.png',
                                      width: 100,
                                      height: 80,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF72E23E),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Text(
                                      "FREE",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    "Post Property",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    "AI base property\nmanagement",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        boxW10(),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                            //  Get.to(const start_page());
                              Get.to(() => const project_start_page(isFrom: "myprojects"));
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Center(
                                    child: Image.asset(
                                      'assets/image_rent/profilePropertyImg.png',
                                      width: 100,
                                      height: 80,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF72E23E),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Text(
                                      "FREE",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    "Post Projects",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    "AI base property\nmanagement",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                        : GestureDetector(
                      onTap: () {
                        Get.to(const start_page(isFrom: 'myproperties'));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF72E23E),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Text(
                                      "FREE",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    "Post Property",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    "AI base property\nmanagement",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Image.asset(
                                'assets/image_rent/profilePropertyImg.png',
                                width: 100,
                                height: 80,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )),

                  /// manage property
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0, left: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Manage Property",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black.withOpacity(0.5),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        boxH15(),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: 1.5,
                            ),
                            color: Colors.white,
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                title: const Text(
                                  "My Properties",
                                  style: TextStyle(fontSize: 17),
                                ),
                                trailing: const Icon(
                                  Icons.arrow_forward,
                                  color: Colors.black,
                                ),
                                onTap: () {
                                  Get.to(const MyProperties());
                                },
                              ),




                              Obx(() => profileController.userType.value.toLowerCase() != 'owner'
                                  ? Column(
                                children: [
                                  Container(
                                    height: 1.5, // Border thickness
                                    color: Colors.grey.shade300, // Border color
                                  ),
                                  ListTile(
                                    title: const Text(
                                      "My Projects",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    trailing: const Icon(
                                      Icons.arrow_forward,
                                      color: Colors.black,
                                    ),
                                    onTap: () {
                                      Get.to(const MyProjects());
                                    },
                                  ),
                                ],
                              )
                                  : const SizedBox.shrink()),
                              Container(
                                height: 1.5, // Border thickness
                                color: Colors.grey.shade300, // Border color
                              ),
                              ListTile(
                                title: const Text(
                                  "My Leads",
                                  style: TextStyle(fontSize: 17),
                                ),
                                trailing: const Icon(
                                  Icons.arrow_forward,
                                  color: Colors.black,
                                ),
                                onTap: () {
                                  Get.to(const MyLeads());
                                },
                              ),
                              Container(
                                height: 1.5, // Border thickness
                                color: Colors.grey.shade300, // Border color
                              ),
                              ListTile(
                                title: const Text(
                                  "Plan / Subscription",
                                  style: TextStyle(fontSize: 17),
                                ),
                                trailing: const Icon(
                                  Icons.arrow_forward,
                                  color: Colors.black,
                                ),
                                onTap: () {
                                  Get.to(const PlansAndSubscription(isfrom: 'all',));
                                },
                              ),
                              Container(
                                height: 1.5, // Border thickness
                                color: Colors.grey.shade300, // Border color
                              ),
                              ListTile(
                                title: const Text(
                                  "Offer / Promote",
                                  style: TextStyle(fontSize: 17),
                                ),
                                trailing: const Icon(
                                  Icons.arrow_forward,
                                  color: Colors.black,
                                ),
                                onTap: () {
                                  Get.to( OffersProperties(isfrom: '', id: '', property: null,));
                                },
                              ),
                              // Container(
                              //   height: 1.5, // Border thickness
                              //   color: Colors.grey.shade300, // Border color
                              // ),
                              // ListTile(
                              //   title: const Text(
                              //     "Advertisement",
                              //     style: TextStyle(fontSize: 17),
                              //   ),
                              //   trailing: const Icon(
                              //     Icons.arrow_forward,
                              //     color: Colors.black,
                              //   ),
                              //   onTap: () {
                              //     Get.to(const Advertisements());
                              //   },
                              // ),
                              Container(
                                height: 1.5, // Border thickness
                                color: Colors.grey.shade300, // Border color
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  ///Services
                  Padding(
                    padding: const EdgeInsets.only(
                        right: 16.0, left: 16.0, top: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Services",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black.withOpacity(0.5),
                              fontWeight: FontWeight.bold),
                        ),
                        boxH15(),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: 1.5,
                            ),
                            color: Colors.white,
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                title: const Text(
                                  "My Virtual Tour",
                                  style: TextStyle(fontSize: 17),
                                ),
                                trailing: const Icon(
                                  Icons.arrow_forward,
                                  color: Colors.black,
                                ),
                                onTap: () {
                                  Get.to(const MyVirtualTourScreen());
                                },
                              ),
                              Container(
                                height: 1.5, // Border thickness
                                color: Colors.grey.shade300, // Border color
                              ),
                              ListTile(
                                title: const Text(
                                  "My Favorite ",
                                  style: TextStyle(fontSize: 17),
                                ),
                                trailing: const Icon(
                                  Icons.arrow_forward,
                                  color: Colors.black,
                                ),
                                onTap: () {
                                  /// add favorite instead of featured property
                                  // Get.to(PropertiesListScreen(
                                  //   isFrom: 'profile',
                                  //   data: controller.getFeaturedPropery,
                                  // ));
                                  Get.to(const MyFavorite());
                                },
                              ),
                              Container(
                                height: 1.5, // Border thickness
                                color: Colors.grey.shade300, // Border color
                              ),
                              ListTile(
                                title: const Text(
                                  "Save Searches ",
                                  style: TextStyle(fontSize: 17),
                                ),
                                trailing: const Icon(
                                  Icons.arrow_forward,
                                  color: Colors.black,
                                ),
                                onTap: () {
                                  Get.to(const SaveScreen(
                                    isFrom: 'profile', isfrom: '',
                                  ));
                                },
                              ),
                              Container(
                                height: 1.5, // Border thickness
                                color: Colors.grey.shade300, // Border color
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),

                  /// Others
                  // Padding(
                  //   padding: const EdgeInsets.only(right: 16.0, left: 16.0),
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     mainAxisAlignment: MainAxisAlignment.start,
                  //     children: [
                  //       Text(
                  //         "Others",
                  //         style: TextStyle(
                  //             fontSize: 16,
                  //             color: Colors.black.withOpacity(0.5),
                  //             fontWeight: FontWeight.bold),
                  //       ),
                  //       boxH15(),
                  //       Container(
                  //         decoration: BoxDecoration(
                  //           borderRadius: BorderRadius.circular(16),
                  //           border: Border.all(
                  //             color: Colors.grey.shade300,
                  //             width: 1.5,
                  //           ),
                  //           color: Colors.white,
                  //         ),
                  //         child: Column(
                  //           children: [
                  //             ListTile(
                  //               title: const Text(
                  //                 "About",
                  //                 style: TextStyle(fontSize: 17),
                  //               ),
                  //               trailing: const Icon(
                  //                 Icons.arrow_forward,
                  //                 color: Colors.black,
                  //               ),
                  //               onTap: () {
                  //                 Get.to(AboutUs(isFrom: 'about_us',));
                  //               },
                  //             ),
                  //             Container(
                  //               height: 1.5, // Border thickness
                  //               color: Colors.grey.shade300, // Border color
                  //             ),
                  //             ListTile(
                  //               title: const Text(
                  //                 "Privacy policy",
                  //                 style: TextStyle(fontSize: 17),
                  //               ),
                  //               trailing: const Icon(
                  //                 Icons.arrow_forward,
                  //                 color: Colors.black,
                  //               ),
                  //               onTap: () {
                  //                 Get.to(AboutUs(isFrom: 'policy',));
                  //               },
                  //             ),
                  //             Container(
                  //               height: 1.5, // Border thickness
                  //               color: Colors.grey.shade300, // Border color
                  //             ),
                  //             ListTile(
                  //               title: const Text(
                  //                 "Terms and conditions",
                  //                 style: TextStyle(fontSize: 17),
                  //               ),
                  //               trailing: const Icon(
                  //                 Icons.arrow_forward,
                  //                 color: Colors.black,
                  //               ),
                  //               onTap: () {
                  //                 Get.to(AboutUs(isFrom: 'TandC',));
                  //               },
                  //             ),
                  //             Container(
                  //               height: 1.5, // Border thickness
                  //               color: Colors.grey.shade300, // Border color
                  //             ),
                  //             ListTile(
                  //               title: const Text(
                  //                 "FAQ",
                  //                 style: TextStyle(fontSize: 17),
                  //               ),
                  //               trailing: const Icon(
                  //                 Icons.arrow_forward,
                  //                 color: Colors.black,
                  //               ),
                  //               onTap: () {
                  //                 Get.to(AboutUs(isFrom: 'faq',));
                  //               },
                  //             ),
                  //             Container(
                  //               height: 1.5, // Border thickness
                  //               color: Colors.grey.shade300, // Border color
                  //             ),
                  //             ListTile(
                  //               title: const Text(
                  //                 "Settings",
                  //                 style: TextStyle(fontSize: 17),
                  //               ),
                  //               trailing: const Icon(
                  //                 Icons.arrow_forward,
                  //                 color: Colors.black,
                  //               ),
                  //               onTap: () {
                  //                 Get.to(AboutUs(isFrom: 'about_us',));
                  //               },
                  //             ),
                  //             Container(
                  //               height: 1.5, // Border thickness
                  //               color: Colors.grey.shade300, // Border color
                  //             ),
                  //             ListTile(
                  //               title: const Text(
                  //                 "Feedback",
                  //                 style: TextStyle(fontSize: 17),
                  //               ),
                  //               trailing: const Icon(
                  //                 Icons.arrow_forward,
                  //                 color: Colors.black,
                  //               ),
                  //               onTap: () => rateUs(context),
                  //             ),
                  //             Container(
                  //               height: 1.5, // Border thickness
                  //               color: Colors.grey.shade300, // Border color
                  //             ),
                  //             ListTile(
                  //               title: const Text(
                  //                 "Logout",
                  //                 style: TextStyle(fontSize: 17),
                  //               ),
                  //               trailing: const Icon(
                  //                 Icons.arrow_forward,
                  //                 color: Colors.black,
                  //               ),
                  //               onTap: () async {
                  //                 await _onLogoutPressed(context);
                  //               },
                  //             ),
                  //             Container(
                  //               height: 1.5, // Border thickness
                  //               color: Colors.grey.shade300, // Border color
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),

                  boxH10(),
                  /// Others
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0, left: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                              Text(
                                "Others",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black.withOpacity(0.5),
                                    fontWeight: FontWeight.bold),
                              ),
                              boxH15(),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: 1.5,
                            ),
                            color: Colors.white,
                          ),
                          child: ListTile(
                            title: const Text(
                              "Settings",
                              style: TextStyle(fontSize: 17),
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward,
                              color: Colors.black,
                            ),
                            onTap: () {
                              Get.to(() => const SettingsPage(isfrom: "login",));
                            },
                          ),
                        ),
                      ],
                    ),

                  ),
                  boxH10(),
                  boxH10(),

                  // Center(
                  //     child: TextButton(
                  //   onPressed: () {
                  //     showDeleteAccountDialog(context,() {
                  //       profileController.deleteUserAcc(context);
                  //     },);
                  //   },
                  //   child: const Text(
                  //     "Delete account",
                  //     style: TextStyle(
                  //       fontSize: 18,
                  //       fontWeight: FontWeight.bold,
                  //       color: Color(0xFFEA4335),
                  //     ),
                  //   ),
                  // ))
                ],
              )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            boxH05(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.purple[50],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/image_rent/profileImg.png',
                            fit: BoxFit.contain,
                            width: 15,
                            height: 15,
                          ),
                        ),
                      ),
                    ),

                  const SizedBox(width: 15),
                  const Expanded(
                    child: Text(
                      "Hello User...!",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            boxH10(),
            Center(
              child: commonButton(
                width: Get.width * 0.9,
                text: "Login",
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(),

                )),),
            ),
            boxH10(),
            // Padding(
            //   padding: const EdgeInsets.symmetric(
            //       horizontal: 16.0, vertical: 16.0),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.start,
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Expanded(
            //         child: GestureDetector(
            //           onTap: () {
            //            // Get.to(start_page());
            //           },
            //           child: Container(
            //             padding: const EdgeInsets.all(16),
            //             decoration: BoxDecoration(
            //               color: Colors.white,
            //               borderRadius: BorderRadius.circular(16),
            //             ),
            //             child: Column(
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               mainAxisSize: MainAxisSize.min,
            //               children: [
            //                 Center(
            //                   child: Image.asset(
            //                     'assets/image_rent/profilePropertyImg.png',
            //                     width: 100,
            //                     height: 80,
            //                     fit: BoxFit.contain,
            //                   ),
            //                 ),
            //                 const SizedBox(height: 10),
            //                 Container(
            //                   padding: const EdgeInsets.symmetric(
            //                       horizontal: 8, vertical: 4),
            //                   decoration: BoxDecoration(
            //                     color: Color(0xFF72E23E),
            //                     borderRadius: BorderRadius.circular(12),
            //                   ),
            //                   child: const Text(
            //                     "FREE",
            //                     style: TextStyle(
            //                       color: Colors.black,
            //                       fontSize: 12,
            //                       fontWeight: FontWeight.bold,
            //                     ),
            //                   ),
            //                 ),
            //                 const SizedBox(height: 8),
            //                 const Text(
            //                   "Post Property",
            //                   style: TextStyle(
            //                     fontSize: 16,
            //                     fontWeight: FontWeight.bold,
            //                     color: Colors.black87,
            //                   ),
            //                 ),
            //                 const SizedBox(height: 4),
            //                 const Text(
            //                   "AI base property\nmanagement",
            //                   style: TextStyle(
            //                     fontSize: 12,
            //                     color: Colors.grey,
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ),
            //       ),
            //       boxW10(),
            //       Expanded(
            //         child: Container(
            //           padding: const EdgeInsets.all(16),
            //           decoration: BoxDecoration(
            //             color: Colors.white,
            //             borderRadius: BorderRadius.circular(16),
            //           ),
            //           child: Column(
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             mainAxisSize: MainAxisSize.min,
            //             children: [
            //               Center(
            //                 child: Image.asset(
            //                   'assets/image_rent/profilePropertyImg.png',
            //                   width: 100,
            //                   height: 80,
            //                   fit: BoxFit.contain,
            //                 ),
            //               ),
            //               const SizedBox(height: 10),
            //               Container(
            //                 padding: const EdgeInsets.symmetric(
            //                     horizontal: 8, vertical: 4),
            //                 decoration: BoxDecoration(
            //                   color: Color(0xFF72E23E),
            //                   borderRadius: BorderRadius.circular(12),
            //                 ),
            //                 child: const Text(
            //                   "FREE",
            //                   style: TextStyle(
            //                     color: Colors.black,
            //                     fontSize: 12,
            //                     fontWeight: FontWeight.bold,
            //                   ),
            //                 ),
            //               ),
            //               const SizedBox(height: 8),
            //               const Text(
            //                 "Post Projects",
            //                 style: TextStyle(
            //                   fontSize: 16,
            //                   fontWeight: FontWeight.bold,
            //                   color: Colors.black87,
            //                 ),
            //               ),
            //               const SizedBox(height: 4),
            //               const Text(
            //                 "AI base property\nmanagement",
            //                 style: TextStyle(
            //                   fontSize: 12,
            //                   color: Colors.grey,
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //       )
            //     ],
            //   ),
            // ),

            /// manage property
            // Padding(
            //   padding: const EdgeInsets.only(right: 16.0, left: 16.0),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     mainAxisAlignment: MainAxisAlignment.start,
            //     children: [
            //       Text(
            //         "Manage Property",
            //         style: TextStyle(
            //             fontSize: 16,
            //             color: Colors.black.withOpacity(0.5),
            //             fontWeight: FontWeight.bold),
            //       ),
            //       boxH15(),
            //       Container(
            //         decoration: BoxDecoration(
            //           borderRadius: BorderRadius.circular(16),
            //           border: Border.all(
            //             color: Colors.grey.shade300,
            //             width: 1.5,
            //           ),
            //           color: Colors.white,
            //         ),
            //         child: Column(
            //           children: [
            //             ListTile(
            //               title: const Text(
            //                 "My Properties",
            //                 style: TextStyle(fontSize: 17),
            //               ),
            //               trailing: const Icon(
            //                 Icons.arrow_forward,
            //                 color: Colors.black,
            //               ),
            //               onTap: () {
            //                // Get.to(const MyProperties());
            //               },
            //             ),
            //             Container(
            //               height: 1.5, // Border thickness
            //               color: Colors.grey.shade300, // Border color
            //             ),
            //             ListTile(
            //               title: const Text(
            //                 "My Projects",
            //                 style: TextStyle(fontSize: 17),
            //               ),
            //               trailing: const Icon(
            //                 Icons.arrow_forward,
            //                 color: Colors.black,
            //               ),
            //               onTap: () {
            //                 //Get.to(const MyProjects());
            //               },
            //             ),
            //             Container(
            //               height: 1.5, // Border thickness
            //               color: Colors.grey.shade300, // Border color
            //             ),
            //             ListTile(
            //               title: const Text(
            //                 "My Leads",
            //                 style: TextStyle(fontSize: 17),
            //               ),
            //               trailing: const Icon(
            //                 Icons.arrow_forward,
            //                 color: Colors.black,
            //               ),
            //               onTap: () {
            //                // Get.to(const MyLeads());
            //               },
            //             ),
            //             Container(
            //               height: 1.5, // Border thickness
            //               color: Colors.grey.shade300, // Border color
            //             ),
            //
            //             ListTile(
            //               title: const Text(
            //                 "Plan / Subscription ",
            //                 style: TextStyle(fontSize: 17),
            //               ),
            //               trailing: const Icon(
            //                 Icons.arrow_forward,
            //                 color: Colors.black,
            //               ),
            //               onTap: () {
            //                 //Get.to(const PlansAndSubscription());
            //               },
            //             ),
            //             Container(
            //               height: 1.5, // Border thickness
            //               color: Colors.grey.shade300, // Border color
            //             ),
            //             ListTile(
            //               title: const Text(
            //                 "Offer / Promote ",
            //                 style: TextStyle(fontSize: 17),
            //               ),
            //               trailing: const Icon(
            //                 Icons.arrow_forward,
            //                 color: Colors.black,
            //               ),
            //               onTap: () {
            //               //  Get.to(const OffersProperties());
            //               },
            //             ),
            //             Container(
            //               height: 1.5, // Border thickness
            //               color: Colors.grey.shade300, // Border color
            //             ),
            //             ListTile(
            //               title: const Text(
            //                 "Advertisement",
            //                 style: TextStyle(fontSize: 17),
            //               ),
            //               trailing: const Icon(
            //                 Icons.arrow_forward,
            //                 color: Colors.black,
            //               ),
            //               onTap: () {
            //                // Get.to(const Advertisements());
            //               },
            //             ),
            //             Container(
            //               height: 1.5, // Border thickness
            //               color: Colors.grey.shade300, // Border color
            //             ),
            //           ],
            //         ),
            //       )
            //     ],
            //   ),
            // ),

            ///Services
            // Padding(
            //   padding: const EdgeInsets.only(
            //       right: 16.0, left: 16.0, top: 16.0),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     mainAxisAlignment: MainAxisAlignment.start,
            //     children: [
            //       Text(
            //         "Services",
            //         style: TextStyle(
            //             fontSize: 16,
            //             color: Colors.black.withOpacity(0.5),
            //             fontWeight: FontWeight.bold),
            //       ),
            //       boxH15(),
            //       Container(
            //         decoration: BoxDecoration(
            //           borderRadius: BorderRadius.circular(16),
            //           border: Border.all(
            //             color: Colors.grey.shade300,
            //             width: 1.5,
            //           ),
            //           color: Colors.white,
            //         ),
            //         child: Column(
            //           children: [
            //             ListTile(
            //               title: const Text(
            //                 "My Virtual Tour",
            //                 style: TextStyle(fontSize: 17),
            //               ),
            //               trailing: const Icon(
            //                 Icons.arrow_forward,
            //                 color: Colors.black,
            //               ),
            //               onTap: () {
            //              //   Get.to(const MyVirtualTourScreen());
            //               },
            //             ),
            //             Container(
            //               height: 1.5, // Border thickness
            //               color: Colors.grey.shade300, // Border color
            //             ),
            //             ListTile(
            //               title: const Text(
            //                 "My Favorite ",
            //                 style: TextStyle(fontSize: 17),
            //               ),
            //               trailing: const Icon(
            //                 Icons.arrow_forward,
            //                 color: Colors.black,
            //               ),
            //               onTap: () {
            //                 /// add favorite instead of featured property
            //                 // Get.to(PropertiesListScreen(
            //                 //   isFrom: 'profile',
            //                 //   data: controller.getFeaturedPropery,
            //                 // ));
            //               //  Get.to(const MyFavorite());
            //               },
            //             ),
            //             Container(
            //               height: 1.5, // Border thickness
            //               color: Colors.grey.shade300, // Border color
            //             ),
            //             ListTile(
            //               title: const Text(
            //                 "Save Searches ",
            //                 style: TextStyle(fontSize: 17),
            //               ),
            //               trailing: const Icon(
            //                 Icons.arrow_forward,
            //                 color: Colors.black,
            //               ),
            //               onTap: () {
            //
            //               },
            //             ),
            //             Container(
            //               height: 1.5, // Border thickness
            //               color: Colors.grey.shade300, // Border color
            //             ),
            //           ],
            //         ),
            //       )
            //     ],
            //   ),
            // ),
            boxH10(),
            /// Others
            Padding(
              padding: const EdgeInsets.only(right: 16.0, left: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.grey.shade300,
                    width: 1.5,
                  ),
                  color: Colors.white,
                ),
                child: ListTile(
                  title: const Text(
                    "Settings",
                    style: TextStyle(fontSize: 17),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward,
                    color: Colors.black,
                  ),
                  onTap: () {
                    Get.to(() => const SettingsPage());
                  },
                ),
              ),

            ),
            boxH10(),

            // Center(
            //     child: TextButton(
            //       onPressed: () {
            //         // showDeleteAccountDialog(context,() {
            //         //   profileController.deleteUserAcc(context);
            //         // },);
            //       },
            //       child: const Text(
            //         "Delete account",
            //         style: TextStyle(
            //           fontSize: 18,
            //           fontWeight: FontWeight.bold,
            //           color: Color(0xFFEA4335),
            //         ),
            //       ),
            //     ))
          ],
        )
          /// old login code
            // Padding(
            //     padding: const EdgeInsets.all(10.0),
            //     child: Column(
            //       children: [
            //         Padding(
            //           padding: const EdgeInsets.symmetric(horizontal: 8.0),
            //           child: Row(
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //               CircleAvatar(
            //                 radius: 30,
            //                 backgroundColor: Colors.grey[300],
            //                 backgroundImage:
            //                     const AssetImage('assets/profileicon.png'),
            //               ),
            //               const SizedBox(width: 15),
            //               const Expanded(
            //                 child: Column(
            //                   crossAxisAlignment: CrossAxisAlignment.start,
            //                   children: [
            //                     Text(
            //                       //  profileController.name!.value??"",
            //                       "Hello User!!!",
            //                       style: TextStyle(
            //                         fontSize: 13,
            //                         fontWeight: FontWeight.bold,
            //                       ),
            //                     ),
            //                     Row(
            //                       children: [
            //                         Icon(
            //                           Icons.verified,
            //                           color: Colors.green,
            //                           size: 18,
            //                         ),
            //                         SizedBox(width: 5),
            //                         Text(
            //                           "Easy Contact with sellers",
            //                           style: TextStyle(
            //                             fontSize: 12,
            //                             color: Colors.black87,
            //                           ),
            //                         ),
            //                       ],
            //                     ),
            //                     Row(
            //                       children: [
            //                         Icon(
            //                           Icons.verified,
            //                           color: Colors.green,
            //                           size: 18,
            //                         ),
            //                         SizedBox(width: 5),
            //                         Text(
            //                           'Personalized experience',
            //                           style: TextStyle(
            //                             fontSize: 12,
            //                             color: Colors.black87,
            //                           ),
            //                         ),
            //                       ],
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //         boxH05(),
            //         const Divider(),
            //         boxH50(),
            //         Center(
            //             child: Image.asset(
            //           'assets/permission.png',
            //           height: 100,
            //           width: 100,
            //         )),
            //         boxH30(),
            //         Center(
            //           child: ElevatedButton(
            //             onPressed: () {
            //               Get.off(LoginScreen());
            //             },
            //             style: ElevatedButton.styleFrom(
            //               backgroundColor: Colors.blueGrey,
            //               foregroundColor: Colors.white,
            //               padding: const EdgeInsets.symmetric(
            //                   horizontal: 32, vertical: 2),
            //               shape: RoundedRectangleBorder(
            //                 borderRadius: BorderRadius.circular(30),
            //               ),
            //               textStyle: const TextStyle(
            //                 fontSize: 18,
            //                 fontWeight: FontWeight.bold,
            //               ),
            //               elevation: 10, // Shadow elevation
            //             ),
            //             child: const Text('Login'),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
     // bottomNavigationBar: const BottomNavbar(),
    );
  }

  void changePassword(context) async {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    showModalBottomSheet<void>(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return GetBuilder<ProfileController>(
          builder: (controller) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                top: MediaQuery.of(context).viewInsets.top,
                right: 10,
                left: 10,
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        children: [
                          const Expanded(
                            child: Center(
                              child: Text(
                                "Change Password",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.cancel,
                              size: 30,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                      const Divider(thickness: 1, color: Colors.grey),
                      CustomTextFormField(
                        controller: controller.currentPassword,
                        labelText: 'Enter old password',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter old password';
                          }
                          return null;
                        },
                      ),
                      boxH10(),
                      CustomTextFormField(
                        controller: controller.newPassword,
                        labelText: 'Enter new password',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter new password';
                          }
                          return null;
                        },
                      ),
                      boxH10(),
                      CustomTextFormField(
                        controller: controller.confirmedPassword,
                        labelText: 'Enter confirmed password',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter confirmed password';
                          }
                          return null;
                        },
                      ),
                      boxH20(),
                      GestureDetector(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            controller
                                .changePassword(
                              oldPassword:
                                  controller.currentPassword.value.text,
                              newPassword: controller.newPassword.value.text,
                              confirmedPassword:
                                  controller.confirmedPassword.value.text,
                            )
                                .then((value) {
                              Navigator.pop(context);
                            });
                          } else {
                            Fluttertoast.showToast(
                              msg: 'Please fill all required fields',
                            );
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: AppColor.blueGrey,
                          ),
                          child: const Text(
                            'Change',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      boxH20(),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  rateUs(context) async {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    showModalBottomSheet<void>(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return GetBuilder<ProfileController>(
          builder: (controller) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,

              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 16.0, right: 8.0, left: 8.0),
                      child: Row(
                        children: [
                          Container(
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
                          const Expanded(
                            child: Center(
                              child: Text(
                                "Feedback",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17),
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                    // const Divider(thickness: 1, color: Colors.grey),
                    boxH15(),
                    const Text(
                      "Rating",
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    boxH20(),
                    Center(
                        child: RatingBar.builder(
                      initialRating: 2,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding:
                          const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        profileController.rate = rating;
                        print(profileController.rate);
                      },
                    )),
                    boxH30(),
                    const Text(
                      "Your Message",
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    boxH20(),
                    CustomTextFormField(
                      controller: controller.RatingController,
                      maxLines: 3,
                      keyboardType: TextInputType.text,
                      hintText: 'Message',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter message';
                        }
                        return null;
                      },
                    ),
                    boxH10(),

                    commonButton(
                      width: Get.width,
                      height: 50,
                      text: "Submit",
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          controller.rateUs(
                            rating: controller.rate.toString(),
                            message: controller.RatingController.value.text,
                          );
                        } else {
                          Fluttertoast.showToast(
                            msg: 'Please fill all required fields',
                          );
                        }
                      },
                    ),

                    boxH20(),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void editProfile(context) async {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    showModalBottomSheet<void>(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return GetBuilder<ProfileController>(
          builder: (controller) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                top: MediaQuery.of(context).viewInsets.top,
                // right: 10,
                // left: 10,
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          children: [
                            const Expanded(
                              child: Center(
                                child: Text(
                                  "Edit Profile",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.cancel,
                                size: 30,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                        const Divider(thickness: 1, color: Colors.grey),
                        Center(
                          child: InkWell(
                            onTap: () {
                              showImageDialog();
                            },
                            child: Stack(
                              alignment: Alignment.topRight,
                              children: <Widget>[
                                Obx(() {
                                  return ClipOval(
                                    child: profileController
                                            .isIconSelected.value
                                        ? Image.file(
                                            File(profileController
                                                .iconImg!.path),
                                            height: 100,
                                            width: 100,
                                          )
                                        : profileController
                                                .profileImage.isNotEmpty
                                            ? CircleAvatar(
                                                radius: 45,
                                                backgroundImage:
                                                    CachedNetworkImageProvider(
                                                  profileController
                                                      .profileImage.value,
                                                ),
                                              )
                                            : CircleAvatar(
                                                radius: 30,
                                                backgroundColor:
                                                    Colors.grey[300],
                                                backgroundImage: const AssetImage(
                                                    'assets/profileicon.png'),
                                              ),
                                  );
                                }),
                              ],
                            ),
                          ),
                        ),
                        boxH20(),
                        CustomTextFormField(
                          controller: controller.userController,
                          labelText: 'Enter User Name',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter User Name';
                            }
                            return null;
                          },
                        ),
                        boxH10(),
                        CustomTextFormField(
                          controller: controller.nameController,
                          labelText: 'Enter Name',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter name';
                            }
                            return null;
                          },
                        ),
                        boxH10(),
                        CustomTextFormField(
                          controller: controller.emailController,
                          labelText: 'Enter Email',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter email';
                            }
                            return null;
                          },
                        ),
                        boxH10(),
                        CustomTextFormField(
                          controller: controller.contactController,
                          labelText: 'Enter mobile number',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter mobile number';
                            }
                            return null;
                          },
                        ),
                        boxH20(),
                        GestureDetector(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              controller
                                  .edit(
                              )
                                  .then((value) {
                                Navigator.pop(context);
                              });
                            } else {
                              Fluttertoast.showToast(
                                msg: 'Please fill all required fields',
                              );
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: AppColor.blueGrey,
                            ),
                            child: const Text(
                              'Update',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        boxH20(),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  showImageDialog() async {
    return showDialog(
      // context: Get.context!,
      context: Get.context!,
      builder: (context) => AlertDialog(
          backgroundColor: Colors.white,
          content: SizedBox(
            height: 100,
            child: Column(
              children: <Widget>[
                const Text(
                  "Choose Photo",
                  style: TextStyle(
                    fontSize: 15.0,
                  ),
                ),
                const Divider(),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextButton.icon(
                        onPressed: () {
                          getCameraImage();
                        },
                        icon: const Icon(
                          Icons.camera,
                          color: Colors.black54,
                          size: 15,
                        ),
                        label: const Text("Camera",
                            style: TextStyle(
                                color: Colors.black54, fontSize: 15))),
                    TextButton.icon(
                        onPressed: () {
                          getGalleryImage();
                        },
                        icon: const Icon(
                          Icons.image,
                          color: Colors.black54,
                          size: 15,
                        ),
                        label: const Text("Gallery",
                            style: TextStyle(
                                color: Colors.black54, fontSize: 15))),
                  ],
                )
              ],
            ),
          )),
    );
  }

  final ImagePicker picker = ImagePicker();

  Future getCameraImage() async {
    try {
      Navigator.of(Get.context!).pop(false);
      XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);
      // var pickedFile = await picker.pickImage(source: ImageSource.camera,imageQuality: 20);

      if (pickedFile != null) {
        profileController.pickedImageFile = pickedFile;

        File selectedImg = File(profileController.pickedImageFile.path);

        cropImage(selectedImg);
      }
    } on Exception catch (e) {
      log("$e");
    }
  }

  Future getGalleryImage() async {
    Navigator.of(Get.context!).pop(false);
    var pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      profileController.pickedImageFile = pickedFile;

      File selectedImg = File(profileController.pickedImageFile.path);

      cropImage(selectedImg);
    }
  }

  cropImage(File icon) async {
    CroppedFile? croppedFile = (await ImageCropper()
        .cropImage(sourcePath: icon.path, aspectRatioPresets: [
      CropAspectRatioPreset.square,
      CropAspectRatioPreset.ratio3x2,
      CropAspectRatioPreset.original,
      CropAspectRatioPreset.ratio4x3,
      CropAspectRatioPreset.ratio16x9
    ], uiSettings: [
      AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
      IOSUiSettings(
        title: 'Cropper',
      ),
    ]));
    if (croppedFile != null) {
      profileController.iconImg = File(croppedFile.path);
      profileController.isIconSelected.value = true;
      profileController.update();
    }
  }

  _onLogoutPressed(BuildContext context) async {
    showCommonBottomSheet(
      context: context,

      title: "Are you sure?",
      message: "Do you want to logout?",
      onYesPressed: () {
        LogOut();
      },
      onNoPressed: () {
        Navigator.of(context).pop(false);
      },
    );
  }

  void LogOut() async {
    bool isCleared = await clearLocalStorage();
    if (isCleared) {
      setState(() {
        isLogin = false;
        profileController.profileImage.value ='';
      });
      Fluttertoast.showToast(msg: "You have logged out successfully.");
      // Navigator.pushReplacementNamed(context, '/login');
      Get.offAll(const BottomNavbar());
      // Navigator.of(context).pushAndRemoveUntil(
      //   MaterialPageRoute(builder: (context) => WelcomeScreen()),
      //   (Route<dynamic> route) => false,
      // );
    } else {
      print("Failed to clear local storage.");
    }
  }

  void showDeleteAccountDialog(BuildContext context, VoidCallback onConfirm) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),backgroundColor: AppColor.white,
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.red,size: 30,),
              SizedBox(width: 8),
              Text('Confirm Deletion'),
            ],
          ),
          content: const Text(
            'Deleting your account is permanent and cannot be undone.\n\nAll your data will be lost. Are you sure you want to proceed?',
            style: TextStyle(fontSize: 16),
          ),
          actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          actionsAlignment: MainAxisAlignment.end,
          actions: <Widget>[
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                side: const BorderSide(color: Colors.grey),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: const Text('Cancel', style: TextStyle(color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            boxW08(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: const Text('Delete', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm();
              },
            ),
          ],
        );
      },
    );
  }

}

class EditProfileBottomSheet extends StatefulWidget {
  const EditProfileBottomSheet({super.key});

  @override
  State<EditProfileBottomSheet> createState() => _EditProfileBottomSheetState();
}

class _EditProfileBottomSheetState extends State<EditProfileBottomSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  File? _selectedImageFile;
  ProfileController profileController = Get.put(ProfileController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_)async{
      await profileController.getProfile();
    });
    // Initialize with current image if available
    if (profileController.isIconSelected.value) {
      _selectedImageFile = profileController.iconImg;
    }
  }

  @override
  Widget build(BuildContext context) {
    print("proprietorship ==> ${profileController.proprietorshipController.text}");
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Update Your Profile",
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
                color: Colors.black, // Border color
                width: 0.1, // Border width
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
      ),
      body:Obx(() => profileController.isLoading.value ? const Center(child: CircularProgressIndicator(),) :  Stack(children: [
        Container(
          height: Get.height,
          color: Colors.white,
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: MediaQuery.of(context).viewInsets.top,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    _buildProfileImage(),
                    _buildFormFields(),

                    ///_buildUpdateButton(context),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
        const Positioned(
          bottom: 0,
          left: 5,
          right: 5,
          child: CustomBottomNavBar(),
        ),
      ])),
    );
  }

  Widget _buildProfileImage() {
    print("profileController.profileImage.value--<");
    print(profileController.profileImage.value);
    print(profileController.profileImage.contains('default_profile'));
    return Center(
      child: InkWell(
        onTap: showImageDialog,
        child: Stack(
          alignment: Alignment.topRight,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.purple[100],
                    ),
                    child: ClipOval(
                      child: _selectedImageFile != null
                          ?  _selectedImageFile.toString().contains('assets/')?
                      Image.asset(
                        'assets/image_rent/profileImg.png',
                        fit: BoxFit.contain,
                        width: 15,
                        height: 15,
                      ):
                      Image.file(
                        _selectedImageFile!,
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      )
                          : profileController.profileImage.isNotEmpty
                          ? Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.purple[50],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipOval(
                            child: (profileController.profileImage.isEmpty ||
                                profileController.profileImage.contains('default_profile'))
                                ? Image.asset(
                              'assets/image_rent/profileImg.png',
                              fit: BoxFit.contain,
                              width: 15,
                              height: 15,
                            )
                                : Image.network(
                              profileController.profileImage.value,
                              fit: BoxFit.cover,
                              width: 50,
                              height: 50,
                              errorBuilder: (_, __, ___) => Image.asset(
                                'assets/image_rent/profileImg.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      )


                          : Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.purple[50],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/image_rent/profileImg.png',
                              fit: BoxFit.contain,
                              width: 15,
                              height: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  boxW10(),
                  Text(
                    profileController.nameController.text ?? "",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildFormFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        boxH20(),
        Text(
          "Personal Details",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black.withOpacity(0.5),
              fontSize: 16),
        ),
        boxH20(),
        ListTile(
          title:  Text(
            "Name",
            style: TextStyle(fontSize: 17,color: Colors.black.withOpacity(0.5)),
          ),
          subtitle: Text(
            profileController.nameController.text,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          trailing: const Icon(
            Icons.arrow_forward,
            color: Colors.black,
          ),
          onTap: () async {
            String? updatedValue = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditProfileFieldScreen(
                  title: "Name",
                  textEditingController: profileController.nameController,
                ),
              ),
            );

            if (updatedValue != null) {
              setState(() {
                profileController.nameController.text = updatedValue;
              });
            }
          },
        ),
        Container(
          height: 1.5,
          color: Colors.grey.shade300,
        ),

        ListTile(
          title:  Text(
            "Mobile",
            style: TextStyle(fontSize: 17,color: Colors.black.withOpacity(0.5)),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              profileController.contactController.text,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
          ),
          trailing: const Icon(
            Icons.arrow_forward,
            color: Colors.black,
          ),
          onTap: () async {
            // String? updatedValue = await Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => EditProfileFieldScreen(
            //       title: "Mobile",
            //       textEditingController: profileController.contactController,
            //     ),
            //   ),
            // );
            //
            // if (updatedValue != null) {
            //   setState(() {
            //     profileController.contactController.text = updatedValue;
            //   });
            // }
          },
        ),

        boxH10(),
        Container(
          height: 1.5,
          color: Colors.grey.shade300,
        ),

        ListTile(
          title:  Text(
            "Email",
            style: TextStyle(fontSize: 17,color: Colors.black.withOpacity(0.5)),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              profileController.emailController.text,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
          ),
          trailing: const Icon(
            Icons.arrow_forward,
            color: Colors.black,
          ),
          onTap: () async {
            String? updatedValue = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditProfileFieldScreen(
                  title: "Email",
                  textEditingController: profileController.emailController,
                ),
              ),
            );
            if (updatedValue != null) {
              if (updatedValue.trim().contains('@')) {
                setState(() {
                  profileController.emailController.text = updatedValue.trim();
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Invalid email format")),
                );
              }
            }

          },
        ),
        Container(
          height: 1.5,
          color: Colors.grey.shade300,
        ),

        ListTile(
          title:  Text(
            "Experience",
            style: TextStyle(fontSize: 17,color: Colors.black.withOpacity(0.5)),
          ),
          subtitle:  Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              profileController.experienceController.text,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
          ),
          trailing: const Icon(
            Icons.arrow_forward,
            color: Colors.black,
          ),
          onTap: () async {
            String? updatedValue = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditProfileFieldScreen(
                  title: "Experience",
                  textEditingController: profileController.experienceController,
                ),
              ),
            );

            if (updatedValue != null) {
              setState(() {
                profileController.experienceController.text = updatedValue;
              });
            }
          },
        ),
        boxH10(),
        Container(
          height: 1.5,
          color: Colors.grey.shade300,
        ),

        ListTile(
          title:  Text(
            "Proprietorship",
            style: TextStyle(fontSize: 17,color: Colors.black.withOpacity(0.5)),
          ),
          subtitle:  Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              profileController.proprietorshipController.text,
              style:const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
          ),
          trailing: const Icon(
            Icons.arrow_forward,
            color: Colors.black,
          ),
          onTap: () async {
            String? updatedValue = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditProfileFieldScreen(
                  title: "Proprietorship",
                  textEditingController:
                  profileController.proprietorshipController,
                ),
              ),
            );

            if (updatedValue != null) {
              setState(() {
                profileController.proprietorshipController.text = updatedValue;
              });
            }
          },
        ),
        boxH10(),
        Container(
          height: 1.5,
          color: Colors.grey.shade300,
        ),
      ],
    );
  }

  // Future<void> showImageDialog() async {
  //   final result = await showDialog<File>(
  //     context: context,
  //     builder: (context) => SimpleDialog(backgroundColor: AppColor.white,
  //       title: const Text('Choose Profile Picture'),
  //       children: [
  //         ListTile(
  //           leading: const Icon(Icons.camera_alt),
  //           title: const Text('Take Photo'),
  //           onTap: () async {
  //             final image =
  //             await ImagePicker().pickImage(source: ImageSource.camera);
  //             if (image != null) {
  //               Navigator.pop(context, File(image.path));
  //             }
  //
  //           },
  //         ),
  //         ListTile(
  //           leading: const Icon(Icons.photo_library),
  //           title: const Text('Choose from Gallery'),
  //           onTap: () async {
  //             final image =
  //             await ImagePicker().pickImage(source: ImageSource.gallery);
  //             if (image != null) {
  //               Navigator.pop(context, File(image.path));
  //             }
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  //
  //   if (result != null) {
  //     setState(() {
  //       _selectedImageFile = result;
  //       profileController.iconImg = result;
  //       profileController.edit();
  //     });
  //     profileController.isIconSelected.value = true;
  //   }
  // }
  Future<void> showImageDialog() async {
    final result = await showDialog<File?>(
      context: context,
      builder: (context) => SimpleDialog(
        backgroundColor: AppColor.white,
        title: const Text('Choose Profile Picture'),
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Take Photo'),
            onTap: () async {
              final image = await ImagePicker().pickImage(source: ImageSource.camera);
              if (image != null) {
                Navigator.pop(context, File(image.path));
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Choose from Gallery'),
            onTap: () async {
              final image = await ImagePicker().pickImage(source: ImageSource.gallery);
              if (image != null) {
                Navigator.pop(context, File(image.path));
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('Remove Profile Image'),
            onTap: () {
              Navigator.pop(context, File('assets/image_rent/profile.png'));
            },
          ),
        ],
      ),
    );

    if (result != null) {
      setState(() {
        if(result.path.contains('assets/')){
          _selectedImageFile = null;
        }else{
          _selectedImageFile = result;
        }

        profileController.iconImg = result;
        profileController.edit(isFromAsset: result.path.contains('assets/'));
      });
      profileController.isIconSelected.value = true;
    }
  }


}



class SettingsPage extends StatefulWidget {
  final isfrom;
  const SettingsPage({Key? key, this.isfrom}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Widget buildDivider() => Container(
    height: 1.5,
    color: Colors.grey.shade300,
  );
  final PostPropertyController controller = Get.find();
  ProfileController profileController = Get.put(ProfileController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    profileController.RatingController.clear();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 15),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: 1.5,
                ),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  ListTile(
                    title: const Text("About", style: TextStyle(fontSize: 17)),
                    trailing: const Icon(Icons.arrow_forward, color: Colors.black),
                    onTap: () {
                      Get.to(() => AboutUs(isFrom: 'about_us'));
                    },
                  ),
                  buildDivider(),
                  ListTile(
                    title: const Text("Privacy Policy", style: TextStyle(fontSize: 17)),
                    trailing: const Icon(Icons.arrow_forward, color: Colors.black),
                    onTap: () {
                      Get.to(() => AboutUs(isFrom: 'policy'));
                    },
                  ),
                  buildDivider(),
                  ListTile(
                    title: const Text("Terms and Conditions", style: TextStyle(fontSize: 17)),
                    trailing: const Icon(Icons.arrow_forward, color: Colors.black),
                    onTap: () {
                      Get.to(() => AboutUs(isFrom: 'TandC'));
                    },
                  ),
                  buildDivider(),
                  ListTile(
                    title: const Text("FAQ", style: TextStyle(fontSize: 17)),
                    trailing: const Icon(Icons.arrow_forward, color: Colors.black),
                    onTap: () {
                      Get.to(() => AboutUs(isFrom: 'faq'));
                    },
                  ),
                  buildDivider(),
                  ListTile(
                    title: const Text("Feedback", style: TextStyle(fontSize: 17)),
                    trailing: const Icon(Icons.arrow_forward, color: Colors.black),
                    // onTap: () {
                    //   // Add your feedback navigation or dialog here
                    //   // e.g., Get.to(() => FeedbackPage());
                    // },
                    onTap: () => rateUs(context),
                  ),
                  buildDivider(),

                  widget.isfrom=="login"?
                  ListTile(
                    title: const Text(
                      "Logout",
                      style: TextStyle(fontSize: 17),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward,
                      color: Colors.black,
                    ),
                    onTap: () async {
                      await _onLogoutPressed(context);
                    },
                  ):SizedBox(),

                  widget.isfrom=="login"?
                  Center(
                      child: TextButton(
                        onPressed: () {
                          showDeleteAccountDialog(context,() {
                            profileController.deleteUserAcc(context);
                          },);
                        },
                        child: const Text(
                          "Delete account",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFEA4335),
                          ),
                        ),
                      )):SizedBox(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  rateUs(context) async {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    showModalBottomSheet<void>(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return GetBuilder<ProfileController>(
          builder: (controller) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,

              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          children: [
                            Container(
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
                            const Expanded(
                              child: Center(
                                child: Text(
                                  "Feedback",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17),
                                ),
                              ),
                            ),

                          ],
                        ),
                        // const Divider(thickness: 1, color: Colors.grey),
                        boxH30(),
                        const Text(
                          "Rating",
                          style: TextStyle(color: Colors.black, fontSize: 15,fontWeight: FontWeight.bold),
                        ),
                        boxH20(),
                        Center(
                            child: RatingBar.builder(
                              initialRating: 2,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemPadding:
                              const EdgeInsets.symmetric(horizontal: 4.0),
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {
                                profileController.rate = rating;
                                print(profileController.rate);
                              },
                            )),
                        boxH30(),
                        const Text(
                          "Your Message",
                          style: TextStyle(color: Colors.black, fontSize: 15,fontWeight: FontWeight.bold),                        ),
                        boxH20(),
                        CustomTextFormField(
                          controller: controller.RatingController,
                          maxLines: 5,
                          keyboardType: TextInputType.text,
                          hintText: 'Message',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter message';
                            }
                            return null;
                          },
                        ),
                        boxH10(),

                        commonButton(
                          width: Get.width,
                          height: 50,
                          text: "Submit",
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              controller.rateUs(
                                rating: controller.rate.toString(),
                                message: controller.RatingController.value.text,
                              );
                            } else {
                              Fluttertoast.showToast(
                                msg: 'Please fill all required fields',
                              );
                            }
                          },
                        ),

                        boxH20(),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
  _onLogoutPressed(BuildContext context) async {
    showCommonBottomSheet(
      context: context,

      title: "Are you sure?",
      message: "Do you want to logout?",
      onYesPressed: () {
        LogOut();
      },
      onNoPressed: () {
       // Get.back();
      },
    );
  }


  // void LogOut() async {
  //   bool isCleared = await clearLocalStorage();
  //   if (isCleared) {
  //     setState(() {
  //       isLogin = false;
  //       profileController.profileImage.value ='';
  //     });
  //     Fluttertoast.showToast(msg: "You have logged out successfully.");
  //     // Navigator.pushReplacementNamed(context, '/login');
  //     controller.isBuyerSelected.value = true;
  //     Get.offAll(const BottomNavbar());
  //     // Navigator.of(context).pushAndRemoveUntil(
  //     //   MaterialPageRoute(builder: (context) => WelcomeScreen()),
  //     //   (Route<dynamic> route) => false,
  //     // );
  //   } else {
  //     print("Failed to clear local storage.");
  //   }
  // }


  void LogOut() async {
    bool isCleared = await clearLocalStorage();
    if (isCleared) {
      await  SPManager.instance.setLoginScrrenView("show_home", "yes");

      setState(() {
        isLogin = false;
        profileController.profileImage.value = '';
      });

      Fluttertoast.showToast(msg: "You have logged out successfully.");
      controller.isBuyerSelected.value = true;

      Get.offAll(const BottomNavbar()); // 👈 Send user to BottomNavbar (home)
    } else {
      print("Failed to clear local storage.");
    }
  }


  void showDeleteAccountDialog(BuildContext context, VoidCallback onConfirm) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),backgroundColor: AppColor.white,
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.red,size: 30,),
              SizedBox(width: 8),
              Text('Confirm Deletion'),
            ],
          ),
          content: const Text(
            'Deleting your account is permanent and cannot be undone.\n\nAll your data will be lost. Are you sure you want to proceed?',
            style: TextStyle(fontSize: 16),
          ),
          actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          actionsAlignment: MainAxisAlignment.end,
          actions: <Widget>[
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                side: const BorderSide(color: Colors.grey),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: const Text('Cancel', style: TextStyle(color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            boxW08(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: const Text('Delete', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm();
              },
            ),
          ],
        );
      },
    );
  }
}
