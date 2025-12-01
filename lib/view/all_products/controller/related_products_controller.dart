import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../global/services/api_shorts_string.dart';
import '../../../global/services/network_http.dart';
import '../../../global/widgets/loading_dialog.dart';
import '../../../utils/common_snackbar.dart';
import '../../shorts/controller/my_profile_controller.dart';

class RelatedProductsController extends GetxController {
  RxBool isApiCallProcessing = true.obs;
  RxMap myVideosResponse = {}.obs;
  RxList searchResult = [].obs;
  RxList myVideosDataList = [].obs;
  RxInt lastPage = 0.obs;
  RxInt currentPageList = 1.obs;
  RxInt nextPage = 1.obs;
  final ScrollController scrollController = ScrollController();

  Future videoForRelatedProducts({
    int pageNumber = 1,
    int count = 10,
    bool isShowMoreCall = false,
  }) async {
    // showLoadingDialog();
    isApiCallProcessing.value = true;
    try {
      var response =
          await HttpHandler.postHttpMethod(url: APIShortsString.my_videos, data: {
        "user_id": Get.find<MyProfileController>().userId.value,
        "count": count,
        "page_no": pageNumber,
      });

      myVideosResponse.value = response;
      isApiCallProcessing.value = false;

      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          var respData = response['body'];
          lastPage.value = response['body']["last_page"];
          currentPageList.value = response['body']["current_page"];
          nextPage.value = currentPageList.value + 1;

          if (isShowMoreCall == true) {
            respData["data"].forEach((e) {
              e["controller"] = null;
              var d = e;
              myVideosDataList.add(/*e*/ d);
            });
            print("myVideosApi  add in existing $myVideosDataList");
          } else {
            respData["data"].forEach((element) {
              element["controller"] = null;
            });
            myVideosDataList.value = respData["data"];
            print("myVideosApi  replace $myVideosDataList");
          }
        } else if (response['body']['status'].toString() == "0") {
          myVideosDataList.value = [];
          showSnackbar(message: response['body']['msg']);
        }
      } else if (response['error'] != null) {
        myVideosDataList.value = [];
      }
    } catch (e, s) {
      debugPrint("myVideosApi Error -- $e  $s");
    }
  }

  ///========
  RxList relatedProductsList = [].obs;
  RxBool isMoreRelatedLoading = false.obs;
  RxInt currentRelatedPage = 1.obs;
  RxInt lastRelatedPage = 0.obs;
  RxInt nextRelatedPage = 1.obs;

  Future addRelatedProductApi({String? videoId, String? productId}) async {
    try {
      showLoadingDialog();
      var response = await HttpHandler.postHttpMethod(
          url: APIShortsString.add_related_products,
          data: {
            "user_id": Get.find<MyProfileController>().userId.value,
            "video_id": videoId,
            "product_id": productId,
          });

      log("addUnitApi  :: response  :: ${response["body"]}");

      hideLoadingDialog();
      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          Get.back();
          getRelatedProductApi( videoId: videoId);
        } else if (response['body']['status'].toString() == "0") {
          showSnackbar(message: response['body']['msg']);
        }
      } else if (response['error'] != null) {}
    } catch (e, s) {
      hideLoadingDialog();
      debugPrint("addUnitApi Error -- $e  $s");
    }
  }

  Future updateRelatedProductApi(
      {String? relatedProductId, String? unit}) async {
    try {
      showLoadingDialog();
      var response = await HttpHandler.postHttpMethod(
          url: APIShortsString.update_related_products,
          data: {
            "related_product_id": relatedProductId,
          });

      log("updateUnitApi  :: response  :: ${response["body"]}");

      hideLoadingDialog();
      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          // getRelatedProductApi(count: 10, pageNo: 1,videoId: );
        } else if (response['body']['status'].toString() == "0") {
          showSnackbar(message: response['body']['msg']);
        }
      } else if (response['error'] != null) {}
    } catch (e, s) {
      hideLoadingDialog();
      debugPrint("updateUnitApi Error -- $e  $s");
    }
  }

  Future deleteRelatedProductApi(
      {String? relatedProductId, String? videoId}) async {
    try {
      showLoadingDialog();
      var response = await HttpHandler.postHttpMethod(
          url: APIShortsString.delete_related_products,
          data: {
            "related_product_id": relatedProductId,
          });

      log("deleteRelatedProductApi  :: response  :: ${response["body"]}");

      hideLoadingDialog();
      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          getRelatedProductApi(videoId: videoId);
        } else if (response['body']['status'].toString() == "0") {
          showSnackbar(message: response['body']['msg']);
        }
        // if (response['body']['status'].toString() == "1") {}
      } else if (response['error'] != null) {}
    } catch (e, s) {
      hideLoadingDialog();
      debugPrint("deleteRelatedProductApi Error -- $e  $s");
    }
  }

  Future getRelatedProductApi({String? videoId}) async {
    try {
      relatedProductsList.clear();
      showLoadingDialog();

      var response = await HttpHandler.postHttpMethod(
          url: APIShortsString.get_related_products,
          data: {
            "user_id": Get.find<MyProfileController>().userId.value,
            "video_id": videoId,
            "product_id":"65a8d1918a63fee65904b7f2",
          });

      log("getRelatedProductApi  :: response  :: ${response["body"]["data"]} ${response["body"]}");

      hideLoadingDialog();
      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1" && response['body']['data'].isNotEmpty) {
          relatedProductsList.value = response['body']["data"];
        } else if (response['body']['status'].toString() == "0") {
          showSnackbar(message: response['body']['msg']);
        }
      } else if (response['error'] != null) {}
    } catch (e, s) {
      hideLoadingDialog();
      debugPrint("getRelatedProductApi Error -- $e  $s");
    }
  }
}
