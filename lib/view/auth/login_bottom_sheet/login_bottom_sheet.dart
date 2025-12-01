import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/common_widgets/height.dart';
import 'package:real_estate_app/global/app_color.dart';
import 'package:real_estate_app/view/auth/auth_controllers/registration_controller.dart';


class LoginBottomSheet extends StatefulWidget {
  final VoidCallback onOtpVerified;

  LoginBottomSheet({required this.onOtpVerified});

  @override
  State<LoginBottomSheet> createState() => _LoginBottomSheetState();
}

class _LoginBottomSheetState extends State<LoginBottomSheet> {
//  final _nameController = TextEditingController();

  FocusNode? pin2FocusNode;
  FocusNode? pin3FocusNode;
  FocusNode? pin4FocusNode;

  final RegistrationController controller = Get.put(RegistrationController());

  bool isSignUpApiprocessing=false,isSendOtpApiProcessing=false,isVerifyOtpApiProcessing=false,isOtpSend=false,isOtpVerified=false;

  late String _currentCountryCode = "IN-91";
  final List<TextEditingController> _otpControllers = List.generate(4, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());

  void _onCountryChange(CountryCode countryCode) {
    _currentCountryCode =
        countryCode.code! + "-" + countryCode.toString().replaceAll("+", "");

  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, state) {
      return SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                boxH20(),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        margin: EdgeInsets.only(right: 5),
                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.all(Radius.circular(5.0)),
                          border: Border.all(
                            width: 1,
                            color: AppColor.primaryColor,
                          ),
                        ),
                        width: 100,
                        height: 60,
                        alignment: Alignment.centerLeft,
                        child: CountryCodePicker(
                          onChanged: _onCountryChange,
                          initialSelection: 'IN',
                          favorite: ['+91', 'IN'],
                          showCountryOnly: false,
                          showOnlyCountryWhenClosed: false,
                          alignLeft: false,
                        ),
                      ),
                    ),
                   boxW05(),
                    Expanded(
                      flex: 7,
                      child: TextFormField(
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(10)
                        ],
                        keyboardType: TextInputType.phone,
                        controller: controller.phoneController,
                        maxLines: 1,cursorColor: Colors.grey,
                        decoration:  InputDecoration(
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.2),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          hintText: 'Enter mobile number',
                        ),
                      ),
                    ),
                  ],
                ),
                boxH20(),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColor.blue,

                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      String mobileNumber = controller.phoneController.text;
                      print('Mobile: $mobileNumber');
                      Navigator.pop(context);
                      _showOtpBottomSheet(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.transparent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        'Send OTP',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: AppColor.white,
                        ),
                      ),
                    ),
                  ),
                ),
                boxH20(),
                Center(
                  child: Text.rich(
                    TextSpan(
                      text: 'By clicking above you agree to ',
                      style: TextStyle(color: AppColor.grey, fontSize: 12),
                      children: [
                        TextSpan(
                          text: 'Terms & Conditions',
                          style: TextStyle(
                              color: AppColor.blue, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    );
  }

  @override
  void dispose() {
    controller.phoneController.dispose();
    super.dispose();
  }

  void _showOtpBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
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
              padding: const EdgeInsets.only(top: 20.0,right: 15,left: 15,bottom: 5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Column(
                    children: [
                      Text(
                        'Verification Code',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'OTP sent to your mobile number',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  Divider(thickness: 0.8),
                  boxH20(),
                  Text(
                    'Enter OTP',
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.7),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
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
                          controller: _otpControllers[index],
                          focusNode: _focusNodes[index],
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
                            if (value.length == 1 && index < 3) {
                              FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
                            }
                            if (value.isEmpty && index > 0) {
                              FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
                            }
                          },
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 16.0),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextButton(
                      onPressed:_verifyOTP,
                      child: const Text(
                        'VERIFY OTP',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),

                  boxH20(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Resend OTP',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(thickness: 0.5),
                ],
              ),
            ),
          ),
        );
      },
    );
  }




  void _verifyOTP() async{
    String enteredOTP = _otpControllers.map((controller) => controller.text).join();
    if (enteredOTP.length == 4) {
      if (enteredOTP == '0001') {
        Fluttertoast.showToast(
          msg: 'Verify OTP is Successfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: AppColor.green,
          textColor: AppColor.white,
        );
        await Future.delayed(Duration(milliseconds: 500));
        // if (mounted) {
        //   Navigator.pop(context);
        //   _tabController.animateTo(_tabController.index + 1);
        // }
      } else {
        Fluttertoast.showToast(
          msg: 'Invalid verification code',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: AppColor.grey.shade500,
          textColor: AppColor.white,
        );
        print('Entered OTP: $enteredOTP');
      }
    } else {
      Fluttertoast.showToast(
        msg: 'Enter a verification code',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppColor.grey.shade500,
        textColor: AppColor.white,
      );
      print('Entered OTP: $enteredOTP');
    }
  }

}

