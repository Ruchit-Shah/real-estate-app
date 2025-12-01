
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:real_estate_app/view/dashboard/view/BottomNavbar.dart';

import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/search_screen/searchController.dart';
import 'package:real_estate_app/view/welcome_screen/view/welcome_screen.dart';

import '../../utils/String_constant.dart';
import '../../utils/shared_preferences/shared_preferances.dart';
import '../dashboard/bottom_navbar_screens/profile_screen/profile_controller.dart';
bool isLogin = false;
class SplashScreen extends StatefulWidget {


  const SplashScreen({Key? key,}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {





  @override
  void initState() {
    super.initState();

    goToScreen();


  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Image.asset(
              'assets/Houzza.png',
              width: 100,
              height: 100,
            ),

          ],
        ),
      ),
    );
  }

  goToScreen() async {
    String? retrievedUserId = await SPManager.instance.getUserId(USER_ID);
    bool isShowWCLPG = await SPManager.instance.getIsShowWlcPg(SHOW_WCL_PG) ?? false;
    bool? islogin =await SPManager.instance.getUserLogin(LOGINKEY.toString());
    String? showHome =  await SPManager.instance.getLoginScrrenView("show_home");

    print('showHome: $showHome');
    print('Retrieved User ID: $retrievedUserId');
    print('LOGINKEY User ID: $isLogin');
    if(islogin==true){
      isLogin =true;
      if(retrievedUserId!=null || retrievedUserId!.isNotEmpty){
        Timer(
          const Duration(seconds: 2),
              () => Get.offAll(const BottomNavbar()),
        );
      }
      else{
        Timer(
          const Duration(seconds: 2),
              () => Get.offAll( WelcomeScreen()),
        );
      }

    }
    else if(showHome == "yes"){
      Timer(
        const Duration(seconds: 2),
            () => Get.offAll(const BottomNavbar()),
      );
    }
    else if(isShowWCLPG){
      Timer(
        const Duration(seconds: 2),
            () => Get.offAll(const BottomNavbar()),
      );
    }
    else{
      Timer(
        const Duration(seconds: 2),
            () => Get.offAll( WelcomeScreen()),
      );
    }

  }
}
