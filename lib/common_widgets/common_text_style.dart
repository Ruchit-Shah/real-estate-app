import 'package:flutter/material.dart';
import 'package:real_estate_app/global/app_color.dart';

class AppTextStyle {
  static TextStyle commonTextStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.normal,
    letterSpacing: 1.0,
    wordSpacing: 2.0,
    color: AppColor.black.withOpacity(0.7),
    decoration: TextDecoration.none,
    decorationColor: AppColor.transparent,
    decorationStyle: TextDecorationStyle.solid,
    height: 1.5,
    // shadows: [
    //   Shadow(
    //     color: AppColor.grey,
    //     blurRadius: 2.0,
    //     offset: Offset(1.0, 1.0),
    //   ),
    // ],
  );
}
