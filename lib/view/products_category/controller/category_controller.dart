import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/global/services/api_shorts_string.dart';

import '../../../global/services/network_http.dart';
import '../../../global/widgets/loading_dialog.dart';
import '../../../utils/common_snackbar.dart';
import '../../shorts/controller/my_profile_controller.dart';

class CategoryController extends GetxController{
  
  final categoryNameController = TextEditingController();

  RxList categories = [].obs;
  RxBool isMoreDataLoading = false.obs;
  RxInt currentCategoryPage = 1.obs;
  RxInt lastCategoryPage = 0.obs;
  RxInt nextCategoryPage = 1.obs;

  Future addCategoryApi({String? categoryName,}) async {
    try {
      showLoadingDialog();
      var response = await HttpHandler.postHttpMethod(
          url: APIShortsString.add_cateory,
          data: {
            "user_id":Get.find<MyProfileController>().userId.value,
            "category_name":categoryName,
          });

      log("addCategoryApi  :: response  :: ${response["body"]}");

      hideLoadingDialog();
      if (response['error'] == null) {

        if(response['body']['status'].toString()=="1"){
          categoryNameController.clear();
          getCategoryApi(count: 10, pageNo: 1);
        }
        else if(response['body']['status'].toString()=="0") {

          showSnackbar(message: response['body']['msg']);
        }
        // if (response['body']['status'].toString() == "1") {}
      } else if (response['error'] != null) {}
    }
    catch (e, s) {
      hideLoadingDialog();
      debugPrint("addCategoryApi Error -- $e  $s");
    }
  }

  Future updateCategoryApi({String? categoryId,String? categoryName,}) async {
    try {
      showLoadingDialog();
      var response = await HttpHandler.postHttpMethod(
          url: APIShortsString.edit_category,
          data: {
            "user_id": Get.find<MyProfileController>().userId.value,
            "category_id": categoryId,
            "category_name": categoryName,
          });

      log("updateCategoryApi  :: response  :: ${response["body"]}");

      hideLoadingDialog();
      if (response['error'] == null) {

        if(response['body']['status'].toString()=="1"){
          getCategoryApi(count: 10, pageNo: 1);
        }
        else if(response['body']['status'].toString()=="0") {

          showSnackbar(message: response['body']['msg']);
        }
      } else if (response['error'] != null) {}
    }
    catch (e, s) {
      hideLoadingDialog();
      debugPrint("updateCategoryApi Error -- $e  $s");
    }
  }

  Future deleteCategoryApi({String? categoryId}) async {
    try {
      showLoadingDialog();
      var response = await HttpHandler.postHttpMethod(
          url: APIShortsString.delete_category,
          data: {
            "user_id":Get.find<MyProfileController>().userId.value,
            "category_id":categoryId,
          });

      log("deleteCategoryApi  :: response  :: ${response["body"]}");

      hideLoadingDialog();
      if (response['error'] == null) {

        if(response['body']['status'].toString()=="1"){
          getCategoryApi(count: 10, pageNo: 1);
        }
        else if(response['body']['status'].toString()=="0") {

          showSnackbar(message: response['body']['msg']);
        }
        // if (response['body']['status'].toString() == "1") {}
      } else if (response['error'] != null) {}
    }
    catch (e, s) {
      hideLoadingDialog();
      debugPrint("deleteCategoryApi Error -- $e  $s");
    }
  }

  Future getCategoryApi({int? pageNo, int? count,bool isShowMore = false}) async {
    try {
     if(isShowMore == false) {
        showLoadingDialog();
      }else{
       isMoreDataLoading.value = true;
     }
      var response = await HttpHandler.postHttpMethod(
          url: APIShortsString.get_categories,
          data: {
            "user_id":Get.find<MyProfileController>().userId.value,
            "page_no":pageNo,
            "count":10,
          });

      log("getCategoryApi  :: response  :: ${response["body"]}");

     if(isShowMore == false) {
        hideLoadingDialog();
      }else{
       isMoreDataLoading.value = false;
     }
      if (response['error'] == null) {

        if(response['body']['status'].toString()=="1"){

          currentCategoryPage.value = response['body']["current_page"];
          nextCategoryPage.value = currentCategoryPage.value + 1;
          lastCategoryPage.value =  response['body']["last_page"];

         if(isShowMore == false){
           categories.value = response['body']["data"];
         }
         else{
           response['body']["data"].forEach((e) {
             print("dataaaaa----- $e");
             categories.add(e);
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
      debugPrint("getCategoryApi Error -- $e  $s");
    }
  }

}