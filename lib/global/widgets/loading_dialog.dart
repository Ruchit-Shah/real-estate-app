import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../app_color.dart';

void showLoadingDialog(
    {bool? loadingText = false, bool? loader = true, bool? delay = false}) {
  Future.delayed(
    delay == false ? Duration.zero : const Duration(seconds: 1),
    () {
      Get.dialog(
        barrierDismissible: false,
        WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Material(
            color: Colors.transparent,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      color: loader == true && loadingText == false
                          ? Colors.transparent
                          : AppColor.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  )),
            ),
          ),
        ),
      );
    },
  );
}

void hideLoadingDialog({bool isTrue = false}) {
  Get.back(
    closeOverlays: isTrue,
  );
}
