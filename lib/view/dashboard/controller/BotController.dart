
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:real_estate_app/view/filter_search/view/FilterSearchController.dart';

import '../../../common_widgets/loading_dart.dart';
import '../../../global/api_string.dart';
import '../../../utils/String_constant.dart';
import '../../../utils/network_http.dart';
import '../../../utils/shared_preferences/shared_preferances.dart';


class BotController extends GetxController {

  RxString topic_data=''.obs;

  RxInt selectedOption = 1.obs;

  var isLoading = false.obs;
  final FilterSearchController filterController = Get.find();
  RxList getSearchResults = [].obs;

  void setSelectedOption(int value) {
    selectedOption.value = value;
  }

  void clearSelection() {
    selectedOption.value = -1;
  }

  Future<void> search_ai({String? search_query, String? keywords,String? search_area,String? city}) async {
    String? userId = await SPManager.instance.getUserId(USER_ID);

    try {
      showHomLoading(Get.context!, 'Processing...');
      getSearchResults.clear();
      isLoading.value = true;
      Get.focusScope!.unfocus();

      var response = await HttpHandler.formDataMethod(
        url: APIString.search_properties,
        apiMethod: "POST",
        body: {
          "search_query": search_query!,
          "search_keywords": keywords!,
          "user_id": userId??"",
          "area":search_area!,
          "city":city!
        },
      );

      log('response----- ${response["body"]}');

      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {

            //log("response[data]  ---- ${response['body']["data"]}");
            var respData = response['body'];

            getSearchResults.value = respData["data"];

              for (var item in getSearchResults.take(3)) {
                final id = item["_id"]?.toString() ?? '';
                final name = item["city_name"]?.toString() ?? '';
                final area = item["address"]?.toString() ?? '';
                final property_name = item["property_name"]?.toString() ?? '';
                filterController.addSearchName(property_id: id, property_name: name,search_by: 'AI',area: area,propertName:property_name );
              }
          //Navigator.of(Get.context!).pop();
          isLoading.value = false;
        } else if (response['body']['status'].toString() == "0") {
          getSearchResults.value=[];
          Fluttertoast.showToast(msg: response['body']['message'].toString());
        }
      } else if (response['error'] != null) {
        var responseBody = json.decode(response['body'] ?? []);
        Fluttertoast.showToast(msg: responseBody['message']);
      }
    } catch (e, s) {
      debugPrint("updateProfile Error -- $e  $s");
    } finally {
      isLoading.value = false;
      if (Navigator.canPop(Get.context!)) {
        Navigator.of(Get.context!).pop();
      }
    }
  }

  //user_id,agora_token,agent_id,schedule_date,schedule_time
  Future<void> add_schedule_virtual_tour({String? token, String? agentId,String? scheduleDate,String? scheduleTime,}) async {
    String? userId = await SPManager.instance.getUserId(USER_ID);

    try {
      showHomLoading(Get.context!, 'Processing...');
      isLoading.value = true;
      Get.focusScope!.unfocus();

      var response = await HttpHandler.formDataMethod(
        url: APIString.search_properties,
        apiMethod: "POST",
        body: {
          "agora_token": token!,
          "agent_id": agentId!,
          "schedule_date": scheduleDate!,
          "schedule_time": scheduleTime!,
          "user_id": userId!,
        },
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
      debugPrint("updateProfile Error -- $e  $s");
    } finally {
      isLoading.value = false;
      if (Navigator.canPop(Get.context!)) {
        Navigator.of(Get.context!).pop();
      }
    }
  }

  Future<void> get_schedule_virtual_tour({String? scheduleDate}) async {
    String? userId = await SPManager.instance.getUserId(USER_ID);

    try {

      var response = await HttpHandler.postHttpMethod(
        url: APIString.get_virtual_tour_schedule,
        data: {
          'user_id':userId,
          'schedule_date':scheduleDate,
        },
      );

      if (response['error'] == null) {

        if (response['body']['status'].toString() == "1") {

          log("response[data]  ---- ${response['body']["data"]}");
          var respData = response['body'];

          getSearchResults.value = respData["data"];

        }
      }
      else if (response['error'] != null) {

      }
    } catch (e) {

      debugPrint("Login Error: $e");
      //  Fluttertoast.showToast(msg: 'An error occurred. Please try again.');
    }
  }
}