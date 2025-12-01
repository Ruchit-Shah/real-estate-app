import 'package:flutter/material.dart';
import 'package:real_estate_app/global/AppBar.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: appBar(
          titleName: "Setting",
          automaticallyImplyLeading: true

      ),
    );
  }
}
