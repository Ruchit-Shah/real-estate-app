import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:real_estate_app/Routes/app_pages.dart';
import 'package:real_estate_app/common_widgets/custom_textformfield.dart';
import 'package:real_estate_app/common_widgets/dialog_util.dart';
import 'package:real_estate_app/common_widgets/height.dart';
import 'package:real_estate_app/global/AppBar.dart';
import 'package:real_estate_app/global/app_color.dart';
import 'package:real_estate_app/global/constant.dart';
import 'package:real_estate_app/utils/String_constant.dart';
import 'package:real_estate_app/utils/shared_preferences/shared_preferances.dart';
import 'package:real_estate_app/view/auth/login_bottom_sheet/login_bottom_sheet.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/view/subscription%20model/Subscription_Screen.dart';

import '../../../global/api_string.dart';
import '../../dashboard/bottom_navbar_screens/profile_screen/profile_controller.dart';
import '../../dashboard/bottom_navbar_screens/profile_screen/profile_section_screens/Listing/listing_screen.dart';
import '../../dashboard/deshboard_controllers/bottom_bar_controller.dart';
import '../../dashboard/view/BottomNavbar.dart';
import '../properties_controllers/post_property_controller.dart';
import 'mapLocationSelection.dart';

class edit_property_screen extends StatefulWidget {
  final data;
  const edit_property_screen({Key? key, required this.data}) : super(key: key);

  @override
  State<edit_property_screen> createState() => _edit_property_screenState();
}

class _edit_property_screenState extends State<edit_property_screen> with SingleTickerProviderStateMixin {

  late TabController _tabController;
  final _BasicformKey = GlobalKey<FormState>();
  final PostPropertyController controller = Get.put(PostPropertyController());
  final bottomBarController = Get.put(BottomBarController());

  String isfeature='';
 @override
  void initState() {
    super.initState();
    setData();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(_handleTabSelection);
    controller.getAmenities();
    controller.getPropertyImage(id: widget.data['_id']);
  }

  setData(){
   ///property for
    controller.categorytype.value = widget.data['property_category_type'];
    controller.categorytype.value=='Residential'?
    controller.categorySelected.value=1 :controller.categorySelected.value=0;

    ///looking for
    controller.CategoryPriceType.value = widget.data['category_price_type'];
    controller.CategoryPriceType.value=='Sell'?
    controller.categoryPriceselected.value=0 :
    controller.CategoryPriceType.value=='Rent'?
    controller.categoryPriceselected.value=1 :
    controller.categoryPriceselected.value=2 ;

    ///Locality
    controller.address = widget.data['address'];

    ///city
    controller.cityValue = widget.data['city_name'];
    controller.pinCodeController.text = widget.data['zip_code'];

    //"zip_code": pinCodeController.text??'',

    ///property type
    controller.propertytype.value = widget.data['property_type'];
    if( controller.categorytype.value=='Residential'){
      controller.propertytype.value=='Apartment' ? controller.selectedProperty.value=0:
      controller.propertytype.value=='Plot' ? controller.selectedProperty.value=1:
      controller.propertytype.value=='Flat' ? controller.selectedProperty.value=2:
      controller.propertytype.value=='Independent House' ? controller.selectedProperty.value=3:
      controller.propertytype.value=='Villa' ? controller.selectedProperty.value=4:
      controller.propertytype.value=='Vacation Home' ? controller.selectedProperty.value=5:
      controller.propertytype.value=='Hostel' ? controller.selectedProperty.value=6:
     controller.selectedProperty.value=7;
    }else{
      controller.propertytype.value=='Office' ? controller.selectedProperty.value=0:
      controller.propertytype.value=='Plot' ? controller.selectedProperty.value=1:
      controller.propertytype.value=='Retail Shop' ? controller.selectedProperty.value=2:
      controller.propertytype.value=='Warehouse' ? controller.selectedProperty.value=3:
      controller.selectedProperty.value=4;
    }

    ///property name
    controller.propertyNameController.text = widget.data['property_name'];

    ///property description
    controller.propertyDescriptionController.text = widget.data['property_description'];

    ///sq.fit area
    controller.buildUpAreaController.text = widget.data['area_sq'];

    ///Total floor
    controller.totalFloorController.text = widget.data['total_floor'];

    ///unit
    controller.UnitController.text = widget.data['units'];

    ///Property floor
    controller.propertyFloorController.text = widget.data['property_floor'];

    ///Bathroom type
    controller.bathroomType.value = widget.data['bathroom_type'];

    ///Bhk type
    controller.bhkType.value = widget.data['bhk_type'];
    controller.bhkType.value=='Single Room'?
    controller.selectedBhk.value=0 :
    controller.bhkType.value=='1 RK'?
    controller.selectedBhk.value=1 :
    controller.bhkType.value=='1 BHK'?
    controller.selectedBhk.value=2 :
    controller.bhkType.value=='2 BHK'?
    controller.selectedBhk.value=3 :
    controller.bhkType.value=='3 BHK'?
    controller.selectedBhk.value=4 :
     controller.selectedBhk.value=5 ;

    ///furninshing Type
    controller.furnishType.value = widget.data['furnished_type'];
    controller.furnishType.value=='Furnished'?
    controller.selectedFurnished.value=0 :
    controller.furnishType.value=='Unfurnished'?
    controller.selectedFurnished.value=1 :
    controller.selectedFurnished.value=2 ;

    ///cover Image
    controller.coverImage.value = widget.data['cover_image'];

    /// is security
    widget.data['security'] == 'Yes' ?  controller.isSecurity =  true :  controller.isSecurity =  false;

    /// is featured
    widget.data['mark_as_featured'] == 'Yes' ?  controller.isFeatured.value =  true :  controller.isFeatured.value =  false;

    /// Amenities
    controller.amenitiesString = widget.data['amenities'];
    controller.selectedamenities.addAll(controller.amenitiesString.split(','));

    ///price deatils
    controller.propertyPriceController.text = widget.data['property_price'];
    controller.propertyPrice.value = widget.data['property_price'];
    controller.securityDepositController.text = widget.data['safety_deposit'];
    controller.availableFrom.value = widget.data['available_on_date'];
    controller.expiryOn.value = widget.data['expiry_date'];
    controller.expieyController.text = widget.data['expiry_date'];

    ///lat and long
    controller.lat = widget.data['latitude'];
    controller.long = widget.data['longitude'];


  }

