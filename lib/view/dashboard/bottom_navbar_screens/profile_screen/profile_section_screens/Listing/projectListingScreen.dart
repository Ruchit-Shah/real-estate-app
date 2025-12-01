import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:real_estate_app/Routes/app_pages.dart';
import 'package:real_estate_app/common_widgets/height.dart';
import 'package:real_estate_app/global/app_color.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/profile_screen/profile_section_screens/Listing/LeadsPage.dart';
import 'package:real_estate_app/view/property_screens/property_details_screen/property_details_screenTest.dart';

import '../../../../../../common_widgets/custom_textformfield.dart';
import '../../../../../../global/api_string.dart';
import '../../../../../../utils/String_constant.dart';
import '../../../../../../utils/shared_preferences/shared_preferances.dart';
import '../../../../../property_screens/post_property_screen/edit_property_screen.dart';
import '../../../../../property_screens/properties_controllers/post_property_controller.dart';
import '../../../../../property_screens/recommended_properties_screen/properties_details_screen.dart';
import '../../profile_controller.dart';


class ProjectListing extends StatefulWidget {
  const ProjectListing({super.key});

  @override
  State<ProjectListing> createState() => _ProjectListingState();
}

class _ProjectListingState extends State<ProjectListing> {
  String  isOffer='';
  PostPropertyController controller = Get.put(PostPropertyController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.getUpcomingProjects();
    getData();
  }
  getData() async {
    String  Project= (await SPManager.instance.getUpcomingProjects(UpcomingProjects))??"no";

    int? projectCount= (await SPManager.instance.getProjectCount(PAID_PROJECT))??0;

    int? projectPlanCount= (await SPManager.instance.getPlanProjectCount(PLAN_PROJECT))??0;

    print('project-->');
    print(Project);

    print(projectCount);

    print(projectPlanCount);


    if(Project=='no'){
      setState(() {
        isOffer ='no';
      });
    }else{
      if(projectCount < projectPlanCount){
        setState(() {
          isOffer ='yes';
        });
      }else {
        setState(() {
          isOffer ='no_limit';
        });
      }
    }
    ///



  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(height: 5,),
            isOffer=='no_limit'?
            const Text(
              "You have exceeded the limit for posting upcoming project under your current plan. "
                  "To continue using this feature, please consider upgrading or "
                  "updating your plan.",
              style: TextStyle(
                color: Colors.red,
                fontSize: 14,
              ),
            ):
            InkWell(
              onTap: (){
                controller.iconImg = null;
                controller.isIconSelected.value = false;
                addUpcomingPoject(context);
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('+ Add New Upcoming Project',style: TextStyle(color: Colors.blueGrey,fontSize: 15,fontWeight: FontWeight.bold),),
                  Icon(Icons.add_circle_outline,size: 20,color: Colors.blueGrey,)
                ],
              ),
            ),
            SizedBox(height: 5,),
            Divider(),
            SizedBox(height: 5,),

