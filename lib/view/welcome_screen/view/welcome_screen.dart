import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/Routes/app_pages.dart';
import 'package:real_estate_app/common_widgets/height.dart';
import 'package:real_estate_app/global/app_color.dart';
import 'package:real_estate_app/view/auth/login_bottom_sheet/login_bottom_sheet.dart';
import 'package:real_estate_app/view/auth/register_screen/register_screen.dart';

import '../../../common_widgets/loading_dart.dart';
import '../../../utils/String_constant.dart';
import '../../../utils/shared_preferences/shared_preferances.dart';

 double screenWidth = 0.0 ;
 double screenHeight = 0.0;

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  int contentIndex = 0;

  void toggleContent() {
    setState(() {
      contentIndex = (contentIndex + 1) % 3;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
backgroundColor: Colors.white,
      body: Column(
        children: [

          const SizedBox(height: 60),

          Center(
            child: Image.asset(
              'assets/welcomePage/welcomeHouse.png',
              width: 400,
              height: 300,
             // color: AppColor.welcomeColor,
              fit: BoxFit.cover,
            ),
          ),

          const Spacer(),

          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: contentIndex == 0
                ? _buildFirstContent()
                : contentIndex == 1
                ? _buildSecondContent()
                : _buildThirdContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildFirstContent() {
    return _contentContainer(
      key: const ValueKey(1),
      title: "Effortless Property Listings with AI",
      subtitle: "📸 Upload Your Property Instantly",
      description: "Just snap a photo, and our AI fills in the details for you!",
    );
  }

  Widget _buildSecondContent() {
    return _contentContainer(
      key: const ValueKey(2),
      title: "Smart Property Search just speak!",
      subtitle: "🎙️ Find your Dream home with with voice",
      description: "Simply describe what you want, and AI finds the perfect match",
    );
  }

  Widget _buildThirdContent() {
    return Container(
      key: const ValueKey(3),
      height: 280,
      padding: const EdgeInsets.all(20),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "AI-Powered Property Recommendations",
            style: TextStyle(
              color: AppColor.primaryThemeColor,
              fontWeight: FontWeight.w900,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Smarter Recommendations",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            "AI learns your preferences to suggest the best properties for you.",
            style: TextStyle(fontSize: 16, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),

          SizedBox(
            width: double.infinity,
            height: 50,
            child:commonButton(
              text: "Let's Start",
              onPressed: () async {
                 await SPManager.instance.setShowWclPG(SHOW_WCL_PG,true);
                 bool isShowWCLPG = await SPManager.instance.getIsShowWlcPg(SHOW_WCL_PG) ?? false;
                 print('wcl page display : $isShowWCLPG');
                Timer(
                    const Duration(seconds: 1),
                        () =>  Get.toNamed(Routes.bottomNavbar)
                );
              },
            )

          ),
        ],
      ),
    );
  }

  Widget _contentContainer({Key? key, required String title, required String subtitle, required String description}) {
    return Container(
      key: key,
      height: 290,
      padding: const EdgeInsets.all(20),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              color:AppColor.primaryThemeColor,
              fontWeight: FontWeight.w900,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(fontSize: 16, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: toggleContent,
            child: CircleAvatar(
              backgroundColor: AppColor.primaryThemeColor,
              radius: 25,
              child: const Icon(
                Icons.arrow_forward,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _boxDecoration() {
    return const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 0.5,
          spreadRadius: 0.5,
        ),
      ],
    );
  }
}