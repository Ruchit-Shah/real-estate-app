import 'package:flutter/material.dart';
import 'package:real_estate_app/global/AppBar.dart';
import 'package:real_estate_app/global/app_color.dart';
import 'package:real_estate_app/global/constant.dart';

 class MyTransactionScreen extends StatefulWidget {
   const MyTransactionScreen({super.key});

   @override
   State<MyTransactionScreen> createState() => _MyTransactionScreenState();
 }

 class _MyTransactionScreenState extends State<MyTransactionScreen> {
   @override
   Widget build(BuildContext context) {
     return Scaffold(
       // appBar: AppBar(
       //   backgroundColor: AppColor.grey.withOpacity(0.1),
       //   automaticallyImplyLeading: false,
       //   leading: IconButton(
       //     onPressed: (){
       //       Navigator.pop(context);
       //     },
       //     icon: Icon(Icons.arrow_back, color: Colors.black.withOpacity(0.7),),
       //   ),
       //   title: Text('My Transactions', style: TextStyle(
       //     fontSize: 20,
       //     fontWeight: FontWeight.bold,
       //     color: Colors.black.withOpacity(0.7),
       //     fontFamily: 'Roboto',
       //   ),),
       // ),
         appBar: appBar(titleName: my_transactions,
           onTap: () {
             Navigator.pop(context);
           },),
       body: Center(child: Text('Their is no Transaction on yet'))
     );
   }
 }
