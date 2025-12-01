import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_places_flutter/google_places_flutter.dart';

import 'package:real_estate_app/common_widgets/dialog_util.dart';
import 'package:real_estate_app/common_widgets/height.dart';
import 'package:real_estate_app/common_widgets/loading_dart.dart';
import 'package:real_estate_app/global/AppBar.dart';
import 'package:real_estate_app/global/app_color.dart';
import 'package:real_estate_app/global/constant.dart';


import '../../property_screens/properties_controllers/post_property_controller.dart';
import '../../splash_screen/splash_screen.dart';
import 'FilterSearchController.dart';
import 'filterListScreen.dart';
import 'package:http/http.dart' as http;

class FilterSearchScreen extends StatefulWidget {
  String  isfrom;
  String?  propety_hide;
  String  isfrompage;
  String? property_listed_by;
  String? searchQuery;
  String? city;
  String? area;
  String? category_type;
  var property_type;
  FilterSearchScreen({super.key,required this.isfrom,required this.isfrompage,this.property_listed_by,this.searchQuery,this.property_type,this.city,this.area,this.category_type,this.propety_hide});


  @override
  State<FilterSearchScreen> createState() => _FilterSearchScreenState();
}

class _FilterSearchScreenState extends State<FilterSearchScreen> {

  FilterSearchController controller = Get.find();

  final PostPropertyController pController = Get.put(PostPropertyController());
   TextEditingController _Controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String? areaName;
  String? cityName;

  @override
  void initState() {
    super.initState();
    controller.isLoading.value = false;
    // controller.budgetMin.value = 0;
    controller.isFetchingLocation.value = false;
    WidgetsBinding.instance.addPostFrameCallback((_) async{


      pController.sortBY.value="";
      widget.isfrom == 'map search' ? controller.ClearData() : null;
    areaName = widget.area;
      _Controller = TextEditingController(text: widget.searchQuery);
    cityName = widget.city; });
    pController.getAmenities();
    debugPrint("widget.isfrom => ${widget.isfrom}");
    debugPrint("widget.isfrompage => ${widget.isfrompage}");
    debugPrint("widget.pro => ${widget.property_type}");
  //  property_category_type: widget.isfrom=="Commercial" || widget.isfrom=="Residential"?controller.lookingFor.join(","): '',
    getData();
  }

  Future<void> getData()async{
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      debugPrint("widget.data => ${widget.searchQuery}");
      debugPrint("widget.area => ${widget.area}");
      debugPrint("widget.city => ${widget.city}");

    await widget.isfrom == 'map search' ? controller.searchLocation(search_query: _Controller.text,city: cityName,search_area:areaName != '' ? areaName : cityName) :
    getFilterData();
    });
  }
