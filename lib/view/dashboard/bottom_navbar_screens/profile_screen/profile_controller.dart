import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:real_estate_app/global/widgets/loading_dialog.dart';
import 'package:real_estate_app/view/dashboard/view/BottomNavbar.dart';
import 'package:real_estate_app/view/property_screens/models/project_details_model.dart';
import 'package:real_estate_app/view/welcome_screen/view/welcome_screen.dart';

import '../../../../common_widgets/loading_dart.dart';
import '../../../../global/api_string.dart';
import '../../../../utils/String_constant.dart';
import '../../../../utils/network_http.dart';
import '../../../../utils/shared_preferences/shared_preferances.dart';
import '../../../splash_screen/splash_screen.dart';
import '../../../subscription model/controller/SubscriptionController.dart';


class ProfileController extends GetxController {
  final SubscriptionController Controller = Get.find<SubscriptionController>();
  final isPaginationLoading = false.obs;
  final hasMore = true.obs;
  final currentPage = 1.obs;
  final totalPages = 1.obs;
  final total_count = 0.obs;
  final sent_total_count = 0.obs;
  final recived_total_count = 0.obs;
  RxInt selectedIndex = (-1).obs; // No item selected initially

  final scrollController1 = ScrollController();
  final scrollController = ScrollController();


  TextEditingController currentPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmedPassword = TextEditingController();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController userController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController RatingController = TextEditingController();
  TextEditingController proprietorshipController = TextEditingController();
  TextEditingController experienceController = TextEditingController();

  TextEditingController searchController = TextEditingController();

  RxList developerData = [].obs;
  var postPropertiesPercentage = {}.obs;
  // RxString? name, email ,mobile;
  RxString userId = "".obs;
  RxString userType = "".obs;
  RxString buyCount = "0".obs;
  RxString rentCount = "0".obs;
  RxString commercialCount = "0".obs;
  RxString totalPropertyCount = "0".obs;
  RxInt paid_featured_count = 0.obs;
  RxInt paid_post_count = 0.obs;
  RxInt paid_project_count =0.obs;

  RxBool dynamic_price = false.obs;
  var profileImage = ''.obs;
  double rate=0.0;
  File? iconImg;
  //late XFile iconImg;
  RxList myListingPrperties = [].obs;
  RxList myselectedListing = [].obs;
  RxList myListingProject = [].obs;

  var projectDetails = ProjectDetailsModel().obs;
  RxList timeSlots = [].obs;
  RxList owner_timeSlots = [].obs;
  RxList virtual_tours_List = [].obs;
  RxList my_virtual_tours_List = [].obs;
  RxList propertyAgentList = [].obs;
  RxList propertyAgentDetails = [].obs;


  RxList projectAgentList =  [].obs;
  RxList projectAgentDetailsList = [].obs;
  var content;

  late XFile pickedImageFile;
  RxBool isIconSelected = false.obs;

  var isLoading = false.obs;
  final name = ''.obs;
  final mobile = ''.obs;
  final email = ''.obs;

