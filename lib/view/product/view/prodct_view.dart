// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/common_widgets/height.dart';
import 'package:real_estate_app/global/app_color.dart';
import 'package:real_estate_app/global/services/api_shorts_string.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../global/theme/app_text_style.dart';
import '../../all_products/controller/look_book_setting_controller.dart';
import '../../look_book/view/add_enquiry.dart';
import '../../shorts/controller/my_profile_controller.dart';
import '../controller/product_controller.dart';

class ProductScreen extends StatefulWidget {
  var productData;
  int? selectedProduct;
  int? selectedLookBook;
  String? user_contact;
  ProductScreen(
      {super.key,
      this.selectedProduct,
      this.selectedLookBook,
      this.productData,
      this.user_contact
      });
  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  // lookBookSettingController.lookbookList
  final scrollbar = ScrollController();
  final controller = Get.find<ProductController>();
  final lookBookSettingController = Get.find<LookBookSettingController>();


  bool get isProductUploadedByUser {
    final productUserId = lookBookSettingController.lookbookList[widget.selectedLookBook!]["productLookbook"]
    [controller.selectedIndex.value]["product_data"]["user_id"];

    print('productUserId-->${productUserId}');
    final currentUserId = Get.find<MyProfileController>().userId.value;
    return productUserId == currentUserId;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var mobileNumber = widget.user_contact.toString();
    if (kDebugMode) {
      print('mobile PNUmberr:- $mobileNumber');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.transparent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              width: Get.width * 0.9,
              // height: Get.height * 0.6,
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: Scrollbar(
                controller: scrollbar,
                trackVisibility: true,
                interactive: true,
                thumbVisibility: true,
                thickness: 10,
                radius: const Radius.circular(10),
                child: SingleChildScrollView(
                  controller: scrollbar,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                                onPressed: () {
                                  Get.back();
                                },
                                icon: const Icon(Icons.arrow_back)),
                            SizedBox(
                              width: Get.width * 0.65,
                              child: Text(
                                "In this Catalogue",
                                style: AppTextStyle.medium.copyWith(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                        boxH10(),
                        Align(
                          alignment: Alignment.topRight,
                          child: Visibility(
                            // visible: !isProductUploadedByUser,
                            visible: true,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: _makePhoneCall,
                                  icon: Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        colors: [Colors.blueAccent, Colors.lightBlue],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 10,
                                          offset: Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Colors.transparent,
                                      child: Image.asset(
                                        'assets/call.png',
                                        height: 30,
                                        width: 30,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20),
                                GestureDetector(
                                  onTap: () {
                                    print('other user_id : ' + lookBookSettingController.lookbookList[widget.selectedLookBook!]["productLookbook"][controller.selectedIndex.value]["product_data"]["user_id"]);
                                    print('product id: ' + lookBookSettingController.lookbookList[widget.selectedLookBook!]["productLookbook"][controller.selectedIndex.value]["product_data"]["_id"]);

                                    var other_userId = lookBookSettingController.lookbookList[widget.selectedLookBook!]["productLookbook"][controller.selectedIndex.value]["product_data"]["user_id"];
                                    var product_id = lookBookSettingController.lookbookList[widget.selectedLookBook!]["productLookbook"][controller.selectedIndex.value]["product_data"]["_id"];
                                    String mobileNumber = widget.user_contact.toString();
                                    print('mobileNumber: $mobileNumber');
                                    Get.to(() => AddEnquiry(productId: product_id, otherUserId: other_userId));
                                  },
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 10),
                                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                                      decoration: BoxDecoration(
                                          color: AppColor.black,
                                          border: Border.all(color: AppColor.black)),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.shopping_bag,
                                            color: AppColor.white,
                                          ),
                                          Text(
                                            " Add Enquiry",
                                            style: AppTextStyle.regular.copyWith(
                                                fontSize: 14,
                                                color: AppColor.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        boxH10(),
                        SizedBox(
                          height: 80,
                          child: ListView.builder(
                            padding: const EdgeInsets.only(left: 10),
                            scrollDirection: Axis.horizontal,
                            itemCount: lookBookSettingController
                                .lookbookList[widget.selectedLookBook!]
                                    ["productLookbook"]
                                .length,

                            itemBuilder: (context, index) {
                              print(
                                  "lookBookSettingController.lookbookList  ${lookBookSettingController.lookbookList[widget.selectedLookBook!]}");
                              var data = lookBookSettingController
                                      .lookbookList[widget.selectedLookBook!]
                                  ["productLookbook"][index]["product_data"];

                              return GestureDetector(
                                onTap: () {
                                  print("On tab of hozza");
                                  print("  ${controller.initialized}");
                                  setState(() {
                                    controller.setSelectedIndex(index);
                                  });

                                },
                                child: Obx(
                                  () => Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    height: 80,
                                    width: 80,
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color:
                                              controller.selectedIndex.value ==
                                                      index
                                                  ? AppColor.black
                                                  : AppColor.transparent),
                                    ),
                                    child: Image.network(
                                        // data["image"].toString(),
                                        "${APIShortsString.products_image}${data["product_image"][0]["product_images"].toString()}",
                                        fit: BoxFit.cover),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        boxH10(),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 150,
                            decoration: BoxDecoration(
                                color: AppColor.grey[100],
                                image: DecorationImage(
                                    // image: NetworkImage(items[controller.selectedIndex.value]["image"])
                                    image: NetworkImage(
                                        "${APIShortsString.products_image}${lookBookSettingController.lookbookList[widget.selectedLookBook!]["productLookbook"][controller.selectedIndex.value]["product_data"]["product_image"][0]["product_images"]}"))),
                          ),
                        ),
                        boxH10(),
                        Container(
                            padding: const EdgeInsets.all(5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Stack(
                                  children: <Widget>[
                                    Container(
                                      margin: const EdgeInsets.only(right: 20),
                                      child: Obx(
                                        () => Text(
                                          "${lookBookSettingController.lookbookList[widget.selectedLookBook!]["productLookbook"][controller.selectedIndex.value]["product_data"]["product_name"]}",
                                          style: AppTextStyle.semiBold
                                              .copyWith(fontSize: 18),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                boxH05(),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Obx(
                                      () => Text(
                                        "${APIShortsString.rupeeSign} ${lookBookSettingController.lookbookList[widget.selectedLookBook!]["productLookbook"][controller.selectedIndex.value]["product_data"]["product_price"]}",
                                        style: const TextStyle(
                                            color: Colors.blue,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    // Text(
                                    //   "  (20% off)",
                                    //   style: AppTextStyle.medium.copyWith(
                                    //       fontSize: 13,
                                    //       color: AppColor.grey),
                                    // ),
                                  ],
                                ),
                                // boxH02(),
                                // Text(
                                //   "\$10  ",
                                //   style: TextStyle(
                                //       color: Colors.grey[600],
                                //       fontSize: 12,
                                //       decoration:
                                //       TextDecoration.lineThrough),
                                // ),
                              ],
                            )),
                        boxH10(),
                        Obx(
                          () => Text(
                            "${lookBookSettingController.lookbookList[widget.selectedLookBook!]["productLookbook"][controller.selectedIndex.value]["product_data"]["description"]}",
                            style: const TextStyle(
                                fontSize: 12, color: Colors.black87),
                          ),
                        ),
                        boxH10(),
                        Obx(
                          () => Text(
                            "${lookBookSettingController.lookbookList[widget.selectedLookBook!]["productLookbook"][controller.selectedIndex.value]["product_data"]["highlights"]}",
                            style: const TextStyle(
                                fontSize: 12, color: Colors.black87),
                          ),
                        ),
                        boxH10(),
                        Obx(
                          () => Text(
                            "${lookBookSettingController.lookbookList[widget.selectedLookBook!]["productLookbook"][controller.selectedIndex.value]["product_data"]["weight"]}",
                            style: const TextStyle(
                                fontSize: 12, color: Colors.black87),
                          ),
                        ),
                        boxH10(),
                        Obx(
                          () => Text(
                            "${lookBookSettingController.lookbookList[widget.selectedLookBook!]["productLookbook"][controller.selectedIndex.value]["product_data"]["product_dimensions"]}",
                            style: const TextStyle(
                                fontSize: 12, color: Colors.black87),
                          ),
                        ),
                        boxH10(),
                        // Row(
                        //   children: [
                        //     Text("Color : ",
                        //         style: AppTextStyle.regular
                        //             .copyWith(fontSize: 12)),
                        //     Obx(()=> Text(
                        //         "${lookBookSettingController.lookbookList[widget.selectedLookBook!]["productLookbook"][controller.selectedIndex.value]["product_data"]["color_name"]}",
                        //         // "Black",
                        //         style: AppTextStyle.semiBold
                        //             .copyWith(fontSize: 12),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        //boxH10(),
                        // SizedBox(
                        //   height: 65,
                        //   child: ListView.builder(
                        //     padding: const EdgeInsets.only(left: 10),
                        //     scrollDirection: Axis.horizontal,
                        //     // itemCount: items.length,
                        //     itemCount: lookBookSettingController.lookbookList[widget.selectedLookBook!]["productLookbook"][controller.selectedIndex.value]["product_data"]["product_image"].length,
                        //     itemBuilder: (context, index) {
                        //       var data = lookBookSettingController.lookbookList[widget.selectedLookBook!]["productLookbook"][controller.selectedIndex.value]["product_data"]["product_image"][index];
                        //       return GestureDetector(
                        //         onTap: () {
                        //           print("1111  ${controller.initialized}");
                        //           controller.setSelectedIndex(index);
                        //         },
                        //         child: Container(
                        //           margin: const EdgeInsets.only(right: 10),
                        //           height: 80,
                        //           width: 80,
                        //           padding: const EdgeInsets.all(2),
                        //
                        //           child:  Image.network(
                        //               // data["image"].toString(),
                        //                 "${APIString.products_image}${data["product_images"].toString()}",
                        //                 fit: BoxFit.cover),
                        //         ),
                        //       );
                        //     },
                        //   ),
                        // ),
                        // boxH15(),
                        ///
                        // Align(
                        //   alignment: Alignment.center,
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     children: [
                        //       IconButton(
                        //         onPressed: _makePhoneCall,
                        //         icon: Container(
                        //           decoration: const BoxDecoration(
                        //             shape: BoxShape.circle,
                        //             gradient: LinearGradient(
                        //               colors: [Colors.blueAccent, Colors.lightBlue],
                        //               begin: Alignment.topLeft,
                        //               end: Alignment.bottomRight,
                        //             ),
                        //             boxShadow: [
                        //               BoxShadow(
                        //                 color: Colors.black26,
                        //                 blurRadius: 10,
                        //                 offset: Offset(0, 5),
                        //               ),
                        //             ],
                        //           ),
                        //           child: CircleAvatar(
                        //             radius: 30,
                        //             backgroundColor: Colors.transparent,
                        //             child: Image.asset(
                        //               'assets/call.png',
                        //               height: 30,
                        //               width: 30,
                        //               color: Colors.white,
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //       SizedBox(
                        //           width: 20),
                        //       GestureDetector(
                        //         onTap: () {
                        //
                        //           // if(cartController.currentCartSeller.isNotEmpty && cartController.currentCartSeller.value.toString().toLowerCase() != lookBookSettingController.lookbookList[widget.selectedLookBook!]["productLookbook"][controller.selectedIndex.value]["product_data"]["user_id"].toString().toLowerCase()){
                        //           // showSnackbar(message: AppString.differentSellerMsg);
                        //           // }else{
                        //           //   log("product_data :: ${lookBookSettingController.lookbookList[widget.selectedLookBook!]["productLookbook"][controller.selectedIndex.value]["product_data"]["_id"]}");
                        //           //   cartController.addToCart(
                        //           //     productId: lookBookSettingController.lookbookList[widget.selectedLookBook!]["productLookbook"][controller.selectedIndex.value]["product_data"]["_id"],
                        //           //     cartQuantity: "1",
                        //           //   );
                        //           print('other user_id : '+lookBookSettingController.lookbookList[widget.selectedLookBook!]["productLookbook"][controller.selectedIndex.value]["product_data"]["user_id"]);
                        //           print('product id: '+lookBookSettingController.lookbookList[widget.selectedLookBook!]["productLookbook"][controller.selectedIndex.value]["product_data"]["_id"]);
                        //
                        //           var  other_userId = lookBookSettingController.lookbookList[widget.selectedLookBook!]["productLookbook"][controller.selectedIndex.value]["product_data"]["user_id"];
                        //           var  product_id = lookBookSettingController.lookbookList[widget.selectedLookBook!]["productLookbook"][controller.selectedIndex.value]["product_data"]["_id"];
                        //           String mobileNumber = widget.user_contact.toString();
                        //           print('mobileNUmber: $mobileNumber');
                        //           Get.to(()=> AddEnquiry(productId: product_id, otherUserId:other_userId));
                        //           // }
                        //         },
                        //         child: FittedBox(
                        //           fit: BoxFit.scaleDown,
                        //           child: Container(
                        //             margin: const EdgeInsets.symmetric(
                        //                 horizontal: 10),
                        //             padding: const EdgeInsets.symmetric(
                        //                 vertical: 8, horizontal: 20),
                        //             decoration: BoxDecoration(
                        //                 color: AppColor.black,
                        //                 border:
                        //                 Border.all(color: AppColor.black)),
                        //             child: Row(
                        //               mainAxisAlignment: MainAxisAlignment.center,
                        //               children: [
                        //                 const Icon(
                        //                   Icons.shopping_bag,
                        //                   color: AppColor.white,
                        //                 ),
                        //                 Text(
                        //                   " Add Enquiry",
                        //                   style: AppTextStyle.regular.copyWith(
                        //                       fontSize: 14,
                        //                       color: AppColor.white),
                        //                 ),
                        //               ],
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        boxH20(),
                        Align(
                          child: SizedBox(
                            width: 100,
                            child: Divider(
                              color: AppColor.grey.shade300,
                            ),
                          ),
                        ),
                        boxH20(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Future<void> _makePhoneCall() async {
   // // mobileNumber = lookBookSettingController.lookbookList[index].user_contact.toString();
   //  print('user_id : '+lookBookSettingController.lookbookList[widget.selectedLookBook!]["productLookbook"][controller.selectedIndex.value]["product_data"]["user_contact"]);
    var mobileNumber= widget.user_contact.toString();
    print('mobileNUmber: $mobileNumber');
    print('other user Mobile Number:$mobileNumber');
    String url = 'tel:' + mobileNumber.replaceAll(' ', '');

    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } on PlatformException catch (e) {
      print("Failed to make phone call: ${e.message}");
    } catch (e) {
      print("Failed to make phone call: $e");
    }
  }
}
