import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/Routes/app_pages.dart';
import 'package:real_estate_app/common_widgets/custom_textformfield.dart';
import 'package:real_estate_app/common_widgets/height.dart';
import 'package:real_estate_app/global/app_color.dart';
import 'package:real_estate_app/view/auth/login_screen/login_screen.dart';

class ForgotScreen extends StatefulWidget {
  const ForgotScreen({Key? key}) : super(key: key);

  @override
  State<ForgotScreen> createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
   final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //_emailController = TextEditingController();
  }

  @override
  void dispose() {
   // _emailController.dispose();
    super.dispose();
  }

  void _sendResetLink() {
    String email = _emailController.text.trim();
    // Implement logic to send password reset link
    print('Reset link sent to: $email');
    // You can show a snackbar or toast to inform the user
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Get.toNamed(Routes.login);
          },
          icon: Icon(Icons.arrow_back, color: Colors.black.withOpacity(0.7),),
        ),
        backgroundColor: AppColor.grey.withOpacity(0.1),
       // backgroundColor: Colors.blue.withOpacity(0.8),

        scrolledUnderElevation: 0,
        elevation: 0,
        title:  Text(
          'Forgot Password',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.bold,
            color: Colors.black.withOpacity(0.7),
          ),
          textAlign: TextAlign.center,
        ),
       // automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: AppColor.blue.withOpacity(0.1),
              child: CircleAvatar(
                radius: 40,
                backgroundColor: AppColor.blue.withOpacity(0.2),
                child: Icon(Icons.lock,color: Colors.blue.withOpacity(0.8),size: 40,)
              ),
            ),
            boxH20(),
            Text(
              'Enter your email to reset your password',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black.withOpacity(0.7),
              ),
            ),
            boxH20(),
            CustomTextFormField(
              controller: _emailController,
             labelText: 'Email Id',hintText: 'Enter your email',
            ),
            boxH50(),
            Center(
              child: InkWell(
                onTap: () {

                },
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text(
                      'Forgot Password',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            boxH20(),
            InkWell(
              onTap: () {
                Get.toNamed(Routes.login);
              },
              child: Text(
                'Login',
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
