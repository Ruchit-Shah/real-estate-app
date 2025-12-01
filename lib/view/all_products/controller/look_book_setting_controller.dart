import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../global/services/api_shorts_string.dart';
import '../../../global/services/network_http.dart';
import '../../../global/widgets/loading_dialog.dart';
import '../../../utils/common_snackbar.dart';
import '../../shorts/controller/my_profile_controller.dart';

class LookBookSettingController extends GetxController {
  final lookbookNameController = TextEditingController();

  RxList lookbookList = [].obs;
  RxBool isMoreLookbookLoading = false.obs;
  RxInt currentLookbookPage = 1.obs;
  RxInt lastLookbookPage = 0.obs;
  RxInt nextLookbookPage = 1.obs;
  RxString user_contact=''.obs;

  Future addLookBookApi(
      {String? videoId, String? productId, String? lookbookName}) async {

    try {
      showLoadingDialog();
      var response = await HttpHandler.postHttpMethod(
          url: APIShortsString.create_product_lookbook,
          //video_id, user_id,product_id,lookbook_name
          data: {
            "user_id": Get.find<MyProfileController>().userId.value,
            "video_id": videoId,
            "product_id": productId,
            "lookbook_name": lookbookName,
          });

      log("addLookBookApi  :: body  :: ${{
        "user_id": Get.find<MyProfileController>().userId.value,
        "video_id": videoId,
        "product_id": productId,
        "lookbook_name": lookbookName,
      }}");
      log("addLookBookApi  :: response  :: ${response["body"]}");

      hideLoadingDialog();
      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          lookbookNameController.clear();
          getLookBookApi(productId: productId, videoId: videoId,userId: Get.find<MyProfileController>().userId.value);
        } else if (response['body']['status'].toString() == "0") {
          showSnackbar(message: response['body']['msg']);
        }
      } else if (response['error'] != null) {}
    } catch (e, s) {
      hideLoadingDialog();
      debugPrint("addLookBookApi Error -- $e  $s");
    }
  }

  Future updateLookBookApi(
      {String? videoId,
      String? productId,
      String? lookbookId,
      String? lookbookName,
      String? relatedProductId}) async {
    try {
      showLoadingDialog();
      var response = await HttpHandler.postHttpMethod(
          url: APIShortsString.update_product_lookbook,
          //lookbook_id,video_id, user_id,product_id,lookbook_name,related_product_id
          data: {
            "user_id": Get.find<MyProfileController>().userId.value,
            "lookbook_id": lookbookId,
            "video_id": videoId,
            "product_id": productId,
            "lookbook_name": lookbookName,
            "related_product_id": relatedProductId,
          });

      log("updateUnitApi  :: response  :: ${response["body"]}");

      hideLoadingDialog();
      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          getLookBookApi(productId: productId, videoId: videoId,userId: Get.find<MyProfileController>().userId.value);
        } else if (response['body']['status'].toString() == "0") {
          showSnackbar(message: response['body']['msg']);
        }
      } else if (response['error'] != null) {}
    } catch (e, s) {
      hideLoadingDialog();
      debugPrint("updateUnitApi Error -- $e  $s");
    }
  }

  Future deleteLookBookApi(
      {String? lookbookId, String? productId, String? videoId}) async {
    try {
      showLoadingDialog();
      var response = await HttpHandler.postHttpMethod(
          url: APIShortsString.delete_product_lookbook,
          data: {
            "lookbook_id": lookbookId,
          });

      log("deleteLookBookApi  :: response  :: ${response["body"]}");

      hideLoadingDialog();
      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          getLookBookApi(productId: productId, videoId: videoId,userId: Get.find<MyProfileController>().userId.value);
        } else if (response['body']['status'].toString() == "0") {
          showSnackbar(message: response['body']['msg']);
        }
      } else if (response['error'] != null) {}
    } catch (e, s) {
      hideLoadingDialog();
      debugPrint("deleteLookBookApi Error -- $e  $s");
    }
  }

  Future getLookBookApi(
      {String? userId,String? videoId, String? productId}) async {
    try {
        showLoadingDialog();
      var response = await HttpHandler.postHttpMethod(
          url: APIShortsString.get_product_lookbook,
          data: {
            // "user_id": Get.find<MyProfileController>().userId.value,
            "user_id": userId,
            "video_id": videoId,
            "product_id": productId,
          });

      log("getLookBookApi  :: body  :: ${{
        "user_id": Get.find<MyProfileController>().userId.value,
        "video_id": videoId,
        "product_id": productId,
      }}");
      log("getLookBookApi  :: response  :: ${response["body"]}");

        hideLoadingDialog();
      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          if(response['body']["data"] != null) {
            // lookbookList.value = response['body']["data"]["product_data"];
            print("response['body'][data]   ${response['body']["data"]}");
            lookbookList.value = response['body']["data"];
        }
          else{
            lookbookList.value = [];
          }
        }
        else if (response['body']['status'].toString() == "0") {
          showSnackbar(message: response['body']['msg']);
        }
      } else if (response['error'] != null) {}
    } catch (e, s) {
      hideLoadingDialog();
      debugPrint("getLookBookApi Error -- $e  $s");
    }
  }

  ///crud for look book products

  Future addProductLookBookApi(
      {String? videoId, String? productId, String? lookbookId}) async {
    try {
      showLoadingDialog();
      var response = await HttpHandler.postHttpMethod(
          url: APIShortsString.add_product_to_lookbook,
          //lookbook_id,video_id, user_id,product_id
          data: {
            "user_id": Get.find<MyProfileController>().userId.value,
            "video_id": videoId,
            "product_id": productId,
            "lookbook_id": lookbookId,
          });

      log("addProductLookBookApi  :: body  :: ${{
        "user_id": Get.find<MyProfileController>().userId.value,
        "video_id": videoId,
        "product_id": productId,
        "lookbook_id": lookbookId,
      }}");
      log("addProductLookBookApi  :: response  :: ${response["body"]}");

      hideLoadingDialog();
      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          print("productId: productId, videoId: videoId   ${ productId} -- ${videoId}");
          getLookBookApi(productId: productId, videoId: videoId,userId: Get.find<MyProfileController>().userId.value);
          Get.close(3);
        } else if (response['body']['status'].toString() == "0") {
          showSnackbar(message: response['body']['msg']);
        }
      } else if (response['error'] != null) {}
    } catch (e, s) {
      hideLoadingDialog();
      debugPrint("addProductLookBookApi Error -- $e  $s");
    }
  }

  Future updateProductLookBookApi({
    String? videoId,
    String? productId,
    // String? lookbookId,
    String? productLookbookId,
    // String? relatedProductId,
  }) async {
    try {
      showLoadingDialog();
      var response = await HttpHandler.postHttpMethod(
          url: APIShortsString.update_product_to_lookbook,
          //product_lookbook_id
          data: {
            // "user_id": Get.find<MyProfileController>().userId.value,
            // "lookbook_id": lookbookId,
            // "video_id": videoId,
            // "product_id": productId,
            "product_lookbook_id": productLookbookId,
            // "related_product_id": relatedProductId,
          });

      log("updateUnitApi  :: response  :: ${response["body"]}");

      hideLoadingDialog();
      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          getLookBookApi(productId: productId, videoId: videoId,userId: Get.find<MyProfileController>().userId.value);
        } else if (response['body']['status'].toString() == "0") {
          showSnackbar(message: response['body']['msg']);
        }
      } else if (response['error'] != null) {}
    } catch (e, s) {
      hideLoadingDialog();
      debugPrint("updateUnitApi Error -- $e  $s");
    }
  }

  Future deleteProductLookBookApi({
    String? product_lookbook_id,
    String? productId,
    String? videoId,
  }) async {
    try {
      showLoadingDialog();
      var response = await HttpHandler.postHttpMethod(
          url: APIShortsString.delete_product_to_lookbook,
          data: {
            "product_lookbook_id": product_lookbook_id,
          });

      log("deleteLookBookApi  :: body  :: ${{
        "product_lookbook_id": product_lookbook_id,
      }}");
      log("deleteLookBookApi  :: response  :: ${response["body"]}");

      hideLoadingDialog();
      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          getLookBookApi(productId: productId, videoId: videoId,userId: Get.find<MyProfileController>().userId.value);
          Get.close(2);
        }
        else if (response['body']['status'].toString() == "0") {
          showSnackbar(message: response['body']['msg']);
        }
      }
      else if (response['error'] != null) {}
    } catch (e, s) {
      hideLoadingDialog();
      debugPrint("deleteLookBookApi Error -- $e  $s");
    }
  }
}
