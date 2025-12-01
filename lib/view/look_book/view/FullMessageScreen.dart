import 'package:flutter/material.dart';

import '../../../global/AppBar.dart';

class FullMessageScreen extends StatelessWidget {
  final String message;

  FullMessageScreen({required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:appBar(titleName: 'Enquiry Message'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: TextFormField(
            initialValue: message,
            maxLines: null, // Allows unlimited lines
            readOnly: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Message',
              alignLabelWithHint: true,
            ),
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
