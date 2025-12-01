import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/global/services/api_shorts_string.dart';

import '../../../global/services/network_http.dart';
import '../../../global/widgets/loading_dialog.dart';
import '../../../utils/common_snackbar.dart';

class SearchScreenController extends GetxController {

  Rx<TextEditingController> searchController = TextEditingController().obs;

  RxMap searchResponse = {}.obs;
  RxList searchResult = [].obs;
  RxList searchDataList = [].obs;

  RxMap psearchResponse = {}.obs;
  RxList psearchResult = [].obs;
  RxList psearchDataList = [].obs;
  // var lastPage;
  RxInt lastPage = 0.obs;
  // var currentPage;
  RxInt currentPage = 1.obs;
  // var nextPage;
  RxInt nextPage = 1.obs;
  final ScrollController scrollController = ScrollController();
  RxBool isApiCallProcessing = true.obs;


///account search
  onSearchTextChanged(String text) async {
    searchResult.clear();
    if (text.replaceAll(" ", "").isEmpty) {
      print("text.isEmpty ");
      update();
      // setState(() {});
      return;
    }
    else if (text.length < 2) {
      print("text.length is ${text.length} which is ${text.length} < 2 ");
      update();
      // setState(() {});
      return;
    }
    print("${text.length} - ${text.length} - ${text.length} - ${text.length} - ${text.length} - ${text.length} - ${text.length} - ${text.length}");
    searchDataApi(keyword: text, pageNumber: 1);
  }

    Future searchDataApi({
    String? keyword,
    int pageNumber = 1,
    int count = 10,
    bool isShowMoreCall = false}) async {
    try {
      isApiCallProcessing.value = true;
      var response = await HttpHandler.postHttpMethod(
          url: APIShortsString.search, data: {
             "search_text": keyword,
             "count": count,
             "page_no": pageNumber,
          });
      searchResponse.value = response;
      isApiCallProcessing.value = false;
      log("search  :: response  :: ${response["body"]}");

      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          var respData = response['body']['data'];
          print("respData[last_page]   ${respData["last_page"]}");
          lastPage.value = respData["last_page"];
          print("respData[current_page]   ${respData["current_page"]}");
          currentPage.value = respData["current_page"];
          nextPage.value = currentPage.value + 1;
          print("isShowMoreCall   $isShowMoreCall");

          if (isShowMoreCall == true) {
            respData["data"].forEach((e) {
              print('e.toString()-->');
              print(e.toString());
              searchDataList.add(e);
            });
            print("searchDataList  add in existing $searchDataList");
          }
          else {
            searchDataList.value = respData["data"];
            print("searchDataList  replace $searchDataList");
          }

        } else if (response['body']['status'].toString() == "0") {
          searchDataList.value = [];
          showSnackbar(message: response['body']['msg']);
        }
      } else if (response['error'] != null) {

        searchDataList.value = [];
      }
    } catch (e, s) {
      hideLoadingDialog();
      debugPrint("search Error -- $e  $s");
    }
  }

///property search
  onPropertySearchTextChanged(String text) async {
    psearchResult.clear();
    if (text.replaceAll(" ", "").isEmpty) {
      print("text.isEmpty ");
      update();
      // setState(() {});
      return;
    }
    else if (text.length < 2) {
      print("text.length is ${text.length} which is ${text.length} < 2 ");
      update();
      // setState(() {});
      return;
    }
    print("${text.length} - ${text.length} - ${text.length} - ${text.length} - ${text.length} - ${text.length} - ${text.length} - ${text.length}");
    searchPropertyDataApi(keyword: text, pageNumber: 1);
  }

  Future searchPropertyDataApi({
    String? keyword,
    int pageNumber = 1,
    int count = 10,
    bool isShowMoreCall = false}) async {
    psearchDataList.clear();
    try {
      isApiCallProcessing.value = true;
      var response = await HttpHandler.postHttpMethod(
          url: APIShortsString.search_property, data: {
        "search_text": keyword,
        "count": count,
        "page_no": pageNumber,
      });
      psearchResponse.value = response;
      isApiCallProcessing.value = false;
      log("search  :: response  :: ${response["body"]}");

      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          // var respData = response['body']['data'];
          print("respData[last_page]   ${response['body']["last_page"]}");
          lastPage.value = response['body']["last_page"];
          print("respData[current_page]   ${response['body']["current_page"]}");
          currentPage.value = response['body']["current_page"];
          nextPage.value = currentPage.value + 1;
          print("isShowMoreCall   $isShowMoreCall");

          if (isShowMoreCall == true) {
            response['body']['data'].forEach((e) {
              print('e.toString()-->');
              print(e.toString());
              psearchDataList.add(e);
            });
            print("searchDataList  add in existing $psearchDataList");
          }
          else {
            psearchDataList.value = response['body']['data'];
            print("searchDataList  replace $psearchDataList");
          }
        } else if (response['body']['status'].toString() == "0") {
          psearchDataList.value = [];
          showSnackbar(message: response['body']['msg']);
        }
      } else if (response['error'] != null) {
        psearchDataList.value = [];
      }
    } catch (e, s) {
      hideLoadingDialog();
      debugPrint("search Error -- $e  $s");
    }
  }


