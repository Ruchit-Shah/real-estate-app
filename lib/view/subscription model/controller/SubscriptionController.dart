import 'dart:convert';
import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/global/app_color.dart';
import 'package:real_estate_app/utils/shared_preferences/shared_preferances.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/profile_screen/profile_controller.dart';

import '../../../global/api_string.dart';
import '../../../utils/String_constant.dart';
import '../../../utils/network_http.dart';
import '../../dashboard/bottom_navbar_screens/search_screen/searchController.dart';

class SubscriptionController extends GetxController {


  var selectedOption = (0).obs;

  var showBenefit = true.obs;
  RxInt paid_featured_count = 0.obs;

  List<Color> colors = [
    AppColor.grey.shade100,
    AppColor.blue.shade100,
    AppColor.amber.shade100,
    AppColor.green.shade100
  ];
  RxSet<int> expandedIndices = <int>{}.obs;
  RxSet<int> expandedHistoryIndices = <int>{}.obs;

  RxList getSubscriptionList = [].obs;
  RxList getHistoryList = [].obs;
  RxList historyList = [].obs;


  Future<void> getSubscriptionPlan(String from) async {
    getSubscriptionList.clear();
    try {
      var response = await HttpHandler.getHttpMethod(
        url: APIString.get_subscription_plans,
      );
      if (response['error'] == null && response['body']['status'].toString() == "1") {
        log("response[data]  ---- ${response['body']['data']}");
        var respData = response['body']['data'] as List<dynamic>;

        final categoryTypeMap = {
          'property': 'Post Properties',
          'feature': 'Featured Properties',
          'project': 'Upcoming Projects',
          'developer': 'Top Developers',
          'offer': 'Offers',
          'contact': 'Contact Details',
        };

        final targetCategoryType = categoryTypeMap[from.toLowerCase()];

        final filteredData = targetCategoryType != null
            ? respData.where((plan) => plan['category_type'] == targetCategoryType).toList()
            : respData;

        getSubscriptionList.value = filteredData;
        log("Filtered subscription list: $filteredData");
      } else {
        log("API error: ${response['error'] ?? 'Unknown error'}");
      }
    } catch (e) {
      debugPrint("Error in getSubscriptionPlan: $e");
    }
  }


