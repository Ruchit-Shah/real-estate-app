
// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app_color.dart';
import '../theme/app_text_style.dart';

class CommonTextField extends StatelessWidget {
  final String? hintText;
  TextStyle? hintStyle;
  final String? validationMessage;
  Color? fillColor;
  void Function()? onTap;
  final bool needValidation;
  final bool isEmailValidation;
  final double? height;
  final double? width;
  FocusNode? focusNode;
  final double? topContentPadding;
  final double? bottomContentPadding;
  final double? rightContentPadding;
  final double? leftContentPadding;
  final double? leftPadding;
  final double? rightPadding;
  final double? topPadding;
  final double? bottomPadding;
  BorderRadiusGeometry? borderRadius;
  double? textfieldBorderRadius;
  final TextEditingController? controller;
  final bool isPhoneValidation;
  final bool isPasswordValidation;
  final bool readOnly;
  final TextInputType? textInputType;
  final int? maxLine;
  final int? maxLength;
  final Widget? suffix;
  final double? fontSize;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Color? focusBorderColor;
  final List<TextInputFormatter>? inputFormatters;
  final bool isTransparentColorBorder;
  final bool focusBorder;
  final bool isSmallTitle;
  final String? title;
  final TextStyle? titleTextStyle;

  final String? Function(String?)? validator;
  // final String? Function(String?)? onChange;
  final dynamic onChange;
  final Function(String)? onFieldSubmitted;
  final bool obscureText;
  final Color? cursorColor;
  final bool autofocus;
  final TextAlign? textAlign;

  CommonTextField({
    super.key,
    this.needValidation = false,
    this.isEmailValidation = false,
    this.focusBorder = false,
    this.title,
    this.fillColor,
    this.hintText,
    this.titleTextStyle,
    this.hintStyle,
    this.validationMessage,
    this.height,
    this.width,
    this.autofocus = false,
    this.cursorColor,
    this.focusBorderColor,
    this.readOnly = false,
    this.topContentPadding,
    this.fontSize,
    this.focusNode,
    this.bottomContentPadding,
    this.textAlign,
    this.onTap,
    this.rightContentPadding,
    this.leftContentPadding,
    this.leftPadding,
    this.rightPadding,
    this.topPadding,
    this.bottomPadding,
    this.borderRadius,
    this.controller,
    this.textfieldBorderRadius,
    this.isPhoneValidation = false,
    this.textInputType,
    this.inputFormatters,
    this.maxLine,
    this.onFieldSubmitted,
    this.maxLength,
    this.isTransparentColorBorder = false,
    this.suffix,
    this.suffixIcon,
    this.isSmallTitle = false,
    this.prefixIcon,
    this.validator,
    this.isPasswordValidation = false,
    this.obscureText = false,
    this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        title == null || title!.isEmpty ?const SizedBox(): Align(
            alignment: AlignmentDirectional.topStart,
            child: Text(title ??"" ,style: titleTextStyle ?? AppTextStyle.medium.copyWith(fontSize: 16),)),
        Container(
          height: height,
          width: width,
          margin: EdgeInsets.only(
              top: topPadding ?? 0,
              bottom: bottomPadding ?? 0,
              left: leftPadding ?? 0,
              right: rightPadding ?? 0),
          decoration: BoxDecoration(borderRadius: borderRadius),
          child: TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onFieldSubmitted: onFieldSubmitted,
            focusNode: focusNode,
            maxLines: maxLine,
            autofocus: autofocus,
            maxLength: maxLength,
            controller: controller,
            cursorColor: cursorColor,
            textAlign: textAlign ?? TextAlign.left,
            readOnly: readOnly,
            onTap: onTap,
              onChanged: onChange,
            obscureText: obscureText,
            inputFormatters: inputFormatters ?? [],
              keyboardType: textInputType ?? TextInputType.text,
            style: AppTextStyle.regular.copyWith(fontSize: fontSize ?? 15),

            decoration: InputDecoration(
                fillColor: fillColor ?? AppColor.white,
              contentPadding: EdgeInsets.only(
                  top: topContentPadding ?? 16,
                  bottom: bottomContentPadding ?? 15,
                  right: rightContentPadding ?? 20,
                  left: leftContentPadding ?? 20),
              isDense: true,
              filled: true,
              counterText: "",
              hintText: hintText ?? "",
              suffix: suffix,
              suffixIcon: suffixIcon,
              prefixIcon: prefixIcon,
              prefixIconConstraints:
              const BoxConstraints(minHeight: 38, minWidth: 38),
              hintStyle: hintStyle ??  AppTextStyle.regular.copyWith(color: AppColor.hintTextColor, fontSize: 16),
              border: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: isTransparentColorBorder
                          ? AppColor.transparent
                          : AppColor.grey),
                  borderRadius: BorderRadius.circular(textfieldBorderRadius ?? 5)),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: isTransparentColorBorder
                          ? AppColor.transparent
                          : AppColor.grey),
                  borderRadius: BorderRadius.circular(textfieldBorderRadius ?? 5)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: focusBorder == true
                          ? focusBorderColor!
                          : isTransparentColorBorder
                          ? AppColor.transparent
                          : AppColor.grey),
                  borderRadius: BorderRadius.circular(textfieldBorderRadius ?? 5)),
              errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: isTransparentColorBorder
                          ? AppColor.transparent
                          : AppColor.grey),
                  borderRadius: BorderRadius.circular(textfieldBorderRadius ?? 5)),
            ),
            // validator: needValidation
            //     ? validator ??
            //         (v) {
            //           return TextFieldValidation.validation(
            //               message: validationMessage ?? title,
            //               value: v,
            //               isPasswordValidator: isPasswordValidation,
            //               isPhone: isPhoneValidation,
            //
            //               isEmailValidator: isEmailValidation);
            //         }
            //     : null,
          ),
        ),
      ],
    );
  }
}