import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';


class  SPManager {
  static final SPManager _singleton = SPManager();

  static SPManager get instance => _singleton;

  late SharedPreferences sp;



  Future<bool> setUserId(String key, String value) async {
    sp = await SharedPreferences.getInstance();
    return sp.setString(key, value);
  }

  Future<String?> getUserId(String key) async {
    sp = await SharedPreferences.getInstance();
    return sp.getString(key);
  }

  Future<bool> setShowWclPG(String key, bool value) async {
    sp = await SharedPreferences.getInstance();
    return sp.setBool(key, value);
  }
  Future<bool?> getIsShowWlcPg(String key) async {
    sp = await SharedPreferences.getInstance();
    return sp.getBool(key);
  }

  Future<bool> setEmail(String key, String value) async {
    sp = await SharedPreferences.getInstance();
    return sp.setString(key, value);
  }

  Future<String?> getEmail(String key) async {
    sp = await SharedPreferences.getInstance();
    return sp.getString(key);
  }

  Future<bool> setCity(String key, String value) async {
    sp = await SharedPreferences.getInstance();
    return sp.setString(key, value);
  }

  Future<String?> getCity(String key) async {
    sp = await SharedPreferences.getInstance();
    return sp.getString(key);
  }

  Future<bool> setContact(String key, String value) async {
    sp = await SharedPreferences.getInstance();
    return sp.setString(key, value);
  }

  Future<String?> getContact(String key) async {
    sp = await SharedPreferences.getInstance();
    return sp.getString(key);
  }
  Future<bool> setName(String key, String value) async {
    sp = await SharedPreferences.getInstance();
    return sp.setString(key, value);
  }

  Future<String?> getName(String key) async {
    sp = await SharedPreferences.getInstance();
    return sp.getString(key);
  }

  Future<bool> setUserType(String key, String value) async {
    sp = await SharedPreferences.getInstance();
    return sp.setString(key, value);
  }

  Future<String?> getUserType(String key) async {
    sp = await SharedPreferences.getInstance();
    return sp.getString(key);
  }

  Future<bool> logout() async {
    sp = await SharedPreferences.getInstance();
    return sp.remove('USER_ID');
  }


  Future<bool> setUserLogin(String key, bool value) async {
    sp = await SharedPreferences.getInstance();
    return sp.setString(key, value.toString());
  }
  Future<bool?> getUserLogin(String key) async {
    sp = await SharedPreferences.getInstance();
    final stringValue = sp.getString(key);
    if (stringValue != null) {
      return true;
    }
    return null;
  }


  ///for setting count
  Future<bool> setSettingPostCount(String key, int value) async {
    sp = await SharedPreferences.getInstance();
    return sp.setInt(key, value);
  }
  Future<int?> getSetingPostCount(String key) async {
    sp = await SharedPreferences.getInstance();
    return sp.getInt(key);
  }

  Future<bool> setSettingViewCount(String key, int value) async {
    sp = await SharedPreferences.getInstance();
    return sp.setInt(key, value);
  }
  Future<int?> getSettingViewCount(String key) async {
    sp = await SharedPreferences.getInstance();
    return sp.getInt(key);
  }

  ///for free user count
  Future<bool> setFreePostCount(String key, int value) async {
    sp = await SharedPreferences.getInstance();
    return sp.setInt(key, value);
  }
  Future<int?> getFreePostCount(String key) async {
    sp = await SharedPreferences.getInstance();
    return sp.getInt(key);
  }

  Future<bool> setFreeViewCount(String key, int value) async {
    sp = await SharedPreferences.getInstance();
    return sp.setInt(key, value);
  }
  Future<int?> getFreeViewCount(String key) async {
    sp = await SharedPreferences.getInstance();
    return sp.getInt(key);
  }

  ///for paid user count
  ///post property count
  Future<bool> setPaidPostCount(String key, int value) async {
    sp = await SharedPreferences.getInstance();
    return sp.setInt(key, value);
  }
  Future<int?> getPaidPostCount(String key) async {
    sp = await SharedPreferences.getInstance();
    return sp.getInt(key);
  }
  ///view count
  Future<bool> setPaidViewCount(String key, int value) async {
    sp = await SharedPreferences.getInstance();
    return sp.setInt(key, value);
  }
  Future<int?> getPaidViewCount(String key) async {
    sp = await SharedPreferences.getInstance();
    return sp.getInt(key);
  }
  ///offer count
  Future<bool> setOfferCount(String key, int value) async {
    sp = await SharedPreferences.getInstance();
    return sp.setInt(key, value);
  }
  Future<int?> getOfferCount(String key) async {
    sp = await SharedPreferences.getInstance();
    return sp.getInt(key);
  }
  ///Project count
  Future<bool> setProjectCount(String key, int value) async {
    sp = await SharedPreferences.getInstance();
    return sp.setInt(key, value);
  }
  Future<int?> getProjectCount(String key) async {
    sp = await SharedPreferences.getInstance();
    return sp.getInt(key);
  }
  ///feature count
  Future<bool> setFeatureCount(String key, int value) async {
    sp = await SharedPreferences.getInstance();
    return sp.setInt(key, value);
  }
  Future<int?> getFeatureCount(String key) async {
    sp = await SharedPreferences.getInstance();
    return sp.getInt(key);
  }


