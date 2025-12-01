import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:ui' as ui;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:real_estate_app/common_widgets/loading_dart.dart';
import 'package:real_estate_app/global/app_color.dart';
import 'package:real_estate_app/utils/common_snackbar.dart';
import 'package:real_estate_app/view/auth/login_screen/login_screen.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/profile_screen/profile_section_screens/my_virtual_tour/GetScheduleBottomSheet.dart';
import 'package:real_estate_app/view/filter_search/view/FilterSearchController.dart';
import 'package:real_estate_app/view/filter_search/view/filter_search_screen.dart';
import 'package:real_estate_app/view/map/result_ui/result_ui_screen.dart';
import 'package:real_estate_app/view/property_screens/properties_controllers/post_property_controller.dart';
import 'package:real_estate_app/view/property_screens/recommended_properties_screen/properties_details_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:real_estate_app/view/property_screens/recommended_properties_screen/propertyCard.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../common_widgets/height.dart';
import '../../../global/api_string.dart';
import '../../../utils/CommonEnquirySheet.dart';
import '../../dashboard/bottom_navbar_screens/profile_screen/profile_controller.dart';
import '../../dashboard/bottom_navbar_screens/search_screen/searchController.dart';
import '../../splash_screen/splash_screen.dart';

class FilterListScreen extends StatefulWidget {
  late final String isFrom;

  late final String property_category_type;
  late final String category_price_type;
  late final String property_listed_by;
  late final String city_name;
  late final String bhk_type;
  late final String max_area;
  late final String min_area;
  late final String min_price;
  late final String max_price;
  late  final String amenties;
  late final String furnish_status;
  late final String property_type;
   String? searchKeyword;
   String? area;


   FilterListScreen({
    Key? key,
    required this.isFrom,
    required this.property_category_type,
    required this.category_price_type,
    required this.property_listed_by,
    required this.bhk_type,
    required this.max_area,
    required this.min_price,
    required this.min_area,
    required this.max_price,
    required this.amenties,
    required this.furnish_status,
    required this.property_type,

    required this.city_name, this.searchKeyword, this.area,

  }) : super(key: key);

  @override
  State<FilterListScreen> createState() => _FilterListScreenState();
}

