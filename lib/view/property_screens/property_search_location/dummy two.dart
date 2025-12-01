import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:developer';

import 'dart:io';
import 'dart:math' as Math;
import 'dart:math';
import 'dart:typed_data';

import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as MapsTookit;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:real_estate_app/Routes/app_pages.dart';
import 'package:real_estate_app/common_widgets/dialog_util.dart';
import 'package:real_estate_app/common_widgets/height.dart';
import 'package:real_estate_app/global/api_string.dart';
import 'package:real_estate_app/global/app_color.dart';
import 'package:http/http.dart' as http;
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/CustomBottomNavBar.dart';
import 'package:real_estate_app/view/filter_search/view/FilterSearchController.dart';
import 'package:real_estate_app/view/filter_search/view/filter_search_screen.dart';
import 'package:real_estate_app/view/map/map_screen.dart';
import 'package:real_estate_app/view/map/result_ui/map_ResultUI.dart';
import 'package:real_estate_app/view/map/result_ui/result_ui_screen.dart';
import 'package:real_estate_app/view/property_screens/properties_controllers/post_property_controller.dart';
import 'package:real_estate_app/view/property_screens/property_search_location/expandableBottomSheet.dart';
import 'package:uuid/uuid.dart';

import '../../../common_widgets/loading_dart.dart';
import '../../../utils/network_http.dart';
import '../../filter_search/view/map_filter_screen.dart';

class PropertySearchLocationScreen extends StatefulWidget {
  final data;
  final latitude;
  final longitude;
  const PropertySearchLocationScreen({
    Key? key,
    required this.data,
    required this.latitude,
    required this.longitude,
  }) : super(key: key);

  @override
  State<PropertySearchLocationScreen> createState() => _PropertySearchLocationScreenState();
}

class _PropertySearchLocationScreenState extends State<PropertySearchLocationScreen> {
  final List<Map<String, dynamic>> categoryType1 = [
    {'title': 'Buy', 'icon': 'assets/buy-home.png'},
    {'title': 'Rent', 'icon': 'assets/rent_house.png'},
    {'title': 'PG', 'icon': 'assets/plot_icon.png'},
    {'title': 'Commercial', 'icon': 'assets/commerical_icon.png'},
  ];
  String propert_type = "";
  int _selectedCategoryIndex = -1;

  final FocusNode _focusNode = FocusNode();
  final TextEditingController _Controller = TextEditingController();
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController? _mapController;
  String city = '';
  bool isSearching = false;
  var uuid = const Uuid();
  String _sessionToken = '1234567890';
  List<dynamic> _placeList = [];

  final PostPropertyController pController = Get.find();
  final FilterSearchController controller = Get.find();
  List<String> latitudeList = [];
  List<String> longitudeList = [];
  Set<Polygon> _polygons = HashSet<Polygon>();
  Set<Polyline> _polyLines = HashSet<Polyline>();
  bool _drawPolygonEnabled = false;
  List<LatLng> _userPolyLinesLatLngList = [];
  bool _clearDrawing = false;
  int? _lastXCoordinate;
  int? _lastYCoordinate;
  double _currentSliderValue = 10;
  bool isMapReady = false;
  bool isZoom = true;

  @override
  void initState() {
    super.initState();
    _Controller.addListener(_onChanged);
    pController.bhkTypes.assignAll([
      "Studio", "1 RK", "1 BHK", "1.5 BHK", "2 BHK", "2.5 BHK",
      "3 BHK", "3.5 BHK", "4 BHK", "5 BHK", "6 BHK",
    ]);
  }