  Future<void> purchasedPlan({
    String? plan_auto_id,
    String? payment_mode,
    String? transaction_status,
    String? plan_purchase_date,
    String? plan_status,
    String? category_type,
    String? plan_expiry_date,
    String? transaction_id,
    String? plan_name,
    String? no_of_units,

  }) async {
    String? userId = await SPManager.instance.getUserId(USER_ID);
    String? name = await SPManager.instance.getName(NAME);

    try {

      var response = await HttpHandler.postHttpMethod(
        url: APIString.purchase_plan,
        data: {
          'user_id':userId,
          'plan_auto_id':plan_auto_id,
          'payment_mode':payment_mode,
          'transaction_id':transaction_id,
          'transaction_status':transaction_status,
          'plan_purchase_date':plan_purchase_date,
          'plan_status':plan_status,
          'category_type':category_type,
          'plan_expiry_date':plan_expiry_date,
          //'plan_expiry_date':'2024-10-20',
          'plan_name':plan_name,
          'user_name':name,
          'no_of_units':no_of_units,
        },
      );
      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          Fluttertoast.showToast(msg: response['body']['msg'].toString());



          print('paid_contact==>${category_type}');
          if(category_type=='Post Properties'){

            add_count(isfrom: 'paid_post',count:0 ).then((value) async {
              await SPManager.instance.setPaidPostCount(PAID_POST, 0);
            });

          }

          if(category_type=='Upcoming Projects'){
            add_count(isfrom: 'project',count:0 ).then((value) async {
              await SPManager.instance.setProjectCount(PAID_PROJECT, 0);
            });

          }

          if(category_type=='Featured Properties'){
            add_count(isfrom: 'feature',count:0 ).then((value) async {
              await SPManager.instance.setFeatureCount(PAID_FEATURE, 0);
            });

          }

          if(category_type=='Top Developers'){
            add_count(isfrom: 'mark_as',count:0 ).then((value) async {
              await SPManager.instance.setMarkDeveloperCount(PAID_MARKDEVELOPER, 0);
            });

          }

          if(category_type=='Offers'){
            add_count(isfrom: 'offer',count:0 ).then((value) async {
              await SPManager.instance.setOfferCount(PAID_OFFER, 0);
            });

          }

          if(category_type=='Contact Details'){
            add_count(isfrom: 'paid_contact',count:0 ).then((value) async {
              await SPManager.instance.setPaidViewCount(PAID_VIEW, 0);
            });

          }

          await getProfile();
    }
      }
      else if (response['error'] != null) {

        var responseBody = json.decode(response['body']);
    //    Fluttertoast.showToast(msg: responseBody['msg']);

      }
    } catch (e) {

      debugPrint("Login Error: $e");
     // Fluttertoast.showToast(msg: 'An error occurred. Please try again.');
    }
  }


  Future<void> getProfile() async {

    print("from SubscriptiomgetProfile()=>");

    try {

      String? userId = await SPManager.instance.getUserId(USER_ID);
      var response = await HttpHandler.postHttpMethod(
        url: APIString.getProfile,
        data: {
          'user_id': userId,
        },
      );
      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          log("response[data] ---- ${response['body']?["data"]}");

          final countData = response['body']?["count_data"];


          if (countData != null) {
            int freeViewCount = int.tryParse(countData['free_view_count']?.toString() ?? "0") ?? 0;
            int freePostCount = int.tryParse(countData['free_post_count']?.toString() ?? "0") ?? 0;
            int featureCount = int.tryParse(countData['feature_count']?.toString() ?? "0") ?? 0;

            int offerCount = int.tryParse(countData['offer_count']?.toString() ?? "0") ?? 0;
            int paidPostCount = int.tryParse(countData['paid_post_count']?.toString() ?? "0") ?? 0;
            int paidviewCount = int.tryParse(countData['paid_view_count']?.toString() ?? "0") ?? 0;
            int projectCount = int.tryParse(countData['upcoming_project_count']?.toString() ?? "0") ?? 0;
            int mark_as_developer_count = int.tryParse(countData['mark_as_developer_count']?.toString() ?? "0") ?? 0;

            paid_featured_count.value = int.tryParse(countData['feature_count']?.toString() ?? "0") ?? 0;
            await SPManager.instance.setMarkDeveloperCount(PAID_MARKDEVELOPER, mark_as_developer_count);
            await SPManager.instance.setFreeViewCount(FREE_VIEW, freeViewCount);
            await SPManager.instance.setFreePostCount(FREE_POST, freePostCount);
            await SPManager.instance.setPaidPostCount(PAID_POST, paidPostCount);
            await SPManager.instance.setPaidViewCount(PAID_VIEW, paidviewCount);
            await SPManager.instance.setFeatureCount(PAID_FEATURE, featureCount);

            await SPManager.instance.setOfferCount(PAID_OFFER, offerCount);
            await SPManager.instance.setProjectCount(PAID_PROJECT, projectCount);
          }

            getSetting();
           getSubscriptionHistory();

        }
      }
      else if (response['error'] != null) {
        var responseBody = json.decode(response['body']);
        print(responseBody['msg']);
        // //Fluttertoast.showToast(msg: responseBody['msg']);
      }
    } catch (e) {
      debugPrint("Login Error: $e");
      // //Fluttertoast.showToast(msg: 'An error occurred. Please try again.');
    }
    finally{

    }
  }

  Future<void> getSubscriptionHistory() async {
    String? userId = await SPManager.instance.getUserId(USER_ID);
    getHistoryList.clear();
    historyList.clear();
    try {
      var response = await HttpHandler.postHttpMethod(
        url: APIString.Plan_purchased_History,
        data: {
          'user_id':userId,
        },);
      print('get plan history response ${response}');
      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          log("response[data]  ---- ${response['body']["data"]}");
          var respData = response['body'];

        //  getHistoryList.value = respData["data"];
          historyList.value = respData["data"];
          ///for plan count
          if (historyList.isNotEmpty) {
            print("historyList.isNotEmpty");
            RxList activeHistoryList = [].obs;
            for (var entry in historyList) {
              if (entry['plan_status'] == "Active") {
                activeHistoryList.add(entry);
              }
            }
            if (activeHistoryList.isNotEmpty) {
              getHistoryList = activeHistoryList;
            }
          }

          final currentDate = DateTime.now();

          if (getHistoryList.isNotEmpty) {
            print("getHistoryList.isNotEmpty");
            for (var entry in getHistoryList) {
              String category = entry['category_type'];
              int unitCount = int.parse(entry['no_of_units'].toString());
              String plan_status = entry['plan_status'];
              DateTime expiryDate = DateTime.parse(entry['plan_expiry_date']);

            //  bool isActive = currentDate.isBefore(expiryDate) || currentDate.isAtSameMomentAs(expiryDate);
              bool isActive = plan_status=="Active"? true : false;



              Map<String, Function> categoryActions = {
                'Post Properties': () async {
                  await SPManager.instance.setPostProperties(PostProperties, isActive ? "yes" : "no");
                  if (isActive) await SPManager.instance.setPlanPostCount(PLAN_POST, unitCount);
                },
                // 'Top Developers': () async {
                //   await SPManager.instance.setTopDevelopers(TopDevelopers, isActive ? "yes" : "no");
                // },
                'Upcoming Projects': () async {
                  await SPManager.instance.setUpcomingProjects(UpcomingProjects, isActive ? "yes" : "no");
                  if (isActive) await SPManager.instance.setPlanProjectCount(PLAN_PROJECT, unitCount);
                },
                'Featured Properties': () async {
                  await SPManager.instance.setFeaturedProperties(FeaturedProperties, isActive ? "yes" : "no");
                  if (isActive) await SPManager.instance.setPlanFeatureCount(PLAN_FEATURE, unitCount);
                },
                'Top Developers': () async {
                  await SPManager.instance.setMarksAS(MARKAS, isActive ? "yes" : "no");
                  if (isActive) await SPManager.instance.setPlanMarkeCount(PLAN_MARKDEVELOPER, unitCount);
                },
                'Offers': () async {
                  await SPManager.instance.setOffers(Offers, isActive ? "yes" : "no");
                  if (isActive) await SPManager.instance.setPlanOfferCount(PLAN_OFFER, unitCount);
                  String  Offer= (await SPManager.instance.getOffers(Offers))??"no";
                  print("Offer-->${Offer}");
                },
                'Contact Details': () async {
                  await SPManager.instance.setContactDetails(ContactDetails, isActive ? "yes" : "no");
                  if (isActive) await SPManager.instance.setPlanViewCount(PLAN_VIEW, unitCount);
                },
              };
              // await getProfile();
              if (categoryActions.containsKey(category)) {
                print("categoryActionsddd");
                await categoryActions[category]!();
              }

            }
          }
          else {
            print("isNotEmpty11111");
            await SPManager.instance.setPostProperties(PostProperties, "no");
            await SPManager.instance.setTopDevelopers(TopDevelopers, "no");
            await SPManager.instance.setUpcomingProjects(UpcomingProjects, "no");
            await SPManager.instance.setFeaturedProperties(FeaturedProperties, "no");
            await SPManager.instance.setMarksAS(MARKAS, "no");
            await SPManager.instance.setOffers(Offers, "no");
            await SPManager.instance.setContactDetails(ContactDetails, "no");

            await SPManager.instance.setPlanPostCount(PLAN_POST, 0);
            await SPManager.instance.setPlanProjectCount(PLAN_PROJECT, 0);
            await SPManager.instance.setPlanMarkeCount(PLAN_MARKDEVELOPER, 0);
            await SPManager.instance.setPlanFeatureCount(PLAN_FEATURE, 0);
            await SPManager.instance.setPlanOfferCount(PLAN_OFFER, 0);
            await SPManager.instance.setPlanViewCount(PLAN_VIEW, 0);
          }


          int? storedViewCount = await SPManager.instance.getPlanPostCount(PLAN_POST);


          print("Stored1 free_view_count: $storedViewCount");

        }
      }
      else if (response['error'] != null) {
        print("response['error']");
        getHistoryList.clear();
        await SPManager.instance.setPostProperties(PostProperties, "no");
        await SPManager.instance.setTopDevelopers(TopDevelopers, "no");
        await SPManager.instance.setUpcomingProjects(UpcomingProjects, "no");
        await SPManager.instance.setFeaturedProperties(FeaturedProperties, "no");
        await SPManager.instance.setMarksAS(MARKAS, "no");
        await SPManager.instance.setOffers(Offers, "no");
        await SPManager.instance.setContactDetails(ContactDetails, "no");

        await SPManager.instance.setPlanPostCount(PLAN_POST, 0);
        await SPManager.instance.setPlanProjectCount(PLAN_PROJECT, 0);
        await SPManager.instance.setPlanFeatureCount(PLAN_FEATURE, 0);
        await SPManager.instance.setPlanMarkeCount(PLAN_MARKDEVELOPER, 0);
        await SPManager.instance.setPlanOfferCount(PLAN_OFFER, 0);
        await SPManager.instance.setPlanViewCount(PLAN_VIEW, 0);

      }
    } catch (e) {
      getHistoryList.clear();
      debugPrint(" Error: $e");
      //  Fluttertoast.showToast(msg: 'An error occurred. Please try again.');
    }
  }

  // Future<void> getSubscriptionHistory() async {
  //   String? userId = await SPManager.instance.getUserId(USER_ID);
  //   getHistoryList.clear();
  //
  //   try {
  //     var response = await HttpHandler.postHttpMethod(
  //       url: APIString.Plan_purchased_History,
  //       data: {
  //         'user_id': userId,
  //       },
  //     );
  //
  //     if (response['error'] == null) {
  //       if (response['body']['status'].toString() == "1") {
  //         log("response[data]  ---- ${response['body']["data"]}");
  //         var respData = response['body'];
  //         getHistoryList.value = respData["data"];
  //
  //         final currentDate = DateTime.now();
  //         final Set<String> activeCategories = {};
  //
  //         for (var item in getHistoryList) {
  //           DateTime expiryDate = DateTime.parse(item['plan_expiry_date']);
  //
  //           if (currentDate.isBefore(expiryDate) || currentDate.isAtSameMomentAs(expiryDate)) {
  //
  //           }
  //         }
  //
  //         ///plan purchsed yes or no
  //         await SPManager.instance.setPostProperties(
  //             PostProperties,
  //             activeCategories.contains('Post Properties') ? "yes" : "no");
  //         await SPManager.instance.setTopDevelopers(
  //             TopDevelopers,
  //             activeCategories.contains('Top Developers') ? "yes" : "no"
  //         );
  //         await SPManager.instance.setUpcomingProjects(
  //             UpcomingProjects,
  //             activeCategories.contains('Upcoming Projects') ? "yes" : "no"
  //         );
  //         await SPManager.instance.setFeaturedProperties(
  //             FeaturedProperties,
  //             activeCategories.contains('Featured Properties') ? "yes" : "no"
  //         );
  //         await SPManager.instance.setOffers(
  //             Offers,
  //             activeCategories.contains('Offers') ? "yes" : "no"
  //         );
  //         await SPManager.instance.setContactDetails(
  //             ContactDetails,
  //             activeCategories.contains('Contact Details') ? "yes" : "no"
  //         );
  //
  //         ///for plan count
  //         int planViewCount =0;
  //         int planPostCount = 0;
  //         int planfeatureCount = 0;
  //         int planofferCount = 0;
  //         int planprojectCount = 0;
  //
  //
  //
  //         await SPManager.instance.setPlanViewCount(PLAN_VIEW, planViewCount);
  //         await SPManager.instance.setPlanPostCount(PLAN_POST, planPostCount);
  //
  //         await SPManager.instance.setPlanFeatureCount(PLAN_FEATURE, planfeatureCount);
  //         await SPManager.instance.setPlanOfferCount(PLAN_OFFER, planofferCount);
  //
  //         await SPManager.instance.setPlanProjectCount(PLAN_PROJECT, planprojectCount);
  //
  //
  //         int? storedViewCount = await SPManager.instance.getPlanViewCount(PLAN_VIEW);
  //
  //
  //         print("Stored1 free_view_count: $storedViewCount");
  //
  //       }
  //     } else {
  //       getHistoryList.clear();
  //       var responseBody = json.decode(response['body']);
  //       Fluttertoast.showToast(msg: responseBody['msg']);
  //     }
  //   } catch (e) {
  //     getHistoryList.clear();
  //     debugPrint("Error: $e");
  //   }
  // }

  Future<void> planStatus({ String? plan_auto_id,
    String? plan_purchased_auto_id,
    String? plan_status,
    String? category_type,
 }) async {
    String? userId = await SPManager.instance.getUserId(USER_ID);

    try {
      // plan_auto_id, user_id,plan_purchased_auto_id, plan_status
      var response = await HttpHandler.postHttpMethod(
        url: APIString.update_plan_status,
        data: {
          'user_id':userId,
          'plan_auto_id':plan_auto_id,
          'plan_purchased_auto_id':plan_purchased_auto_id,
          'plan_status':plan_status,

        },
      );
      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          //Fluttertoast.showToast(msg: response['body']['msg'].toString());
          if (response['body']['status'].toString() == "1") {
           // Fluttertoast.showToast(msg: response['body']['msg'].toString());

            print('paid_contact==>${category_type}');
            if(category_type=='Post Properties'){

              add_count(isfrom: 'paid_post',count:0 ).then((value) async {
                await SPManager.instance.setPaidPostCount(PAID_POST, 0);
              });

            }
            if(category_type=='Upcoming Projects'){
              add_count(isfrom: 'project',count:0 ).then((value) async {
                await SPManager.instance.setProjectCount(PAID_PROJECT, 0);
              });

            }
            if(category_type=='Featured Properties'){
              add_count(isfrom: 'feature',count:0 ).then((value) async {
                await SPManager.instance.setFeatureCount(PAID_FEATURE, 0);
              });

            }

            if(category_type=='Top Developers'){
              add_count(isfrom: 'mark_as',count:0 ).then((value) async {
                await SPManager.instance.setMarkDeveloperCount(PAID_MARKDEVELOPER, 0);
              });

            }
            if(category_type=='Offers'){
              add_count(isfrom: 'offer',count:0 ).then((value) async {
                await SPManager.instance.setOfferCount(PAID_OFFER, 0);
              });

            }
            if(category_type=='Contact Details'){
              add_count(isfrom: 'paid_contact',count:0 ).then((value) async {
                await SPManager.instance.setPaidViewCount(PAID_VIEW, 0);
              });

            }
          }

        }
      }
      else if (response['error'] != null) {

        var responseBody = json.decode(response['body']);
       // Fluttertoast.showToast(msg: responseBody['msg']);

      }
    } catch (e) {

      debugPrint("Login Error: $e");
     // Fluttertoast.showToast(msg: 'An error occurred. Please try again.');
    }
  }
