import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
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

class MapFilterListScreen extends StatefulWidget {
  final String isFrom;

  final String property_category_type;
  final String category_price_type;
  final String property_listed_by;
  final String city_name;
  final String bhk_type;
  final String max_area;
  final String min_area;
  final String min_price;
  final String max_price;
  final String amenties;
  final String furnish_status;
  final String property_type;
  String? searchKeyword;
  String? area;


  MapFilterListScreen({
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
  State<MapFilterListScreen> createState() => _MapFilterListScreenState();
}


class _MapFilterListScreenState extends State<MapFilterListScreen> {
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
  final Completer<GoogleMapController> _controller = Completer();
  Set<Marker> markers = {};
  final FocusNode _focusNode = FocusNode();
  TextEditingController searchControllerField = TextEditingController();
  String areaName = '';
  String cityName = '';
  final scrollControllerForFilterList = ScrollController();
  @override
  void initState() {
    super.initState();
    print('is from :${widget.isFrom}');
    print('city :${widget.city_name}');
    print('area :${widget.area}');
    print('search query :${widget.searchKeyword}');
    if(widget.isFrom == 'popularCity'){
      searchControllerField.clear();
    }
    setCity();
    postController.Ismap.value= false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      search_controller.getsessionData();
      // getClear();
      filterController.getFilterProperty(
          property_category_type: widget.property_category_type,
          category_price_type:widget.category_price_type,
          property_listed_by: widget.property_listed_by,
          city_name: "",
          searchKeyword: "",
          area: widget.area,
          isFrom: 'filterScreen',
          bhk_type:widget.bhk_type,
          max_area:widget.max_area,
          min_area: widget.min_area,
          min_price:widget.min_price,
          max_price:widget.max_price,
          furnish_status:widget.furnish_status,
          property_type:widget.property_type,
          page: '1'
      );
    });
    getMarkers().then((loadedMarkers) {
      setState(() {
        markers = loadedMarkers;
      });
    });
    scrollControllerForFilterList.addListener(() {
      if (filterController.scrollControllerForFilterList.position.pixels >=
          scrollControllerForFilterList.position.maxScrollExtent - 100 &&
          !filterController.isPaginationLoading.value &&
          filterController.hasMore.value) {
        loadMoreData();
      }
    });
  }

