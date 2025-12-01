
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/global/services/api_shorts_string.dart';

import '../../../global/AppBar.dart';
import '../../../global/app_string.dart';
import '../../../global/services/network_http.dart';
import '../../../global/widgets/common_textfield.dart';
import '../../../global/widgets/loading_dialog.dart';

import '../../shorts/controller/my_profile_controller.dart';

class AddEnquiry extends StatefulWidget {
  final String productId;
  final String otherUserId;
  const AddEnquiry({Key? key, required this.productId,required this.otherUserId}) : super(key: key);

  @override
  State<AddEnquiry> createState() => _AddEnquiryState();
}

class _AddEnquiryState extends State<AddEnquiry> {
  final TextEditingController _enquiryEditingController =
      TextEditingController();
  final myProfileController = Get.find<MyProfileController>();

  bool isSubmitting = false;
  late TextEditingController nameController;
  late TextEditingController contactController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: myProfileController.myProfileData['user_data']["name"]);
    contactController = TextEditingController(text: myProfileController.myProfileData['user_data']["mobile_number"].toString());
  }

  Future<void> addCustomerEnquiry() async {
    showLoadingDialog();
    final String name = nameController.text.trim();
    final String contact = contactController.text.trim();
    final String enquiry = _enquiryEditingController.text.trim();
  //  final String userId = Get.find<MyProfileController>().userId.value;

    if (name.isEmpty || contact.isEmpty || enquiry.isEmpty) {
      Get.snackbar("Error", "All fields are necessary",
          snackPosition: SnackPosition.BOTTOM);
      hideLoadingDialog();
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    try {
      final response = await HttpHandler.postHttpMethod(
        url: APIShortsString.add_customer_enquiry,
        data: {
          "customer_auto_id": Get.find<MyProfileController>().userId.value,
          'customer_name': name,
          'customer_contact': contact,
          'message': enquiry,
          'product_id': widget.productId,
          'otherUserId' :widget.otherUserId
        },
      );

      log(Get.find<MyProfileController>().userId.value.toString());
      print('response $response');

      setState(() {
        isSubmitting = false;
      });
      if (response['error'] == null) {
        hideLoadingDialog();
        if (response['body']['status'].toString() == "1") {
          hideLoadingDialog();
          Fluttertoast.showToast(msg: 'Enquiry submitted successfully');
          Get.back();
        } else {
          hideLoadingDialog();
          Fluttertoast.showToast(msg: 'Failed to submit enquiry');
        }
      }
    } catch (e) {
      hideLoadingDialog();
      setState(() {
        isSubmitting = false;
      });
      hideLoadingDialog();
      Fluttertoast.showToast(msg: 'Error Occurred:');

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        titleName: AppString.addEnquiry,

      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 15),
              CommonTextField(
                  prefixIcon: Icon(Icons.person),
                  controller: nameController,
                  hintText: "Full Name"),
              const SizedBox(height: 15),
              CommonTextField(
                  prefixIcon: Icon(Icons.call),
                  controller: contactController,
                  isPhoneValidation: true,
                  maxLength: 10,
                  hintText: "Contact"),
              const SizedBox(height: 15),
              CommonTextField(
                  maxLine: 10,
                  controller: _enquiryEditingController,
                  hintText: "Enquiry data"),
              const SizedBox(height: 25),
              ElevatedButton(
                // onPressed: () {
                //   if (_NameController != "" &&
                //       _ContactEditingController != "" &&
                //       _enquiryEditingController != "") {
                //     addCustomerEnquiry();
                //     Get.back();
                //   } else {
                //     print("all fields necessary");
                //   }
                // },
                onPressed: addCustomerEnquiry,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(150, 50),
                  backgroundColor: Colors.blue,
                  shape: const StadiumBorder(),
                  shadowColor: Colors.grey,
                  elevation: 5,
                ),
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }


}
