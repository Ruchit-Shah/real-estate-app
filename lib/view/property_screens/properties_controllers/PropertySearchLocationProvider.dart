import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as Math;
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as MapsTookit;
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:real_estate_app/common_widgets/loading_dart.dart';
import 'package:real_estate_app/global/api_string.dart';
import 'package:real_estate_app/global/app_color.dart';
import 'package:real_estate_app/global/widgets/loading_dialog.dart';
import 'package:real_estate_app/utils/network_http.dart';
import 'package:real_estate_app/view/filter_search/view/FilterSearchController.dart';
import 'package:real_estate_app/view/property_screens/properties_controllers/post_property_controller.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class PropertySearchLocationProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> categoryType1 = [
    {'title': 'Buy', 'icon': 'assets/buy-home.png'},
    {'title': 'Rent', 'icon': 'assets/rent_house.png'},
    {'title': 'PG', 'icon': 'assets/plot_icon.png'},
    {'title': 'Commercial', 'icon': 'assets/commerical_icon.png'},
  ];
  String propert_type = "";
  int _selectedCategoryIndex = -1;
  int get selectedCategoryIndex => _selectedCategoryIndex;
  Set<Marker> markers = {};
  bool markersReady = false;
  RxList getSearchList = [].obs;
  bool _isIconsSet = false;
  bool isLoadingMarkers = false;
  String city = '';
  bool isMapReady = false;
  bool isSearching = false;
  final PostPropertyController pController = Get.find();
  final FilterSearchController filterSearchController = Get.find();
  var uuid = const Uuid();
  String _sessionToken = '1234567890';
  List<dynamic> _placeList = [];
  List<dynamic> get placeList => _placeList;
  int? _selectedIndex;
  bool showresult = false;
  double _currentSliderValue = 10;
  double get currentSliderValue => _currentSliderValue;
  BitmapDescriptor? propertiesIcon;
  bool showMarkers = true;
  List<String> latitudeList = [];
  List<String> longitudeList = [];
  Completer<GoogleMapController> _controller = Completer();
  Completer<GoogleMapController> get controller => _controller;
  GoogleMapController? _mapController;
  GoogleMapController? get mapController => _mapController;
  PermissionStatus _permissionStatus = PermissionStatus.denied;
  Set<Polygon> _polygons = HashSet<Polygon>();
  Set<Polygon> get polygons => _polygons;
  Set<Polyline> _polyLines = HashSet<Polyline>();
  Set<Polyline> get polyLines => _polyLines;
  bool _drawPolygonEnabled = false;
  bool get drawPolygonEnabled => _drawPolygonEnabled;
  List<LatLng> _userPolyLinesLatLngList = [];
  List<LatLng> drawnPolygonCoordinates = [];
  bool _clearDrawing = false;
  int? _lastXCoordinate;
  int? _lastYCoordinate;
  UniqueKey _mapKey = UniqueKey();
  UniqueKey get mapKey => _mapKey;

  PropertySearchLocationProvider() {
    initialize();
  }

  void initialize() {
    pController.bhkTypes.assignAll([
      "Studio",
      "1 RK",
      "1 BHK",
      "1.5 BHK",
      "2 BHK",
      "2.5 BHK",
      "3 BHK",
      "3.5 BHK",
      "4 BHK",
      "5 BHK",
      "6 BHK",
    ]);
    notifyListeners();
  }

  void setSelectedCategoryIndex(int index) {
    _selectedCategoryIndex = index;
    propert_type = categoryType1[index]['title'] == "Buy" ? "Sell" : categoryType1[index]['title'];
    latitudeList.clear();
    longitudeList.clear();
    getLocationSearchData(latitudeList, longitudeList);
    notifyListeners();
  }

  void clearSearch() {
    getSearchList.clear();
    _selectedCategoryIndex = -1;
    notifyListeners();
  }

  void callLocation(double latitude, double longitude) {
    latitudeList.add(latitude.toStringAsFixed(2));
    longitudeList.add(longitude.toStringAsFixed(2));
    notifyListeners();
  }

  void getSuggestion(String input) async {
    const String PLACES_API_KEY = "AIzaSyAt8bj4UACvakZfiSy-0c1o_ivfplm7jEU";
    String baseURL = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request = '$baseURL?input=$input&key=$PLACES_API_KEY&sessiontoken=$_sessionToken';

    try {
      var response = await http.get(Uri.parse(request));
      if (response.statusCode == 200) {
        _placeList = json.decode(response.body)['predictions'];
        isSearching = true;
        notifyListeners();
      } else {
        throw Exception('Failed to load predictions');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> setMarkerIcons() async {
    if (!_isIconsSet) {
      final Uint8List markerIconBytes = await getBytesFromAsset('assets/properties.png', 100);
      propertiesIcon = BitmapDescriptor.fromBytes(markerIconBytes);
      _isIconsSet = true;
      notifyListeners();
    }
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  Future<Set<Marker>> getMarkers() async {
    await setMarkerIcons();
    if (getSearchList.isEmpty) return {};

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

    return propertyPolygon.map<Marker>((property) {
      return Marker(
        markerId: MarkerId(property['_id']),
        position: LatLng(
          double.parse(property['latitude']),
          double.parse(property['longitude']),
        ),
        infoWindow: InfoWindow(
          title: '₹${property['property_price']}',
          onTap: onMarkerClicked,
        ),
        icon: propertiesIcon ?? BitmapDescriptor.defaultMarker,
      );
    }).toSet();
  }

  Future<void> loadMarkers() async {
    isLoadingMarkers = true;
    notifyListeners();

    await setMarkerIcons();

    if (getSearchList.isEmpty) {
      markers = {};
      isLoadingMarkers = false;
      notifyListeners();
      return;
    }

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

    markers = propertyPolygon.map<Marker>((property) {
      return Marker(
        markerId: MarkerId(property['_id']),
        position: LatLng(
          double.parse(property['latitude']),
          double.parse(property['longitude']),
        ),
        infoWindow: InfoWindow(
          title: '₹${property['property_price']}',
          onTap: onMarkerClicked,
        ),
        icon: propertiesIcon ?? BitmapDescriptor.defaultMarker,
      );
    }).toSet();

    isLoadingMarkers = false;
    notifyListeners();
  }

  void onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _controller.complete(controller);
    if (Platform.isAndroid) {
      controller.setMapStyle('''[
        {
          "featureType": "all",
          "elementType": "labels",
          "stylers": [
            { "visibility": "simplified" }
          ]
        }
      ]''');
    }
    isMapReady = true;
    notifyListeners();
  }

  void onPanUpdate(DragUpdateDetails details, BuildContext context) async {
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

      ScreenCoordinate screenCoordinate = ScreenCoordinate(x: xCoordinate!, y: yCoordinate!);

      final GoogleMapController controller = await _controller.future;
      LatLng latLng = await controller.getLatLng(screenCoordinate);

      try {
        _userPolyLinesLatLngList.add(latLng);
        _polyLines.removeWhere((polyline) => polyline.polylineId.value == 'user_polyline');
        _polyLines.add(
          Polyline(
            polylineId: const PolylineId('user_polyline'),
            points: _userPolyLinesLatLngList,
            width: 2,
            color: AppColor.primaryThemeColor,
          ),
        );
      } catch (e) {
        print(" error painting $e");
      }
      notifyListeners();
    }
  }

  void onPanEnd() async {
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

      drawnPolygonCoordinates = List.from(_userPolyLinesLatLngList);
      latitudeList.clear();
      longitudeList.clear();
      for (LatLng point in drawnPolygonCoordinates) {
        latitudeList.add(point.latitude.toStringAsFixed(2));
        longitudeList.add(point.longitude.toStringAsFixed(2));
      }

      if (latitudeList.isNotEmpty && longitudeList.isNotEmpty) {
        await getLocationSearchData(latitudeList, longitudeList);
        await loadMarkers();
      }
      _clearDrawing = true;
      notifyListeners();
    }
  }

  void showDrawing() {
    _clearPolygons();
    _drawPolygonEnabled = true;
    showMarkers = false;
    showresult = false;
    _clearDrawing = false;
    notifyListeners();
  }

  void hideDrawing() {
    _clearPolygons();
    _drawPolygonEnabled = false;
    showresult = false;
    showMarkers = true;
    _clearDrawing = true;
    notifyListeners();
  }

  void _clearPolygons() {
    _polyLines.clear();
    _polygons.clear();
    _userPolyLinesLatLngList.clear();
    notifyListeners();
  }

  void onMarkerClicked() {
    showresult = true;
    notifyListeners();
  }

  void updateZoom(double value) async {
    if (_mapController != null) {
      await _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(0, 0), // Will be updated in UI with widget.latitude/longitude
            zoom: _currentSliderValue,
          ),
        ),
      );
    }
    notifyListeners();
  }

  Future<void> getLocationSearchData(List<String> latitudeList, List<String> longitudeList) async {
    final startTime = DateTime.now();
    getSearchList.clear();
    markersReady = false;
    isLoadingMarkers = true;
    notifyListeners();

    try {
      showHomLoading(Get.context!, 'Processing...');
      var response = await HttpHandler.postHttpMethod(
        url: APIString.searchLocation,
        data: {
          'property_latitude': latitudeList.join(","),
          'property_longitude': longitudeList.join(","),
          'property_category_type': propert_type,
          'bhk_type': filterSearchController.selectedBHKTypeList.join(","),
          'city_name': city,
        },
      ).timeout(Duration(seconds: 10));

      if (response['error'] == null && response['body']['status'].toString() == "1") {
        getSearchList = response['body']["data"];
        markers = await getMarkers();
        markersReady = true;
        showresult = true;
        Fluttertoast.showToast(msg: 'Fetch successfully');
      } else {
        Fluttertoast.showToast(msg: 'Property not found');
        markersReady = true;
      }
    } catch (e) {
      debugPrint("Error: $e");
      markersReady = true;
    } finally {
      isLoadingMarkers = false;
      hideLoadingDialog();
      notifyListeners();
      print('Total time: ${DateTime.now().difference(startTime).inMilliseconds}ms');
    }
  }
}