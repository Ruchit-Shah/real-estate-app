import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:real_estate_app/view/top_developer/offerList.dart';

import '../../common_widgets/loading_dart.dart';
import '../../global/api_string.dart';
import '../../utils/String_constant.dart';
import '../../utils/network_http.dart';
import '../../utils/shared_preferences/shared_preferances.dart';

class top_developer_controller extends GetxController {

  TextEditingController developerController = TextEditingController();
  TextEditingController designationController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  File? iconImg;
  var getFeaturedPropery = [].obs;
  RxList getOfferList = [].obs;
  RxList myListingPrperties = [].obs;
  RxList getUpcomingProject = [].obs;
  late XFile pickedImageFile;
  RxBool isIconSelected = false.obs;
  var isLoading = false.obs;
  RxList getdeveloperList = [].obs;
  var developerDetails = {}.obs;


  Future<void> addDeveloper({ String? name,String? designation,String? add,var image}) async {
    String? userId = await SPManager.instance.getUserId(USER_ID);
    try {
      showHomLoading(Get.context!, 'Processing...');
      isLoading.value = true;
      Get.focusScope!.unfocus();
      XFile? xFile;
      if (image != null) {
        xFile = XFile(image.path);
      }
      var response = await HttpHandler.formDataMethod(
        url: APIString.add_developer,
        apiMethod: "POST",
        body: {
          "user_id":userId!,
          "developer_name": name!,
          "designation": designation!,
          "address": add!,
         // "approval_status": "Approved",
          "approval_status": "Pending",

        },
        imageKey: "brand_img",
        imagePath: xFile?.path,
      );
      log('response----- ${response["body"]}');

      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          Fluttertoast.showToast(msg: response['body']['msg'].toString());
          Navigator.of(Get.context!).pop();
          isLoading.value = false;
        } else if (response['body']['status'].toString() == "0") {
          Fluttertoast.showToast(msg: response['body']['msg'].toString());
        }
      } else if (response['error'] != null) {
        var responseBody = json.decode(response['body']);
        Fluttertoast.showToast(msg: responseBody['msg']);
      }
    } catch (e, s) {
      debugPrint("brand_img Error -- $e  $s");
    } finally {
      isLoading.value = false;

      if (Navigator.canPop(Get.context!)) {
        Navigator.of(Get.context!).pop();
      }
    }
  }

  Future<void> getDeveloper() async {
    getdeveloperList.clear();
    try {
      var response = await HttpHandler.getHttpMethod(
        url: APIString.get_developer,);
      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          log("response[data]  ---- ${response['body']["data"]}");
          var respData = response['body'];
          getdeveloperList.value = respData["data"];
        //  Fluttertoast.showToast(msg: 'Fetch successfully');
        }
      }
      else if (response['error'] != null) {
        //Fluttertoast.showToast(msg: 'An error occurred. Please try again.');
      }
    } catch (e) {
      debugPrint(" Error: $e");
     // Fluttertoast.showToast(msg: 'An error occurred. Please try again.');
    }
  }

  Future<void> getDeveloperDetails({String? userId, String? developerId,}) async {
    developerDetails.clear();
      showHomLoading(Get.context!, 'Processing...');
      isLoading.value = true;
      //user_id, developer_id
      try {

        var response = await HttpHandler.postHttpMethod(
          url: APIString.get_developer_details,
          data: {
            'user_id': userId,
            'developer_id': developerId,
          },
        );
        if (response['error'] == null && response['body']['status'].toString() == "1") {
          developerDetails.value = response['body']['developer_details'];
          getFeaturedPropery.value = response['body']['featured_properties'];
          getUpcomingProject.value = response['body']['upcoming_projects'];
          getOfferList.value = response['body']['offer_details'];
          myListingPrperties.value = response['body']['recommended_properties'];
          Fluttertoast.showToast(msg: 'successful.');
        } else {
          var responseBody = json.decode(response['body']);
          Fluttertoast.showToast(msg: responseBody['msg']);
        }
      } catch (e) {
        debugPrint("Error: $e");
        Fluttertoast.showToast(msg: 'An error occurred. Please try again2.');
      } finally {
        isLoading.value = false;
        if (Navigator.canPop(Get.context!)) {
          Navigator.of(Get.context!).pop();
        }
    }
  }
}