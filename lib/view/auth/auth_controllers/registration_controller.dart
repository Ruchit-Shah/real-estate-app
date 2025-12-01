import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/Routes/app_pages.dart';
import 'package:real_estate_app/common_widgets/loading_dart.dart';
import 'package:real_estate_app/global/api_string.dart';
import 'package:real_estate_app/global/services/api_shorts_string.dart';
import 'package:real_estate_app/utils/shared_preferences/shared_preferances.dart';
import 'package:real_estate_app/view/dashboard/view/BottomNavbar.dart';
import 'package:real_estate_app/view/subscription%20model/controller/SubscriptionController.dart';
import '../../../global/services/shared_preference_services.dart';
import '../../../global/widgets/loading_dialog.dart';
import '../../../utils/String_constant.dart';
import '../../../utils/local_storage.dart';
import '../../../utils/network_http.dart';
import '../../../utils/notification_services.dart';
import '../../shorts/controller/my_profile_controller.dart';
import '../../splash_screen/splash_screen.dart';
import 'package:http/http.dart' as htttp;
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegistrationController extends GetxController {
  bool isLocationAllowed = false, isLocationPermissionChecked = false;
  final controller = Get.find<SubscriptionController>();

  String city = "";
  bool agreeToTerms = false;
  late String _currentCountryCode = "IN-91";

  var currentScreen = "login".obs;
  void showLoginOtp() => currentScreen.value = 'loginOtp';
  void showLogin() => currentScreen.value = 'login';
  void showSignup() => currentScreen.value = 'signup';
  void showSignupOtp() => currentScreen.value = 'signUpOtp';

  RxString countryCode = "IN".obs;
  RxString phoneCode = '+91'.obs;  // Initialize with default value
  RxString countryName = 'India'.obs;


  Timer? resendOtpTimer;
  bool passwordVisible = false;
  int resendOtpSeconds = 0;
  bool canResendOtp = true;
  NotificationServices notificationServices = NotificationServices();

  List<FocusNode> focusNodes =
      List<FocusNode>.generate(4, (index) => FocusNode());

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController fNameController = TextEditingController();
  final TextEditingController uNameController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final RxInt selected = (-1).obs;
  var propertyOwnerType = ''.obs;
  List<String> categoryOwnerType = ["Buyer/Owner", "Agent", "Builder"];
  var loadingMessage = ''.obs;
  var wrongOtpError = false.obs;
  var isOtpSent = false.obs;
  var otpError = false.obs;
  var otpErrorMsg = ''.obs;
  var isotp1 = false.obs;
  var isotp = false.obs;
  var isverified = false.obs;
  var isLoading = false.obs;

 // late String currentCountryCode = "IN-91";

  RxBool isUsernameLoading = false.obs;
  RxBool isUsernameValid = false.obs;
  RxBool isSignUp = false.obs;
  RxBool isOtp = false.obs;
  RxString userName = ''.obs;
  void updateCountryCode(String code, String name) {
    phoneCode.value = code;
    countryName.value = name;
  }

  ///verify otp code dont delete it

  Future<void> verifyOtpSignApi() async {
    try {
      // Dismiss keyboard
      Get.focusScope?.unfocus();
      wrongOtpError.value = false;
      // Prepare request data
      final requestData = {
        'full_name': fNameController.text.trim(),
        'mobile_number': phoneController.text.trim(),
        'country_code': phoneCode.value.toString(),
        'otp': otpController.text.trim(),
      };

      debugPrint('OTP Verification Request: ${json.encode(requestData)}');

      // Make API call
      final response = await http.post(
        Uri.parse('${APIString.baseUrl}${APIString.verifyOtp}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestData),
      ).timeout(const Duration(seconds: 30));

      // Parse response
      final responseBody = json.decode(response.body);
      debugPrint('OTP Verification Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        if (responseBody['status'] == 1) {
          // Success case
          isverified.value = true;
          wrongOtpError.value = false;
          isOtpSent.value = false;
          update();
          Get.rawSnackbar(
            message: responseBody['message'] ?? 'OTP verified successfully',
            duration: const Duration(seconds: 2),
          );
          registerUser();
        } else {
          // OTP verification failed
          isverified.value = false;
          wrongOtpError.value = true;
          update();
          Get.rawSnackbar(
            message: responseBody['message'] ?? 'Invalid OTP',
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          );
        }
      }
      else{
        wrongOtpError.value = true;
      }
    } on http.ClientException catch (e) {
      debugPrint('Network error: $e');
      Get.rawSnackbar(
        message: 'Network error. Please check your connection',
        backgroundColor: Colors.red,
      );
    } on TimeoutException {
      Get.rawSnackbar(
        message: 'Request timed out. Please try again',
        backgroundColor: Colors.red,
      );
    } on FormatException {
      Get.rawSnackbar(
        message: 'Invalid server response',
        backgroundColor: Colors.red,
      );
    } catch (e, s) {
      debugPrint('Unexpected error: $e\n$s');
      Get.rawSnackbar(
        message: 'An unexpected error occurred',
        backgroundColor: Colors.red,
      );
    }
    finally{
      print('wrong otp : $wrongOtpError');
    }
  }

  Color get wrongOtpColor {
    if (otpController.text.length != 4) return Colors.grey;
    return wrongOtpError.value ? Colors.red : Colors.grey;
  }

  void loginWithGoogle() {
    Fluttertoast.showToast(msg: 'Google sign-in not implemented yet');
  }

  void loginWithFacebook() {
    Fluttertoast.showToast(msg: 'Facebook sign-in not implemented yet');
  }

  /// registration api function

  Future<void> generateOtp({String? countryCode}) async {
    // Reset states
    otpError.value = false;
    isotp.value = false;
    isotp1.value = false;
    isOtpSent.value = false;

    final String mobileNumber = phoneController.text.trim();

    if (mobileNumber.isEmpty) {
      otpError.value = true;
      otpErrorMsg.value = "Please enter mobile number";
      return;
    }

    try {
      Get.focusScope?.unfocus(); // Dismiss keyboard

      final response = await http.post(
        Uri.parse(APIString.baseUrl+APIString.generateOtp),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'mobile_number': mobileNumber,
          'country_code': countryCode ?? '+91',
        }),
      ).timeout(const Duration(seconds: 30));

      print(APIString.baseUrl+APIString.generateOtp);
      print(mobileNumber);
      print(countryCode);
      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        if (responseData['status'] == 1) {
          // Success case
          isOtpSent.value = true;
          isotp.value = true;
          isotp1.value = true;
          showSignupOtp();
          // Log for debugging
          debugPrint('OTP sent successfully: ${responseData['otp']}');

          // Show success message
          Fluttertoast.showToast(
            msg: responseData['message'] ?? 'OTP sent successfully',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        } else {
          // API returned error
          _handleApiError(responseData['message'] ?? 'Failed to send OTP');
        }
      } else {
        // HTTP error status code
        _handleHttpError(response.statusCode, responseData);
      }
    } on http.ClientException catch (e) {
      _handleNetworkError('Network error: ${e.message}');
    } on TimeoutException catch (_) {
      _handleNetworkError('Request timed out. Please try again.');
    } on FormatException catch (_) {
      _handleNetworkError('Invalid server response.');
    }
  }

  void _handleApiError(String message) {
    otpError.value = true;
    otpErrorMsg.value = message;
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _handleHttpError(int statusCode, dynamic responseData) {
    String errorMessage = 'Failed to send OTP';

    if (statusCode == 400) {
      errorMessage = responseData['message'] ?? 'Invalid request';
    } else if (statusCode == 401) {
      errorMessage = 'Authentication failed';
    } else if (statusCode == 404) {
      errorMessage = 'Endpoint not found';
    } else if (statusCode >= 500) {
      errorMessage = 'Server error, please try again later';
    }

    _handleApiError(errorMessage);
  }

  void _handleNetworkError(String message) {
    otpError.value = true;
    otpErrorMsg.value = message;
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
    );
  }

  verifyOtpApi() async {
    String otp = otpController.text;
    String mobileNumber = phoneController.text;
    log("step --------  +++ 1 ");
    try {
      log("step --------  +++ 2 ");

      Get.focusScope!.unfocus();

      var response =
          await HttpHandler.postHttpMethod(url: APIString.verifyOtp, data: {
        'mobile_number': mobileNumber,
        'country_code':  phoneCode.value,
        'otp': otp,
      });

      if (response['body']['status'].toString() == "1") {
        isOtpSent.value = false;
        isotp.value = true;
        log((response['body']['message'].toString()));
        isverified.value = true;

        Fluttertoast.showToast(
          msg: 'Verify OTP is Successfully',
        );
        isOtpSent.value = false;
        isotp.value = true;
        isOtp.value = false;
        Get.offAllNamed(Routes.bottomNavbar);
        // Get.back();
      } else if (response['body']['status'].toString() == "0") {
        log((response['body']['message'].toString()));
        isverified.value = false;
        Fluttertoast.showToast(
          msg: 'Verify OTP is Successfully',
          toastLength: Toast.LENGTH_SHORT,
        );
        // isOtpSent.value = false;
        //// isotp.value =true;
       // Get.back();
      } else {
        var responseBody = json.decode(response['body']);
        Fluttertoast.showToast(msg: responseBody['message']);
        log("step --------  +++  Response message: ${response['body']['message'].toString()}");
      }
    } catch (e, s) {
      Fluttertoast.showToast(
        msg: 'otp failed',
        toastLength: Toast.LENGTH_SHORT,
      );
      debugPrint("get OTP Error -- $e  $s");
    }
  }

  registerUser() async {
    showHomLoading(Get.context!, 'Processing...');
    isLoading.value = true;
    log("OTP SENT Register");

    try {
      var response = await HttpHandler.postHttpMethod(
        url: APIString.registerUser,
        data: {
          'full_name': fNameController.text,
          'token': await notificationServices.getDeviceToken(),
          'user_type': propertyOwnerType.value == "Buyer/Owner" ? 'Owner' : propertyOwnerType.value ?? '',
          'country_code': phoneCode.value,
          'mobile_number': phoneController.text,
          'account_type': '',
        },
      );

      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          log("response[data]  ---- ${response['data'] ?? 'No user data'}");

          // Extracting data safely
          String userId = response['body']['data']['_id'];
          String userType = response['body']['data']['user_type'] ?? '';
          String contact = response['body']['data']['mobile_number'].toString();
          String name = response['body']['data']['full_name'] ?? "";
          String email = response['body']['data']['email'] ?? "";
          String city = response['body']['data']['city'] ?? "";

          print('Full Name: $name');
          print('Mobile Number: $contact');
          print('userType: $userType');

          // Save to local storage safely
          await SPManager.instance.setUserId(USER_ID, userId);
          await SPManager.instance.setContact(CONTACT, contact);
          await SPManager.instance.setName(NAME, name);
          await SPManager.instance.setEmail(EMAIL, email);
          await SPManager.instance.setCity(CITY, city);
          await SPManager.instance.setUserType(USER_TYPE, userType);
          await SPManager.instance.setUserLogin(LOGINKEY.toString(), true);

          // Update GetX Controller
          Get.find<MyProfileController>().userId.value = userId;

          // Debugging User ID
          String? retrievedUserId = await SPManager.instance.getUserId(USER_ID);
          print('Retrieved User ID: $retrievedUserId');
          print('userType: $userType');

          isLogin = true;
          Fluttertoast.showToast(msg: 'Registration successful');
          Get.offAll(const BottomNavbar());
        }
      } else {
        print('Response: $response');
        var responseBody = json.decode(response['body']);
        Fluttertoast.showToast(msg: responseBody['message']);
      }
    } catch (e) {
      debugPrint(" Error: $e");
      Fluttertoast.showToast(msg: 'Registration failed');
    } finally {
      if (Navigator.canPop(Get.context!)) {
        Navigator.of(Get.context!).pop();
      }
      isLoading.value = false;
    }
  }

  checkUsernameAvailability(
      {bool? fromProfileUpdate = false, String? username}) async {
    try {
      fromProfileUpdate == true
          ? Get.find<MyProfileController>().isUsernameLoading.value = true
          : isUsernameLoading.value = true;

      fromProfileUpdate == true
          ? Get.find<MyProfileController>().isUsernameValid.value = false
          : isUsernameValid.value = false;

      // showLoadingDialog();

      var response = await HttpHandler.postHttpMethod(
          url: APIShortsString.usernameAvailability,
          data: {
            "username": username,
          });

      log("usernameAvailability  :: response  :: ${response["body"]}");

      fromProfileUpdate == true
          ? Get.find<MyProfileController>().isUsernameLoading.value = false
          : isUsernameLoading.value = false;
      // hideLoadingDialog();
      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          fromProfileUpdate == true
              ? Get.find<MyProfileController>().isUsernameValid.value = true
              : isUsernameValid.value = true;
          isUsernameLoading.value = false;
          Get.find<MyProfileController>().isUsernameLoading.value = false;
        } else if (response['body']['status'].toString() == "0") {
          fromProfileUpdate == true
              ? Get.find<MyProfileController>().isUsernameValid.value = false
              : isUsernameValid.value = false;
        }
      } else if (response['error'] != null) {}
    } catch (e, s) {
      hideLoadingDialog();
      debugPrint("usernameAvailability Error -- $e  $s");
    }
  }

  Future<void> loginUser(String? isFrom) async {
    showHomLoading(Get.context!, 'Processing...');
    isLoading.value = true;
    wrongOtpError.value = false;
print('is from $isFrom');
    try {
      final deviceToken = await notificationServices.getDeviceToken();
      final requestData = {
        'mobile_number': phoneController.text.trim(),
      //  'country_code': phoneCode.value.toString(),
        'country_code': phoneCode.value.toString(),
        'otp': otpController.text.trim(),
        'token': deviceToken,
      };

      debugPrint('Login Request: ${json.encode(requestData)}');

      final response = await http.post(
        Uri.parse('${APIString.baseUrl}${APIString.userLogin}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestData),
      ).timeout(const Duration(seconds: 30));

      final responseBody = json.decode(response.body);
      debugPrint('Login Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        if (responseBody['status'] == 1) {
          // Successful login
          await _handleSuccessfulLogin(responseBody);
          String? userId = await SPManager.instance.getUserId(USER_ID);
          if(isFrom == 'signUp'){
            print('inside is form $isFrom');
            await controller.add_count(isfrom: 'free_post',count: controller.freeCount.value);
            await  controller.add_count(isfrom: 'free_contact',count: controller.viewCount.value);
          }
          if(userId!.isNotEmpty && userId != '' ) {
            Get.offAll(const BottomNavbar());
          }
          showLogin();
        } else {
          print('wrong otp ');
          wrongOtpError.value = true;
        }
      }else{
        wrongOtpError.value = true;                      
      }
    } on http.ClientException catch (e) {
      _handleNetworkError('Network error: ${e.message}');
    } on TimeoutException {
      _handleNetworkError('Request timed out. Please try again');
    } on FormatException {
      _handleNetworkError('Invalid server response');
    } finally {
      if (Navigator.canPop(Get.context!)) {
        Navigator.of(Get.context!).pop();
      }
      isLoading.value = false;
      update();
    }
  }

  Future<void> _handleSuccessfulLogin(Map<String, dynamic> response) async {
    try {
      final userData = response['user'] ?? {};

      await SPManager.instance.setUserId(USER_ID, userData['_id']?.toString() ?? "");
      await SPManager.instance.setContact(CONTACT, userData['mobile_number']?.toString() ?? "");
      await SPManager.instance.setName(NAME, userData['full_name']?.toString() ?? "");
      await SPManager.instance.setEmail(EMAIL, userData['email']?.toString() ?? "");
      await SPManager.instance.setCity(CITY, userData['city']?.toString() ?? "");
      await SPManager.instance.setUserType(USER_TYPE, userData['user_type']?.toString() ?? "");
      await SPManager.instance.setUserLogin(LOGINKEY.toString(), true);

      print('userType: ${ userData['user_type']?.toString() ?? ""}');

      Get.find<MyProfileController>().userId.value = userData['_id']?.toString() ?? "";
      isLogin = true;
    } catch (e, s) {
      debugPrint('User Data Handling Error: $e\n$s');
      throw Exception('Failed to process user data');
    }
  }

  generateLoginOtp() async {
    isOtpSent.value = false;
    otpError.value = false;
    isotp.value = false;
    isotp1.value = false;

    try {
      print('generateLoginOtp api calling');
      if(phoneController.text.length != 10){
        otpError.value = true;
        otpErrorMsg.value = 'Please enter a valid phone number';
        return;
      }
      showHomLoading(Get.context!, 'Processing...');
      var response = await HttpHandler.postHttpMethod(
        url: APIString.generateOtpLogin,
        data: {
          "mobile_number": phoneController.text,
          "country_code": phoneCode.value,
        },
      );
      // First check if the HTTP status code is 1
      if (response['body']['status'].toString() == "1") {
        isOtpSent.value = true;
        otpError.value = false;
        isotp1.value = true;
        isotp.value = true;
        Fluttertoast.showToast(msg: "OTP Sent Successfully!");
        showLoginOtp();
        return true;
      } else {
        otpError.value = true;
        if(response['body']['message']=="Not found..!"){
          otpErrorMsg.value = "User Not Found";
        }else{
          otpErrorMsg.value = response['body']['message'];
        }

        Fluttertoast.showToast(
          msg: response['body']['message'] ?? "Error sending OTP",
        );
        return false;
      }
    } catch (e) {
      otpError.value = true;
      otpErrorMsg.value = "Network Error, Try again.";
      Fluttertoast.showToast(msg: "Network Error. Try again.");
      return false;
    }
    finally{
      hideLoadingDialog();
    }
  }
}
