import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../global/api_string.dart';
import '../../utils/network_http.dart';

class notificationController extends GetxController {
  RxList getNotificationList = [].obs;

  Future<void> getNotification() async {
    getNotificationList.clear();
    try {
      var url = 'http://13.127.244.70:4444/api/get_notifications';
      Uri uri = Uri.parse(url);
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final resp = jsonDecode(response.body);
        int status = resp['status'];
        if (status == 1) {
          getNotificationList.value = resp["data"];
        } else {

        }

      }
    } catch (e) {
      getNotificationList.clear();
      debugPrint(" Error: $e");
    }
  }
}