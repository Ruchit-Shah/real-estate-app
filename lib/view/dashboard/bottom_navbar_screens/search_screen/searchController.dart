import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:intl/intl.dart';
import 'package:real_estate_app/global/widgets/loading_dialog.dart';
import 'package:real_estate_app/utils/String_constant.dart';
import 'package:real_estate_app/view/property_screens/models/property_details_model.dart';

import '../../../../common_widgets/loading_dart.dart';
import '../../../../global/api_string.dart';
import '../../../../utils/network_http.dart';
import '../../../../utils/shared_preferences/shared_preferances.dart';
import '../../../subscription model/controller/SubscriptionController.dart';
import '../profile_screen/profile_controller.dart';

class searchController extends GetxController{
  SubscriptionController _subscriptionController = Get.find<SubscriptionController>();
  var isLoading = false.obs;
  var propertyDetails = PropertyDetailsModel().obs;
  final List<String> propertyFrom = ['Property in Mumbai', 'Property in Delhi',
    'Property in Chennai', 'Property in Bangalore ','Property in Pune', 'Property in Hyderabad'];
  RxString selectedPropertyType = ''.obs;
  var isContact = ''.obs;
  var count = 0.obs;
  var setting_count = 0.obs;
  var paidCount = 0.obs;
  var planCount = 0.obs;


  String selectedLocation = "";
  List<String> lookingFor = [];
  double budget = 0.0;
  double _selectedArea = 0.0;
  String selectedGender = "";
  List<String> selectAmenities = [];

  String selectedRoomType = "";
  List<String> lookingforRoom = [];

 RxBool isFavorited = false.obs;
  String selectedBrand = "";

  double minBudget = 0.0;
  double maxBudget = 10000.0;

  RxList getFavoriteList = [].obs;
  RxList getFavoriteProjectList = [].obs;
  RxList getRecentSearchList = [].obs;
  RxList getViewlist = [].obs;
  RxList getContactedlist = [].obs;

