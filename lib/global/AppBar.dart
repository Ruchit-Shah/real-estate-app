import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/global/app_color.dart';

AppBar appBar({
  String? titleName,
  void Function()? onTap,
  Color? backgroundColor,
  List<Widget>? actions,
  bool automaticallyImplyLeading = false,
  Color? textColor,
  Color? borderColor,
  double? borderWidth,
}) {
  return AppBar(
    backgroundColor: backgroundColor ?? Colors.white,
    automaticallyImplyLeading: automaticallyImplyLeading,
    scrolledUnderElevation: 0,
    elevation: 0,
    centerTitle: true,
    leadingWidth: 46,
    leading: automaticallyImplyLeading
        ? Padding(
      padding: const EdgeInsets.only(left: 5.0),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: borderColor ?? Colors.black,
            width: borderWidth ?? 0.1,
          ),
        ),
        child: InkWell(
          onTap: onTap ?? () => Get.back(),
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
    )
        : null,
    title: Text(
      titleName ?? "",
      style: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.bold,
        color: textColor ?? Colors.black,
      ),
    ),
    actions: actions ?? [],
  );
}
