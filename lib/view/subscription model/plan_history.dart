import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:real_estate_app/common_widgets/height.dart';
import 'package:real_estate_app/global/AppBar.dart';
import 'package:real_estate_app/global/app_color.dart';
import 'package:real_estate_app/global/constant.dart';
import 'package:real_estate_app/view/property_screens/properties_list_screen/properties_list_screen.dart';
import 'package:real_estate_app/view/property_screens/recommended_properties_screen/properties_details_screen.dart';
import 'package:real_estate_app/view/top_developer/top_developer_details.dart';

import '../../../common_widgets/loading_dart.dart';
import '../../../global/api_string.dart';
import '../../common_widgets/custom_textformfield.dart';
import '../dashboard/view/BottomNavbar.dart';
import '../property_screens/properties_controllers/post_property_controller.dart';
import 'controller/SubscriptionController.dart';


class planHistory extends StatefulWidget {

  const planHistory({super.key,});

  @override
  State<planHistory> createState() => _planHistoryState();
}

class _planHistoryState extends State<planHistory> {
  bool isDialogShowing = false;
  final SubscriptionController Controller = Get.put(SubscriptionController());
  @override

  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showLoadingDialog();
    });
    Controller.getSubscriptionHistory();

  }

  void _showLoadingDialog() {
    showHomLoading(Get.context!, 'Processing...');
    Future.delayed(const Duration(seconds: 2), () {
      if (Get.context != null && Navigator.canPop(Get.context!)) {
        Navigator.of(Get.context!).pop();
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: AppColor.grey.withOpacity(0.1),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Controller.historyList.isNotEmpty && Controller.historyList.length!=0?
      Obx(
            () => ListView.builder(

          itemCount:Controller.historyList.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {

              },
              child: Container(
                margin: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColor.greyBorderColor),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Controller.historyList[index]['category_type'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const Icon(Icons.calendar_month, color: Colors.grey, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                Controller.historyList[index]['plan_purchase_date'],
                                style: const TextStyle(fontSize: 13, color: Colors.grey),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const Icon(Icons.calendar_month, color: Colors.grey, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                Controller.historyList[index]['plan_expiry_date'],
                                style: const TextStyle(fontSize: 13, color: Colors.grey),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const Icon(Icons.info_outline, color: Colors.grey, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                isPlanActive(Controller.historyList[index]['plan_expiry_date'])
                                    ? 'Plan Active'
                                    : 'Plan Inactive',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: isPlanActive(Controller.historyList[index]['plan_expiry_date'])
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                        if (!isPlanActive(Controller.getHistoryList[index]['plan_expiry_date']))
                        SizedBox(
                          height: 30,
                          child: ElevatedButton(
                            onPressed: () {
                              processPayment(context,Controller.getHistoryList[index]['plan_auto_id'],Controller.getHistoryList[index]['_id'],Controller.getHistoryList[index]['category_type']);
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white, backgroundColor: Colors.blue,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            child: const Text(
                              'Update',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                    ],
                  )
                ),
              ),
            );
          },
        ),
      ):
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/data.png',
              height: 40,
              width: 40,
            ),
            boxH08(),
            const Text(
              'No data available',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
  void processPayment(BuildContext context,String id,String plan_purchased_auto_id,String category_type) {
    showModalBottomSheet(
      isDismissible: false,
      context: context,
      builder: (context) {
        return Container(
          height: 150,
          child: Center(child: CircularProgressIndicator()),
        );
      },
    );

    Future.delayed(Duration(seconds: 5), () {
      Navigator.of(context).pop();
    //  plan_auto_id, user_id,plan_purchased_auto_id, plan_status
      Controller.planStatus(
        plan_auto_id: id,
        plan_status: 'Active',
        plan_purchased_auto_id: plan_purchased_auto_id,
        category_type: category_type,
      ).then((value) {
        showPaymentResult(context, true);
      });


    });
  }
  void showPaymentResult(BuildContext context, bool isSuccess) {

    showModalBottomSheet(
      isDismissible: false,
      context: context,
      builder: (context) {
        return Container(
          height: 200,
          width: Get.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isSuccess ? Icons.check_circle : Icons.error,
                color: isSuccess ? Colors.green : Colors.red,
                size: 60,
              ),
              SizedBox(height: 16),
              Text(
                isSuccess ? 'Payment Successful!' : 'Payment Failed!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Navigator.of(context).pop();
                  Get.offAll(const BottomNavbar());
                },
                // style: ElevatedButton.styleFrom(
                //   backgroundColor: AppColor.nightBlue,
                //   textStyle: const TextStyle(fontSize: 20),
                // ),
                child: Text('OK',
                  //style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  bool isPlanActive(String expiryDateString) {
    DateTime expiryDate = DateTime.parse(expiryDateString);
    DateTime currentDate = DateTime.now();
    return currentDate.isBefore(expiryDate) || currentDate.isAtSameMomentAs(expiryDate);
  }
}