  Future<bool> setMarkDeveloperCount(String key, int value) async {
    sp = await SharedPreferences.getInstance();
    return sp.setInt(key, value);
  }
  Future<int?> getMarkDeveloperCount(String key) async {
    sp = await SharedPreferences.getInstance();
    return sp.getInt(key);
  }

  ///for purchased plan count
  ///post property count
  Future<bool> setPlanPostCount(String key, int value) async {
    sp = await SharedPreferences.getInstance();
    return sp.setInt(key, value);
  }
  Future<int?> getPlanPostCount(String key) async {
    sp = await SharedPreferences.getInstance();
    return sp.getInt(key);
  }
  ///view count
  Future<bool> setPlanViewCount(String key, int value) async {
    sp = await SharedPreferences.getInstance();
    return sp.setInt(key, value);
  }
  Future<int?> getPlanViewCount(String key) async {
    sp = await SharedPreferences.getInstance();
    return sp.getInt(key);
  }
  ///offer count
  Future<bool> setPlanOfferCount(String key, int value) async {
    sp = await SharedPreferences.getInstance();
    return sp.setInt(key, value);
  }
  Future<int?> getPlanOfferCount(String key) async {
    sp = await SharedPreferences.getInstance();
    return sp.getInt(key);
  }
  ///Project count
  Future<bool> setPlanProjectCount(String key, int value) async {
    sp = await SharedPreferences.getInstance();
    return sp.setInt(key, value);
  }
  Future<int?> getPlanProjectCount(String key) async {
    sp = await SharedPreferences.getInstance();
    return sp.getInt(key);
  }
  ///feature count
  Future<bool> setPlanFeatureCount(String key, int value) async {
    sp = await SharedPreferences.getInstance();
    return sp.setInt(key, value);
  }
  Future<int?> getPlanMarkCount(String key) async {
    sp = await SharedPreferences.getInstance();
    return sp.getInt(key);
  }

  Future<bool> setPlanMarkeCount(String key, int value) async {
    sp = await SharedPreferences.getInstance();
    return sp.setInt(key, value);
  }
  Future<int?> getPlanFeatureCount(String key) async {
    sp = await SharedPreferences.getInstance();
    return sp.getInt(key);
  }
///for plan yes and no
  Future<bool> setPostProperties(String key, String value) async {
    sp = await SharedPreferences.getInstance();
    return sp.setString(key, value);
  }
  Future<String?> getPostProperties(String key) async {
    sp = await SharedPreferences.getInstance();
    return sp.getString(key);
  }

  Future<bool> setTopDevelopers(String key, String value) async {
    sp = await SharedPreferences.getInstance();
    return sp.setString(key, value);
  }
  Future<String?> getTopDevelopers(String key) async {
    sp = await SharedPreferences.getInstance();
    return sp.getString(key);
  }

  Future<bool> setUpcomingProjects(String key, String value) async {
    sp = await SharedPreferences.getInstance();
    return sp.setString(key, value);
  }
  Future<String?> getUpcomingProjects(String key) async {
    sp = await SharedPreferences.getInstance();
    return sp.getString(key);
  }

  Future<bool> setFeaturedProperties(String key, String value) async {
    sp = await SharedPreferences.getInstance();
    return sp.setString(key, value);
  }
  Future<String?> getFeaturedProperties(String key) async {
    sp = await SharedPreferences.getInstance();
    return sp.getString(key);
  }

  Future<bool> setMarksAS(String key, String value) async {
    sp = await SharedPreferences.getInstance();
    return sp.setString(key, value);
  }
  Future<String?> getMarkAs(String key) async {
    sp = await SharedPreferences.getInstance();
    return sp.getString(key);
  }

  Future<bool> setOffers(String key, String value) async {
    sp = await SharedPreferences.getInstance();
    return sp.setString(key, value);
  }
  Future<String?> getOffers(String key) async {
    sp = await SharedPreferences.getInstance();
    return sp.getString(key);
  }

  Future<bool> setContactDetails(String key, String value) async {
    sp = await SharedPreferences.getInstance();
    return sp.setString(key, value);
  }
  Future<String?> getContactDetails(String key) async {
    sp = await SharedPreferences.getInstance();
    return sp.getString(key);
  }


  Future<bool> setLoginScrrenView(String key, String value) async {
    sp = await SharedPreferences.getInstance();
    return sp.setString(key, value);
  }

  Future<String?> getLoginScrrenView(String key) async {
    sp = await SharedPreferences.getInstance();
    return sp.getString(key);
  }
}

Future<bool> clearLocalStorage() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  await sharedPreferences.clear();
  return true;
}