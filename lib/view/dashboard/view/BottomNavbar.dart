import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/common_widgets/height.dart';
import 'package:real_estate_app/global/app_color.dart';
import 'package:real_estate_app/view/activity/ActivityScreen.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/profile_screen/profile_screen.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/save_screen/save_screen.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/search_screen/search_screen.dart';
import 'package:real_estate_app/view/dashboard/deshboard_controllers/bottom_bar_controller.dart';
import 'package:real_estate_app/view/dashboard/view/BotScreen.dart';
import 'package:real_estate_app/view/property_screens/post_property_screen/NewChanges/post_property_start_page.dart';
import 'package:real_estate_app/view/property_screens/properties_controllers/post_property_controller.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../../../Routes/app_pages.dart';
import '../../../utils/String_constant.dart';
import '../../../utils/shared_preferences/shared_preferances.dart';
import '../../auth/register_screen/register_screen.dart';
import '../../property_screens/post_property_screen/post_property_screen.dart';
import '../../shorts/bottom_bar/view/bottom_nav_bar.dart';
import '../../shorts/view/home_view.dart';
import '../../splash_screen/splash_screen.dart';
import '../../subscription model/Subscription_Screen.dart';
import '../../subscription model/controller/SubscriptionController.dart';
import '../bottom_navbar_screens/profile_screen/profile_controller.dart';
import '../bottom_navbar_screens/profile_screen/profile_section_screens/Listing/listing_screen.dart';
import '../bottom_navbar_screens/profile_screen/profile_section_screens/Listing/myListingProperty.dart';

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({super.key});

  @override
  _BottomNavbarState createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  final bottomBarController = Get.put(BottomBarController());
  final ProfileController profileController = Get.put(ProfileController());
  final PostPropertyController controller = Get.put(PostPropertyController());
  final SubscriptionController subscriptionController = Get.put(SubscriptionController());

  // List to track navigation history (store screen indices or identifiers)
  final List<int> navigationStack = [0]; // Start with Home (index 0)

  @override
  void initState() {
    super.initState();
    profileController.checkLogin();
    bottomBarController.fromPage.value = 'Home';
    //getdata();
  }

  getdata() async {
    await subscriptionController.getSubscriptionHistory();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: handleBackPress,
      child: Obx(()=>
        Scaffold(
          body: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    controller.isBuyerSelected.value
                        ? Obx(
                          () => Expanded(
                        child: bottomBarController.selectedBottomIndex.value == 0
                            ? const SearchScreen()
                            : bottomBarController.selectedBottomIndex.value == 1
                            ?  Onboarding_Screen(isfrom: '',)
                            : bottomBarController.selectedBottomIndex.value == 2
                            ? const SaveScreen(isFrom: 'searchScreen', isfrom: '',)
                            : const SizedBox(),
                      ),
                    )
                        : Obx(
                          () => Expanded(
                        child: bottomBarController.selectedBottomIndex.value == 0
                            ? const SearchScreen()
                            : bottomBarController.selectedBottomIndex.value == 1
                            ?  Onboarding_Screen(isfrom: '',)
                            : bottomBarController.selectedBottomIndex.value == 2
                            // ? const ListingScreen()
                            ? const SaveScreen(isFrom: 'searchScreen', isfrom: '',)
                            : const SizedBox(),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 10,
                right: 5,
                left: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    height: 72,
                    decoration: BoxDecoration(
                      color: AppColor.primaryThemeColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Obx(
                          () => BottomNavigationBar(
                        elevation: 0,
                        type: BottomNavigationBarType.fixed,
                        backgroundColor: Colors.transparent,
                        selectedItemColor: AppColor.white,
                        unselectedItemColor: AppColor.white.withOpacity(0.5),
                        currentIndex: bottomBarController.selectedBottomIndex.value,
                        onTap: handleTabTap,
                        selectedLabelStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColor.white,
                        ),
                        unselectedLabelStyle: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.normal,
                          color: AppColor.white.withOpacity(0.5),
                        ),
                        items: [
                          BottomNavigationBarItem(
                            icon: Image.asset(
                              'assets/image_rent/home.png',
                              width: 24,
                              height: 24,
                              color: bottomBarController.selectedBottomIndex.value == 0
                                  ? AppColor.white
                                  : AppColor.white.withOpacity(0.5),
                            ),
                            label: 'Home',
                          ),
                          // BottomNavigationBarItem(
                          //   icon: SizedBox(
                          //     height: 43,
                          //     width: 43,
                          //     child: Image.asset(
                          //       'assets/image_rent/postProperty.png',
                          //       height: 35,
                          //       width: 35,
                          //       fit: BoxFit.contain,
                          //       color: bottomBarController.selectedBottomIndex.value == 1
                          //           ? AppColor.white
                          //           : AppColor.white.withOpacity(0.5),
                          //     ),
                          //   ),
                          //   label: 'AI Assist',
                          // ),
                          BottomNavigationBarItem(
                            icon: SizedBox(
                              height: 43,
                              width: 43,
                              child: Image.asset(
                                'assets/image_rent/postProperty.png',
                                height: 35,
                                width: 35,
                                fit: BoxFit.contain,
                                color: bottomBarController.selectedBottomIndex.value == 1
                                    ? AppColor.white
                                    : AppColor.white.withOpacity(0.5),
                              ),
                            ),
                            label: 'AI Assist',
                          ),
                          controller.isBuyerSelected.value
                              ? BottomNavigationBarItem(
                            icon: Image.asset(
                              'assets/image_rent/saveSearch.png',
                              width: 24,
                              height: 24,
                              color: bottomBarController.selectedBottomIndex.value == 2
                                  ? AppColor.white
                                  : AppColor.white.withOpacity(0.5),
                            ),
                            label: 'Save Search',
                          )
                              : BottomNavigationBarItem(
                            icon: Image.asset(
                              'assets/image_rent/saveSearch.png',
                              width: 24,
                              height: 24,
                              color: bottomBarController.selectedBottomIndex.value == 2
                                  ? AppColor.white
                                  : AppColor.white.withOpacity(0.5),
                            ),
                         //   label: 'My Property',
                            label: 'Save Search',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void handleTabTap(int index) {
    setState(() {
      bottomBarController.selectedBottomIndex.value = index;
      if (navigationStack.isEmpty || navigationStack.last != index) {
        navigationStack.add(index);
      }
      if (index == 3) {
        bottomBarController.fromPage.value = 'Shorts';
      } else {
        bottomBarController.fromPage.value = index == 0
            ? 'Home'
            : index == 1
            ? 'PostProperty'
            : controller.isBuyerSelected.value
            ? 'SaveSearch'
            : 'MyProperty';
      }
    });
  }

  Future<bool> handleBackPress() async {
    // If the navigation stack has more than one screen and we're not on the Home screen
    if (navigationStack.length > 1 && bottomBarController.selectedBottomIndex.value != 0) {
      // Remove the current screen from the stack
      navigationStack.removeLast();
      // Set the bottom navigation index to the previous screen
      setState(() {
        bottomBarController.selectedBottomIndex.value = navigationStack.last;
        bottomBarController.fromPage.value = navigationStack.last == 0
            ? 'Home'
            : navigationStack.last == 1
            ? 'PostProperty'
            : controller.isBuyerSelected.value
            ? 'SaveSearch'
            : 'MyProperty';
      });
      return false; // Prevent app exit
    } else {
      // If on the Home screen or no previous screens, show the exit dialog
      return await showAlertExit();
    }
  }

  Future<bool> showAlertExit() async {
    return await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColor.grey[50],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Wrap(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 50,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
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
                      ),
                      const Text(
                        'Exit',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColor.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                boxH05(),
                Text(
                  'Do you want to exit the App?',
                  style: TextStyle(fontSize: 17, color: AppColor.black.withOpacity(0.7)),
                ),
                boxH30(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => SystemNavigator.pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.lightPurple,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Yes",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    boxW15(),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context, false),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          side: BorderSide(color: AppColor.black.withOpacity(0.7)!),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          "No",
                          style: TextStyle(
                            color: AppColor.black.withOpacity(0.7),
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                boxH05(),
              ],
            ),
          ],
        ),
      ),
    ) ?? false;
  }

  goToScreen() async {
    String? retrievedUserId = await SPManager.instance.getUserId(USER_ID);
    bool? isLogin = await SPManager.instance.getUserLogin(LOGINKEY.toString());
    print('Retrieved User ID: $retrievedUserId');
    print('LOGIN KEY User ID: $isLogin');
    if (isLogin == true && (retrievedUserId != null && retrievedUserId.isNotEmpty)) {
      Get.back();
      Get.offNamed(Routes.postProperty);
      // Add the post property screen to the navigation stack (optional, depending on your logic)
      navigationStack.add(1); // Assuming PostProperty is index 1
    } else {
      Timer(
        const Duration(seconds: 1),
            () => Get.to(const RegisterScreen()),
      );
    }
  }
}



