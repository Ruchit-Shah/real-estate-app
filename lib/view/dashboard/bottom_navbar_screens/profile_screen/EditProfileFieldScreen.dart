import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:real_estate_app/common_widgets/custom_textformfield.dart';
import 'package:real_estate_app/common_widgets/height.dart';
import 'package:real_estate_app/common_widgets/loading_dart.dart';
import 'package:real_estate_app/global/app_color.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/profile_screen/profile_controller.dart';

import '../../../../utils/String_constant.dart';
import '../../../../utils/shared_preferences/shared_preferances.dart';
import '../../../auth/auth_controllers/registration_controller.dart';

class EditProfileFieldScreen extends StatefulWidget {
  final String title;
  final TextEditingController textEditingController;


  const EditProfileFieldScreen({
    Key? key,
    required this.title,
    required this.textEditingController,
  }) : super(key: key);

  @override
  _EditProfileFieldScreenState createState() => _EditProfileFieldScreenState();
}

class _EditProfileFieldScreenState extends State<EditProfileFieldScreen> {
  final controller = Get.find<ProfileController>();
  final _formkey = GlobalKey<FormState>();
  bool _showOtpUI = false;
  String _selectedCountryCode = '+91';


  final List<String> proprietorshipList = [
    'Individual',
    'Partnership',
    'Private Limited',
    'LLP'
  ];

  late String selectedProprietorship ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedProprietorship = widget.textEditingController.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.title == "Mobile"
              ? "Update Your ${widget.title} number"
              : "Update Your ${widget.title}",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 46,
        leading: Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.black,
                width: 0.1,
              ),
            ),
            child: InkWell(
              onTap: () {
                Get.back();
              },
              borderRadius: BorderRadius.circular(50),
              child: const Padding(
                padding: EdgeInsets.all(6),
                child: Icon(
                  Icons.arrow_back_outlined,
                  size: 18,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formkey,
          child: Column(
            children: [

              (widget.title == 'Experience')
                  ? Text(
                "What's your ${widget.title.toLowerCase()} in Years",
                style: const TextStyle(color: Colors.black, fontSize: 24),
              )
                  : Text(
                "What's your ${widget.title.toLowerCase()}?",
                style: const TextStyle(color: Colors.black, fontSize: 24),
              ),
              boxH50(),
              if (widget.title == 'Mobile')
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 8,),
                        Expanded(
                          child: TextFormField(
                            controller: widget.textEditingController,
                            keyboardType: TextInputType.phone,
                            maxLength: 10,
                            decoration: InputDecoration(
                              hintText: "Enter mobile number",
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter mobile number';
                              } else if (!RegExp(r'^[0-9]{10}$').hasMatch(value.trim())) {
                                return 'Enter a valid 10-digit mobile number';
                              } else if (value.trim().length != 10) {
                                return 'Enter valid 10-digit number';
                              }else if (value.trim().length < 10) {
                                return 'Enter valid 10-digit number';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                )else if (widget.title == 'Name')
                TextFormField(
                  controller: widget.textEditingController,
                  decoration: InputDecoration(
                    hintText: "Enter ${widget.title.toLowerCase()} here..",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Name is required';
                    } else if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                      return 'Name must contain only letters and spaces';
                    }
                    return null;
                  },
                )
              else if (widget.title != 'Proprietorship')
                CustomTextFormField(
                  size: 50,
                  maxLines: 2,
                  controller: widget.textEditingController,
                  hintText: "Enter ${widget.title.toLowerCase()} here..",
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Field is required';
                    } else if (widget.title == 'Email' && !value.contains('@')) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                )
              else
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                  ),
                  borderRadius: BorderRadius.circular(15),
                  dropdownColor: AppColor.white,
                  value: selectedProprietorship.isEmpty ? null : selectedProprietorship,
                  hint: const Text("Select Proprietorship"),
                  items: [
                    const DropdownMenuItem<String>(
                      value: null,
                      enabled: false,
                      child: Text(
                        "Select Proprietorship",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    ...proprietorshipList.map(
                          (value) => DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      ),
                    )
                  ],
                  onChanged: (newValue) {
                    setState(() {
                      selectedProprietorship = newValue!;
                      widget.textEditingController.text = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select an option';
                    }
                    return null;
                  },
                ),


              boxH20(),
              const Spacer(),
              commonButton(
                width: Get.width,
                height: 60,
                textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold),
                text: "Save",
                onPressed: () {
                  if (_formkey.currentState!.validate()) {
                    controller.edit().then((value) {
                      Navigator.pop(context);
                    });
                  }
                },
              )
// Or just don’t render anything

            ],
          ),
        ),
      ),
    );
  }
}

