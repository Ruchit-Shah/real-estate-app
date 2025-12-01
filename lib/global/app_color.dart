// App Colors

import 'package:flutter/material.dart';

class AppColor {

  static const Color primaryColor = Color(0xFF607D8B);

  static const Color textGrey = Color(0xFF929292);
  static const Color textLightBlueGrey = Color(0xFF6D7A87);
  static  const Color app_background = Color(0xFFeeeeee);
  static const Color red = Color(0xFFC5032B);
  static const Color text_black = Color(0xFF424141);
  static const Color image_bg_grey = Color(0xFF424141);
  static const Color pandingColor = Color(0xFFC9B626);



  static const Color shrinePink400 = Color(0xFFEAA4A4);
  static const Color nightBlue = Color(0xFF0e1e40);
  static const Color nightBlueLight = Color(0xff2a4a8f);
  static const Color shrineBrown900 = Color(0xFF442B2D);
  static const Color shrineBrown600 = Color(0xFF7D4F52);

  static  const Color shrineErrorRed = Color(0xFFC5032B);

  static const Color shrineSurfaceWhite = Color(0xFFFFFBFA);
  static  const Color shrineBackgroundWhite = Colors.white;

  static  const Color status_green = Color(0xFF05DA05);
  static  const Color status_yellow = Color(0xFFff9500);
  static  const Color status_red = Color(0xFFD81B60);
  static  const Color online_green = Color(0xFF05DA05);
  static  const Color clinic_blue = Color(0xFF0A3DE9);
  static  const Color lightBlue = Color(0xFF563EE2);
  static  const Color lightPurple = Color(0xFF813BEA);


  static const transparent = Color(0x00FFFFFF);
  static const black = Color(0xff000000);
  static const white = Color(0xFFFFFFFF);
  static const grey = Colors.grey;
  static const yellow = Colors.yellow;
  static const green = Colors.green;
  static const amber = Colors.amber;
  static const orange = Colors.orange;
  static const deeporange = Colors.deepOrange;
  static const orangeAccent = Colors.orangeAccent;
  static const blue = Colors.blue;
  static const blueGrey = Colors.blueGrey;
  static const lightBlueAccent = Colors.lightBlueAccent;

  static const black87 = Colors.black87;
  static const black45 = Colors.black45;
  static const black54 = Colors.black54;

  // Hexadecimal Color
  static Color hexGrey = fromHex('#121212');

  static const deepPurpleAccent = Colors.deepPurpleAccent;
  static const deepPurple = Colors.deepPurple;
  static const purple = Colors.purple;

  // Constant color
  static const Color whiteColor = Colors.white;
  static const Color blackColor = Colors.black;
  static const Color redColor = Colors.red;
  static const Color greyColor = Colors.grey;
  static const Color blueColor = Colors.blue;
  static const Color transparentColor = Colors.transparent;

  static const backgroundColor = Color(0xffEBEBEB);
  static const greyShade = Color(0xffF9FAFB);
  static const greyBorderColor = Color(0xffD9D9D9);
  static const hintTextColor = Color(0xff434A54);
  static const textColor = Color(0xff111928);
  static const buttonTextColor = Color(0xffF9FAFB);
  static const lightGreyColor = Color(0xffF5F5F5);
  static const vistaBlue = Color(0xffA3B8CC);
  static const lightGreenColor = Color(0xffFFB061);
  static const yellowButton = Color(0xFFF5CC3D);
  static const lightWhiteColor = Color(0xffF2F2F2);
  static const lightGrey = Color(0xff999999);
  static const lightGreen = Color(0xff67C8A6);

  //from new theme



  static const Color welcomeColor = Color(0xFFEEF4FC);
  static const Color boldColor = Color(0xFF72E23E);
  static const Color bold1Color = Color(0xFFFFE5E3);
  static const Color bgColor = Color(0xFFF7F5FE);
  static const Color primaryThemeColor = Color(0xFF813BEA);
  static const Color secondaryThemeColor = Color(0xFFF5CC3D);
  static const Color baarColor = Color(0xFF9DB8DA);


  static Color fromHex(
      String hexString,
      ) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) {
      buffer.write(
        'ff',
      );
    }
    buffer.write(
      hexString.replaceFirst(
        '#',
        '',
      ),
    );
    return Color(
      int.parse(
        buffer.toString(),
        radix: 16,
      ),
    );
  }
}
