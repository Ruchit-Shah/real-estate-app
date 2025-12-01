import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:real_estate_app/common_widgets/RequiredTextWidget.dart';
import 'package:real_estate_app/common_widgets/height.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String? labelText;
  final double? size;
  final String? hintText;
  final String? initialValue;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool alignLabelWithHint;
  final Widget? prefixIcon;
  final bool filled;
  final Widget? sufixIcon;
  final FocusNode? focusNode;
  final Function(String)? onChanged;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;
  final bool readOnly;
  final bool isRequired;
  final double labelFontSize;
  final Color labelColor;
  final Color asteriskColor;
  final FontWeight labelFontWeight;

  CustomTextFormField({
    required this.controller,
    this.labelText,
    this.initialValue,
    this.hintText,
    this.alignLabelWithHint = false,
    this.prefixIcon,
    this.onChanged,
    this.filled = true,
    this.sufixIcon,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.maxLength,
    this.focusNode,
    this.inputFormatters,
    this.maxLines = 1,
    this.readOnly = false,
    this.size,
    this.isRequired = false,
    this.labelFontSize = 15.0,
    this.labelColor = Colors.black,
    this.asteriskColor = Colors.red,
    this.labelFontWeight = FontWeight.bold,
  }) : assert(!obscureText || maxLines == 1, 'Obscured fields cannot be multiline.');

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null && labelText!.isNotEmpty)
          isRequired
              ? RequiredTextWidget(
            label: labelText!,
            fontSize: labelFontSize,
            textColor: labelColor,
            asteriskColor: asteriskColor,
            fontWeight: labelFontWeight,
          )
              : Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Text(
              labelText!,
              style: TextStyle(
                fontSize: labelFontSize,
                color: labelColor,
                fontWeight: labelFontWeight,
              ),
            ),
          ),
        boxH10(),
        Container(
          constraints: BoxConstraints(minHeight: size ?? 45),
          alignment: Alignment.center,
          child: TextFormField(
            initialValue: initialValue,
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            maxLength: maxLength,
            inputFormatters: inputFormatters,
            validator: validator,
            onChanged: onChanged,
            focusNode: focusNode,
            maxLines: maxLines,
            readOnly: readOnly,
            decoration: InputDecoration(
              isDense: true,
              hintText: hintText,
              alignLabelWithHint: alignLabelWithHint,
              prefixIcon: prefixIcon,
              suffixIcon: sufixIcon,
              labelStyle: TextStyle(
                color: Colors.grey[500],
                fontSize: 14.0,
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 0.8),
                borderRadius: BorderRadius.circular(10.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 0.8),
                borderRadius: BorderRadius.circular(10.0),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              counterText: '',
              filled: filled,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
            ),
          ),
        ),
      ],
    );
  }
}

