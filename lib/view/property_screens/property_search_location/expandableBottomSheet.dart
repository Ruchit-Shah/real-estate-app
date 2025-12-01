import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:real_estate_app/common_widgets/height.dart';
import 'package:real_estate_app/common_widgets/loading_dart.dart';
import 'package:real_estate_app/global/app_color.dart';
import 'package:real_estate_app/utils/shared_preferences/shared_preferances.dart';
import 'package:real_estate_app/view/auth/login_screen/login_screen.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/profile_screen/profile_section_screens/my_virtual_tour/GetScheduleBottomSheet.dart';
import 'package:real_estate_app/view/filter_search/view/FilterSearchController.dart';
import 'package:real_estate_app/view/property_screens/properties_controllers/post_property_controller.dart';
import 'package:real_estate_app/view/property_screens/recommended_properties_screen/properties_details_screen.dart';
import 'package:real_estate_app/view/property_screens/recommended_properties_screen/propertyCard.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../global/api_string.dart';
import '../../../global/widgets/loading_dialog.dart';
import '../../../utils/CommonEnquirySheet.dart';
import '../../../utils/String_constant.dart';
import '../../../utils/network_http.dart';
import '../../dashboard/bottom_navbar_screens/profile_screen/profile_controller.dart';
import '../../dashboard/bottom_navbar_screens/search_screen/searchController.dart';
import '../../splash_screen/splash_screen.dart';



///
class ExpandableResultScreen extends StatefulWidget {
  final bool isAPIcall;
  final bool clear;
  final String property_category_type;
  final String category_price_type;
  final String property_type;
  final String bhk_type;
  final String city_name;
  final String area;
  final String properties_latitude;
  final String search_keyword;
  final String properties_longitude;

  const ExpandableResultScreen({
    super.key,
    required this.isAPIcall,
    required this.clear,
    required this.property_category_type,
    required this.category_price_type,
    required this.property_type,
    required this.area,
    required this.bhk_type,
    required this.city_name,
    required this.properties_latitude,
    required this.search_keyword,
    required this.properties_longitude,
  });

  @override
  State<ExpandableResultScreen> createState() => _ExpandableResultScreenState();
}

class _ExpandableResultScreenState extends State<ExpandableResultScreen> {




  final searchController search_controller = Get.put(searchController());
  String isContact = "";
  int count = 0;
  int _currentIndex = 0;
  final searchApiController = Get.find<searchController>();

  final FilterSearchController filterController = Get.find();
  final PostPropertyController postController = Get.find();
  RxString selectedValue = "".obs;
  final ScrollController _scrollController = ScrollController();
  String searchQuery = '';

