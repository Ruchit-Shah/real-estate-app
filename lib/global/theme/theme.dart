import 'package:flutter/material.dart';

import '../../utils/theme.dart';

ThemeData theme() {
  return ThemeData(
    scaffoldBackgroundColor: Colors.white,
    fontFamily: "Muli",
    // appBarTheme: appBarTheme(),
    textTheme: textTheme(),
    //inputDecorationTheme: inputDecorationTheme(),
    visualDensity: VisualDensity.standard,
  );
}