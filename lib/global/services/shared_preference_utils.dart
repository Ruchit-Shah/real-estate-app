
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceManagerUtils {
  static GetStorage getStorage = GetStorage();
  static String isLogin = "is_login";
  static String token = "token";

  ///login
  static Future setIsLogin(String value) async {
    await getStorage.write(isLogin, value);
  }

  static String getIsLogin() {
    return getStorage.read(isLogin) ?? '';
  }

  ///token
  static Future setToken(String value) async {
    await getStorage.write(token, value);
  }

  static String getToken() {
    return getStorage.read(token) ?? '';
  }

  setDataToLocalStorage({
    @required String? dataType,
    @required String? prefKey,
    bool? boolData,
    double? doubleData,
    int? integerData,
    String? stringData,
    List<String>? listOfStringData,
  }) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    switch (dataType) {
      case "BOOL":
        return sharedPreferences.setBool(
          prefKey!,
          boolData!,
        );
      case "DOUBLE":
        return sharedPreferences.setDouble(
          prefKey!,
          doubleData!,
        );
      case "INTEGER":
        return sharedPreferences.setInt(
          prefKey!,
          integerData!,
        );
      case "STRING":
        return stringData != null
            ? sharedPreferences.setString(
          prefKey!,
          stringData,
        )
            : "";
      case "LIST-OF-STRING":
        return sharedPreferences.setStringList(
          prefKey!,
          listOfStringData!,
        );
      default:
        return null;
    }
  }

  getDataFromLocalStorage({
    @required String? dataType,
    @required String? prefKey,
  }) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    switch (dataType) {
      case "BOOL":
        return sharedPreferences.getBool(
          prefKey!,
        );
      case "DOUBLE":
        return sharedPreferences.getDouble(
          prefKey!,
        );
      case "INTEGER":
        return sharedPreferences.getInt(
          prefKey!,
        );
      case "STRING":
        return sharedPreferences.getString(
          prefKey!,
        );
      case "LIST-OF-STRING":
        return sharedPreferences.getStringList(
          prefKey!,
        );
      default:
        return null;
    }
  }

}