            // Expanded(
            //   child: Obx(
            //         () =>  ListView.builder(
            //       scrollDirection: Axis.vertical,
            //       itemCount: controller.getUpcomingProject.length,
            //       itemBuilder: (context, index) {
            //         return GestureDetector(
            //           onTap: (){
            //
            //           },
            //           child:Padding(
            //             padding: const EdgeInsets.symmetric(vertical: 8.0),
            //             child: Container(
            //               decoration: BoxDecoration(
            //                 color: AppColor.grey.shade50,
            //                 borderRadius: const BorderRadius.all(Radius.circular(10)),
            //                 border: Border.all(color: AppColor.grey.withOpacity(0.2)),
            //               ),
            //               child: Padding(
            //                 padding: const EdgeInsets.all(8.0),
            //                 child: Column(
            //                   children: [
            //                     Row(
            //                       children: [
            //                         Text(
            //                           'ID: ${100935}',
            //                           style: TextStyle(fontSize: 15, color: Colors.black.withOpacity(0.8),),
            //                         ),
            //                         const Spacer(),
            //                         InkWell(
            //                             onTap: () {
            //                               showDeleteConfirmationDialog(context, controller.getUpcomingProject[index]['_id']);
            //                             },
            //                             child: Icon(Icons.delete, color: Colors.red.shade300, size: 20)),
            //                         boxW08(),
            //                         // InkWell(
            //                         //     onTap: () {
            //                         //       Get.to(edit_property_screen());
            //                         //     },
            //                         //     child: Icon(Icons.edit, color: Colors.blue, size: 20)),
            //                         // boxW08(),
            //                         // Icon(Icons., color: Colors.blue, size: 20),
            //                       ],
            //                     ),
            //                     Divider(height: 17, thickness: 0.8, color: Colors.grey.shade300),
            //                     Column(
            //                       crossAxisAlignment: CrossAxisAlignment.start,
            //                       children: [
            //                         ClipRRect(
            //                           borderRadius: BorderRadius.circular(5),
            //                           child:controller.getUpcomingProject[index]['project_image'] != null
            //                               ? CachedNetworkImage(
            //                             width: Get.width,
            //                             height: 150,
            //
            //                             fit: BoxFit.cover,
            //                             imageUrl:APIString.imageBaseUrl+ controller.getUpcomingProject[index]['project_image'],
            //
            //                             placeholder: (context, url) => Container(
            //                               width: Get.width,
            //                               height: 150,
            //                               decoration: BoxDecoration(
            //                                 borderRadius: BorderRadius.circular(10),
            //                               ),
            //                             ),
            //                             errorWidget: (context, url, error) => const Icon(Icons.error),
            //                           )
            //                               : Container(
            //                             color: Colors.grey[400],
            //                             child: const Center(
            //                               child: Icon(Icons.image_rounded),
            //                             ),
            //                           ),
            //                         ),
            //
            //                         boxH10(),
            //                         Text(
            //                           controller.getUpcomingProject[index]['project_name'],
            //                           style: const TextStyle(
            //                             fontSize: 15,
            //                             color: Colors.black,
            //                             fontWeight: FontWeight.bold,
            //                           ),
            //                         ),
            //                         boxH02(),
            //                         Text(
            //                           '${controller.getUpcomingProject[index]['description']}',
            //                           style: TextStyle(fontSize: 14,  color: Colors.black),
            //                         ),
            //                       ],
            //                     ),
            //
            //                   ],
            //                 ),
            //               ),
            //             ),
            //           ),
            //         );
            //       },
            //     ),
            //   ),
            // ),
            Expanded(
              child: Obx(
                    () => controller.getUpcomingProject.isEmpty
                    ? Center(
                  child: Text(
                    'No upcoming projects found',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blueGrey,
                    ),
                  ),
                )
                    : ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: controller.getUpcomingProject.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColor.grey.shade50,
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                            border: Border.all(color: AppColor.grey.withOpacity(0.2)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    // Text(
                                    //   'ID: ${100935}',
                                    //   style: TextStyle(
                                    //     fontSize: 15,
                                    //     color: Colors.black.withOpacity(0.8),
                                    //   ),
                                    // ),
                                    const Spacer(),
                                    InkWell(
                                      onTap: () {
                                        showDeleteConfirmationDialog(context, controller.getUpcomingProject[index]['_id']);
                                      },
                                      child: Icon(Icons.delete, color: Colors.red.shade300, size: 20),
                                    ),
                                    boxW08(),
                                    // Uncomment the following lines if edit functionality is required
                                    // InkWell(
                                    //     onTap: () {
                                    //       Get.to(edit_property_screen());
                                    //     },
                                    //     child: Icon(Icons.edit, color: Colors.blue, size: 20)),
                                    // boxW08(),
                                    // Icon(Icons., color: Colors.blue, size: 20),
                                  ],
                                ),
                                Divider(height: 17, thickness: 0.8, color: Colors.grey.shade300),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: controller.getUpcomingProject[index]['project_image'] != null
                                          ? CachedNetworkImage(
                                        width: Get.width,
                                        height: 150,
                                        fit: BoxFit.cover,
                                        imageUrl: APIString.imageBaseUrl + controller.getUpcomingProject[index]['project_image'],
                                        placeholder: (context, url) => Container(
                                          width: Get.width,
                                          height: 150,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) => const Icon(Icons.error),
                                      )
                                          : Container(
                                        color: Colors.grey[400],
                                        child: const Center(
                                          child: Icon(Icons.image_rounded),
                                        ),
                                      ),
                                    ),
                                    boxH10(),
                                    Text(
                                      controller.getUpcomingProject[index]['project_name'],
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    boxH02(),
                                    Text(
                                      '${controller.getUpcomingProject[index]['description']}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            )

          ],
        ),
      ),
    );
  }

  void showDeleteConfirmationDialog(BuildContext context,String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          content: const Text("Are you sure you want to delete this project?",style: TextStyle(fontSize: 14),),
          actions: [

            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blueGrey,
                textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              child: const Text("Cancel"),
            ),

            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blueGrey,
                textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                controller.deleteUpcomingProjects(id: id);
                Navigator.of(context).pop();
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }
  void addUpcomingPoject(context) async {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    showModalBottomSheet<void>(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return GetBuilder<PostPropertyController>(
          builder: (controller) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                top: MediaQuery.of(context).viewInsets.top,
                right: 10,
                left: 10,
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        children: [
                          const Expanded(
                            child: Center(
                              child: Text(
                                "Add Project",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.cancel,
                              size: 30,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                      const Divider(thickness: 1, color: Colors.grey),
                      Center(
                        child: InkWell(
                          onTap: () {
                            showImageDialog();
                          },
                          child: Obx(
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
                                        'Tap to add Project images',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      boxH20(),
                      CustomTextFormField(
                        controller: controller.amenetiesName,
                        labelText: 'Project Name',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the offer name';
                          }
                          return null;
                        },
                      ),
                      boxH20(),
                      CustomTextFormField(
                        controller: controller.availableFromController,
                        labelText: 'Project Description',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the offer description';
                          }
                          return null;
                        },
                      ),
                      boxH20(),

                      GestureDetector(
                        onTap: () {
                          if (_formKey.currentState!.validate() && controller.iconImg!=null) {
                            controller.addUpcomingProjects(
                              name: controller.amenetiesName.value.text,
                              des: controller.availableFromController.value.text,
                              image: controller.iconImg,
                            );
                          } else {
                            Fluttertoast.showToast(
                              msg: 'Please fill all required fields',
                            );
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: AppColor.blueGrey,
                          ),
                          child: const Text(
                            'Add',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      boxH20(),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
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
