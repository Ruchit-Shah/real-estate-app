import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:real_estate_app/global/services/api_exception.dart';
import 'package:real_estate_app/global/services/api_response.dart';
import 'package:real_estate_app/global/services/end_point.dart';
import 'package:real_estate_app/global/services/shared_preference_utils.dart';



class ApiService {
  dynamic response;

  static Map<String, String> _getHeaders() {
    final String token = PreferenceManagerUtils.getToken();
    // debugPrint("Token -- '$token'");
    return {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      if (token.isNotEmpty) 'x-access-token': token,
    };
  }

  Future<dynamic> getResponse(
      {required APIType? apiType,
      required String? url,
      Map<String, dynamic>? body,
      bool fileUpload = false}) async {
    String uri = EndPoint.baseUrl() + url!;
    log("URL------ $uri");
    log("REQUEST FOR API ${jsonEncode(body)}");

    try {
      ///=======GET METHOD============
      if (apiType == APIType.aGet) {
        var result = await http.get(Uri.parse(uri));
        response = returnResponse(
          result.statusCode,
          result.body,
        );
        // log("Result==================${result.body}");
      }

      ///=========POST METHOD=============
      else if (apiType == APIType.aPost) {
        var result = await http.post(Uri.parse(uri),
            body: jsonEncode(body), headers: _getHeaders());
        response = returnResponse(
          result.statusCode,
          result.body,
        );
        // log("Result==================${result.body}");
      }

      ///=======PUT METHOD============
      else if (apiType == APIType.aPut) {
        var result = await http.put(Uri.parse(uri),
            body: jsonEncode(body), headers: _getHeaders());

        response = returnResponse(
          result.statusCode,
          result.body,
        );
        // log("Result==================${result.body}");
      }

      ///========DELETE METHOD=========
      else if (apiType == APIType.aDelete) {
        var result = await http.delete(Uri.parse(uri));
        response = returnResponse(
          result.statusCode,
          result.body,
        );
        // log("Result==================${result.body}");
      }
      return response;
    } catch (e) {
      log('Error=>.. $e');
    }
  }

  returnResponse(int status, String result) {
    log("API RESPONSE STATUS ************* $status **************");
    switch (status) {
      case 200:
        return jsonDecode(result);
      case 256:
        return jsonDecode(result);
      case 400:
        throw BadRequestException('Bad Request');
      case 401:
        throw UnauthorisedException('Unauthorised user');
      case 404:
        throw ServerException('Server Error');
      case 500:
      default:
        throw FetchDataException('Internal Server Error');
    }
  }
}
