import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:real_estate_app/Routes/app_pages.dart';
import 'package:real_estate_app/utils/initilizer.dart';
import 'package:real_estate_app/utils/notification/app_notification.dart';
import 'package:real_estate_app/view/dashboard/view/Provider/BotProvider.dart';
import 'view/dashboard/bottom_navbar_screens/profile_screen/profile_controller.dart';
import 'view/dashboard/deshboard_controllers/bottom_bar_controller.dart';

import 'package:country_code_picker/country_code_picker.dart';
import 'view/property_screens/properties_controllers/PropertySearchLocationProvider.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message)async {
  await Firebase.initializeApp();
}
void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  Get.put(BottomBarController());


  await Firebase.initializeApp();
  AppNotificationHandler.firebaseNotificationSetup();
  AppNotificationHandler.getInitialMsg();
  AppNotificationHandler.showMsgHandler();
  AppNotificationHandler.onMsgOpen();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  getXPutInitializer();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => PropertySearchLocationProvider()),
        ChangeNotifierProvider(create: (_) => BotProvider()),],
      child: MyApp()));
}



class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    checkPermission();
  }

  checkPermission() async {
    var status = await Permission.notification.status;

    try {
      if (status.isGranted) {
        debugPrint("permission allowed");
        // Notification permission granted
      }
      else if (status.isDenied) {
        PermissionStatus requestStatus = await Permission.notification.request();

        if (requestStatus.isGranted) {
          // Permission granted by the user
          debugPrint("Permission granted");
        } else {
          // Permission denied by the user
          debugPrint("Permission denied");
        }
        // Notification permission denied
      }
      else if (status.isPermanentlyDenied) {
        // Notification permission permanently denied, take user to app settings
        await openAppSettings();
      }
    } on Exception catch (e) {
      print("Notification permission Error $e");
    }
  }

  @override
  Widget build(BuildContext context,) {
    return ScreenUtilInit(
     designSize:  Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height) ,
     minTextAdapt: true,
     splitScreenMode: false,
     child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
       supportedLocales: const [
         Locale('en'),
       ],
       localizationsDelegates: const [
         CountryLocalizations.delegate,
       ],
        title: 'Houzza',
        initialRoute: Routes.splash,
        getPages: AppPages.routes,
      ),
   );
  }

}
