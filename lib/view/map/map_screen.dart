import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'dart:math' as Math;
import 'package:maps_toolkit/maps_toolkit.dart' as MapsTookit;
import 'package:http/http.dart' as http;
import 'package:real_estate_app/common_widgets/height.dart';
import 'package:real_estate_app/global/app_color.dart';

import 'package:real_estate_app/view/map/result_ui/result_ui_screen.dart';

import '../../global/api_string.dart';
import '../../utils/network_http.dart';
import '../filter_search/view/FilterSearchController.dart';
import '../filter_search/view/filter_search_screen.dart';
import 'package:uuid/uuid.dart';

import '../property_screens/properties_controllers/post_property_controller.dart';
class MapScreen extends StatefulWidget {
  final data;
  const MapScreen({super.key,required this.data});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  RxList getSearchList = [].obs;
  bool _isIconsSet = false;
  final FocusNode _focusNode = FocusNode();
  late String _searchText;
  late TextEditingController searchController;
  late Completer<GoogleMapController> _controller;
  late GoogleMapController _mapController;
  late PermissionStatus _permissionStatus;
  late Set<Polygon> _polygons;
  late Set<Polyline> _polyLines;
  late bool _drawPolygonEnabled;
  late List<LatLng> _userPolyLinesLatLngList;
  late bool _clearDrawing;
  late int? _lastXCoordinate;
  late int? _lastYCoordinate;
  late Set<Marker> markers;
  String city='';
  final PostPropertyController postController = Get.find();
  bool isSearching = false;
  FilterSearchController controller = Get.find();

  var uuid = const Uuid();
  String _sessionToken = '1234567890';
  List<dynamic> _placeList = [];
  int? _selectedIndex;
  TextEditingController _Controller = TextEditingController();

  final ScrollController scrollController = ScrollController();

  final Set<Marker> emptyMarkers = new Set();

  List<LatLng> drawnPolygonCoordinates = [];

  late double selected = 20.0;
  bool showresult = false;
  double _currentSliderValue = 30;


  late BitmapDescriptor propertiesIcon;

  double? latitude ;
  double? longitude;
  bool showMarkers = true;

