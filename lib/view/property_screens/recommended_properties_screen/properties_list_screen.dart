import 'dart:async';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:real_estate_app/common_widgets/height.dart';
import 'package:real_estate_app/global/app_color.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/CustomBottomNavBar.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/profile_screen/profile_screen.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/profile_screen/profile_section_screens/my_virtual_tour/GetScheduleBottomSheet.dart';
import 'package:real_estate_app/view/filter_search/view/FilterSearchController.dart';
import 'package:real_estate_app/view/filter_search/view/filter_search_screen.dart';
import 'package:real_estate_app/view/map/result_ui/result_ui_screen.dart';
import 'package:real_estate_app/view/property_screens/recommended_properties_screen/properties_details_screen.dart';
import 'package:real_estate_app/view/property_screens/recommended_properties_screen/propertyCard.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../common_widgets/loading_dart.dart';
import '../../../global/api_string.dart';
import '../../../global/widgets/loading_dialog.dart';
import '../../../utils/CommonEnquirySheet.dart';
import '../../../utils/text_style.dart';
import '../../auth/login_screen/login_screen.dart';
import '../../dashboard/bottom_navbar_screens/profile_screen/profile_controller.dart';
import '../../dashboard/bottom_navbar_screens/search_screen/searchController.dart';
import '../../splash_screen/splash_screen.dart';
import '../filter/filtter_screen.dart';
import '../properties_controllers/post_property_controller.dart';
import 'dart:ui' as ui;

class PropertiesListScreen extends StatefulWidget {
  final String isFrom;

  const PropertiesListScreen(
      {super.key, required this.isFrom});

  @override
  State<PropertiesListScreen> createState() => _PropertiesListScreenState();
}

class _PropertiesListScreenState extends State<PropertiesListScreen> {
  final PostPropertyController controller = Get.find();
  final searchApiController = Get.find<searchController>();
  final FocusNode _focusNode = FocusNode();
  int _currentIndex = 0;
  GoogleMapController? _mapController;
  final FilterSearchController _filterController = Get.find();
  final Completer<GoogleMapController> _controller = Completer();


  final scrollController = ScrollController();

  bool isDialogShowing = false;


  @override
  // void initState() {
  //   super.initState();
  // controller.searchController.clear();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     print("widget.isFrom-->${widget.isFrom}");
  //     if(widget.isFrom=="featured"){
  //       controller.getFeaturedProperty(page: '1');
  //     }else{
  //       controller.getRecommendedProperty(page: '1');
  //     }
  //
  //     searchApiController.getsessionData();
  //     controller.Ismap.value= false;
  //     // print('widget data :${widget.data}');
  //   });
  //   controller.sortBY.value = 'relevance';
  //   getMarkers().then((loadedMarkers) {
  //       markers = loadedMarkers;
  //   });
  //   scrollController.addListener(() {
  //     if (scrollController.position.pixels >=
  //         scrollController.position.maxScrollExtent - 100 &&
  //         !controller.isPaginationLoading.value &&
  //         controller.hasMore.value) {
  //       loadMoreData();
  //     }
  //   });
  // }

  @override
  void initState() {
    super.initState();

    controller.searchController.clear();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Show loading dialog
      showHomLoading(context, 'Loading...');
      getClear();
      // Print debug info
      print("widget.isFrom-->${widget.isFrom}");

      // Call the appropriate API
      if (widget.isFrom == "featured") {
        await controller.getFeaturedProperty(page: '1');
      } else {
        await controller.getRecommendedProperty(page: '1');
      }

      // Additional calls
      await searchApiController.getsessionData();
      controller.Ismap.value = false;

      controller.sortBY.value = '';

      // Get map markers
      // getMarkers().then((loadedMarkers) {
      //   markers = loadedMarkers;
      // });
      setState(() {
        _filterController.getMarkers(controller.getCommonPropertyList).then((loadedMarkers) {
          setState(() {
            _focusNode.unfocus();
            _filterController.markers = loadedMarkers;
          });
        });
      });
      // Set up infinite scrolling
      scrollController.addListener(() {
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 100 &&
            !controller.isPaginationLoading.value &&
            controller.hasMore.value) {
          loadMoreData();
        }
      });

