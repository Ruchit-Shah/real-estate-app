import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:real_estate_app/common_widgets/custom_textformfield.dart';
import 'package:real_estate_app/common_widgets/height.dart';
import 'package:real_estate_app/global/AppBar.dart';
import 'package:real_estate_app/global/app_color.dart';
import 'package:real_estate_app/global/constant.dart';

import '../profile_controller.dart';


class EditProfileDetailsScreen extends StatefulWidget {
  const EditProfileDetailsScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileDetailsScreen> createState() =>
      _EditProfileDetailsScreenState();
}

class _EditProfileDetailsScreenState extends State<EditProfileDetailsScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();
  ProfileController profileController = Get.put(ProfileController());

  @override
  void initState() {
    super.initState();
    profileController.getProfile();
    // _nameController.text = profileController.profile.value.name;
    // _emailController.text = profileController.profile.value.email;
    // _phoneController.text = profileController.profile.value.phone;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        titleName: edit_profile,
        automaticallyImplyLeading: false,
        onTap: () {
          Navigator.pop(context);
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!)
                          : const AssetImage('assets/user.png') as ImageProvider,
                    ),
                    Positioned(
                      bottom: 15,
                      right: 8,
                      child: GestureDetector(
                        onTap: () => _pickImage(ImageSource.gallery),
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.white70,
                          child: Icon(Icons.add, color: Colors.blue),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              boxH30(),
              Text(
                'Full Name',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black.withOpacity(0.7),
                    fontWeight: FontWeight.bold),
              ),
              boxH10(),
              CustomTextFormField(
                labelText: 'Enter your full name',
                keyboardType: TextInputType.text,
                controller: _nameController,
              ),
              boxH20(),
              Text(
                'Email',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black.withOpacity(0.7),
                    fontWeight: FontWeight.bold),
              ),
              boxH10(),
              CustomTextFormField(
                labelText: 'Enter your email',
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
              ),
              boxH20(),
              Text(
                'Phone',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black.withOpacity(0.7),
                    fontWeight: FontWeight.bold),
              ),
              boxH10(),
              CustomTextFormField(
                labelText: 'Enter your phone number',
                keyboardType: TextInputType.number,
                controller: _phoneController,
              ),
              boxH30(),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    String name = _nameController.text.trim();
                    String email = _emailController.text.trim();
                    String phone = _phoneController.text.trim();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.blue,
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
              ///
              // Center(
              //   child: ElevatedButton(
              //     onPressed: () {
              //       String name = _nameController.text.trim();
              //       String email = _emailController.text.trim();
              //       String phone = _phoneController.text.trim();
              //       Profile updatedProfile = Profile(
              //         name: name,
              //         email: email,
              //         phone: phone,
              //         profileImageUrl: profileController.profile.value.profileImageUrl,
              //       );
              //       profileController.updateProfile(updatedProfile);
              //     },
              //     style: ElevatedButton.styleFrom(
              //       primary: AppColor.blue,
              //       padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(25),
              //       ),
              //     ),
              //     child: const Text(
              //       'Save Changes',
              //       style: TextStyle(
              //         color: Colors.white,
              //         fontWeight: FontWeight.bold,
              //         fontSize: 17,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
