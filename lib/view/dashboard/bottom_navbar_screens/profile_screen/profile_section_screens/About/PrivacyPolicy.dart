import 'package:flutter/material.dart';
import 'package:real_estate_app/global/AppBar.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({super.key});

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: appBar(
          titleName: "Privacy Policy",
          automaticallyImplyLeading: true

      ),
    );
  }
}