      // Hide the loading dialog
      hideLoadingDialog();
    });
  }

  getClear()  {
    _filterController.ClearData();
    _filterController.selectedFurnishingStatusList.clear();
    _filterController.isClear.value =true;
    controller.sortBY.value = '';

    // pController.profileController.myListingPrperties.clear();
    // pController.getCommonPropertyList.clear();
    // controller.budgetMin.value = 5;
    // controller.budgetMax.value = 10;
    _filterController.budgetMin.value = null;
    _filterController.budgetMax.value = null;

    _filterController.budgetMin1.value = "";
    _filterController.budgetMax1.value = "";

    // await pController.getMySearchProperty(
    //   searchKeyword: widget.search_key,
    //   city: '',
    //   locality: '',
    //   max_price:controller.budgetMax1.value!=""?"${controller.budgetMax.value.toString()}00000":
    //   controller.budgetMax1.value.toString(),
    //   min_price:controller.budgetMin1.value.toString() ,
    //   showFatured: widget.isFrom =='profile' || widget.isFrom=='my_leads' ? 'false': 'true',
    //   property_type:controller.selectedPropertyType.join('|') ,
    //   isFrom: widget.isFrom=="my_leads"?"profile":widget.isFrom,
    //   furnishtype: controller.selectedFurnishingStatusList.join('|'),
    //   bhktype: controller.selectedBHKTypeList.join('|'),
    //
    // );
  }


  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  // void loadMoreData() {
  //   if (controller.hasMore.value && controller.isPaginationLoading.value) {
  //     controller.isPaginationLoading.value = true;
  //
  //     final nextPage = (controller.currentPage.value + 1).toString();
  //
  //     if (controller.searchController.text.trim().isNotEmpty) {
  //       controller.getMySearchProperty(searchKeyword:controller.searchController.text.trim(),showFatured: 'true',page: nextPage);
  //     } else {
  //       print("widget.isFrom-->${widget.isFrom}");
  //       if(widget.isFrom=="featured"){
  //         controller.getFeaturedProperty(page: nextPage);
  //       }else{
  //         controller.getRecommendedProperty(page:nextPage);
  //       }
  //     }
  //   }
  // }




  Future<void> loadMoreData() async {
    if (controller.hasMore.value && !controller.isPaginationLoading.value) {
      print("loadMoreData called: Fetching next page");
      controller.isPaginationLoading.value = true;

      final nextPage = (controller.currentPage.value + 1).toString();
      print("Next page to fetch: $nextPage");

      if (controller.searchController.text.trim().isNotEmpty) {
        print("Fetching search results for page: $nextPage");
        controller.getMySearchProperty(
          searchKeyword: controller.searchController.text.trim(),
          //showFatured: 'true',
          showFatured: widget.isFrom =='featured'  ? 'true': 'false',
          page: nextPage,
        );
      } else {
        print("widget.isFrom: ${widget.isFrom}");
        print("controller.sortBY.value ${controller.sortBY.value}");
        print("_filterController.isClear.value  ${_filterController.isClear.value }");


        if(_filterController.isClear.value || controller.sortBY.value.isEmpty || controller.sortBY.value==''){
          if (widget.isFrom == "featured") {
            print("Fetching featured properties for page: $nextPage");
            controller.getFeaturedProperty(page: nextPage);
          } else {
            print("Fetching recommended properties for page: $nextPage");
            controller.getRecommendedProperty(page: nextPage);
          }
        }else{
          controller.getMySearchProperty(
              searchKeyword: controller.searchController.text.trim(),
              city: '',
              locality: '',
              max_price:_filterController.budgetMax1.value!=""?"${_filterController.budgetMax.value.toString()}00000":
              _filterController.budgetMax1.value.toString(),
              min_price:_filterController.budgetMin1.value.toString() ,
              //  showFatured: widget.isFrom =='profile' || widget.isFrom=='my_leads' ? 'false': 'true',
              showFatured: widget.isFrom =='featured'  ? 'true': 'false',
              property_type:_filterController.selectedPropertyType.join('|') ,
              isFrom: widget.isFrom=="my_leads"?"profile":widget.isFrom,
              furnishtype: _filterController.selectedFurnishingStatusList.join('|'),
              bhktype: _filterController.selectedBHKTypeList.join('|'),
              page: nextPage

          );
        }

      }
    }
    else {
      print("loadMoreData not called: hasMore=${controller.hasMore.value}, isPaginationLoading=${controller.isPaginationLoading.value}");
    }
    return;
  }
  void onSearchChanged(String value) async {
    controller.currentPage.value = 1;
    controller.hasMore.value = true;
    if (value.trim().isEmpty) {
      if(widget.isFrom=="featured"){
        await  controller.getFeaturedProperty(page: '1');
      }else{
        await controller.getRecommendedProperty(page: '1');
      }
    } else {
      print('not empty');
      await controller.getMySearchProperty(searchKeyword:value.trim(),showFatured:  widget.isFrom =='featured'  ? 'true': 'false',page: '1');
    }
    setState(() {
      _filterController.getMarkers(controller.getCommonPropertyList).then((loadedMarkers) {
        setState(() {
          _focusNode.unfocus();
          _filterController.markers = loadedMarkers;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: widget.isFrom == 'profile'
            ? const Text(
                "My Favorite",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              )
            :    Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            height: 40,
            child: TextField(
              focusNode: _focusNode,
              controller: controller.searchController,
              onSubmitted: (value) {
                onSearchChanged(value);
              },

              decoration: InputDecoration(
                hintText: "Search...",
                hintStyle: const TextStyle(
                    color: Colors.grey, fontWeight: FontWeight.normal),
                prefixIcon: const Icon(Icons.search, size: 25),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.cancel, size: 18),
                  onPressed: () {
                    controller.searchController.clear();
                    controller.sortBY.value = '';
                    onSearchChanged('');
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
            ),
          ),
        ),
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
              // onTap: () {
              //   Get.back();
              // },
              onTap: () {
                // setState(() {
                //   Ismap= !Ismap;
                // });
                ///
                if(controller.Ismap.value==true){
                  setState(() {
                    controller.Ismap.value=false;
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
        actions: [
          if (widget.isFrom == 'profile')
            const SizedBox()
          else
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.black, // Border color
                    width: 0.1, // Border width
                  ),
                ),
                child: InkWell(
                  onTap: () {

                   Get.to( FilterScreen(search_key: controller.searchController.text, isFrom:widget.isFrom=="featured"? 'featured':'',));
                  },
                  borderRadius: BorderRadius.circular(50),
                  child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Image.asset(
                        "assets/image_rent/filter.png",
                        height: 10,
                        width: 12,
                      )),
                ),
              ),
            )
        ],
      ),
      body: Obx(() => Stack(
          children:[
            Column(
              children: [
                widget.isFrom == 'profile'
                    ? const SizedBox(height: 15,) : Padding(
                  padding: const EdgeInsets.only(top: 10, left: 8.0, right: 8.0 ),
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
                                //text: controller.getCommonPropertyList.length.toString(),
                                text: controller.total_count.toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const TextSpan(
                                text: " Results",
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
                            controller.Ismap.value= !controller.Ismap.value;
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
                                controller.Ismap.value
                                    //? "assets/image_rent/mapView.png"
                                    ? "assets/image_rent/listView.png"
                                    : "assets/image_rent/mapView.png",
                                width: 24,
                                height: 24,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                controller.Ismap.value ? "List View" : "Map View",
                                style: const TextStyle(color: Colors.white, fontSize: 13),
                              ),
                            ],
                          ),
                          // Row(
                          //   crossAxisAlignment: CrossAxisAlignment.center,
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     Image.asset(
                          //       "assets/image_rent/mapView.png",
                          //       width: 24,
                          //       height: 24,
                          //       color: Colors.white,
                          //     ),
                          //     const SizedBox(width: 5),
                          //     const Text(
                          //       "Map View",
                          //       style: TextStyle(color: Colors.white, fontSize: 13),
                          //     ),
                          //   ],
                          // ),
                        ),
                      ),
                    ],
                  ),
                ),

                controller.getCommonPropertyList.isNotEmpty && controller.getCommonPropertyList.isNotEmpty
                    ?  controller.Ismap.value?
                Stack(
                  children: <Widget>[
                    SizedBox(
                      width: Get.width,
                      height: Get.height * 0.8,
                      child: GoogleMap(
                        buildingsEnabled: false,
                        trafficEnabled: false,
                        mapToolbarEnabled: false,
                        onMapCreated: (GoogleMapController controller) {
                          _mapController = controller;
                          _controller.complete(controller);
                        },
                        zoomGesturesEnabled: true,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(_filterController.latitude.value, _filterController.longitude.value),
                          zoom: 13.50,
                        ),
                        mapType: MapType.normal,
                        myLocationEnabled: true,
                        zoomControlsEnabled: true,
                        myLocationButtonEnabled: true,
                        onTap: (LatLng latLng) {
                          // Handle map tap if necessary
                        },
                        markers: _filterController.markers,
                      ),
                    ),

                    Positioned(
                      bottom: -90,
                      child: ResultUi(
                        data: controller.getCommonPropertyList,
                        onLoadMore: () async {
                          await loadMoreData(); // 👈 your parent pagination logic
                        },
                      ),
                    )
                  ],
                ) :
                Expanded(
                  child: RefreshIndicator(
                      onRefresh: () async {
                        if(widget.isFrom=="featured"){
                          controller.getFeaturedProperty(page: '1');
                        }else{
                          controller.getRecommendedProperty(page: '1');
                        }
                      },
                      child:LazyLoadScrollView(
                        // onEndOfPage: () {
                        //   print("object");
                        //   if (controller.hasMore.value && controller.isPaginationLoading.value) {
                        //     loadMoreData(); // Your existing method
                        //   }else{
                        //     print("LazyLoadScrollView==>");
                        //     print(controller.hasMore.value);
                        //     print(controller.isPaginationLoading.value);
                        //   }
                        // },
                        onEndOfPage: () {
                          print("Reached end of page");
                          if (controller.hasMore.value && !controller.isPaginationLoading.value) {
                            loadMoreData();
                          } else {
                            print("LazyLoadScrollView==>");
                            print("hasMore: ${controller.hasMore.value}");
                            print("isPaginationLoading: ${controller.isPaginationLoading.value}");
                          }

                          print("LazyLoadScrollView==>");
                          print("hasMore: ${controller.hasMore.value}");
                          print("isPaginationLoading: ${controller.isPaginationLoading.value}");
                        },

                        isLoading: controller.isPaginationLoading.value,
                        child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          controller: scrollController,
                          itemCount:  controller.getCommonPropertyList.length + (controller.isPaginationLoading.value ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index ==  controller.getCommonPropertyList.length) {
                              return const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Center(child: CircularProgressIndicator()),
                              );
                            }
                              return propertyCard( property_data: controller.getCommonPropertyList[index], index: index, propertyList: controller.getCommonPropertyList,);
                          },
                        ),
                      )

                  ),
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
          ])),

    );
  }

  void viewPhone(context, String name, String contact_number, String email_id,
      String owner_type, String property_id, String owner_id) async {
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
                          const Expanded(
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
                                      child: const Center(
                                        child: Text(
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
                            boxH10(),
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 12,
                                  backgroundColor:
                                      Colors.green.withOpacity(0.1),
                                  child: Icon(Icons.headset_mic_outlined,
                                      color: Colors.blue.shade900, size: 18),
                                ),
                                const SizedBox(width: 12),
                                const Expanded(
                                  child: Text(
                                    'Enquiry',
                                    style: TextStyle(
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
                                      Navigator.pop(context);
                                      addEnquiry(
                                          context, property_id, owner_id);
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
                                          "Add",
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
            searchApiController
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

  String getImageUrl(int index) {
    if (widget.isFrom == 'project' ||
        widget.isFrom == 'featured' ||
        widget.isFrom == 'offer' ||
        widget.isFrom == 'profile' ||
        widget.isFrom == 'recommended') {
      return controller.getCommonPropertyList[index]['cover_image'];
    } else {
      return APIString.imageBaseUrl +controller.getCommonPropertyList[index]['cover_image'];
    }
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
                        groupValue: controller.sortBY.value, // Use controller.sortBY.value
                        onChanged: (value) {
                          controller.sortBY.value = value!; // Update controller.sortBY.value
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
                    // controller.getMySearchProperty()
                      setState(() {
                        _filterController.isClear.value=false;
                      });
                      controller.getMySearchProperty(
                          searchKeyword:controller.searchController.text.trim(),
                          showFatured:  widget.isFrom =='featured'  ? 'true': 'false',
                          max_price:_filterController.budgetMax1.value!=""?"${_filterController.budgetMax.value.toString()}00000":
                          _filterController.budgetMax1.value.toString(),
                          min_price:_filterController.budgetMin1.value.toString() ,
                          //  showFatured: widget.isFrom =='profile' || widget.isFrom=='my_leads' ? 'false': 'true',

                          property_type:_filterController.selectedPropertyType.join('|') ,
                          isFrom: widget.isFrom=="my_leads"?"profile":widget.isFrom,
                          furnishtype: _filterController.selectedFurnishingStatusList.join('|'),
                          bhktype: _filterController.selectedBHKTypeList.join('|'),
                          page: '1')
                        .then((value) => Get.back());
                    });                  },
                ),

                boxH20(),
              ],
            ),
          ),
        );
      },
    );
  }

}
