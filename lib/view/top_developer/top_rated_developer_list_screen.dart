import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:real_estate_app/common_widgets/height.dart';
import 'package:real_estate_app/global/app_color.dart';
import 'package:real_estate_app/view/auth/login_screen/login_screen.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/search_screen/searchController.dart';
import 'package:real_estate_app/view/map/result_ui/projectResultUi.dart';
import 'package:real_estate_app/view/top_developer/top_developer_details.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../common_widgets/loading_dart.dart';
import '../../../global/api_string.dart';
import '../../common_widgets/custom_textformfield.dart';
import '../../utils/text_style.dart';
import '../filter_search/view/FilterSearchController.dart';
import '../map/result_ui/result_ui_screen.dart';
import '../property_screens/filter/project_filter_screen.dart';
import '../property_screens/properties_controllers/post_property_controller.dart';
import '../splash_screen/splash_screen.dart';

class top_rated_developer_listScreen extends StatefulWidget {

  const top_rated_developer_listScreen({super.key, });

  @override
  State<top_rated_developer_listScreen> createState() =>
      _top_rated_developer_listScreenState();
}

class _top_rated_developer_listScreenState
    extends State<top_rated_developer_listScreen> {
  bool isDialogShowing = false;
  final PostPropertyController controller = Get.put(PostPropertyController());
  final FilterSearchController filterController = Get.find();
  String selectedValue = "";
  final FocusNode _focusNode = FocusNode();
  GoogleMapController? _mapController;
  final Completer<GoogleMapController> _controller = Completer();
   Set<Marker> markers  = {};
  bool Ismap= false;
  final scrollController = ScrollController();
  final searchApiController = Get.find<searchController>();

  void onChange(String? value) {
    setState(() {
      selectedValue = value!;
    });
  }

  @override
  void initState() {
    super.initState();
    controller.searchController.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getBuildersProjects(page: '1');
      getClear();
      controller.sortBY.value = '';
    });
    getMarkers().then((loadedMarkers) {
      markers = loadedMarkers;
      setState(() {

      });
    });
    print('markers output ${markers}');
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 100 &&
          !controller.isPaginationLoading.value &&
          controller.hasMore.value) {
        loadMoreData();
      }
    });
  }

  getClear(){
    filterController.ClearData();
    print("object");
    setState(() {
      filterController.selectedFurnishingStatusList.clear();
      // pController.profileController.myListingProject.clear();
      // pController.getCommonProjectsList.clear();


      setState(() {
        filterController.isClear.value=false;
      });
      filterController.budgetMin.value = null;
      filterController.budgetMax.value = null;
      filterController.budgetMin1.value = "";
      filterController.budgetMax1.value = "";
    });
    // await pController.getMySearchProject(
    //   searchKeyword: widget.search_key,
    //   city: '',
    //   locality: '',
    //   max_price:"${controller.budgetMax1.value.toString()}00000" ,
    //   min_price:controller.budgetMin1.value.toString() ,
    //   project_type:controller.selectedPropertyType.join('|') ,isFrom: widget.isFrom,
    //   furnishtype:  controller.selectedFurnishingStatusList.join('|'),
    //   bhktype: controller.selectedBHKTypeList.join('|'),
    //
    // );
  }
  // @override
  // void initState() {
  //   super.initState();
  //   controller.searchController.clear();
  //   controller.hasMore.value = true;
  //   controller.isPaginationLoading.value = false;
  //   controller.currentPage.value = 0;
  //   controller.totalPages.value = 1;
  //   controller.buildersProjectList.clear();
  //   controller.getCommonProjectsList.clear();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     print("initState: Fetching builders projects for page 1");
  //     controller.getBuildersProjects(page: '1');
  //     controller.sortBY.value = 'relevance';
  //   });
  //   getMarkers().then((loadedMarkers) {
  //     markers = loadedMarkers;
  //     setState(() {});
  //   });
  //   print('markers output: $markers');
  // }
  Future<Set<Marker>> getMarkers() async {
    Set<Marker> markers = {};

    final List<dynamic> filterDataCopy = List.from(controller.buildersProjectList);
print("length ${filterDataCopy.length}");
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
        //   title: '₹${user['average_project_price'] ?? '0'}',
        // ),
        infoWindow: InfoWindow(

          // title: '₹${user['property_price']}',
          title:
          controller.formatPriceRange(user['average_project_price']),
          snippet: '${user['project_name']}',
        ),
        icon: BitmapDescriptor.fromBytes(markerIcon),
      ));
    }

    return markers;
  }
  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  void loadMoreData() {
    if (controller.hasMore.value && !controller.isPaginationLoading.value) {
      controller.isPaginationLoading.value = true;

      final nextPage = (controller.currentPage.value + 1).toString();

      if (controller.searchController.text.trim().isNotEmpty) {
        controller.getMySearchProject(searchKeyword:controller.searchController.text.trim(),page: nextPage);
      } else {
        if(filterController.isClear.value){
          print('builder project api is called ===>>>');
          controller.getBuildersProjects(page: nextPage);
        }else{
          controller.getMySearchProject(
            searchKeyword: controller.searchController.text.trim(),
            city: '',
            locality: '',
            sortBY: controller.sortBY.value,
            max_price:"${filterController.budgetMax1.value.toString()}" ,
            min_price:filterController.budgetMin1.value.toString() ,
            project_type:filterController.selectedPropertyType.join('|') ,
            isFrom: '',
            furnishtype:  filterController.selectedFurnishingStatusList.join('|'),
            bhktype: filterController.selectedBHKTypeList.join('|'),
              page: nextPage,


          );
        }

      }
    }
  }
  Timer? _debounce;

  void onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      controller.currentPage.value = 1;
      controller.hasMore.value = true;
      if (value.trim().isEmpty) {
        controller.getBuildersProjects(page: '1').then((_) {
          getMarkers().then((loadedMarkers) {
            setState(() {
              markers = loadedMarkers;
              _mapController?.setMapStyle(null);
            });
          });
        });
      } else {
        controller.getMySearchProject(searchKeyword: value.trim(), page: '1').then((_) {
          getMarkers().then((loadedMarkers) {
            setState(() {
              markers = loadedMarkers;
              _mapController?.setMapStyle(null);
            });
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    var _height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title:  Padding(
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
                hintText: "Search",
                hintStyle: const TextStyle(
                    color: Colors.grey, fontWeight: FontWeight.normal),
                prefixIcon: const Icon(Icons.search, size: 25),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.cancel, size: 18),
                  onPressed: () {
                    if(controller.searchController.text.isNotEmpty) {
                      controller.searchController.clear();
                      controller.sortBY.value = '';
                      onSearchChanged('');
                    }
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
              onTap: () {
                // setState(() {
                //   Ismap= !Ismap;
                // });
                ///
                if(Ismap==true){
                  setState(() {
                    Ismap=false;
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
                  Get.to(projectFilterScreen(search_key: controller.searchController.text, isFrom: 'top builder', ));
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
      body: Obx(() => Column(
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
                            text:controller.total_count.toString(),
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
                // GestureDetector(
                //   onTap: () {
                //     setState(() {
                //       Ismap= !Ismap;
                //     });
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
                    setState(() {
                      Ismap = !Ismap; // Toggle between views
                    });
                    // Optionally call a method to switch views
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
                          Ismap
                              ? "assets/image_rent/mapView.png"
                              : "assets/image_rent/listView.png", // Replace with your list view icon
                          width: 24,
                          height: 24,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          Ismap ? "Map View" : "List View",
                          style: const TextStyle(color: Colors.white, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          controller.getCommonProjectsList.isNotEmpty && controller.getCommonProjectsList.length != 0
              ?  Ismap?
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
                child: ProjectResultUi(
                  data: controller.getCommonProjectsList,
                  loadMoreData: loadMoreData,
                  hasMore: controller.hasMore,
                  isPaginationLoading: controller.isPaginationLoading,
                ),
              )

            ],
          ):  Expanded(
            child: Obx(() {
              if (controller.getCommonProjectsList.isEmpty && controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              return RefreshIndicator(
                  onRefresh: () async {
                    controller.getBuildersProjects(page: '1');
                  },
                  child:LazyLoadScrollView(
                    onEndOfPage: () {
                      print("LazyLoadScrollView: Reached end of page");
                      if (controller.hasMore.value && !controller.isPaginationLoading.value) {
                        print("LazyLoadScrollView: Triggering loadMoreData");
                        loadMoreData();
                      } else {
                        print("LazyLoadScrollView: Not loading more data");
                        print("hasMore: ${controller.hasMore.value}");
                        print("isPaginationLoading: ${controller.isPaginationLoading.value}");
                      }
                    },
                    isLoading: controller.isPaginationLoading.value,
                    child: Obx(()=>
                        ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          controller: scrollController,
                          padding: EdgeInsets.zero, // Add this
                          itemCount: controller.getCommonProjectsList.length + (controller.isPaginationLoading.value ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == controller.getCommonProjectsList.length) {
                              return const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Center(child: CircularProgressIndicator()),
                              );
                            }
                            return _buildProjectCard(context, controller.getCommonProjectsList[index]);
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
      )),
    );
  }
  Widget _buildProjectCard(BuildContext context, Map<String, dynamic> project) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: () {
        Get.to(TopDevelopersDetails(
          projectID: project['_id'].toString(),
        ))?.then((value) {
          if (value != null) {
            setState(() {
              // If you're just updating isFavorite
              project['is_favorite'] = value;

              print("widget.property_data['isFavorite']--->");
              print(project['is_favorite']);
              print(value);


            });
          }
        });
      },

      child: Container(
        height: height* 0.6,
        margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
        child: Stack(
          children: [
            // Main Image
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: project['cover_image'] != null && project['cover_image'].isNotEmpty
                  ? CachedNetworkImage(
                imageUrl: project['cover_image'],
                height: height * 0.4,
                width: width * 0.9,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(), // or your custom placeholder
                ),
                errorWidget: (context, url, error) => Image.asset(
                  'assets/image_rent/langAsiaCity.png',
                  height: height * 0.4,
                  width: width * 0.9,
                  fit: BoxFit.cover,
                ),
              )
                  : Image.asset(
                'assets/image_rent/langAsiaCity.png',
                height: height * 0.4,
                width: width * 0.9,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Row(
                children: [
                  /// Favorite Icon
                  Container(
                    height: 36,
                    width: 36,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.8),
                    ),
                    child: InkWell(
                      onTap: () {
                        if (isLogin == true) {
                          if (project['is_favorite'] ?? false) {
                            searchApiController.removeFavoriteProject(
                              project_id: project['_id'],
                              favorite_id: project['favorite_id'],
                            ).then((_) {
                              project['is_favorite'] = false;
                              setState(() {}); // Moved inside then()
                            });
                          } else {
                            searchApiController.addFavoriteProject(
                              project_id: project['_id'],
                            ).then((_) {
                              project['is_favorite'] = true;
                              setState(() {});
                            });
                          }
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginScreen()),
                          );
                        }
                      },
                      borderRadius: BorderRadius.circular(50),
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Icon(
                          (project['is_favorite'] == true) ? Icons.favorite : Icons.favorite_border,
                          color: (project['is_favorite'] == true) ? Colors.red : Colors.black.withOpacity(0.6),
                          size: 25.0,
                        ),
                      ),
                    ),
                  ),

                  /// Share Icon
                  Container(
                    height: 36,
                    width: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.8),
                    ),
                    child: InkWell(
                      onTap: () async {

                        shareProject(project['_id']);

                      },
                      borderRadius: BorderRadius.circular(50),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Image.asset(
                          "assets/image_rent/share.png",
                          height: 16,
                          width: 16,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Overlay Content
            Positioned(
              bottom: 0,
              left: 20,
              right: 20,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top dark section with developer name
                      Container(
                        height: height * 0.15,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                          ),
                        ),
                        child: Stack(
                          children: [
                            // Blurred background image
                            if (project['cover_image'] != null && project['cover_image'].isNotEmpty)
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15),
                                ),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Image.network(
                                      project['cover_image'],
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          color: Colors.black.withOpacity(0.7),
                                        );
                                      },
                                    ),
                                    BackdropFilter(
                                      filter: ImageFilter.blur(sigmaX: 50.0, sigmaY: 50.0),
                                      child: Container(
                                        color: Colors.black.withOpacity(0.5),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            else
                              Container(
                                color: Colors.black.withOpacity(0.7),
                              ),

                            // Text content
                            Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 30),
                                child: Text(
                                  project['project_name'],
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),

                      // Bottom white section with details
                      Container(
                        height: width * 0.35,
                        width: double.infinity, // Full width
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          ),
                          border: Border.all(
                            width: 0.5,
                            color: Colors.grey,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 10,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              project['congfigurations'].toString(),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              project['project_type'],
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            // Text(
                            //   project['address_area'] ?? project['address'],
                            //   style: const TextStyle(
                            //     fontSize: 14,
                            //     fontWeight: FontWeight.bold,
                            //     color: Colors.black54,
                            //     overflow: TextOverflow.ellipsis,
                            //   ),
                            //   maxLines: 1,
                            //   overflow: TextOverflow.ellipsis,
                            // ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  "assets/address-location.png",
                                  height: 25,
                                  width: 25,
                                ),
                                const SizedBox(width: 5),
                                Expanded(
                                  child:  Text(
                                    // "city_name": "Nagpur",
                                    // "country": "India",
                                    // "state": "Maharashtra",
                                    project['city_name']+", " +project['state'],
                                    //project['address_area'] ?? project['address'],
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),



                            boxH05(),
                            Text(
                              controller.formatPriceRange(project['average_project_price']),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),

                            // Text(
                            //   project['average_project_price']?.toString().isNotEmpty == true
                            //       ? controller.formatIndianPrice(project['average_project_price'] ?? '0')
                            //       : '₹ N/A',
                            //   style: const TextStyle(
                            //     fontSize: 18,
                            //     fontWeight: FontWeight.bold,
                            //     color: Colors.black,
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Circular logo image - Centered version
                  Positioned(
                    top: -(height * 0.058),
                    left: 0,
                    right: 0,
                    child: Center(
                      child: ClipOval(
                        child: SizedBox(
                          width: height * 0.12,
                          height: height * 0.12,
                          child: project['logo'] != null
                              ? CachedNetworkImage(
                            imageUrl: project['logo'],
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) => Image.asset(
                              'assets/image_rent/langAsiaCity.png',
                              fit: BoxFit.cover,
                            ),
                          )
                              : Image.asset(
                            'assets/image_rent/langAsiaCity.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void addEnquiry(context, String developer_id) async {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    showModalBottomSheet<void>(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return GetBuilder<PostPropertyController>(
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
                                "Add Enquiry",
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
                      CustomTextFormField(
                        controller: controller.addressController,
                        labelText: 'Enter Message',
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter message';
                          }
                          return null;
                        },
                      ),
                      boxH10(),
                      GestureDetector(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            // developer_id, name, user_id, email, contact_number,message
                            controller
                                .addDeveloperEnquiry(
                                    message:
                                        controller.addressController.value.text,
                                    developer_id: developer_id)
                                .then((value) {
                              controller.addressController.clear();
                              Navigator.of(context).pop();
                            });
                          } else {
                            Fluttertoast.showToast(
                              msg: 'Please fill all required fields',
                            );
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: AppColor.blueGrey,
                          ),
                          child: const Text(
                            'Send Enquiry',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      boxH20(),
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
                    // {'value': 'low_to_high', 'label': 'Price low to high'},
                    // {'value': 'hight_to_low', 'label': 'Price high to low'},
                    // {'value': 'newest', 'label': 'Newest'},
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
                      controller.getMySearchProject(
                        searchKeyword: controller.searchController.text.trim(),
                        city: '',
                        locality: '',
                        sortBY: controller.sortBY.value,
                        max_price:"${filterController.budgetMax1.value.toString()}" ,
                        min_price:filterController.budgetMin1.value.toString() ,
                        project_type:filterController.selectedPropertyType.join('|') ,
                        isFrom: '',
                        furnishtype:  filterController.selectedFurnishingStatusList.join('|'),
                        bhktype: filterController.selectedBHKTypeList.join('|'),
                      ).then((value) {
                        print('sort by count : ${controller.getCommonProjectsList.length}');
                        Get.back();
                        setState(() {

                        });
                      });
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
}
Future<void> shareProject(String propertyId) async {
  final propertyUrl = 'http://customer.houzza.in/projectdetail/$propertyId';
  final playStoreUrl = 'https://play.google.com/store/apps/details?id=com.houzzaapp&hl=en';

  final message = '''
Hey! 👋

I found this 🏠project on Houzza and thought you might like it:
$propertyUrl

Download the Houzza app to explore more projects and get a better experience:
$playStoreUrl
''';

  await Share.share(message);
}