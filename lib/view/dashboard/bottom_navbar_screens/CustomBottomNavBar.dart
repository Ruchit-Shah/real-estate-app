import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/common_widgets/height.dart';
import 'package:real_estate_app/global/app_color.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/profile_screen/profile_section_screens/Listing/listing_screen.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/save_screen/save_screen.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/search_screen/search_screen.dart';
import 'package:real_estate_app/view/dashboard/deshboard_controllers/bottom_bar_controller.dart';
import 'package:real_estate_app/view/dashboard/view/BotScreen.dart';
import 'package:real_estate_app/view/dashboard/view/BottomNavbar.dart';
import 'package:real_estate_app/view/property_screens/properties_controllers/post_property_controller.dart';


class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({super.key});

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  final BottomBarController bottomBarController = Get.find();
  final PostPropertyController postPropertyController = Get.find();




  void _handleTabTap(int index) {
    setState(() {
      bottomBarController.selectedBottomIndex.value = index;
    });

    switch(index) {
      case 0:
        Get.to(() => const BottomNavbar());
        break;
      case 1:
        Get.to(() => const Onboarding_Screen(isfrom: 'bottom',));
        break;
      case 2:
        if(postPropertyController.isBuyerSelected.value) {
          Get.to(() => const SaveScreen(isFrom: 'searchScreen', isfrom: 'bottom',));
        } else {
          // Get.offAll(() => const ListingScreen());
          Get.to(() => const SaveScreen(isFrom: 'searchScreen', isfrom: 'bottom',));
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
    onWillPop: showAlertExit,
      child: Container(
      height: 72,
      margin: const EdgeInsets.all(16),
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
          onTap: _handleTabTap,
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
            BottomNavigationBarItem(
              icon: Image.asset(
                postPropertyController.isBuyerSelected.value
                    ? 'assets/image_rent/saveSearch.png'
                    : 'assets/image_rent/saveSearch.png',
                width: 24,
                height: 24,
                color: bottomBarController.selectedBottomIndex.value == 2
                    ? AppColor.white
                    : AppColor.white.withOpacity(0.5),
              ),
              label: postPropertyController.isBuyerSelected.value
                  ? 'Save Search'
                  : 'Save Search'
            ),
          ],
        ),
      ),
    ));
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
                      // Back button aligned to the start (left)
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

                      // Exit text centered
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
                  style: TextStyle( fontSize: 17,color: AppColor.black.withOpacity(0.7)),
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
}