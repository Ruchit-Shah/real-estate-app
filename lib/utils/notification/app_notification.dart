import 'dart:convert';
import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

bool isMissedCall = false;

class AppNotificationHandler {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize() {
    InitializationSettings initializationSettings =
        const InitializationSettings(
            android: AndroidInitializationSettings("@drawable/ic_notification"),
            iOS: DarwinInitializationSettings(
                requestAlertPermission: true,
                requestSoundPermission: true,
                requestBadgePermission: true));

    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse: (NotificationResponse res) {
        debugPrint("onDidReceiveBackgroundNotificationResponse  ${res.payload}");
      },
      onDidReceiveNotificationResponse: (NotificationResponse res) {
        debugPrint("onDidReceiveNotificationResponse  ${res.payload} ");
      },
    );
  }

  /// FIREBASE NOTIFICATION SETUP

  static Future<void> firebaseNotificationSetup() async {
    ///firebase initialize
    await Firebase.initializeApp();
    print(" passed step  ----------- firebaseNotificationSetup 1 ");

    ///local notification...
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    print(" passed step  ----------- firebaseNotificationSetup 2 ");

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    ///IOS Setup
    DarwinInitializationSettings initializationSettings =
        const DarwinInitializationSettings(
            requestAlertPermission: true,
            requestSoundPermission: true,
            requestBadgePermission: true);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.initialize(initializationSettings);
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    // Update the iOS foreground notification presentation options to allow
    // heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    ///Get FCM Token..
    await getFcmToken();
  }

  ///background notification handler..
  @pragma('vm:entry-point')
  static Future<void> firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();
    print("inside --- > firebaseMessagingBackgroundHandler");
    print("inside --- > firebaseMessagingBackgroundHandler   ${message.data}");
    print("inside --- > message.data ::type::  ${message.data["type"]}");
    print("inside --- > message.data ::Sender::  ${message.data["Sender"]}");
    print("inside --- > message.data ::callId::  ${message.data["callId"]}");
    print("inside --- > message.data ::callType::  ${message.data["callType"]}");
    print("inside --- > message.data ::channelName::  ${message.data["channelName"]}");
    print("inside --- > message.data ::callToken::  ${message.data["callToken"]}");
    if (message.data["type"] == "missed_call") {
      // isMissedCall = true ;
      print("inside --- > firebaseMessagingBackgroundHandler :: type ::  ${message.data["type"]}");
      flutterLocalNotificationsPlugin.cancelAll();
      Future.delayed(
        const Duration(seconds: 1),
        () => flutterLocalNotificationsPlugin.cancelAll(),
      );
    }
    if (message.data["type"].toString() == "Live Stream") {
      final liveData = message.data['live_data'];
      final channelName = liveData['channel_name'];
      final agoraToken = liveData['agora_token'];
      final username = liveData['user_data']['username'];

// Redirect to the live screen after a delay
//       Future.delayed(
//         const Duration(seconds: 1),
//             () => Get.to(() => LiveScreen(
//           isBroadcaster: false,
//           appId: appId,
//           channelName: channelName,
//           token: agoraToken,
//           username: username,
//         )),
//       );
    }
  }

  static AndroidNotificationChannel channel = const AndroidNotificationChannel(
      "high_importance_channel", // idz
      'high_importance_channel', // title
      description: "high_importance_channel", // description
      importance: Importance.high,
      playSound: true,

  );

  ///get fcm token
  static Future<void> getFcmToken() async {
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

    try {
      String? token = await firebaseMessaging.getToken().catchError((e) {
        debugPrint("=========fcm- Error ....:$e");
      });

      debugPrint("fcm-token :  $token");
    } catch (e) {
      // debugPrint("=========fcm- Error :$e");
      return;
    }
  }

  ///call when app in fore ground
  static Future<void> showMsgHandler() async {
    // debugPrint('showMsgHandler...');
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        RemoteNotification? notification = message.notification;

        debugPrint("message  ::  "+message.data.toString());

        debugPrint("notification   ::  "+notification!.body.toString());  ///jaydeep_10 Is Going To Live
        debugPrint("title   ::  "+notification!.title.toString());  ///Live Stream
        showMsg(notification!, message.data);
        if (notification!.title.toString() == "Live Stream") {
          Map<String, dynamic> data = json.decode(message.data['live_data'].toString());
          if(data.containsKey('live_data') && data['live_data'] is Map<String, dynamic>) {
            Map<String, dynamic> liveData = data['live_data'];
            final channelName = liveData['channel_name'];
            final agoraToken = liveData['agora_token'];
            final username = liveData['user_data'][0]['username'];

            // Redirect to the live screen after a delay
            // Future.delayed(
            //   const Duration(seconds: 1),
            //       () =>
            //       Get.to(() =>
            //           LiveScreen(
            //             isBroadcaster: true,
            //             appId: appId,
            //             channelName: channelName,
            //             token: agoraToken,
            //             username: username,
            //           )),
            // );
          }
        }
        // if (message.data["type"] == "call") {
        //   showMsg(notification!, message.data);
        //   // debugPrint("-=-=-1=-=-$message");
        //   debugPrint("-=-=-message=-=-  $message");
        //   debugPrint("-=-=-message.data=-=-   ${message.data}");
        //   ///---------------
        //   print("Step -------- 2");
        //   ///regular ringtone play
        //   if (Get.find<VideoController>().inCall.value == false) {
        //     log("went from here ------------ 1");
        //     if (message.data["callType"] == "video") {
        //           // Navigator.push(
        //           // Get.context!,
        //           // MaterialPageRoute(
        //           //   builder: (context) => VideoPreJoiningDialog(
        //           //     callerId: message.data["Sender"],
        //           //     otherUserName: message.data["SenderName"],
        //           //     callId: message.data["callId"],
        //           //     callType: message.data["callType"],
        //           //     isCalling: false,
        //           //     channelName: message.data["channelName"],
        //           //     token: message.data["callToken"],
        //           //     fromSender: true,
        //           //   ),
        //           // ));
        //     } else if (message.data["callType"] == "audio") {
        //       // Navigator.push(
        //       //     Get.context!,
        //       //     MaterialPageRoute(
        //       //       builder: (context) => AudioPreJoiningDialog(
        //       //         otherUserName: message.data["SenderName"],
        //       //         callerId: message.data["Sender"],
        //       //         callType: message.data["callType"],
        //       //         callId: message.data["callId"],
        //       //         isCalling: false,
        //       //         channelName: message.data["channelName"],
        //       //         token: message.data["callToken"],
        //       //         fromSender: true,
        //       //       ),
        //       //     ));
        //
        //     }
        //     else {
        //       log("some error --- ");
        //     }
        //   }
        // }
        // else if (message.data["type"] == "silent") {
        //   log("silent notification");
        //   log("silent notification   $message");
        // }
        // else if (message.data["type"] == "missed_call") {
        //   log("missed_call notification");
        //   log("missed_call notification   $message");
        // }
        // else {
        //   log("-=-===-=-=-=-=-=-=-=");
        // }
      },
      onDone: () {
        debugPrint("remote on tap ++++++++++++++");
      },
      onError: (s, o) {
        debugPrint("remote on tap error+++++++++++++ $o   $s ");
      },
    ).onError((e) {
      debugPrint('Error Notification : ....$e');
    });
  }

  /// handle notification when app in fore ground..
  static void getInitialMsg() {
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      debugPrint('tap on notification =========  ${message}  =======================');
    });
  }

  ///show notification msg
  static void showMsg(RemoteNotification notification, Map<String, dynamic> time) async {
    log("show msg calld -----> ");
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          "high_importance_channel", // id
          'high_importance_channel', // title
          channelDescription: "high_importance_channel",
          // description
          importance: Importance.high,
          priority: Priority.high,
          icon: '@drawable/ic_notification',
          playSound: true,
        ),
      ),
    );
    // await FlutterRingtonePlayer.playNotification();
  }

  ///call when click on notification
  static onMsgOpen() {
    FirebaseMessaging.onMessageOpenedApp.listen(
      (
        RemoteMessage message,
      ) async {
        // isFromNotification = "yes";
        debugPrint("message.notification!.title   ${message.notification!.title}");
        debugPrint("message.notification!.body    ${message.notification!.body}");

        if (message.data != null) {
          log("Step -------- 2");
          log("message.data['type'] -------- ${message.data}");
          log("message.datasss   ${message.data}");
          // if (Get.find<VideoController>().inCall.value == false) {
          //
          //    if (message.data["callType"] == "video") {
          //     // Navigator.push(
          //     //     Get.context!,
          //     //     MaterialPageRoute(
          //     //       builder: (context) => VideoPreJoiningDialog(
          //     //         callerId: message.data["Sender"],
          //     //         otherUserName: message.data["SenderName"],
          //     //         callType: message.data["callType"],
          //     //         callId: message.data["callId"],
          //     //         isCalling: false,
          //     //         channelName: message.data["channelName"],
          //     //         token: message.data["callToken"],
          //     //         fromSender: true,
          //     //       ),
          //     //     ));
          //   } else if (message.data["callType"] == "audio") {
          //     // Navigator.push(
          //     //     Get.context!,
          //     //     MaterialPageRoute(
          //     //       builder: (context) => AudioPreJoiningDialog(
          //     //         callerId: message.data["Sender"],
          //     //         otherUserName: message.data["SenderName"],
          //     //         callType: message.data["callType"],
          //     //         callId: message.data["callId"],
          //     //         isCalling: false,
          //     //         channelName: message.data["channelName"],
          //     //         token: message.data["callToken"],
          //     //         fromSender: true,
          //     //       ),
          //     //     ));
          //   } else {
          //     log("some error --- ");
          //   }
          // }
        }
      },
      onDone: () {
        debugPrint("remote on tap");
      },
      onError: (s, o) {
        debugPrint("remote on tap errro   $s   $o");
      },
    );
  }
}