void getFilterData(){
  WidgetsBinding.instance.addPostFrameCallback((_) async{
    controller.isClear.value=false;
    pController.bhkTypes.assignAll([
      "Studio", "1 RK", "1 BHK", "1.5 BHK", "2 BHK", "2.5 BHK",
      "3 BHK", "3.5 BHK", "4 BHK", "5 BHK", "6 BHK",
    ]);
    print("popular city ${widget.city}");

    final matchedBHK = widget.searchQuery != null
        ? pController.bhkTypes.firstWhere(
          (bhk) => bhk.toLowerCase() == widget.searchQuery!.toLowerCase(),
      orElse: () => '',
    )
        : '';


    if (matchedBHK.isNotEmpty && !controller.selectedBHKTypeList.contains(matchedBHK)) {
      controller.selectedBHKTypeList.add(matchedBHK);
      controller.BHKType.value = matchedBHK; // optional, if single-select
    }

    final query = widget.searchQuery?.toLowerCase().trim() ?? '';
    for (var type in pController.filterpropertyTypes) {
      if (type.toLowerCase() == query &&
          !controller.selectedPropertyType.contains(type)) {
        controller.selectedPropertyType.add(type);
      }
    }
    for (var furnishType in pController.furnishTypes) {
      if (furnishType.toLowerCase() == query &&
          !controller.selectedFurnishingStatusList.contains(furnishType)) {
        controller.selectedFurnishingStatusList.add(furnishType);
      }
    }
    await controller.getFilterProperty(
        category_price_type:widget.isfrom=="Commercial" || widget.isfrom=="Residential" ||  widget.isfrom=="PG"?"":'',
        // searchKeyword:widget.searchQuery ?? '',
        area:widget.isfrom == "popularCity" ? '' : areaName != '' ? areaName : cityName ,
        city_name: widget.isfrom == "popularCity" ? widget.city : widget.searchQuery,
        bhk_type:controller.selectedBHKTypeList.join(","),
        max_area:controller.areatMax.toString()=='0.0'?'':controller.areatMax.toString(),
        min_area: controller.areaMin.toString()=='0.0'?'':controller.areaMin.toString(),
        // min_price:(controller.budgetMin.value!.toInt() * 100000).toString()=='0'?'':
        // (controller.budgetMin.value!.toInt() * 100000).toString(),
        // max_price:'${(controller.budgetMax.value!.toInt() * 100000)}'=='0'?'':'${(controller.budgetMax.value!.toInt() * 100000)}',
        max_price:controller.budgetMax1.value!=""?"${controller.budgetMax.value.toString()}00000":
        controller.budgetMax1.value.toString(),
        min_price:controller.budgetMin1.value.toString() ,
        amenties:controller.selectAmenities.join(","),
        furnish_status:controller.selectedFurnishingStatusList.join(","),
        property_listed_by: widget.property_listed_by,
        property_category_type: widget.isfrom=="Commercial" || widget.isfrom=="Residential"?controller.lookingFor.join(","): '',
        //property_type:widget.isfrom == 'searchScreen' ? widget.property_type : controller.selectedPropertyType.join(","),
        property_type:widget.isfrom == 'searchScreen' ? controller.selectedPropertyType.isEmpty? widget.property_type:controller.selectedPropertyType.join(",") : controller.selectedPropertyType.join(","),
        page: '1'
    );
    setState(() {
      controller.getMarkers(controller.getFilterData).then((loadedMarkers) {
        setState(() {
          controller.markers = loadedMarkers;
        });
      });
    });
  });

}




