import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:real_estate_app/global/app_color.dart';

class Slider_Component extends StatefulWidget{
  // late double value;
  // SliderUi({required double value});

  @override
  State<Slider_Component> createState() => _Slider_ComponentState();
}
class _Slider_ComponentState extends State<Slider_Component>
{
  double _currentSliderValue = 1;
  @override
  Widget build(BuildContext context) {
    return Container(child:
    SizedBox(
      height: 30,
      width: double.maxFinite,
      child: Padding(
          padding: EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
          child:Slider(
            value: _currentSliderValue,
            min: 1,
            max: 20,
            divisions: 20,
            thumbColor: AppColor.blue,
            label: _currentSliderValue.round().toString(),
            onChanged: (double value) {
              setState(() {
                _currentSliderValue = value;
              });
            },
          )
      ),
    ),);
  }

}