var settingData = [].obs;
var freeCount = 0.obs;
var viewCount = 0.obs;
  Future<void> getSetting() async {
    settingData.clear();
    try {
      var response = await HttpHandler.getHttpMethod(
        url: APIString.get_setting,
      );
print("get setting response ${response}");
      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          log("get_setting  ---- ${response['body']["data"]}");
          var respData = response['body'];
          var settings = respData["data"][0];
          settingData.value = settingData;
          int freeViewCount = int.parse(settings['free_view_count'].toString());
          viewCount.value = int.parse(settings['free_view_count'].toString());
          freeViewCount=freeViewCount-1;
          int freePostCount = int.parse(settings['free_post_count'].toString());
          freeCount.value = int.parse(settings['free_post_count'].toString());
          freePostCount = freePostCount-1;
          await SPManager.instance.setSettingViewCount(SETTING_VIEW, freeViewCount);
          await SPManager.instance.setSettingPostCount(SETTING_POST, freePostCount);

        }
      } else {
        await SPManager.instance.setSettingViewCount(SETTING_VIEW, 1);
        await SPManager.instance.setSettingPostCount(SETTING_POST, 1);
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
  }


  Future<void> add_count({String? isfrom, int? count}) async {
    debugPrint("is_from==> ${isfrom}");
    debugPrint("count==> ${count}");
    try {
      String? userId = await SPManager.instance.getUserId(USER_ID);
      if (userId == null) {
        debugPrint("User ID not available");

        return;
      }

      // Prepare the base request data
      Map<String, String> requestData = {
        'user_id': userId,
        'is_from': isfrom ?? '',
      };

      // Add only the relevant count based on isfrom
      switch (isfrom) {
        case 'free_contact':
          requestData['free_view_count'] = count?.toString() ??
              (await SPManager.instance.getFreeViewCount(FREE_VIEW))?.toString() ?? '0';
          break;
        case 'paid_contact':
          requestData['paid_view_count'] = count?.toString() ??
              (await SPManager.instance.getPaidViewCount(PAID_VIEW))?.toString() ?? '0';
          break;
        case 'free_post':
          requestData['free_post_count'] = count?.toString() ??
              (await SPManager.instance.getFreePostCount(FREE_POST))?.toString() ?? '0';
          break;
        case 'paid_post':
          requestData['paid_post_count'] = count?.toString() ??
              (await SPManager.instance.getPaidPostCount(PAID_POST))?.toString() ?? '0';
          break;
        case 'feature':
          requestData['feature_count'] = count?.toString() ??
              (await SPManager.instance.getFeatureCount(PAID_FEATURE))?.toString() ?? '0';
          break;
        case 'mark_as':
          requestData['mark_as_developer'] = count?.toString() ??
              (await SPManager.instance.getMarkDeveloperCount(PAID_MARKDEVELOPER))?.toString() ?? '0';
          break;
        case 'offer':
          requestData['offer_count'] = count?.toString() ??
              (await SPManager.instance.getOfferCount(PAID_OFFER))?.toString() ?? '0';
          break;
        case 'project':
          requestData['upcoming_project_count'] = count?.toString() ??
              (await SPManager.instance.getProjectCount(PAID_PROJECT))?.toString() ?? '0';
          break;
        default:
          debugPrint("Invalid isfrom value: $isfrom");
          return;
      }

      var response = await HttpHandler.postHttpMethod(
        url: APIString.add_count,
        data: requestData,
      );

      debugPrint('add count response $response');

      if (response['error'] == null && response['body']['status'].toString() == "1") {
        debugPrint('add count successfully');
      } else if (response['error'] != null) {
        debugPrint("Error in response: ${response['error']}");
      }
    } catch (e) {
      debugPrint("add_count Error: $e");
    }
  }

}