  @override
  void dispose() {
    _Controller.removeListener(_onChanged);
    _Controller.dispose();
    _focusNode.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  void _onChanged() {
    if (_sessionToken.isEmpty) {
      setState(() {
        _sessionToken = uuid.v4();
      });
    }
    getSuggestion(_Controller.text);
  }

  void getSuggestion(String input) async {
    const String PLACES_API_KEY = "AIzaSyAt8bj4UACvakZfiSy-0c1o_ivfplm7jEU";
    String baseURL = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request = '$baseURL?input=$input&key=$PLACES_API_KEY&sessiontoken=$_sessionToken';

    try {
      var response = await http.get(Uri.parse(request));
      if (response.statusCode == 200 && mounted) {
        setState(() {
          _placeList = json.decode(response.body)['predictions'];
          isSearching = true;
        });
      } else {
        throw Exception('Failed to load predictions');
      }
    } catch (e) {
      print('Error fetching suggestions: $e');
    }
  }

  // Future<void> getLocationSearchData(List<String> latitudeList, List<String> longitudeList) async {
  //   await pController.getLocationSearchData(
  //     latitudeList.join(","),
  //     longitudeList.join(","),
  //     "1",
  //     "10",
  //     propert_type,
  //     widget.data == "Commercial" || widget.data == "Residential" || widget.data == "PG" ? "" : widget.data,
  //     widget.data == "PG" ? widget.data : "",
  //     controller.selectedBHKTypeList.join(","),
  //     city,
  //     reset: true,
  //   );
  //   await loadMarkers();
  // }
  Future<void> getLocationSearchData(List<String> latitudeList, List<String> longitudeList) async {
    final stopwatch = Stopwatch()..start();
    print('Starting API call: latitudeList=${latitudeList.length}, longitudeList=${longitudeList.length}');
    print('Payload: ${latitudeList.join(",")} | ${longitudeList.join(",")}');
    await pController.getLocationSearchData(
      latitudeList.join(","),
      longitudeList.join(","),
      "1",
      "10",
      propert_type,
      widget.data == "Commercial" || widget.data == "Residential" || widget.data == "PG" ? "" : widget.data,
      widget.data == "PG" ? widget.data : "",
      controller.selectedBHKTypeList.join(","),
      city,
      reset: true,
    );
    controller.getSearchList.clear();
    setState(() {
      controller.isLoadingMarkers.value = true;
      controller.markersReady.value = false;
    });

    try {
      var response = await HttpHandler.postHttpMethod(
        url: APIString.searchLocation,
        data: {
          'properties_latitude': latitudeList.join(","),
          'properties_longitude': longitudeList.join(","),
          'page': 1,
          'page_size': 1000,
          'property_category_type': propert_type,
          'category_price_type': widget.data == "Commercial" || widget.data == "Residential" || widget.data == "PG" ? "" : widget.data,
          'property_type': widget.data == "PG" ? widget.data : "",
          'bhk_type': controller.selectedBHKTypeList.join(","),
          'city_name': city,
          'user_id': "",
          'min_price': "",
          'max_price': "",
          'amenities': "",
        },
      ).timeout(const Duration(seconds: 10), onTimeout: () {
        throw TimeoutException('API call timed out after 10 seconds');
      });

      print('API call completed in ${stopwatch.elapsedMilliseconds}ms');
      print('Response status: ${response['body']['status']}');

      if (response['error'] == null && response['body']['status'].toString() == "1" && response['body']['data'] != null) {
        final data = response['body']['data'] ?? [];

        controller.getSearchList.value = data.where((property) {
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
        print('getSearchList size: ${controller.getSearchList.length}');
        await controller.updateMarkers();
        setState(() {
          controller.showresult.value = true;
          controller.isLoadingMarkers.value = false;
          controller.markersReady.value = true;
        });
        Fluttertoast.showToast(msg: 'Fetch successfully');
      } else {
        final errorMsg = response['body']['msg'] ?? response['error'] ?? 'Property not found';
        print('API error: $errorMsg');
        //Fluttertoast.showToast(msg: errorMsg);
        setState(() {
          controller.isLoadingMarkers.value = false;
          controller.markersReady.value = true;
        });
      }
    } catch (e, stackTrace) {
      print('API call error: $e');
      print('Stack trace: $stackTrace');
      //Fluttertoast.showToast(msg: 'Error fetching data: $e');
      setState(() {
        controller.isLoadingMarkers.value = false;
        controller.markersReady.value = true;
      });
    } finally {
      print('getLocationSearchData completed in ${stopwatch.elapsedMilliseconds}ms');
      if (mounted) {
        setState(() {
          controller.isLoadingMarkers.value = false;
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 4,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: SizedBox(
                            height: 55,
                            child: GooglePlaceAutoCompleteTextField(
                              textEditingController: _Controller,
                              focusNode: _focusNode,
                              googleAPIKey: 'AIzaSyAt8bj4UACvakZfiSy-0c1o_ivfplm7jEU',
                              inputDecoration: InputDecoration(
                                hintText: "Search by Project, Locality, Property Type",
                                prefixIcon: const Icon(Icons.search),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                hintStyle: TextStyle(color: Colors.grey[400]),
                                contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                              ),
                              debounceTime: 800,
                              countries: const ["in"],
                              isLatLngRequired: true,
                              getPlaceDetailWithLatLng: (prediction) async {
                                if (prediction != null) {
                                  city = prediction.structuredFormatting?.mainText ?? '';
                                  print("Selected place: $city");
                                  try {
                                    const String googleApiKey = 'AIzaSyAt8bj4UACvakZfiSy-0c1o_ivfplm7jEU';
                                    final String placeId = prediction.placeId!;
                                    final String placeDetailsUrl =
                                        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=geometry,address_components&key=$googleApiKey';

                                    final response = await http.get(Uri.parse(placeDetailsUrl));
                                    if (response.statusCode == 200) {
                                      final data = json.decode(response.body);
                                      if (data['status'] == 'OK') {
                                        final geometry = data['result']['geometry'];
                                        final location = geometry['location'];
                                        final double lat = location['lat'];
                                        final double lng = location['lng'];

                                        _mapController?.animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 13));

                                        final addressComponents = data['result']['address_components'] as List<dynamic>;
                                        String? areaName;
                                        for (var component in addressComponents) {
                                          final types = component['types'] as List<dynamic>;
                                          if (types.contains('locality')) {
                                            city = component['long_name'];
                                          } else if (types.contains('administrative_area_level_2')) {
                                            city = component['long_name'].split(' ').first;
                                          }
                                          if (types.contains('sublocality') ||
                                              types.contains('sublocality_level_1') ||
                                              types.contains('neighborhood')) {
                                            areaName = component['long_name'];
                                          }
                                        }

                                        print("City name: $city");
                                        print("Area name: ${areaName ?? 'Not found'}");

                                        latitudeList.clear();
                                        longitudeList.clear();
                                        latitudeList.add(lat.toStringAsFixed(4));
                                        longitudeList.add(lng.toStringAsFixed(4));

                                        setState(() {
                                          controller.showresult.value = true;
                                        });

                                        await getLocationSearchData(latitudeList, longitudeList);
                                      } else {
                                        print("Place details API error: ${data['status']}");
                                      }
                                    } else {
                                      print("HTTP error: ${response.statusCode}");
                                    }
                                  } catch (e) {
                                    print("Error fetching place details: $e");
                                  }
                                }
                              },
                              itemClick: (prediction) {
                                _Controller.text = prediction.description ?? '';
                                _Controller.selection = TextSelection.fromPosition(
                                  TextPosition(offset: prediction.description?.length ?? 0),
                                );
                                setState(() {
                                  isSearching = false;
                                  _placeList.clear();
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      customIconButton(
                        icon: Icons.filter_list,
                        iconSize: 30,
                        borderRadius: 9,
                        onTap: () {
                          Get.to(() => map_filter_screen(
                            isfrom: 'map search',
                            isfrompage: '',
                            searchQuery: _Controller.text,

                            city: city,
                            category_type: propert_type,
                          ));
                        },
                      ),
                      boxW02(),
                    ],
                  ),
                  boxH10(),
                  if (_Controller.text.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        boxH10(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: getCurrentLocation,
                            child: const Row(
                              children: [
                                Icon(Icons.location_searching_rounded, size: 18, color: Colors.black),
                                SizedBox(width: 5),
                                Text("Use my current location", style: TextStyle(fontSize: 15)),
                                Spacer(),
                                Icon(Icons.arrow_forward),
                                SizedBox(width: 10),
                              ],
                            ),
                          ),
                        ),
                        boxH10(),
                      ],
                    ),
                  Expanded(
                    child: Stack(
                      children: [
                        SizedBox(
                          width: Get.width,
                          height: Get.height * 0.8,
                          child: GestureDetector(
                            onPanUpdate: _drawPolygonEnabled ? _onPanUpdate : null,
                            onPanEnd: _drawPolygonEnabled ? _onPanEnd : null,
                            child:     GoogleMap(
                              onMapCreated: (GoogleMapController controller) {
                                _mapController = controller;
                                _controller.complete(controller);
                                setState(() {
                                  isMapReady = true;
                                });
                              },
                              trafficEnabled: false,
                              buildingsEnabled: false,
                              indoorViewEnabled: false,
                              liteModeEnabled: false,

                              tiltGesturesEnabled: false,
                              fortyFiveDegreeImageryEnabled: false,
                              compassEnabled: false,
                              mapToolbarEnabled: false,
                              initialCameraPosition: CameraPosition(
                                target: LatLng(widget.latitude!, widget.longitude!),
                                zoom: _currentSliderValue,
                              ),
                              mapType: MapType.normal,
                              polygons: _polygons,
                              polylines: _polyLines,
                              myLocationEnabled: true,
                              zoomControlsEnabled: true,
                              zoomGesturesEnabled: isZoom,
                              myLocationButtonEnabled: true,
                              onTap: (LatLng latLng) {
                                setState(() {
                                  controller.showresult.value = false;
                                });
                              },
                              markers: controller.markers,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(10),
                          alignment: Alignment.topRight,
                          child: FloatingActionButton(
                            onPressed: () {
                              _drawPolygonEnabled ? hideDrawing() : showDrawing();
                            },
                            tooltip: 'Drawing',
                            child: _drawPolygonEnabled
                                ? const Icon(Icons.cancel)
                                : Padding(
                              padding: const EdgeInsets.all(5),
                              child: Image.asset('assets/draw.png', height: 30, width: 30),
                            ),
                          ),
                        ),
                        Obx(() => controller.showresult.value
                            ? Positioned(
                          bottom: 45,
                          child: MapResultUi(
                            isAPIcall: true,
                            clear: true,
                            property_category_type: propert_type,
                            category_price_type: widget.data == "Commercial" || widget.data == "Residential" || widget.data == "PG" ? "" : widget.data,
                            property_type: widget.data == "PG" ? widget.data : "",
                            bhk_type: controller.selectedBHKTypeList.join(","),
                            city_name: city,
                            properties_latitude: latitudeList.join(","),
                            properties_longitude: longitudeList.join(","),
                          ),
                        )
                            : const SizedBox()),
                        // controller.showresult.value
                        //     ? ExpandableBottomSheet(
                        //   clear: true,
                        //   property_category_type: propert_type,
                        //   category_price_type: widget.data == "Commercial" || widget.data == "Residential" || widget.data == "PG" ? "" : widget.data,
                        //   property_type: widget.data == "PG" ? widget.data : "",
                        //   bhk_type: controller.selectedBHKTypeList.join(","),
                        //   city_name: city,
                        //   properties_latitude: latitudeList.join(","),
                        //   properties_longitude: longitudeList.join(","), )
                        //     : const SizedBox(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _Controller.text.isNotEmpty || _selectedCategoryIndex != -1
          ? Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _Controller.clear();
                  _selectedCategoryIndex = -1;
                  propert_type = "";
                  city = "";
                  latitudeList.clear();
                  longitudeList.clear();
                  pController.clearSearchData();
                  controller.showresult.value = false;
                  _drawPolygonEnabled = false;
                  isZoom = true;
                  controller.markersReady.value = false;
                  controller.markers.clear();
                });
                hideDrawing();
              },
              child: const Text(
                "Clear All",
                style: TextStyle(color: AppColor.primaryThemeColor, fontSize: 18),
              ),
            ),
            SizedBox(
              width: 150,
              height: 50,
              child: commonButton(
                text: "Search",
                onPressed: () {
                  getLocationSearchData(latitudeList, longitudeList);
                },
              ),
            ),
          ],
        ),
      )
          : null,
    );
  }



  AppBar appBar(BuildContext context) {
    return AppBar(
      toolbarHeight: 65,
      automaticallyImplyLeading: false,
      elevation: 0,
      scrolledUnderElevation: 0,
      flexibleSpace: Stack(
        children: [
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.only(top: 40.0, left: 0.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  customIconButton(
                    icon: Icons.arrow_back,
                    onTap: () => Navigator.pop(context),
                  ),
                  boxW15(),
                  Container(
                    height: Get.height * 0.09,
                    width: 300,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: categoryType1.length,
                        itemBuilder: (context, index) {
                          bool isSelected = _selectedCategoryIndex == index;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedCategoryIndex = index;
                                propert_type = categoryType1[index]['title'] == "Buy"
                                    ? "Buy"
                                    : categoryType1[index]['title'];
                                latitudeList.clear();
                                longitudeList.clear();
                                getLocationSearchData(latitudeList, longitudeList);
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 6.0),
                              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                              decoration: BoxDecoration(
                                color: isSelected ? AppColor.secondaryThemeColor : AppColor.white,
                                border: Border.all(
                                  color: isSelected ? AppColor.secondaryThemeColor : AppColor.white,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  categoryType1[index]['title'],
                                  style: TextStyle(
                                    color: isSelected ? AppColor.black : AppColor.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        latitudeList.clear();
        longitudeList.clear();
        latitudeList.add(position.latitude.toStringAsFixed(4));
        longitudeList.add(position.longitude.toStringAsFixed(4));
      });
      await getLocationSearchData(latitudeList, longitudeList);
    } else {
      print("Location permission denied");
    }
  }

  // Future<void> loadMarkers() async {
  //   setState(() => controller.markersReady.value = false);
  //   await controller.setMarkerIcons();
  //
  //   if (controller.getSearchList.isEmpty) {
  //     setState(() {
  //       controller.markers = {};
  //       controller.markersReady.value = true;
  //     });
  //     return;
  //   }
  //
  //   final propertyPolygon = controller.getSearchList.where((property) {
  //     final latStr = property['latitude']?.toString();
  //     final lngStr = property['longitude']?.toString();
  //     final lat = double.tryParse(latStr ?? '') ?? 0.0;
  //     final lng = double.tryParse(lngStr ?? '') ?? 0.0;
  //
  //     if (lat == 0.0 || lng == 0.0) {
  //       print('Invalid coordinates in loadMarkers for property ${property['_id'] ?? 'unknown'}: lat=$latStr, lng=$lngStr');
  //       return false;
  //     }
  //
  //     if (_userPolyLinesLatLngList.isEmpty) return true;
  //
  //     try {
  //       return MapsTookit.PolygonUtil.containsLocation(
  //         MapsTookit.LatLng(lat, lng),
  //         _userPolyLinesLatLngList.map((latLng) => MapsTookit.LatLng(latLng.latitude, latLng.longitude)).toList(),
  //         false,
  //       );
  //     } catch (e) {
  //       print('Polygon check error for property ${property['_id'] ?? 'unknown'}: $e');
  //       return false;
  //     }
  //   }).toList();
  //
  //   final newMarkers = propertyPolygon.map<Marker>((property) {
  //     final lat = double.tryParse(property['latitude']?.toString() ?? '') ?? 0.0;
  //     final lng = double.tryParse(property['longitude']?.toString() ?? '') ?? 0.0;
  //     return Marker(
  //       markerId: MarkerId(property['_id'] ?? 'marker_${property.hashCode}'),
  //       position: LatLng(lat, lng),
  //       infoWindow: InfoWindow(
  //         title: '₹${property['property_price'] ?? 'N/A'}',
  //         onTap: controller.onMarkerClicked,
  //       ),
  //       icon: controller.propertiesIcon,
  //     );
  //   }).toSet();
  //
  //   setState(() {
  //     controller.markers = newMarkers;
  //     controller.markersReady.value = true;
  //   });
  // }
  Future<void> loadMarkers() async {
    final stopwatch = Stopwatch()..start();
    print('Starting loadMarkers');

    setState(() {
      controller.isLoadingMarkers.value = true;
    });

    try {
      await controller.setMarkerIcons();

      if (controller.getSearchList.isEmpty) {
        print('No properties to display');
        setState(() {
          controller.markers = {};
          controller.isLoadingMarkers.value = false;
          controller.markersReady.value = true;
        });
        return;
      }

      final propertyPolygon = controller.getSearchList.where((property) {
        final latStr = property['latitude']?.toString();
        final lngStr = property['longitude']?.toString();
        final lat = double.tryParse(latStr ?? '') ?? 0.0;
        final lng = double.tryParse(lngStr ?? '') ?? 0.0;

        if (lat == 0.0 || lng == 0.0) {
          print('Invalid coordinates in loadMarkers for property ${property['_id'] ?? 'unknown'}: lat=$latStr, lng=$lngStr');
          return false;
        }

        if (_userPolyLinesLatLngList.isEmpty) return true;

        try {
          return MapsTookit.PolygonUtil.containsLocation(
            MapsTookit.LatLng(lat, lng),
            _userPolyLinesLatLngList
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

      final newMarkers = propertyPolygon.map<Marker>((property) {
        final lat = double.tryParse(property['latitude']?.toString() ?? '') ?? 0.0;
        final lng = double.tryParse(property['longitude']?.toString() ?? '') ?? 0.0;
        return Marker(
          markerId: MarkerId(property['_id'] ?? 'marker_${property.hashCode}'),
          position: LatLng(lat, lng),
          infoWindow: InfoWindow(
            title: '₹${property['property_price'] ?? 'N/A'}',
            onTap: controller.onMarkerClicked,
          ),
          icon: controller.propertiesIcon,
        );
      }).toSet();

      print('Marker creation completed in ${stopwatch.elapsedMilliseconds}ms');
      setState(() {
        controller.markers = newMarkers;
        controller.isLoadingMarkers.value = false;
        controller.markersReady.value = true;
      });
    } catch (e, stackTrace) {
      print('loadMarkers error: $e');
      print('Stack trace: $stackTrace');
      setState(() {
        controller.isLoadingMarkers.value = false;
        controller.markersReady.value = true;
      });
    }
  }
  void showDrawing() {
    _clearPolygons();
    setState(() {
      _drawPolygonEnabled = true;
      isZoom = false;
    });
  }

  void hideDrawing() {
    _clearPolygons();
    setState(() {
      _drawPolygonEnabled = false;
      controller.showresult.value = false;
      isZoom = true;
    });
  }

  void _clearPolygons() {
    setState(() {
      _polyLines.clear();
      _polygons.clear();
      _userPolyLinesLatLngList.clear();
    });
  }

  _onPanUpdate(DragUpdateDetails details) async {
    if (_clearDrawing) {
      _clearDrawing = false;
      _clearPolygons();
    }

    if (_drawPolygonEnabled) {
      double pixelRatio = MediaQuery.of(context).devicePixelRatio;

      double? x, y;
      if (Platform.isAndroid) {
        x = details.localPosition.dx * pixelRatio;
        y = details.localPosition.dy * pixelRatio;
      } else if (Platform.isIOS) {
        x = details.globalPosition.dx;
        y = details.globalPosition.dy;
      }

      int? xCoordinate = x?.round();
      int? yCoordinate = y?.round();

      if (_lastXCoordinate != null && _lastYCoordinate != null) {
        var distance = Math.sqrt(Math.pow(xCoordinate! - _lastXCoordinate!, 2) +
            Math.pow(yCoordinate! - _lastYCoordinate!, 2));

        if (distance > 80.0) return;
      }


      _lastXCoordinate = xCoordinate;
      _lastYCoordinate = yCoordinate;

      ScreenCoordinate screenCoordinate =
      ScreenCoordinate(x: xCoordinate!, y: yCoordinate!);

      final GoogleMapController controller = await _controller.future;
      LatLng latLng = await controller.getLatLng(screenCoordinate);

      try {
        // Add new point to list.
        _userPolyLinesLatLngList.add(latLng);

        _polyLines.removeWhere(
                (polyline) => polyline.polylineId.value == 'user_polyline');
        _polyLines.add(
          Polyline(
            polylineId: const PolylineId('user_polyline'),
            points: _userPolyLinesLatLngList,
            width: 2,
            color:AppColor.primaryThemeColor,
          ),
        );
      } catch (e) {
        print(" error painting $e");
      }
      setState(() {});
    }
  }

  void _onPanEnd(DragEndDetails details) async {
    _lastXCoordinate = null;
    _lastYCoordinate = null;

    if (_drawPolygonEnabled) {
      _polygons.removeWhere((polygon) => polygon.polygonId.value == 'user_polygon');
      _polygons.add(
        Polygon(
          polygonId: const PolygonId('user_polygon'),
          points: _userPolyLinesLatLngList,
          strokeWidth: 2,
          strokeColor: AppColor.primaryThemeColor,
          fillColor: AppColor.primaryThemeColor.withOpacity(0.2),
        ),
      );

      latitudeList.clear();
      longitudeList.clear();
      for (LatLng point in _userPolyLinesLatLngList) {
        latitudeList.add(point.latitude.toStringAsFixed(4));
        longitudeList.add(point.longitude.toStringAsFixed(4));
      }

      await getLocationSearchData(latitudeList, longitudeList);
      setState(() {
        _clearDrawing = true;
      });
    }
  }
}
