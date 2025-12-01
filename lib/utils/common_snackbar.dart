import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/common_widgets/height.dart';
import 'package:real_estate_app/global/api_string.dart';
import 'package:real_estate_app/global/app_color.dart';
import 'package:real_estate_app/view/auth/login_screen/login_screen.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/profile_screen/profile_section_screens/my_virtual_tour/GetScheduleBottomSheet.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/search_screen/searchController.dart';
import 'package:real_estate_app/view/property_screens/recommended_properties_screen/properties_details_screen.dart';

import '../common_widgets/loading_dart.dart';
import '../view/property_screens/properties_controllers/post_property_controller.dart';
import '../view/splash_screen/splash_screen.dart';

showSnackbar({required String message}) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.grey,
    textColor: Colors.white,
    fontSize: 15.0);
}
Future<void> showCommonBottomSheet({
  required BuildContext context,
  required String title,
  required String message,
  String yesText = 'Yes',
  String noText = 'No',
  Color buttonColor = const Color(0xFF813BEA),
  required VoidCallback onYesPressed,
  VoidCallback? onNoPressed,
  TextStyle? messageTextStyle,
}) async {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    isScrollControlled: true,
    builder: (context) {
      return SizedBox(
        height: MediaQuery.of(context).size.width * 0.60,
        child: Padding(
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Padding(
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
                        onTap: () => Navigator.pop(context),
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
                  const Spacer(),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  message,
                  style: messageTextStyle ?? const TextStyle(fontSize: 24),
                  textAlign: TextAlign.center,
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: commonButton(
                        width: 150,
                        height: 50,
                        buttonColor: buttonColor,
                        text: yesText,
                        textStyle: const TextStyle(
                            fontSize: 14,
                            color: Colors.white
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          onYesPressed();
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: commonButton(
                        width: 150,
                        height: 50,
                        buttonColor: buttonColor,
                        text: noText,
                        textStyle: const TextStyle(
                            fontSize: 14,
                            color: Colors.white
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          onNoPressed?.call();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<void> showCommonSinleButtonBottomSheet({
  required BuildContext context,
  required String title,
  required String message,
  String yesText = 'Ok',

  Color buttonColor = const Color(0xFF813BEA),
  required VoidCallback onYesPressed,
  VoidCallback? onNoPressed,
  TextStyle? messageTextStyle,
}) async {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    isScrollControlled: true,
    builder: (context) {
      return SizedBox(
        height: MediaQuery.of(context).size.width * 0.65,
        child: Padding(
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Padding(
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
                        onTap: () => Navigator.pop(context),
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
                  const Spacer(),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  message,
                  style: messageTextStyle ?? const TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:  commonButton(
                  width: 150,
                  height: 50,
                  buttonColor: buttonColor,
                  text: yesText,
                  textStyle: const TextStyle(
                      fontSize: 14,
                      color: Colors.white
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    onYesPressed();
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

