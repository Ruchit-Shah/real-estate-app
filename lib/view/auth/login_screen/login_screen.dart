import 'dart:async';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/common_widgets/RequiredTextWidget.dart';
import 'package:real_estate_app/common_widgets/custom_textformfield.dart';
import 'package:real_estate_app/common_widgets/height.dart';
import 'package:real_estate_app/common_widgets/loading_dart.dart';
import 'package:real_estate_app/global/app_color.dart';
import 'package:real_estate_app/view/subscription%20model/controller/SubscriptionController.dart';
import '../../../utils/String_constant.dart';
import '../../../utils/shared_preferences/shared_preferances.dart';
import '../../dashboard/bottom_navbar_screens/profile_screen/about_us.dart';
import '../auth_controllers/registration_controller.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formSignUpKey = GlobalKey<FormState>();

  final RegistrationController controller = Get.put(RegistrationController());

  List<TextEditingController> otpFieldsControllers =
  List.generate(4, (index) => TextEditingController());

  List<FocusNode> focusNodes = List.generate(4, (index) => FocusNode());

  getLoc() async {
    await getCurrentLocation();
  }

  void _startResendOtpTimer(StateSetter setState) {
    setState(() {
      controller.resendOtpSeconds = 30;
      controller.canResendOtp = false;
    });

    controller.resendOtpTimer?.cancel();
    controller.resendOtpTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (controller.resendOtpSeconds > 0) {
        setState(() {
          controller.resendOtpSeconds--;
        });
      } else {
        timer.cancel();
        setState(() {
          controller.canResendOtp = true;
        });
      }
    });
  }

  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await _showLocationErrorDialog('Please enable location for a better experience.');
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        await _showLocationErrorDialog('Please enable location for a better experience.');
        return;
      } else if (permission == LocationPermission.deniedForever) {
        await _showLocationErrorDialog('Location permissions are permanently denied, we cannot request permissions.');
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];

    setState(() {
      controller.city = place.locality!;
      print('city==>');
      print(controller.city);
      controller.isLocationAllowed = true;
      controller.isLocationPermissionChecked = true;
    });
  }

  Future<void> _showLocationErrorDialog(String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    controller.resendOtpTimer?.cancel();
    for (var controller in otpFieldsControllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    clearFields();
    debug();
  }

  void clearFields() {
    controller.phoneController.clear();
    controller.fNameController.clear();
    controller.otpController.clear();
    controller.agreeToTerms = false;
    controller.selected.value = -1;
    controller.currentScreen.value = 'login';
    controller.propertyOwnerType.value = '';
  }

  void debug() async {
    await Get.find<SubscriptionController>().getSetting();
    int? free_post_count = await SPManager.instance.getFreePostCount(FREE_POST) ?? 0;
    int? free_view_count = await SPManager.instance.getFreeViewCount(FREE_VIEW) ?? 0;
    print('free post : $free_post_count');
    print('free view : $free_view_count');
  }

  Widget currentScreen() {
    if (controller.currentScreen.value == 'login') {
      return loginUI();
    } else if (controller.currentScreen.value == 'loginOtp') {
      return _buildOTPVerificationUI();
    } else if (controller.currentScreen.value == 'signup') {
      return signupUI();
    } else if (controller.currentScreen.value == 'signUpOtp') {
      return OtpUI();
    } else {
      return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        print("controller.currentScreen.value==>");
        print(controller.currentScreen.value);
        if (controller.currentScreen.value == 'signup' ||
            controller.currentScreen.value == 'loginOtp' ) {
          controller.showLogin();
          return false;
        }else{
          // controller.showSignup();
          Navigator.pop(context);
          return false;
        }


        return true;
      },
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/NewThemChangesAssets/authBgImage.png',
                fit: BoxFit.cover,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Obx(
                    () => controller.isOtp.value
                    ? Container(
                  height: 350,
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: OtpUI(),
                  ),
                )
                    : Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: currentScreen(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Login UI
  Widget loginUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
         //  onTap: () {
         //    controller.showSignup();
         //  },
          child: const Icon(Icons.arrow_back, size: 24),
        ),
        const SizedBox(height: 10),
        const Center(
          child: Text(
            "Enter Mobile Number",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 20),
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const RequiredTextWidget(label: 'Mobile Number'),
              boxH10(),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.grey.shade400, width: 2),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 7),
                      child: CountryCodePicker(
                        onChanged: (country) {
                          controller.updateCountryCode(country.dialCode!, country.name!);
                        },
                        initialSelection: 'IN',
                        favorite: const ['+91', 'IN'],
                        showCountryOnly: false,
                        showFlag: false,
                        showDropDownButton: true,
                        showOnlyCountryWhenClosed: false,
                        alignLeft: false,
                        textStyle: const TextStyle(fontSize: 16, color: Colors.black),
                        dialogTextStyle: const TextStyle(fontSize: 16),
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        flagDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),
                  boxW15(),
                  // Phone number field
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.grey.shade400, width: 2),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: TextFormField(
                          controller: controller.phoneController,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10),
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: '  Mobile Number',
                            contentPadding: EdgeInsets.only(left: 10),
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                          style: const TextStyle(fontSize: 16),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter mobile number';
                            }
                            if (value.length != 10) {
                              return 'Mobile number must be 10 digits';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        boxH08(),
        Align(
          alignment: Alignment.centerRight,
          child: controller.otpError.value
              ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              controller.otpErrorMsg.value,
              style: const TextStyle(color: Colors.red),
            ),
          )
              : null,
        ),
        boxH15(),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: commonButton(
            text: "Login",
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                await controller.generateLoginOtp();
                if (controller.isOtpSent.value) {
                  controller.otpController.clear();
                  controller.showLoginOtp();
                  _startResendOtpTimer(setState);
                } else {
                  controller.showLogin();
                }
              } else {
                Fluttertoast.showToast(msg: 'Please enter a valid mobile number');
              }
            },
          ),
        ),
        const SizedBox(height: 30),
        Center(
          child: Text.rich(
            TextSpan(
              text: "Don't have an account? ",
              style: const TextStyle(color: Colors.black54),
              children: [
                TextSpan(
                  text: "Signup",
                  style: TextStyle(
                    color: Colors.deepPurple[400],
                    fontWeight: FontWeight.bold,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => controller.showSignup(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOTPVerificationUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => controller.showLogin(),
          child: const Icon(Icons.arrow_back, size: 24),
        ),
        const SizedBox(height: 10),
        const Center(
          child: Text(
            'Verify your number',
            style: TextStyle(
              color: AppColor.black,
              fontWeight: FontWeight.w600,
              fontSize: 24,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Center(
          child: Text(
            'We have sent OTP to your mobile number ${controller.phoneController.text}',
            style: const TextStyle(
              color: AppColor.black,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          width: MediaQuery.sizeOf(context).width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (index) {
              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.02,
                  vertical: 15,
                ),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.15,
                  height: MediaQuery.of(context).size.width * 0.15,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 1.0,
                          spreadRadius: 0.2,
                        ),
                      ],
                    ),
                    child: TextFormField(
                      controller: otpFieldsControllers[index],
                      focusNode: focusNodes[index],
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      cursorColor: Colors.grey,
                      style: const TextStyle(
                        height: 1.0,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: controller.wrongOtpColor),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: controller.wrongOtpColor),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onChanged: (value) {
                        if (value.length == 1 && index < 3) {
                          FocusScope.of(context).requestFocus(focusNodes[index + 1]);
                        }
                        if (value.isEmpty && index > 0) {
                          FocusScope.of(context).requestFocus(focusNodes[index - 1]);
                        }
                        controller.otpController.text =
                            otpFieldsControllers.map((c) => c.text).join();
                        if (index == 3 && value.length == 1) {
                          FocusScope.of(context).unfocus();
                        }
                      },
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        boxH05(),
        Align(
          alignment: Alignment.center,
          child: controller.wrongOtpError.value
              ? const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "Opps! Seems Like You've Entered a Wrong OTP.",
              style: TextStyle(color: Colors.red),
            ),
          )
              : null,
        ),
        boxH10(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: controller.canResendOtp
                  ? () {
                controller.generateLoginOtp();
                _startResendOtpTimer(setState);
              }
                  : null,
              child: Text(
                controller.canResendOtp
                    ? 'Resend OTP'
                    : 'Resend OTP in ${controller.resendOtpSeconds} seconds',
                style: TextStyle(
                  color: controller.canResendOtp ? AppColor.primaryThemeColor : Colors.grey,
                  fontSize: 15,
                ),
              ),
            ),
            // Text(
            //   '${controller.resendOtpSeconds} Sec',
            //   style: const TextStyle(
            //     color: Colors.black87,
            //     fontSize: 12,
            //     decoration: TextDecoration.underline,
            //   ),
            // ),
          ],
        ),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: commonButton(
            text: "Verify OTP",
            onPressed: () async {
              if (controller.otpController.text.length == 4) {
                await controller.loginUser('');
              } else {
                Fluttertoast.showToast(msg: 'Please enter complete OTP');
              }
            },
          ),
        ),
      ],
    );
  }

  bool isFormValid() {
    return controller.fNameController.text.isNotEmpty &&
        controller.agreeToTerms &&
        controller.propertyOwnerType.value.isNotEmpty &&
        controller.phoneController.text.length == 10;
  }

  Widget signupUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            controller.showLogin();
          },
          child: const Icon(Icons.arrow_back, size: 24),
        ),
        const Center(
          child: Column(
            children: [
              Text(
                "SignUp",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                "Almost there / One Last Step",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Form(
          key: _formSignUpKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              boxH10(),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: RequiredTextWidget(label: 'I am'),
              ),
              boxH08(),
              // SizedBox(
              //   height: MediaQuery.of(context).size.width * 0.1,
              //   width: MediaQuery.of(context).size.width,
              //   child: ListView.builder(
              //     scrollDirection: Axis.horizontal,
              //     itemCount: controller.categoryOwnerType.length,
              //     itemBuilder: (context, index) {
              //       bool isSelected = controller.selected == index;
              //       return Row(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         crossAxisAlignment: CrossAxisAlignment.center,
              //         children: [
              //           Obx(() => Radio<String>(
              //             value: controller.categoryOwnerType[index],
              //             groupValue: controller.propertyOwnerType.value,
              //             activeColor: AppColor.primaryThemeColor,
              //             onChanged: (value) {
              //               controller.selected.value = index;
              //               controller.propertyOwnerType.value = controller.categoryOwnerType[index];
              //               print(controller.categoryOwnerType[index]);
              //             },
              //           )),
              //           Text(
              //             controller.categoryOwnerType[index],
              //             style: const TextStyle(
              //               fontSize: 15,
              //               color: AppColor.black,
              //               fontWeight: FontWeight.bold,
              //             ),
              //           ),
              //         ],
              //       );
              //     },
              //   ),
              // ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.1,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.categoryOwnerType.length,
                  itemBuilder: (context, index) {
                    bool isSelected = controller.selected == index;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Obx(() => Radio<String>(
                          value: controller.categoryOwnerType[index],
                          groupValue: controller.propertyOwnerType.value,
                          activeColor: AppColor.primaryThemeColor,
                          onChanged: (value) {
                            controller.selected.value = index;
                            controller.propertyOwnerType.value = controller.categoryOwnerType[index];
                            print(controller.categoryOwnerType[index]);
                          },
                          visualDensity: const VisualDensity(horizontal: -4, vertical: -4), // Reduce padding around Radio
                        )),
                        const SizedBox(width: 4), // Smaller gap between Radio and Text
                        Text(
                          controller.categoryOwnerType[index],
                          style: const TextStyle(
                            fontSize: 15,
                            color: AppColor.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              boxH20(),
              CustomTextFormField(
                labelText: 'Name',
                isRequired: true,
                size: 50,
                controller: controller.fNameController,
                maxLines: 2,
                keyboardType: TextInputType.text,
                hintText: ' Name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter full name';
                  }
                  return null;
                },
              ),
              boxH10(),
              const RequiredTextWidget(label: 'Mobile Number'),
              boxH10(),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.grey.shade400, width: 2),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 7),
                      child: CountryCodePicker(
                        onChanged: (country) {
                          controller.updateCountryCode(country.dialCode!, country.name!);
                        },
                        initialSelection: 'IN',
                        favorite: const ['+91', 'IN'],
                        showCountryOnly: false,
                        showFlag: false,
                        showDropDownButton: true,
                        showOnlyCountryWhenClosed: false,
                        alignLeft: false,
                        textStyle: const TextStyle(fontSize: 16, color: Colors.black),
                        dialogTextStyle: const TextStyle(fontSize: 16),
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        flagDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),
                  boxW15(),
                  // Phone number field
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.grey.shade400, width: 2),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: TextFormField(
                          controller: controller.phoneController,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10),
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          onChanged: (value) {
                            if (value.length == 10) {
                              Future.delayed(const Duration(seconds: 1), () {
                                FocusScope.of(context).unfocus();
                              });
                            }
                          },
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: '  Mobile Number',
                            contentPadding: EdgeInsets.only(left: 10),
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                          style: const TextStyle(fontSize: 16),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter mobile number';
                            }
                            if (value.length != 10) {
                              return 'Mobile number must be 10 digits';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              boxH08(),
              Align(
                alignment: Alignment.centerRight,
                child: controller.otpError.value
                    ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    controller.otpErrorMsg.value,
                    style: const TextStyle(color: Colors.red),
                  ),
                )
                    : null,
              ),
              boxH15(),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Checkbox(
                    value: controller.agreeToTerms,
                    activeColor: AppColor.primaryThemeColor,
                    onChanged: (value) {
                      setState(() {
                        controller.agreeToTerms = value!;
                      });
                    },
                  ),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: '* ',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.red,
                            ),
                          ),
                          const TextSpan(
                            text: 'I agree to ',
                            style: TextStyle(fontSize: 13),
                          ),
                          const TextSpan(
                            text: 'Houzza ',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: 'T&C',
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColor.primaryThemeColor,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Get.to(AboutUs(isFrom: 'TandC'));
                                print("T&C tapped");
                              },
                          ),
                          const TextSpan(
                            text: ' & ',
                            style: TextStyle(fontSize: 12),
                          ),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColor.primaryThemeColor,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Get.to(AboutUs(isFrom: 'policy'));
                                print("Privacy Policy tapped");
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              boxH10(),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: commonButton(
                  buttonColor: isFormValid() ? AppColor.primaryThemeColor : AppColor.greyColor,
                  text: "Sign Up",
                  onPressed: () {
                    if (controller.propertyOwnerType.value.isNotEmpty && (_formSignUpKey.currentState?.validate() ?? false)) {
                      if (controller.agreeToTerms) {
                        controller.generateOtp(countryCode: controller.phoneCode.value);
                        if (controller.isOtpSent.value) {
                          controller.otpController.clear();
                          controller.showSignupOtp();
                          _startResendOtpTimer(setState);
                        } else {
                          controller.showSignup();
                        }
                      } else {
                        Fluttertoast.showToast(msg: "Please agree to our conditions");
                      }
                    } else {
                      Fluttertoast.showToast(msg: "Please fill all required fields");
                    }
                  },
                ),
              ),
              boxH05(),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget OtpUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => controller.showSignup(),
          child: const Icon(Icons.arrow_back, size: 24),
        ),
        const SizedBox(height: 10),
        const Center(
          child: Text(
            'Verify your number',
            style: TextStyle(
              color: AppColor.black,
              fontWeight: FontWeight.w600,
              fontSize: 24,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Center(
          child: Text(
            'We have sent OTP to your mobile number ${controller.phoneController.text}',
            style: const TextStyle(
              color: AppColor.black,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          width: MediaQuery.sizeOf(context).width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (index) {
              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.02,
                  vertical: 15,
                ),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.15,
                  height: MediaQuery.of(context).size.width * 0.15,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 1.0,
                          spreadRadius: 0.2,
                        ),
                      ],
                    ),
                    child: TextFormField(
                      controller: otpFieldsControllers[index],
                      focusNode: focusNodes[index],
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      cursorColor: Colors.grey,
                      style: const TextStyle(
                        height: 1.0,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: controller.wrongOtpColor),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: controller.wrongOtpColor),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onChanged: (value) {
                        if (value.length == 1 && index < 3) {
                          FocusScope.of(context).requestFocus(focusNodes[index + 1]);
                        }
                        if (value.isEmpty && index > 0) {
                          FocusScope.of(context).requestFocus(focusNodes[index - 1]);
                        }
                        controller.otpController.text =
                            otpFieldsControllers.map((c) => c.text).join();
                        if (index == 3 && value.length == 1) {
                          FocusScope.of(context).unfocus();
                        }
                      },
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        boxH05(),
        Align(
          alignment: Alignment.center,
          child: controller.wrongOtpError.value
              ? const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "Opps! Seems Like You've Entered a Wrong OTP.",
              style: TextStyle(color: Colors.red),
            ),
          )
              : null,
        ),
        boxH10(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: controller.canResendOtp
                  ? () {
                controller.generateOtp(countryCode: controller.phoneCode.value);
                _startResendOtpTimer(setState);
              }
                  : null,
              child: Text(
                controller.canResendOtp
                    ? 'Resend OTP'
                    : 'Resend OTP in ${controller.resendOtpSeconds} seconds',
                style: TextStyle(
                  color: controller.canResendOtp ? AppColor.primaryThemeColor : Colors.grey,
                  fontSize: 15,
                ),
              ),
            ),
            // Text(
            //   '${controller.resendOtpSeconds} Sec',
            //   style: const TextStyle(
            //     color: Colors.black87,
            //     fontSize: 12,
            //     decoration: TextDecoration.underline,
            //   ),
            // ),
          ],
        ),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: commonButton(
            text: "Verify",
            onPressed: () async {
              if (controller.otpController.text.isNotEmpty && controller.otpController.text.length == 4) {
                print('otp value ${controller.otpController.text}');
                await controller.verifyOtpSignApi();
              } else {
                Fluttertoast.showToast(
                  msg: 'Enter OTP',
                );
              }
            },
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}