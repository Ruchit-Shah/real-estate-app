import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/global/app_color.dart';

class DialogUtil {
  static void showLoadingDialog() {
    Get.dialog(
      Center(
        child: CircularProgressIndicator(color: AppColor.blue),
      ),
      barrierDismissible: false,
    );
  }

  static void hideLoadingDialog() {
    if (Get.isDialogOpen == true) {
      Get.back();
    }
  }

  static Future<void> showLoadingDialogWithDelay({int milliseconds = 600}) async {
    showLoadingDialog();
    await Future.delayed(Duration(milliseconds: milliseconds));
    hideLoadingDialog();
  }
}