void getFilterData1(){
  WidgetsBinding.instance.addPostFrameCallback((_) async{

    pController.bhkTypes.assignAll([
      "Studio", "1 RK", "1 BHK", "1.5 BHK", "2 BHK", "2.5 BHK",
      "3 BHK", "3.5 BHK", "4 BHK", "5 BHK", "6 BHK",
    ]);
    print("popular city ${widget.city}");

    final matchedBHK = widget.searchQuery != null
        ? pController.bhkTypes.firstWhere(
          (bhk) => bhk.toLowerCase() == widget.searchQuery!.toLowerCase(),
      orElse: () => '',
    )
        : '';


    if (matchedBHK.isNotEmpty && !controller.selectedBHKTypeList.contains(matchedBHK)) {
      controller.selectedBHKTypeList.add(matchedBHK);
      controller.BHKType.value = matchedBHK; // optional, if single-select
    }

    final query = widget.searchQuery?.toLowerCase().trim() ?? '';
    for (var type in pController.filterpropertyTypes) {
      if (type.toLowerCase() == query &&
          !controller.selectedPropertyType.contains(type)) {
        controller.selectedPropertyType.add(type);
      }
    }
    for (var furnishType in pController.furnishTypes) {
      if (furnishType.toLowerCase() == query &&
          !controller.selectedFurnishingStatusList.contains(furnishType)) {
        controller.selectedFurnishingStatusList.add(furnishType);
      }
    }
    await controller.getFilterProperty(
        category_price_type:widget.isfrom=="Commercial" || widget.isfrom=="Residential" ||  widget.isfrom=="PG"?"":'',
        // searchKeyword:widget.searchQuery ?? '',
        area:widget.isfrom == "popularCity" ? '' : areaName != '' ? areaName : cityName ,
        city_name: widget.isfrom == "popularCity" ? widget.city : widget.searchQuery,

        bhk_type:controller.selectedBHKTypeList.join(","),
        max_area:controller.areatMax.toString()=='0.0'?'':controller.areatMax.toString(),
        min_area: controller.areaMin.toString()=='0.0'?'':controller.areaMin.toString(),
        // min_price:(controller.budgetMin.value!.toInt() * 100000).toString()=='0'?'':
        // (controller.budgetMin.value!.toInt() * 100000).toString(),
        // max_price:'${(controller.budgetMax.value!.toInt() * 100000)}'=='0'?'':'${(controller.budgetMax.value!.toInt() * 100000)}',
        max_price:controller.budgetMax1.value!=""?"${controller.budgetMax.value.toString()}00000":
        controller.budgetMax1.value.toString(),
        min_price:controller.budgetMin1.value.toString() ,
        amenties:controller.selectAmenities.join(","),
        furnish_status:controller.selectedFurnishingStatusList.join(","),
        property_listed_by: widget.property_listed_by,
        property_category_type: widget.isfrom=="Commercial" || widget.isfrom=="Residential"?controller.lookingFor.join(","): '',
        property_type:widget.isfrom == 'searchScreen' ? controller.selectedPropertyType.isEmpty? widget.property_type:controller.selectedPropertyType.join(",") : controller.selectedPropertyType.join(","),
        page: '1'
    );
    setState(() {
      controller.getMarkers(controller.getFilterData).then((loadedMarkers) {
        setState(() {
          controller.markers = loadedMarkers;
        });
      });
    });
  });

}
  @override
  void dispose() {

    _Controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  String _currentAddress = 'Fetching location...';
  bool isLoading = false; // Add a loading state variable
  bool isFetchingLocation = false;



  @override
  Widget build(BuildContext context)  {
    print(_currentAddress);
    return Scaffold(
      bottomNavigationBar: continueButtons(context),
      appBar:AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            customIconButton(
              icon: Icons.arrow_back,
              onTap: () {

                if(widget.isfrom == 'map search'){
                  Get.to(() => FilterListScreen(
                    isFrom: 'FilterSearch',
                    searchKeyword: _Controller.text?? '',
                    area:widget.isfrom == "popularCity" ? '' : areaName != "" ? areaName : cityName,
                    category_price_type:widget.isfrom=="Commercial" || widget.isfrom=="Residential" ||  widget.isfrom=="PG"?"":widget.isfrom,
                    city_name: widget.isfrom == "popularCity" ? widget.city ?? '' : cityName ?? '',
                    bhk_type:controller.selectedBHKTypeList.join(","),
                    max_area:controller.areatMax.toString()=='0.0'?'':controller.areatMax.toString(),
                    min_area: controller.areaMin.toString()=='0.0'?'':controller.areaMin.toString(),
                    // min_price:(controller.budgetMin.value!.toInt() * 100000).toString()=='0'?'':
                    // (controller.budgetMin.value!.toInt() * 100000).toString(),
                    // max_price:'${(controller.budgetMax.value!.toInt() * 100000)}'=='0'?'':'${(controller.budgetMax.value!.toInt() * 100000)}',
                    max_price:controller.budgetMax1.value!=""?"${controller.budgetMax.value.toString()}00000":
                    controller.budgetMax1.value.toString(),
                    min_price:controller.budgetMin1.value.toString() ,
                    amenties:controller.selectAmenities.join(","),
                    furnish_status:controller.selectedFurnishingStatusList.join(","),
                    property_listed_by: widget.property_listed_by ?? '',
                    property_category_type: widget.isfrom=="Commercial" || widget.isfrom=="Residential"?controller.lookingFor.join(","): widget.category_type??'',
                    property_type:widget.isfrom == 'searchScreen' ? controller.selectedPropertyType.isEmpty? widget.property_type:controller.selectedPropertyType.join(",") : controller.selectedPropertyType.join(","),
                  ));
                }else{

                  controller.ClearData();
                  controller.budgetMin.value = null;
                  controller.selectedFurnishingStatusList.clear();
                  controller.budgetMax.value = null;
                  controller.isClear.value =true;
                  controller.budgetMin1.value = "";
                  controller.budgetMax1.value = "";
                  getFilterData1();


                  Navigator.pop(context);
                }


                // Get.to(() => FilterListScreen(
                //   isFrom: 'FilterSearch',
                //   searchKeyword: _Controller.text?? '',
                //   area:widget.isfrom == "popularCity" ? '' : areaName != "" ? areaName : cityName,
                //   category_price_type:widget.isfrom=="Commercial" || widget.isfrom=="Residential" ||  widget.isfrom=="PG"?"":widget.isfrom,
                //   city_name: widget.isfrom == "popularCity" ? widget.city ?? '' : cityName ?? '',
                //   bhk_type:controller.selectedBHKTypeList.join(","),
                //   max_area:controller.areatMax.toString()=='0.0'?'':controller.areatMax.toString(),
                //   min_area: controller.areaMin.toString()=='0.0'?'':controller.areaMin.toString(),
                //   // min_price:(controller.budgetMin.value!.toInt() * 100000).toString()=='0'?'':
                //   // (controller.budgetMin.value!.toInt() * 100000).toString(),
                //   // max_price:'${(controller.budgetMax.value!.toInt() * 100000)}'=='0'?'':'${(controller.budgetMax.value!.toInt() * 100000)}',
                //   max_price:controller.budgetMax1.value!=""?"${controller.budgetMax.value.toString()}00000":
                //   controller.budgetMax1.value.toString(),
                //   min_price:controller.budgetMin1.value.toString() ,
                //   amenties:controller.selectAmenities.join(","),
                //   furnish_status:controller.selectedFurnishingStatusList.join(","),
                //   property_listed_by: widget.property_listed_by ?? '',
                //   property_category_type: widget.isfrom=="Commercial" || widget.isfrom=="Residential"?controller.lookingFor.join(","): widget.category_type??'',
                //   property_type:widget.isfrom == 'searchScreen' ? widget.property_type : controller.selectedPropertyType.join(","),
                // ));

              },
            ),
            const Text("Filter",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
            GestureDetector(
              onTap: (){
                controller.ClearData();
                controller.budgetMin.value = null;
                controller.selectedFurnishingStatusList.clear();
                controller.budgetMax.value = null;
                controller.isClear.value =true;
                controller.budgetMin1.value = "";
                controller.budgetMax1.value = "";
                getFilterData1();
              },
              //  {"city_name":"Pune","bhk_type":"1 BHK,2 BHK","category_price_type":"popularCity","page":"1","page_size":"10"}
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.white.withOpacity(0.7),
                  border: Border.all(
                    color: Colors.black.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Clear All",style: TextStyle(color: Colors.black,fontSize: 13),),

                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: Obx(() {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(widget.isfrom == 'map search')...[
                  ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 35),
                    child: GooglePlaceAutoCompleteTextField(
                      textEditingController: _Controller,
                      focusNode: _focusNode,
                     // googleAPIKey: 'AIzaSyDY-oB0QysTXFJu2cOMlZvpwANBR2XS84E',
                      googleAPIKey: 'AIzaSyAt8bj4UACvakZfiSy-0c1o_ivfplm7jEU',
                      inputDecoration: InputDecoration(
                        hintText: "Select City",
                        prefixIcon: const Icon(Icons.search),
                        contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      debounceTime: 800,
                      countries: ["in"],
                      isLatLngRequired: true,
                      getPlaceDetailWithLatLng: (prediction) async {
                        if (prediction != null) {
                          final location = prediction.description;
                          print("Selected place: $location");

                          try {
                            final String googleApiKey = 'AIzaSyDY-oB0QysTXFJu2cOMlZvpwANBR2XS84E';
                            final String placeId = prediction.placeId!;
                            final String placeDetailsUrl =
                                'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=address_components&key=$googleApiKey';

                            final response = await http.get(Uri.parse(placeDetailsUrl));
                            if (response.statusCode == 200) {
                              final data = json.decode(response.body);
                              if (data['status'] == 'OK') {
                                final addressComponents = data['result']['address_components'] as List<dynamic>;
                                String? cityname;
                                String? areaname;

                                for (var component in addressComponents) {
                                  final types = component['types'] as List<dynamic>;
                                  if (types.contains('locality')) {
                                    cityname = component['long_name'];
                                  } else if (types.contains('administrative_area_level_2')) {
                                    cityname ??= component['long_name'].split(' ').first;
                                  }
                                  if (types.contains('sublocality') ||
                                      types.contains('sublocality_level_1') ||
                                      types.contains('neighborhood')) {
                                    areaname = component['long_name'];
                                  }
                                }

                                if (cityname != null) {
                                  print("City name: $cityname");
                                  print("Area name: ${areaname ?? 'Not found'}");

                                  WidgetsBinding.instance.addPostFrameCallback((_) async{
                                    setState(() {
                                      cityName = cityname ?? '';
                                      areaName = areaname ?? '';
                                      print('updated city : $cityName');
                                      print('updated area : $areaName');
                                    });
                                  });

                                  await getData();
                                } else {
                                  print("City name not found in address components");
                                }
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
                        try {
                          _Controller.text = prediction.description!;
                          _Controller.selection = TextSelection.fromPosition(
                            TextPosition(offset: _Controller.text.length),
                          );
                        } catch (e) {
                          print("Error setting text selection: $e");
                        }
            setState(() {});
                      },
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Divider(),
                  const SizedBox(height: 5),
                ],

                Text(
                  propertyType,
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.black.withOpacity(0.7),
                      fontWeight: FontWeight.normal),
                ),
                const SizedBox(height: 8.0),
                Wrap(
                  children: pController.filterpropertyTypes
                      .map((propertyType) =>
                      PropertyType(propertyType))
                      .toList(),
                ),
                const Divider(thickness: 1.0),


                Text(
                  "Select BHK",
                  style: TextStyle(
                      fontSize: 15,
                      color: AppColor.black.withOpacity(0.7),
                      fontWeight: FontWeight.normal),
                ),
                const SizedBox(height: 8.0),
                Wrap(
                  children:
                  pController.bhkTypes.map((bhk) => bhkOption(bhk)).toList(),
                ),
                const Divider(thickness: 1.0),


                Text(
                  rbudget,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: AppColor.black.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 8.0),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.grey.shade300, width: 1.0),
                        ),
                        child:DropdownButton<int>(
                          value: controller.budgetMin.value,
                          hint: const Text("Min Budget"),
                          items: controller.budgetOptions.map((option) {
                            final max = controller.budgetMax.value;
                            final isEnabled = max == null || option['value'] < max;
                            return DropdownMenuItem<int>(
                              value: option['value'],
                              enabled: isEnabled,
                              child: Text(
                                option['label'],
                                style: TextStyle(color: isEnabled ? Colors.black : Colors.grey),
                              ),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            if (newValue != null &&
                                (controller.budgetMax.value == null || newValue < controller.budgetMax.value!)) {
                              controller.budgetMin.value = newValue;
                              final selected = controller.budgetOptions.firstWhere((e) => e['value'] == newValue);
                              controller.budgetMin1.value = convertLabelToNumberString(selected['label']);
                              getFilterData();
                            }
                          },
                          isExpanded: true,
                          underline: const SizedBox(),
                        ),



                        // DropdownButton<int>(
                        //   value: controller.budgetMin.value,
                        //   items: controller.budgetOptions.map((option) {
                        //     return DropdownMenuItem<int>(
                        //       value: option['value'],
                        //       child: Text(option['label']),
                        //     );
                        //   }).toList(),
                        //   onChanged: (newValue) {
                        //     if (newValue != null && newValue <= controller.budgetMax.value) {
                        //       controller.budgetMin.value = newValue;
                        //       final selectedOption = controller.budgetOptions.firstWhere((e) => e['value'] == newValue);
                        //       controller.budgetMin1.value = convertLabelToNumberString(selectedOption['label']);
                        //       filtterData();
                        //     }
                        //   },
                        //   hint: const Text("Min Budget"),
                        //   isExpanded: true,
                        //   style: const TextStyle(color: Colors.black, fontSize: 14),
                        //   underline: const SizedBox(),
                        // ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.grey.shade300, width: 1.0),
                        ),
                        child:DropdownButton<int>(
                          value: controller.budgetMax.value,
                          hint: const Text("Max Budget"),
                          items: controller.budgetOptions.map((option) {
                            final min = controller.budgetMin.value;
                            final isEnabled = min == null || option['value'] > min;
                            return DropdownMenuItem<int>(
                              value: option['value'],
                              enabled: isEnabled,
                              child: Text(
                                option['label'],
                                style: TextStyle(color: isEnabled ? Colors.black : Colors.grey),
                              ),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            if (newValue != null &&
                                (controller.budgetMin.value == null || newValue > controller.budgetMin.value!)) {
                              controller.budgetMax.value = newValue;
                              final selected = controller.budgetOptions.firstWhere((e) => e['value'] == newValue);
                              controller.budgetMax1.value = convertLabelToNumberString(selected['label']);
                              getFilterData();
                            }
                          },
                          isExpanded: true,
                          underline: const SizedBox(),
                        ),

                      ),
                    ),
                  ],
                ),
                const Divider(thickness: 1.0),

                boxH05(),


                Text(
                  "Select Furnishing",
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.black.withOpacity(0.7),
                      fontWeight: FontWeight.normal),
                ),
                boxH05(),

                Wrap(
                  spacing: 8,
                  children: pController.furnishTypes.map((furnishType) {
                    return ChoiceChip(
                      label: Text(furnishType),
                      labelStyle: TextStyle(
                        color: controller.selectedFurnishingStatusList.contains(furnishType)
                            ? AppColor.primaryThemeColor
                            : Colors.black.withOpacity(0.7),
                      ),
                      selected: controller.selectedFurnishingStatusList.contains(furnishType),
                      selectedColor: AppColor.primaryThemeColor.withOpacity(0.2),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            controller.selectedFurnishingStatusList.add(furnishType);
                          } else {
                            controller.selectedFurnishingStatusList.remove(furnishType);
                          }
                          getFilterData();
                        });
                      },
                      showCheckmark: false,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      side: BorderSide(
                        color: controller.selectedFurnishingStatusList.contains(furnishType)
                            ? Colors.white
                            : Colors.grey.withOpacity(0.3),
                        width: 0.8,
                      ),
                    );
                  }).toList(),
                ),

                //    Divider()
              ],
            );
          }),
        ),
      ),
    );
  }
  String convertLabelToNumberString(String label) {
    final cleanedLabel = label.replaceAll('₹', '').trim().toLowerCase();

    if (cleanedLabel.contains('lakh')) {
      final number = double.parse(cleanedLabel.split('lakh')[0].trim());
      return (number * 100000).toInt().toString();
    } else if (cleanedLabel.contains('crore')) {
      final number = double.parse(cleanedLabel.split('crore')[0].trim());
      return (number * 10000000).toInt().toString();
    } else {
      return '0'; // fallback if format not matched
    }
  }
  Widget continueButtons(BuildContext context) {
    return Container(
      decoration: BoxDecoration(

        border: Border.all(
          color:
          Colors.grey.shade300,
        ),
        borderRadius: BorderRadius.circular(0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            controller.isLoading.value ? const CircularProgressIndicator() :
            Text(controller.isClear.value==true?"0 Property":"${controller.total_count.value} Properties",style: const TextStyle(
                color: AppColor.black,fontSize: 18,fontWeight: FontWeight.bold
            ),),

            // Search Button
            SizedBox(
                width: 150,
                height: 50,
                child:commonButton(
                  text: "Filter",
                  onPressed: () {
                    print('pass city name to FilterListScreen ===> ${controller.city}');

                    // Get.to(() => FilterListScreen(
                    //   isFrom: 'FilterSearch',
                    //   searchKeyword: _Controller.text?? '',
                    //   area:widget.isfrom == "popularCity" ? '' : areaName != "" ? areaName : cityName,
                    //   category_price_type:widget.isfrom=="Commercial" || widget.isfrom=="Residential" ||  widget.isfrom=="PG"?"":widget.isfrom,
                    //   city_name: widget.isfrom == "popularCity" ? widget.city ?? '' : cityName ?? '',
                    //   bhk_type:controller.selectedBHKTypeList.join(","),
                    //   max_area:controller.areatMax.toString()=='0.0'?'':controller.areatMax.toString(),
                    //   min_area: controller.areaMin.toString()=='0.0'?'':controller.areaMin.toString(),
                    //   // min_price:(controller.budgetMin.value!.toInt() * 100000).toString()=='0'?'':
                    //   // (controller.budgetMin.value!.toInt() * 100000).toString(),
                    //   // max_price:'${(controller.budgetMax.value!.toInt() * 100000)}'=='0'?'':'${(controller.budgetMax.value!.toInt() * 100000)}',
                    //   max_price:controller.budgetMax1.value!=""?"${controller.budgetMax.value.toString()}00000":
                    //   controller.budgetMax1.value.toString(),
                    //   min_price:controller.budgetMin1.value.toString() ,
                    //   amenties:controller.selectAmenities.join(","),
                    //   furnish_status:controller.selectedFurnishingStatusList.join(","),
                    //   property_listed_by: widget.property_listed_by ?? '',
                    //   property_category_type: widget.isfrom=="Commercial" || widget.isfrom=="Residential"?controller.lookingFor.join(","):
                    //   widget.category_type??'',
                    //   property_type:widget.isfrom == 'searchScreen' ? widget.property_type : controller.selectedPropertyType.join(","),
                    // ));


                    if(widget.isfrom == 'map search'){
                      Get.to(() => FilterListScreen(
                        isFrom: 'FilterSearch',
                        searchKeyword: _Controller.text?? '',
                        area:widget.isfrom == "popularCity" ? '' : areaName != "" ? areaName : cityName,
                        category_price_type:widget.isfrom=="Commercial" || widget.isfrom=="Residential" ||  widget.isfrom=="PG"?"":widget.isfrom,
                        city_name: widget.isfrom == "popularCity" ? widget.city ?? '' : cityName ?? '',
                        bhk_type:controller.selectedBHKTypeList.join(","),
                        max_area:controller.areatMax.toString()=='0.0'?'':controller.areatMax.toString(),
                        min_area: controller.areaMin.toString()=='0.0'?'':controller.areaMin.toString(),
                        // min_price:(controller.budgetMin.value!.toInt() * 100000).toString()=='0'?'':
                        // (controller.budgetMin.value!.toInt() * 100000).toString(),
                        // max_price:'${(controller.budgetMax.value!.toInt() * 100000)}'=='0'?'':'${(controller.budgetMax.value!.toInt() * 100000)}',
                        max_price:controller.budgetMax1.value!=""?"${controller.budgetMax.value.toString()}00000":
                        controller.budgetMax1.value.toString(),
                        min_price:controller.budgetMin1.value.toString() ,
                        amenties:controller.selectAmenities.join(","),
                        furnish_status:controller.selectedFurnishingStatusList.join(","),
                        property_listed_by: widget.property_listed_by ?? '',
                        property_category_type: widget.isfrom=="Commercial" || widget.isfrom=="Residential"?controller.lookingFor.join(","):
                        widget.category_type??'',
                        property_type:widget.isfrom == 'searchScreen' ? controller.selectedPropertyType.isEmpty? widget.property_type:controller.selectedPropertyType.join(",") : controller.selectedPropertyType.join(","),
                      ));
                    }else{
                      controller.getFilterProperty(
                          property_category_type: widget.isfrom=="Commercial" || widget.isfrom=="Residential"?controller.lookingFor.join(","):
                          widget.category_type??'',
                          category_price_type:widget.isfrom=="Commercial" || widget.isfrom=="Residential" ||  widget.isfrom=="PG"?"":widget.isfrom,
                          property_listed_by: widget.property_listed_by ?? '',
                          city_name: widget.isfrom == "popularCity" ? widget.city : widget.searchQuery,

                          // searchKeyword: _Controller.text?? '',
                          isFrom: 'filterScreen',
                          bhk_type:controller.selectedBHKTypeList.join(","),
                          max_area:controller.areatMax.toString()=='0.0'?'':controller.areatMax.toString(),
                          min_area: controller.areaMin.toString()=='0.0'?'':controller.areaMin.toString(),
                          // min_price:(controller.budgetMin.value!.toInt() * 100000).toString()=='0'?'':
                          // (controller.budgetMin.value!.toInt() * 100000).toString(),
                          // max_price:'${(controller.budgetMax.value!.toInt() * 100000)}'=='0'?'':'${(controller.budgetMax.value!.toInt() * 100000)}',
                          max_price:controller.budgetMax1.value!=""?"${controller.budgetMax.value.toString()}00000":
                          controller.budgetMax1.value.toString(),
                          min_price:controller.budgetMin1.value.toString() ,
                          furnish_status:controller.selectedFurnishingStatusList.join(","),
                          // property_type:widget.isfrom == 'searchScreen' ?
                          // widget.property_type : controller.selectedPropertyType.join(","),
                          property_type:widget.isfrom == 'searchScreen' ? controller.selectedPropertyType.isEmpty? widget.property_type:controller.selectedPropertyType.join(",") : controller.selectedPropertyType.join(","),
                          page: '1'
                      ).then((value) => Get.back());
                      if(isLogin==true){
                        //controller.addSearchName(name: widget.data);
                      }
                    }



                  },
                )

            ),
          ],
        )),
      ),
    );
  }

  Widget bhkOption(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Obx(() => ChoiceChip(
        label: Text(text),
        labelStyle: TextStyle(
          color: controller.selectedBHKTypeList.contains(text)
              ? AppColor.primaryThemeColor
              : Colors.black.withOpacity(0.7),
        ),
        selected: controller.BHKType.value == text ||
            controller.selectedBHKTypeList.contains(text),
        onSelected: (isSelected) {
          if (isSelected) {
            if (text == controller.BHKType.value) {
              return;
            }
            controller.selectedBHKTypeList.add(text);
          } else {
            controller.selectedBHKTypeList.remove(text);
            if (controller.BHKType.value == text) {
              controller.BHKType.value = "";
            }
          }
          getFilterData();
        },
        showCheckmark: false,
        side: BorderSide(
            color: controller.selectedBHKTypeList.contains(text)
                ? Colors.white
                : Colors.grey.withOpacity(0.3),
            width: 0.8),
        selectedColor: AppColor.primaryThemeColor.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // Circular corners
        ),

      )),
    );
  }

  Widget categoryType(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Obx(() => ChoiceChip(
        label: Text(text),
        selected: controller.selectedLocation.value == text ||
            controller.lookingFor.contains(text),
        onSelected: (isSelected) {
          if (isSelected) {
            if (text == controller.selectedLocation.value) {
              return;
            }
            controller.lookingFor.add(text);
          } else {
            controller.lookingFor.remove(text);
            if (controller.selectedLocation.value == text) {
              controller.selectedLocation.value = "";
            }
          }
        },
        labelStyle: TextStyle(
          color: controller.selectedLocation.value == text
              ? AppColor.blue
              : Colors.black.withOpacity(0.7),
        ),
        selectedColor: Colors.blue.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
              color: controller.selectedLocation.value == text
                  ? AppColor.blue
                  : Colors.grey.withOpacity(0.3),
              width: 0.8),
        ),
      )),
    );
  }

  Widget amenitiesType(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Obx(() => ChoiceChip(
        label: Text(text),
        labelStyle: TextStyle(
          color: controller.selectedLocation.value == text
              ? AppColor.blue
              : Colors.black.withOpacity(0.7),
        ),
        selected: controller.selectAmenities.contains(text),
        onSelected: (isSelected) {
          if (isSelected) {
            controller.selectAmenities.add(text);
          } else {
            controller.selectAmenities.remove(text);
          }
        },
        selectedColor: Colors.blue.withOpacity(0.3),
        side: BorderSide(
            color: controller.selectedLocation.value == text
                ? AppColor.blue
                : Colors.grey.withOpacity(0.3),
            width: 0.8),
      )),
    );
  }

  Widget PropertyType(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Obx(() => ChoiceChip(
        label: Text(text),
        labelStyle: TextStyle(
          color: controller.selectedPropertyType.contains(text)
              ? AppColor.primaryThemeColor
              : Colors.black.withOpacity(0.7),
        ),
        selected: controller.selectedPropertyType.contains(text),
        onSelected: (isSelected) {
          if (isSelected) {
            controller.selectedPropertyType.add(text);
          } else {
            controller.selectedPropertyType.remove(text);
          }
          getFilterData();
        },
        selectedColor: AppColor.primaryThemeColor.withOpacity(0.3),
        showCheckmark: false,
        side: BorderSide(
            color: controller.selectedPropertyType.contains(text)
                ? Colors.white : Colors.grey.withOpacity(0.3),
            width: 0.8
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      )),
    );
  }


}
