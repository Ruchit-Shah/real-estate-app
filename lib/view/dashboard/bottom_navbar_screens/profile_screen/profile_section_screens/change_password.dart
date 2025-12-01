import 'package:flutter/material.dart';
import 'package:real_estate_app/common_widgets/custom_textformfield.dart';
import 'package:real_estate_app/common_widgets/height.dart';
import 'package:real_estate_app/global/AppBar.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _changePassword() {
    String currentPassword = _currentPasswordController.text.trim();
    String newPassword = _newPasswordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    if (newPassword == confirmPassword) {
      // Implement password change logic
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password changed successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('New passwords do not match')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        //automaticallyImplyLeading: false,
        titleName: "Change Password",
        onTap: () {
          Navigator.pop(context);
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Password',
              style: TextStyle(fontSize: 16, color: Colors.black.withOpacity(0.7), fontWeight: FontWeight.bold),
            ),
            boxH10(),
            CustomTextFormField(
              controller: _currentPasswordController,
              obscureText: true,
             labelText: 'Current Password', hintText: 'Enter your current password',
            ),
            boxH20(),
            Text(
              'New Password',
              style: TextStyle(fontSize: 16, color: Colors.black.withOpacity(0.7), fontWeight: FontWeight.bold),
            ),
            boxH10(),
            CustomTextFormField(
              controller: _newPasswordController,
              obscureText: true,
              labelText: 'New Password', hintText: 'Enter your new password',
            ),
            boxH20(),
            Text(
              'Confirm New Password',
              style: TextStyle(fontSize: 16, color: Colors.black.withOpacity(0.7), fontWeight: FontWeight.bold),
            ),
           boxH10(),
            CustomTextFormField(
              controller: _confirmPasswordController,
              obscureText: true,
                labelText: 'Confirm new password', hintText: "Confirm your new password"
            ),
            boxH30(),
            Center(
              child: ElevatedButton(
                onPressed: _changePassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Change Password',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