  Future<void> addPropertyEnquiry( {String? property_id,String? name,String? number,String? owner_id,String? message,String? enquiry_bhk_type}) async {
    showHomLoading(Get.context!, 'Processing...');
    String? userId = await SPManager.instance.getUserId(USER_ID);
    String? sessionName = await SPManager.instance.getName(NAME);
    String? contact = await SPManager.instance.getContact(CONTACT);
    String? email = await SPManager.instance.getEmail(EMAIL);
    try {
      // property_id, name, user_id, email, contact_number,message
      var response = await HttpHandler.postHttpMethod(
        url: APIString.add_property_enquiry,
        data: {
          'user_id':owner_id,
          'customer_id': userId,
          'name':name ?? sessionName,
          'email':email,
          'property_id':property_id,
          'message':message,
          'enquiry_type':'Property',
          'contact_number': number ?? contact,
          // 'enquiry_bhk_type': enquiry_bhk_type,
          'time_date': DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now()),
        },
      );
      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          print(response['body']['msg'].toString());
          Fluttertoast.showToast(msg: response['body']['msg'].toString());

          Future.delayed(const Duration(seconds: 1), () {
            navigator?.pop();
          });
        }
      }
      else if (response['error'] != null) {
        hideLoadingDialog();
        var responseBody = json.decode(response['body']);
        Fluttertoast.showToast(msg: responseBody['msg']);

      }
    } catch (e) {
      hideLoadingDialog();
      debugPrint("Login Error: $e");
      Fluttertoast.showToast(msg: 'An error occurred. Please try again.');
    }
    finally{
      hideLoadingDialog();
    }
  }
  Future<void> addProjectEnquiry( {String? property_id,String? name,String? number,String? owner_id,String? message}) async {
    showHomLoading(Get.context!, 'Processing...');
    String? userId = await SPManager.instance.getUserId(USER_ID);
    String? sessionName = await SPManager.instance.getName(NAME);
    String? contact = await SPManager.instance.getContact(CONTACT);
    String? email = await SPManager.instance.getEmail(EMAIL);
    try {
      // property_id, name, user_id, email, contact_number,message
      var response = await HttpHandler.postHttpMethod(
        url: APIString.add_project_enquiry,
        data: {
          'user_id':owner_id,
          'customer_id': userId,
          'name':name ?? sessionName,
          'email':email,
          'project_id':property_id,
          'message':message,
          'enquiry_type':'Project',
          'contact_number': number ?? contact,
          'time_date': DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now()),
        },
      );
      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          print(response['body']['msg'].toString());
          Fluttertoast.showToast(msg: response['body']['msg'].toString());

          Future.delayed(const Duration(seconds: 1), () {
            navigator?.pop();
          });
        }
      }
      else if (response['error'] != null) {
        hideLoadingDialog();
        var responseBody = json.decode(response['body']);
        Fluttertoast.showToast(msg: responseBody['msg']);

      }
    } catch (e) {
      hideLoadingDialog();
      debugPrint("Login Error: $e");
      Fluttertoast.showToast(msg: 'An error occurred. Please try again.');
    }
    finally{
      hideLoadingDialog();
    }
  }
  Future<void> getContacted() async {
    String? userId = await SPManager.instance.getUserId(USER_ID);
    getContactedlist.clear();


    try {

      var response = await HttpHandler.postHttpMethod(
        url: APIString.get_contact,
        data: {
          'user_id':userId,

        },
      );

      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {

          log("response[data]  ---- ${response['body']["data"]}");
          var respData = response['body'];
          getContactedlist.value = respData["data"];
          Fluttertoast.showToast(msg: 'Fetch successfully');
        }else{
          getContactedlist.clear();
        }
      }
      else if (response['error'] != null) {
        getContactedlist.clear();
        var responseBody = json.decode(response['body']);
        Fluttertoast.showToast(msg: responseBody['msg']);

      }
    } catch (e) {
      getContactedlist.clear();
      debugPrint(" Error: $e");
      Fluttertoast.showToast(msg: 'An error occurred. Please try again.');
    }
  }

  Future<void> addContact({String? property_id,String? owner_id}) async {
    showHomLoading(Get.context!, 'Processing...');

    isLoading.value = true;
    String? userId = await SPManager.instance.getUserId(USER_ID);
    try {

      var response = await HttpHandler.postHttpMethod(
        url: APIString.add_contact,
        data: {
          'user_id':userId,
          'property_id':property_id,
        },
      );

      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          isLoading.value = false;

          int? free_count = await SPManager.instance.getFreeViewCount(FREE_VIEW)??0;
          String isContact= (await SPManager.instance.getContactDetails(ContactDetails))??"no";
          int? setting_count=  (await SPManager.instance.getSettingViewCount(SETTING_VIEW))??2;
          int? paidCount=  (await SPManager.instance.getPaidViewCount(PAID_VIEW))??0;
          int? planCount=  (await SPManager.instance.getPlanViewCount(PLAN_VIEW))??0;

          print('isContact==>');
          print(isContact);
          print(free_count);
          if( isContact =='no'){
            if( free_count <= setting_count){
              int count = free_count+1 ;
              _subscriptionController.add_count(isfrom: 'free_contact',count:count ).then((value) async {
                await SPManager.instance.setFreeViewCount(FREE_VIEW, count);
              });
              print('testing--');
              print(free_count);
            }
          }
          else{
            print('paidCount--');
            print(paidCount);
            print(planCount);
            if( paidCount <= planCount){
              int count = paidCount+1 ;
              _subscriptionController.add_count(isfrom: 'paid_contact',count:count ).then((value) async {
                await SPManager.instance.setPaidViewCount(PAID_VIEW, count);
              });
              print('testing--');
              print(paidCount);
            }
          }

          //Fluttertoast.showToast(msg: 'successfully!!!');

        }
      }
      else if (response['error'] != null) {
        isLoading.value = false;

       // Fluttertoast.showToast(msg: 'An error occurred. Please try again.');

      }
    } catch (e) {
      isLoading.value = false;

      debugPrint("Login Error: $e");
    // Fluttertoast.showToast(msg: 'An error occurred. Please try again.');
    }finally {

      if (Navigator.canPop(Get.context!)) {
        Navigator.of(Get.context!).pop();
      }


      isLoading.value = false;
    }
  }

  /// favorite properties
  Future<void> getFavorite() async {
    String? userId = await SPManager.instance.getUserId(USER_ID);
    getFavoriteList.clear();

    try {

      var response = await HttpHandler.postHttpMethod(
        url: APIString.get_favorite_properties,
        data: {
          'user_id':userId,
        },
      );
      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {

          log("response[data]  ---- ${response['body']["data"]}");
          var respData = response['body'];
          getFavoriteList.value = respData["data"];
          //Fluttertoast.showToast(msg: 'Fetch successfully');
        }else{
          getFavoriteList.clear();
          Fluttertoast.showToast(msg: 'Data no available');
        }
      }
      else if (response['error'] != null) {
        getFavoriteList.clear();
        // var responseBody = json.decode(response['body']);
        // Fluttertoast.showToast(msg: responseBody['msg']);
      }
    } catch (e) {
      getFavoriteList.clear();
      debugPrint(" Error: $e");
      Fluttertoast.showToast(msg: 'An error occurred. Please try again2.');
    }
  }
  Future<void> addFavorite({String? property_id }) async {
    showHomLoading(Get.context!, 'Processing...');

    isLoading.value = true;
    String? userId = await SPManager.instance.getUserId(USER_ID);
    try {

      var response = await HttpHandler.postHttpMethod(
        url: APIString.add_to_favorite,
        data: {
          'user_id':userId,
          'property_id':property_id,

        },
      );

      if (response['error'] == null) {
       if (response['body']['status'].toString() == "1") {
          isLoading.value = false;

          //Fluttertoast.showToast(msg: 'successfully saved!!!');

        }
      }
      else if (response['error'] != null) {
        isLoading.value = false;

        var responseBody = json.decode(response['body']);
       // Fluttertoast.showToast(msg: responseBody['msg']);

      }
    } catch (e) {
      isLoading.value = false;

      debugPrint("Login Error: $e");
     // Fluttertoast.showToast(msg: 'An error occurred. Please try again.');
    }finally {

      if (Navigator.canPop(Get.context!)) {
        Navigator.of(Get.context!).pop();
      }
      isLoading.value = false;
    }
  }
  Future<void> removeFavorite({String? property_id,String? favorite_id}) async {
    String? userId = await SPManager.instance.getUserId(USER_ID);
    showHomLoading(Get.context!, 'Processing...');
    try {
      var response = await HttpHandler.deleteHttpMethod(
        url: APIString.remove_from_favorite,
        data: {
          'user_id': userId,
          'property_id': property_id,
          'favorite_id': favorite_id,
        },
      );
      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
         // getAmenities();
          getFavorite();
        //  Fluttertoast.showToast(msg: 'Successfully removed');
        }
      } else if (response['error'] != null) {
        //var responseBody = json.decode(response['body']);
      //  Fluttertoast.showToast(msg: responseBody['msg']);
      }
    } catch (e) {
     // debugPrint("Login Error: $e");
     // Fluttertoast.showToast(msg: 'An error occurred. Please try again.');
    } finally {
hideLoadingDialog();
    }
  }

  /// favorite project
  Future<void> getFavoriteProject() async {
    String? userId = await SPManager.instance.getUserId(USER_ID);
    getFavoriteProjectList.clear();

    try {

      var response = await HttpHandler.postHttpMethod(
        url: APIString.get_favorite_projects,
        data: {
          'user_id':userId,
        },
      );
      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {

          log("response[data]  ---- ${response['body']["data"]}");
          var respData = response['body'];
          getFavoriteProjectList.value = respData["data"];
          //Fluttertoast.showToast(msg: 'Fetch successfully');
        }else{
          getFavoriteProjectList.clear();
          Fluttertoast.showToast(msg: 'Data no available');
        }
      }
      else if (response['error'] != null) {
        getFavoriteProjectList.clear();
        // var responseBody = json.decode(response['body']);
        // Fluttertoast.showToast(msg: responseBody['msg']);
      }
    } catch (e) {
      getFavoriteProjectList.clear();
      debugPrint(" Error: $e");
      Fluttertoast.showToast(msg: 'An error occurred. Please try again2.');
    }
  }
  Future<void> addFavoriteProject({String? project_id }) async {
    showHomLoading(Get.context!, 'Processing...');

    isLoading.value = true;
    String? userId = await SPManager.instance.getUserId(USER_ID);
    try {

      var response = await HttpHandler.postHttpMethod(
        url: APIString.add_favorite_project,
        data: {
          'user_id':userId,
          'project_id':project_id,

        },
      );

      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          isLoading.value = false;

          //Fluttertoast.showToast(msg: 'successfully saved!!!');

        }
      }
      else if (response['error'] != null) {
        isLoading.value = false;

        var responseBody = json.decode(response['body']);
        // Fluttertoast.showToast(msg: responseBody['msg']);

      }
    } catch (e) {
      isLoading.value = false;

      debugPrint("Login Error: $e");
      // Fluttertoast.showToast(msg: 'An error occurred. Please try again.');
    }finally {

      if (Navigator.canPop(Get.context!)) {
        Navigator.of(Get.context!).pop();
      }
      isLoading.value = false;
    }
  }
  Future<void> removeFavoriteProject({String? project_id,String? favorite_id}) async {
    String? userId = await SPManager.instance.getUserId(USER_ID);
    showHomLoading(Get.context!, 'Processing...');
    try {
      var response = await HttpHandler.deleteHttpMethod(
        url: APIString.remove_favorite_project,
        data: {
          'user_id': userId,
          'project_id': project_id,
          'favorite_id': favorite_id,
        },
      );
      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          // getAmenities();
          getFavorite();
          //  Fluttertoast.showToast(msg: 'Successfully removed');
        }
      } else if (response['error'] != null) {
        //var responseBody = json.decode(response['body']);
        //  Fluttertoast.showToast(msg: responseBody['msg']);
      }
    } catch (e) {
      // debugPrint("Login Error: $e");
      // Fluttertoast.showToast(msg: 'An error occurred. Please try again.');
    } finally {
      hideLoadingDialog();
    }
  }

  Future getPropertyDetails({String? property_id }) async {
    propertyDetails.value = PropertyDetailsModel();
    String? userId = await SPManager.instance.getUserId(USER_ID);
    showHomLoading(Get.context!, 'Processing...');
    isLoading.value = true;

   try {

      var response = await HttpHandler.postHttpMethod(
        url: APIString.get_property_details,
        data: {
          'property_id': property_id,
          'user_id': userId,
        },
      );
      if (response['error'] == null && response['body']['status'].toString() == "1") {
        log("response[data]  ----22 ${response['body']["data"]}");
        var respData = response['body'];
        propertyDetails.value = PropertyDetailsModel.fromJson(respData);
        print('project details data response ${propertyDetails.value}');
        //Fluttertoast.showToast(msg: 'successful.');
      } else {
        propertyDetails.value = PropertyDetailsModel();
        var responseBody = json.decode(response['body']);
        Fluttertoast.showToast(msg: responseBody['msg']);
      }
    } catch (e) {
      propertyDetails.value = PropertyDetailsModel();
      debugPrint("Error: $e");
      //Fluttertoast.showToast(msg: 'An error occurred. Please try again2.');
    } finally {
      isLoading.value = false;
      if (Navigator.canPop(Get.context!)) {
        Navigator.of(Get.context!).pop();
      }
    }
  }

  Future<void> addView({String? property_id,String? owner_id }) async {

    String? userId = await SPManager.instance.getUserId(USER_ID);
    try {

      var response = await HttpHandler.postHttpMethod(
        url: APIString.add_view_property,
        data: {
          'user_id':owner_id, // property owner id
          'property_id':property_id,
          'customer_id':userId,
        },
      );

      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {

        }
      }
      else if (response['error'] != null) {

      }
    } catch (e) {
      debugPrint("Login Error: $e");
    }
  }
  Future<void> addProjectView({String? project_id,String? owner_id }) async {

    String? userId = await SPManager.instance.getUserId(USER_ID);
    try {

      var response = await HttpHandler.postHttpMethod(
        url: APIString.add_view_project,
        data: {
          'user_id':owner_id, // project owner id
          'project_id':project_id,
          'customer_id':userId,
        },
      );

      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {

        }
      }
      else if (response['error'] != null) {

      }
    } catch (e) {
      debugPrint("Login Error: $e");
    }
  }

  Future<void> getViewList() async {
    String? userId = await SPManager.instance.getUserId(USER_ID);
    getViewlist.clear();

    try {

      var response = await HttpHandler.postHttpMethod(
        url: APIString.get_view_property,
        data: {
          'user_id':userId,
        },
      );

      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {

          log("response[data]  ---- ${response['body']["data"]}");
          var respData = response['body'];
          getViewlist.value = respData["data"];
          Fluttertoast.showToast(msg: 'Fetch successfully');
        }else{
          getViewlist.clear();
        }
      }
      else if (response['error'] != null) {
        getViewlist.clear();
        var responseBody = json.decode(response['body']);
        Fluttertoast.showToast(msg: responseBody['msg']);

      }
    } catch (e) {
      getViewlist.clear();
      debugPrint(" Error: $e");
      Fluttertoast.showToast(msg: 'An error occurred. Please try again.');
    }
  }

  Future<void> addRecentSearch({String? property_id }) async {
    // showLoadingDialog1(Get.context!, 'Processing...');

    // isLoading.value = true;
    String? userId = await SPManager.instance.getUserId(USER_ID);
    try {

      var response = await HttpHandler.postHttpMethod(
        url: APIString.addRecentSearchProperties,
        data: {
          'user_id':userId,
          'property_id':property_id,

        },
      );

      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          // isLoading.value = false;

          Fluttertoast.showToast(msg: 'successfully saved!!!');

        }
      }
      else if (response['error'] != null) {
        // isLoading.value = false;

        var responseBody = json.decode(response['body']);
        Fluttertoast.showToast(msg: responseBody['msg']);

      }
    } catch (e) {
      // isLoading.value = false;

      debugPrint("Login Error: $e");
      Fluttertoast.showToast(msg: 'An error occurred. Please try again.');
    }
  }

  Future<void> getRecentSearch() async {
    String? userId = await SPManager.instance.getUserId(USER_ID);
    getRecentSearchList.clear();


    try {

      var response = await HttpHandler.postHttpMethod(
        url: APIString.getRecentSearchProperties,
        data: {
          'user_id':userId,

        },
      );

      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {

          log("response[data]  ---- ${response['body']["data"]}");
          var respData = response['body'];
          getRecentSearchList.value = respData["data"];
          Fluttertoast.showToast(msg: 'Fetch successfully');
        }else{
          getRecentSearchList.clear();
        }
      }
      else if (response['error'] != null) {
        getRecentSearchList.clear();
        var responseBody = json.decode(response['body']);
        Fluttertoast.showToast(msg: responseBody['msg']);

      }
    } catch (e) {
      getRecentSearchList.clear();
      debugPrint(" Error: $e");
      Fluttertoast.showToast(msg: 'An error occurred. Please try again.');
    }
  }


  getsessionData() async {
   isContact.value= (await SPManager.instance.getContactDetails(ContactDetails))??"no";
  count.value=  (await SPManager.instance.getFreeViewCount(FREE_VIEW))??0;
   setting_count.value=  (await SPManager.instance.getSettingViewCount(SETTING_VIEW))??2;
   paidCount.value=  (await SPManager.instance.getPaidViewCount(PAID_VIEW))??0;
   planCount.value=  (await SPManager.instance.getPlanViewCount(PLAN_VIEW))??0;

    print('getData()-->');
    print(isContact.value);
    print(count.value);
    print(setting_count.value);
    print(paidCount.value);
    print(planCount.value);

  }
}