  @override
  void dispose() {
    _Controller.removeListener(_onChanged);
    _Controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onChanged() {
    if (_sessionToken == null) {
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
      if (response.statusCode == 200) {
        if (mounted) {
          print('_placeList-->${_placeList.length}');

          setState(() {
            _placeList = json.decode(response.body)['predictions'];
            isSearching = true;
          });
        }
      } else {
        throw Exception('Failed to load predictions');
      }
    } catch (e) {
      print(e);
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("widget.data==jndc");
    print(widget.data);
    _controller = Completer();
    callLocation();
    _searchText = '';
    searchController = TextEditingController();
    _controller = Completer();
    _permissionStatus = PermissionStatus.denied;
    _polygons = HashSet<Polygon>();
    _polyLines = HashSet<Polyline>();
    _drawPolygonEnabled = false;
    _userPolyLinesLatLngList = [];
    _clearDrawing = false;
    _lastXCoordinate = null;
    _lastYCoordinate = null;
  // _Controller.addListener(_onChanged);
    markers = Set<Marker>();
  }

  @override
  Widget build(BuildContext context) {
    if (latitude == null || longitude == null) {
      return Center(child: CircularProgressIndicator());
    }
    return
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.only(bottom: 0),
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child:   SizedBox(
                      height: 50,
                      child: TextField(
                        focusNode: _focusNode,
                        controller: _Controller,
                        decoration: InputDecoration(
                          hintText: "Search locality, projects, landmark",
                          hintStyle: const TextStyle(color: Colors.grey,fontWeight: FontWeight.normal),
                          prefixIcon: const Icon(Icons.search,size: 25,),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.cancel,size: 18,),
                            onPressed: () {
                              setState(() {
                                _placeList.clear();
                                isSearching = false;
                                _Controller.clear();
                                _focusNode.unfocus();
                              });

                            },
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey, width: 0.8),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey, width: 0.8),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                        ),
                      ),
                    ),
                  ),
                ),

              ],
            ),

            boxH10(),

            // isSearching==true?
            // Expanded(
            //   child: ListView.builder(
            //     physics: NeverScrollableScrollPhysics(),
            //     shrinkWrap: true,
            //     itemCount: _placeList.length,
            //     itemBuilder: (context, index) {
            //       return GestureDetector(
            //         onTap: () async {
            //           setState(() {
            //             _selectedIndex = index;
            //           });
            //
            //           List<Location> loc = await locationFromAddress(_placeList[index]['description']);
            //           double lat = loc.last.latitude;
            //           double lng = loc.last.longitude;
            //
            //           List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
            //            city = placemarks.isNotEmpty ? placemarks[0].locality ?? '' : '';
            //
            //
            //           print("city===>");
            //           print(city);
            //           setState(() {
            //             _Controller.text=city;
            //             isSearching=false;
            //             _placeList.clear();
            //
            //           });
            //           // Get.to(FilterSearchScreen(data: city, isfrom: widget.data,));
            //         },
            //         child: ListTile(
            //           title: Text(_placeList[index]["description"]),
            //           tileColor: _selectedIndex == index ? AppColor.secondaryThemeColor.withOpacity(0.3) : Colors.white,
            //           textColor: _selectedIndex == index ? AppColor.secondaryThemeColor : Colors.black,
            //         ),
            //       );
            //
            //     },
            //   ),
            // ):SizedBox(),

            ///
            // SizedBox(
            //     height: 30,
            //     child: SliderTheme(
            //       data: SliderThemeData(
            //         trackHeight: 2,
            //       ),
            //       child: zoomSlider(),
            //     )),

            Expanded(
              child: Stack(
                children: <Widget>[
                  SizedBox(
                    height: 600,
                    child: GestureDetector(
                      onPanUpdate: (_drawPolygonEnabled) ? _onPanUpdate : null,
                      onPanEnd: (_drawPolygonEnabled) ? _onPanEnd : null,
                      child:
                      GoogleMap(

                          onMapCreated: (GoogleMapController controller) {
                            _mapController = controller;
                            _controller.complete(controller);
                          },
                          trafficEnabled: false,
                          buildingsEnabled: false,
                          indoorViewEnabled: false,
                           liteModeEnabled : false,
                           tiltGesturesEnabled : false,
                           fortyFiveDegreeImageryEnabled : false,



                          compassEnabled: false,
                          mapToolbarEnabled: false,
                          initialCameraPosition: CameraPosition(
                            target: LatLng(latitude!, longitude!),
                            zoom: _currentSliderValue,
                          ),
                          mapType: MapType.normal,
                          polygons: _polygons,
                          polylines: _polyLines,
                          myLocationEnabled: true,
                          zoomControlsEnabled: false,
                          myLocationButtonEnabled: true,

                          onTap: (LatLng latLng) {
                            setState(() {
                              showresult = false;
                            });
                          },
                          markers: getMarkers()
                          ),

                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    alignment: Alignment.topRight,
                    child: FloatingActionButton(
                        onPressed: () => {
                              _drawPolygonEnabled == false
                                  ? showDrawing()
                                  : hideDrawing(),
                            },
                        tooltip: 'Drawing',
                        child: (_drawPolygonEnabled)
                            ? Icon(Icons.cancel)
                            : Padding(
                                padding: EdgeInsets.all(5),
                                child: Image.asset(
                                  'assets/draw.png',
                                  height: 30,
                                  width: 30,
                                ),
                              )),),
                  showresult == true
                      ? Align(
                    alignment: Alignment.bottomCenter,
                   //- bottom: 5,
                    child: ResultUi(data: getSearchList,),
                  )
                      : SizedBox(),
                ],
              ),
            ),

          ],
        ),
            ),
      );
  }
  void callLocation() async {
    await getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      List<String> latitudeList = [];
      List<String> longitudeList = [];
      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
        print("latitude->${latitude.toString()}");
        print("longitude->${longitude.toString()}");
        String formattedLatitude = position.latitude.toStringAsFixed(2);
        String formattedLongitude = position.longitude.toStringAsFixed(2);

        latitudeList.add(formattedLatitude);
        longitudeList.add(formattedLongitude);
      });
      await getLocationSearchData(latitudeList,longitudeList);
    } else {
      print("Location permission denied");
    }
  }

  void onDrawListener() {}

  setMarkerIcons() async {
    if (!_isIconsSet) {
      propertiesIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(
          devicePixelRatio: 2.5,
        ),
        'assets/propertis.png',
      );
      _isIconsSet = true;
      if (this.mounted) {
        setState(() {});
      }
    }
  }

  Set<Marker> getMarkers() {
    setMarkerIcons();

    List propertyPolygon = getSearchList.where((property) {
      return MapsTookit.PolygonUtil.containsLocation(
        MapsTookit.LatLng(
          double.parse(property['latitude']),
          double.parse(property['longitude']),
        ),
        _userPolyLinesLatLngList.map((latLng) => MapsTookit.LatLng(latLng.latitude, latLng.longitude)).toList(),
        false,
      );
    }).toList();

    markers.clear();

    markers.addAll(propertyPolygon.map((property) {
      return Marker(
        onTap: () => onMarkerClicked(),
        markerId: MarkerId(property['_id']),
        position: LatLng(
          double.parse(property['latitude']),
          double.parse(property['longitude']),
        ),
        // infoWindow: InfoWindow(
        //   title: property['property_name'],
        //   snippet: 'Price: ${property['property_price']}',
        // ),
        infoWindow: InfoWindow(

          // title: '₹${user['property_price']}',
          title:   property['property_category_type']=="Rent"?
          ' ${postController.formatIndianPrice(property['rent'].toString())}/ Month':
          postController.formatIndianPrice( property['property_price'].toString()),
          snippet: '${property['property_name']}',
        ),
        icon: propertiesIcon,
      );
    }));

    return markers;
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


         x = details.localPosition.dx * pixelRatio ;
         y = details.localPosition.dy * pixelRatio ;

      } else if (Platform.isIOS) {
        x = details.globalPosition.dx;
        y = details.globalPosition.dy;
      }

      // Round the x and y.
      int? xCoordinate = x?.round();
      int? yCoordinate = y?.round();


      // Check if the distance between last point is not too far.
      // to prevent two fingers drawing.
      if (_lastXCoordinate != null && _lastYCoordinate != null) {
        var distance = Math.sqrt(Math.pow(xCoordinate! - _lastXCoordinate!, 2) +
            Math.pow(yCoordinate! - _lastYCoordinate!, 2));
        // Check if the distance of point and point is large.
        if (distance > 80.0) return;
      }

      // Cached the coordinate.
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
            polylineId: PolylineId('user_polyline'),
            points: _userPolyLinesLatLngList,
            width: 4,
            color: Colors.blueGrey,
          ),
        );
      } catch (e) {
        print(" error painting $e");
      }
      setState(() {});
    }
  }

  bool isPointInPolygon(LatLng point, List<LatLng> polygon) {
    int crossings = 0;
    for (int i = 0; i < polygon.length; i++) {
      final LatLng a = polygon[i];
      final LatLng b = polygon[(i + 1) % polygon.length];
      if (((a.latitude > point.latitude) != (b.latitude > point.latitude)) &&
          (point.longitude < (b.longitude - a.longitude) * (point.latitude - a.latitude) / (b.latitude - a.latitude) + a.longitude)) {
        crossings++;
      }
    }
    return (crossings % 2 == 1);
  }



  _onPanEnd(DragEndDetails details) async {
    _lastXCoordinate = null;
    _lastYCoordinate = null;

    if (_drawPolygonEnabled) {
      _polygons.removeWhere((polygon) => polygon.polygonId.value == 'user_polygon');
      _polygons.add(
        Polygon(
          polygonId: PolygonId('user_polygon'),
          points: _userPolyLinesLatLngList,
          strokeWidth: 4,
          strokeColor: Colors.blueGrey,
          fillColor: Colors.blueGrey.withOpacity(0.4),
        ),
      );

      drawnPolygonCoordinates = List.from(_userPolyLinesLatLngList);
      List<String> latitudeList = [];
      List<String> longitudeList = [];

      for (LatLng point in drawnPolygonCoordinates) {
        // latitudeList.add(point.latitude.toString());
        // longitudeList.add(point.longitude.toString());
        String formattedLatitude = point.latitude.toStringAsFixed(2);
        String formattedLongitude = point.longitude.toStringAsFixed(2);

        latitudeList.add(formattedLatitude);
        longitudeList.add(formattedLongitude);
      }

      print("Latitude List: $latitudeList");
      print("Longitude List: $longitudeList");
      print("Drawn Polygon Coordinates: $drawnPolygonCoordinates");

      await getLocationSearchData(latitudeList,longitudeList);

      setState(() {
        _clearDrawing = true;
      });
    }
  }


  showDrawing() {
    _clearPolygons();
    setState(() {
      _drawPolygonEnabled = true;
      showMarkers = false;
    });
  }

  hideDrawing() {
    _clearPolygons();
    setState(() {
      _drawPolygonEnabled = false;
      showresult = false;

      /* if(_drawPolygonEnabled==true){
        showresult = false;
      }*/
    });
  }

  _clearPolygons() {
    setState(() {
      _polyLines.clear();
      _polygons.clear();
      _userPolyLinesLatLngList.clear();
    });
  }

  onSearchCallback(bool showresul1) async {
    if (mounted) {
      setState(() {
        showresult = showresul1;
        print('showresult' + showresul1.toString());
      });
    }
  }

  onMarkerClicked() async {
    if (mounted) {
      setState(() {
        showresult = true;
      });
    }
  }

  updateZoom(double value) async {
    if (this.mounted) {
      setState(() {
        _currentSliderValue = value;
      });

      if (_mapController != null) {
        await _mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(latitude!, longitude!),
              zoom: _currentSliderValue,
            ),
          ),
        );
      }
    }
  }

  Widget zoomSlider() {
    return Container(
      child: SizedBox(
        height: 30,
        width: double.maxFinite,
        child: Padding(
          padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
          child: Slider(
            value: _currentSliderValue,
            min: 1,
            max: 20,
            divisions: 20,
            thumbColor: Colors.blueGrey,
            label: _currentSliderValue.round().toString(),
            onChanged: (double value) {
              updateZoom(value);
            },
          ),
        ),
      ),
    );
  }

  // created method for getting user current location
  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR" + error.toString());
    });
    return await Geolocator.getCurrentPosition();
  }

  Future<void> getLocationSearchData(List<String> latitudeList,  List<String> longitudeList) async {
    getSearchList.clear();
    try {
      var response = await HttpHandler.postHttpMethod(
        url: APIString.searchLocation,
        data: {
          // 'properties_latitude': "18.5642",
          // 'properties_longitude': "73.7769",
          'property_latitude': latitudeList.join(","),
          'property_longitude':longitudeList.join(","),
          'property_category_type':widget.data=="PG"?widget.data:"",
          'category_price_type':widget.data=="Commercial" || widget.data=="Residential" || widget.data=="PG" ?"":widget.data,
          'property_type':widget.data=="PG"?widget.data:"",
          'bhk_type':"",
          'city_name':city,

        },
      );

      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          log("response[data]  ---- ${response['body']["data"]}");
          var respData = response['body'];
          getSearchList.value = respData["data"];
          Fluttertoast.showToast(msg: 'Fetch successfully');
        }else{
          Fluttertoast.showToast(msg: 'Property not found');
        }
      } else if (response['error'] != null) {
        Fluttertoast.showToast(msg: 'Property not found');
      }
    } catch (e) {
      debugPrint(" Error: $e");
    //  Fluttertoast.showToast(msg: 'An error occurred. Please try again.');
    }
  }


}


