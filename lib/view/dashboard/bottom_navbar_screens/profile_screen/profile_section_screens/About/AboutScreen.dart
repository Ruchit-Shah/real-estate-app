import 'package:flutter/material.dart';
import 'package:real_estate_app/global/AppBar.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: appBar(
        titleName: "About",
          automaticallyImplyLeading: true

      ),
    );
  }
}
