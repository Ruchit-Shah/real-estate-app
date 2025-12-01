import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:real_estate_app/view/shorts/controller/profile_videos_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../global/api_string.dart';
import '../../../global/services/api_shorts_string.dart';
import '../../../global/services/network_http.dart';
import '../../../global/widgets/loading_dialog.dart';
import '../../../utils/String_constant.dart';
import '../../../utils/common_snackbar.dart';
import '../../../utils/shared_preferences/shared_preferances.dart';
import '../../splash_screen/splash_screen.dart';

class MyProfileController extends GetxController {
  ProfileVideosController? profileVideosController;

  @override
  void onInit() {
    super.onInit();
    print("called my profile on init");
    checkLogin();
    Get.lazyPut(() => ProfileVideosController());
    profileVideosController = Get.find<ProfileVideosController>();

  }
  RxString userId = "".obs;
  RxString cityName = "".obs;
  RxString phoneNo = "".obs;
  RxBool isLogin = false.obs;

  checkLogin() async {
    print("checkLogin   MyProfileController");

    userId.value = (await SPManager.instance.getUserId(USER_ID))??"";
    isLogin.value = userId.value.isNotEmpty ?true:false;
    print("userId.value   ${userId.value}  ${isLogin.value}");
    if (userId.value.isNotEmpty) {
      getProfileApi();
    }
  }

  RxMap myProfileData = {}.obs;
  RxMap userProfileData = {}.obs;
  RxMap LiveData = {}.obs;

  Rx<TextEditingController> name = TextEditingController().obs;
  Rx<TextEditingController> email = TextEditingController().obs;
  Rx<TextEditingController> city = TextEditingController().obs;

  final TextEditingController mobileController=TextEditingController();

  String? mobileNumber;
  RxString countryCode = "IN".obs;
  RxString phoneCode=''.obs;
  RxString countryName='India'.obs;

  Rx<TextEditingController> dob = TextEditingController().obs;

