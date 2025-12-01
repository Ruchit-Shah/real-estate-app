// import 'dart:async';
// import 'package:blissiq_app/Model/studentModel.dart';
// import 'package:blissiq_app/view/chats/ChatDetailsScreen.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:easy_date_timeline/easy_date_timeline.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'dart:typed_data';
// import 'dart:ui' as ui;
// import '../../Controller/ThemeController.dart';
// import 'Controllers/HomeController.dart';
//
// class sectionUI extends StatefulWidget {
//   const sectionUI({super.key});
//
//   @override
//   State<sectionUI> createState() => _sectionUIState();
// }
//

// class _sectionUIState extends State<sectionUI> {
//   GoogleMapController? _mapController;
//   final Completer<GoogleMapController> _controller = Completer();
//
//   final themecontroller controller = Get.find<themecontroller>();
//   late BitmapDescriptor sellerIcon;
//   late BitmapDescriptor customerIcon;
//   late List<LatLng> _userPolyLinesLatLngList;
//
//
//   late Set<Marker> markers;
//   Set<Marker> _markers = {};
//   final HomeController homeController = Get.find<HomeController>();
//   double latitude = 18.564208529754932;
//   double longitude =73.78223237165886;
//
//   Set<Circle> _circles = {};
//
//   final LatLng _circleCenter = const LatLng(18.5, 73.7);
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     // setUserLocation();
//     controller.getGeneratedTheme();
//     _userPolyLinesLatLngList = [];
//     markers = Set<Marker>();
//     customerIcon = BitmapDescriptor.defaultMarker;
//     _addPinLocation();
//     getMarkers().then((markers) {
//       setState(() {
//         _markers = markers;
//       });
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//     return   SingleChildScrollView(
//       child: Column(
//         children: [
//           const SizedBox(height: 10,),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 5.0),
//             child: Obx(()=>
//               Container(
//                 width: Get.width,
//                 height: Get.width * 0.18,
//                 alignment: Alignment.center,
//
//                 decoration: BoxDecoration(
//                   color: controller.Commoncolor.value,
//                   borderRadius: BorderRadius.circular(15),
//                //   color: Color(0xFFF3EBE5),
//                   border: Border.all(
//                     color: controller.Commoncolor.value,
//                   ),
//                 ),
//                 child: const Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 1),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//
//                     children: [
//                       Column(
//                         children: [
//                           Icon(Icons.star,color: Colors.grey,),
//                          // Image.asset('assets/star.png', width: 25,height: 25,),
//                           Text(
//                             'Points',
//                             style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),
//                           ),
//                           Text('500',   style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),),
//                         ],
//                       ),
//                       Column(
//                         children: [
//
//                           Icon(Icons.auto_graph_sharp,color: Colors.grey,),
//                            //Image.asset('assets/internet.png', width: 25,height: 25,),
//                           Text(
//                             'All Over India Rank',
//                             style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),
//                           ),
//                           Text('#114',   style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),),
//                         ],
//                       ),
//                       Column(
//                         children: [
//                           Icon(Icons.stacked_bar_chart,color: Colors.grey,),
//                       //    Image.asset('assets/star.png', width: 25,height: 25,),
//                           Text(
//                             'Local Rank',
//                             style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),
//                           ),
//                           Text('#50',   style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),),
//                         ],
//                       ),
//
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 4.0),
//             child: Obx(()=>
//                Container(
//                 width: Get.width,
//                 height: 110,
//                  color: controller.bgcolor.value,
//                 child: Obx(
//                       () => EasyDateTimeLine(
//                         initialDate: DateTime.now(),
//                         onDateChange: (selectedDate) {},
//                         activeColor:controller.pallet_name.value=='pallet_1'?
//                           controller.buttonColor.value.withOpacity(0.9):
//              //     controller.buttonColor.value,
//                         controller.buttonColor.value,
//                         headerProps: EasyHeaderProps(
//                           dateFormatter: DateFormatter.monthOnly(),
//                           showMonthPicker: true,
//
//                           showSelectedDate: true,
//                           selectedDateStyle: TextStyle(
//                             color: controller.textColor.value,
//                             fontWeight: FontWeight.bold,
//                           ),
//                           monthStyle: TextStyle(
//                             color: controller.textColor.value,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         dayProps: EasyDayProps(
//                           height: 45.0,
//                           width: 45.0,
//                           dayStructure: DayStructure.dayNumDayStr,
//                           inactiveDayStyle: DayStyle(
//                             decoration: BoxDecoration(
//                               color:controller.pallet_name.value=='pallet_1'?
//                               controller.buttonColor.value.withOpacity(0.4):
//                               controller.buttonColor.value,
//                             //  controller.buttonColor.value.withOpacity(0.9),
//                               borderRadius: BorderRadius.circular(15),
//                             ),
//                             dayStrStyle: TextStyle(
//                               color: controller.textColor.value.withOpacity(0.6),
//                               fontSize: 10,
//                             ),
//                             dayNumStyle: TextStyle(
//                               color: controller.textColor.value.withOpacity(0.6),
//                               fontSize: 18.0,
//                             ),
//                           ),
//                           activeDayStyle: DayStyle(
//                             dayNumStyle: TextStyle(
//                               fontSize: 18.0,
//                               color: controller.textColor.value,
//                               fontWeight: FontWeight.bold,
//                             ),
//                             dayStrStyle: TextStyle(
//                               color: controller.textColor.value.withOpacity(0.6),
//                               fontSize: 10,
//                             ),
//                           ),
//                         ),
//                       ),
//
//
//                   //   EasyDateTimeLine(
//                   //   initialDate: DateTime.now(),
//                   //   onDateChange: (selectedDate) {
//                   //   },
//                   //   activeColor: controller.buttonColor.value,
//                   //   headerProps: const EasyHeaderProps(
//                   //     dateFormatter: DateFormatter.monthOnly(),
//                   //   ),
//                   //   dayProps: EasyDayProps(
//                   //     height: 45.0,
//                   //     width: 45.0,
//                   //     dayStructure: DayStructure.dayNumDayStr,
//                   //     inactiveDayStyle: DayStyle(
//                   //       decoration: BoxDecoration(
//                   //        // color: Colors.orange.shade50,
//                   //         color: controller.buttonColor.value.withOpacity(0.7),
//                   //         borderRadius: BorderRadius.circular(15),
//                   //       ),
//                   //       dayNumStyle: const TextStyle(
//                   //         fontSize: 18.0,
//                   //       ),
//                   //     ),
//                   //     activeDayStyle: const DayStyle(
//                   //       dayNumStyle: TextStyle(
//                   //         fontSize: 18.0,
//                   //         color: Colors.white,
//                   //         fontWeight: FontWeight.bold,
//                   //       ),
//                   //     ),
//                   //   ),
//                   // ),
//                 ),
//               ),
//             ),
//           ),
//
//           // EasyDateTimeLine(
//           //   initialDate: DateTime.now(),
//           //   onDateChange: (selectedDate) {
//           //     // Handle date change
//           //   },
//           //   activeColor: const Color(0xffFFBF9B),
//           //   headerProps: const EasyHeaderProps(
//           //     dateFormatter: DateFormatter.monthOnly(),
//           //   ),
//           //   dayProps: const EasyDayProps(
//           //     height: 45.0,
//           //     width: 45.0,
//           //     dayStructure: DayStructure.dayNumDayStr,
//           //     inactiveDayStyle: DayStyle(
//           //       decoration: BoxDecoration(
//           //           color: Colors.green
//           //       ),
//           //       borderRadius: 48.0,
//           //       dayNumStyle: TextStyle(
//           //         fontSize: 18.0,
//           //         color: Colors.grey,
//           //       ),
//           //     ),
//           //     activeDayStyle: DayStyle(
//           //       dayNumStyle: TextStyle(
//           //         fontSize: 18.0,
//           //         fontWeight: FontWeight.bold,
//           //       ),
//           //     ),
//           //   ),
//           // ),
//
//           const SizedBox(height: 10,),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 25.0,),
//             child: Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const SizedBox(height: 5,),
//                     Column(
//                       children: [
//                         Obx(()=>
//                            Container(
//                             width: 55,
//                             decoration:   BoxDecoration(
//                               borderRadius: const BorderRadius.all(Radius.circular(25)),
//                               //  D0D7EF
//                               color:controller.bottomNavBarColor.value,
//                             //  color:controller.bottomNavBarColor.value.withOpacity(0.3),
//                             ),
//                             child: const Padding(
//                               padding: EdgeInsets.all(5.0),
//                               child:        Center(
//                                 child: Text(
//                                   '8:30',
//                                   style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 13),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 25,),
//                         Container(
//                           width: 55,
//                           decoration:  const BoxDecoration(
//                             borderRadius:  BorderRadius.all(Radius.circular(25)),
//
//                           ),
//                           child:  Padding(
//                             padding: EdgeInsets.all(5.0),
//                             child:        Center(
//                               child: Obx(()=>
//                               Text(
//                                   '9:30',
//                                   style: TextStyle(color: controller.textColor.value, fontWeight: FontWeight.w500, fontSize: 13),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 25,),
//                         Container(
//                           width: 55,
//                           decoration:  const BoxDecoration(
//                             borderRadius: BorderRadius.all(Radius.circular(25)),
//
//                           ),
//                           child:  Padding(
//                             padding: EdgeInsets.all(5.0),
//                             child:        Center(
//                               child: Obx(()=>
//                                 Text(
//                                   '10:00',
//                                   style: TextStyle(color: controller.textColor.value, fontWeight: FontWeight.w500, fontSize: 13),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 25,),
//                         Container(
//                           width: 55,
//                           decoration:  const BoxDecoration(
//                             borderRadius: BorderRadius.all(Radius.circular(25)),
//
//                           ),
//                           child:  Padding(
//                             padding: EdgeInsets.all(5.0),
//                             child:        Center(
//                               child: Obx(()=>
//                                  Text(
//                                   '10:30',
//                                   style: TextStyle(color: controller.textColor.value, fontWeight: FontWeight.w500, fontSize: 13),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const Divider(color: Colors.black45,thickness: 1,),
//                     const SizedBox(width: 3),
//                     Expanded(
//                       child: GestureDetector(
//                         onTap: (){
//                           VideoCallPopUp('video');
//                         },
//                         child: Obx(()=>
//                            Container(
//                             width: Get.width,
//                             decoration:  BoxDecoration(
//                               borderRadius: BorderRadius.all(Radius.circular(25)),
//                              // color:Color(0xFFD0D7EF),
//                               color:controller.bottomNavBarColor.value,
//                              // color:controller.bottomNavBarColor.value.withOpacity(0.5)
//                             ),
//                             margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
//                             child: Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Row(
//                                     children: [
//                                       Container(
//                                         decoration: const BoxDecoration(
//                                           borderRadius: BorderRadius.all(Radius.circular(25)),
//                                           color: Colors.white,
//                                         ),
//                                         child: const Padding(
//                                           padding: EdgeInsets.all(13.0),
//                                           child: Row(
//                                             children: [
//                                               Icon(Icons.calendar_month, size: 18),
//                                               SizedBox(width: 5),
//                                               Text(
//                                                 '8:30 - 10:00 AM',
//                                                 style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 12),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                       Container(
//                                         decoration: BoxDecoration(
//                                           borderRadius: const BorderRadius.all(Radius.circular(50)),
//                                           color:controller.bottomNavBarColor.value,
//                                        //   Color(0xFFD0D7EF),
//                                           border: Border.all(color: Colors.white, width: 3),
//                                         ),
//                                         child: const Padding(
//                                           padding: EdgeInsets.all(8.0),
//                                           child: Icon(Icons.check),
//                                         ),
//                                       ),
//                                       const Spacer(),
//                                       Container(
//                                         decoration:  BoxDecoration(
//                                           borderRadius: BorderRadius.all(Radius.circular(50)),
//                                           color:controller.bottomNavBarColor.value,
//                                         ),
//                                         child: const Padding(
//                                           padding: EdgeInsets.all(8.0),
//                                           child: Icon(Icons.arrow_forward_ios),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   const SizedBox(height: 5),
//                                   const Text(
//                                     'Vocabulary Session - Grammar Class ',
//                                     style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 18),
//                                   ),
//                                   RichText(
//                                     text: const TextSpan(
//                                       style: TextStyle(color: Colors.black87, fontSize: 15),
//                                       children: [
//                                         TextSpan(
//                                           text: 'by ',
//                                           style: TextStyle(color: Colors.black45),
//                                         ),
//                                         TextSpan(
//                                           text: 'Sam Ritch',
//                                           style: TextStyle(color: Colors.black87),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   const SizedBox(height: 5),
//
//
//                                   Row(
//                                     children: [
//                                       Expanded(
//                                         child: Container(
//                                           decoration: BoxDecoration(
//                                             borderRadius: const BorderRadius.all(Radius.circular(25)),
//                                             color: Colors.red.shade100,
//                                             // border: Border.all(color: Colors.red, width: 1),
//                                           ),
//                                           child: const Padding(
//                                             padding: EdgeInsets.all(10.0),
//                                             child: Text(
//                                               'Your mentor will call you at 8:30 AM.',
//                                               style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 11.50),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 5),
//                                       // Expanded(
//                                       //   child: Container(
//                                       //     decoration: BoxDecoration(
//                                       //       borderRadius: const BorderRadius.all(Radius.circular(25)),
//                                       //       border: Border.all(color: Colors.black, width: 1),
//                                       //     ),
//                                       //     child: const Padding(
//                                       //       padding: EdgeInsets.all(10.0),
//                                       //       child: Row(
//                                       //         mainAxisAlignment: MainAxisAlignment.center,
//                                       //         crossAxisAlignment: CrossAxisAlignment.center,
//                                       //         children: [
//                                       //           Icon(Icons.flash_on, size: 18),
//                                       //           SizedBox(width: 5),
//                                       //           Text(
//                                       //             'Intensive',
//                                       //             style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 12),
//                                       //           ),
//                                       //         ],
//                                       //       ),
//                                       //     ),
//                                       //   ),
//                                       // ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 25,),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const SizedBox(height: 5,),
//                     Column(
//                       children: [
//                         Obx(()=>
//                            Container(
//                             width: 55,
//                             decoration:   BoxDecoration(
//                               borderRadius: BorderRadius.all(Radius.circular(25)),
//                            //  color:controller.appBarColor.value.withOpacity(0.3),
//                               color:controller.appBarColor.value,
//                             ),
//                             child: const Padding(
//                               padding: EdgeInsets.all(5.0),
//                               child:        Center(
//                                 child: Text(
//                                   '11:00',
//                                   style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 13),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 25,),
//                         Container(
//                           width: 55,
//                           decoration:  const BoxDecoration(
//                             borderRadius:  BorderRadius.all(Radius.circular(25)),
//
//                           ),
//                           child:  Padding(
//                             padding: EdgeInsets.all(5.0),
//                             child:        Center(
//                               child: Obx(()=>
//                                   Text(
//                                     '11:30',
//                                     style: TextStyle(color: controller.textColor.value, fontWeight: FontWeight.w500, fontSize: 13),
//                                   ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 25,),
//                         Container(
//                           width: 55,
//                           decoration:  const BoxDecoration(
//                             borderRadius: BorderRadius.all(Radius.circular(25)),
//
//                           ),
//                           child:  Padding(
//                             padding: EdgeInsets.all(5.0),
//                             child:        Center(
//                               child: Obx(()=>
//                                   Text(
//                                     '12:00',
//                                     style: TextStyle(color: controller.textColor.value, fontWeight: FontWeight.w500, fontSize: 13),
//                                   ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 25,),
//                         Container(
//                           width: 55,
//                           decoration:  const BoxDecoration(
//                             borderRadius: BorderRadius.all(Radius.circular(25)),
//
//                           ),
//                           child:  Padding(
//                             padding: EdgeInsets.all(5.0),
//                             child:        Center(
//                               child: Obx(()=>
//                                   Text(
//                                     '12:30',
//                                     style: TextStyle(color: controller.textColor.value, fontWeight: FontWeight.w500, fontSize: 13),
//                                   ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const Divider(color: Colors.black45,thickness: 1,),
//                     const SizedBox(width: 3),
//                     Expanded(
//                       child: GestureDetector(
//                         onTap: (){
//                           VideoCallPopUp('chat');
//                           },
//                         child: Obx(()=>
//                            Container(
//                             width: Get.width,
//                             decoration:  BoxDecoration(
//                               borderRadius: BorderRadius.all(Radius.circular(25)),
//                               // #C3DADE
//                                // color:controller.appBarColor.value.withOpacity(0.4)
//                                 color:controller.appBarColor.value,
//
//                             ),
//                             margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
//                             child: Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Row(
//                                     children: [
//                                       Container(
//                                         decoration: const BoxDecoration(
//                                           borderRadius: BorderRadius.all(Radius.circular(25)),
//                                           color: Colors.white,
//                                         ),
//                                         child: const Padding(
//                                           padding: EdgeInsets.all(13.0),
//                                           child: Row(
//                                             children: [
//                                               Icon(Icons.calendar_month, size: 18),
//                                               SizedBox(width: 5),
//                                               Text(
//                                                 '8:30 - 10:00 AM',
//                                                 style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 12),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                       Container(
//                                         decoration: BoxDecoration(
//                                           borderRadius: const BorderRadius.all(Radius.circular(50)),
//                                           color:controller.appBarColor.value.withOpacity(0.5),
//                                           border: Border.all(color: Colors.white, width: 3),
//                                         ),
//                                         child: const Padding(
//
//                                           padding: EdgeInsets.all(8.0),
//                                           child: Icon(Icons.check),
//                                         ),
//                                       ),
//                                       const Spacer(),
//                                       Container(
//                                         decoration:  BoxDecoration(
//                                           borderRadius: BorderRadius.all(Radius.circular(50)),
//                                           color:controller.appBarColor.value.withOpacity(0.5),
//                                         ),
//                                         child: const Padding(
//                                           padding: EdgeInsets.all(8.0),
//                                           child: Icon(Icons.arrow_forward_ios),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   const SizedBox(height: 5),
//                                   const Text(
//                                     'Pronoun Session - Grammar Class ',
//                                     style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 18),
//                                   ),
//                                   const SizedBox(height: 5),
//                                   RichText(
//                                     text: const TextSpan(
//                                       style: TextStyle(color: Colors.black87, fontSize: 15),
//                                       children: [
//                                         TextSpan(
//                                           text: 'by ',
//                                           style: TextStyle(color: Colors.black45),
//                                         ),
//                                         TextSpan(
//                                           text: 'Vitaliy Rusiy',
//                                           style: TextStyle(color: Colors.black87),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   const SizedBox(height: 5),
//                                   Row(
//                                     children: [
//                                       Expanded(
//                                         child: Container(
//                                           decoration: BoxDecoration(
//                                             borderRadius: const BorderRadius.all(Radius.circular(25)),
//                                             border: Border.all(color: Colors.black, width: 1),
//                                           ),
//                                           child: const Padding(
//                                             padding: EdgeInsets.all(10.0),
//                                             child: Row(
//                                               mainAxisAlignment: MainAxisAlignment.center,
//                                               crossAxisAlignment: CrossAxisAlignment.center,
//                                               children: [
//                                                 Icon(Icons.access_time, size: 18),
//                                                 SizedBox(width: 5),
//                                                 Text(
//                                                   '1h 30m',
//                                                   style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 12),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 5),
//                                       Expanded(
//                                         child: Container(
//                                           decoration: BoxDecoration(
//                                             borderRadius: const BorderRadius.all(Radius.circular(25)),
//                                             border: Border.all(color: Colors.black, width: 1),
//                                           ),
//                                           child: const Padding(
//                                             padding: EdgeInsets.all(10.0),
//                                             child: Row(
//                                               mainAxisAlignment: MainAxisAlignment.center,
//                                               crossAxisAlignment: CrossAxisAlignment.center,
//                                               children: [
//                                                 Icon(Icons.flash_on, size: 18),
//                                                 SizedBox(width: 5),
//                                                 Text(
//                                                   'Intensive',
//                                                   style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 12),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 5,),
//           _UpcomingCourses(),
//           const SizedBox(height: 5,),
//           Center(
//             child: Container(
//             margin:   const EdgeInsets.only(
//                 bottom: 40.0,
//               right: 10,
//               left: 5,top: 5
//               ),
//               decoration: BoxDecoration(
//                // shape: BoxShape.circle,
//                 border: Border.all(
//                   color: Color(0xFFC3DADE),
//                   width: 2,
//                 ),
//               ),
//               child: SizedBox(
//                 width: 400,
//                 height: 400,
//                 child: GoogleMap(
//                   buildingsEnabled:false ,
//                   trafficEnabled: false,
//                   mapToolbarEnabled: false,
//
//                   //  circles: _circles,
//                   onMapCreated: (GoogleMapController controller) {
//                     _mapController = controller;
//                     _controller.complete(controller);
//                   },
//                   zoomGesturesEnabled: true,
//                   initialCameraPosition: CameraPosition(
//                     target: LatLng(latitude, longitude),
//                     zoom: 13.50,
//                   ),
//                   mapType: MapType.normal,
//                   myLocationEnabled: true,
//                   zoomControlsEnabled: true,
//                   myLocationButtonEnabled: true,
//                   onTap: (LatLng latLng) {
//
//                   },
//                   markers: _markers,
//
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 10,),
//         ],
//       ),
//     );
//   }
//   Widget _UpcomingCourses() {
//     final List<String> labels = ["Toddler", "Conversational", "Grammar"];
//
//     return Obx(
//       ()=> Container(
//         width: Get.width,
//         padding: const EdgeInsets.all(10),
//         decoration: BoxDecoration(
//           color: controller.bgcolor.value,
//           border: Border.all(color: Colors.grey.shade300),
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Column(
//           children: [
//             // Label Selector
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: List.generate(
//                 labels.length,
//                     (index) => GestureDetector(
//                   onTap: () {
//                     // Update selected index reactively
//                     homeController.selectedIndex.value = index;
//                   },
//                   child: Obx(
//                         () => Container(
//                       padding:
//                       const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//                       decoration: BoxDecoration(
//                         color: homeController.selectedIndex.value == index
//                             ? controller.Commoncolor.value.withOpacity(0.8).withOpacity(0.2)
//                             : Colors.white,
//                         borderRadius: BorderRadius.circular(8),
//                         border: Border.all(
//                           color: homeController.selectedIndex.value == index
//                               ?controller.Commoncolor.value
//                               : Colors.grey.shade300,
//                         ),
//                       ),
//                       child: Text(
//                         labels[index],
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: homeController.selectedIndex.value == index
//                               ? Colors.black
//                               : Colors.grey.shade600,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//
//             // Carousel
//             Obx(
//                   () => CarouselSlider(
//                 options: CarouselOptions(
//                   height: 200.0,
//                   enlargeCenterPage: true,
//                   enableInfiniteScroll: true,
//                   autoPlay: true,
//                   autoPlayInterval: const Duration(seconds: 3),
//                 ),
//                 items: homeController.cardItems[homeController.selectedIndex.value].map((item) {
//                   return Builder(
//                     builder: (BuildContext context) {
//                       return Card(
//                         elevation: 4,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: Container(
//                           width: MediaQuery.of(context).size.width * 0.8,
//                           alignment: Alignment.center,
//                           padding: const EdgeInsets.all(20),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10),
//                             image: DecorationImage(
//                               image: AssetImage(item['image'] ?? ''), // Using the image path from the map
//                               fit: BoxFit.cover, // Ensure the image covers the container
//                             ),
//                           ),
//                           child: Container(
//                             padding: const EdgeInsets.all(10),
//                             decoration: BoxDecoration(
//                               color: Colors.black.withOpacity(0.5), // Semi-transparent black background
//                               borderRadius: BorderRadius.circular(8), // Rounded corners for the text box
//                             ),
//                             child: Text(
//                               item['text'] ?? '', // Using the text from the map
//                               style: const TextStyle(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.white, // Text color
//                               ),
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                 }).toList(),
//               ),
//             )
//
//           ],
//         ),
//       ),
//     );
//   }
//   // setMarkerIcons() async {
//   //   customerIcon = await BitmapDescriptor.fromAssetImage(
//   //       const ImageConfiguration(
//   //         devicePixelRatio: 2.5,
//   //       ),
//   //       'assets/propertis.png');
//   //
//   //   if (this.mounted) {
//   //     setState(() {});
//   //   }
//   // }
//   Future<Uint8List> getBytesFromAsset(String path, int width) async {
//     ByteData data = await rootBundle.load(path);
//     ui.Codec codec =
//     await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
//     ui.FrameInfo fi = await codec.getNextFrame();
//     return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
//   }
//   Future<Set<Marker>> getMarkers() async {
//     Set<Marker> markers = {};
//
//     for (var user in initialUsersPoints) {
//       final Uint8List markerIcon = await getBytesFromAsset( user.iconPath, 80);
//
//
//       markers.add(Marker(
//         markerId: MarkerId(user.id.toString()),
//         position: LatLng(user.latitude, user.longitude),
//         infoWindow: InfoWindow(
//           title: user.name,
//           snippet: 'Student',
//         ),
//         icon:  BitmapDescriptor.fromBytes(markerIcon),
//       ));
//     }
//
//     return markers;
//   }
//
//   // Set<Marker> getMarkers() {
//   //   return {
//   //     Marker(
//   //       markerId: MarkerId('marker_1'),
//   //       position: LatLng(latitude, longitude),
//   //       infoWindow: InfoWindow(
//   //         title: 'San Francisco',
//   //         snippet: 'A beautiful city!',
//   //       ),
//   //       icon: BitmapDescriptor.defaultMarker,
//   //     ),
//   //   };
//   // }
//   void _addPinLocation() {
//     _markers.add(
//       Marker(
//         markerId: const MarkerId('pinLocation'), // unique ID
//         position: LatLng(latitude, longitude), // Pin location
//         infoWindow: const InfoWindow(
//           title: 'Pin Location',
//           snippet: 'This is the pin location.',
//         ),
//      //   icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
//         icon: BitmapDescriptor.defaultMarker,
//       ),
//     );
//   }
//
//   void VideoCallPopUp(String isFrom) async {
//     await showDialog(
//       context: context,
//
//       barrierDismissible: true,
//       builder: (BuildContext context) {
//         return Dialog(
//           backgroundColor: Colors.purple.shade50,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10.0),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Row(
//                   children: [
//                     const Expanded(
//                       child: Text(
//                         "",
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     IconButton(
//                       icon: const Icon(
//                         Icons.cancel,
//                         size: 30,
//                         color: Colors.red,
//                       ),
//                       onPressed: () {
//                         Navigator.of(context).pop();
//                       },
//                     ),
//                   ],
//                 ),
//                 CircleAvatar(
//                   radius: 45,
//                   backgroundColor: Colors.grey[300],
//                   backgroundImage: const AssetImage('assets/profile.png'),
//                 ),
//                 const SizedBox(height: 5),
//                 const Text(
//                   "Sam Ritch",
//                   style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
//                 ),
//                 const Text(
//                   "@Grammar Mentor",
//                   style: TextStyle(fontSize: 15,),
//                 ),
//                 const Divider(),
//                 const SizedBox(height: 5),
//                 Container(
//                   decoration: BoxDecoration(
//                     color: Colors.amber.shade100.withOpacity(0.6),
//                     borderRadius: BorderRadius.circular(15),
//                     border: Border.all(color: Colors.amber.shade200),
//                   ),
//                   child:  Padding(
//                     padding: EdgeInsets.all(8.0),
//                     child: Text(
//                       isFrom=='video'?
//                       "Video call scheduled for 27th November 2024 at 8:30 AM.":
//         "Chat scheduled for 27th November 2024 at 8:30 AM.You can leave a message meanwhile.",
//                       style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 ),
//                 const Divider(),
//                 const SizedBox(height: 5),
//                 ElevatedButton(
//         onPressed: () {
//         if(isFrom=='video'){
//         Navigator.of(context).pop();
//         }
//         Navigator.of(context).pop();
//         Get.to(ChatDetailsScreen());
//         },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green,
//                   ),
//                   child: const Text('OK',style: TextStyle(color: Colors.white),),
//                 ),
//                 const SizedBox(height: 5),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//
//
// }
