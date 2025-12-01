import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:real_estate_app/global/services/api_shorts_string.dart';

import '../../../global/services/network_http.dart';
import '../../../global/widgets/loading_dialog.dart';
import '../../../utils/common_snackbar.dart';
import '../../shorts/controller/my_profile_controller.dart';

class AllProductsController extends GetxController {

  RxInt selectedCategory = 0.obs;
  RxString selectedCategoryId = "".obs;
  RxInt selectedMaterial = 0.obs;
  RxInt selectedUnit = 0.obs;

  ///add product variables
  TextEditingController productName = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController highlights = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController productWeight = TextEditingController();
  TextEditingController colorName = TextEditingController();
  TextEditingController productSize = TextEditingController();
  TextEditingController productPrice = TextEditingController();
  TextEditingController time = TextEditingController();
  List<String> timeUnitItems = ['Min', 'Hrs', 'Days', 'Week', 'Month'];
  RxString timeType = "Min".obs;
  TextEditingController expiryDate = TextEditingController();
  TextEditingController availableStock = TextEditingController();
  TextEditingController stockAlertLimit = TextEditingController();
  TextEditingController productWidth = TextEditingController();
  TextEditingController productHeight = TextEditingController();
    TextEditingController returnController = TextEditingController();
    TextEditingController exchangeController = TextEditingController();


  addProduct({
    String? categoryId,String? materialId,
    String? currencyId,String? countryProductPriceId,
    String? pincodeId,
    String? productUnitId,String? discountId,
    var imageList,
  }) async {
    try {
      showLoadingDialog();
      Get.focusScope!.unfocus();
      var response = await HttpHandler.formDataMethod(
        url: APIShortsString.add_product,
        apiMethod: "POST",
        body: {
          "user_id":  Get.find<MyProfileController>().userId.value,
          "category_id": categoryId!,
          'product_name':productName.text,
          "product_price":productPrice.text,
          'description':description.text??'',
          'highlights':highlights.text??'',
          'city':cityController.text??'',
          'weight':'',
          'color_name':'',
          'color_image':'',
          'color_name_visible':'',
          'product_dimensions':'',
          'product_image':'',
          'product_image_id':'',
          'size':'',
          // 'time':time.text??'',
          'time':'',
          'isExchange':"no",
          'exchange_time':"",
          'isReturn':"no",
          'return_time':"",
          'time_unit':'',
          'available_stock':'',
          'stock_alert_limit':'',
          'Width':'',
          'height':'',
          'material_id':'',
          'currency_id':currencyId??'',
          'country_product_price_id':countryProductPriceId??"",
          'pincode_id':pincodeId??'',
          'product_unit_id':productUnitId!??'',
          'discount_id':discountId??'',
        },
      );

      hideLoadingDialog();
      if (response['error'] == null) {

        if(response['body']['status'].toString()=="1"){
          // showSnackbar(message: response['body']['msg'].toString());
          // Get.close(3);
          print("response['body']['status'].toString()   ${response['body']['status'].toString()}");
          print("response['body']   ${response['body']}");
          addProductImage(productId: response['body']['product_auto_id'],productImage: imageList);
          clearFields();

        }
        else if(response['body']['status'].toString()=="0") {
          showSnackbar(message: response['body']['msg'].toString());
        }
      } else if (response['error'] != null) {}

    } catch (e, s) {
      debugPrint("upload_video Error -- $e  $s");
    }
  }


  addProductImage({String? productId,List<File>? productImage}) async {
    //uploadReel()
    try {
      showLoadingDialog();
      Get.focusScope!.unfocus();
      if(productImage!.isNotEmpty){
      for (int index = 0; index < productImage.length; index++) {
        XFile? xFileImage;
        if( productImage[index] != null){
          xFileImage =  XFile(productImage[index].path);
        }
        var response = await HttpHandler.formDataMethod(
          url: APIShortsString.add_product_image,
          apiMethod: "POST",
          body: {
            "user_id":  Get.find<MyProfileController>().userId.value,
            "product_id": productId!,
          },
          imagePath: xFileImage!.path,
          imageKey: "product_images",
        );

        hideLoadingDialog();
        if (response['error'] == null) {

          if(response['body']['status'].toString()=="1"){
            print("add_product_image ==> status  ${response['body']['status'].toString()}");
            // showSnackbar(message: response['body']['msg'].toString());
            // Get.close(2);
            Get.close(3);
          }
          else if(response['body']['status'].toString()=="0") {
            print("add_product_image ==> status  ${response['body']['status'].toString()}");
            // showSnackbar(message: response['body']['msg'].toString());
          }
        } else if (response['error'] != null) {}
      }}


    } catch (e, s) {
      debugPrint("addProductImage Error -- $e  $s");
    }
  }

  RxList productsList = [].obs;
  RxBool isMoreProductsLoading = false.obs;
  RxInt currentProductsPage = 1.obs;
  RxInt lastProductsPage = 0.obs;
  RxInt nextProductsPage = 1.obs;