/*  Future getProfileApi({
    String? keyword,
    String pageNumber = "1",
    String count = "10",
    bool isShowMoreCall = false}) async {
    try {
      isApiCallProcessing = true;
      var response = await HttpHandler.postHttpMethod(
          url: APIShortsString.search,
          data: {
            // "search": keyword,
            // "admin_auto_id": admin_auto_id,
            // "app_type_id": app_type_id,
            "search_text": keyword,
            "count": count,
            "page_no": pageNumber,
          }
      );

      log("search  :: response  :: ${response["body"]}");

      if (response['error'] == null) {

        searchResponse = response['body'];
        print("searchResponse   --- $searchResponse");
        if (response['body']['status'].toString() == "1") {

          lastPage = resp["allsearchlist"]["last_page"];
          currentPage = resp["allsearchlist"]["current_page"];
          nextPage = (int.parse(currentPage.toString()) + 1).toString();

          if (isShowMoreCall == true) {
            resp["allsearchlist"]["data"].forEach((e) {
              searchDataList.add(e);
            });
          }
          else {
            searchDataList = resp["allsearchlist"]["data"];
          }

          setState(() {});

        } else if (response['body']['status'].toString() == "0") {
          showSnackbar(message: response['body']['msg']);
        }
      } else if (response['error'] != null) {}
    } catch (e, s) {
      hideLoadingDialog();
      debugPrint("getProfile Error -- $e  $s");
    }
  }*/



  // addSearchData(String userId, String id, String title, String type) async {
  //   controller.text = title;
  //   if (mounted) {
  //     setState(() {
  //       isApiCallProcessing = true;
  //     });
  //   }
  //
  //   var url = baseUrl + 'api/' + search;
  //
  //   Uri uri = Uri.parse(url);
  //   final body = {
  //     "customer_auto_id": userId,
  //     "id": id,
  //     "title": title,
  //     "type": type,
  //     "admin_auto_id": admin_auto_id,
  //     "app_type_id": app_type_id,
  //   };
  //
  //   print("urlsearch ::  $uri");
  //   print("urlbody ::  $body");
  //
  //   final response = await http.post(uri, body: body);
  //   //print(response);
  //   if (response.statusCode == 200) {
  //     isApiCallProcessing = false;
  //
  //     final resp = jsonDecode(response.body);
  //     int status = resp['status'];
  //     print("status=>$status");
  //     if (status == 1) {
  //       print('search added');
  //       if (type == 'Product') {
  //         Navigator.push(context,
  //             MaterialPageRoute(builder: (context) => ProductDetailScreen(id)));
  //       } else if (type == 'Subcategory') {
  //         Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //                 builder: (context) => Product_List_User(
  //                   type: type,
  //                   main_cat_id: '',
  //                   sub_cat_id: id,
  //                   brand_id: '',
  //                   home_componet_id: "",
  //                   offer_id: '',
  //                 )));
  //       } else if (type == 'Brand') {
  //         Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //                 builder: (context) => Product_List_User(
  //                   type: type,
  //                   main_cat_id: '',
  //                   sub_cat_id: '',
  //                   brand_id: id,
  //                   home_componet_id: "",
  //                   offer_id: '',
  //                 )));
  //       } else if (type == 'category') {
  //         Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //                 builder: (context) => Product_List_User(
  //                   type: type,
  //                   main_cat_id: id,
  //                   sub_cat_id: '',
  //                   brand_id: '',
  //                   home_componet_id: "",
  //                   offer_id: '',
  //                 )));
  //       }
  //     }
  //     else {
  //       print('empty');
  //     }
  //     if (mounted) {
  //       setState(() {});
  //     }
  //   }
  // }


}
