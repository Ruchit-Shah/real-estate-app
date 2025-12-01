import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:real_estate_app/common_widgets/custom_container.dart';
import 'package:real_estate_app/common_widgets/height.dart';
import 'package:real_estate_app/common_widgets/loading_dart.dart';
import 'package:real_estate_app/global/app_color.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/CustomBottomNavBar.dart';
import 'package:real_estate_app/view/subscription%20model/controller/SubscriptionController.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../../global/api_string.dart';
import '../../../../../../utils/String_constant.dart';
import '../../../../../../utils/shared_preferences/shared_preferances.dart';
import '../../../../view/BottomNavbar.dart';

class PlansAndSubscription extends StatefulWidget {
  final String isfrom;
  const PlansAndSubscription({super.key, required this.isfrom});

  @override
  State<PlansAndSubscription> createState() => _PlansAndSubscriptionState();
}

class _PlansAndSubscriptionState extends State<PlansAndSubscription> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final SubscriptionController Controller = Get.put(SubscriptionController());
  bool isApiCalled = false;
  bool isBottomSheetOpen = false;
  String? price;
  int tabIndex=0;
  bool showDetails = false;
  bool PlanshowDetails = false;
  String? finalprice;
  String? off;
  String? id;
  String? validity;
  String? validity_unit;
  String? category_type;
  String? plan_name;
  String? no_of_units;
  Razorpay razorpay= Razorpay();
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showLoadingDialog();
      Controller.getSubscriptionPlan(widget.isfrom);
      Controller.getSubscriptionHistory();
    });

  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
      // onWillPop: () async {
      //   await Controller.getProfile();
      //
      //   return trur; // Prevent default pop behavior
      //
      // },
      backgroundColor: AppColor.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Plan / Subscription",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 46,
        leading: Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.black,
                width: 0.1,
              ),
            ),
            child: InkWell(
              onTap: () {
                 Controller.getProfile();
                Get.back();
              },
              borderRadius: BorderRadius.circular(50),
              child: const Padding(
                padding: EdgeInsets.all(6),
                child: Icon(
                  Icons.arrow_back_outlined,
                  size: 18,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColor.lightBlue,
          labelColor: AppColor.lightPurple,
          unselectedLabelColor: Colors.black,
          indicatorSize: TabBarIndicatorSize.tab,
          onTap: (v){
            setState(() {
              tabIndex = v;
            });

          },
          tabs: const [
            Tab(
              child: Text("Plans"),
            ),
            Tab(
              child: Text("My Plans"),
            ),
          ],
        )),
      body: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          buildTabPlans(Controller.selectedOption, context),
          buildHistoryTabPlans(Controller.selectedOption, context),
        ],
      ),
      // bottomNavigationBar:
      // tabIndex==0?
      // Obx(() {
      //   if (Controller.getSubscriptionList.isNotEmpty &&
      //       Controller.selectedOption.value < Controller.getSubscriptionList.length) {
      //     finalprice = Controller.getSubscriptionList[Controller.selectedOption.value]['final_price'].toString();
      //     off = Controller.getSubscriptionList[Controller.selectedOption.value]['offer_percentage'].toString();
      //     price = Controller.getSubscriptionList[Controller.selectedOption.value]['plan_price'].toString();
      //     id = Controller.getSubscriptionList[Controller.selectedOption.value]['_id'].toString();
      //     validity = Controller.getSubscriptionList[Controller.selectedOption.value]['validity'].toString();
      //     validity_unit = Controller.getSubscriptionList[Controller.selectedOption.value]['validity_unit'].toString();
      //     category_type = Controller.getSubscriptionList[Controller.selectedOption.value]['category_type'].toString();
      //     plan_name = Controller.getSubscriptionList[Controller.selectedOption.value]['plan_name'].toString();
      //     no_of_units = Controller.getSubscriptionList[Controller.selectedOption.value]['no_of_units'].toString();
      //     return Checkout_Section(context, price!,finalprice!,off!,id!,validity!,validity_unit!,category_type!,plan_name!,no_of_units!);
      //   }
      //   return const SizedBox();
      // }):null,
    );
  }

  Widget buildTabPlans(RxInt selectedOption, BuildContext context) {
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child:ListView.builder(
          shrinkWrap: true,
          itemCount: Controller.getSubscriptionList.length,
          itemBuilder: (context, index) {
            final plan = Controller.getSubscriptionList[index];
            return Obx(() => AdvertisingPlanCard(
              '',
              index,
              plan,
              selectedOption,
              context,
              Controller.expandedIndices,
            ));
          },
        ),

      );
    });
  }
  Widget buildHistoryTabPlans(RxInt selectedOption, BuildContext context) {
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: Controller.getHistoryList.length,
          itemBuilder: (context, index) {
            final plan = Controller.getHistoryList[index];
            return Obx(() => AdvertisingHistoryPlanCard(
              'history',
              index,
              plan,
              selectedOption,
              context,
              Controller.expandedHistoryIndices,
            ));
          },
        ),
      );
    });
  }





  Widget AdvertisingPlanCard(
      String isfrom,
      int index,
      Map<String, dynamic> plan,
      RxInt selectedOption,
      BuildContext context,
      RxSet<int> expandedIndices,
      ) {
    bool isSelected = selectedOption.value == index;
    bool isExpanded = expandedIndices.contains(index);

    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child:
      // Column(
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //   children: [
      //     ClipRRect(
      //       borderRadius: const BorderRadius.vertical(top: Radius.circular(16.0)),
      //       child: plan['plan_image'] != null
      //           ? CachedNetworkImage(
      //         height: 180,
      //         width: double.infinity,
      //         imageUrl: APIString.imageBaseUrl + plan['plan_image'],
      //         fit: BoxFit.cover,
      //         placeholder: (context, url) => Container(
      //           height: 180,
      //           width: double.infinity,
      //           decoration: BoxDecoration(
      //             borderRadius: BorderRadius.circular(10),
      //           ),
      //         ),
      //         errorWidget: (context, url, error) => const Icon(Icons.error),
      //       )
      //           : Container(
      //         color: Colors.grey[400],
      //         height: 180,
      //         width: double.infinity,
      //         child: const Center(
      //           child: Icon(Icons.image_rounded),
      //         ),
      //       ),
      //     ),
      //     Padding(
      //       padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      //       child: Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: [
      //           Text(
      //             "${plan['plan_name']}",
      //             style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      //           ),
      //           Text(
      //             "Plan category Type: ${plan['category_type']}",
      //             style: const TextStyle(fontSize: 14, color: Colors.grey),
      //           ),
      //           boxH08(),
      //           Text(
      //             "Units: ${plan['no_of_units']}",
      //             style: const TextStyle(fontSize: 14),
      //           ),
      //           boxH08(),
      //           Row(
      //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //             children: [
      //               Column(
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 children: [
      //                   Text(
      //                     "\u20B9${plan['plan_price']}",
      //                     style: const TextStyle(
      //                       fontSize: 16,
      //                       fontWeight: FontWeight.bold,
      //                       decoration: TextDecoration.lineThrough,
      //                     ),
      //                   ),
      //                   Text(
      //                     "\u20B9${plan['final_price']} / ${plan['offer_percentage']}% OFF",
      //                     style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      //                   ),
      //                   const Text('Price', style: TextStyle(color: Colors.grey)),
      //                 ],
      //               ),
      //               Column(
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 children: [
      //                   Text(
      //                     "${plan['validity']} ${plan['validity_unit']}",
      //                     style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      //                   ),
      //                   const Text('Validity', style: TextStyle(color: Colors.grey)),
      //                 ],
      //               ),
      //             ],
      //           ),
      //           Align(
      //             alignment: Alignment.centerRight,
      //             child: GestureDetector(
      //               onTap: () {
      //                 if (expandedIndices.contains(index)) {
      //                   expandedIndices.remove(index);
      //                 } else {
      //                   expandedIndices.add(index);
      //                 }
      //               },
      //               child: Padding(
      //                 padding: const EdgeInsets.only(right: 8.0, top: 8.0),
      //                 child: Text(
      //                   isExpanded ? "Hide Details" : "View Details",
      //                   style: const TextStyle(
      //                     fontSize: 14,
      //                     color: AppColor.primaryThemeColor,
      //                     decoration: TextDecoration.underline,
      //                   ),
      //                 ),
      //               ),
      //             ),
      //           ),
      //           const Divider(height: 20, thickness: 1),
      //           boxH08(),
      //
      //           /// ✅ Show details if expanded
      //           if (isExpanded) ...[
      //             Column(
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               children: [
      //                 Text(
      //                   "Description: ${plan['description']}",
      //                   style: const TextStyle(fontSize: 13),
      //                 ),
      //
      //                 boxH08(),
      //                 const Text(
      //                   "What's included",
      //                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      //                 ),
      //                 boxH08(),
      //                 Column(
      //                   crossAxisAlignment: CrossAxisAlignment.start,
      //                   children: (plan['features'] as String)
      //                       .split(',')
      //                       .map((f) => f.trim())
      //                       .map(
      //                         (include) => Padding(
      //                       padding: const EdgeInsets.symmetric(vertical: 4),
      //                       child: Row(
      //                         crossAxisAlignment: CrossAxisAlignment.start,
      //                         children: [
      //                           const Icon(Icons.fiber_manual_record, size: 8),
      //                           boxW08(),
      //                           Expanded(
      //                             child: Text(
      //                               include,
      //                               style: const TextStyle(fontSize: 13),
      //                             ),
      //                           ),
      //                         ],
      //                       ),
      //                     ),
      //                   )
      //                       .toList(),
      //                 ),
      //                 boxH10(),
      //               ],
      //             ),
      //           ],
      //
      //           /// Button Section
      //           Center(
      //             child: isSelected
      //                 ? commonButton(
      //               width: Get.width * 0.8,
      //               height: 50,
      //               buttonColor: Colors.grey,
      //               text: "Selected",
      //               onPressed: () {
      //                 selectedOption.value = index;
      //               },
      //             )
      //                 : commonButton(
      //               width: Get.width * 0.8,
      //               height: 50,
      //               buttonColor: const Color(0xFF52C672),
      //               text: "Pay Now",
      //               onPressed: () {
      //                 selectedOption.value = index;
      //                 Controller.selectedOption.value = index;
      //               },
      //             ),
      //           ),
      //
      //           boxH10(),
      //         ],
      //       ),
      //     ),
      //   ],
      // ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: plan['plan_image'] != null && plan['plan_image'].isNotEmpty
                ? CachedNetworkImage(
              height: 180,
              width: double.infinity,
              imageUrl: "${APIString.imageBaseUrl}${plan['plan_image']}",
              fit: BoxFit.cover,
              placeholder: (context, url) => Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  height: 180,
                  width: double.infinity,
                  color: Colors.grey[300],
                ),
              ),
              errorWidget: (context, url, error) => Container(
                height: 180,
                width: double.infinity,
                color: Colors.grey[300],
                child: const Icon(Icons.error, color: Colors.red, size: 40),
              ),
            )
                : Container(
              height: 180,
              width: double.infinity,
              color: Colors.grey[300],
              child: const Icon(
                Icons.image_rounded,
                size: 50,
                color: Colors.grey,
              ),
            ),
          ),
          // Content Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Plan Name
                Text(
                  plan['plan_name']?.toString() ?? 'Unnamed Plan',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                // Plan Category
                Text(
                  "Plan Category: ${plan['category_type'] ?? 'N/A'}",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                boxH08(),
                // Number of Units
                Text(
                  "Units: ${plan['no_of_units'] ?? 'N/A'}",
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
                boxH08(),
                // Price and Validity Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "\u20B9${plan['plan_price']}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        Text(
                          "\u20B9${plan['final_price']} / ${plan['offer_percentage']}% OFF",
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const Text('Price', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${plan['validity']} ${plan['validity_unit']}",
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const Text('Validity', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
                // View Details Toggle
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      if (isExpanded) {
                        expandedIndices.remove(index);
                      } else {
                        expandedIndices.add(index);
                      }
                      // Trigger rebuild
                      (context as Element).markNeedsBuild();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8, top: 8),
                      child: Text(
                        isExpanded ? "Hide Details" : "View Details",
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColor.primaryThemeColor,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ),
                const Divider(height: 20, thickness: 1),
                boxH08(),
                // Expanded Details Section
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 300),
                  crossFadeState: isExpanded
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  firstChild: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Description
                      Text(
                        "Description: ${plan['description'] ?? 'No description available'}",
                        style: TextStyle(fontSize: 13, color: Colors.black87),
                      ),
                      boxH08(),
                      // What's Included
                      const Text(
                        "What's Included",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      boxH08(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: (plan['features'] as String? ?? '')
                            .split(',')
                            .map((f) => f.trim())
                            .where((f) => f.isNotEmpty)
                            .map(
                              (include) => Padding(
                            padding:
                            const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.check_circle,
                                  size: 16,
                                  color: Colors.green,
                                ),
                                boxW08(),
                                Expanded(
                                  child: Text(
                                    include,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                            .toList(),
                      ),
                      boxH10(),
                    ],
                  ),
                  secondChild: const SizedBox.shrink(),
                ),
                // Button Section
                Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: Get.width * 0.8,
                    height: 50,
                    child: commonButton(
                      width: Get.width * 0.8,
                      height: 50,
                      buttonColor: isSelected ? Colors.grey : const Color(0xFF52C672),
                      text: isSelected ? "Selected" : "Pay Now",
                      onPressed: () {
                        selectedOption.value = index;
                        Controller.selectedOption.value = index;

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
                           //return Checkout_Section(context, price!,finalprice!,off!,id!,validity!,validity_unit!,category_type!,plan_name!,no_of_units!);
                          calculateExpiryDate(context, id!, validity_unit!,
                              int.parse(validity!),category_type!,plan_name!,no_of_units!,'transId123');

                        }
                      },
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                boxH10(),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget AdvertisingHistoryPlanCard(
      String isfrom,
      int index,
      Map<String, dynamic> plan,
      RxInt selectedOption,
      BuildContext context,
      RxSet<int> expandedIndices,
      ) {
    bool isSelected = selectedOption.value == index;
    bool isExpanded = expandedIndices.contains(index);

    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16.0)),
            child: plan['plan_image'] != null
                ? CachedNetworkImage(
              height: 180,
              width: double.infinity,
              imageUrl: APIString.imageBaseUrl + plan['plan_image'],
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            )
                : Container(
              height: 180,
              width: double.infinity,
              color: Colors.grey[400],
              child: const Center(child: Icon(Icons.image_rounded)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${plan['plan_name']}",
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Text(
                  "for ${plan['category_type']}",
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                boxH08(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                  decoration: BoxDecoration(
                    color: isPlanActive(plan['plan_expiry_date'])
                        ? Colors.green.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isPlanActive(plan['plan_expiry_date']) ? Colors.green : Colors.red,
                    ),
                  ),
                  child: Text(
                    isPlanActive(plan['plan_expiry_date'])
                        ? 'Plan Active'
                        : 'Plan Deactive',
                    style: TextStyle(
                      fontSize: 15,
                      color: isPlanActive(plan['plan_expiry_date']) ? Colors.green : Colors.red,
                    ),
                  ),
                ),
                boxH08(),
                Text(
                  "Plan Expiry Date: ${DateFormat('dd MMMM, yyyy').format(DateTime.parse(plan['plan_expiry_date']))}",
                  style: const TextStyle(fontSize: 15, color: Colors.grey),
                ),
                boxH08(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "\u20B9${plan['plan_price']}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        Text(
                          "\u20B9${plan['final_price']} / ${plan['offer_percentage']}% OFF",
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const Text('Price', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${plan['validity']} ${plan['validity_unit']}",
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const Text('Validity', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
                const Divider(height: 20, thickness: 1),
                boxH08(),

                /// Expanded details (only when isExpanded is true)
                if (isExpanded) ...[
                  boxH08(),
                  Text(
                    "${plan['description']}",
                    style: const TextStyle(fontSize: 13),
                    textAlign: TextAlign.start,
                    softWrap: true,
                  ),
                  Text(
                    "${plan['no_of_units']} units for ${plan['category_type']} category",
                    style: const TextStyle(fontSize: 13),
                    textAlign: TextAlign.start,
                    softWrap: true,
                  ),
                  boxH08(),
                  const Text(
                    "What's included",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  boxH08(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: (plan['features'] as String)
                        .split(',')
                        .map((f) => f.trim())
                        .map(
                          (include) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.fiber_manual_record, color: Colors.black, size: 8),
                            boxW08(),
                            Expanded(
                              child: Text(
                                include,
                                style: const TextStyle(fontSize: 13),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                        .toList(),
                  ),
                  boxH15(),
                ],

                /// View / Hide Details Button
                Center(
                  child: SizedBox(
                    width: Get.width * 0.8,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColor.primaryThemeColor,
                        side: const BorderSide(color: AppColor.primaryThemeColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        if (expandedIndices.contains(index)) {
                          expandedIndices.remove(index);
                        } else {
                          expandedIndices.add(index);
                        }
                      },
                      child: Text(
                        isExpanded ? "Hide Details" : "View Details",
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool isPlanActive(String expiryDateString) {
    DateTime expiryDate = DateTime.parse(expiryDateString);
    DateTime currentDate = DateTime.now();
    return currentDate.isBefore(expiryDate) || currentDate.isAtSameMomentAs(expiryDate);
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
                height: 55,
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
                    backgroundColor: const Color(0xFF52C672),
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    ///payment gateway
                  //  openRazorpayCheckout();
                    calculateExpiryDate(context, id, validity_unit,
                        int.parse(validity),category_type,plan_name,no_of_units,'transId123');
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
                isSuccess ? 'Purchased Successful!' : 'Payment Failed!',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if(isSuccess){
                    // Get.offAll(const BottomNavbar());
                    await Controller.getProfile();
                    Navigator.pop(context);
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
        return const SizedBox(
          height: 150,
          child: Center(child: CircularProgressIndicator()),
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





