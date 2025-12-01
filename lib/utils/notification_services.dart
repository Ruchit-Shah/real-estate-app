

// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:math';


import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:path_provider/path_provider.dart';


class NotificationServices {

  FirebaseMessaging messaging = FirebaseMessaging.instance ;


  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    return token!;
  }

  void isTokenRefresh()async{
    messaging.onTokenRefresh.listen((event) {
      event.toString();
      if (kDebugMode) {
        print('refresh');
      }
    });
  }



}