
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:real_estate_app/global/app_color.dart';

const themeColor = Color(0xFF7439CB);


///for otp
final otpInputDecoration =
InputDecoration(
  contentPadding:
  EdgeInsets.symmetric(vertical: 10),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);
OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(15),
    borderSide:  BorderSide(color: themeColor),
  );
}

///for textfiled
InputDecoration customInputDecoration({
  String hintText = "",
  BorderSide? border,
}) {
  return InputDecoration(
    filled: true,
    fillColor: AppColor.white,
    contentPadding: const EdgeInsets.all(10),
    hintText: hintText,
    focusedBorder: OutlineInputBorder(
      borderSide: border ?? BorderSide(color: AppColor.grey, width: 1),
      borderRadius: BorderRadius.circular(20),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: border ?? BorderSide(color: AppColor.red, width: 1),
      borderRadius: BorderRadius.circular(20),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: border ?? BorderSide(color: AppColor.grey, width: 1),
      borderRadius: BorderRadius.circular(20),
    ),
  );
}