  Future<void> getPropertyAgentProfile({
    String? page = '1',
    String? agentId,
    String? building_type,
    String? category_type
  }) async {
    // Only clear lists and show loading for initial page load when not filtering
    final isInitialLoad = page == '1';
    final isFiltering = building_type != null || category_type != null;

    if (isInitialLoad && !isFiltering) {
      propertyAgentList.clear();
      propertyAgentDetails.clear();
      isLoading.value = true;
      showHomLoading(Get.context!, 'Processing...');
    } else if (isInitialLoad) {
      propertyAgentList.clear();
      isLoading.value = true;
      showHomLoading(Get.context!, 'Processing...');
    } else {
      isPaginationLoading.value = true;
    }

    try {
      String? userId = await SPManager.instance.getUserId(USER_ID);
      Get.focusScope!.unfocus();

      var response = await HttpHandler.postHttpMethod(
        url: APIString.agent_property_list,
        data: {
          'property_category_type': category_type,
          'building_type': building_type,
          'user_id': agentId,
          'customer_id': userId,
          'page': page,
        },
      );

      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          log("response[data]  ---- ${response['body']["data"]}");
          var respData = response['body'];

          // Only update counts when not filtering
          if (!isFiltering) {
            buyCount.value = respData['buy_count'].toString();
            rentCount.value = respData['rent_count'].toString();
            commercialCount.value = respData['commercial_count'].toString();
            totalPropertyCount.value = respData['total_count'].toString();
          }

          currentPage.value = respData["current_page"] is int
              ? respData["current_page"]
              : int.tryParse(respData["current_page"].toString()) ?? currentPage.value;

          totalPages.value = respData["total_pages"] is int
              ? respData["total_pages"]
              : int.tryParse(respData["total_pages"].toString()) ?? totalPages.value;

          hasMore.value = currentPage.value < totalPages.value;
print('response data : ${respData["data"]}');
          propertyAgentList.addAll(respData["data"]);

          // Only update agent details when not filtering
          if (!isFiltering && respData["user_details"] != null) {
            propertyAgentDetails.addAll(respData["user_details"]);
          }

          print('agent property count : ${propertyAgentList.length} : $propertyAgentList');
          isLoading.value = false;
        } else {
          if (isInitialLoad) {
            propertyAgentList.clear();
            if (!isFiltering) {
              propertyAgentDetails.clear();
            }
          }
          hasMore.value = false;
        }
      }
      else if (response['error'] != null) {
        if (isInitialLoad) {
          propertyAgentList.clear();
          if (!isFiltering) {
            propertyAgentDetails.clear();
          }
        }
      }
    } catch (e) {
      propertyAgentList.clear();
      if (!isFiltering) {
        propertyAgentDetails.clear();
      }
      debugPrint("Login Error: $e");
    } finally {
      isLoading.value = false;
      isPaginationLoading.value = false;
      if (Navigator.canPop(Get.context!)) {
        Navigator.of(Get.context!).pop();
      }
    }
  }

  Future<void> getProjectAgentProfile({
    String? agentId,
    String? page = '1',
  }) async {
    final isInitialLoad = page == '1';

    if (isInitialLoad) {
      projectAgentList.clear();
      projectAgentDetailsList.clear();
      isLoading.value = true;
      showHomLoading(Get.context!, 'Processing...');
    } else {
      isPaginationLoading.value = true;
    }

    try {
      Get.focusScope!.unfocus();
      var response = await HttpHandler.postHttpMethod(
        url: APIString.agent_project_list,
        data: {
          'user_id': agentId,
          'page': page,
          'page_size': '10',
        },
      );

      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          log("response[data] ---- ${response['body']["data"]}");
          var respData = response['body'];
          totalPropertyCount.value = respData['total_count'].toString();
          // Update pagination variables
          currentPage.value = respData["current_page"] is int
              ? respData["current_page"]
              : int.tryParse(respData["current_page"].toString()) ?? currentPage.value;

          totalPages.value = respData["total_pages"] is int
              ? respData["total_pages"]
              : int.tryParse(respData["total_pages"].toString()) ?? totalPages.value;

          hasMore.value = currentPage.value < totalPages.value;

          if (isInitialLoad) {
            projectAgentList.value = respData["data"];
            projectAgentDetailsList.value = respData["user_details"];
          } else {
            projectAgentList.addAll(respData["data"]);
          }

          isLoading.value = false;
        } else {
          if (isInitialLoad) {
            projectAgentList.clear();
            projectAgentDetailsList.clear();
          }
          hasMore.value = false;
        }
      } else if (response['error'] != null) {
        if (isInitialLoad) {
          projectAgentList.clear();
          projectAgentDetailsList.clear();
        }
      }
    } catch (e) {
      if (isInitialLoad) {
        projectAgentList.clear();
        projectAgentDetailsList.clear();
      }
      debugPrint("Login Error: $e");
    } finally {
      isLoading.value = false;
      isPaginationLoading.value = false;
      if (Navigator.canPop(Get.context!)) {
        Navigator.of(Get.context!).pop();
      }
    }
  }

  Future<void> deleteUserAcc(BuildContext context) async {
    try {
      String? userId = await SPManager.instance.getUserId(USER_ID);
      String? name = await SPManager.instance.getUserId(NAME);
      String? email = await SPManager.instance.getUserId(EMAIL);
      showHomLoading(Get.context!, 'Processing...');
      isLoading.value = true;
      Get.focusScope!.unfocus();
      var response = await HttpHandler.postHttpMethod(
        url: APIString.delete_user,
        data: {
          'user_id':userId,
          'full_name':name,
          'email':email,
        },
      );
      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          log("response[data]  ---- ${response['body']["data"]}");
          var respData = response['body'];
          bool isCleared = await clearLocalStorage();
          // if (isCleared) {
          //   isLogin = false;
          //  // //Fluttertoast.showToast(msg: "You have logged out successfully.");
          //   Navigator.pushReplacementNamed(context, '/login');
          //   Navigator.of(context).pushAndRemoveUntil(
          //     MaterialPageRoute(builder: (context) => WelcomeScreen()),
          //         (Route<dynamic> route) => false,
          //   );
          // }
          if (isCleared) {

            isLogin = false;
            profileImage.value ='';

            Fluttertoast.showToast(msg: "You have logged out successfully.");
            // Navigator.pushReplacementNamed(context, '/login');
            Get.offAll(const BottomNavbar());
            // Navigator.of(context).pushAndRemoveUntil(
            //   MaterialPageRoute(builder: (context) => WelcomeScreen()),
            //   (Route<dynamic> route) => false,
            // );
          }
          else {
            print("Failed to clear local storage.");
          }
          isLoading.value = false;
        }else{
          // //Fluttertoast.showToast(msg: 'No Listing Found');
        }
      }
      else if (response['error'] != null) {
        // var responseBody = json.decode(response['body']);
        //  //Fluttertoast.showToast(msg: responseBody['msg']);
      }
    } catch (e) {
      projectAgentList.clear();
      projectAgentDetailsList.clear();
      debugPrint("Login Error: $e");
      ////Fluttertoast.showToast(msg: 'No Listing Found');
    }finally {
      isLoading.value = false;
      if (Navigator.canPop(Get.context!)) {
        Navigator.of(Get.context!).pop();
      }
    }
  }
  Future<void> getProfile() async {

    try {
      isLoading.value = true;
      // showLoadingDialog1(Get.context!, 'Processing...');
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

          final data = response['body']?["data"];
          final countData = response['body']?["count_data"];
          final devData = response['body']?["developer_data"];
          print('Email: ${data?['email']}');
          print('Full Name: ${data?['full_name']}');
          print('Mobile Number: ${data?['mobile_number']}');

          proprietorshipController.text = data?['proprietorship']?.toString() ?? "";
          name.value = data?['full_name']?.toString() ?? "";
          mobile.value = data?['mobile_number']?.toString() ?? "";
          email.value = data?['email']?.toString() ?? "";
          userType.value = data?['user_type']?.toString() ?? "";


          nameController.text = name.value;
          contactController.text = mobile.value;
          emailController.text = email.value;


          nameController.text = data?['full_name']?.toString() ?? "";
          emailController.text = data?['email']?.toString() ?? "";
          userController.text = data?['username']?.toString() ?? "";
          experienceController.text = data?['experience']?.toString() ?? "";
          postPropertiesPercentage.value = response['body']?["compare_data"];

          profileImage.value = data?['profile_image']?.toString() ?? "";

          contactController.text = data?['mobile_number']?.toString() ?? "";

          dynamic_price.value = data?['dynamic_pricing']?.toString() == "ON";

          if (devData != null) {
            developerData.value = devData;
          }

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

            await SPManager.instance.setFreeViewCount(FREE_VIEW, freeViewCount);
            await SPManager.instance.setFreePostCount(FREE_POST, freePostCount);
            await SPManager.instance.setPaidPostCount(PAID_POST, paidPostCount);
            await SPManager.instance.setPaidViewCount(PAID_VIEW, paidviewCount);
            await SPManager.instance.setFeatureCount(PAID_FEATURE, featureCount);
            await SPManager.instance.setOfferCount(PAID_OFFER, offerCount);
            await SPManager.instance.setProjectCount(PAID_PROJECT, projectCount);
            await SPManager.instance.setMarkDeveloperCount(PAID_MARKDEVELOPER, mark_as_developer_count);
          }

          Controller.getSetting();
          Controller.getSubscriptionHistory();

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
      isLoading.value = false;
      // hideLoadingDialog();
    }
  }

  // Future<void> edit() async {
  //   String? userId = await SPManager.instance.getUserId(USER_ID);
  //   try {
  //     showLoadingDialog1(Get.context!, 'Processing...');
  //     isLoading.value = true;
  //     Get.focusScope!.unfocus();
  //     XFile? xFile;
  //     final iconImg = this.iconImg;
  //     if (iconImg != null) {
  //       xFile = XFile(iconImg.path);
  //     }
  //     var response = await HttpHandler.formDataMethod(
  //       url: APIString.editProfile,
  //       apiMethod: "POST",
  //       body: {
  //         "full_name": nameController.text,
  //         "email": emailController.text,
  //         "mobile_number": contactController.text,
  //         "experience": experienceController.text,
  //         "proprietorship": proprietorshipController.text,
  //         "user_id": userId!,
  //       },
  //       imageKey: "profile_image",
  //       imagePath: xFile?.path,
  //     );
  //     log('response----- ${response["body"]}');
  //
  //     if (response['error'] == null) {
  //       if (response['body']['status'].toString() == "1") {
  //
  //         await SPManager.instance.setContact(CONTACT, nameController.text);
  //         await SPManager.instance.setName(NAME, contactController.text);
  //         await SPManager.instance.setEmail(EMAIL, emailController.text);
  //
  //        // //Fluttertoast.showToast(msg: response['body']['message'].toString());
  //         getProfile();
  //
  //         isLoading.value = false;
  //       } else if (response['body']['status'].toString() == "0") {
  //         print(response['body']['message'].toString());
  //         ////Fluttertoast.showToast(msg: response['body']['message'].toString());
  //       }
  //     }
  //   } catch (e, s) {
  //     debugPrint(" Error -- $e  $s");
  //   } finally {
  //     isLoading.value = false;
  //
  //     if (Navigator.canPop(Get.context!)) {
  //       Navigator.of(Get.context!).pop();
  //     }
  //   }
  // }

  Future<void> edit({bool isFromAsset = false}) async {
    String? userId = await SPManager.instance.getUserId(USER_ID);
    try {
      showHomLoading(Get.context!, 'Processing...');
      isLoading.value = true;
      Get.focusScope?.unfocus();

      XFile? xFile;
      final iconImg = this.iconImg;

      if (iconImg != null) {
        if (isFromAsset) {
          // Copy asset image to temp file
          final byteData = await rootBundle.load(iconImg.path); // Load from asset
          final tempDir = await getTemporaryDirectory();
          final file = File('${tempDir.path}/default_profile.png');
          await file.writeAsBytes(byteData.buffer.asUint8List());
          xFile = XFile(file.path);
        } else {
          xFile = XFile(iconImg.path);
        }
      }

      var response = await HttpHandler.formDataMethod(
        url: APIString.editProfile,
        apiMethod: "POST",
        body: {
          "full_name": nameController.text,
          "email": emailController.text,
          "mobile_number": contactController.text,
          "experience": experienceController.text,
          "proprietorship": proprietorshipController.text,
          "user_id": userId!,
        },
        imageKey: "profile_image",
        imagePath: xFile?.path,
      );

      log('response----- ${response["body"]}');

      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          await SPManager.instance.setContact(CONTACT, nameController.text);
          await SPManager.instance.setName(NAME, contactController.text);
          await SPManager.instance.setEmail(EMAIL, emailController.text);

          getProfile();
          isLoading.value = false;
        } else if (response['body']['status'].toString() == "0") {
          print(response['body']['message'].toString());
        }
      }
    } catch (e, s) {
      debugPrint("Error -- $e  $s");
    } finally {
      isLoading.value = false;
      if (Navigator.canPop(Get.context!)) {
        Navigator.of(Get.context!).pop();
      }
    }
  }


  Future<void> changePassword({ String? oldPassword,String? newPassword,String? confirmedPassword}) async {
    String? userId = await SPManager.instance.getUserId(USER_ID);
    try {
      var response = await HttpHandler.postHttpMethod(
        url: APIString.changePassword,
        data: {
          'user_id':userId,
          'old_password':oldPassword,
          'new_password':newPassword,
          'confirm_password':confirmedPassword,

        },
      );
      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          print(response['body']['message'].toString());
         // //Fluttertoast.showToast(msg: response['body']['message'].toString());

        }else{
          print(response['body']['message'].toString());
         // //Fluttertoast.showToast(msg: response['body']['message'].toString());
        }
      }
      else if (response['error'] != null) {
         print(response['body']['message'].toString());

      }
    } catch (e) {

      debugPrint("Login Error: $e");
     // //Fluttertoast.showToast(msg: 'An error occurred. Please try again.');
    }
  }

  Future<void> rateUs({ String? message,String? rating,}) async {
    String? userId = await SPManager.instance.getUserId(USER_ID);
    String? name = await SPManager.instance.getName(NAME);
    String? contact = await SPManager.instance.getContact(CONTACT);
    String? email = await SPManager.instance.getEmail(EMAIL);
    try {
      // user_id, name, contact_number, email, rating, feedback_msg
      var response = await HttpHandler.postHttpMethod(
        url: APIString.give_us_feedback,
        data: {
          'user_id':userId,
          'name':name,
          'email':"test@gmail.com",
          'rating':rating,
          'contact_number':contact,
          'feedback_msg':message,

        },
      );
      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {

          Get.back();
          Fluttertoast.showToast(msg: "Feedback sent successfully");
          RatingController.clear();

        }
      }
      else if (response['error'] != null) {

        print(response['body']['msg'].toString());


      }
    } catch (e) {
      debugPrint("Login Error: $e");

    }
  }

  Future<void> getMyListingProjects({String? isfrom, String? otherUserId, String? page = '1'})
  async {

    if (page == '1') {
      myListingProject.clear();
      isLoading.value = true;
      showHomLoading(Get.context!, 'Processing...');
    } else {
      isPaginationLoading.value = true;
    }

    String? userId;

    if (isfrom == 'search') {
      userId = "";
    } else if (isfrom == 'developer') {
      userId = otherUserId;
    } else {
      userId = await SPManager.instance.getUserId(USER_ID);
    }

    try {
      Get.focusScope?.unfocus();

      var response = await HttpHandler.postHttpMethod(
        url: APIString.get_project_list,
        data: {
          'user_id': userId,
          'page': page,
          'page_size': APIString.Index,
        },
      );

      if (response['error'] == null) {

        if (response['body']['status'].toString() == "1") {
          final respData = response['body'];
          List<dynamic> data = respData["data"];

          if (isfrom == 'developer') {
            data = data.where((item) => item['admin_approval'] == "Approved").toList();
          }

          currentPage.value = respData["current_page"] is int
              ? respData["current_page"]
              : int.tryParse(respData["current_page"].toString()) ?? currentPage.value;

          totalPages.value = respData["total_pages"] is int
              ? respData["total_pages"]
              : int.tryParse(respData["total_pages"].toString()) ?? totalPages.value;

          total_count.value = respData["total_count"] is int
              ? respData["total_count"]
              : int.tryParse(respData["total_count"].toString()) ?? total_count.value;

          hasMore.value = currentPage.value < totalPages.value;

          print("Called getMyListingProperties with page: $page");
          print("→ Updated currentPage: ${currentPage.value}, totalPages: ${totalPages.value}");

          myListingProject.addAll(data);
        }

        else {
          if (page == '1') {
            myListingProject.clear();
            //Fluttertoast.showToast(msg: 'No Listing Found');
          }
          hasMore.value = false;
        }

      } else {
        myListingProject.clear();
        var responseBody = json.decode(response['body']);
        //Fluttertoast.showToast(msg: responseBody['msg']);
      }
    } catch (e) {
      debugPrint("Listing Error: $e");
      if (page == '1') {
        myListingProject.clear();
      }
      //Fluttertoast.showToast(msg: 'No Listing Found');
    } finally {
      isLoading.value = false;
      isPaginationLoading.value = false;
      if (page == '1') {
        hideLoadingDialog();
      } else {

      }
    }
  }
  Future<void> getMySearchProjects(String searchKeyword, String page) async {
    String? userId = await SPManager.instance.getUserId(USER_ID);
    if (page == '1') {
      myListingProject.clear();
      isLoading.value = true;
      showHomLoading(Get.context!, 'Processing...');
    } else {
      isPaginationLoading.value = true;
    }

    try {
      Get.focusScope?.unfocus();

      var response = await HttpHandler.postHttpMethod(
        url: APIString.my_projects_search,
        data: {
          'user_id': userId,
          //  'search_keyword': "Rajwansh Property",
          'search_keyword': searchKeyword,
          'page': page,
          'page_size': APIString.Index,
        },
      );

      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          final respData = response['body'];
          List<dynamic> newItems = respData["data"];

          // Pagination setup
          currentPage.value = int.tryParse(respData["current_page"].toString()) ?? 1;
          totalPages.value = int.tryParse(respData["total_pages"].toString()) ?? 1;
          hasMore.value = currentPage.value < totalPages.value;

          myListingProject.addAll(newItems);
        } else {
          if (page == '1') {
            myListingProject.clear();
            //Fluttertoast.showToast(msg: 'No Listing Found');
          }
          hasMore.value = false;
        }
      } else {
        myListingProject.clear();
        var responseBody = json.decode(response['body']);
        //Fluttertoast.showToast(msg: responseBody['msg']);
      }
    } catch (e) {
      debugPrint("Search Error: $e");
      if (page == '1') {
        myListingProject.clear();
      }
      //Fluttertoast.showToast(msg: 'No Listing Found');
    } finally {
      isLoading.value = false;
      isPaginationLoading.value = false;
      if (page == '1') {
        hideLoadingDialog();
      } else {

      }
      // if (Navigator.canPop(Get.context!)) {
      //   Navigator.of(Get.context!).pop();
      // }
    }
  }



  Future<void> getProjectDetails({required String projectID}) async {
    String? userId = await SPManager.instance.getUserId(USER_ID);
    showHomLoading(Get.context!, 'Processing...');
    projectDetails.value = ProjectDetailsModel();
    print('api is calling...1');
    try {
      isLoading.value = true;
      Get.focusScope!.unfocus();
      var response = await HttpHandler.postHttpMethod(
        url: APIString.get_project_details,
        data: {
          'project_id': projectID,
          'user_id': userId,
        },
      );

      print('get builder project details API response : ${response}');
      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          log("response[data]  ----22 ${response['body']["data"]}");
          var respData = response['body'];
          projectDetails.value = ProjectDetailsModel.fromJson(respData);
          print('project details data response ${projectDetails.value}');
        } else {
          projectDetails.value = ProjectDetailsModel();
          //Fluttertoast.showToast(msg: 'No Listing Found');
        }
      } else if (response['error'] != null) {
        projectDetails.value = ProjectDetailsModel();
        var responseBody = json.decode(response['body']);
        //Fluttertoast.showToast(msg: responseBody['msg']);
      }
    } catch (e) {
      projectDetails.value = ProjectDetailsModel();
      debugPrint("project details error : $e");
      //Fluttertoast.showToast(msg: 'No Listing Found');
    } finally {
      isLoading.value = false;
      hideLoadingDialog();
      // if (Navigator.canPop(Get.context!)) {
      //   Navigator.of(Get.context!).pop();
      // }
    }
  }

  Future<void> deleteMyListing({String? id}) async {
    String? userId = await SPManager.instance.getUserId(USER_ID);
    showHomLoading(Get.context!, 'Processing...');
    try {
      var response = await HttpHandler.deleteHttpMethod(
        url: APIString.delete_listing_property,
        data: {
          'user_id': userId,
          'property_id': id,
        },
      );
      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          getMyListingProperties();
          update();
          //Fluttertoast.showToast(msg: 'Successfully deleted');
        }
      } else if (response['error'] != null) {

        var responseBody = json.decode(response['body']);
        //Fluttertoast.showToast(msg: responseBody['msg']);

      }
    } catch (e) {
      debugPrint("Login Error: $e");
      //Fluttertoast.showToast(msg: 'An error occurred. Please try again.');
    } finally {
      isLoading.value = false;
      hideLoadingDialog();
    }
  }
  Future<void> deleteMyProject({String? id}) async {

    showHomLoading(Get.context!, 'Processing...');
    try {
      var response = await HttpHandler.deleteHttpMethod(
        url: APIString.delete_project,
        data: {

          'project_id': id,
        },
      );
      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          getMyListingProjects();
          update();
          //Fluttertoast.showToast(msg: 'Successfully deleted');
        }
      } else if (response['error'] != null) {

        var responseBody = json.decode(response['body']);
        //Fluttertoast.showToast(msg: responseBody['msg']);

      }
    } catch (e) {
      debugPrint("Login Error: $e");
      //Fluttertoast.showToast(msg: 'An error occurred. Please try again.');
    } finally {
      isLoading.value = false;
      hideLoadingDialog();
    }
  }

  ///Property status
  Future<void> changePropertyStatus({String? id,String? available_status}) async {
    String? userId = await SPManager.instance.getUserId(USER_ID);
    showHomLoading(Get.context!, 'Processing...');
    try {
      var response = await HttpHandler.postHttpMethod(
        url: APIString.change_property_status,
        data: {

          'property_id': id,
          'user_id': userId,
          'available_status': available_status,
        },
      );
      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          getMyListingProperties();
          update();
          //Fluttertoast.showToast(msg: 'Successfully Changed');
        }
      } else if (response['error'] != null) {

        var responseBody = json.decode(response['body']);
        //Fluttertoast.showToast(msg: responseBody['msg']);

      }
    } catch (e) {
      debugPrint("Login Error: $e");
      //Fluttertoast.showToast(msg: 'An error occurred. Please try again.');
    } finally {
      isLoading.value = false;
      hideLoadingDialog();
    }
  }
  ///search my properties
  var sortBY = ''.obs;
  Future<void> getMySearchProperties({
    String? searchKeyword,
    String? page = '1',
    String? showFatured,
    String? isFrom,
    String? property_category_type,
    String? city,
    String? locality,
    String? property_type,
    String? min_price,
    String? max_price,
  }) async {
    String? userId = await SPManager.instance.getUserId(USER_ID);

    if (page == '1') {
      myListingPrperties.clear();
      isLoading.value = true;
      showHomLoading(Get.context!, 'Processing...');
    } else {
      isPaginationLoading.value = true;
    }

    try {
      Get.focusScope?.unfocus();

      // ✅ Dynamically build data map
      Map<String, dynamic> requestData = {
        'user_id': userId ?? '',
        'search_keyword': searchKeyword ?? '',
        'page': page ?? '1',
        'show_featured': showFatured ?? 'false',
        'page_size': APIString.Index ?? '10',
        'property_category_type': property_category_type ?? '',
        'city': city ?? '',
        'locality': locality ?? '',
        'property_type': property_type ?? '',
        'sort_by': sortBY.value ?? '',
      };

      // ✅ Add min_price only if not null or empty
      if (min_price != null && min_price.trim().isNotEmpty) {
        requestData['min_price'] = min_price;
      }

      // ✅ Add max_price only if not null or empty
      if (max_price != null && max_price.trim().isNotEmpty) {
        requestData['max_price'] = max_price;
      }

      var response = await HttpHandler.postHttpMethod(
        url: APIString.my_properties_search_filter,
        data: requestData,
      );

      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          final respData = response['body'];
          List<dynamic> newItems = respData["data"];

          // Pagination setup
          currentPage.value = int.tryParse(respData["current_page"].toString()) ?? 1;
          totalPages.value = int.tryParse(respData["total_pages"].toString()) ?? 1;
          hasMore.value = currentPage.value < totalPages.value;

          myListingPrperties.addAll(newItems);
        } else {
          if (page == '1') {
            myListingPrperties.clear();
          }
          hasMore.value = false;
        }
      } else {
        myListingPrperties.clear();
        var responseBody = json.decode(response['body']);
      }
    } catch (e) {
      debugPrint("Search Error: $e");
      if (page == '1') {
        myListingPrperties.clear();
      }
    } finally {
      isLoading.value = false;
      isPaginationLoading.value = false;
      if (page == '1') {
        hideLoadingDialog();
      }
    }
  }


  Future<void> getMyListingProperties({String? isfrom, String? otherUserId, String? page = '1'}) async {

    if (page == '1') {
      myListingPrperties.clear();
      isLoading.value = true;
      // showLoadingDialog1(Get.context!, 'Processing...');
    } else {
      isPaginationLoading.value = true;
    }

    String? userId;

    if (isfrom == 'search') {
      userId = "";
    } else if (isfrom == 'developer') {
      userId = otherUserId;
    } else {
      userId = await SPManager.instance.getUserId(USER_ID);
    }

    try {
      Get.focusScope?.unfocus();

      var response = await HttpHandler.postHttpMethod(
        url: APIString.getlistingproperties,
        data: {
          'user_id': userId,
          'page': page,
          'page_size': APIString.Index,
        },
      );

      if (response['error'] == null) {

        if (response['body']['status'].toString() == "1") {
          final respData = response['body'];
          List<dynamic> data = respData["data"];

          if (isfrom == 'developer') {
            data = data.where((item) => item['admin_approval'] == "Approved").toList();
          }

          currentPage.value = respData["current_page"] is int
              ? respData["current_page"]
              : int.tryParse(respData["current_page"].toString()) ?? currentPage.value;

          totalPages.value = respData["total_pages"] is int
              ? respData["total_pages"]
              : int.tryParse(respData["total_pages"].toString()) ?? totalPages.value;

          total_count.value = respData["total_count"] is int
              ? respData["total_count"]
              : int.tryParse(respData["total_count"].toString()) ?? 0;

          hasMore.value = currentPage.value < totalPages.value;

          print("Called getMyListingProperties with page: $page");
          print("→ Updated currentPage: ${currentPage.value}, totalPages: ${totalPages.value}");

          myListingPrperties.addAll(data);
        }

        else {
          if (page == '1') {
            myListingPrperties.clear();
            //Fluttertoast.showToast(msg: 'No Listing Found');
          }
          hasMore.value = false;
        }
      } else {
        myListingPrperties.clear();
        var responseBody = json.decode(response['body']);
        //Fluttertoast.showToast(msg: responseBody['msg']);
      }
    } catch (e) {
      debugPrint("Listing Error: $e");
      if (page == '1') {
        myListingPrperties.clear();
      }
      //Fluttertoast.showToast(msg: 'No Listing Found');
    } finally {
      isLoading.value = false;
      isPaginationLoading.value = false;
      if (page == '1') {
        // hideLoadingDialog();
      } else {

      }

     //  if (Navigator.canPop(Get.context!)) {
     //    Navigator.of(Get.context!).pop();
     //  }
    }
  }

  checkLogin() async {
    print("checkLogin");

    userId.value = await getUserId();
    isLogin = userId.value.isNotEmpty ?true:false;
    print("userId.value   ${userId.value}  $isLogin");

  }

  getUserId()async{
    String? userId = await SPManager.instance.getUserId(USER_ID);
    print("getDataFromLocalStorage   userId       $userId   ");
    return userId;
  }

  ///
  Future<void> getFaq() async {
    content="";
    try {
      var response = await HttpHandler.getHttpMethod(
        url: APIString.get_faqs,);
      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          log("response[data]  ---- ${response['body']["data"]}");
          var respData = response['body'];
          content = respData["data"][0]['content']??"No faq available";

          //Fluttertoast.showToast(msg: 'Fetch successfully');
        }else{

          content = "No data available";

        }
      }
      else if (response['error'] != null) {
        content = "No data available";
        ////Fluttertoast.showToast(msg: 'An error occurred. Please try again.');

      }
    } catch (e) {

      content = "No data available";
     // //Fluttertoast.showToast(msg: 'An error occurred. Please try again.');
    }
  }

  Future<void> getAboutUs() async {
    content="";
    try {
      var response = await HttpHandler.getHttpMethod(
        url: APIString.get_about_us,);
      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          log("response[data]  ---- ${response['body']["data"]}");
          var respData = response['body'];
          content = respData["data"][0]['content']??"No about us available";
          //Fluttertoast.showToast(msg: 'Fetch successfully');
        }else{
          content = "No data available";

        }
      }


      else if (response['error'] != null) {
        content = "No data available";

      //  //Fluttertoast.showToast(msg: 'An error occurred. Please try again.');

      }
    } catch (e) {
      content = "No data available";

      debugPrint(" Error: $e");
   //   //Fluttertoast.showToast(msg: 'An error occurred. Please try again.');
    }
  }

  Future<void> getPrivacyPolicy() async {
    content="";
    try {
      var response = await HttpHandler.getHttpMethod(
        url: APIString.get_privacy_policy,);
      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          log("response[data]  ---- ${response['body']["data"]}");
          var respData = response['body'];
          content = respData["data"][0]['content']??"No policy available";
          //Fluttertoast.showToast(msg: 'Fetch successfully');
        }else{
          content = "No Data available";

        }
      }
      else if (response['error'] != null) {
        content = "No Data available";
        ////Fluttertoast.showToast(msg: 'An error occurred. Please try again.');

      }
    } catch (e) {
      content = "No Data available";
      debugPrint(" Error: $e");
     // //Fluttertoast.showToast(msg: 'An error occurred. Please try again.');
    }
  }

  Future<void> getTandC() async {
    content="";
    try {
      var response = await HttpHandler.getHttpMethod(
        url: APIString.get_term_conditions,);
      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          log("response[data]  ---- ${response['body']["data"]}");
          var respData = response['body'];
          content = respData["data"][0]['content']??"No TandC available";

          //Fluttertoast.showToast(msg: 'Fetch successfully');
        }else{
          content = "No Data available";

        }
      }
      else if (response['error'] != null) {
        content = "No Data available";
        ////Fluttertoast.showToast(msg: 'An error occurred. Please try again.');

      }
    } catch (e) {
      content = "No Data available";
      debugPrint(" Error: $e");
   //   //Fluttertoast.showToast(msg: 'An error occurred. Please try again.');
    }
  }

  Future<void> addTime({String? timeSlot}) async {

    String? userId;
    userId = await SPManager.instance.getUserId(USER_ID);
    print("userId->$userId");

    try {
      showHomLoading(Get.context!, 'Processing...');
      isLoading.value = true;
      Get.focusScope!.unfocus();
      var response = await HttpHandler.postHttpMethod(
        url: APIString.add_timeslot,
        data: {
          'user_id':userId,
          'timeslot':timeSlot,
        },
      );
      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          log("response[data]  ---- ${response['body']["data"]}");
          getTime();
          isLoading.value = false;
        }else{
          //Fluttertoast.showToast(msg: 'No Listing Found');
        }
      }
      else if (response['error'] != null) {
        var responseBody = json.decode(response['body']);
        //Fluttertoast.showToast(msg: responseBody['msg']);
      }
    } catch (e) {
      timeSlots.clear();

      debugPrint("Login Error: $e");
      //Fluttertoast.showToast(msg: 'No Listing Found');
    }finally {
      isLoading.value = false;

      if (Navigator.canPop(Get.context!)) {
        Navigator.of(Get.context!).pop();
      }
    }
  }

  Future<void> getTime() async {

    timeSlots.clear();
    String? userId;

      userId = await SPManager.instance.getUserId(USER_ID);
      print("userId->$userId");

    try {
      showHomLoading(Get.context!, 'Processing...');
      isLoading.value = true;
      Get.focusScope!.unfocus();
      var response = await HttpHandler.postHttpMethod(
        url: APIString.get_timeslot,
        data: {
          'user_id':userId,
        },
      );
      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          log("response[data]  ---- ${response['body']["data"]}");
          var respData = response['body'];

          timeSlots.value = respData["data"];
          isLoading.value = false;
        }else{
          timeSlots.clear();
          //Fluttertoast.showToast(msg: 'No Listing Found');
        }
      }
      else if (response['error'] != null) {
        timeSlots.clear();

        var responseBody = json.decode(response['body']);
        //Fluttertoast.showToast(msg: responseBody['msg']);
      }
    } catch (e) {
      timeSlots.clear();

      debugPrint("Login Error: $e");
      //Fluttertoast.showToast(msg: 'No Listing Found');
    }finally {
      isLoading.value = false;

      if (Navigator.canPop(Get.context!)) {
        Navigator.of(Get.context!).pop();
      }
    }
  }

  Future<void> get_OwnerTimeslot(String owner_id) async {
    owner_timeSlots.clear();
    try {
      showHomLoading(Get.context!, 'Processing...');
      isLoading.value = true;
      Get.focusScope!.unfocus();
      var response = await HttpHandler.postHttpMethod(
        url: APIString.get_timeslot,
        data: {
          'user_id':owner_id,
        },
      );
      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          log("response[data]  ---- ${response['body']["data"]}");
          var respData = response['body'];

          owner_timeSlots.value = respData["data"];
          isLoading.value = false;
        }else{
          owner_timeSlots.clear();
         // //Fluttertoast.showToast(msg: 'No Listing Found');
        }
      }
      else if (response['error'] != null) {
        owner_timeSlots.clear();

       // var responseBody = json.decode(response['body']);
      //  //Fluttertoast.showToast(msg: responseBody['msg']);
      }
    } catch (e) {
      owner_timeSlots.clear();

      debugPrint("Login Error: $e");
      ////Fluttertoast.showToast(msg: 'No Listing Found');
    }finally {
      isLoading.value = false;

      if (Navigator.canPop(Get.context!)) {
        Navigator.of(Get.context!).pop();
      }
    }
  }

  Future<void> deleteTime({String? timeSlotId}) async {

    try {
      showHomLoading(Get.context!, 'Processing...');
      isLoading.value = true;
      Get.focusScope!.unfocus();
      var response = await HttpHandler.deleteHttpMethod(
        url: APIString.delete_timeslot,
        data: {
          'timeslot_id':timeSlotId,
        },
      );
      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          log("response[data]  ---- ${response['body']["data"]}");
          getTime();
          isLoading.value = false;
        }else{
          //Fluttertoast.showToast(msg: 'No Listing Found');
        }
      }
      else if (response['error'] != null) {
        var responseBody = json.decode(response['body']);
        //Fluttertoast.showToast(msg: responseBody['msg']);
      }
    } catch (e) {
      timeSlots.clear();

      debugPrint("Login Error: $e");
      //Fluttertoast.showToast(msg: 'No Listing Found');
    }finally {
      isLoading.value = false;

      if (Navigator.canPop(Get.context!)) {
        Navigator.of(Get.context!).pop();
      }
    }
  }
  Future<void> get_tour_List({
    String? page = '1',
    String? status,
  }) async {
    if (page == '1') {
      virtual_tours_List.clear();
      isLoading.value = true;
      showHomLoading(Get.context!, 'Processing...');
    } else {
      isPaginationLoading.value = true;
    }
    try {
      final userId = await SPManager.instance.getUserId(USER_ID);
      Get.focusScope!.unfocus();
      var data = {
        'user_id': userId,
        'page': page,
      };
      if (status != null && status.isNotEmpty && status != 'All') {
        data['status'] = status;
      }
      var response = await HttpHandler.postHttpMethod(
        url: APIString.get_virtual_tour_schedule,
        data: data,
      );
      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          log("response[data]  ---- ${response['body']['data']}");
          var respData = response['body'];
          var tourData = respData['data'] as List;
          // final sent_total_count = 0.obs;
          // final recived_total_count = 0.obs;
          currentPage.value = respData["current_page"] is int ? respData["current_page"] : int.tryParse(respData["current_page"].toString()) ?? currentPage.value;
          sent_total_count.value = respData["total_count"] is int ? respData["total_count"] : int.tryParse(respData["total_count"].toString()) ?? sent_total_count.value;

          totalPages.value = respData["total_pages"] is int
              ? respData["total_pages"]
              : int.tryParse(respData["total_pages"].toString()) ?? totalPages.value;

          hasMore.value = currentPage.value < totalPages.value;

          virtual_tours_List.addAll(tourData);
          print('tour ${tourData.length} tour, total: ${virtual_tours_List.length}');
        } else {
          if (page == '1') {
            virtual_tours_List.clear();
           // Fluttertoast.showToast(msg: 'No tours found for the selected filter');
          }
        }
      } else {
        if (page == '1') {
          virtual_tours_List.clear();
          var responseBody = json.decode(response['body']);
         // Fluttertoast.showToast(msg: responseBody['msg'] ?? 'Error fetching tours');
        }
      }
    } catch (e) {
      if (page == '1') {
        virtual_tours_List.clear();
        //Fluttertoast.showToast(msg: 'Error fetching tours: $e');
      }
      debugPrint("Fetch Tours Error: $e");
    } finally {
      if (page == '1') {
        isLoading.value = false;
        isPaginationLoading.value = false;
        if (Navigator.canPop(Get.context!)) {
          Navigator.of(Get.context!).pop();
        }
      } else {
        isPaginationLoading.value = false; // Corrected: Set to false for pagination
      }
    }
  }

