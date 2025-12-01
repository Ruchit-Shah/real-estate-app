import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:real_estate_app/Routes/app_pages.dart';
import 'package:real_estate_app/common_widgets/dialog_util.dart';
import 'package:real_estate_app/common_widgets/height.dart';
import 'package:real_estate_app/global/app_color.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/CustomBottomNavBar.dart';
import 'package:real_estate_app/view/filter_search/view/FilterSearchController.dart';
import 'package:real_estate_app/view/filter_search/view/filter_search_screen.dart';
import 'package:real_estate_app/view/map/result_ui/result_ui_screen.dart';
import 'package:real_estate_app/view/property_screens/properties_controllers/PropertySearchLocationProvider.dart';
import 'package:real_estate_app/view/property_screens/property_search_location/expandableBottomSheet.dart';
import '../../../common_widgets/loading_dart.dart';

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
  TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController scrollController = ScrollController();
  double selected = 20.0;

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    var _height = MediaQuery.of(context).size.height;
    return ChangeNotifierProvider(
      create: (_) => PropertySearchLocationProvider()
        ..callLocation(widget.latitude, widget.longitude),
      child: Consumer<PropertySearchLocationProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            appBar: appBar(context, provider),
            body: Stack(
              children: [
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      height: _height,
                      padding: const EdgeInsets.only(bottom: 0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 4,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                  child: SizedBox(
                                    height: 50,
                                    child: GooglePlaceAutoCompleteTextField(
                                      textEditingController: _controller,
                                      focusNode: _focusNode,
                                     // googleAPIKey: 'AIzaSyDY-oB0QysTXFJu2cOMlZvpwANBR2XS84E',
                                      googleAPIKey: 'AIzaSyAt8bj4UACvakZfiSy-0c1o_ivfplm7jEU',
                                      inputDecoration: InputDecoration(
                                        hintText: "Search locality, projects, landmark",
                                        prefixIcon: const Icon(Icons.search),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(25),
                                          borderSide: BorderSide.none,
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                      ),
                                      debounceTime: 800,
                                      countries: const ["in"],
                                      isLatLngRequired: true,
                                      getPlaceDetailWithLatLng: (prediction) async {
                                        if (prediction != null &&
                                            prediction.structuredFormatting?.mainText != null) {
                                          final details =
                                              prediction.structuredFormatting!.mainText;
                                          Get.to(FilterSearchScreen(

                                            isfrom: widget.data,
                                            isfrompage: '',
                                          ));
                                        }
                                      },
                                      itemClick: (prediction) {
                                        if (prediction?.description != null) {
                                          _controller.text = prediction!.description!;
                                          _controller.selection = TextSelection.fromPosition(
                                            TextPosition(
                                                offset: prediction.description!.length),
                                          );
                                          provider.getSuggestion(_controller.text);
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              customIconButton(
                                icon: Icons.filter_list,
                                onTap: () {
                                  Get.to(FilterSearchScreen(

                                    isfrom: widget.data,
                                    isfrompage: '',
                                  ));
                                },
                              ),
                              boxW02(),
                            ],
                          ),
                          boxH10(),

                          _controller.text.isNotEmpty
                              ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              boxH10(),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () {
                                    provider.callLocation(
                                        widget.latitude, widget.longitude);
                                  },
                                  child: const Row(
                                    children: [
                                      Icon(Icons.location_searching_rounded,
                                          size: 18, color: Colors.black),
                                      SizedBox(width: 5),
                                      Text(
                                        "Use my current location",
                                        style: TextStyle(fontSize: 15),
                                      ),
                                      Spacer(),
                                      Icon(Icons.arrow_forward),
                                      SizedBox(width: 10),
                                    ],
                                  ),
                                ),
                              ),
                              Divider(
                                color: Colors.grey.shade200,
                              ),
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "Configuration",
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              SizedBox(
                                height: 60,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: provider.pController.bhkTypes.length,
                                  itemBuilder: (context, index) {
                                    final text =
                                    provider.pController.bhkTypes[index];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5.0),
                                      child: Obx(() => ChoiceChip(
                                        label: Text(text),
                                        labelStyle: TextStyle(
                                          color: provider
                                              .filterSearchController
                                              .selectedLocation
                                              .value ==
                                              text
                                              ? AppColor
                                              .secondaryThemeColor
                                              : Colors.black
                                              .withOpacity(0.7),
                                        ),
                                        selected: provider
                                            .filterSearchController
                                            .BHKType
                                            .value ==
                                            text ||
                                            provider
                                                .filterSearchController
                                                .selectedBHKTypeList
                                                .contains(text),
                                        onSelected: (isSelected) {
                                          if (isSelected) {
                                            if (text ==
                                                provider
                                                    .filterSearchController
                                                    .BHKType
                                                    .value) {
                                              return;
                                            }
                                            provider
                                                .filterSearchController
                                                .selectedBHKTypeList
                                                .add(text);
                                          } else {
                                            provider
                                                .filterSearchController
                                                .selectedBHKTypeList
                                                .remove(text);
                                            if (provider
                                                .filterSearchController
                                                .BHKType
                                                .value ==
                                                text) {
                                              provider
                                                  .filterSearchController
                                                  .BHKType
                                                  .value = "";
                                            }
                                          }
                                        },
                                        selectedColor: AppColor
                                            .secondaryThemeColor
                                            .withOpacity(0.3),
                                        side: BorderSide(
                                          color: provider
                                              .filterSearchController
                                              .selectedLocation
                                              .value ==
                                              text
                                              ? AppColor
                                              .secondaryThemeColor
                                              : Colors.grey
                                              .withOpacity(0.3),
                                          width: 0.8,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(30),
                                        ),
                                      )),
                                    );
                                  },
                                ),
                              ),
                              boxH10(),
                            ],
                          )
                              : const SizedBox(),

                          Expanded(
                            child: Stack(
                              children: <Widget>[
                                SizedBox(
                                  width: Get.width,
                                  height: Get.height * 0.8,
                                  child: GestureDetector(
                                    onPanUpdate: provider.drawPolygonEnabled
                                        ? (details) =>
                                        provider.onPanUpdate(details, context)
                                        : null,
                                    onPanEnd: provider.drawPolygonEnabled
                                        ? (_) => provider.onPanEnd()
                                        : null,
                                    behavior: HitTestBehavior.opaque,
                                    child: Stack(
                                      children: [
                                        if (provider.isLoadingMarkers)
                                          const Center(
                                              child: CircularProgressIndicator())
                                        else
                                          GoogleMap(
                                            key: provider.mapKey,
                                            onMapCreated: provider.onMapCreated,
                                            initialCameraPosition: CameraPosition(
                                              target: LatLng(
                                                  widget.latitude,
                                                  widget.longitude),
                                              zoom: provider.currentSliderValue,
                                            ),
                                            zoomGesturesEnabled:
                                            !provider.drawPolygonEnabled,
                                            scrollGesturesEnabled:
                                            !provider.drawPolygonEnabled,
                                            rotateGesturesEnabled:
                                            !provider.drawPolygonEnabled,
                                            tiltGesturesEnabled:
                                            !provider.drawPolygonEnabled,
                                            zoomControlsEnabled:
                                            !provider.drawPolygonEnabled,
                                            myLocationButtonEnabled:
                                            !provider.drawPolygonEnabled,
                                            trafficEnabled: false,
                                            buildingsEnabled: false,
                                            indoorViewEnabled: false,
                                            liteModeEnabled: false,
                                            fortyFiveDegreeImageryEnabled: false,
                                            compassEnabled: false,
                                            mapToolbarEnabled: false,
                                            mapType: MapType.normal,
                                            polygons: provider.polygons,
                                            polylines: provider.polyLines,
                                            myLocationEnabled: true,
                                            onTap: (LatLng latLng) {
                                              provider.showresult = false;
                                              provider.notifyListeners();
                                            },
                                            markers: provider.markers,
                                            onCameraMove: (position) {
                                              if (provider.drawPolygonEnabled) {
                                                Fluttertoast.showToast(
                                                  msg: "Please finish drawing first",
                                                  toastLength: Toast.LENGTH_SHORT,
                                                );
                                                provider.mapController
                                                    ?.animateCamera(
                                                  CameraUpdate.newCameraPosition(
                                                    CameraPosition(
                                                      target: LatLng(
                                                          widget.latitude,
                                                          widget.longitude),
                                                    ),
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                                        if (provider.drawPolygonEnabled)
                                          Positioned.fill(
                                            child: IgnorePointer(
                                              child: Container(
                                                color:
                                                Colors.black.withOpacity(0.2),
                                                child: const Center(
                                                  child: Text(
                                                    "Drawing Mode - Zoom Disabled",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.all(10),
                                  alignment: Alignment.topRight,
                                  child: FloatingActionButton(
                                    onPressed: () {
                                      if (provider.drawPolygonEnabled) {
                                        provider.hideDrawing();
                                      } else {
                                        provider.showDrawing();
                                      }
                                    },
                                    tooltip: 'Drawing',
                                    child: (provider.drawPolygonEnabled)
                                        ? const Icon(Icons.cancel)
                                        : Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Image.asset(
                                        'assets/draw.png',
                                        height: 30,
                                        width: 30,
                                      ),
                                    ),
                                  ),
                                ),
                                if (provider.showresult) ...[
                                  Positioned(
                                    bottom: 45,
                                    child: ResultUi(data: provider.getSearchList),
                                  ),
                                  ExpandableBottomSheet(
                                      data: provider.getSearchList),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            bottomNavigationBar:
            _controller.text.isNotEmpty || provider.selectedCategoryIndex != -1
                ? Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10.0, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      _controller.clear();
                      provider.clearSearch();
                    },
                    child: const Text(
                      "Clear All",
                      style: TextStyle(
                          color: AppColor.primaryThemeColor,
                          fontSize: 18),
                    ),
                  ),
                  SizedBox(
                    width: 150,
                    height: 50,
                    child: commonButton(
                      text: "Search",
                      onPressed: () {
                        provider.getLocationSearchData(
                            provider.latitudeList,
                            provider.longitudeList);
                      },
                    ),
                  ),
                ],
              ),
            )
                : null,
          );
        },
      ),
    );
  }

  AppBar appBar(BuildContext context, PropertySearchLocationProvider provider) {
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
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  boxW15(),
                  Container(
                    height: Get.height * 0.09,
                    width: 300,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: provider.categoryType1.length,
                        itemBuilder: (context, index) {
                          bool isSelected = provider.selectedCategoryIndex == index;
                          return GestureDetector(
                            onTap: () async {
                              DialogUtil.showLoadingDialogWithDelay(
                                  milliseconds: 600);
                              Get.back();
                              provider.setSelectedCategoryIndex(index);
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 6.0),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 8.0),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColor.secondaryThemeColor
                                    : AppColor.white,
                                border: Border.all(
                                  color: isSelected
                                      ? AppColor.secondaryThemeColor
                                      : AppColor.white,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  provider.categoryType1[index]['title'],
                                  style: TextStyle(
                                    color:
                                    isSelected ? AppColor.black : AppColor.black,
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



// Placeholder widgets (replace with actual implementations)
  Widget customIconButton({required IconData icon, required VoidCallback onTap}) {
    return IconButton(icon: Icon(icon), onPressed: onTap);
  }

  Widget boxW02() => const SizedBox(width: 2);
  Widget boxW15() => const SizedBox(width: 15);
  Widget boxH10() => const SizedBox(height: 10);

  Widget commonButton({required String text, required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }

  Widget ResultUi({required List<dynamic> data}) {
    return Container(
      width: Get.width,
      height: 100,
      color: Colors.white,
      child: Text('Results: ${data.length} items'),
    );
  }

  Widget ExpandableBottomSheet({required List<dynamic> data}) {
    return Container(
      width: Get.width,
      height: 200,
      color: Colors.grey[200],
      child: Text('Bottom Sheet: ${data.length} items'),
    );
  }
}
