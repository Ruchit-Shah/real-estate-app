import 'package:flutter/services.dart';

class TextFieldValidation {
  TextFieldValidation._();

  static String? validation({
    String? value,
    String? message,
    bool isEmailValidator = false,
    bool isPhone = false,
    bool isPasswordValidator = false,
  }) {
    if (value!.isEmpty) {
      return "$message is required!";
    }
    if (isEmailValidator == true) {
      if (value.isEmpty) {
        return "$message is required!";
      } else if (!RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(value)) {
        return 'Enter Valid $message';
      }
    } else if (isPhone == true) {
      if (value.isEmpty) {
        return "$message is required!";
      } else if (value.length < 10) {
        return 'Enter Valid $message';
      }
    } else if (isPasswordValidator == true) {
      /*  RegExp regex = RegExp(
          r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');*/
      if (value.isEmpty) {
        return "$message is required!";
      } else {
        if (value.length < 8) {
          return 'Password must be at least 8 characters.';
        } else {
          return null;
        }
      }
    }
    return null;
  }
}


class DigitDotInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    // Allow only digits and dot
    String formattedValue = newValue.text.replaceAll(RegExp(r'[^0-9.]'), '');

    return TextEditingValue(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: formattedValue.length),
    );
  }
}