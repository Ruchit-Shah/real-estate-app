// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:real_estate_app/view/dashboard/view/BottomNavbar.dart';
//
// class OTPScreen extends StatefulWidget {
//   @override
//   _OTPScreenState createState() => _OTPScreenState();
// }
//
// class _OTPScreenState extends State<OTPScreen> {
//   late TextEditingController _otpController;
//
//   @override
//   void initState() {
//     super.initState();
//     _otpController = TextEditingController();
//   }
//
//   @override
//   void dispose() {
//     _otpController.dispose();
//     super.dispose();
//   }
//
//   List<FocusNode> focusNodes = List<FocusNode>.generate(4, (index) => FocusNode());
//
//   void _verifyOTP() {
//     String enteredOTP = _otpController.text;
//     if (enteredOTP.isNotEmpty && enteredOTP.length == 4) {
//       Fluttertoast.showToast(
//         msg: 'Verify OTP is Successfully',
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//         backgroundColor: Colors.green,
//         textColor: Colors.white,
//       );
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) {
//           return BottomNavbar();
//         }),
//       );
//     } else {
//       Fluttertoast.showToast(
//         msg: 'Enter a verification code',
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//         backgroundColor: Colors.grey.shade500,
//         textColor: Colors.white,
//       );
//       print('Entered OTP: $enteredOTP');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(10.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Column(
//                 children: [
//                   Text(
//                     'Verification Code',
//                     style: TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black,
//                     ),
//                   ),
//                   SizedBox(height: 5),
//                   Text(
//                     'OTP sent to your mobile number',
//                     style: TextStyle(
//                       color: Colors.blue,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ],
//               ),
//               Divider(thickness: 1.5),
//               SizedBox(height: 20),
//               Text(
//                 'Enter OTP',
//                 style: TextStyle(
//                   color: Colors.black.withOpacity(0.7),
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18,
//                 ),
//               ),
//               SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: List.generate(4, (index) {
//                   return SizedBox(
//                     width: 50,
//                     child: TextFormField(
//                       focusNode: focusNodes[index],
//                       inputFormatters: [
//                         LengthLimitingTextInputFormatter(1),
//                         FilteringTextInputFormatter.digitsOnly,
//                       ],
//                       keyboardType: TextInputType.number,
//                       textAlign: TextAlign.center,
//                       cursorColor: Colors.grey,
//                       decoration: InputDecoration(
//                         filled: true,
//                         fillColor: Colors.white,
//                         focusedBorder: OutlineInputBorder(
//                           borderSide: BorderSide(color: Colors.black),
//                         ),
//                         border: OutlineInputBorder(
//                           borderSide: BorderSide(color: Colors.grey),
//                         ),
//                       ),
//                       onChanged: (value) {
//                         if (value.length == 1 && index < 3) {
//                           FocusScope.of(context).requestFocus(focusNodes[index + 1]);
//                         }
//                         if (value.isEmpty && index > 0) {
//                           FocusScope.of(context).requestFocus(focusNodes[index - 1]);
//                         }
//                       },
//                     ),
//                   );
//                 }),
//               ),
//               SizedBox(height: 30),
//               Container(
//                 height: 50,
//                 width: MediaQuery.of(context).size.width * 0.8,
//                 decoration: BoxDecoration(
//                   color: Colors.blue,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: TextButton(
//                   onPressed: _verifyOTP,
//                   child: Text(
//                     'VERIFY OTP',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   TextButton(
//                     onPressed: () {},
//                     child: Text(
//                       'Resend OTP',
//                       style: TextStyle(
//                         color: Colors.blue,
//                         fontSize: 15,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               Divider(thickness: 1.5),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
