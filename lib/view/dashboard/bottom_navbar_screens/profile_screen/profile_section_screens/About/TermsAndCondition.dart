import 'package:flutter/material.dart';
import 'package:real_estate_app/global/AppBar.dart';

class TermsAndCondition extends StatefulWidget {
  const TermsAndCondition({super.key});

  @override
  State<TermsAndCondition> createState() => _TermsAndConditionState();
}

class _TermsAndConditionState extends State<TermsAndCondition> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: appBar(
          titleName: "Terms And Condition",
          automaticallyImplyLeading: true

      ),
    );
  }
}
