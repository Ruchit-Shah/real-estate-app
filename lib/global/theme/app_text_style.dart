// App TextStyle

import 'package:flutter/material.dart';

import '../app_color.dart';

class AppTextStyle {
  static TextStyle bold = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColor.black,
    letterSpacing: 0,
  );
  static TextStyle semiBold = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColor.black,
    letterSpacing: 0,
  );

  static TextStyle medium = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColor.black,
    letterSpacing: 0,
  );

  static TextStyle regular = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColor.black,
    letterSpacing: 0,
  );

  static TextStyle caption = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColor.white,
    letterSpacing: 0,
  );
}
