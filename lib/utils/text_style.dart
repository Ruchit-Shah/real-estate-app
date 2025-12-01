import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/global/app_color.dart';

import '../view/auth/login_screen/login_screen.dart';
import '../view/auth/register_screen/register_screen.dart';
import '../view/dashboard/view/BottomNavbar.dart';
import '../view/subscription model/Subscription_Screen.dart';


class AppTextStyle {
  static TextStyle regular300 = const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w300,
    color: AppColor.textColor,
  );
  static TextStyle regular400 = const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColor.textColor,
  );

  static TextStyle regular500 = const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColor.textColor,
  );

  static TextStyle regular600 = const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColor.textColor,
  );

  static TextStyle regular700 = const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: AppColor.textColor,
  );
  static TextStyle regular800 = const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w800,
    color: AppColor.textColor,
  );
}

// void LoginView(context) async {
//
//   showModalBottomSheet<void>(
//     //backgroundColor: Colors.white,
//     context: context,
//
//     builder: (BuildContext context) {
//       return Container(
//         height: 300,
//         child: Padding(
//           padding: EdgeInsets.only(
//             bottom: MediaQuery.of(context).viewInsets.bottom,
//             top: MediaQuery.of(context).viewInsets.top,
//             right: 10,
//             left: 10,
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: <Widget>[
//               Row(
//                 children: [
//                   const Expanded(
//                     child: Center(
//                       child: Text(
//                         "",
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ),
//                   IconButton(
//                     icon: const Icon(
//                       Icons.cancel,
//                       size: 30,
//                       color: Colors.red,
//                     ),
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                     },
//                   ),
//                 ],
//               ),
//               const Divider(thickness: 1, color: Colors.grey),
//
//               Padding(
//                 padding: const EdgeInsets.all(10.0),
//                 child: Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Row(
//                         children: [
//                           ClipOval(
//                             child: Image.asset(
//                               'assets/Houzza.png',
//                               height: 60,
//                               width: 60,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//
//                           SizedBox(width: 10),
//                           const Text("Login to Houzza",style: TextStyle(color: Colors.black,fontWeight:
//                           FontWeight.bold,fontSize: 18),),
//                         ],
//                       ),
//
//                       Center(
//                         child: ElevatedButton(
//                           onPressed: () {
//                             Get.off(LoginScreen());
//                           },
//                           style: ElevatedButton.styleFrom(
//                             foregroundColor: Colors.white, backgroundColor: Colors.blueGrey,
//                             padding: EdgeInsets.symmetric(horizontal: 32, vertical: 3),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(30),
//                             ),
//                             textStyle: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                             elevation: 10, // Shadow elevation
//                           ),
//                           child: Text('Login'),
//                         ),
//                       ),
//                       Divider(),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const Text(
//                             'Don\'t have an account? ',
//                             style: TextStyle(fontSize: 14, color: Colors.black),
//                           ),
//
//                           InkWell(
//                             onTap: () {
//                               Get.offAll( LoginScreen());
//                             },
//                             child: const Text(
//                               'Register',
//                               style: TextStyle(
//                                 fontSize: 17,
//                                 color: AppColor.primaryColor,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     },
//   );
// }

void Subscription(BuildContext context,String isfrom,String type) async {
  showDialog<void>(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async {
          Get.offAll(const BottomNavbar());
          return false;
        },
        child: AlertDialog(
          title: const Text(
            "Upgrade Required",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
          content: SizedBox(
            height: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Divider(),
                isfrom=='free' && type =='listing'?
                const Text(
                  "You have utilized all of your free listings. To activate your listings and continue using this feature, please upgrade your plan.",
                  style: TextStyle(color: Colors.black, fontSize: 15),
                  textAlign: TextAlign.center,
                ):isfrom=='paid' && type =='listing'?
                const Text(
                  "You have exceeded the limit for posting property under your current plan. To continue using this feature, please consider upgrading or updating your plan.",
                  style: TextStyle(color: Colors.black, fontSize: 15),
                  textAlign: TextAlign.center,
                ): isfrom=='expired' && type =='listing'?
                const Text( "Your plan has been expired. To activate your plan and continue"
                    " using this feature, please upgrade your plan.", style: TextStyle(color: Colors.black, fontSize: 15),
                  textAlign: TextAlign.center,):SizedBox(),

                isfrom=='free' && type =='contact'?
                const Text(
                  "You have utilized all of your free contact. To activate your plan and continue using this feature, please upgrade your plan.",
                  style: TextStyle(color: Colors.black, fontSize: 15),
                  textAlign: TextAlign.center,
                ): isfrom=='paid' && type =='contact'?
                const Text(
                  "You have exceeded the limit for viewing contacts under your current plan. To continue using this feature, please consider upgrading or updating your plan.",
                  style: TextStyle(color: Colors.black, fontSize: 15),
                  textAlign: TextAlign.center,
                ): isfrom=='expired' && type =='contact'?
                const Text( "Your plan has been expired. To activate your plan and continue using this feature, please upgrade your plan.", style: TextStyle(color: Colors.black, fontSize: 15),
                  textAlign: TextAlign.center,):SizedBox(),


                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Get.offAll(SubscriptionScreen());
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.blueGrey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    elevation: 10, // Shadow elevation
                  ),
                  child: const Text('Upgrade Package'),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}