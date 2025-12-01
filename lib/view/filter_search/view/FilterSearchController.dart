import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:real_estate_app/global/widgets/loading_dialog.dart';
import 'package:real_estate_app/view/filter_search/view/filterListScreen.dart';
import 'package:flutter/services.dart';
import '../../../common_widgets/loading_dart.dart';
import '../../../global/api_string.dart';
import '../../../utils/String_constant.dart';
import '../../../utils/network_http.dart';
import '../../../utils/shared_preferences/shared_preferances.dart';
import 'dart:ui' as ui;
import 'package:maps_toolkit/maps_toolkit.dart' as MapsTookit;
  class FilterSearchController extends GetxController {
    RxString initialIsFrom = ''.obs;
    RxString initialPropertyCategoryType = ''.obs;
    RxString initialCategoryPriceType = ''.obs;
    RxString initialPropertyListedBy = ''.obs;
    RxString initialCityName = ''.obs;
    RxString initialBhkType = ''.obs;
    RxString initialMaxArea = ''.obs;
    RxString initialMinArea = ''.obs;
    Set<Marker> markers = {};
    RxString initialMinPrice = ''.obs;
    RxString initialMaxPrice = ''.obs;
    RxString initialAmenties = ''.obs;
    RxString initialFurnishStatus = ''.obs;
    RxString initialPropertyType = ''.obs;
    RxString initialSearchKeyword = ''.obs;
    RxString initialArea = ''.obs;



    var currentAddress = ''.obs;
    var city = ''.obs;
    var area = ''.obs;
    RxBool showresult = false.obs;
    RxList getSearchList = [].obs;
    var selectedLocation = "".obs;
    var isFetchingLocation = false.obs;
    final isPaginationLoading = false.obs;
    final hasMore = true.obs;
    final currentPage = 1.obs;
    final totalPages = 1.obs;
    final total_count = 0.obs;
    final scrollController = ScrollController();
    final scrollControllerForFilterList = ScrollController();
    TextEditingController searchController = TextEditingController();

    ClearData(){

      BHKType.value="";
      //selectedFurnishingStatusList.clear();
      selectedPropertyType.clear();

      selectedBHKTypeList.clear();
      city.value = '';

    }


    final List<Map<String, dynamic>> budgetOptions = [
      {'value': 5, 'label': '₹ 5 Lakhs'},
      {'value': 10, 'label': '₹ 10 Lakhs'},
      {'value': 15, 'label': '₹ 15 Lakhs'},
      {'value': 20, 'label': '₹ 20 Lakhs'},
      {'value': 25, 'label': '₹ 25 Lakhs'},
      {'value': 30, 'label': '₹ 30 Lakhs'},
      {'value': 40, 'label': '₹ 40 Lakhs'},
      {'value': 50, 'label': '₹ 50 Lakhs'},
      {'value': 60, 'label': '₹ 60 Lakhs'},
      {'value': 75, 'label': '₹ 75 Lakhs'},
      {'value': 90, 'label': '₹ 90 Lakhs'},
      {'value': 100, 'label': '₹ 1 Crore'},
      {'value': 125, 'label': '₹ 1.25 Crore'},
      {'value': 150, 'label': '₹ 1.5 Crore'},
      {'value': 175, 'label': '₹ 1.75 Crore'},
      {'value': 200, 'label': '₹ 2 Crore'},
      {'value': 300, 'label': '₹ 3 Crore'},
      {'value': 400, 'label': '₹ 4 Crore'},
      {'value': 500, 'label': '₹ 5 Crore'},
      {'value': 1000, 'label': '₹ 10 Crore'},
      {'value': 2000, 'label': '₹ 20 Crore'},
      {'value': 3000, 'label': '₹ 30 Crore'},
      {'value': 5000, 'label': '₹ 50 Crore'},
      {'value': 7500, 'label': '₹ 75 Crore'},
    ];


    var BHKType = ''.obs;
    var latitude = 18.5642.obs;
    var longitude =73.7769.obs;
    RxBool isLoading = false.obs;
    // var budgetMin = 5.obs;
    // var budgetMax = 10.obs;
    final RxnInt budgetMin = RxnInt(); // Nullable int
    final RxnInt budgetMax = RxnInt();

    RxString currentCity = "Pune".obs;
    RxString budgetMin1 = "".obs;
    RxString budgetMax1 = "".obs;

    RxBool isClear=false.obs;
    var areaMin = 0.0.obs;
    var areatMax = 0.0.obs;
    var selectedFurnishingStatusList = <String>[].obs;
    var lookingFor = <String>[].obs;
    var selectedPropertyType = <String>[].obs;
    var selectedBHKTypeList = <String>[].obs;
    var selectAmenities = <String>[].obs;
    var selectedPostedByList = <String>[].obs;


    RxBool markersReady = false.obs;
    RxBool isLoadingMarkers = false.obs;
    List<LatLng> userPolyLinesLatLngList = [];
    RxBool isIconsSet = false.obs;
    RxList getFilterData = [].obs;
    RxList getSaveList = [].obs;
    late BitmapDescriptor propertiesIcon;
    Future<void> getCurrentLocation() async {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);

        double lat = position.latitude;
        double lon = position.longitude;

        latitude.value = lat;
        longitude.value = lon;

        print("Current latitude -> $lat");
        print("Current longitude -> $lon");

        try {
          // 🔁 Reverse geocoding
          List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);

          if (placemarks.isNotEmpty) {
            Placemark place = placemarks[0];
            currentCity.value = place.locality!;

            print("Current city: ${currentCity.value}.");
          }
        } catch (e) {
          print("Error in reverse geocoding: $e");
        }

      } else {
        print("Location permission denied");
      }
    }


    Future<void> addSearchName({String? name,String? property_id,String? property_name,String? search_by,String? area,String? propertName}) async {
      String? userId = await SPManager.instance.getUserId(USER_ID);
     try {

    //   property_id, user_id, save_search_name
        var response = await HttpHandler.postHttpMethod(
          url: APIString.addSaveSearchProperty,
          data: {
            'user_id':userId,
            'property_id':property_id,
            'property_name':property_name,
           'search_by':search_by,
           'building_type':area,
           'property_category_type':propertName,
          },
        );

        if (response['error'] == null) {
          if (response['body']['status'].toString() == "1") {

            log("response[data]  ---- ${response['body']["data"]}");
            var respData = response['body'];
          //  //Fluttertoast.showToast(msg: 'Add');
          }
        }
        else if (response['error'] != null) {
          var responseBody = json.decode(response['body']);
          ////Fluttertoast.showToast(msg: responseBody['msg']);

        }
      } catch (e) {

       debugPrint("Login Error: $e");
        ////Fluttertoast.showToast(msg: 'An error occurred. Please try again.');
      }
    }


    Future<void> getSaveSearch({ String? search_by,String? page = '1'}) async {

      if (page == '1') {
        getSaveList.clear();
        // isLoading.value = true;
        // showLoadingDialog1(Get.context!, 'Processing...');
      } else {
        isPaginationLoading.value = true;
      }

      String? userId = await SPManager.instance.getUserId(USER_ID);


      try {
        Get.focusScope?.unfocus();

        var response = await HttpHandler.postHttpMethod(
          url: APIString.getSaveSearch,
          data: {
            'user_id': userId,
            'search_by': search_by,
            'page': page,
            'page_size': APIString.Index,
          },
        );

        if (response['error'] == null) {
          final respData = response['body'];

          if (respData['status'].toString() == "1") {
            currentPage.value = respData["current_page"] is int
                ? respData["current_page"]
                : int.tryParse(respData["current_page"].toString()) ?? currentPage.value;

            totalPages.value = respData["total_pages"] is int
                ? respData["total_pages"]
                : int.tryParse(respData["total_pages"].toString()) ?? totalPages.value;

            hasMore.value = currentPage.value < totalPages.value;

            print("Called getMyListingProperties with page: $page");
            print("→ Updated currentPage: ${currentPage.value}, totalPages: ${totalPages.value}");

            // if (respData["data"] != null && respData["data"] is List) {
            //   getSaveList.addAll(respData["data"]);
            // }
            if (respData["data"] != null && respData["data"] is List) {
              List<dynamic> newData = respData["data"];

              // Step 1: Get existing property_ids in list
              Set<String> existingIds = getSaveList
                  .map((item) => item['property_id'].toString())
                  .toSet();

              // Step 2: Remove duplicates inside newData
              Map<String, dynamic> uniqueByPropertyId = {};

              for (var item in newData) {
                String propertyId = item['property_id'].toString();
                if (!uniqueByPropertyId.containsKey(propertyId)) {
                  uniqueByPropertyId[propertyId] = item;
                }
              }

              List filteredNewItems = uniqueByPropertyId.entries
                  .where((entry) => !existingIds.contains(entry.key))
                  .map((entry) => entry.value)
                  .toList();

               getSaveList.addAll(filteredNewItems);
            }



            else {
              print("respData['data'] is null or not a List");
            }
          } else {
            if (page == '1') {
              getSaveList.clear();
              // Fluttertoast.showToast(msg: 'No Saved Found');
            }
            hasMore.value = false;
          }
        } else {
          getSaveList.clear();
          var responseBody = json.decode(response['body']);
          // Fluttertoast.showToast(msg: responseBody['msg']);
        }
      } catch (e) {
        debugPrint("Listing Error: $e");
        if (page == '1') {
          getSaveList.clear();
        }
        //Fluttertoast.showToast(msg: 'No Listing Found');
      } finally {
     //   isLoading.value = false;
        isPaginationLoading.value = false;
        if (page == '1') {
        //  hideLoadingDialog();
        } else {

        }

        //  if (Navigator.canPop(Get.context!)) {
        //    Navigator.of(Get.context!).pop();
        //  }
      }
    }



    Future<void> deleteSaveSearch({String? id}) async {
      String? userId = await SPManager.instance.getUserId(USER_ID);
      showHomLoading(Get.context!, 'Processing...');
      try {
        var response = await HttpHandler.deleteHttpMethod(
          url: APIString.delete_save_search,
          data: {
            'saved_search_id': id,
          },
        );
        if (response['error'] == null) {
          if (response['body']['status'].toString() == "1") {
            getSaveSearch(page: '1');
            update();
            //Fluttertoast.showToast(msg: 'Successfully deleted');
          }
        } else if (response['error'] != null) {

          var responseBody = json.decode(response['body']);
          //Fluttertoast.showToast(msg: responseBody['msg']);

        }
      } catch (e) {
        debugPrint("Login Error: $e");
        //Fluttertoast.showToast(msg: 'An error occurred. Please try again.');
      } finally {
        isLoading.value = false;
        hideLoadingDialog();
      }
    }

    // Future<void> getSaveSearch() async {
    //   String? userId = await SPManager.instance.getUserId(USER_ID);
    //   getSaveList.clear();
    //    try {
    //
    //     var response = await HttpHandler.postHttpMethod(
    //       url: APIString.getSaveSearch,
    //       data: {
    //         'user_id':userId??"",
    //
    //       },
    //     );
    //     if (response['error'] == null) {
    //       if (response['body']['status'].toString() == "1") {
    //         log("response[data]  ---- ${response['body']["data"]}");
    //         var respData = response['body']['data'];
    //         getSaveList.addAll(respData);
    //
    //         // print("getSaveList.length-->");
    //         // print(getSaveList.length);
    //       }
    //     }
    //
    //     else if (response['error'] != null) {
    //     //  //Fluttertoast.showToast(msg: 'An error occurred. Please try again.');
    //     }
    //   } catch (e) {
    //     debugPrint("Login Error: $e");
    //   //  //Fluttertoast.showToast(msg: 'An error occurred. Please try again.');
    //   }
    // }

    Future<void> searchLocation({
      String? search_query,
      String? search_area,
      String? city,
      String? property_type,
      String? user_type,
      String? page = '1',
    }) async {
      try {
        if (page == '1') {
          getFilterData.clear();
          total_count.value = 0;
          currentPage.value = 0;
          totalPages.value = 0;
          isLoading.value = true;
          showHomLoading(Get.context!, 'Processing...');
        } else {
          isPaginationLoading.value = true;
        }

        Get.focusScope!.unfocus();
        String? userId = await SPManager.instance.getUserId(USER_ID);

        // Dynamically build the request data map
        Map<String, dynamic> requestData = {
          "page": page ?? '1',
          "page_size": APIString.Index,
        };

        if (search_query?.isNotEmpty ?? false) {
          requestData["search_query"] = search_query;
        }
        if (search_area?.isNotEmpty ?? false) {
          requestData["area"] = search_area;
        }
        if (city?.isNotEmpty ?? false) {
          requestData["city_name"] = city;
        }
        if (user_type?.isNotEmpty ?? false) {
          requestData["user_type"] = user_type;
        }
        if (property_type?.isNotEmpty ?? false) {
          requestData["property_type"] = property_type;
        }
        if (userId?.isNotEmpty ?? false) {
          requestData["user_id"] = userId;
        }

        var response = await HttpHandler.postHttpMethod(
          url: APIString.search_properties,
          data: requestData,
        );

        log('response----- ${response["body"]}');

        if (response['error'] == null) {
          if (response['body']['status'].toString() == "1") {
            final respData = response['body'];
            List<dynamic> data = respData["data"];

            currentPage.value = respData["current_page"] is int
                ? respData["current_page"]
                : int.tryParse(respData["current_page"].toString()) ?? 0;

            totalPages.value = respData["total_pages"] is int
                ? respData["total_pages"]
                : int.tryParse(respData["total_pages"].toString()) ?? 0;

            total_count.value = respData["total_count"] is int
                ? respData["total_count"]
                : int.tryParse(respData["total_count"].toString()) ?? 0;

            hasMore.value = currentPage.value < totalPages.value;

            print("Called searchLocation with page: $page");
            print("→ Updated currentPage: ${currentPage.value}, totalPages: ${totalPages.value}");

            getFilterData.addAll(data);

            isLoading.value = false;
          } else if (response['body']['status'].toString() == "0") {
            if (page == '1') {
              getFilterData.clear();
            }
            hasMore.value = false;
            //Fluttertoast.showToast(msg: response['body']['message'].toString());
          }
        } else if (response['error'] != null) {
          var responseBody = json.decode(response['body'] ?? {});
          //Fluttertoast.showToast(msg: responseBody['message']);
        }
      } catch (e, s) {
        debugPrint("searchLocation Error -- $e  $s");
        if (page == '1') {
          getFilterData.clear();
        }
        //Fluttertoast.showToast(msg: 'Not found');
      } finally {
        isLoading.value = false;
        isPaginationLoading.value = false;
        if (page == '1' && Navigator.canPop(Get.context!)) {
          Navigator.of(Get.context!).pop();
        }
      }
    }


    // Future<void> getFilterProperty({
    //   String? property_category_type,
    //   String? city_name,
    //   String? area,
    //   String? searchKeyword,
    //   String? isFrom,
    //   String? bhk_type,
    //   String? min_price,
    //   String? max_price,
    //   String? category_price_type,
    //   String? min_area,
    //   String? max_area,
    //   String? amenties,
    //   String? property_type,
    //   String? furnish_status,
    //   String? property_listed_by,
    //   String? page
    // }) async
    // {
    //   try {
    //
    //     if (page == '1') {
    //       getFilterData.clear();
    //       total_count.value = 0;
    //       currentPage.value = 0;
    //       totalPages.value = 0;
    //       isLoading.value = true;
    //       showLoadingDialog1(Get.context!, 'Processing...');
    //     } else {
    //       isPaginationLoading.value = true;
    //     }
    //
    //     var response = await HttpHandler.postHttpMethod(
    //       url: APIString.filter_property,
    //       data: {
    //         'search_keyword':searchKeyword??'',
    //         'area':area??'',
    //         'property_category_type':property_category_type??'',
    //         'city_name':city_name??city.value,
    //         'bhk_type':bhk_type??'',
    //         'min_price':min_price??'',
    //         'max_price':max_price??'',
    //         'category_price_type':category_price_type??'',
    //         'min_area':min_area??'',
    //         'max_area': max_area??'',
    //         'amenties':amenties??'',
    //         'property_type':property_type??'',
    //         'furnished_type':furnish_status??'',
    //         'property_listed_by':property_listed_by??'',
    //         'page': page??'1',
    //         'page_size': APIString.Index,
    //
    //       },
    //     );
    //
    //     if (response['body']['status'].toString() == "1") {
    //
    //       final respData = response['body'];
    //       List<dynamic> data = respData["data"];
    //
    //
    //
    //       currentPage.value = respData["current_page"] is int ? respData["current_page"] : int.tryParse(respData["current_page"].toString()) ?? 0;
    //
    //       totalPages.value = respData["total_pages"] is int ? respData["total_pages"] : int.tryParse(respData["total_pages"].toString()) ?? 0;
    //
    //       total_count.value = respData["total_count"] is int ? respData["total_count"] : int.tryParse(respData["total_count"].toString()) ?? 0;
    //
    //       hasMore.value = currentPage.value < totalPages.value;
    //
    //       print("Called getMyListingProperties with page: $page");
    //       print("→ Updated currentPage: ${currentPage.value}, totalPages: ${totalPages.value}");
    //
    //       getFilterData.addAll(data);
    //
    //       if(isFrom == 'filterScreen') {
    //         for (var item in getFilterData.take(3)) {
    //           final id = item["_id"]?.toString() ?? '';
    //           final name = item["city_name"]?.toString() ?? '';
    //           final property_name = item["property_name"]?.toString() ?? '';
    //           final area = item["address"]?.toString() ?? '';
    //           addSearchName(property_id: id, property_name: name,search_by: 'Normal',area:area,propertName:property_name  );
    //         }
    //       }
    //
    //     }
    //     else{
    //
    //       if (page == '1') {
    //         getFilterData.clear();
    //         //Fluttertoast.showToast(msg: 'No data Found');
    //       }
    //       hasMore.value = false;
    //       // getFilterData.clear();
    //       // isLoading.value = false;
    //       // //Fluttertoast.showToast(msg: 'Not found');
    //     }
    //   } catch (e) {
    //     if (page == '1') {
    //       getFilterData.clear();
    //     }
    //
    //     //Fluttertoast.showToast(msg: 'Not found');
    //   } finally {
    //     isLoading.value = false;
    //     isPaginationLoading.value = false;
    //     if (page == '1') {
    //       hideLoadingDialog();
    //     } else {
    //
    //     }
    //   }
    // }


    Future<void> getFilterProperty({
      String? property_category_type,
      String? city_name,
      String? area,
      String? searchKeyword,
      String? isFrom,
      String? bhk_type,
      String? min_price,
      String? max_price,
      String? category_price_type,
      String? min_area,
      String? max_area,
      String? amenties,
      String? property_type,
      String? furnish_status,
      String? property_listed_by,
      String? sort_by,
      String? page,
    }) async {
      try {
        if (page == '1') {
          getFilterData.clear();
          total_count.value = 0;
          currentPage.value = 0;
          totalPages.value = 0;
          isLoading.value = true;
          showHomLoading(Get.context!, 'Processing...');
        } else {
          isPaginationLoading.value = true;
        }


        final Map<String, String> data = {
          if ((searchKeyword ?? '').isNotEmpty) 'search_keyword': searchKeyword!,
          // if ((area ?? '').isNotEmpty) 'area': area!,
          if ((property_category_type ?? '').isNotEmpty) 'property_category_type': property_category_type!,
          if ((city_name ?? city.value).isNotEmpty) 'city_name': city_name ?? city.value,
          if ((bhk_type ?? '').isNotEmpty) 'bhk_type': bhk_type!,
          if ((min_price ?? '').isNotEmpty) 'min_price': min_price!,
          if ((max_price ?? '').isNotEmpty) 'max_price': max_price!,
          if ((category_price_type ?? '').isNotEmpty) 'category_price_type': category_price_type!,
          if ((min_area ?? '').isNotEmpty) 'min_area': min_area!,
          if ((max_area ?? '').isNotEmpty) 'max_area': max_area!,
          if ((amenties ?? '').isNotEmpty) 'amenties': amenties!,
          if ((property_type ?? '').isNotEmpty) 'property_type': property_type!,
          if ((furnish_status ?? '').isNotEmpty) 'furnished_type': furnish_status!,
          if ((property_listed_by ?? '').isNotEmpty) 'property_listed_by': property_listed_by!,
          if ((sort_by ?? '').isNotEmpty) 'sort_by': sort_by!,
          'page': page ?? '1',
          'page_size': APIString.Index,
        };

        var response = await HttpHandler.postHttpMethod(
          url: APIString.filter_property,
          data: data,
        );

        if (response['body']['status'].toString() == "1") {
          final respData = response['body'];
          List<dynamic> responseData = respData["data"];

          currentPage.value = int.tryParse(respData["current_page"].toString()) ?? 0;
          totalPages.value = int.tryParse(respData["total_pages"].toString()) ?? 0;
          total_count.value = int.tryParse(respData["total_count"].toString()) ?? 0;
          hasMore.value = currentPage.value < totalPages.value;

          getFilterData.addAll(responseData);

          if (isFrom == 'filterScreen') {
            for (var item in getFilterData.take(3)) {
              final id = item["_id"]?.toString() ?? '';
              final name = item["city_name"]?.toString() ?? '';
              final property_name = item["property_name"]?.toString() ?? '';
              final area = item["address"]?.toString() ?? '';
              addSearchName(
                property_id: id,
                property_name: name,
                search_by: 'Normal',
                area: area,
                propertName: property_name,
              );
            }
          }
        } else {
          if (page == '1') {
            getFilterData.clear();
          }
          hasMore.value = false;
        }
      } catch (e) {
        if (page == '1') {
          getFilterData.clear();
        }
        // Optional: log or show error
      } finally {
        isLoading.value = false;
        isPaginationLoading.value = false;
        if (page == '1') {
          hideLoadingDialog();
        }
      }
    }

    Future<void> getFilterCityCategoryProperty({
      String? property_category_type,
      String? city_name,
      String? area,
      String? searchKeyword,

      String? bhk_type,
      String? min_price,
      String? max_price,
      String? category_price_type,
      String? min_area,
      String? max_area,
      String? amenties,
      String? property_type,
      String? furnish_status,
      String? property_listed_by,
      String? sort_by,
      String? page,
    }) async {
      try {
        if (page == '1') {
          getFilterData.clear();
          total_count.value = 0;
          currentPage.value = 0;
          totalPages.value = 0;
          isLoading.value = true;
          showHomLoading(Get.context!, 'Processing...');
        } else {
          isPaginationLoading.value = true;
        }


        final Map<String, String> data = {
          if ((searchKeyword ?? '').isNotEmpty) 'search_keyword': searchKeyword!,
          // if ((area ?? '').isNotEmpty) 'area': area!,
          if ((property_category_type ?? '').isNotEmpty) 'property_category_type': property_category_type!,
          if ((city_name ?? city.value).isNotEmpty) 'city_name': city_name ?? city.value,
          if ((bhk_type ?? '').isNotEmpty) 'bhk_type': bhk_type!,
          if ((min_price ?? '').isNotEmpty) 'min_price': min_price!,
          if ((max_price ?? '').isNotEmpty) 'max_price': max_price!,
          if ((category_price_type ?? '').isNotEmpty) 'category_price_type': category_price_type!,
          if ((min_area ?? '').isNotEmpty) 'min_area': min_area!,
          if ((max_area ?? '').isNotEmpty) 'max_area': max_area!,
          if ((amenties ?? '').isNotEmpty) 'amenties': amenties!,
          if ((property_type ?? '').isNotEmpty) 'property_type': property_type!,
          if ((furnish_status ?? '').isNotEmpty) 'furnished_type': furnish_status!,
          if ((property_listed_by ?? '').isNotEmpty) 'property_listed_by': property_listed_by!,
          if ((sort_by ?? '').isNotEmpty) 'sort_by': sort_by!,
          'page': page ?? '1',
          'page_size': APIString.Index,
        };

        var response = await HttpHandler.postHttpMethod(
          url: APIString.filter_property,
          data: data,
        );

        if (response['body']['status'].toString() == "1") {
          final respData = response['body'];
          List<dynamic> responseData = respData["data"];

          currentPage.value = int.tryParse(respData["current_page"].toString()) ?? 0;
          totalPages.value = int.tryParse(respData["total_pages"].toString()) ?? 0;
          total_count.value = int.tryParse(respData["total_count"].toString()) ?? 0;
          hasMore.value = currentPage.value < totalPages.value;

          getFilterData.addAll(responseData);

        } else {
          if (page == '1') {
            getFilterData.clear();
          }
          hasMore.value = false;
        }
      } catch (e) {
        if (page == '1') {
          getFilterData.clear();
        }
        // Optional: log or show error
      } finally {
        isLoading.value = false;
        isPaginationLoading.value = false;
        if (page == '1') {
          hideLoadingDialog();
        }
      }
    }


    Future<Set<Marker>> getMarkers(RxList getFilterData) async {
      Set<Marker> markers = {};

      final List<dynamic> filterDataCopy = List.from(getFilterData);

      for (var user in filterDataCopy) {
        double lat = double.tryParse(user['latitude'].toString()) ?? 0.0;
        double lng = double.tryParse(user['longitude'].toString()) ?? 0.0;

        if (lat == 0.0 && lng == 0.0) continue;



        final Uint8List markerIcon = await getBytesFromAsset('assets/properties.png', 100);


        markers.add(Marker(
          markerId: MarkerId(user['_id'].toString()),
          position: LatLng(lat, lng),
          infoWindow: InfoWindow(

            // title: '₹${user['property_price']}',
            title:   user['property_category_type']=="Rent"?
            ' ${formatIndianPrice(user['rent'].toString())}/ Month':
            formatIndianPrice( user['property_price'].toString()),
            snippet: '${user['property_name']}',
          ),
          icon: BitmapDescriptor.fromBytes(markerIcon),
        ));

      }

      return markers;
    }

    String formatIndianPrice(String? priceStr) {
      try {
        final price = double.tryParse(priceStr ?? "0") ?? 0;

        if (price >= 10000000) {
          double crore = price / 10000000;
          return '₹${_formatRounded(crore)} Cr';
        } else if (price >= 100000) {
          double lakh = price / 100000;
          return '₹${_formatRounded(lakh)} L';
        } else if (price >= 1000) {
          double thousand = price / 1000;
          return '₹${_formatRounded(thousand)} K';
        } else {
          return '₹${_formatRounded(price)}';
        }
      } catch (e) {
        return priceStr ?? "";
      }
    }
    String _formatRounded(double value) {
      if (value % 1 == 0) {
        return value.toStringAsFixed(0); // e.g., 3K
      } else {
        return value.toStringAsFixed(1); // e.g., 3.5K
      }
    }

    Future<void> updateMarkers() async {
      final stopwatch = Stopwatch()..start();
      print('Starting updateMarkers');

      if (getSearchList.isEmpty) {
        print('No properties to display');

          markers = {};
          isLoadingMarkers.value = false;
          markersReady.value = true;

        return;
      }

      isLoadingMarkers.value = true;
      try {
        await setMarkerIcons();

        final bounds = userPolyLinesLatLngList.isEmpty
            ? null
            : LatLngBounds.fromList(userPolyLinesLatLngList);
        final propertyPolygon = getSearchList.where((property) {
          final latStr = property['latitude']?.toString();
          final lngStr = property['longitude']?.toString();
          final lat = double.tryParse(latStr ?? '') ?? 0.0;
          final lng = double.tryParse(lngStr ?? '') ?? 0.0;

          if (lat == 0.0 || lng == 0.0) {
            print('Invalid coordinates in updateMarkers for property ${property['_id'] ?? 'unknown'}: lat=$latStr, lng=$lngStr');
            return false;
          }

          if (bounds != null && !bounds.contains(LatLng(lat, lng))) return false;
          if (userPolyLinesLatLngList.isEmpty) return true;

          try {
            return MapsTookit.PolygonUtil.containsLocation(
              MapsTookit.LatLng(lat, lng),
              userPolyLinesLatLngList
                  .map((latLng) => MapsTookit.LatLng(latLng.latitude, latLng.longitude))
                  .toList(),
              false,
            );
          } catch (e) {
            print('Polygon check error for property ${property['_id'] ?? 'unknown'}: $e');
            return false;
          }
        }).toList();

        print('Filtered properties: ${propertyPolygon.length}');

        const batchSize = 50;
        final newMarkers = <Marker>{};
        for (var i = 0; i < propertyPolygon.length; i += batchSize) {
          final batch = propertyPolygon
              .skip(i)
              .take(batchSize)
              .map<Marker>((property) {
            final lat = double.tryParse(property['latitude']?.toString() ?? '') ?? 0.0;
            final lng = double.tryParse(property['longitude']?.toString() ?? '') ?? 0.0;
            return Marker(
              markerId: MarkerId(property['_id'] ?? 'marker_$i'),
              position: LatLng(lat, lng),
              infoWindow: InfoWindow(
                title: '₹${property['property_price'] ?? 'N/A'}',
                onTap: onMarkerClicked,
              ),
              icon: propertiesIcon,
            );
          }).toSet();
          newMarkers.addAll(batch);
          await Future.delayed(Duration(milliseconds: 50));
        }

        print('Marker creation completed in ${stopwatch.elapsedMilliseconds}ms');
        markers = newMarkers;
        isLoadingMarkers.value = false;
        markersReady.value = true;
      } catch (e, stackTrace) {
        print('updateMarkers error: $e');
        print('Stack trace: $stackTrace');
        isLoadingMarkers.value = false;
        markersReady.value = true;
      }
    }
    onMarkerClicked() async {
      showresult.value = true;
    }
    Future<void> setMarkerIcons() async {
      if (!isIconsSet.value) {
        final Uint8List markerIconBytes = await getBytesFromAsset('assets/properties.png', 100);
        propertiesIcon = BitmapDescriptor.fromBytes(markerIconBytes);
        isIconsSet.value = true;

      }
    }
    Future<Uint8List> getBytesFromAsset(String path, int width) async {
      ByteData data = await rootBundle.load(path);
      ui.Codec codec =
      await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
      ui.FrameInfo fi = await codec.getNextFrame();
      return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
    }
    Future<void> searchLocationAI({String? search_query, String? search_area,String? city}) async {
      try {
        showHomLoading(Get.context!, 'Processing...');
        getFilterData.clear();
        isLoading.value = true;
        Get.focusScope!.unfocus();
        String? userId = await SPManager.instance.getUserId(USER_ID);
        var response = await HttpHandler.postHttpMethod(
          url: APIString.search_properties,
          data: {
            "search_query": search_query ?? '',
            "user_id": userId ?? '',
            "area":search_area ?? '',
            "city":city ?? ''
          },
        );

        log('response----- ${response["body"]}');

        if (response['error'] == null) {
          if (response['body']['status'].toString() == "1") {

            //log("response[data]  ---- ${response['body']["data"]}");
            var respData = response['body'];

            getFilterData.value = respData["data"];

            //Navigator.of(Get.context!).pop();
            isLoading.value = false;
          } else if (response['body']['status'].toString() == "0") {
            getFilterData.value=[];
            //Fluttertoast.showToast(msg: response['body']['message'].toString());
          }
        } else if (response['error'] != null) {
          var responseBody = json.decode(response['body'] ?? []);
          //Fluttertoast.showToast(msg: responseBody['message']);
        }
      } catch (e, s) {
        debugPrint("updateProfile Error -- $e  $s");
      } finally {
        isLoading.value = false;
        if (Navigator.canPop(Get.context!)) {
          Navigator.of(Get.context!).pop();
        }
      }
    }

    Future<void> getMysearchFiletr({String? searchKeyword,String? page,String? showFatured,String? isFrom})
    async {
      String? userId = await SPManager.instance.getUserId(USER_ID);
      if (page == '1') {
        getFilterData.clear();
        isLoading.value = true;
        showHomLoading(Get.context!, 'Processing...');
      } else {
        isPaginationLoading.value = true;
      }

      try {
        Get.focusScope?.unfocus();

        var response = await HttpHandler.postHttpMethod(
          url: APIString.my_properties_search,
          data: {
            'user_id': isFrom == 'profile' ? userId : '',
            'search_keyword': searchKeyword,
            'page': page,
            'show_featured': showFatured ?? 'false',
            'page_size': APIString.Index,
          },
        );

        if (response['error'] == null) {
          if (response['body']['status'].toString() == "1") {
            final respData = response['body'];
            List<dynamic> newItems = respData["data"];

            // Pagination setup
            currentPage.value = int.tryParse(respData["current_page"].toString()) ?? 1;
            totalPages.value = int.tryParse(respData["total_pages"].toString()) ?? 1;
            hasMore.value = currentPage.value < totalPages.value;

            getFilterData.addAll(newItems);
          } else {
            if (page == '1') {
              getFilterData.clear();
              //Fluttertoast.showToast(msg: 'No Listing Found');
            }
            hasMore.value = false;
          }
        } else {
          getFilterData.clear();
          var responseBody = json.decode(response['body']);
          //Fluttertoast.showToast(msg: responseBody['msg']);
        }
      } catch (e) {
        debugPrint("Search Error: $e");
        if (page == '1') {
          getFilterData.clear();
        }
        //Fluttertoast.showToast(msg: 'No Listing Found');
      } finally {
        isLoading.value = false;
        isPaginationLoading.value = false;
        if (page == '1') {
          hideLoadingDialog();
        } else {

        }
        // if (Navigator.canPop(Get.context!)) {
        //   Navigator.of(Get.context!).pop();
        // }
      }
    }



  }