  Future getProductsApi({int? pageNo, int? count,bool isShowMore = false}) async {
    try {
      if(isShowMore == false) {
        showLoadingDialog();
      }else{
        isMoreProductsLoading.value = true;
      }
      var response = await HttpHandler.postHttpMethod(
          url: APIShortsString.get_product,
          data: {
            "user_id":Get.find<MyProfileController>().userId.value,
            "page_no":pageNo,
            "count":10,
          });
      log("getProductsApi  :: body  :: ${{
        "user_id":Get.find<MyProfileController>().userId.value,
        "page_no":pageNo,
        "count":10,
      }}");
      log("getProductsApi  :: response  :: ${response["body"]}");


      if(isShowMore == false) {
        hideLoadingDialog();
      }else{
        isMoreProductsLoading.value = false;
      }
      if (response['error'] == null) {

        if(response['body']['status'].toString()=="1"){

          currentProductsPage.value = response['body']["current_page"];
          nextProductsPage.value = currentProductsPage.value + 1;
          print("response['body'][last_page]  ${response['body']["total"]}");
          // lastProductsPage.value =  response['body']["last_page"];
          lastProductsPage.value =  response['body']["total"];

          if(isShowMore == false){
            productsList.value = response['body']["data"];
          }
          else{
            response['body']["data"].forEach((e) {
              print("dataaaaa----- $e");
              productsList.add(e);
            });
          }
        }
        else if(response['body']['status'].toString()=="0") {

          showSnackbar(message: response['body']['msg']);
        }
      } else if (response['error'] != null) {}
    }
    catch (e, s) {
      hideLoadingDialog();
      debugPrint("getSizeApi Error -- $e  $s");
    }
  }

  Future deleteProductApi({String? productId}) async {
    try {
      showLoadingDialog();
      var response = await HttpHandler.postHttpMethod(
          url: APIShortsString.delete_product,
          data: {
            "product_id":productId,
          });

      log("deleteproductApi  :: response  :: ${response["body"]}");

      hideLoadingDialog();
      if (response['error'] == null) {

        if(response['body']['status'].toString()=="1"){
          getProductsApi(count: 10, pageNo: 1);
        }
        else if(response['body']['status'].toString()=="0") {

          showSnackbar(message: response['body']['msg']);
        }
      } else if (response['error'] != null) {}
    }
    catch (e, s) {
      hideLoadingDialog();
      debugPrint("deleteMaterialApi Error -- $e  $s");
    }
  }


  clearFields(){
    productName.clear();
    description.clear();
    highlights.clear();
    productWeight.clear();
    colorName.clear();
    productSize.clear();
    productPrice.clear();
    time.clear();
    expiryDate.clear();
    availableStock.clear();
    productWidth.clear();
    productHeight.clear();
    stockAlertLimit.clear();
  }


  editProduct({
    String? productId,
    String? categoryId,String? materialId,
    String? currencyId,String? countryProductPriceId,
    String? pincodeId,
    String? productUnitId,String? discountId,
    // var imageList,
  }) async {
    try {
      print("Get.find<MyProfileController>().userId.value   ${Get.find<MyProfileController>().userId.value}");
      showLoadingDialog();
      Get.focusScope!.unfocus();
      var response = await HttpHandler.formDataMethod(
        url: APIShortsString.update_product,
        apiMethod: "POST",
        body: {
          "user_id":  Get.find<MyProfileController>().userId.value,
          "product_id":  productId!,
          "category_id": categoryId!,
          'product_name':productName.text,
          'description':description.text??'',
          'product_price': productPrice.text??'',
          'highlights':highlights.text??'',
          'city':cityController.text??'',
          'weight':productWeight.text??'',
          'color_name':colorName.text??'',
          'color_image':'',
          'color_name_visible':'',
          'product_dimensions':'',
          'product_image':'',
          'product_image_id':'',
          'size':productSize.text??'',
          'time':time.text.isEmpty ?"":time.text,
          'isExchange':exchangeController.text.isEmpty ?"no":"yes",
          'exchange_time':exchangeController.text.isEmpty ?"":exchangeController.text,
          'isReturn':returnController.text.isEmpty ?"no":"yes",
          'return_time':returnController.text.isEmpty ?"":returnController.text,
          'time_unit':timeType.value,
          'available_stock':availableStock.text??'',
          'stock_alert_limit':stockAlertLimit.text??'',
          'Width':productWidth.text??'',
          'height':productHeight.text??'',
          'material_id':'',
          'currency_id':'',
          'country_product_price_id':"",
          'pincode_id':'',
          'product_unit_id':'',
          'discount_id':'',
        },
      );
      hideLoadingDialog();
      if (response['error'] == null) {

        if(response['body']['status'].toString()=="1"){
          Get.back();
          print("response['body']['status'].toString()   ${response['body']['status'].toString()}");
          print("response['body']   ${response['body']}");
          clearFields();
          getProductsApi(count: 10,pageNo: 1,isShowMore: false);

        }
        else if(response['body']['status'].toString()=="0") {
          showSnackbar(message: response['body']['msg'].toString());
        }
      } else if (response['error'] != null) {}

    } catch (e, s) {
      debugPrint("upload_video Error -- $e  $s");
    }
  }


}
