import 'dart:developer';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:real_estate_app/common_widgets/custom_textformfield.dart';
import 'package:real_estate_app/common_widgets/height.dart';
import 'package:real_estate_app/global/AppBar.dart';
import 'package:real_estate_app/global/app_color.dart';
import 'package:real_estate_app/global/constant.dart';
import 'package:real_estate_app/view/top_developer/top_developer_controller.dart';

import '../dashboard/bottom_navbar_screens/profile_screen/profile_controller.dart';
import '../dashboard/bottom_navbar_screens/profile_screen/profile_screen.dart';



class add_topDeveloper extends StatefulWidget {
  const add_topDeveloper({Key? key}) : super(key: key);

  @override
  State<add_topDeveloper> createState() =>
      _add_topDeveloperState();
}

class _add_topDeveloperState extends State<add_topDeveloper> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  top_developer_controller controller = Get.put(top_developer_controller());

  @override
  void initState() {
    super.initState();

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        titleName: "Mark as Developer",
        automaticallyImplyLeading: false,
        onTap: () {
          Navigator.pop(context);
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                      () => InkWell(
                    onTap: () {
                      controller.iconImg = null;
                      controller.isIconSelected.value = false;
                      showImageDialog();
                    },
                    child: controller.isIconSelected.value
                        ? Image.file(
                      File(controller.iconImg!.path),
                      width: double.infinity,
                      height: 100,
                      fit: BoxFit.fitWidth,
                    )
                        : DottedBorder(
                      color: AppColor.grey,
                      strokeWidth: 1,
                      dashPattern: [8, 4],
                      child: Container(
                        padding: EdgeInsets.all(16),
                        width: double.infinity,
                        height: 100,
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_a_photo, size: 25, color: Colors.grey),
                            SizedBox(height: 2),
                            Text(
                              'Tap to add property cover images',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                boxH15(),
                const Text(
                  'Enter Name',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                ),
                boxH05(),
                CustomTextFormField(
                  labelText: 'Enter developer name',
                  keyboardType: TextInputType.text,
                  controller: controller.developerController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                boxH15(),
                const Text(
                  'Designation',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                ),
                boxH10(),
                CustomTextFormField(
                  labelText: 'Enter your designation',
                  keyboardType: TextInputType.text,
                  controller: controller.designationController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your designation';
                    }
                    return null;
                  },
                ),
                boxH15(),
                const Text(
                  'Address',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                ),
                boxH10(),
                CustomTextFormField(
                  labelText: 'Enter your Address',
                  keyboardType: TextInputType.text,
                  controller: controller.addressController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your address';
                    }
                    return null;
                  },
                ),
                boxH30(),
                Center(
                  child: ElevatedButton(
                    onPressed: () {

                      if (_formKey.currentState!.validate() && controller.iconImg!=null) {
                        controller.addDeveloper(
                          name: controller.developerController.text,
                          designation: controller.designationController.text,
                          add: controller.addressController.text,
                          image: controller.iconImg,
                        ).then((value) {
                          Get.to(ProfileScreen());
                        });
                      } else {
                        Fluttertoast.showToast(
                          msg: 'Please fill all required fields',
                        );
                      }

                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text(
                      'Submit',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
  showImageDialog() async {
    return showDialog(
      // context: Get.context!,
      context: Get.context!,
      builder: (context) => AlertDialog(
          backgroundColor: Colors.white,
          content: SizedBox(
            height: 100,
            child: Column(
              children: <Widget>[
                const Text(
                  "Choose Photo",
                  style: TextStyle(
                    fontSize: 15.0,
                  ),
                ),
                Divider(),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextButton.icon(
                        onPressed: () {
                          getCameraImage();
                        },
                        icon: const Icon(
                          Icons.camera,
                          color: Colors.black54,
                          size: 15,
                        ),
                        label: const Text("Camera",
                            style: TextStyle(
                                color: Colors.black54, fontSize: 15))),
                    TextButton.icon(
                        onPressed: () {
                          getGalleryImage();
                        },
                        icon: const Icon(
                          Icons.image,
                          color: Colors.black54,
                          size: 15,
                        ),
                        label: const Text("Gallery",
                            style: TextStyle(
                                color: Colors.black54, fontSize: 15))),
                  ],
                )
              ],
            ),
          )),
    );
  }
  final ImagePicker picker = ImagePicker();
  Future getCameraImage() async {
    try {
      Navigator.of(Get.context!).pop(false);
      XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);
      // var pickedFile = await picker.pickImage(source: ImageSource.camera,imageQuality: 20);

      if (pickedFile != null) {
        controller.pickedImageFile = pickedFile;

        File selectedImg = File(controller.pickedImageFile.path);

        cropImage(selectedImg);
      }
    } on Exception catch (e) {
      log("$e");
    }
  }
  Future getGalleryImage() async {
    Navigator.of(Get.context!).pop(false);
    var pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      controller.pickedImageFile = pickedFile;

      File selectedImg = File(controller.pickedImageFile.path);

      cropImage(selectedImg);
    }
  }
  cropImage(File icon) async {
    CroppedFile? croppedFile = (await ImageCropper()
        .cropImage(sourcePath: icon.path, aspectRatioPresets: [
      CropAspectRatioPreset.square,
      CropAspectRatioPreset.ratio3x2,
      CropAspectRatioPreset.original,
      CropAspectRatioPreset.ratio4x3,
      CropAspectRatioPreset.ratio16x9
    ], uiSettings: [
      AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
      IOSUiSettings(
        title: 'Cropper',
      ),
    ]));
    if (croppedFile != null) {
      controller.iconImg = File(croppedFile.path);
      controller.isIconSelected.value = true;

    }
  }
}