  final int _pageSize = 10;
  final FocusNode _focusNode = FocusNode();
  TextEditingController searchControllerField = TextEditingController();
  String areaName = '';
  String cityName = '';
  @override
  @override
  void initState() {
    super.initState();
    filterController.initialIsFrom.value = "";
    filterController.initialPropertyCategoryType.value = widget.property_category_type;
    filterController.initialCategoryPriceType.value = widget.category_price_type;
    filterController.initialPropertyListedBy.value = "";
    postController.sortBY.value = '';
    filterController.initialCityName.value = widget.city_name;
    filterController.initialBhkType.value = widget.bhk_type;
    filterController.initialMaxArea.value = "";
    filterController.initialMinArea.value = "";
    filterController.initialMinPrice.value = "";
    filterController.initialMaxPrice.value = "";
    filterController.initialAmenties.value = "";
    filterController.initialFurnishStatus.value = "";
    filterController.initialPropertyType.value = widget.property_type;
    filterController.initialSearchKeyword.value = widget.search_keyword ?? "";
    filterController.initialArea.value = widget.area ?? "";
    filterController.isLoading.value = false; // Ensure loading is false initially
    filterController.hasMore.value = true; // Ensure hasMore is true initially
    searchControllerField.clear();
    postController.Ismap.value = false;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      postController.sortBY.value = "";
      // Explicitly pass reset: true for the initial call
      getLocationSearchData(
        widget.properties_latitude,
        widget.properties_longitude,
        "1",
        _pageSize.toString(),
        widget.property_category_type,
        widget.category_price_type,
        widget.property_type,
        widget.bhk_type,
        widget.city_name,
        reset: true, // Add reset: true to ensure the API call is not blocked
      );
    });

    filterController.getMarkers(controller.getSearchList).then((loadedMarkers) {
      setState(() {
        filterController.markers = loadedMarkers;
      });
    });
  }


  getClear()  {
    filterController.ClearData();
    filterController.selectedFurnishingStatusList.clear();
    filterController.isClear.value =true;

    filterController.budgetMin.value = null;
    filterController.budgetMax.value = null;

    filterController.budgetMin1.value = "";
    filterController.budgetMax1.value = "";

  }
  Future<void> loadMoreData() async {
    if (!filterController.hasMore.value || filterController.isPaginationLoading.value) {
      print("No more data to load or already loading");
      return;
    }

    filterController.isPaginationLoading.value = true;
    final nextPage = (filterController.currentPage.value + 1).toString();

    print('loadMoreData - searchQuery: ${searchControllerField.text}, page: $nextPage');
    print('loadMoreData - city: ${cityName}, area: ${areaName}');

    try {
      if (searchControllerField.text.isNotEmpty) {
        // Use searchLocation API when text field has input
        await searchLocation(
          search_query: searchControllerField.text.trim(),
          page: nextPage,
          city: cityName,
          search_area: widget.area.isNotEmpty ? widget.area : cityName,
        );
      } else if (postController.sortBY.value.isNotEmpty) {
        // Use getFilterProperty API when sortBy has a value
        await getFilterProperty(

          area: widget.area,

          sort_by: postController.sortBY.value,
          page: nextPage,
        );
      } else {
        // Use getLocationSearchData API as fallback
        await getLocationSearchData(
          widget.properties_latitude,
          widget.properties_longitude,
          nextPage,
          _pageSize.toString(),
          widget.property_category_type,
          widget.category_price_type,
          widget.property_type,
          widget.bhk_type,
          widget.city_name,
        );
      }

      // Update markers after successful API call
      final loadedMarkers = await filterController.getMarkers(controller.getSearchList);
      setState(() {
        filterController.markers = loadedMarkers;
      });
    } catch (e) {
      print("Error in loadMoreData: $e");
      Fluttertoast.showToast(msg: 'Error loading more data: $e');
    } finally {
      filterController.isPaginationLoading.value = false;
    }
  }

  void onSearchChanged() {
    filterController.currentPage.value = 1; // Reset to first page
    filterController.hasMore.value = true; // Assume more data is available
    controller.getSearchList.clear(); // Clear existing data
    print('onSearchChanged - searchQuery: ${searchControllerField.text}');
    print('onSearchChanged - city: ${cityName}, area: ${areaName}');


    if(searchControllerField.text.isNotEmpty){
      searchLocation(
        search_query: searchControllerField.text.trim(),
        city: cityName,

        search_area: widget.area,
        page: filterController.currentPage.value.toString(),
      );

    }else{
      getLocationSearchData(
        widget.properties_latitude,
        widget.properties_longitude,
        "1",
        _pageSize.toString(),
        widget.property_category_type,
        widget.category_price_type,
        widget.property_type,
        widget.bhk_type,
        widget.city_name,
      );
    }


    // Update markers after search
    filterController.getMarkers(controller.getSearchList).then((loadedMarkers) {
      setState(() {
        filterController.markers = loadedMarkers;
        _focusNode.unfocus();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Padding(padding: const EdgeInsets.symmetric(horizontal: 10.0), child: TextField(
            focusNode: _focusNode,
            controller: searchControllerField,
            onSubmitted: (value) {
              onSearchChanged();
            },

            decoration: InputDecoration(
              hintText: "Search...",
              hintStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.normal),
              prefixIcon: const Icon(Icons.search, size: 25),
              suffixIcon: IconButton(
                icon: const Icon(Icons.cancel, size: 18),
                onPressed: () {
                  searchControllerField.clear();
                  onSearchChanged();
                },
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:
                const BorderSide(color: Colors.grey, width: 0.8),
                borderRadius: BorderRadius.circular(25.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide:
                const BorderSide(color: Colors.grey, width: 0.8),
                borderRadius: BorderRadius.circular(25.0),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                  vertical: 12.0, horizontal: 16.0),
            ),
          ),),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 40,
        leading: Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.black, // Border color
                width: 0.1, // Border width
              ),
            ),
            child: InkWell(
              //   onTap: () {
              // // Get.back();
              //   },
              onTap: () {
                // setState(() {
                //   postController.Ismap.value= !postController.Ismap.value;
                // });
                ///
                if(postController.Ismap.value==true){
                  setState(() {
                    postController.Ismap.value=false;
                  });
                }else{
                  Get.back();
                }


              },
              borderRadius: BorderRadius.circular(
                  50), // Ensures ripple effect is circular
              child: const Padding(
                padding: EdgeInsets.all(6), // Adjust padding for better spacing
                child: Icon(
                  Icons.arrow_back_outlined,
                  size: 18, // Slightly increased for better visibility
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),

      ),
      body: Stack(
          children: [
            Obx(()=>
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              _showFilterBottomSheet(context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white, // Background color
                                  borderRadius:
                                  BorderRadius.circular(20), // Rounded shape
                                  border: Border.all(
                                    color: Colors.black.withOpacity(0.2), // Subtle border
                                    width: 0.8,
                                  ),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Sort",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    SizedBox(width: 8), // Space between text & icon
                                    Icon(
                                      Icons.keyboard_arrow_down, // Matching icon style
                                      size: 18,
                                      color: Colors.black87,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Obx(()=>
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      //  text: "56.9K ",
                                      text: '${filterController.total_count.value.toString()}  ' ,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "Results",
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ),

                          GestureDetector(
                            onTap: () {
                              postController.Ismap.value= !postController.Ismap.value;

                                Get.back();

                            },
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.05,
                              width: MediaQuery.of(context).size.width * 0.38,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  width: 1,
                                  color: const Color(0xFF813BEA),
                                ),
                                color: const Color(0xFF813BEA),
                              ),
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    postController.Ismap.value
                                    //   ? "assets/image_rent/listView.png"
                                        ? "assets/image_rent/listView.png"
                                        : "assets/image_rent/mapView.png",
                                    width: 24,
                                    height: 24,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    postController.Ismap.value ? "List View" : "Map View",
                                    style: const TextStyle(color: Colors.white, fontSize: 13),
                                  ),
                                ],
                              ),

                            ),
                          ),
                        ],
                      ),
                    ),


                    controller.getSearchList.isNotEmpty
                        ?


                    Expanded(
                      child: Obx(() {
                        if (controller.getSearchList.isEmpty && filterController.isLoading.value) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        return RefreshIndicator(
                          onRefresh: () async {
                            filterController.currentPage.value = 1;
                            filterController.hasMore.value = true;
                            controller.getSearchList.clear();
                            await loadMoreData(); // Reload data
                          },
                          child: LazyLoadScrollView(
                            onEndOfPage: () {
                              if (filterController.hasMore.value && !filterController.isPaginationLoading.value) {
                                loadMoreData();
                              } else {
                                print("LazyLoadScrollView: No more data or already loading");
                                print("hasMore: ${filterController.hasMore.value}, isPaginationLoading: ${filterController.isPaginationLoading.value}");
                              }
                            },
                            isLoading: filterController.isPaginationLoading.value,
                            child: ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              controller: _scrollController,
                              itemCount: controller.getSearchList.length + (filterController.isPaginationLoading.value ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index == controller.getSearchList.length) {
                                  return const Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Center(child: CircularProgressIndicator()),
                                  );
                                }

                                return propertyCard(
                                  property_data: controller.getSearchList[index],
                                  index: index,
                                  propertyList: controller.getSearchList,
                                );
                              },
                            ),
                          ),
                        );
                      }),
                    )
                        : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/data.png',
                            height: 40,
                            width: 40,
                          ),
                          boxH08(),
                          const Text(
                            'No data available',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
            ),
          ]),
    );
  }

  void viewPhone(context, String name, String contact_number, String email_id,
      String owner_type) async {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    showModalBottomSheet<void>(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return GetBuilder<ProfileController>(
          builder: (controller) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                top: MediaQuery.of(context).viewInsets.top,
                right: 10,
                left: 10,
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        children: [
                          Expanded(
                            child: Center(
                              child: Text(
                                "You Contacted",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.cancel,
                              size: 30,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                      const Divider(thickness: 1, color: Colors.grey),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.person_outline,
                                    size: 20, color: Colors.blue.shade900),
                                boxW10(),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '${name ?? "Unknown"} ',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15.0,
                                          color: Colors.black,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '(${owner_type ?? "Unknown"})',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15.0,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            boxH10(),
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 12,
                                  backgroundColor:
                                  Colors.green.withOpacity(0.1),
                                  child: Icon(Icons.phone,
                                      color: Colors.blue.shade900, size: 18),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  // Add Expanded here
                                  child: Text(
                                    contact_number ?? "Unknown",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.blueGrey,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 80,
                                  child: GestureDetector(
                                    onTap: () {
                                      _makePhoneCall(contact_number);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4, horizontal: 16),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade900,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Center(
                                        child: const Text(
                                          "Call",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            boxH10(),
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 12,
                                  backgroundColor:
                                  Colors.green.withOpacity(0.1),
                                  child: Icon(Icons.email,
                                      color: Colors.blue.shade900, size: 18),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    email_id,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.blueGrey,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 80,
                                  child: GestureDetector(
                                    onTap: () async {
                                      final email = email_id;
                                      final Uri emailLaunchUri = Uri(
                                        scheme: 'mailto',
                                        path: email,
                                        query: encodeQueryParameters({
                                          // 'subject': 'Revert Back to your Enquiry',
                                          // 'body': '${'Hello '+lead['name']},',
                                          'subject': 'Response to Your Inquiry',
                                          'body': '${'Hello ' + name},',
                                        }),
                                      );
                                      if (await canLaunch(
                                          emailLaunchUri.toString())) {
                                        await launch(emailLaunchUri.toString());
                                      } else {
                                        print(
                                            'Could not launch $emailLaunchUri');
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4, horizontal: 14),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade900,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          "Email",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
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

  _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) =>
    '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  void addEnquiry(BuildContext context, String propertyId, String ownerId) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController messageController = TextEditingController();

    showModalBottomSheet<void>(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return CommonBottomSheet(
          title: 'Add Enquiry',
          formKey: formKey,
          messageController: messageController,
          submitButtonText: 'Send Enquiry',
          onSubmit: () {
            search_controller
                .addPropertyEnquiry(
                property_id: propertyId,
                owner_id: ownerId,
                message: messageController.text)
                .then((value) {
              Navigator.of(context).pop();
            });
          },
        );
      },
    );
  }



  _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.width * 0.98,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              bottom: MediaQuery.of(context).viewInsets.bottom,
              top: 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween, // Ensures proper spacing
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.black, // Border color
                            width: 0.1, // Border width
                          ),
                        ),
                        child: InkWell(
                          onTap: () {
                            Get.back();
                          },
                          borderRadius: BorderRadius.circular(50),
                          child: const Padding(
                            padding: EdgeInsets.all(6),
                            child: Icon(
                              Icons.arrow_back_outlined,
                              size: 18,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          "Sort By",
                          style: TextStyle(
                            fontWeight: FontWeight.bold, // Bold text
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 40),
                  ],
                ),
                boxH20(),
                Obx(() => Column(
                  children: [
                    // {'value': 'relevance', 'label': 'Relevance'},
                    {'value': 'newest', 'label': 'Newest'},
                    {'value': 'low_to_high', 'label': 'Price low to high'},
                    {'value': 'high_to_low', 'label': 'Price high to low'},
                    {'value': 'oldest', 'label': 'Oldest'},
                  ].map((option) => Row(
                    children: [
                      Radio<String>(
                        value: option['value']!,
                        groupValue: postController.sortBY.value, // Use controller.sortBY.value
                        onChanged: (value) {
                          postController.sortBY.value = value!;

                          print("postController.sortBY.value=>${postController.sortBY.value}");
                          // Update controller.sortBY.value
                        },
                      ),
                      Text(
                        option['label']!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                    ],
                  )).toList(),
                )),
                const Spacer(),
                commonButton(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 50,
                  buttonColor: const Color(0xFF813BEA),
                  text: 'Sort',
                  textStyle: const TextStyle(fontSize: 14, color: Colors.white),
                  onPressed: () {
                    WidgetsBinding.instance.addPostFrameCallback((_) {

                      print("postController.sortBY.value11=>${postController.sortBY.value}");
                      //     postController.getMySearchProperty().then((value) => Get.back());
                       getFilterProperty(
                      area: widget.area,

                      sort_by: postController.sortBY.value,
                      page: "1",
                      ).then((value) => Get.back());
                    });

                  },
                ),
                boxH20(),
              ],
            ),
          ),
        );
      },
    );
  }


  void onChange(String? value) {
    selectedValue.value = value!;  // Update the selected value
  }

  Future<void> getLocationSearchData(
      String properties_latitude,
      String properties_longitude,
      String page,
      String page_size,
      String property_category_type,
      String category_price_type,
      String property_type,
      String bhk_type,
      String city_name,
      {bool reset = false}) async {
    // Skip if already loading and not resetting, or if no more data and not resetting
    if (filterController.isLoading.value || (!filterController.hasMore.value && !reset)) {
      print('getLocationSearchData skipped: isLoading=${filterController.isLoading.value}, hasMore=${filterController.hasMore.value}, reset=$reset');
      return;
    }

    filterController.isLoading.value = true;

    final stopwatch = Stopwatch()..start();
    print("getLocationSearchData called with page: $page, reset: $reset");

    try {
      if (reset) {
        controller.getSearchList.clear();
        filterController.currentPage.value = 1;
        filterController.hasMore.value = true;
        filterController.total_count.value = 0; // Reset total count
      }

      final requestData = {
        'page': page,
        'page_size': page_size,
        'building_type': property_category_type,
        'property_category_type': category_price_type,
        'property_type': property_type,
        'bhk_type': bhk_type,
        'city_name': city_name,
        'user_id': "",
        'min_price': "",
        'max_price': "",
        'amenities': "",
        'area': widget.area,
      };

      print("API request payload: $requestData");

      var response = await HttpHandler.postHttpMethod(
        url: APIString.searchLocation,
        data: requestData,
      ).timeout(const Duration(seconds: 10), onTimeout: () {
        throw TimeoutException('API call timed out after 10 seconds');
      });

      print("API response status: ${response['body']['status']}");
      print("API response body: ${response['body']}");

      print('API call completed in ${stopwatch.elapsedMilliseconds}ms');
      print('Response data length: ${response['body']['data']?.length ?? 0}');
      print('Current page: $page, Total pages: ${response['body']['total_pages']}, Total count: ${response['body']['total_count']}');

      filterController.total_count.value = int.tryParse(response['body']['total_count']?.toString() ?? "0") ?? 0;

      if (response['error'] == null &&
          response['body']['status'].toString() == "1" &&
          response['body']['data'] != null) {
        final data = response['body']['data'] ?? [];

        final newData = data.where((property) {
          final latStr = property['latitude']?.toString();
          final lngStr = property['longitude']?.toString();
          if (latStr == null || lngStr == null || latStr == "null" || lngStr == "null" || latStr.isEmpty || lngStr.isEmpty) {
            print('Skipping invalid property ${property['_id'] ?? 'unknown'}: lat=$latStr, lng=$lngStr');
            return false;
          }
          final lat = double.tryParse(latStr);
          final lng = double.tryParse(lngStr);
          if (lat == null || lng == null || lat == 0.0 || lng == 0.0) {
            print('Skipping invalid coordinates for property ${property['_id'] ?? 'unknown'}: lat=$latStr, lng=$lngStr');
            return false;
          }
          return true;
        }).toList();

        if (int.parse(page) == 1 || reset) {
          controller.getSearchList.clear();
        }
        controller.getSearchList.addAll(newData);

        final totalCount = response['body']['total_count'] ?? 0;
        final totalPages = response['body']['total_pages'] ?? 1;

        filterController.hasMore.value = int.parse(page) < totalPages || controller.getSearchList.length < totalCount;
        if (filterController.hasMore.value && !reset) {
          filterController.currentPage.value = int.parse(page) + 1;
        }

        print('getSearchList size: ${controller.getSearchList.length}');
        Fluttertoast.showToast(msg: 'Fetched successfully');

        // Update markers after successful API call
        final loadedMarkers = await filterController.getMarkers(controller.getSearchList);
        setState(() {
          filterController.markers = loadedMarkers;
        });
      } else {
        final errorMsg = response['body']['msg'] ?? response['error'] ?? 'Property not found';
        print('API error: $errorMsg');
        filterController.hasMore.value = false;
        Fluttertoast.showToast(msg: errorMsg);
      }
    } catch (e, stackTrace) {
      print('API call error: $e');
      print('Stack trace: $stackTrace');
      filterController.hasMore.value = false;
      Fluttertoast.showToast(msg: 'Error fetching data: $e');
    } finally {
      filterController.isLoading.value = false;
      print('getLocationSearchData completed in ${stopwatch.elapsedMilliseconds}ms');
    }
  }

  Future<void> searchLocation({
    String? search_query,
    String? search_area,
    String? city,
    String? page = '1',
  }) async {
    try {
      if (page == '1') {
        controller.getSearchList.clear();
        filterController.total_count.value = 0;
        filterController.currentPage.value = 0;
        filterController.totalPages.value = 0;
        filterController.isLoading.value = true;
        showHomLoading(Get.context!, 'Processing...');
      } else {
        filterController.isPaginationLoading.value = true;
      }

      Get.focusScope!.unfocus();
      String? userId = await SPManager.instance.getUserId(USER_ID);
      var response = await HttpHandler.postHttpMethod(
        url: APIString.search_properties,
        data: {
          "search_query": search_query ?? '',
          "user_id": userId ?? '',
          "area": filterController.initialArea.value,
          "city": city ?? '',
          "page": page ?? '1',
          "page_size": APIString.Index,
        },
      );

      log('response----- ${response["body"]}');

      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          final respData = response['body'];
          List<dynamic> data = respData["data"];

          filterController.currentPage.value = respData["current_page"] is int
              ? respData["current_page"]
              : int.tryParse(respData["current_page"].toString()) ?? 0;

          filterController.totalPages.value = respData["total_pages"] is int
              ? respData["total_pages"]
              : int.tryParse(respData["total_pages"].toString()) ?? 0;

          filterController.total_count.value = respData["total_count"] is int
              ? respData["total_count"]
              : int.tryParse(respData["total_count"].toString()) ?? 0;

          filterController.hasMore.value = filterController.currentPage.value < filterController.totalPages.value;

          print("Called searchLocation with page: $page");
          print("→ Updated currentPage: ${filterController.currentPage.value}, totalPages: ${filterController.totalPages.value}");

          if (int.parse(page!) == 1) {
            controller.getSearchList.clear();
          }
          controller.getSearchList.addAll(data);
        } else if (response['body']['status'].toString() == "0") {
          if (page == '1') {
            controller.getSearchList.clear();
          }
          filterController.hasMore.value = false;
          //Fluttertoast.showToast(msg: response['body']['message'].toString());
        }
      } else if (response['error'] != null) {
        var responseBody = json.decode(response['body'] ?? {});
        //Fluttertoast.showToast(msg: responseBody['message']);
      }
    } catch (e, s) {
      debugPrint("searchLocation Error -- $e  $s");
      if (page == '1') {
        controller.getSearchList.clear();
      }
      //Fluttertoast.showToast(msg: 'Not found');
    } finally {
      filterController.isLoading.value = false;
      filterController.isPaginationLoading.value = false;
      if (page == '1' && Navigator.canPop(Get.context!)) {
        Navigator.of(Get.context!).pop();
      }
    }
  }
  Future<void> getFilterProperty({
    String? property_category_type,
    String? city_name,
    String? area,
    String? searchKeyword,

    String? sort_by,
    String? page,
  }) async {
    try {
      if (page == '1') {
        controller.getSearchList.clear();
        filterController.total_count.value = 0;
        filterController.currentPage.value = 0;
        filterController.totalPages.value = 0;
        filterController.isLoading.value = true;
        showHomLoading(Get.context!, 'Processing...');
      } else {
        filterController.isPaginationLoading.value = true;
      }

      final Map<String, String> data = {
        if ((searchKeyword ?? '').isNotEmpty) 'search_keyword': searchKeyword!,
        if ((area ?? '').isNotEmpty) 'area': widget.area!,
        if ((city_name ?? widget.city_name).isNotEmpty) 'city_name': city_name ?? widget.city_name,

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

        filterController.currentPage.value = int.tryParse(respData["current_page"].toString()) ?? 0;
        filterController.totalPages.value = int.tryParse(respData["total_pages"].toString()) ?? 0;
        filterController.total_count.value = int.tryParse(respData["total_count"].toString()) ?? 0;
        filterController.hasMore.value = filterController.currentPage.value < filterController.totalPages.value;

        if (int.parse(page!) == 1) {
          controller.getSearchList.clear();
        }
        controller.getSearchList.addAll(responseData);

      } else {
        if (page == '1') {
          controller.getSearchList.clear();
        }
        filterController.hasMore.value = false;
      }
    } catch (e) {
      if (page == '1') {
        controller.getSearchList.clear();
      }
      // Optional: log or show error
    } finally {
      filterController.isLoading.value = false;
      filterController.isPaginationLoading.value = false;
      if (page == '1') {
        hideLoadingDialog();
      }
    }
  }

}