  Rx<DateTime> selectedDate = DateTime.now().obs;

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime(1940),
      // lastDate: DateTime(2101),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != selectedDate.value) {
      selectedDate.value = picked;
    }
  }

  final TextEditingController userNameController=TextEditingController();
  RxString userName=''.obs;
  RxString commentuserName=''.obs;
  RxBool usernameChangesStart=false.obs;
  RxBool isUsernameLoading=false.obs;
  RxBool isUsernameValid=false.obs;

  RxString selectedGender = "".obs;

  RxString accountType = "".obs;

  RxBool isIconSelected = false.obs;

  Future getProfileApi({bool isMyProfile = true,profileId}) async {
    userProfileData.clear();
    print('getProfile userId.value  ${userId.value}');

    try {
      var response = await HttpHandler.postHttpMethod(url: APIString.getProfile,
          data: {"user_id": isMyProfile == true ?userId.value : profileId});

      log("getProfile  :: response  :: ${response["body"]}");

      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          if(isMyProfile == true){
            myProfileData.value = response['body']['data'];
            SharedPreferences prefs = await SharedPreferences.getInstance();
            accountType.value = myProfileData['user_data']["account_type"]??"";
            mobileController.text = myProfileData['user_data']["mobile_number"].toString()??"";
            phoneNo.value = myProfileData['user_data']["mobile_number"].toString()??"";
            commentuserName.value = myProfileData['user_data']["username"]??'';
            cityName.value = myProfileData['user_data']["city"]??"";
            prefs.setString('user_city', cityName.value);

          }
          else{
            userProfileData.value = response['body']['data'];

            print("userProfileData.value  after success :: $userProfileData");
          }
        } else if (response['body']['status'].toString() == "0") {
          showSnackbar(message:'Please Login');
        }
      } else if (response['error'] != null) {}
    } catch (e, s) {
      hideLoadingDialog();
      debugPrint("getProfile Error -- $e  $s");
    }
  }

  //  File? iconImg;
  updateProfile({String? name,String? dob,String? gender,String? token,
    String? mobileNo,String? countryCode,String? country,String? username,String? email,String? city,var image,String? privacy}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      showLoadingDialog();
      Get.focusScope!.unfocus();
      XFile? xFile;
      if( image != null){
      xFile =  XFile(image.path);
       }
      var response = await HttpHandler.formDataMethod(
          url: APIString.editProfile,
          apiMethod: "POST",
          body: {
            "name": name!,
            "dob": dob!,
            //"gender": gender!,
            "token": token!,
            "user_id":  userId.value,
            "mobile_number": mobileNo!,
            "country_code": countryCode!,
            "country": country!,
            "username": username.toString().toLowerCase() == myProfileData['user_data']["username"].toString().toLowerCase()? "" :username!,
            "email": email!,
            "city": city!,
            "account_type": privacy!,
          },
          imageKey: "image",
          imagePath: xFile?.path
      );
      log(' response----- ${response["body"]} ');
      log(' error----- ${response['error']} ');
      if (response['error'] == null) {

        if(response['body']['status'].toString()=="1"){
          showSnackbar(message: response['body']['msg'].toString());
          prefs.setString('user_city', city);
          getProfileApi();
          Get.back();
          hideLoadingDialog();
        }
        else if(response['body']['status'].toString()=="0") {
          showSnackbar(message: response['body']['msg'].toString());
          hideLoadingDialog();
        }
      } else if (response['error'] != null) {}

    } catch (e, s) {
      debugPrint("updateProfile Error -- $e  $s");
    }
  }


  // RxBool isApiCallProcessing = true.obs;
  // RxMap searchResponse = {}.obs;
  // RxList searchResult = [].obs;
  // RxList myVideosDataList = [].obs;
  // RxInt lastPage = 0.obs;
  // RxInt currentPage = 1.obs;
  // RxInt nextPage = 1.obs;
  // final ScrollController scrollController = ScrollController();
  //
  // Future myVideosApi({
  //   int pageNumber = 1,
  //   int count = 10,
  //   bool isShowMoreCall = false,
  // }) async {
  //   try {
  //     isApiCallProcessing.value = true;
  //     var response = await HttpHandler.postHttpMethod(
  //         url: APIString.my_videos, data: {
  //       "user_id": userId.value,
  //       "count": count,
  //       "page_no": pageNumber,
  //     });
  //     log("myVideosApi  :: response  :: userId.value  :: ${userId.value}");
  //     log("myVideosApi  :: response  :: count  :: ${count}");
  //     log("myVideosApi  :: response  :: pageNumber  :: ${pageNumber}");
  //     searchResponse.value = response;
  //     isApiCallProcessing.value = false;
  //     log("myVideosApi  :: response  :: ${response["body"]}");
  //
  //     if (response['error'] == null) {
  //       if (response['body']['status'].toString() == "1") {
  //         var respData = response['body'];
  //         print("myVideosApi respData[last_page]   ${response['body']["last_page"]}");
  //         lastPage.value = response['body']["last_page"];
  //         print("myVideosApi respData[current_page]   ${response['body']["current_page"]}");
  //         currentPage.value = response['body']["current_page"];
  //         nextPage.value = currentPage.value + 1;
  //         print("myVideosApi isShowMoreCall   $isShowMoreCall");
  //
  //         if (isShowMoreCall == true) {
  //           respData["data"].forEach((e) {
  //             myVideosDataList.add(e);
  //           });
  //           print("myVideosApi  add in existing ${myVideosDataList.value}");
  //         }
  //         else {
  //           myVideosDataList.value = respData["data"];
  //           print("myVideosApi  replace ${myVideosDataList.value}");
  //         }
  //
  //       } else if (response['body']['status'].toString() == "0") {
  //         myVideosDataList.value = [];
  //         showSnackbar(message: response['body']['msg']);
  //       }
  //     } else if (response['error'] != null) {
  //
  //       myVideosDataList.value = [];
  //     }
  //   } catch (e, s) {
  //     hideLoadingDialog();
  //     debugPrint("myVideosApi Error -- $e  $s");
  //   }
  // }

  Future deleteVideoApi(
      {String? videoId}) async {
    try {
      showLoadingDialog();
      var response = await HttpHandler.postHttpMethod(
          url: APIShortsString.delete_video,
          data: {
            "video_id": videoId,
          });

      log("deleteVideoApi  :: response  :: ${response["body"]}");

      hideLoadingDialog();
      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          showSnackbar(message: response['body']['msg']);
          Get.back();
        } else if (response['body']['status'].toString() == "0") {
          showSnackbar(message: response['body']['msg']);
        }
      } else if (response['error'] != null) {}
    } catch (e, s) {
      hideLoadingDialog();
      debugPrint("deleteLookBookApi Error -- $e  $s");
    }
  }

}
