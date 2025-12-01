// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, camel_case_types, library_private_types_in_public_api, no_logic_in_create_state, must_be_immutable, unnecessary_null_comparison, avoid_function_literals_in_foreach_calls, file_names, unrelated_type_equality_checks, depend_on_referenced_packages

import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:real_estate_app/global/services/api_shorts_string.dart';

import '../../../../common_widgets/height.dart';
import '../../../../global/app_color.dart';
import '../../../../global/theme/app_text_style.dart';
import '../../../../global/widgets/common_textfield.dart';
import '../../../../utils/validation/validator.dart';
import '../../../shorts/controller/my_profile_controller.dart';
import '../../controller/all_products_controller.dart';

class UpdateProductScreen extends StatefulWidget {
  // String? categoryId;
  int? index;

  UpdateProductScreen({super.key, /*this.categoryId,*/ this.index});

  @override
  _UpdateProductScreenState createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {
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
    /*allProductsController.*/
    setEditFieldsData(widget.index);
  }

  setEditFieldsData(index) {
    print("editProduct==>");

    var data = allProductsController.productsList[index];
    print("data['user_id']   ===>  $data");

    Get.find<MyProfileController>().userId.value = data['user_id'];
    // categoryId = data['category_id'];
    allProductsController.productName.text = data['product_name'];
    allProductsController.productPrice.text = data['product_price'];
    allProductsController.description.text = data['description'];
    allProductsController.highlights.text = data['highlights'];

    allProductsController.cityController.text = data['city']??"";
    print('allProductsController.cityController.text==>${data['city']}');
    allProductsController.productWeight.text = data['weight'];
    allProductsController.colorName.text = data['color_name'];
    allProductsController.productSize.text = data['size'];
    allProductsController.time.text = data['time'];
    allProductsController.timeType.value =
        data["time_unit"].toString().capitalize!;
    print(
        "allProductsController.timeType.value   ${allProductsController.timeType.value}");
    allProductsController.exchangeController.text = data['isExchange'];
    allProductsController.exchangeController.text = data['exchange_time'];
    allProductsController.returnController.text = data['isReturn'];
    allProductsController.returnController.text = data['return_time'];
    allProductsController.availableStock.text = data['available_stock'].toString();
    allProductsController.productWidth.text = data['Width'];
    allProductsController.productHeight.text = data['height'];
    // materialId = data['material_id'];
    // currencyId  = data['currency_id'];
    // countryProductPriceId = data['country_product_price_id'];
    // pincodeId  = data['pincode_id'];
    // productUnitId = data['product_unit_id'];
    // discountId  = data['discount_id'];
    setState(() {});
  }

  @override
  // bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.white,
        title: Text("Update Property",
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
                    bottomPadding: 8,
                    controller: allProductsController.productName,
                    title: 'Property Name',
                    hintText: 'Enter the Property name',
                  ),
                  CommonTextField(
                    bottomPadding: 8,
                    controller: allProductsController.productPrice,
                    textInputType: const TextInputType.numberWithOptions(),
                    title: 'Property Price',
                    hintText: 'Enter Property Price',
                    inputFormatters: [DigitDotInputFormatter()],
                  ),
                  CommonTextField(
                    bottomPadding: 8,
                    controller: allProductsController.description,
                    title: 'Property Description',
                    hintText: 'Enter the Property Description',
                  ),
                  CommonTextField(
                    bottomPadding: 8,
                    controller: allProductsController.highlights,
                    title: 'Property Highlights',
                    hintText: 'Enter the Property Highlights',
                  ),
                  CommonTextField(
                    bottomPadding: 8,
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
                                  allProductsController.editProduct(
                                    productId: allProductsController.productsList[widget.index!]["_id"],
                                    categoryId: allProductsController.productsList[widget.index!]["category_id"],
                                  );
                                }
                              },
                              child: Center(
                                child: Text('Update Property',
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

    for (int index = 0;
        // index < productImages.length;
        index <
            allProductsController
                .productsList[widget.index!]['product_image'].length;
        index++) {
      items.add(SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 450,
        child: CachedNetworkImage(
          fit: BoxFit.contain,
          imageUrl:
              "${APIShortsString.products_image}${allProductsController.productsList[widget.index!]['product_image'][index]["product_images"]}",
          placeholder: (context, url) => Container(
              decoration: BoxDecoration(
            color: Colors.grey[400],
          )),
          errorWidget: (context, url, error) => const Icon(Icons.image_rounded),
        ),
      ));
      // items.add(SizedBox(
      //     width: MediaQuery
      //         .of(context)
      //         .size
      //         .width,
      //     height: 400,
      //     child: ClipRRect(
      //       child: productImages[index] != null
      //           ? Image.file(
      //         productImages[index],
      //         // fit: BoxFit.fill,
      //       )
      //           : Container(
      //           decoration: BoxDecoration(
      //             borderRadius: BorderRadius.circular(5),
      //             color: Colors.grey[200],
      //           )),
      //     )));
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
              // productImages.isEmpty
              allProductsController
                      .productsList[widget.index!]['product_image'].isEmpty
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
              allProductsController
                      .productsList[widget.index!]['product_image'].isNotEmpty
                  ? const SizedBox()
                  : Container(
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
    if (allProductsController.productsList[widget.index!]["_id"] == null ||
        allProductsController.productsList[widget.index!]["_id"].isEmpty) {
      Fluttertoast.showToast(
        msg: "Unknown Error",
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
