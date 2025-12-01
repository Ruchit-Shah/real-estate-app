import 'package:flutter/material.dart';

class CustomContainer extends StatefulWidget {
  final Widget child;
  final double? width;
  final double? height;
  final Color? color;
  final double? borderRadius;
  final double? borderWidth;
  final Color? borderColor;
  final EdgeInsets? padding;
  final List<BoxShadow>? boxShadow;
  final Gradient? gradient;
  final EdgeInsets? margin;

  const CustomContainer({
    Key? key,
    required this.child,
    this.color,
    this.borderRadius,
    this.borderWidth,
    this.borderColor,
    this.padding,
    this.boxShadow,
    this.gradient,
    this.width,
    this.height,
    this.margin
  }) : super(key: key);

  @override
  _CustomContainerState createState() => _CustomContainerState();
}

class _CustomContainerState extends State<CustomContainer> {
  @override
  Widget build(BuildContext context) {
    double containerWidth = widget.width ?? MediaQuery.of(context).size.width;
    double containerHeight = widget.height ?? MediaQuery.of(context).size.height;

    return Container(
      margin: widget.margin ?? EdgeInsets.zero,
      width: containerWidth,
      height: containerHeight,
      padding: widget.padding ?? EdgeInsets.zero,
      decoration: BoxDecoration(
        color: widget.color ?? Theme.of(context).canvasColor,
        borderRadius: BorderRadius.circular(widget.borderRadius ?? 0),
        border: Border.all(
          width: widget.borderWidth ?? 0,
          color: widget.borderColor ?? Colors.transparent,
        ),
        boxShadow: widget.boxShadow ?? [],
        gradient: widget.gradient,
      ),
      child: widget.child,
    );
  }
}

