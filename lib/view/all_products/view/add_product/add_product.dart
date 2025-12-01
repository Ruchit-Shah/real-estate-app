// ignore_for_file: use_build_context_synchronously,
// non_constant_identifier_names, camel_case_types,
// library_private_types_in_public_api, no_logic_in_create_state,
// must_be_immutable, unnecessary_null_comparison, avoid_function_literals_in_foreach_calls,
// file_names, unrelated_type_equality_checks, depend_on_referenced_packages

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../common_widgets/height.dart';
import '../../../../global/app_color.dart';
import '../../../../global/theme/app_text_style.dart';
import '../../../../global/widgets/common_textfield.dart';
import '../../../../utils/validation/validator.dart';
import '../../controller/all_products_controller.dart';

class AddProductScreen extends StatefulWidget {
  String? categoryId;
  AddProductScreen({super.key, this.categoryId});

  @override _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  AllProductsController allProductsController =
      Get.find<AllProductsController>();

  List<File>? imageFileList;
  List<String> selectedSize = [];

  List<String> Unit_list = [
    'Select Unit',
  ];
  List product_info_model_List = [];
  bool isApiCallProcessing = false;

  showAlert() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
          backgroundColor: Colors.yellow[50],
          title: Text('Are you sure?', style: AppTextStyle.regular),
          content: Wrap(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text('Do you want to discard your data',
                      style: AppTextStyle.regular),
                  boxH10(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[200],
                          minimumSize: const Size(70, 30),
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(2.0)),
                          ),
                        ),
                        child: Text("Yes",
                            style: AppTextStyle.regular
                                .copyWith(color: AppColor.black, fontSize: 13)),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[200],
                          minimumSize: const Size(70, 30),
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(2.0)),
                          ),
                        ),
                        child: Text("No",
                            style: AppTextStyle.regular
                                .copyWith(color: AppColor.black, fontSize: 13)),
                      ),
                    ],
                  )
                ],
              )
            ],
          )),
    );
  }

  @override
  void initState() {
    super.initState();

  }

  @override
  // bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.white,
        title: Text("Add Property",
            style: AppTextStyle.bold
                .copyWith(color: AppColor.black, fontSize: 18)),
        leading: IconButton(
          onPressed: () {
            showAlert();
          },
          icon: const Icon(Icons.arrow_back, color: AppColor.black),
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  productImageUi(),
                  CommonTextField(
                    bottomPadding: 12,
                    controller: allProductsController.productName,
                    title: 'Property Name',
                    hintText: 'Enter the Property name',
                  ),
                  CommonTextField(
                    bottomPadding: 12,
                    controller: allProductsController.productPrice,
                    title: 'Property Price',
                    hintText: 'Enter Property Price',
                    textInputType: const TextInputType.numberWithOptions(),
                    inputFormatters: [DigitDotInputFormatter()],
                  ),
                  CommonTextField(
                    bottomPadding: 12,
                    controller: allProductsController.description,
                    title: 'Property Description',
                    hintText: 'Enter the Property Description',
                  ),
                  CommonTextField(
                    bottomPadding: 12,
                    controller: allProductsController.highlights,
                    title: 'Property Highlights',
                    hintText: 'Enter the Property Highlights',
                  ),
                  CommonTextField(
                    bottomPadding: 12,
                    controller: allProductsController.cityController,
                    title: 'City Name',
                    hintText: 'Enter the City Name',
                  ),

                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: isApiCallProcessing == true
                        ? Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            child: const GFLoader(type: GFLoaderType.circle),
                          )
                        : SizedBox(
                            height: 40,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColor.orange,
                                  textStyle: AppTextStyle.regular
                                      .copyWith(fontSize: 20)),
                              onPressed: () {
                                if (validations() == true) {
                                  // add_product(i);
                                  allProductsController.addProduct(
                                      categoryId: widget.categoryId,
                                      materialId: "",
                                      productUnitId: "",
                                      imageList: productImages);
                                }
                              },
                              child: Center(
                                child: Text('Add Property',
                                    style: AppTextStyle.regular.copyWith(
                                        color: AppColor.white, fontSize: 16)),
                              ),
                            ),
                          ),
                  )
                ],
              ),
            ),
          )),
    );
  }

  List<File> productImages = [];

  Future<void> addMoreImagesProduct() async {
    ImagePicker imagePicker = ImagePicker();
    // List<File>? imageFileList = [];
    var selectedImages = await imagePicker.pickMultiImage();

    if (selectedImages != null) {
      for (var file in selectedImages) {
        File selectedImg = File(file.path);
        // product_info_model_List[i].productImages.add(selectedImg);
        productImages.add(selectedImg);
      }
      setState(() {});
    }
  }

  List<Widget> sliderItems() {
    List<Widget> items = [];

    for (int index = 0; index < productImages.length; index++) {
      items.add(SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 400,
          child: ClipRRect(
            child: productImages[index] != null
                ? Image.file(
                    productImages[index],
                    // fit: BoxFit.fill,
                  )
                : Container(
                    decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.grey[200],
                  )),
          )));
    }

    return items;
  }

  productImageUi() {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 400,
          child: Stack(
            children: <Widget>[
              productImages.isEmpty
                  ? Container(
                      color: Colors.grey.shade200,
                      child: const Center(child: Text("select image")),
                    )
                  : ImageSlideshow(
                      width: MediaQuery.of(context).size.width,
                      height: 400,
                      initialPage: 0,
                      indicatorColor: Colors.blue,
                      indicatorBackgroundColor: Colors.grey,
                      onPageChanged: (value) {
                        //print('Page changed: $value');
                      },
                      autoPlayInterval: null,
                      isLoop: true,
                      children: sliderItems(),
                    ),
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.bottomRight,
                child: Container(
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.black54),
                  child: IconButton(
                    onPressed: () => {addMoreImagesProduct()},
                    icon: const Icon(
                      Icons.library_add_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        Divider(color: Colors.grey.shade300),
      ],
    );
  }


  bool validations() {
    if (productImages.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please add product image",
        backgroundColor: Colors.grey,
      );
      return false;
    } else if (allProductsController
        .productName.text.removeAllWhitespace.isEmpty) {
      Fluttertoast.showToast(
        msg: "Enter the product name",
        backgroundColor: Colors.grey,
      );
      return false;
    } else if (allProductsController
        .productPrice.text.removeAllWhitespace.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please add product price",
        backgroundColor: Colors.grey,
      );
      return false;
    }
    return true;
  }
}

productAddedAlert() {
  return showDialog(
    context: Get.context!,
    builder: (context) => AlertDialog(
        backgroundColor: Colors.yellow[50],
        title: Text('Property added', style: AppTextStyle.regular),
        content: Wrap(
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(
                    'You can add more for this product from edit product screen',
                    style: AppTextStyle.regular),
                boxH10(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        Get.close(2);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[200],
                        minimumSize: const Size(70, 30),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(2.0)),
                        ),
                      ),
                      child: Text("Ok",
                          style: AppTextStyle.regular.copyWith(fontSize: 13)),
                    ),
                    boxW10(),
                  ],
                )
              ],
            )
          ],
        )),
  );
}