class _FilterListScreenState extends State<FilterListScreen> {
  final searchController search_controller = Get.put(searchController());
  String isContact = "";
  int count = 0;
  int _currentIndex = 0;
  final searchApiController = Get.find<searchController>();
  final FilterSearchController filterController = Get.find();
  final PostPropertyController postController = Get.find();
  RxString selectedValue = "".obs;
  GoogleMapController? _mapController;
  String searchQuery = '';
  final scrollControllerForFilterList = ScrollController();
  final Completer<GoogleMapController> _controller = Completer();
  final FocusNode _focusNode = FocusNode();
  TextEditingController searchControllerField = TextEditingController();
  String areaName = '';
  String cityName = '';
  @override
  void initState() {
    super.initState();
    filterController.initialIsFrom.value = widget.isFrom;
    filterController.initialPropertyCategoryType.value = widget.property_category_type;
    filterController.initialCategoryPriceType.value = widget.category_price_type;
    filterController.initialPropertyListedBy.value = widget.property_listed_by;
    postController.sortBY.value='';
    filterController.initialCityName.value = widget.city_name;
    filterController.initialBhkType.value = widget.bhk_type;
    filterController.initialMaxArea.value = widget.max_area;
    filterController.initialMinArea.value = widget.min_area;
    filterController.initialMinPrice.value = widget.min_price;
    filterController.initialMaxPrice.value = widget.max_price;
    filterController.initialAmenties.value = widget.amenties;
    filterController.initialFurnishStatus.value = widget.furnish_status;
    filterController.initialPropertyType .value= widget.property_type;
    filterController.initialSearchKeyword.value = widget.searchKeyword??"";
    filterController.initialArea.value = widget.area??"";

    if(widget.isFrom == 'popularCity'){
      searchControllerField.clear();
    }
    setCity();
    postController.Ismap.value= false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initialFilterAPI();

      search_controller.getsessionData();
      getClear();

    });

    scrollControllerForFilterList.addListener(() {
      if (scrollControllerForFilterList.position.pixels >=
          scrollControllerForFilterList.position.maxScrollExtent - 100 &&
          !filterController.isPaginationLoading.value &&
          filterController.hasMore.value) {
        loadMoreData();
      }
    });
  }
  void setCity() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        cityName = widget.city_name;
        areaName = widget.area != null && widget.area!.isNotEmpty ? widget.area! : widget.city_name;
        filterController.city.value = cityName;
        filterController.area.value = areaName;
        if (kDebugMode) {
          print('Initialized - cityName: $cityName, areaName: $areaName');
        }
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

    print("loadMoreData==>");
    if (filterController.hasMore.value && !filterController.isPaginationLoading.value) {
      filterController.isPaginationLoading.value = true;

      final nextPage = (filterController.currentPage.value + 1).toString();
      print('loadMoreData - searchQuery: ${searchControllerField.text}');
      print('loadMoreData - city: ${cityName}, area: ${areaName}');

      pagignationFilterAPI(nextPage.toString());

      filterController.isPaginationLoading.value = false;
    }

    return;
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  Future<void> onSearchChanged() async {
    filterController.currentPage.value = 1;
    filterController.hasMore.value = true;
    print('onSearchChanged - searchQuery: ${searchControllerField.text}');
    print('onSearchChanged - city: ${cityName}, area: ${areaName}');

    if (searchControllerField.text.trim().isEmpty) {
      await initialFilterAPI();
    } else {
    await  SearrchAPI();

    }
    setState(() {
      filterController.getMarkers(filterController.getFilterData).then((loadedMarkers) {
        setState(() {
          _focusNode.unfocus();
          filterController.markers = loadedMarkers;
        });
      });
    });
  }

  Future<void> initialFilterAPI() async {
    if(widget.isFrom == "selectCategory"){
    await  filterController.getFilterProperty(
          property_category_type: widget.property_category_type,
          category_price_type:widget.category_price_type,
          property_listed_by: widget.property_listed_by,
          city_name:widget.city_name,
          searchKeyword: widget.searchKeyword,
          area: widget.area,
          isFrom: 'filterScreen',
          bhk_type:widget.bhk_type,
          max_area:widget.max_area,
          min_area: widget.min_area,
          min_price:widget.min_price,
          max_price:widget.max_price,
          furnish_status:widget.furnish_status,
          property_type:widget.property_type,
          sort_by:  postController.sortBY.value,
          page: '1'
      );
    }
    else if(widget.isFrom == "popularCity"){
      filterController.getFilterProperty(
          property_category_type: widget.property_category_type,
          category_price_type:widget.category_price_type,
          property_listed_by: widget.property_listed_by,
          city_name: widget.isFrom == "popularCity" ?  widget.city_name :widget.city_name,
          searchKeyword: widget.searchKeyword,area: widget.area,
          isFrom: 'filterScreen',
          bhk_type:widget.bhk_type,
          max_area:widget.max_area,
          min_area: widget.min_area,
          min_price:widget.min_price,
          max_price:widget.max_price,
          furnish_status:widget.furnish_status,
          property_type:widget.property_type,
          sort_by:  postController.sortBY.value,
          page: '1'
      );
    }
    else{
      filterController.getFilterProperty(
          property_category_type: widget.property_category_type,
          category_price_type:widget.category_price_type,
          property_listed_by: widget.property_listed_by,
          city_name: widget.isFrom == "popularCity" ?  widget.city_name :widget.city_name,
          searchKeyword: widget.searchKeyword,area: widget.area,
          isFrom: 'filterScreen',
          bhk_type:widget.bhk_type,
          max_area:widget.max_area,
          min_area: widget.min_area,
          min_price:widget.min_price,
          max_price:widget.max_price,
          furnish_status:widget.furnish_status,
          property_type:widget.property_type,
          sort_by:  postController.sortBY.value,
          page: '1'
      );
    }

    filterController.getMarkers(filterController.getFilterData).then((loadedMarkers) {
      setState(() {
        filterController.markers = loadedMarkers;
      });
    });
  }
  Future<void> SearrchAPI() async {
    if(widget.isFrom == "selectCategory"){
    await   filterController.searchLocation(
      search_query: searchControllerField.text.trim(),
      user_type: widget.property_listed_by,

    );
    }
    else if(widget.isFrom == "popularCity"){
      await  filterController.searchLocation(
        search_query: searchControllerField.text.trim(),
        city: cityName,

      );
    }else if(widget.isFrom == "searchScreen"){
      await  filterController.searchLocation(
        search_query: searchControllerField.text.trim(),
        property_type: widget.property_type,

      );
    }
    else{
      await  filterController.searchLocation(
        search_query: searchControllerField.text.trim(),
        city: cityName,

      );
    }

    filterController.getMarkers(filterController.getFilterData).then((loadedMarkers) {
      setState(() {
        filterController.markers = loadedMarkers;
      });
    });
  }

   Future<void> pagignationFilterAPI(String nextPage) async {

     if(widget.isFrom == "selectCategory"){

       if (searchControllerField.text.isNotEmpty) {
         await filterController.searchLocation(
           search_query: searchControllerField.text,
           page: nextPage,

           city: cityName,
           search_area: areaName != '' ? areaName : cityName,
         );
         setState(() {
           filterController.getMarkers(filterController.getFilterData).then((loadedMarkers) {
             setState(() {
               filterController.markers = loadedMarkers;
             });
           });
         });
       }
       else {
         await filterController.getFilterProperty(
           property_category_type: filterController.initialPropertyCategoryType.value,
           category_price_type: filterController.initialCategoryPriceType.value,
           property_listed_by: filterController.initialPropertyListedBy.value,
           isFrom: 'filterScreen',
           city_name:filterController.initialCityName.value,
           bhk_type:filterController.selectedBHKTypeList.join(","),
           max_area:filterController.areatMax.toString()=='0.0'?'':filterController.areatMax.toString(),
           min_area: filterController.areaMin.toString()=='0.0'?'':filterController.areaMin.toString(),
           max_price:filterController.budgetMax1.value!=""?"${filterController.budgetMax.value.toString()}00000":
           filterController.budgetMax1.value.toString(),
           min_price:filterController.budgetMin1.value.toString() ,
           furnish_status:filterController.selectedFurnishingStatusList.join(","),
           property_type:   filterController.selectedPropertyType.join(","),
           sort_by:  postController.sortBY.value,
           page: nextPage,


         );

         setState(() {
           filterController.getMarkers(filterController.getFilterData).then((loadedMarkers) {
             setState(() {
               filterController.markers = loadedMarkers;
             });
           });
         });
       }
    }else{

       if (searchControllerField.text.isNotEmpty) {
         await filterController.searchLocation(
           search_query: searchControllerField.text,
           page: nextPage,
           city: cityName,
           search_area: areaName != '' ? areaName : cityName,
         );
         setState(() {
           filterController.getMarkers(filterController.getFilterData).then((loadedMarkers) {
             setState(() {
               filterController.markers = loadedMarkers;
             });
           });
         });
       }
       else {
         await filterController.getFilterProperty(
           property_category_type: filterController.initialPropertyCategoryType.value,
           category_price_type: filterController.initialCategoryPriceType.value,
           property_listed_by: filterController.initialPropertyListedBy.value,
           isFrom: 'filterScreen',
           city_name:filterController.initialIsFrom.value == "popularCity" ?  filterController.initialCityName.value :"",
           bhk_type:filterController.selectedBHKTypeList.join(","),
           max_area:filterController.areatMax.toString()=='0.0'?'':filterController.areatMax.toString(),
           min_area: filterController.areaMin.toString()=='0.0'?'':filterController.areaMin.toString(),
           max_price:filterController.budgetMax1.value!=""?"${filterController.budgetMax.value.toString()}00000":
           filterController.budgetMax1.value.toString(),
           min_price:filterController.budgetMin1.value.toString() ,
           furnish_status:filterController.selectedFurnishingStatusList.join(","),
           // property_type:filterController.initialIsFrom.value == 'searchScreen' ?filterController.initialPropertyType.value : filterController.initialPropertyType.value,
           property_type:filterController.initialIsFrom.value == 'searchScreen' ? filterController.selectedPropertyType.isEmpty? filterController.initialPropertyType.value:filterController.selectedPropertyType.join(",") : filterController.selectedPropertyType.join(","),

           sort_by:  postController.sortBY.value,
           page: nextPage,


         );

         setState(() {
           filterController.getMarkers(filterController.getFilterData).then((loadedMarkers) {
             setState(() {
               filterController.markers = loadedMarkers;
             });
           });
         });
       }
    }

   }



  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child:
          TextField(
            focusNode: _focusNode,
            controller: searchControllerField,
            onSubmitted: (value) {
              onSearchChanged();
            },

            decoration: InputDecoration(
              hintText: "Search...",
              hintStyle: const TextStyle(
                  color: Colors.grey, fontWeight: FontWeight.normal),
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
        actions: [
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
                  // widget.isFrom == 'FilterSearch' ?
                  // Get.back() :
                  Get.to( FilterSearchScreen(
                    searchQuery: searchControllerField.text != '' ? searchControllerField.text : widget.searchKeyword ?? '',isfrom: widget.isFrom,
                    isfrompage: '',city: cityName ?? postController.city,area: areaName != '' ? areaName : cityName,
                    property_listed_by: widget.property_listed_by,
                    property_type: widget.property_type,));
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
                    // GestureDetector(
                    //   onTap: () {
                    //      postController.Ismap.value= !postController.Ismap.value;
                    //   },
                    //   child: Container(
                    //     height: MediaQuery.of(context).size.height * 0.05,
                    //     width: MediaQuery.of(context).size.width * 0.38,
                    //     decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(30),
                    //       border: Border.all(
                    //         width: 1,
                    //         color: const Color(0xFF813BEA),
                    //       ),
                    //       color: const Color(0xFF813BEA),
                    //     ),
                    //     padding: const EdgeInsets.all(8),
                    //     child: Row(
                    //       crossAxisAlignment: CrossAxisAlignment.center,
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: [
                    //         Image.asset(
                    //           "assets/image_rent/mapView.png",
                    //           width: 24,
                    //           height: 24,
                    //           color: Colors.white,
                    //         ),
                    //         const SizedBox(width: 5),
                    //         const Text(
                    //           "Map View",
                    //           style: TextStyle(color: Colors.white, fontSize: 13),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    GestureDetector(
                      onTap: () {
                        postController.Ismap.value= !postController.Ismap.value;
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


              filterController.getFilterData.isNotEmpty
                  ?
              postController.Ismap.value?
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
                        target: LatLng(filterController.latitude.value, filterController.longitude.value),
                        zoom: 13.50,
                      ),
                      mapType: MapType.normal,
                      myLocationEnabled: true,
                      zoomControlsEnabled: true,
                      myLocationButtonEnabled: true,
                      onTap: (LatLng latLng) {
                        // Handle map tap if necessary
                      },
                      markers: filterController.markers, // Show the markers on the map
                    ),
                  ),


                   Positioned(
                    bottom: -90,
                    child: ResultUi(
                      data: filterController.getFilterData,
                      onLoadMore: () async {
                        await loadMoreData(); // 👈 your parent pagination logic
                      },
                    ),
                  )


                ],
              ):
              Expanded(
                child: Obx(() {
                  if (filterController.getFilterData.isEmpty && filterController.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return RefreshIndicator(
                      onRefresh: () async {
                        filterController.getFilterProperty(
                            property_category_type: widget.property_category_type,
                            category_price_type:widget.category_price_type,
                            property_listed_by: widget.property_listed_by,
                            city_name: widget.city_name,isFrom: 'filterScreen',
                            bhk_type:widget.bhk_type,
                            max_area:widget.max_area,
                            min_area: widget.min_area,
                            min_price:widget.min_price,
                            max_price:widget.max_price,
                            furnish_status:widget.furnish_status,
                            property_type:widget.property_type,
                            page: '1'
                        );
                      },
                      child:LazyLoadScrollView(
                        onEndOfPage: () {
                          if (filterController.hasMore.value && !filterController.isPaginationLoading.value) {
                            loadMoreData(); // Your existing method
                          }else{
                            print("LazyLoadScrollView==>");
                            print(filterController.hasMore.value);
                            print(filterController.isPaginationLoading.value);
                          }
                        },
                        isLoading: filterController.isPaginationLoading.value,
                        child: Obx(()=>
                         ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            controller: scrollControllerForFilterList,
                            itemCount: filterController.getFilterData.length + (filterController.isPaginationLoading.value ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == filterController.getFilterData.length) {
                                return const Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Center(child: CircularProgressIndicator()),
                                );
                              }

                              return propertyCard( property_data:filterController.getFilterData[index], index: index, propertyList: filterController.getFilterData,);
                            },
                          ),

                        ),
                      )

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
                      setState(() {
                        searchControllerField.clear();
                      });
                      print("postController.sortBY.value11=>${postController.sortBY.value}");
                 //     postController.getMySearchProperty().then((value) => Get.back());
                      filterController.getFilterProperty(
                          property_category_type: widget.property_category_type,
                          category_price_type:widget.category_price_type,
                          property_listed_by: widget.property_listed_by,
                          city_name: widget.isFrom == "popularCity" ?  widget.city_name :cityName,
                          searchKeyword: widget.searchKeyword,area: widget.area,
                          isFrom: 'filterScreen',
                          bhk_type:widget.bhk_type,
                          max_area:widget.max_area,
                          min_area: widget.min_area,
                          min_price:widget.min_price,
                          max_price:widget.max_price,
                          furnish_status:widget.furnish_status,
                          property_type:widget.property_type,
                          sort_by:  postController.sortBY.value,
                          page: '1'
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


  String getImageUrl(int index) {
    if (widget.isFrom == 'project' ||
        widget.isFrom == 'featured' ||
        widget.isFrom == 'offer' ||
        widget.isFrom == 'profile' ||
        widget.isFrom == 'searchScreen' ||
        widget.isFrom == 'FilterSearch' ||
        widget.isFrom == 'recommended') {
      return filterController.getFilterData[index]['cover_image'];
    } else {
      return APIString.imageBaseUrl + filterController.getFilterData[index]['cover_image'];
    }
  }
}
