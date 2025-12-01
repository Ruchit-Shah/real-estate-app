import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/global/services/api_shorts_string.dart';

import '../../../global/services/network_http.dart';
import '../../../global/widgets/loading_dialog.dart';
import '../../../utils/common_snackbar.dart';
import 'my_profile_controller.dart';

class FollowController extends GetxController {

  RxInt lastFollowerPage = 0.obs;
  RxInt currentFollowerPage = 1.obs;
  RxList followerList = [].obs;

  Future getFollowerList({int pageNumber = 1, bool isShowMoreCall = false,String user_id=''}) async {
    try {
      showLoadingDialog();
      var response = await HttpHandler.postHttpMethod(url: APIShortsString.follow_list, data: {
        "follow_type": "follower",
        "user_id": user_id,
        "count": 10,
        "page_no": pageNumber,
      });

      hideLoadingDialog();
      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          var respData = response['body'];
          lastFollowerPage.value = respData["last_page"];
          currentFollowerPage.value = respData["current_page"];
          if (isShowMoreCall == true) {
            respData["data"]["follower"].forEach((e) {
              followerList.add(e);
            });
          } else {
            followerList.value = respData["data"]["follower"];
          }
        } else if (response['body']['status'].toString() == "0") {
          followerList.value = [];
          showSnackbar(message: response['body']['msg']);
        }
      } else if (response['error'] != null) {
        followerList.value = [];
      }
    } catch (e, s) {
      hideLoadingDialog();
      debugPrint("getFollowerList Error -- $e  $s");
    }
  }

  RxInt lastFollowingPage = 0.obs;
  RxInt currentFollowingPage = 1.obs;
  RxList followingList = [].obs;

  Future getFollowingList({int pageNumber = 1, bool isShowMoreCall = false,String user_id=''}) async {
    try {
      showLoadingDialog();
      var response = await HttpHandler.postHttpMethod(
        url: APIShortsString.follow_list,
        data: {
          "follow_type": "following",
          "user_id": user_id,
          "count": 10,
          "page_no": pageNumber,
        },
      );
      log("respData  ==============  respData   $response");

      hideLoadingDialog();

      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          var respData = response['body'];
          lastFollowingPage.value = respData["last_page"];
          currentFollowingPage.value = respData["current_page"];
          if (isShowMoreCall == true) {
            if(respData["data"]["following"]!=[]) {
              respData["data"]["following"].forEach((e) {
                followingList.add(e);
              });
            }
          }
          else {
            log("respData  ==============  respData   ${respData["data"]}");
            followingList.value = respData["data"]["following"];
          }
        } else if (response['body']['status'].toString() == "0") {
          followingList.value = [];
          showSnackbar(message: response['body']['msg']);
        }
      } else if (response['error'] != null) {
        hideLoadingDialog();
        followingList.value = [];
      }
    } catch (e, s) {
      hideLoadingDialog();
      debugPrint("getFollowingList Error -- $e  $s");
    }
  }

  Future followUnfollowUpdateList({String? followId, String? status}) async {
    try {
      var response = await HttpHandler.postHttpMethod(
        url: APIShortsString.follow_unfollow_update,
        data: {
          "follow": status,
          "user_id": Get.find<MyProfileController>().userId.value,
          "follow_id":followId
        },
      );

      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {}
        else if (response['body']['status'].toString() == "0") {
          showSnackbar(message: response['body']['msg']);
        }
      } else if (response['error'] != null) {
      }
    } catch (e, s) {
      hideLoadingDialog();
      debugPrint("followUnfollowUpdateList Error -- $e  $s");
    }
  }
}
