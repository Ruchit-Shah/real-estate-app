import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:real_estate_app/global/services/api_shorts_string.dart';

class EnquiryController extends GetxController {
  RxList enquiries = <dynamic>[].obs;
  var isLoading = true.obs;

  Future<void> fetchEnquiries(String productId, String userID) async {
    final String baseURL = APIShortsString.baseUrl;
    final String url = '$baseURL${APIShortsString.get_customer_enquiry}';

    try {
      isLoading(true);
      //enquiries.clear();

      print('Request URL: $url');
      print('Request Body: ${jsonEncode({
        'UserId': userID,
        'product_id': productId,
      })}');

      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'otherUserId': userID,
          'product_id': productId,
        }),
      );

      print('Response: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        print('JSON Response: ${jsonResponse}');
        print('Status: ${jsonResponse['status']}');

        if (jsonResponse['status'].toString() == "1") {
          var data = jsonResponse['data'];
          print('Enquiries: '+data.toString());
          var productDetails = jsonResponse['product_details'];
          print('Product: '+productDetails.toString());
          if (data is List) {
            enquiries.value = data;
            print('Enquiries: ${enquiries}');
          } else {
            print('Data field is not a list or is null');
            Get.snackbar('Info', 'No enquiries found');
          }
        } else {
          Get.snackbar('Error', 'Failed to load enquiries');
        }
      } else {
        print('Response status code: ${response.statusCode}');
        Get.snackbar('Error', 'Failed to load enquiries');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load enquiries');
      print('Error: $e');
    } finally {
      isLoading(false);
    }
  }
}
