// API EndPoint


import 'api_response.dart';

abstract class EndPoint {
  static dynamic environment = Environment.staging;

  static String baseUrl() {
    if (environment == Environment.staging) {
    //  return 'https://gruzen.in/HouzzaShorts/api/';
      return 'https://crm.houzza.in/HouzzaShorts/api/';
      // return 'https://baseurl/staging';
    } else {
      return 'https://crm.houzza.in/HouzzaShorts/api/';
    }
  }

}