  planData() async {

    String isFeature= (await SPManager.instance.getFeaturedProperties(FeaturedProperties))??"no";
    int? featuredCount= (await SPManager.instance.getFeatureCount(PAID_FEATURE))??0;
    int? PlanfeaturedCount= (await SPManager.instance.getPlanFeatureCount(PLAN_FEATURE))??0;

    if(isFeature=='no'){
      setState(() {
        isfeature ='no';
      });
    }else{
      if(featuredCount < PlanfeaturedCount){
        setState(() {
          isfeature ='yes';
        });
      }else {
        setState(() {
          isfeature ='no_limit';
        });
      }
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  void _onContinuePressed() {
    if (_tabController.index == 0) {
      if (controller.validateBasicDetails()) {
        print("Basic details are valid. Moving to the next tab...");
        _tabController.animateTo(_tabController.index + 1);
      } else {
        print("Basic details are not valid. Please correct them.");
      }
    }
    else if (_tabController.index == 1) {
      if (controller.validatePropertyDetails()) {
        print("Property details are valid. Moving to the next tab...");
        _tabController.animateTo(_tabController.index + 1);
      } else {
        print("Property details are not valid. Please correct them.");
      }
    }
    else if (_tabController.index == 2) {
      if (controller.validateAmenities()) {
        print("Property details are valid. Moving to the next tab...");
        _tabController.animateTo(_tabController.index + 1);
      } else {
        print("Property details are not valid. Please correct them.");
      }
    }
    else if (_tabController.index == 3) {
      if (controller.validatePrice()) {
        print("Property details are valid. Moving to the next tab...");
        _tabController.animateTo(_tabController.index + 1);
        controller.editProperty(property_id: widget.data['_id']);
      } else {
        print("Property details are not valid. Please correct them.");
      }
    }
    else {

    }
  }


  void _handleTabSelection() {
    setState(() {

    });
  }

  void _onCountryChange(CountryCode countryCode) {
    controller.currentCountryCode = countryCode.code! + "-" + countryCode.toString().replaceAll("+", "");
  }

  Future<bool> _onWillPop() async {
    if (_tabController.index > 0) {
      setState(() {
        _tabController.index -= 1;
      });
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: AppColor.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Edit Property",style: TextStyle(fontSize: 17,color: Colors.white,fontWeight: FontWeight.bold),),
          //  backgroundColor: AppColor.grey.withOpacity(0.1),
          backgroundColor:Colors.blueGrey,

        ),
        body: Column(
          children: [


            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
                color: Colors.blueGrey, // Example color
                border: Border.all(color: AppColor.backgroundColor),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TabBar(
                  isScrollable: true,
                  controller: _tabController,
                  indicatorWeight: 0,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColor.primaryColor),
                    color: Colors.blueGrey.shade50,
                  ),
                  unselectedLabelColor: Colors.white,
                  labelColor: Colors.blueGrey,
                  dividerColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  unselectedLabelStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  labelStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                  onTap: (index) {

                  },
                  tabs: const [
                    Tab(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text("Basic Details", textAlign: TextAlign.center),
                      ),
                    ),
                    Tab(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text("Property Details", textAlign: TextAlign.center),
                      ),
                    ),
                    Tab(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text("Add Amenities", textAlign: TextAlign.center),
                      ),
                    ),
                    Tab(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text("Price Details", textAlign: TextAlign.center),
                      ),
                    ),
                    Tab(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text("Add Images", textAlign: TextAlign.center),
                      ),
                    ),
                  ],
                ),
              ),

            ),

            Expanded(
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _tabController,
                children: [
                  BasicDetailsTab(),
                  PropertyDetailsTab(),
                  AddAmenitiesTab(),
                  PriceDetailsTab(),
                  AddImagesTab(),

                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_tabController.index != _tabController.length - 1)
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: TextButton(
                    onPressed: _onContinuePressed,
                    child: const Text(
                      'Continue',
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                  ),
                ),
              if (_tabController.index == _tabController.length - 1)
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: TextButton(
                    onPressed: (){
                      bottomBarController.selectedBottomIndex.value = 4;
                      Get.off(() => const BottomNavbar());
                    },
                    child: const Text(
                      'Update Property',
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget BasicDetailsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Form(
        key: _BasicformKey,
        child: Container(

          color: AppColor.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(),
              Center(
                child: Text(
                  'Basic Details',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColor.black.withOpacity(0.6),
                  ),
                ),
              ),

              const Divider(),

              boxH15(),

              // boxH05(),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
              //   child: Text(
              //     'You Are',
              //     style: TextStyle(
              //       fontSize: 14,
              //       color: AppColor.black.withOpacity(0.6),
              //     ),
              //   ),
              // ),
              // boxH08(),
              // SizedBox(
              //   height: MediaQuery.of(context).size.width * 0.1,
              //   width: MediaQuery.of(context).size.width,
              //   child: ListView.builder(
              //     scrollDirection: Axis.horizontal,
              //     itemCount: controller.categoryOwnerType.length,
              //     itemBuilder: (context, index) {
              //       bool isSelected = controller.selected == index;
              //       return GestureDetector(
              //           onTap: () async {
              //
              //             setState(() {
              //               controller.selected.value = index;
              //               controller.propertyOwnerType.value = controller.categoryOwnerType[index];
              //
              //               print(controller.categoryOwnerType[index]);
              //             });
              //           },
              //           child: Container(
              //             margin:const EdgeInsets.symmetric(horizontal: 6.0),
              //             padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
              //             decoration: BoxDecoration(
              //               color: isSelected ? AppColor.blue.shade50 : AppColor.white,
              //               border: Border.all(
              //                 color: isSelected ? AppColor.blue : AppColor.grey[400]!,
              //               ),
              //               borderRadius: BorderRadius.circular(15),
              //             ),
              //             child: Row(
              //               mainAxisAlignment: MainAxisAlignment.center,
              //               crossAxisAlignment: CrossAxisAlignment.center,
              //               children: [
              //                 Center(
              //                   child: Text(
              //                     controller.categoryOwnerType[index],
              //                     style: TextStyle(
              //                       color: isSelected ? AppColor.blue.withOpacity(0.9) : AppColor.black.withOpacity(0.6),
              //                       fontSize: 14,
              //                     ),
              //                   ),
              //                 ),
              //               ],
              //             ),
              //           )
              //       );
              //     },
              //   ),
              // ),
              // boxH15(),

              Text(
                "Property For",
                style: TextStyle(
                  fontSize: 15,
                  color: AppColor.black.withOpacity(0.6),
                ),
              ),
              boxH08(),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.1,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.categoryType.length,
                  itemBuilder: (context, index) {
                    bool categoryIsSelected = controller.categorySelected.value == index;
                    return GestureDetector(
                      onTap: () async {
                        setState(() {
                          controller.categorySelected.value = index;
                          controller.categorytype.value = controller.categoryType[index];

                          print(controller.categoryType[index]);


                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        margin: EdgeInsets.symmetric(horizontal: 6.0),
                        padding:
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
                        decoration: BoxDecoration(
                          color: categoryIsSelected
                              ? AppColor.blue.shade50
                              : AppColor.white,
                          border: Border.all(
                            color: categoryIsSelected
                                ? AppColor.blue
                                : AppColor.grey[400]!,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Center(
                              child: Text(
                                controller.categoryType[index],
                                style: TextStyle(
                                  color: categoryIsSelected
                                      ? AppColor.blue.withOpacity(0.9)
                                      : AppColor.black.withOpacity(0.6),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              boxH15(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'Looking to',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColor.black.withOpacity(0.6),
                  ),
                ),
              ),
              boxH08(),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.1,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.categorytype.value=='Residential'?controller.categoryPriceType.length :
                  controller.categoryPriceType.length,
                  itemBuilder: (context, index) {
                    bool isSelected = controller.categoryPriceselected == index;
                    return GestureDetector(
                        onTap: () async {

                          setState(() {
                            controller.categoryPriceselected.value = index;
                            controller.CategoryPriceType.value = controller.categoryPriceType[index];

                            print(controller.categoryPriceType[index]);
                          });
                        },
                        child: Container(
                          margin:const EdgeInsets.symmetric(horizontal: 6.0),
                          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColor.blue.shade50 : AppColor.white,
                            border: Border.all(
                              color: isSelected ? AppColor.blue : AppColor.grey[400]!,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(
                                child: Text(
                                  controller.categoryPriceType[index],
                                  style: TextStyle(
                                    color: isSelected ? AppColor.blue.withOpacity(0.9) : AppColor.black.withOpacity(0.6),
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                    );
                  },
                ),
              ),

              boxH15(),
              // Text(
              //   "City ",
              //   style: TextStyle(
              //     fontSize: 15,
              //     color: AppColor.black.withOpacity(0.6),
              //   ),
              // ),
              // boxH08(),
              // CSCPicker(
              //   /// Enable disable state dropdown [OPTIONAL PARAMETER]
              //   showStates: true,
              //
              //   /// Enable disable city drop down [OPTIONAL PARAMETER]
              //   showCities: true,
              //
              //   /// Set default country to India
              //   defaultCountry: CscCountry.India,
              //
              //   /// Disable country dropdown
              //   disableCountry: true,
              //
              //   /// Enable (get flag with country name) / Disable (Disable flag)
              //   flagState: CountryFlag.DISABLE,
              //
              //   /// Dropdown box decoration
              //   dropdownDecoration: BoxDecoration(
              //     borderRadius: const BorderRadius.all(Radius.circular(10)),
              //     color: Colors.transparent, // Make background transparent
              //     border: Border.all(color: Colors.grey.shade300, width: 1),
              //   ),
              //
              //   /// Disabled Dropdown box decoration
              //   disabledDropdownDecoration: BoxDecoration(
              //     borderRadius: const BorderRadius.all(Radius.circular(10)),
              //     color: Colors.transparent, // Make background transparent
              //     border: Border.all(color: Colors.grey.shade300, width: 1),
              //   ),
              //
              //   /// Placeholders for dropdown search field
              //   stateSearchPlaceholder: "State",
              //   citySearchPlaceholder: "City",
              //
              //   /// Labels for dropdown
              //   stateDropdownLabel: "Select State",
              //   cityDropdownLabel: "Select City",
              //
              //   /// Current selections
              //   currentCountry: controller.country_name,
              //   currentState: controller.stateValue,
              //   currentCity: controller.cityValue,
              //
              //   /// Selected item style
              //   selectedItemStyle: const TextStyle(
              //     color: Colors.black,
              //     fontSize: 14,
              //   ),
              //
              //   /// DropdownDialog Heading style
              //   dropdownHeadingStyle: const TextStyle(
              //     color: Colors.black,
              //     fontSize: 17,
              //     fontWeight: FontWeight.bold,
              //   ),
              //
              //   /// DropdownDialog Item style
              //   dropdownItemStyle: const TextStyle(
              //     color: Colors.black,
              //     fontSize: 14,
              //   ),
              //
              //   /// Dialog box radius
              //   dropdownDialogRadius: 10.0,
              //
              //   /// Search bar radius
              //   searchBarRadius: 10.0,
              //
              //   /// Triggers once country selected in dropdown
              //
              //
              //   /// Triggers once state selected in dropdown
              //   onStateChanged: (value) {
              //     setState(() {
              //       controller.stateValue = value;
              //     });
              //   },
              //
              //   /// Triggers once city selected in dropdown
              //   onCityChanged: (value) {
              //     setState(() {
              //       controller.cityValue = value;
              //     });
              //   },
              // ),
              // boxH15(),
              Text(
                "Locality / Apartment",
                style: TextStyle(
                  fontSize: 15,
                  color: AppColor.black.withOpacity(0.6),
                ),
              ),
              boxH08(),
              // CustomTextFormField(
              //   labelText: 'Locality / Apartment',
              //   hintText: 'Enter your Locality/Apartment',
              //   controller: controller.addressController,
              //   onChanged: (value) {
              //     controller.address.value = value;
              //   },
              //   maxLines: 2,
              // ),
              InkWell(
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GoogleMapSearchPlacesApi(),
                    ),
                  );
                  if (result != null) {

                    controller.lat = result['latitude'].toString();
                    controller.long = result['longitude'].toString();
                    controller.address = result['add'];
                    controller.cityValue = result['city'];
                    print("Selected Location: Latitude: ${controller.lat}, Longitude: ${controller.long}");
                    setState(() {

                    });
                  }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Colors.grey, width: 0.8),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      controller.address!= null
                          ? controller.address!
                          : "Enter your Locality / Apartment",
                      style: TextStyle(
                        color: controller.address != null ? Colors.black : Colors.grey,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                ),
              ),
              boxH15(),

              Text(
                "City ",
                style: TextStyle(
                  fontSize: 15,
                  color: AppColor.black.withOpacity(0.6),
                ),
              ),
              boxH08(),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: Colors.grey, width: 0.8),
                ),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    controller.cityValue!= null
                        ? controller.cityValue!
                        : "Enter your city",
                    style: TextStyle(
                      color: controller.cityValue != null ? Colors.black : Colors.grey,
                      fontSize: 14.0,
                    ),
                  ),
                ),
              ),


//              boxH15(),
              //  Text('Your contact number',style: TextStyle(fontSize: 15,   color: AppColor.black.withOpacity(0.6),),),
              // boxH10(),
              // Row(
              //   children: [
              //     Expanded(
              //       flex: 3,
              //       child: Container(
              //         margin: EdgeInsets.only(right: 5),
              //         decoration: BoxDecoration(
              //           borderRadius:
              //           BorderRadius.all(Radius.circular(5.0)),
              //           border: Border.all(
              //             width: 1,
              //             color: AppColor.blue,
              //           ),
              //         ),
              //        //width: 80,
              //         height: 50,
              //         alignment: Alignment.centerLeft,
              //         child: CountryCodePicker(
              //           onChanged: _onCountryChange,
              //           initialSelection: 'IN',
              //           favorite: ['+91', 'IN'],
              //           showCountryOnly: false,
              //           showOnlyCountryWhenClosed: false,
              //           alignLeft: false,
              //         ),
              //       ),
              //     ),
              //     boxW05(),
              //     Expanded(
              //       flex: 7,
              //       child: SizedBox(
              //         height: 50,
              //         child: TextFormField(
              //           inputFormatters: [
              //             LengthLimitingTextInputFormatter(10)
              //           ],
              //           keyboardType: TextInputType.phone,
              //           controller: controller.phNoController,
              //           maxLines: 1,cursorColor: Colors.black,
              //           decoration:  InputDecoration(
              //             border: OutlineInputBorder(),
              //             filled: true,
              //             fillColor: Colors.white.withOpacity(0.2),
              //             focusedBorder: const OutlineInputBorder(
              //               borderSide: BorderSide(color: Colors.grey),
              //               borderRadius: BorderRadius.all(Radius.circular(10)),
              //             ),
              //             hintText: 'Enter mobile number',
              //           ),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),


            ],
          ),
        ),
      ),
    );
  }

  Widget PropertyDetailsTab() {

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Container(
        color: AppColor.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(),
            Center(
              child: Text(
                'Property Details',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold,color: AppColor.black.withOpacity(0.6)),
              ),
            ),
            const Divider(),

            boxH10(),
            Text('Property Type:',style: TextStyle(
              fontSize: 15,
              color: AppColor.black.withOpacity(0.6),
            ),),
            boxH10(),
            SizedBox(
              height: 35,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.categorytype.value=='Residential'?
                controller.residentalpropertyTypes.length :
                controller.commercialPropertyType.length,

                itemBuilder: (context, index) {
                  bool isSelectedProperty = controller.selectedProperty.value == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        controller.selectedProperty.value = index;
                        controller.propertytype.value = controller.categorytype.value=='Residential'?
                        controller.residentalpropertyTypes[index] :
                        controller.commercialPropertyType[index];

                        print(controller.residentalpropertyTypes[index]);
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6.0),
                      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
                      decoration: BoxDecoration(
                        color: isSelectedProperty
                            ? AppColor.blue.shade50
                            : AppColor.white,
                        border: Border.all(
                          color: isSelectedProperty
                              ? AppColor.blue
                              : AppColor.grey[400]!,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            controller.categorytype.value=='Residential'?
                            controller.residentalpropertyTypes[index] :
                            controller.commercialPropertyType[index],
                            // controller.propertyTypes[index],
                            style: TextStyle(
                              color: isSelectedProperty
                                  ? AppColor.blue.withOpacity(0.9)
                                  : AppColor.black.withOpacity(0.6),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            boxH15(),

            CustomTextFormField(
              controller: controller.propertyNameController,
              labelText: 'Property Name',
            ),
            boxH15(),
            CustomTextFormField(
              controller: controller.propertyDescriptionController,
              labelText: 'Property Description',
              maxLines: 2,
            ),

            boxH15(),
            CustomTextFormField(
              controller: controller.buildUpAreaController,
              labelText: 'Built-up Area (sq. ft.)',
              keyboardType: TextInputType.number,
            ),
            boxH15(),
            CustomTextFormField(
              controller: controller.totalFloorController,
              labelText: 'Total Floors',
              keyboardType: TextInputType.number,
            ),
            boxH15(),


            CustomTextFormField(
              controller: controller.UnitController,

              labelText: 'Unit',
              keyboardType: TextInputType.number,
            ),
            boxH15(),

            // Property Floor
            CustomTextFormField(
              controller: controller.propertyFloorController,
              labelText: 'Property Floor',
              keyboardType: TextInputType.number,
            ),
            boxH10(),
            Text(
              'Bathroom Type:',
              style: TextStyle(
                fontSize: 15,
                color: AppColor.black.withOpacity(0.6),

              ),
            ),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    fillColor: MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.selected)) {
                        return Colors.blue;
                      }
                      return Colors.black.withOpacity(0.6);
                    }),
                    title:  Text('Combine',style: TextStyle(color:Colors.black.withOpacity(0.6) ,fontSize: 14),),
                    value: 'Combine',
                    groupValue: controller.bathroomType.value,
                    onChanged: (value) {
                      if (value != null) {
                        controller.bathroomType.value = value;
                      }
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    fillColor: MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.selected)) {
                        return Colors.blue;
                      }
                      return Colors.black.withOpacity(0.6);
                    }),
                    title:  Text('Separate',style: TextStyle(color:Colors.black.withOpacity(0.6) ,fontSize: 14)),
                    value: 'Separate',
                    groupValue: controller.bathroomType.value,
                    onChanged: (value) {
                      if (value != null) {
                        controller.bathroomType.value = value;
                      }
                    },
                  ),
                ),
              ],
            ),
            boxH08(),
            Text('BHK Type:',style: TextStyle(
              fontSize: 15,
              color: AppColor.black.withOpacity(0.6),
            ),),
            boxH15(),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.1,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.bhkTypes.length,
                itemBuilder: (context, index) {
                  bool isSelectedProperty = controller.selectedBhk.value == index;
                  return GestureDetector(
                    onTap: () async {
                      DialogUtil.showLoadingDialogWithDelay(milliseconds: 600);
                      Get.back();
                      setState(() {
                        controller.selectedBhk.value = index;
                        controller.bhkType.value = controller.bhkTypes[index];

                        print(controller.bhkTypes[index]);
                      });
                    },
                    child: Container(

                      margin: EdgeInsets.symmetric(horizontal: 3.0),
                      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
                      decoration: BoxDecoration(
                        color: isSelectedProperty ? AppColor.blue.shade50 : AppColor.white,
                        border: Border.all(
                          color: isSelectedProperty ? AppColor.blue : AppColor.grey[400]!,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Text(
                          controller.bhkTypes[index],
                          style: TextStyle(
                            color: isSelectedProperty
                                ? AppColor.blue.withOpacity(0.9)
                                : AppColor.black.withOpacity(0.6),
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            boxH20(),
            Text('Furnishing:',style: TextStyle(
              fontSize: 15,
              color: AppColor.black.withOpacity(0.6),
            ),),
            boxH15(),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.1,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.furnishTypes.length,
                itemBuilder: (context, index) {
                  bool isSelectedFurnished = controller.selectedFurnished.value == index;
                  return GestureDetector(
                    onTap: () async {
                      DialogUtil.showLoadingDialogWithDelay(milliseconds: 600);
                      Get.back();
                      setState(() {
                        controller.selectedFurnished.value = index;
                        controller.furnishType.value = controller.furnishTypes[index];
                      });
                    },
                    child:Container(

                      margin: EdgeInsets.symmetric(horizontal: 3.0),
                      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
                      decoration: BoxDecoration(
                        color: isSelectedFurnished ? AppColor.blue.shade50 : AppColor.white,
                        border: Border.all(
                          color: isSelectedFurnished ? AppColor.blue : AppColor.grey[400]!,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Text(
                          controller.furnishTypes[index],
                          style: TextStyle(
                            color: isSelectedFurnished
                                ? AppColor.blue.withOpacity(0.9)
                                : AppColor.black.withOpacity(0.6),
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            boxH10(),
            const Divider(),
            Text('Add Property Cover Image :',style: TextStyle(color: AppColor.black.withOpacity(0.6),),),
            boxH10(),


            Obx(
                  () => InkWell(
                onTap: () {
                  controller.coverImg = null;
                  controller.isIconSelected.value = false;
                  showImageDialog('CoverImage');
                },
                child: controller.isIconSelected.value
                    ? Image.file(
                  File(controller.coverImg!.path),
                  width: double.infinity,
                  height: 100,
                  fit: BoxFit.fitWidth,
                )
                    : controller.coverImage.isNotEmpty
                    ? CachedNetworkImage(
                  width: double.infinity,
                  height: 100,
                 // imageUrl: APIString.imageBaseUrl + controller.coverImage.value,
                  imageUrl:controller.coverImage.value,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    width: double.infinity,
                    height: 100,

                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                )
                    : DottedBorder(
                  color: AppColor.grey,
                  strokeWidth: 1,
                  dashPattern: [8, 4],
                  child: Container(
                    padding: EdgeInsets.all(16),
                    width: double.infinity,
                    height: 100,
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_a_photo, size: 25, color: Colors.grey),
                        SizedBox(height: 2),
                        Text(
                          'Tap to add property cover images',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),


            boxH10(),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(
                  value: controller.isSecurity,
                  activeColor: Colors.blue,
                  onChanged: (value) {
                    setState(() {
                      controller.isSecurity = value!;
                    });
                  },
                ),
                const Expanded(
                    child: Text( "Is security available?",)
                ),
              ],
            ),

            isfeature=='yes'?
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(
                  value: controller.isFeatured.value,
                  activeColor: Colors.blue,
                  onChanged: (value) {
                    setState(() {
                      controller.isFeatured.value = value!;
                    });
                  },
                ),
                const Expanded(
                    child: Text("Mark As featured ")
                ),
              ],
            ):
            // isfeature=='no_limit'?
            // const Text("You have exceeded the limit for posting featured property under your current plan. "
            //     "To continue using this feature, please consider upgrading or "
            //     "updating your plan.",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,),):
            // const Text("If you would like to mark the above property as featured,"
            //     " please upgrade plan.",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,),),
            GestureDetector(
              onTap: () {
                Get.to(const SubscriptionScreen());
              },
              child: Text(
                isfeature == 'no_limit'
                    ? "You have exceeded the limit for posting featured property under your current plan. "
                    "To continue using this feature, please consider upgrading or "
                    "updating your plan."
                    : "If you would like to mark the above property as featured, please upgrade plan.",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),


          ],
        ),
      ),
    );
  }

  Widget AddAmenitiesTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Container(
        color: AppColor.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(),
            Center(
              child: Text(
                'Add Amenities',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,color: AppColor.black.withOpacity(0.6)),
              ),
            ),
            const Divider(),

            boxH08(),

            InkWell(
              onTap: (){
                controller.iconImg = null;
                controller.isIconSelected.value = false;
                addNewAmenities(context);
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('+ Add New Amenities',style: TextStyle(color: Colors.blueGrey),),
                  Icon(Icons.add_circle_outline,size: 18,color: Colors.blueGrey,)
                ],
              ),
            ),

            boxH08(),

            Obx(
                  () => GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisExtent: 120,
                  mainAxisSpacing: 1,
                  crossAxisSpacing: 1,
                ),
                itemCount: controller.getAmenitiesList.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (ctx, index) {
                  String amenityId = controller.getAmenitiesList[index]['_id'].toString();
                   bool isSelected = controller.isAdded(amenityId);
                 // bool isSelected = controller.selectedAmenityIds.contains(amenityId) || controller.isAdded(amenityId);

                  return InkWell(
                    onTap: () {
                      controller.toggleSelection(amenityId);
                      setState(() {});
                    },
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: isSelected ? Colors.blue : Colors.grey,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          margin: const EdgeInsets.all(5),
                          height: 70,
                          width: 70,
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: controller.getAmenitiesList[index]['amenity_icon'] != null
                                    ? CachedNetworkImage(
                                  height: 70,
                                  width: 70,
                                  imageUrl: APIString.imageBaseUrl + controller.getAmenitiesList[index]['amenity_icon'],
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    height: 70,
                                    width: 70,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                        color: isSelected ? Colors.blue : Colors.grey,
                                        width: isSelected ? 3 : 1,
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                )
                                    : Container(
                                  color: Colors.grey[400],
                                  child: const Center(
                                    child: Icon(Icons.image_rounded),
                                  ),
                                ),
                              ),
                              // Positioned(
                              //   top: -1,
                              //   right: 0,
                              //   child: GestureDetector(
                              //     onTap: () {
                              //       showDeleteConfirmationDialog("Amenity",context,controller.getAmenitiesList[index]['_id']);
                              //     },
                              //     child: Container(
                              //       decoration: BoxDecoration(
                              //         shape: BoxShape.circle,
                              //         color: Colors.red,
                              //       ),
                              //       padding: const EdgeInsets.all(1),
                              //       child: const Icon(
                              //         Icons.close,
                              //         size: 13,
                              //         color: Colors.white,
                              //       ),
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                        Center(
                          child: Text(
                            controller.getAmenitiesList[index]['amenity_name'],
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            style: const TextStyle(color: Colors.black87, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
  void showDeleteConfirmationDialog(String from,BuildContext context,String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          content: const Text("Are you sure you want to delete this item?",style: TextStyle(fontSize: 14),),
          actions: [

            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blueGrey,
                textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              child: const Text("Cancel"),
            ),

            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blueGrey,
                textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              onPressed: () {

                if(from=='property_image'){
                  controller.removePropertyImages(id: id,p_id: controller.PropertyId);
                }else{
                  controller.removeAmenities(id: id);

                }

                Navigator.of(context).pop();
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  Widget AddImagesTab() {
    return SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Obx(
              () => Container(
            color: AppColor.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Add Property Images',
                    style: TextStyle(fontSize: 17, color: AppColor.black.withOpacity(0.6)),
                  ),
                ),
                const Divider(),
                controller.getPropertyImageList.length < 10
                    ? const Text(
                  '(Add a minimum of 5 property images)',
                  style: TextStyle(fontSize: 13, color: AppColor.red),
                )
                    : const Text(
                  'You have reached the limit for uploading property images. You can only upload a minimum of 10 property images.',
                  style: TextStyle(fontSize: 13, color: AppColor.red),
                ),

                boxH05(),
                controller.getPropertyImageList.length < 5
                    ? Obx(
                      () => InkWell(
                    onTap: () {
                      controller.pickedFiles.clear();
                      controller.isIconSelected.value = false;
                      showImageDialog('propertyImage');
                    },
                    child: controller.isIconSelected.value &&  controller.iconImg!=null
                        ? Image.file(
                      File(controller.iconImg!.path),
                      width: double.infinity,
                      height: 100,
                      fit: BoxFit.fitWidth,
                    )
                        : DottedBorder(
                      color: AppColor.grey,
                      strokeWidth: 1,
                      dashPattern: [8, 4],
                      child: Container(
                        padding: EdgeInsets.all(16),
                        width: double.infinity,
                        height: 100,
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_a_photo, size: 25, color: Colors.grey),
                            SizedBox(height: 2),
                            Text(
                              'Tap to add property images',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
                    : SizedBox(),
                boxH10(),
                controller.isIconSelected.value
                    ? Center(
                  child: InkWell(
                    onTap: () {
                      controller.addPropertyImages(
                        id: widget.data['_id'],
                        image: controller.iconImg,
                      );

                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColor.grey,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey.shade100,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 3),
                        child: Text("Upload Image"),
                      ),
                    ),
                  ),
                ) : const SizedBox(),

                boxH10(),

                Obx(
                      () => GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisExtent: 100,
                      mainAxisSpacing: 1,
                      crossAxisSpacing: 1,
                    ),
                    itemCount: controller.getPropertyImageList.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (ctx, index) {
                      return Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: Colors.grey,
                                width: 1,
                              ),
                            ),
                            margin: const EdgeInsets.all(5),
                            height: 90,
                            width: 90,
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: controller.getPropertyImageList[index]['image'] != null
                                      ? CachedNetworkImage(
                                    height: 90,
                                    width: 90,
                                    imageUrl: APIString.imageBaseUrl + controller.getPropertyImageList[index]['image'],
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(
                                      height: 90,
                                      width: 90,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                          color: Colors.grey,
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                  )
                                      : Container(
                                    color: Colors.grey[400],
                                    child: const Center(
                                      child: Icon(Icons.image_rounded),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: -1,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: () {
                                      showDeleteConfirmationDialog('property_image', context, controller.getPropertyImageList[index]['_id']);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.red,
                                      ),
                                      padding: const EdgeInsets.all(1),
                                      child: const Icon(
                                        Icons.close,
                                        size: 13,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        )

    );
  }

  Widget PriceDetailsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Container(
        color: AppColor.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Divider(),
            Center(
              child: Text(
                'Price Details',
                style: TextStyle(
                    fontSize: 17,

                    color: AppColor.black.withOpacity(0.7)
                ),
              ),
            ),
            const Divider(),

            boxH10(),
            controller.CategoryPriceType.value=='Rent' ||  controller.CategoryPriceType.value=='PG'?
            CustomTextFormField(
              labelText: 'Monthly Rent',
              prefixIcon: Icon(Icons.currency_rupee_outlined,color: AppColor.grey,size: 18,),
              controller: controller.propertyPriceController,
              onChanged: (value) {
                controller.propertyPrice.value = value;
              },
            ):SizedBox(),
            boxH10(),
            controller.CategoryPriceType.value=='Sell' ?
            CustomTextFormField(
              labelText: 'Property Price',
              prefixIcon: Icon(Icons.currency_rupee_outlined,color: AppColor.grey,size: 18,),
              controller: controller.propertyPriceController,
              onChanged: (value) {
                controller.propertyPrice.value = value;
              },
            ):SizedBox(),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Obx(() {
                int priceAsInt = int.tryParse(controller.propertyPrice.value) ?? 0;
                String priceInWords = controller.convertNumberToWords(priceAsInt);

                return Text(
                  priceInWords.isNotEmpty ? priceInWords : "Enter your amount",
                  style: TextStyle(
                    color: controller.propertyPrice != null ? Colors.green : Colors.grey,
                    fontSize: 14.0,
                  ),
                  maxLines: 3,
                );
              }),
            ),

            GestureDetector(
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  // Format the date as needed (e.g. yyyy-MM-dd)
                  String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                  controller.availableFromController.text = formattedDate;
                  controller.availableFrom.value = formattedDate;
                }
              },
              child: AbsorbPointer(
                child: CustomTextFormField(
                  labelText: 'Available From',
                  prefixIcon: Icon(Icons.calendar_month_outlined,color: AppColor.grey,size: 18,),
                  controller: controller.availableFromController,
                ),
              ),
            ),
            boxH20(),
            boxH10(),
            GestureDetector(
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {

                  String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                  controller.expieyController.text = formattedDate;
                  controller.expiryOn.value = formattedDate;
                }
              },
              child: AbsorbPointer(
                child: CustomTextFormField(
                  labelText: 'Expiry On',
                  prefixIcon: Icon(Icons.calendar_month_outlined,color: AppColor.grey,size: 18,),
                  controller: controller.expieyController,
                ),
              ),
            ),
            boxH20(),
            CustomTextFormField(
              labelText: 'Security Deposit',
              hintText: 'Enter expected safety deposit',
              prefixIcon: Icon(Icons.currency_rupee_outlined,color: AppColor.grey,size: 18,),
              controller: controller.securityDepositController,
            ),
          ],
        ),
      ),
    );
  }
  void addNewAmenities(context) async {
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
                                "Add Amenities",
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
                      Center(
                        child: InkWell(
                          onTap: () {
                            showImageDialog('Amenity');
                          },
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: <Widget>[
                              Obx(() {
                                return controller.isIconSelected.value
                                    ? Image.file(
                                  File(controller.iconImg!.path),
                                  height: 100,
                                  width: 100,
                                )
                                    : Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: AppColor.grey,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.grey.shade100,
                                  ),
                                  height: 150,
                                  width: 250,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      const Text('+ Add Amenities Image',
                                          style: TextStyle(color: Colors.grey)),
                                      boxH05(),
                                      const Icon(Icons.image_outlined, color: Colors.grey),
                                    ],
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                      boxH20(),
                      CustomTextFormField(
                        controller: controller.amenetiesName,
                        labelText: 'Amanities Name',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the amenity name';
                          }
                          return null;
                        },
                      ),
                      boxH20(),
                      GestureDetector(
                        onTap: () {
                          if (_formKey.currentState!.validate() && controller.iconImg!=null) {
                            controller.addAmenities(
                              name: controller.amenetiesName.value.text,
                              image: controller.iconImg,
                            ).then((value) {
                              // controller.iconImg = null;
                              // controller.isIconSelected.value = false;
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
                            'Add',
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
  showImageDialog(String isFrom) async {
    return showDialog(
      // context: Get.context!,
      context: Get.context!,
      builder: (context) => AlertDialog(
          backgroundColor: Colors.white,
          content: SizedBox(
            height: 100,
            child: Column(
              children: <Widget>[
                const Text(
                  "Choose Photo",
                  style: TextStyle(
                    fontSize: 15.0,
                  ),
                ),
                Divider(),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextButton.icon(
                        onPressed: () {
                          if(isFrom=='propertyImage'){
                            getCameraImages(isFrom);
                          }
                          else{
                            getCameraImage(isFrom);
                          }
                        },
                        icon: const Icon(
                          Icons.camera,
                          color: Colors.black54,
                          size: 15,
                        ),
                        label: const Text("Camera",
                            style: TextStyle(
                                color: Colors.black54, fontSize: 15))),
                    TextButton.icon(
                        onPressed: () {
                          if(isFrom=='propertyImage'){
                            getGalleryImages(isFrom);
                          }
                          else{
                            getGalleryImage(isFrom);
                          }
                        },
                        icon: const Icon(
                          Icons.image,
                          color: Colors.black54,
                          size: 15,
                        ),
                        label: const Text("Gallery",
                            style: TextStyle(
                                color: Colors.black54, fontSize: 15))),
                  ],
                )
              ],
            ),
          )),
    );
  }
  final ImagePicker picker = ImagePicker();
  Future getCameraImage(String isFrom) async {
    try {
      Navigator.of(Get.context!).pop(false);
      XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);
      // var pickedFile = await picker.pickImage(source: ImageSource.camera,imageQuality: 20);

      if (pickedFile != null) {
        controller.pickedImageFile = pickedFile;

        File selectedImg = File(controller.pickedImageFile.path);

        cropImage(selectedImg,isFrom);
      }
    } on Exception catch (e) {
      log("$e");
    }
  }
  Future getGalleryImage(String isFrom) async {
    Navigator.of(Get.context!).pop(false);
    var pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      controller.pickedImageFile = pickedFile;

      File selectedImg = File(controller.pickedImageFile.path);

      cropImage(selectedImg,isFrom);
    }
  }
  cropImage(File icon,String isFrom) async {
    CroppedFile? croppedFile = (await ImageCropper()
        .cropImage(sourcePath: icon.path, aspectRatioPresets: [
      CropAspectRatioPreset.square,
      CropAspectRatioPreset.ratio3x2,
      CropAspectRatioPreset.original,
      CropAspectRatioPreset.ratio4x3,
      CropAspectRatioPreset.ratio16x9
    ], uiSettings: [
      AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
      IOSUiSettings(
        title: 'Cropper',
      ),
    ]));
    if (croppedFile != null) {
      if(isFrom=='CoverImage'){
        controller.coverImg = File(croppedFile.path);
      }else{
        controller.iconImg = File(croppedFile.path);
      }

      controller.isIconSelected.value = true;

    }
  }

  Future<void> getGalleryImages(String isFrom) async {
    List<XFile>? selectedFiles = await picker.pickMultiImage();

    if (selectedFiles != null) {
      for (var file in selectedFiles) {
        controller.pickedFiles.add(file);
      }

    }
    for (var file in controller.pickedFiles) {
      if (file != null) {
        File imageFile = File(file.path);
        controller.addPropertyImages(
          id: controller.PropertyId,
          image: imageFile,
        );
      }
    }
    Navigator.pop(context);
  }
  Future<void> getCameraImages(String isFrom) async {
    XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      controller.pickedFiles.add(pickedFile);
    }
    for (var file in controller.pickedFiles) {
      if (file != null) {
        File imageFile = File(file.path);
        controller.addPropertyImages(
          id: controller.PropertyId,
          image: imageFile,
        );
      }
    }
    Navigator.pop(context);
  }
}