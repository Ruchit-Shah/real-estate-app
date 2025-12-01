import 'dart:async';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/Routes/app_pages.dart';
import 'package:real_estate_app/common_widgets/custom_textformfield.dart';
import 'package:real_estate_app/common_widgets/height.dart';
import 'packa'
    'ge:real_estate_app/global/app_color.dart';
import 'package:real_estate_app/view/auth/auth_controllers/registration_controller.dart';

import '../../../global/theme/app_text_style.dart';
import '../../../utils/notification_services.dart';
import '../../dashboard/bottom_navbar_screens/profile_screen/about_us.dart';
import '../../dashboard/view/BottomNavbar.dart';
import '../../property_screens/properties_controllers/post_property_controller.dart';
import '../../welcome_screen/view/welcome_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final RegistrationController controller = Get.put(RegistrationController());
  final PostPropertyController propertyController = Get.put(PostPropertyController());
  bool isLocationAllowed = false, isLocationPermissionChecked = false;

  String city = "";
  bool _agreeToTerms = false;
  late String _currentCountryCode = "IN-91";
  Timer? _resendOtpTimer;
  bool passwordVisible = false;
  int _resendOtpSeconds = 0;
  bool _canResendOtp = true;
  NotificationServices notificationServices = NotificationServices();

  List<FocusNode> focusNodes =
  List<FocusNode>.generate(4, (index) => FocusNode());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLoc();
  }
