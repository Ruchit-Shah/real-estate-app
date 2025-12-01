import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/common_widgets/height.dart';
import 'package:real_estate_app/global/app_color.dart';

class PropertyDetailRow extends StatefulWidget {
  final String label;
  final String value;
  final String image;

  const PropertyDetailRow({
    Key? key,
    required this.label,
    required this.value,
    required this.image,
  }) : super(key: key);

  @override
  _PropertyDetailRowState createState() => _PropertyDetailRowState();
}

class _PropertyDetailRowState extends State<PropertyDetailRow> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start, // Align text to the top
        children: [
          // Label
          SizedBox(
            width: 100, // Fixed width for the label column
            child: Text(
              widget.label,
              style: const TextStyle(fontSize: 14,color: AppColor.grey),
            ),
          ),
          // Value
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                widget.image.isNotEmpty?
                Image.asset(widget.image,height: 20,width: 20,):const SizedBox(),
                widget.image.isNotEmpty?
                const SizedBox(width: 5,):const SizedBox(),
                SizedBox(
                  width: Get.width * 0.4,
                  child: Text(
                    widget.value,
                    style: const TextStyle(
                      fontFamily: "Muli",
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          )

        ],
      ),
    );
  }
}

/// For developers properties
class DeveloperPropertyDetailRow extends StatefulWidget {
  final String label;
  final String value;

  const DeveloperPropertyDetailRow({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  _DeveloperPropertyDetailRowState createState() => _DeveloperPropertyDetailRowState();
}

class _DeveloperPropertyDetailRowState extends State<DeveloperPropertyDetailRow> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Text(
            widget.label,
            style:  const TextStyle(fontSize: 14,color: AppColor.grey),
          ),
          const Spacer(),
          // Value
          Text(
            widget.value,
            style: const TextStyle(
              fontFamily: "Muli",
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          )

        ],
      ),
    );
  }
}
