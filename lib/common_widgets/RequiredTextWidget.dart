import 'package:flutter/material.dart';

class RequiredTextWidget extends StatelessWidget {
  final String label;
  final double fontSize;
  final Color textColor;
  final Color asteriskColor;
  final FontWeight fontWeight;
  final EdgeInsets padding;

  const RequiredTextWidget({
    Key? key,
    required this.label,
    this.fontSize = 15.0,
    this.textColor = Colors.black,
    this.asteriskColor = Colors.red,
    this.fontWeight = FontWeight.bold,
    this.padding = const EdgeInsets.symmetric(horizontal: 8.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              color: textColor,
              fontWeight: fontWeight,
            ),
          ),
          Text(
            ' *',
            style: TextStyle(
              fontSize: fontSize,
              color: asteriskColor,
              fontWeight: fontWeight,
            ),
          ),
        ],
      ),
    );
  }
}