  // @override
  // void dispose() {
  //  scrollControllerForFilterList?.dispose();
  //   super.dispose();
  // }
  void setCity() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        cityName = widget.city_name;
        areaName = widget.area != null && widget.area!.isNotEmpty ? widget.area! : widget.city_name;
        filterController.city.value = cityName;
        filterController.area.value = areaName;
        print('Initialized - cityName: $cityName, areaName: $areaName');
      });
    });
  }

  getClear()  {
    filterController.ClearData();
    filterController.selectedFurnishingStatusList.clear();
    filterController.isClear.value =true;

    // pController.profileController.myListingPrperties.clear();
    // pController.getCommonPropertyList.clear();
    // controller.budgetMin.value = 5;
    // controller.budgetMax.value = 10;
    filterController.budgetMin.value = null;
    filterController.budgetMax.value = null;

    filterController.budgetMin1.value = "";
    filterController.budgetMax1.value = "";

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
  // Future<void> loadMoreData() async {
  //   print("loadMoreData==> filterListScreen.dart");
  //   if (filterController.hasMore.value && !filterController.isPaginationLoading.value) {
  //     filterController.isPaginationLoading.value = true;
  //
  //     final nextPage = (filterController.currentPage.value + 1).toString();
  //     print('loadMoreData - searchQuery: ${searchControllerField.text}');
  //     print('loadMoreData - city: ${cityName}, area: ${areaName}');
  //
  //     if (searchControllerField.text.isNotEmpty) {
  //       await filterController.searchLocation(
  //         search_query: searchControllerField.text,
  //         page: nextPage,
  //         city: cityName,
  //         search_area: areaName != '' ? areaName : cityName,
  //       );
  //       if (mounted) {
  //         final loadedMarkers = await filterController.getMarkers(filterController.getFilterData);
  //         filterController.markers = loadedMarkers; // Update reactive state
  //       }
  //     } else {
  //       await filterController.getFilterProperty(
  //         property_category_type: filterController.initialPropertyCategoryType.value,
  //         category_price_type: filterController.initialCategoryPriceType.value,
  //         property_listed_by: filterController.initialPropertyListedBy.value,
  //         isFrom: 'filterScreen',
  //         city_name: filterController.initialIsFrom.value == "popularCity" ? filterController.initialCityName.value : "",
  //         bhk_type: filterController.selectedBHKTypeList.join(","),
  //         max_area: filterController.areatMax.toString() == '0.0' ? '' : filterController.areatMax.toString(),
  //         min_area: filterController.areaMin.toString() == '0.0' ? '' : filterController.areaMin.toString(),
  //         max_price: filterController.budgetMax1.value != "" ? "${filterController.budgetMax.value.toString()}00000" : filterController.budgetMax1.value.toString(),
  //         min_price: filterController.budgetMin1.value.toString(),
  //         furnish_status: filterController.selectedFurnishingStatusList.join(","),
  //         property_type: filterController.initialIsFrom.value == 'searchScreen' ? filterController.selectedPropertyType.join(",") : filterController.selectedPropertyType.join(","),
  //         sort_by: postController.sortBY.value,
  //         page: nextPage,
  //       );
  //       if (mounted) {
  //         final loadedMarkers = await filterController.getMarkers(filterController.getFilterData);
  //         filterController.markers = loadedMarkers; // Update reactive state
  //       }
  //     }
  //
  //     filterController.isPaginationLoading.value = false;
  //   }
  // }

  void loadMoreData() {
    if (filterController.hasMore.value && !filterController.isPaginationLoading.value) {
      filterController.isPaginationLoading.value = true;

      final nextPage = (filterController.currentPage.value + 1).toString();
      print('loadMoreData - searchQuery: ${searchControllerField.text}');
      print('loadMoreData - city: ${cityName}, area: ${areaName}');


      if ( searchControllerField.text.isNotEmpty && searchControllerField.text != null) {
        filterController.searchLocation(
          search_query: searchControllerField.text,
          page: nextPage,
          // city: cityName,
          search_area: widget.area,
        ).then((value) {
          setState(() {
            getMarkers().then((loadedMarkers) {
              setState(() {
                markers = loadedMarkers;
              });
            });
          });
          filterController.isPaginationLoading.value = false;
        });
      } else {
        filterController.getFilterProperty(
          property_category_type: widget.property_category_type,
          category_price_type: widget.category_price_type,
          property_listed_by: widget.property_listed_by,
          isFrom: 'filterScreen',
          city_name: "",
          searchKeyword: "",
          area: widget.area,
          bhk_type: widget.bhk_type,
          max_area: widget.max_area,
          min_area: widget.min_area,
          min_price: widget.min_price,
          max_price: widget.max_price,
          furnish_status: widget.furnish_status,
          property_type: widget.property_type,
          page: nextPage,
        ).then((value) {
          setState(() {
            getMarkers().then((loadedMarkers) {
              setState(() {
                markers = loadedMarkers;
              });
            });
          });
          filterController.isPaginationLoading.value = false;
        });
      }
    }
  }


  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  Future<Set<Marker>> getMarkers() async {
    Set<Marker> markers = {};

    final List<dynamic> filterDataCopy = List.from(filterController.getFilterData);

    for (var user in filterDataCopy) {
      double lat = double.tryParse(user['latitude'].toString()) ?? 0.0;
      double lng = double.tryParse(user['longitude'].toString()) ?? 0.0;

      if (lat == 0.0 && lng == 0.0) continue;

      print('Property ID: ${user['_id']} - Latitude: $lat, Longitude: $lng');

      final Uint8List markerIcon = await getBytesFromAsset('assets/properties.png', 100);

      markers.add(Marker(
        markerId: MarkerId(user['_id'].toString()),
        position: LatLng(lat, lng),
        // infoWindow: InfoWindow(
        //   title: '₹${user['property_price']}',
        // ),
        infoWindow: InfoWindow(

          // title: '₹${user['property_price']}',
          title:   user['property_category_type']=="Rent"?
          ' ${postController.formatIndianPrice(user['rent'].toString())}/ Month':
          postController.formatIndianPrice( user['property_price'].toString()),
          snippet: '${user['property_name']}',
        ),
        icon: BitmapDescriptor.fromBytes(markerIcon),
      ));
    }

    return markers;
  }


  void onSearchChanged() {
    filterController.currentPage.value = 1;
    filterController.hasMore.value = true;
    print('onSearchChanged - searchQuery: ${searchControllerField.text}');
    print('onSearchChanged - city: ${cityName}, area: ${areaName}');

    if (searchControllerField.text.trim().isEmpty) {
      filterController.getFilterProperty(
        isFrom: 'filterScreen',
        searchKeyword: widget.searchKeyword ?? '',
        area: areaName != '' ? areaName : cityName,
        property_category_type: widget.property_category_type,
        category_price_type: widget.category_price_type,
        property_listed_by: widget.property_listed_by,
        city_name: cityName,
        bhk_type: widget.bhk_type,
        max_area: widget.max_area,
        min_area: widget.min_area,
        min_price: widget.min_price,
        max_price: widget.max_price,
        furnish_status: widget.furnish_status,
        property_type: widget.property_type,
        page: '1',
      );
    } else {
      filterController.searchLocation(
        search_query: searchControllerField.text.trim(),
        city: cityName,
        // search_area: areaName != '' ? areaName : cityName,
      );
    }
    setState(() {
      getMarkers().then((loadedMarkers) {
        setState(() {
          _focusNode.unfocus();
          markers = loadedMarkers;
        });
      });
    });
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
          // SizedBox(
          //   height: 50,
          //   child: TextField(
          //     controller: searchControllerField,
          //     focusNode: _focusNode,
          //     onChanged: (value) {
          //       onSearchChanged();
          //     },
          //     decoration: InputDecoration(
          //       hintText: "Search",
          //       hintStyle: const TextStyle(
          //         color: Colors.grey,
          //         fontWeight: FontWeight.normal,
          //       ),
          //       prefixIcon: const Icon(Icons.search, size: 25),
          //       suffixIcon: IconButton(
          //         icon: const Icon(Icons.cancel, size: 18),
          //         onPressed: () {
          //           searchControllerField.clear();
          //           onSearchChanged();
          //         },
          //       ),
          //       border: InputBorder.none,
          //       filled: true,
          //       fillColor: Colors.white,
          //       contentPadding: const EdgeInsets.symmetric(
          //         vertical: 12.0,
          //         horizontal: 16.0,
          //       ),
          //     ),
          //   ),
          // ),

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
          // SizedBox(
          //   height: 50,
          //   child: GooglePlaceAutoCompleteTextField(
          //     textEditingController: searchControllerField,
          //     focusNode: _focusNode,
          //     googleAPIKey: 'AIzaSyDY-oB0QysTXFJu2cOMlZvpwANBR2XS84E',
          //     debounceTime: 800,
          //     countries: ["in"],
          //     inputDecoration: InputDecoration(
          //       hintText: "Search",
          //       hintStyle: const TextStyle(
          //         color: Colors.grey,
          //         fontWeight: FontWeight.normal,
          //       ),
          //       prefixIcon: const Icon(Icons.search, size: 25),
          //       suffixIcon: IconButton(
          //         icon: const Icon(Icons.cancel, size: 18),
          //         onPressed: () {
          //           searchControllerField.clear();
          //           onSearchChanged();
          //         },
          //       ),
          //       border: InputBorder.none,
          //       filled: true,
          //       fillColor: Colors.white,
          //       contentPadding: const EdgeInsets.symmetric(
          //         vertical: 12.0,
          //         horizontal: 16.0,
          //       ),
          //     ),
          //     formSubmitCallback: () {
          //
          //       onSearchChanged();
          //     },
          //     isCrossBtnShown: false,
          //     itemClick: (prediction) {
          //       // Update the controller with the selected place
          //       searchControllerField.text = prediction.description ?? '';
          //
          //       searchControllerField.selection = TextSelection.fromPosition(
          //         TextPosition(offset: prediction.description?.length ?? 0),
          //       );
          //       // Force a rebuild to ensure the text is visible
          //       setState(() {
          //       }); // If using StatefulWidget
          //     },
          //     getPlaceDetailWithLatLng: (prediction) async {
          //       if (prediction != null) {
          //         final location = prediction.description;
          //         print("Selected place: $location");
          //
          //         try {
          //           final String googleApiKey = 'AIzaSyDY-oB0QysTXFJu2cOMlZvpwANBR2XS84E';
          //           final String placeId = prediction.placeId!;
          //           final String placeDetailsUrl =
          //               'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=address_components&key=$googleApiKey';
          //
          //           final response = await http.get(Uri.parse(placeDetailsUrl));
          //           if (response.statusCode == 200) {
          //             final data = json.decode(response.body);
          //             if (data['status'] == 'OK') {
          //               final addressComponents = data['result']['address_components'] as List<dynamic>;
          //               String? cityNamee;
          //               String? areaNamee;
          //
          //               for (var component in addressComponents) {
          //                 final types = component['types'] as List<dynamic>;
          //                 if (types.contains('locality')) {
          //                   cityNamee = component['long_name'];
          //                 } else if (types.contains('administrative_area_level_2')) {
          //                   cityNamee ??= component['long_name'].split(' ').first;
          //                 }
          //                 if (types.contains('sublocality') ||
          //                     types.contains('sublocality_level_1') ||
          //                     types.contains('neighborhood')) {
          //                   areaNamee = component['long_name'];
          //                 }
          //               }
          //
          //               if (cityNamee != null) {
          //                 print("City name: $cityNamee");
          //                 print("Area name: ${areaNamee ?? 'Not found'}");
          //
          //                 setState(() {
          //                   cityName = cityNamee ?? '';
          //                   areaName = areaNamee ?? cityNamee ?? '';
          //                   print('Updated - cityName: $cityName, areaName: $areaName');
          //                 });
          //                 onSearchChanged();
          //               } else {
          //                 print("City name not found in address components");
          //               }
          //             } else {
          //               print("Place details API error: ${data['status']}");
          //             }
          //           } else {
          //             print("HTTP error: ${response.statusCode}");
          //           }
          //         } catch (e) {
          //           print("Error fetching place details: $e");
          //         }
          //       }
          //     },
          //
          //   ),
          // ),
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
                //   Ismap= !Ismap;
                // });
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
                  Get.back();
                  // Get.to( FilterSearchScreen(
                  //   searchQuery: searchControllerField.text != '' ? searchControllerField.text : widget.searchKeyword ?? '',isfrom: widget.isFrom,
                  //   isfrompage: '',city: cityName ?? postController.city,area: areaName != '' ? areaName : cityName,
                  //   property_listed_by: widget.property_listed_by,property_type: widget.property_type,));
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
                            markers: markers, // Show the markers on the map
                          ),
                        ),

                        Positioned(
                          bottom: -90,
                          child: ResultUi(
                            data: filterController.getFilterData,
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
                                    controller:scrollControllerForFilterList,
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

  // _showFilterBottomSheet(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     backgroundColor: Colors.white,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //     ),
  //     isScrollControlled: true,
  //     builder: (context) {
  //       return SizedBox(
  //         height: MediaQuery.of(context).size.width * 0.98,
  //         width: MediaQuery.of(context).size.width,
  //         child: Padding(
  //           padding: EdgeInsets.only(
  //             left: 16.0,
  //             right: 16.0,
  //             bottom: MediaQuery.of(context).viewInsets.bottom,
  //             top: 20,
  //           ),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   Padding(
  //                     padding: const EdgeInsets.only(left: 5.0),
  //                     child: Container(
  //                       decoration: BoxDecoration(
  //                         shape: BoxShape.circle,
  //                         border: Border.all(
  //                           color: Colors.black,
  //                           width: 0.1,
  //                         ),
  //                       ),
  //                       child: InkWell(
  //                         onTap: () {
  //                           Get.back();
  //                         },
  //                         borderRadius: BorderRadius.circular(50),
  //                         child: const Padding(
  //                           padding: EdgeInsets.all(6),
  //                           child: Icon(
  //                             Icons.arrow_back_outlined,
  //                             size: 18,
  //                             color: Colors.black,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                   const Expanded(
  //                     child: Center(
  //                       child: Text(
  //                         "Sort By",
  //                         style: TextStyle(
  //                           fontWeight: FontWeight.bold,
  //                           fontSize: 20,
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                   const SizedBox(width: 40),
  //                 ],
  //               ),
  //               boxH20(),
  //               Obx(() => Row(
  //                 children: [
  //                   Radio(
  //                     value: "oldest",
  //                     groupValue: selectedValue.value,
  //                     onChanged: onChange,
  //                   ),
  //                   const Text(
  //                     "Oldest",
  //                     style: TextStyle(
  //                       fontWeight: FontWeight.bold,
  //                       fontSize: 17,
  //                     ),
  //                   ),
  //                 ],
  //               )),
  //               Obx(() => Row(
  //                 children: [
  //                   Radio(
  //                     value: "lowToHigh",
  //                     groupValue: selectedValue.value,
  //                     onChanged: onChange,
  //                   ),
  //                   const Text(
  //                     "Price low to high",
  //                     style: TextStyle(
  //                       fontWeight: FontWeight.bold,
  //                       fontSize: 17,
  //                     ),
  //                   ),
  //                 ],
  //               )),
  //               Obx(() => Row(
  //                 children: [
  //                   Radio(
  //                     value: "highToLow",
  //                     groupValue: selectedValue.value,
  //                     onChanged: onChange,
  //                   ),
  //                   const Text(
  //                     "Price high to low",
  //                     style: TextStyle(
  //                       fontWeight: FontWeight.bold,
  //                       fontSize: 17,
  //                     ),
  //                   ),
  //                 ],
  //               )),
  //               Obx(() => Row(
  //                 children: [
  //                   Radio(
  //                     value: "newest",
  //                     groupValue: selectedValue.value,
  //                     onChanged: onChange,
  //                   ),
  //                   const Text(
  //                     "Newest",
  //                     style: TextStyle(
  //                       fontWeight: FontWeight.bold,
  //                       fontSize: 17,
  //                     ),
  //                   ),
  //                 ],
  //               )),
  //               const Spacer(),
  //               commonButton(
  //                 width: MediaQuery.of(context).size.width * 0.9,
  //                 height: 50,
  //                 buttonColor: const Color(0xFF813BEA),
  //                 text: 'Sort',
  //                 textStyle: const TextStyle(fontSize: 14, color: Colors.white),
  //                 onPressed: () {
  //                   _sortDataBySelectedOption();
  //                   Get.back();
  //                 },
  //               ),
  //               boxH20(),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }


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
                          postController.sortBY.value = value!; // Update controller.sortBY.value
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

  void _sortDataBySelectedOption() {
    // Create a copy of the list to sort
    List<Map<String, dynamic>> sortedData = List.from(filterController.getFilterData);

    if (selectedValue.value == "lowToHigh") {
      sortedData.sort((a, b) {
        double priceA = double.tryParse(a['property_price']?.toString() ?? '0') ?? 0.0;
        double priceB = double.tryParse(b['property_price']?.toString() ?? '0') ?? 0.0;
        print('Low to High - Price A: $priceA, Price B: $priceB'); // Debug
        return priceA.compareTo(priceB); // Ascending order
      });
    } else if (selectedValue.value == "highToLow") {
      sortedData.sort((a, b) {
        double priceA = double.tryParse(a['property_price']?.toString() ?? '0') ?? 0.0;
        double priceB = double.tryParse(b['property_price']?.toString() ?? '0') ?? 0.0;
        print('High to Low - Price A: $priceA, Price B: $priceB'); // Debug
        return priceB.compareTo(priceA); // Descending order
      });
    } else if (selectedValue.value == "newest") {
      sortedData.sort((a, b) {
        DateTime dateA = DateTime.tryParse(a['property_added_date']?.toString() ?? '') ??
            DateTime(1970);
        DateTime dateB = DateTime.tryParse(b['property_added_date']?.toString() ?? '') ??
            DateTime(1970);
        print('Newest - Date A: $dateA, Date B: $dateB'); // Debug
        return dateB.compareTo(dateA); // Newest first
      });
    } else if (selectedValue.value == "oldest") {
      sortedData.sort((a, b) {
        DateTime dateA = DateTime.tryParse(a['property_added_date']?.toString() ?? '') ??
            DateTime(1970);
        DateTime dateB = DateTime.tryParse(b['property_added_date']?.toString() ?? '') ??
            DateTime(1970);
        print('Oldest - Date A: $dateA, Date B: $dateB'); // Debug
        return dateA.compareTo(dateB); // Oldest first
      });
    }

    // Update the reactive list
    if (filterController.getFilterData is RxList) {
      filterController.getFilterData.assignAll(sortedData);
    } else {
      filterController.getFilterData.value = sortedData;
      // If not using RxList, trigger UI update
      setState(() {});
    }
  }

  // Handle the radio button value change
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
