import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:real_estate_app/common_widgets/height.dart';

import 'package:shimmer/shimmer.dart';
import '../../common_widgets/loading_dart.dart';
import '../../global/api_string.dart';
import '../../global/app_color.dart';
import '../../utils/String_constant.dart';
import '../../utils/shared_preferences/shared_preferances.dart';
import '../dashboard/view/BottomNavbar.dart';
import 'controller/SubscriptionController.dart';


class SubscriptionScreen extends StatefulWidget {

  const SubscriptionScreen({Key? key}) : super(key: key);
  @override
  _SubscriptionScreenState createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> with TickerProviderStateMixin{

  final SubscriptionController Controller = Get.put(SubscriptionController());
  Razorpay razorpay= Razorpay();
  bool isApiCalled = false;
  bool isBottomSheetOpen = false;
  String? price;
  String? finalprice;
  String? off;
  String? id;
  String? validity;
  String? validity_unit;
  String? category_type;
  String? plan_name;
  String? no_of_units;
  late TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    isBottomSheetOpen = false;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showLoadingDialog();
      Controller.getSubscriptionPlan("");
      Controller.getSubscriptionHistory();
    });

  }
  void _showLoadingDialog() {
    showHomLoading(Get.context!, 'Processing...');
    Future.delayed(const Duration(seconds: 1), () {
      if (Get.context != null && Navigator.canPop(Get.context!)) {
        Navigator.of(Get.context!).pop();
      }
    });
  }




  @override
  Widget build(BuildContext context) {
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    return Scaffold(
      appBar:AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            customIconButton(
              icon: Icons.arrow_back,
              onTap: () {
                Navigator.pop(context);

              },
            ),
            const Text("Plan / Subscription",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
            const Text("",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),

          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(
                child: Text('Plans'),
              ),
              Tab(
                child: Text('My Plans'),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                subscriptionPlanUI(Controller.selectedOption, context),
                subscriptionHistoryPlanUI(Controller.selectedOption, context),
              ],
            ),
          ),
        ],
      ),
      bottomSheet: Obx(() {
        if (Controller.getSubscriptionList.isNotEmpty &&
            Controller.selectedOption.value < Controller.getSubscriptionList.length) {
           finalprice = Controller.getSubscriptionList[Controller.selectedOption.value]['final_price'].toString();
           off = Controller.getSubscriptionList[Controller.selectedOption.value]['offer_percentage'].toString();
           price = Controller.getSubscriptionList[Controller.selectedOption.value]['plan_price'].toString();
           id = Controller.getSubscriptionList[Controller.selectedOption.value]['_id'].toString();
           validity = Controller.getSubscriptionList[Controller.selectedOption.value]['validity'].toString();
           validity_unit = Controller.getSubscriptionList[Controller.selectedOption.value]['validity_unit'].toString();
           category_type = Controller.getSubscriptionList[Controller.selectedOption.value]['category_type'].toString();
           plan_name = Controller.getSubscriptionList[Controller.selectedOption.value]['plan_name'].toString();
           no_of_units = Controller.getSubscriptionList[Controller.selectedOption.value]['no_of_units'].toString();
          return Checkout_Section(context, price!,finalprice!,off!,id!,validity!,validity_unit!,category_type!,plan_name!,no_of_units!);
        }
        return const SizedBox();
      }),
    );
  }

  Widget Checkout_Section(
      BuildContext context,
      String price,
      String finalprice,
      String off,
      String id,
      String validity,String validity_unit,String category_type,String plan_name,String no_of_units) {


    return Container(
      color: Colors.grey.shade50,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                height: 50,
                alignment: Alignment.center,
                child:  Column(
                  children: [
                    Text(
                      "\u20B9$price ",
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColor.nightBlue,
                          decoration: TextDecoration.lineThrough,decorationColor:  AppColor.nightBlue,
                      ),

                    ),
                    Text(
                      "\u20B9$finalprice / $off% OFF",
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColor.nightBlue,
                      ),
                    ),

                  ],
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.nightBlue,
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    openRazorpayCheckout();
                      // calculateExpiryDate(context, id, validity_unit,
                      //     int.parse(validity),category_type,plan_name,no_of_units);
                    ///
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => PaymentPage(
                    //           hyperSDK:hyperSDK,
                    //           amount: '0',
                    //         )));
                  },
                  child: const Center(
                    child: Text(
                      'Pay',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  void showPaymentResult(BuildContext context, bool isSuccess) {

    showModalBottomSheet(
      isDismissible: false,
      context: context,
      builder: (context) {
        return SizedBox(
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
              const SizedBox(height: 16),
              Text(
                isSuccess ? 'Payment Successful!' : 'Payment Failed!',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if(isSuccess){
                    Get.offAll(const BottomNavbar());

                  }else{
                    Navigator.of(context).pop();
                    setState(() {
                      isBottomSheetOpen = false;
                    });
                  }
                },
                child: const Text('OK',
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void processPayment(BuildContext context,String id,String expiryDate,String CurrentDate,
      String category_type,String plan_name,String no_of_units,String transactionId) {
    showModalBottomSheet(
      isDismissible: false,
      context: context,
      builder: (context) {
        return SizedBox(
          height: 150,
          child: const Center(child: CircularProgressIndicator()),
        );
      },
    );
    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => PaymentPage(
    //           hyperSDK:hyperSDK,
    //           amount: '0',
    //         )));
    ///
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pop();
      Controller.purchasedPlan(
        plan_auto_id: id,
        payment_mode: 'Online',
        plan_expiry_date: expiryDate,
        plan_purchase_date: CurrentDate,
        plan_status: 'Active',
        transaction_id: transactionId,
        category_type: category_type,
        transaction_status: 'Success',
        plan_name: plan_name,
          no_of_units: no_of_units
      ).then((value) {
        showPaymentResult(context, true);
      });


    });
  }

  Widget subscriptionPlanUI(RxInt selectedOption, BuildContext context) {
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: Controller.getSubscriptionList.length,
          itemBuilder: (context, index) {
            final plan = Controller.getSubscriptionList[index];
            return SubscriptionUI('',index, plan, selectedOption, context);
          },
        ),
      );
    });
  }

  Widget subscriptionHistoryPlanUI(RxInt selectedOption, BuildContext context) {
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: Controller.getHistoryList.length,
          itemBuilder: (context, index) {
            final plan = Controller.getHistoryList[index];
            return SubscriptionUI('history',index, plan, selectedOption, context);
          },
        ),
      );
    });
  }


    Widget SubscriptionUI(
        String isfrom,
      int index, Map<String, dynamic> plan, RxInt selectedOption, BuildContext context) {
    return Obx(() {
      bool isSelected = selectedOption.value == index;
      return GestureDetector(
        onTap: () {
          selectedOption.value = index;
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0,horizontal: 5),
          child: Container(
            width: 300,
            decoration: BoxDecoration(
              color: isSelected ? Colors.white10 : Colors.transparent,
              border: Border.all(
                color: isSelected ? AppColor.black.withOpacity(0.7) : AppColor.greyBorderColor,
                width: isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(16),
            ),

            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: plan['plan_image'] != null
                          ? CachedNetworkImage(

                        width:  MediaQuery.of(context).size.width,
                        height: 300,
                        imageUrl:  APIString.imageBaseUrl+plan['plan_image'],
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          width:  MediaQuery.of(context).size.width,
                          height: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      )
                          : Container(
                        color: Colors.grey[400],
                        child: const Center(
                          child: Icon(Icons.image_rounded),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          "${plan['plan_name']}",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "/ ${plan['validity']} ${plan['validity_unit']}",
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          "\u20B9${plan['plan_price']} ",
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            decoration: TextDecoration.lineThrough,decorationColor: Colors.white
                          ),

                        ),
                        Text(
                          "\u20B9${plan['final_price']} / ${plan['offer_percentage']}% OFF",
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),

                      ],
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () {
                        if (isSelected) {
                          Controller.showBenefit.value = !Controller.showBenefit.value;
                        }
                      },
                      child: Row(
                        children: [
                          const Text(
                            "See benefits",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(
                            Controller.showBenefit.value
                                ? Icons.keyboard_arrow_up_outlined
                                : Icons.keyboard_arrow_down_outlined,
                            size: 24,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                    if (selectedOption.value == index && Controller.showBenefit.value)
                      BenefitsUI(plan['features'].split(', ')),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }


  Widget BenefitsUI(List<String> benefits) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        const Text(
          "Benefits",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColor.black,
            fontFamily: 'Roboto',
          ),
        ),
        const SizedBox(height: 10),
        Column(
          children: List.generate(benefits.length, (index) {
            return Row(
              children: [
                Icon(Icons.check, color: Colors.green[600], size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    benefits[index],
                    style: TextStyle(color: Colors.black.withOpacity(0.5)),
                  ),
                ),
              ],
            );
          }),
        ),
      ],
    );
  }


  void calculateExpiryDate(BuildContext context, String id,
      String validityUnit, int validity,String category_type,String plan_name,String no_of_units,String transactionId) {

    DateTime currentDate = DateTime.now();

    DateTime expiryDate;

    switch (validityUnit) {
      case 'Month':
        expiryDate = DateTime(currentDate.year, currentDate.month + validity, currentDate.day);
        break;
      case 'Year':
        expiryDate = DateTime(currentDate.year + validity, currentDate.month, currentDate.day);
        break;
      case 'Days':
        expiryDate = currentDate.add(Duration(days: validity));
        break;
      default:
        throw Exception("Invalid validity unit");
    }
    String ExpiryDate = DateFormat('yyyy-MM-dd').format(expiryDate);
    String CurrentDate = DateFormat('yyyy-MM-dd').format(currentDate);
    print('ID: $id');
    print('Validity Unit: $validityUnit');
    print('Validity: $validity');
    print('Expiry Date: ${ExpiryDate}');
    print('transactionId Date: ${transactionId}');

    processPayment(context, id,ExpiryDate,CurrentDate,category_type,plan_name,no_of_units,transactionId);
  }
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    /// Do something when payment succeeds
    Fluttertoast.showToast(msg: 'payment succeeds');
    onPaymentSucesslistner(response.paymentId!);
  }

  // void _handlePaymentError(PaymentFailureResponse response) {
  //   /// Do something when payment fails
  //   Fluttertoast.showToast(msg: ' payment Failed ');
  //   showPaymentResult(context, false);
  // }
  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(msg: 'Payment Failed');
    if (!isBottomSheetOpen) {
      isBottomSheetOpen = true;
      // Fluttertoast.showToast(msg: 'Payment Failed');
      showPaymentResult(context, false);
    }
  }
  void _handleExternalWallet(ExternalWalletResponse response) {
    /// Do something when an external wallet was selected
    Fluttertoast.showToast(msg: '_handleExternalWallet');
  }
  //
  // onPaymentSucesslistner(String transactionId) async {
  //
  //   print('transaction id$transactionId');
  //
  //   if(transactionId.isNotEmpty){
  //     calculateExpiryDate(context, id!, validity_unit!,
  //         int.parse(validity!),category_type!,plan_name!,no_of_units!,transactionId);
  //   }
  // }
  onPaymentSucesslistner(String transactionId) async {
    print('transaction id $transactionId');
    if (transactionId.isNotEmpty && !isApiCalled) {
      isApiCalled = true;
      calculateExpiryDate(
        context,
        id!,
        validity_unit!,
        int.parse(validity!),
        category_type!,
        plan_name!,
        no_of_units!,
        transactionId,
      );
    } else {
      print('API already called or transaction ID is empty');
    }
  }
  void openRazorpayCheckout() async {
    String? userId = await SPManager.instance.getUserId(USER_ID);
    String? name = await SPManager.instance.getName(NAME);
    String? contact = await SPManager.instance.getContact(CONTACT);
    String? email = await SPManager.instance.getEmail(EMAIL);
    Map<String, Object> options={};

    String paidPrice = finalprice!;
    int finalPaidPrice = int.parse(paidPrice);
    int amount = finalPaidPrice * 100;

    try {
      options = {
        // key_id:      rzp_test_NUdFc6JnjprfBJ
        // key_secret:  BhPtTcUoAwo03petrUSxOhhc
       // 6LUJ9MmOe1sYGryOgepnRR8v
      //  'key': 'rzp_test_NUdFc6JnjprfBJ',
        'key': 'rzp_live_akexo8kqOAp4k7',
        // 'key': 'OUAF0zFNZW5lQf',
        'amount': amount,
        'name': name!,

         'description': userId!,
        'prefill': {
          'contact': contact!,
          'email': email!
        },

        'retry': {'enabled': true, 'max_count': 1},
        'send_sms_hash': true,
      };
    } catch (e) {
      debugPrint('Error: e');
    }

    try {
      razorpay.open(options);
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'Payment Error', toastLength: Toast.LENGTH_SHORT);
    }
  }
}
Widget dotDivider() {
  return LayoutBuilder(
    builder: (BuildContext context, BoxConstraints constraints) {
      final boxWidth = constraints.constrainWidth();
      const dashWidth = 6.0;
      final dashCount = (boxWidth / (2 * dashWidth)).floor();
      return Flex(
        children: List.generate(dashCount, (_) {
          return const SizedBox(
            width: dashWidth,
            height: 1.8,
            child: DecoratedBox(
              decoration: BoxDecoration(color: AppColor.grey),
            ),
          );
        }),
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        direction: Axis.horizontal,
      );
    },
  );
}