// Corrected get_mySchedules_List
  Future<void> get_mySchedules_List({
    String? page = '1',
    String? status,
  }) async {
    if (page == '1') {
      my_virtual_tours_List.clear();
      isLoading.value = true;
      showHomLoading(Get.context!, 'Processing...');
    } else {
      isPaginationLoading.value = true;
    }
    try {
      final userId = await SPManager.instance.getUserId(USER_ID);
      Get.focusScope!.unfocus();
      var data = {
        'property_owner_id': userId,
        'page': page,
      };
      if (status != null && status.isNotEmpty && status != 'All') {
        data['status'] = status;
      }
      var response = await HttpHandler.postHttpMethod(
        url: APIString.get_virtual_tour_schedule,
        data: data,
      );
      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          log("response[data]  ---- ${response['body']['data']}");
          var respData = response['body'];
          var tourData = respData['data'] as List;

          currentPage.value = respData["current_page"] is int
              ? respData["current_page"]
              : int.tryParse(respData["current_page"].toString()) ?? currentPage.value;
          recived_total_count.value = respData["total_count"] is int ? respData["total_count"] : int.tryParse(respData["total_count"].toString()) ?? recived_total_count.value;

          totalPages.value = respData["total_pages"] is int
              ? respData["total_pages"]
              : int.tryParse(respData["total_pages"].toString()) ?? totalPages.value;

          hasMore.value = currentPage.value < totalPages.value;

          my_virtual_tours_List.addAll(tourData);
          print('tour length ${tourData.length} tour, total: ${my_virtual_tours_List.length}');
        } else {
          if (page == '1') {
            my_virtual_tours_List.clear();
          //  Fluttertoast.showToast(msg: 'No schedules found for the selected filter');
          }
        }
      } else {
        if (page == '1') {
          my_virtual_tours_List.clear();
          var responseBody = json.decode(response['body']);
         // Fluttertoast.showToast(msg: responseBody['msg'] ?? 'Error fetching schedules');
        }
      }
    } catch (e) {
      if (page == '1') {
        my_virtual_tours_List.clear();
        //Fluttertoast.showToast(msg: 'Error fetching schedules: $e');
      }
      debugPrint("Fetch Schedules Error: $e");
    } finally {
      if (page == '1') {
        isLoading.value = false;
        isPaginationLoading.value = false;
        if (Navigator.canPop(Get.context!)) {
          Navigator.of(Get.context!).pop();
        }
      } else {
        isPaginationLoading.value = false; // Corrected: Set to false for pagination
      }
    }
  }
  Future<void> update_tour_Status({String? tour_id,String? Status,String? from}) async {

    try {
      showHomLoading(Get.context!, 'Processing...');
      isLoading.value = true;
      Get.focusScope!.unfocus();
      var response = await HttpHandler.postHttpMethod(
        url: APIString.update_tour_status,
        data: {
          'tour_schedule_id':tour_id,
          'status':Status,
        },
      );
      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          log("response[data]  ---- ${response['body']["data"]}");

          isLoading.value = false;
        }else{
          //Fluttertoast.showToast(msg: 'No Listing Found');
        }
      }
      else if (response['error'] != null) {
        var responseBody = json.decode(response['body']);
        //Fluttertoast.showToast(msg: responseBody['msg']);
      }
    } catch (e) {

      debugPrint("Login Error: $e");
      //Fluttertoast.showToast(msg: 'No Listing Found');
    }finally {
      isLoading.value = false;

      if (Navigator.canPop(Get.context!)) {
        Navigator.of(Get.context!).pop();
      }
    }
  }
}