getLoc() async {
    await getCurrentLocation();
}
  void _startResendOtpTimer(StateSetter setState) {
    setState(() {
      _resendOtpSeconds = 20;
      _canResendOtp = false;
    });

    _resendOtpTimer?.cancel();
    _resendOtpTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_resendOtpSeconds > 0) {
        setState(() {
          _resendOtpSeconds--;
        });
      } else {
        timer.cancel();
        setState(() {
          _canResendOtp = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _resendOtpTimer?.cancel();
    super.dispose();
  }
  void _loginWithGoogle() {
    Fluttertoast.showToast(msg: 'Google sign-in not implemented yet');
  }

  void _loginWithFacebook() {
    Fluttertoast.showToast(msg: 'Facebook sign-in not implemented yet');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          children: [
            Opacity(
              opacity: 0.8,
              child: Image.asset(
                'assets/register_background.png',
                width: screenWidth,
                height: screenWidth,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
                top: 80,
                left: 20,
                child: Column(
                  children: [
                    SizedBox(
                      width:screenWidth * 0.7,
                      child: const Text(
                        'Discover Your Dream Home!',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 21,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                )),
            Padding(
              padding:  EdgeInsets.only(top: screenHeight * 0.25),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(15),
                        topLeft: Radius.circular(15)),
                    //color: Colors.white,
                    color: Colors.white.withOpacity(1.0)),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                           Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Registration',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              InkWell(
                                onTap: (){
                                  Get.offAll(const BottomNavbar());
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width * 0.2,
                                  decoration: BoxDecoration(
                                    color: AppColor.blueGrey.withOpacity(0.1),
                                    border: Border.all(
                                      color:
                                      AppColor.blueGrey.withOpacity(0.5),
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: Center(
                                      child: Text(
                                        'Skip',
                                        style: TextStyle(color: Colors.blueGrey),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          boxH10(),
                          CustomTextFormField(
                            controller: controller.fNameController,
                            keyboardType: TextInputType.text,
                            sufixIcon: Icon(
                              Icons.person_outline,
                              color: Colors.black.withOpacity(0.5),
                            ),
                            labelText: 'Full Name',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter full name';
                              }
                              return null;
                            },
                          ),
                          boxH10(),
                          CustomTextFormField(
                            controller: controller.uNameController,
                            keyboardType: TextInputType.text,
                            sufixIcon: Icon(
                              Icons.person,
                              color: Colors.black.withOpacity(0.5),
                            ),
                            labelText: 'Enter Username',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Username';
                              }
                              return null;
                            },
                            // onChanged: (p0){
                            //   controller.userName.value = controller.uNameController.text;
                            //   controller.checkUsernameAvailability(username:controller.userName.value,fromProfileUpdate: false);
                            // },
                          ),
                          // Align(
                          //   alignment: Alignment.topLeft,
                          //   // child:controller.userNameController.text.isEmpty?const SizedBox():
                          //   child:controller.userName.value.isEmpty?const SizedBox():
                          //   controller.isUsernameLoading.value == true ?
                          //   const SizedBox(height: 10,width: 10,child: CircularProgressIndicator(color: AppColor.blue),)
                          //       : controller.isUsernameValid.value == false
                          //       ? Text("Username is not available",style: AppTextStyle.regular.copyWith(color: AppColor.red),)
                          //       : Text("Username is available",style: AppTextStyle.regular.copyWith(color: AppColor.blue),),
                          // ),
                          boxH10(),
                          CustomTextFormField(
                            controller: controller.phoneController,
                            keyboardType: TextInputType.emailAddress,
                            sufixIcon: Icon(
                              Icons.email_outlined,
                              color: Colors.black.withOpacity(0.5),
                            ),
                            labelText: 'E-mail',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter your e-mail';
                              }
                              return null;
                            },
                          ),
                          boxH10(),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              'You Are',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColor.black.withOpacity(0.6),
                              ),
                            ),
                          ),
                         // boxH08(),
                          boxH08(),
                          SizedBox(
                            height: MediaQuery.of(context).size.width * 0.1,
                            width: MediaQuery.of(context).size.width,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: propertyController.categoryOwnerType.length,
                              itemBuilder: (context, index) {
                                bool isSelected = propertyController.selected == index;
                                return GestureDetector(
                                    onTap: () async {

                                      setState(() {
                                        propertyController.selected.value = index;
                                        propertyController.propertyOwnerType.value = propertyController.categoryOwnerType[index];

                                        print(propertyController.categoryOwnerType[index]);
                                      });
                                    },
                                    child: Container(
                                      margin:const EdgeInsets.symmetric(horizontal: 6.0),
                                      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
                                      decoration: BoxDecoration(
                                        color: isSelected ? AppColor.blue.shade50 : AppColor.white,
                                        border: Border.all(
                                          color: isSelected ? AppColor.blue : AppColor.grey[400]!,
                                        ),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Center(
                                            child: Text(
                                              propertyController.categoryOwnerType[index],
                                              style: TextStyle(
                                                color: isSelected ? AppColor.blue.withOpacity(0.9) : AppColor.black.withOpacity(0.6),
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                );
                              },
                            ),
                          ),
                          boxH15(),

                          CustomTextFormField(
                            controller: controller.fNameController,
                            obscureText: !passwordVisible,
                            sufixIcon: IconButton(
                              icon: Icon(
                                passwordVisible ? Icons.visibility : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  passwordVisible = !passwordVisible;
                                });
                              },
                              color: Colors.black.withOpacity(0.5),
                            ),
                            labelText: 'Password',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                          ),
                          boxH10(),
                          CustomTextFormField(
                            controller: controller.phoneController,
                            obscureText: !passwordVisible,
                            sufixIcon: IconButton(
                              icon: Icon(
                                passwordVisible ? Icons.visibility : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  passwordVisible = !passwordVisible;
                                });
                              },
                              color: Colors.black.withOpacity(0.5),
                            ),
                            labelText: 'Confirm Password',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please confirm your password';
                              }
                              if (value != controller.phoneController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),

                          boxH10(),

                          Row(
                            children: [
                              // Expanded(
                              //   flex: 3,
                              //   child: Container(
                              //     margin: EdgeInsets.only(right: 5),
                              //     decoration: BoxDecoration(
                              //       borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              //       border: Border.all(
                              //         width: 1,
                              //         color: AppColor.primaryColor,
                              //       ),
                              //     ),
                              //     height: 50,
                              //     alignment: Alignment.centerLeft,
                              //     child: CountryCodePicker(
                              //       onChanged: _onCountryChange,
                              //       initialSelection: 'IN',
                              //       favorite: const ['+91', 'IN'],
                              //     ),
                              //   ),
                              // ),
                              // boxW05(),
                              Expanded(
                                flex: 7,
                                child: CustomTextFormField(
                                  controller: controller.phoneController,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(10),
                                  ],
                                  keyboardType: TextInputType.phone,
                                  sufixIcon: Icon(
                                    Icons.phone_outlined,
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                  labelText: 'Mobile No',
                                  validator: (value) {
                                    if (value == null || value.isEmpty || value.length != 10) {
                                      return 'Please enter a valid mobile number';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    setState(() {
                                      controller.isOtpSent.value = value.length == 10;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),

                          boxH10(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Checkbox(
                                value: _agreeToTerms,
                                activeColor: Colors.blue,
                                onChanged: (value) {
                                  setState(() {
                                    _agreeToTerms = value!;
                                  });
                                },
                              ),
                              Expanded(
                                child: Text.rich(
                                  TextSpan(
                                    children: [
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
                                          color: Colors.blue,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Get.to(
                                                AboutUs(isFrom: 'TandC',
                                                ));
                                            print("T&C tapped");
                                          },
                                      ),
                                      const TextSpan(
                                        text: ', ',
                                        style: TextStyle(fontSize: 10),
                                      ),

                                      const TextSpan(
                                        text: ' & ',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      TextSpan(
                                        text: 'Privacy Policy',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.blue,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Get.to(
                                                AboutUs(isFrom: 'policy',
                                                ));
                                            print("T&C tapped");
                                          },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),

                          Obx(() => Column(
                            children: [
                              if (controller.isverified.value)
                                const Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    "Verified",
                                    style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              const SizedBox(height: 15),
                              Visibility(
                                visible: !controller.isOtpSent.value,
                                child: InkWell(
                                  onTap: () {

                                    if (_formKey.currentState?.validate() ?? false ) {
                                      if(_agreeToTerms){
                                        // Get.find<RegistrationController>()
                                        //     .registerUser(type:  propertyController.propertyOwnerType.value);
                                      }else{
                                        Fluttertoast.showToast(msg: "Please agree our conditions");
                                      }

                                    }
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: AppColor.blueGrey.withOpacity(0.1),
                                      border: Border.all(
                                        color: AppColor.blueGrey.withOpacity(0.5),
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'Register',
                                        style: TextStyle(
                                          color: AppColor.primaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: controller.isOtpSent.value,
                                child: InkWell(
                                  onTap: () {
                                    if (_formKey.currentState!.validate()) {
                                      controller.generateOtp(countryCode: _currentCountryCode).then((_) {
                                        // Check if OTP was successfully sent
                                        if (controller.isotp1.value) {
                                          _showOtpBottomSheet(context);
                                        }
                                      });
                                    }
                                  },

                                  child: Container(
                                    width: double.infinity,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: AppColor.blueGrey.withOpacity(0.1),
                                      border: Border.all(
                                        color: AppColor.blueGrey.withOpacity(0.5),
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'Verify Mobile Number',
                                        style: TextStyle(
                                          color: Colors.blueGrey,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )),

                          boxH10(),
                          const Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: Colors.grey,
                                  thickness: 1,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  '* * *',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: Colors.grey,
                                  thickness: 1,
                                ),
                              ),
                            ],
                          ),

                          boxH05(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Already have an account? ',
                                style: TextStyle(fontSize: 14, color: Colors.black),
                              ),
                              InkWell(
                                onTap: () {
                                  Get.toNamed(Routes.login);
                                },
                                child: const Text(
                                  'Login',
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: AppColor.primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ]),
    );
  }

  void _showOtpBottomSheet(BuildContext context) {
    List<TextEditingController> otpFieldsControllers =
    List.generate(4, (index) => TextEditingController());

    List<FocusNode> focusNodes = List.generate(4, (index) => FocusNode());

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Column(
                        children: [
                          Text(
                            'OTP sent to your mobile number',
                            style: TextStyle(
                              color: AppColor.primaryColor,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const Divider(thickness: 1.5),
                      boxH10(),
                      Text(
                        'Enter OTP',
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.7),
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      boxH10(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(4, (index) {
                          return Container(
                            width: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
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
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              onChanged: (value) {
                                if (value.length == 1 && index < otpFieldsControllers.length - 1) {
                                  FocusScope.of(context).requestFocus(focusNodes[index + 1]);
                                }

                                if (value.isEmpty && index > 0) {
                                  FocusScope.of(context).requestFocus(focusNodes[index - 1]);
                                }

                                String otp = otpFieldsControllers
                                    .map((controller) => controller.text)
                                    .join();

                                controller.otpController.text = otp;

                                if (index == otpFieldsControllers.length - 1 && value.length == 1) {
                                  FocusScope.of(context).unfocus();
                                }
                              },

                            ),
                          );
                        }),
                      ),
                      boxH20(),
                      InkWell(
                        onTap: () async {
                          if(controller.otpController.text.isNotEmpty &&  controller.otpController.text.length==4){
                            await controller.verifyOtpApi();
                          }else{
                            Fluttertoast.showToast(
                              msg: 'Enter Otp',
                            );
                          }

                        },
                        child: Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width * 0.8,
                          decoration: BoxDecoration(
                            color: AppColor.blueGrey.withOpacity(0.1),
                            border: Border.all(
                              color: AppColor.blueGrey.withOpacity(0.5),
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: Text(
                              'VERIFY OTP',
                              style: TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      boxH10(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: _canResendOtp
                                ? () {
                              Get.find<RegistrationController>()
                                  .generateOtp(countryCode: _currentCountryCode);
                              _startResendOtpTimer(setState);
                            }
                                : null,
                            child: Text(
                              _canResendOtp
                                  ? 'OTP not received Resend OTP'
                                  : 'Resend OTP in $_resendOtpSeconds seconds',
                              style: TextStyle(
                                color: _canResendOtp ? Colors.blue : Colors.grey,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(thickness: 1.5),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
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
      city = place.locality!;
      print('city==>');
      print(city);
      isLocationAllowed = true;
      isLocationPermissionChecked = true;
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
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
