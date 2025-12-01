// The best way to handle network requests in Flutter
// Applications frequently need to perform POST and GET and other HTTP requests.
// Flutter provides an http package that supports making HTTP requests.

// HTTP methods: GET, POST, PATCH, PUT, DELETE

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:real_estate_app/utils/shared_preferences/shared_preferances.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../global/api_string.dart';
import 'local_storage.dart';



class HttpHandler {
  // static String baseURL = APIString.baseURL;
  static String baseURL = APIString.baseUrl;



  static Future<Map<String, String>> _getHeaders() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString(
      LocalStorage.token,
    );
    log("Token -- '$token'");
    return {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': "Bearer $token",
    };
  }

  static Future<Map<String, dynamic>> formDataMethod({required String url,
        Map<String, String>? body,
        String? imagePath,
        String? logoPath,
        String? videoPath,
        String? pdfFile,
        String? pdfKey,
        String? apiMethod,
        List<String>? imageList,
        List<Map<String,dynamic>>? imageListSeprateFile,
        String? imageKey,
        String? logoKey,
        String? videoKey
      }) async
  {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString(
      LocalStorage.token,
    );
    var request = http.MultipartRequest(
      (apiMethod ?? "POST").toUpperCase(),
      Uri.parse(
        "$baseURL$url",
      ),
    );
    log("POST FORM DATA URL ----  $request");
    // log("============================$token");

    request.headers.addAll(
      {
        // if (token != null) 'Authorization': 'Bearer $token',
        if (token != null) 'Authorization': "Bearer $token",
        'Content-Type':
        'multipart/form-data; boundary=<calculated when request is sent>'
      },
    );

    log("FORM DATA BODY :-  $body");

    if (imagePath != null) {
      log("image -- $imagePath");
      request.files.add(
        await http.MultipartFile.fromPath('$imageKey', imagePath),
      );
    }
    if (logoPath != null) {
      log("Logo -- $logoPath");
      request.files.add(
        await http.MultipartFile.fromPath('$logoKey', logoPath),
      );
    }
    if (pdfFile != null) {
      log("pdfKey -- $pdfFile");
      request.files.add(
        await http.MultipartFile.fromPath('$pdfKey', pdfFile),
      );
    }
    if (imageList != null) {
      for (var element in imageList) {
        request.files.add(
          await http.MultipartFile.fromPath('$imageKey', element),
        );
      }
    }
    if (imageListSeprateFile != null) {
      for (var element in imageListSeprateFile) {
        request.files.add(
          await http.MultipartFile.fromPath('${element["imageKey"]}', element["filepath"]),
        );
      }
    }
    if (imageList != null) {
      for (var element in imageList) {
        request.files.add(
          await http.MultipartFile.fromPath('$imageKey', element),
        );
      }
    }
    // Handle single video
    if (videoPath != null) {
      log("video -- $videoPath");
      request.files.add(
        await http.MultipartFile.fromPath('$videoKey', videoPath),
      );
    }

    if (body != null) {
      request.fields.addAll(body);
    }
    var response = await request.send();
    var responseData = await response.stream.toBytes();
    String responseString = String.fromCharCodes(responseData);
    log("RESPONSE = $responseString");
    log("RESPONSE CODE = ${response.statusCode}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = json.decode(
        responseString,
      );
      Map<String, dynamic> returnRes = {
        'body': data,
        'error': null,
      };
      return returnRes;
    } else {
      Map<String, dynamic> returnRes = {
        'body': null,
        'error': responseString,
      };
      log('Something went wrong');
      return returnRes;
    }
  }

  static Future<Map<String, dynamic>> getHttpMethod({
    @required String? url,
    Map<String, dynamic>? data, // Add this parameter for request body
    bool isMockUrl = false,
  }) async {
    var header = await _getHeaders();

    log("Get URL -- '$baseURL$url'");
    log("Get Data -- '$data'");

    // Create the base request
    var request = http.Request('GET', Uri.parse(isMockUrl ? "$url" : "$baseURL$url"));

    // Add headers
    request.headers.addAll(header);

    // Add body if provided
    if (data != null) {
      request.body = jsonEncode(data);
    }

    // Send the request
    http.StreamedResponse streamedResponse = await request.send();

    // Convert to regular response
    http.Response response = await http.Response.fromStream(streamedResponse);

    var res = handler(response);
    return res;
  }

  // static Future<Map<String, dynamic>> postHttpMethod({
  //   @required String? url,
  //   Map<String, dynamic>? data,
  // }) async {
  //   var header = await _getHeaders();
  //
  //   log("Post URL -- '$baseURL$url'");
  //   log("Post Data -- '${jsonEncode(data)}'");
  //   http.Response response = await http.post(
  //     Uri.parse("$baseURL$url"),
  //     headers: header,
  //     body: data == null ? null : jsonEncode(data),
  //   );
  //   print("url  statusCode :: $url - ${response.statusCode}");
  //   print("url  body :: $url - ${response.body}");
  //   var res = handler(response);
  //   return res;
  // }
  static Future<Map<String, dynamic>> postHttpMethod({
    required String? url,
    Map<String, dynamic>? data,
  }) async {
    var headers = await _getHeaders();

    log("Post URL -- '$baseURL$url'");
    log("Post Data -- '${jsonEncode(data)}'");

    try {
      final response = await http.post(
        Uri.parse("$baseURL$url"),
        headers: headers,
        body: data == null ? null : jsonEncode(data),
      );

      print("url statusCode :: $url - ${response.statusCode}");
      print("url body :: $url - ${response.body}");

      // Here you can handle the response directly
      return handler(response); // Ensure your handler function is defined correctly

    } catch (error) {
      print("Error in POST request: $error");
      return {
        'error': true,
        'message': 'An error occurred during the request.',
      };
    }
  }

  static Future<Map<String, dynamic>> patchHttpMethod({
    @required String? url,
    Map<String, dynamic>? data,
  }) async {
    var header = await _getHeaders();
    log("Patch URL -- '$baseURL$url'");
    log("Post Data -- '${jsonEncode(data)}'");
    http.Response response = await http.patch(
      Uri.parse("$baseURL$url"),
      headers: header,
      body: data == null ? null : jsonEncode(data),
    );
    var res = handler(response);
    return res;
  }

  static Future<Map<String, dynamic>> putHttpMethod({
    @required String? url,
    Map<String, dynamic>? data,
  }) async {
    var header = await _getHeaders();
    log("Put URL -- '$baseURL$url'");
    log("Post Data -- '${jsonEncode(data)}'");
    http.Response response = await http.put(
      Uri.parse("$baseURL$url"),
      headers: header,
      body: data == null ? null : jsonEncode(data),
    );
    var res = handler(response);
    return res;
  }

  // static Future<Map<String, dynamic>> deleteHttpMethod({
  //   @required String? url,
  //   Map<String, dynamic>? data,
  // }) async {
  //   var header = await _getHeaders();
  //   final uri = Uri.parse("$baseURL$url").replace(queryParameters: data);
  //   log("Delete URL -- '$uri'");
  //   http.Response response = await http.delete(uri, headers: header);
  //   var res = handler(response);
  //   return res;
  // }

  static Future<Map<String, dynamic>> deleteHttpMethod({
    @required String? url,
    Map<String, dynamic>? data,
  }) async {
    var header = await _getHeaders();

    log("Delete URL -- '$baseURL$url'");
    log("Delete Data -- '${jsonEncode(data)}'");
    http.Response response = await http.delete(
      Uri.parse("$baseURL$url"),
      headers: header,
      body: data == null ? null : jsonEncode(data),
    );
    print("url  statusCode :: $url - ${response.statusCode}");
    print("url  body :: $url - ${response.body}");
    var res = handler(response);
    return res;
  }


  static Map<String, dynamic> handler(http.Response response) {
    log("Response Code -- '${response.statusCode}'");
    log("Response -- '${response.body}'");
    if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 204) {
      return {
        'body': jsonDecode(response.body),
        'headers': response.headers,
        'error': null,
      };
    } else if (response.statusCode == 401 || response.statusCode == 400) {
      // clearLocalStorage();
      // Get.offAll(() => const LoginScreen());

      return {
        'body': response.body,
        'headers': response.headers,
        'error': "${response.statusCode}",
      };
    }
    else if (response.statusCode == 500) {
      //clearLocalStorage();
      // Get.offAll(() => const LoginScreen());

      return {
        'body': response.body,
        'headers': response.headers,
        'error': "${response.statusCode}",
      };
    }else {
      return {
        'body': response.body,
        'headers': response.headers,
        'error': "${response.statusCode}",
      };
    }
  }
}
