
import 'dart:developer';
import 'dart:io';
import 'dart:math';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:real_estate_app/common_widgets/custom_textformfield.dart';
import 'package:real_estate_app/common_widgets/dialog_util.dart';
import 'package:real_estate_app/common_widgets/height.dart';
import 'package:real_estate_app/global/app_color.dart';
import 'package:real_estate_app/global/constant.dart';
import 'package:real_estate_app/view/subscription%20model/Subscription_Screen.dart';
import '../../../global/api_string.dart';
import '../../../utils/String_constant.dart';
import '../../../utils/shared_preferences/shared_preferances.dart';
import '../../../utils/text_style.dart';
import '../../auth/login_screen/login_screen.dart';
import '../../dashboard/deshboard_controllers/bottom_bar_controller.dart';
import '../../dashboard/view/BottomNavbar.dart';
import '../../splash_screen/splash_screen.dart';
import '../properties_controllers/post_property_controller.dart';
import 'mapLocationSelection.dart';

class PostPropertyScreen extends StatefulWidget {
  const PostPropertyScreen({Key? key}) : super(key: key);

  @override
  State<PostPropertyScreen> createState() => _PostPropertyScreenState();
}

class _PostPropertyScreenState extends State<PostPropertyScreen> with TickerProviderStateMixin {
  late Animation<double> _scaleAnimation;
  late AnimationController _controller;
  late TabController _tabController;
  final _BasicformKey = GlobalKey<FormState>();
  final PostPropertyController controller = Get.put(PostPropertyController());
  final bottomBarController = Get.put(BottomBarController());
  String isfeature='';
  String ispost='';
  String? userId ="" ;
  int count=0,paid_post=0,plan_post=0,setting_count=0;
  static const colorizeTextStyle = TextStyle(
    fontSize: 16.0,
    fontFamily: 'Horizon',
  );
  static const colorizeColors = [Colors.yellowAccent, Colors.white, Colors.orangeAccent];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true); // Repeats the animation

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _tabController = TabController(length: 5, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(isLogin==true){
    //    planData();
      }
    });
    _tabController.addListener(_handleTabSelection);
    controller.getAmenities();
    controller.clearData();
  }

  planData() async                                                                 {
   userId = await SPManager.instance.getUserId(USER_ID);
   String isFeature= (await SPManager.instance.getFeaturedProperties(FeaturedProperties))??"no";
   ispost= (await SPManager.instance.getPostProperties(PostProperties))??"no";
   int? featuredCount= (await SPManager.instance.getFeatureCount(PAID_FEATURE))??0;
   int? PlanfeaturedCount= (await SPManager.instance.getPlanFeatureCount(PLAN_FEATURE))??0;
   count= (await SPManager.instance.getFreePostCount(FREE_POST))??0;
   paid_post= (await SPManager.instance.getPaidPostCount(PAID_POST))??0;
   plan_post= (await SPManager.instance.getPlanPostCount(PLAN_POST))??0;
   setting_count= (await SPManager.instance.getSetingPostCount(SETTING_POST))??0;

    if( ispost=='no'){
       if(count< setting_count){

      }
       else {
         Subscription(context,'free','listing');
      }
    }else{
      if( paid_post < plan_post){

      }
      else if(paid_post >= plan_post){
         Subscription(context,'paid','listing');
      }
      else{
        Subscription(context,'expired','listing');
        Subscription(context,'expired','listing');
      }
    }

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
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onContinuePressed() async {
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
        // controller.postProperty();
        if (!controller.isPropertyPosted) {
          print("Property details are valid. Posting property...");
          // if(await SPManager.instance.getPostProperties(PostProperties)=='yes'){
          //   controller.postProperty();
          // }else{
          //   Subscription(context);
          // }
          controller.postProperty();
          controller.isPropertyPosted = true;
        }
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
         title: const Text(post_property,style: TextStyle(fontSize: 17,color: Colors.white,fontWeight: FontWeight.bold),),
      //  backgroundColor: AppColor.grey.withOpacity(0.1),
        backgroundColor:Colors.blueGrey,
        ),
        body:
        isLogin == true ?
        Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
                color: Colors.blueGrey, // Example color
                border: Border.all(color: AppColor.primaryColor),
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
        )  :
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Centering the children
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Image.asset(
                    'assets/permission.png',
                    height: 100,
                    width: 100,
                  ),
                ),
                const Text("Login to add your listing"),
                const SizedBox(height: 10),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.off(LoginScreen());
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.blueGrey,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      elevation: 10, // Shadow elevation
                    ),
                    child: const Text('Login'),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar:
        isLogin == true ?
        Padding(
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
                      'Post Property',
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                  ),
                ),
            ],
          ),
        ):const SizedBox(),
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
                        margin: const EdgeInsets.symmetric(horizontal: 6.0),
                        padding:
                            const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
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
                      builder: (context) => const GoogleMapSearchPlacesApi(),
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
                    padding: const EdgeInsets.all(8.0),
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
                  padding: const EdgeInsets.all(8.0),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget PropertyDetailsTab() {

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
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
                      controller.categorytype.value=='Residential'?
                      controller.getDescription(Category:controller.residentalpropertyTypes[index]):
                      controller.getDescription(Category:controller.commercialPropertyType[index]);
                      setState(() {
                        controller.selectedProperty.value = index;
                        controller.categorytype.value=='Residential'?
                        controller.selectedPropertyType.value=controller.residentalpropertyTypes[index]:
                        controller.selectedPropertyType.value=controller.commercialPropertyType[index];
                        controller.propertytype.value = controller.categorytype.value=='Residential'?
                        controller.residentalpropertyTypes[index] :
                        controller.commercialPropertyType[index];
                        if(controller.selectedPropertyType.value=="Plot")
                          {
                            controller.bhkType.value='';
                          }
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6.0),
                      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
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


             Row(
               mainAxisAlignment:MainAxisAlignment.spaceBetween,
               children: [
                 const Text("Property Description"),
                 GestureDetector(
                     onTap: () {
                       print("ontap");
                       if (controller.descriptionList.isNotEmpty) {
                         // Select a random description
                         final randomIndex = Random().nextInt(controller.descriptionList.length);
                         controller.propertyDescriptionController.text =
                         controller.descriptionList[randomIndex]['description'];
                       }
                     },
                     child: Container(
                         height: 30,
                         width: 110,
                         margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                         padding: const EdgeInsets.only(left: 10,right:5),
                         alignment: Alignment.center,
                         decoration: BoxDecoration(
                           //color: Colors.purple,
                             gradient: LinearGradient(
                               colors: [Colors.deepPurple, Colors.deepPurpleAccent.shade100],
                               begin: Alignment.centerLeft,
                               end: Alignment.centerRight,
                             ),
                             borderRadius:
                             BorderRadius.circular(100)),
                         child:  SizedBox(
                           width: 110.0,
                           child: Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children:
                               [GestureDetector(
                                 onTap: () {
                                   if (controller.descriptionList.isNotEmpty) {
                                     // Select a random description
                                     final randomIndex = Random().nextInt(controller.descriptionList.length);
                                     controller.propertyDescriptionController.text =
                                     controller.descriptionList[randomIndex]['description'];
                                   }
                                 },
                                 child:AnimatedTextKit(
                                   animatedTexts: [
                                     ColorizeAnimatedText(
                                       ' Generate',
                                       textStyle: colorizeTextStyle,
                                       colors: colorizeColors,
                                     ),
                                     ColorizeAnimatedText(
                                       ' Generate',
                                       textStyle: colorizeTextStyle,
                                       colors: colorizeColors,
                                     ),
                                     ColorizeAnimatedText(
                                       ' Generate',
                                       textStyle: colorizeTextStyle,
                                       colors: colorizeColors,
                                     ),
                                   ],
                                   isRepeatingAnimation: true,
                                   onTap: () {
                                     if (controller.descriptionList.isNotEmpty) {
                                       // Select a random description
                                       final randomIndex = Random().nextInt(controller.descriptionList.length);
                                       controller.propertyDescriptionController.text =
                                       controller.descriptionList[randomIndex]['description'];
                                     }
                                   },
                                 ),
                               ),
                                 Image.asset(
                                   'assets/stars.png',
                                   width:17,height:17,
                                 )
                               ]),
                         ))),
               ],
             ),

            boxH05(),
             CustomTextFormField(
                controller: controller.propertyDescriptionController,
                maxLines: 7,
              //     sufixIcon: GestureDetector(
              //       onTap: () {
              //         if (controller.descriptionList.isNotEmpty) {
              //           // Select a random description
              //           final randomIndex = Random().nextInt(controller.descriptionList.length);
              //           controller.propertyDescriptionController.text =
              //           controller.descriptionList[randomIndex]['description'];
              //         }
              //       },
              //       child:AnimatedBuilder(
              //           animation: _scaleAnimation,
              //           builder: (context, child) {
              //             return Transform.scale(
              //                 scale: _scaleAnimation.value,
              //                 child: const Icon(
              //                   Icons.star_border_outlined,
              //                   color: Colors.deepPurple,
              //                   size: 30,
              //                 ),);
              //           }
              // )
              //     )
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
           // controller.categorytype.value=='Residential'?
            controller.categorytype.value=='Commercial'?
            Text(
              'Bathroom Type:',
              style: TextStyle(
                  fontSize: 15,
                  color: AppColor.black.withOpacity(0.6),

              ),
            ):const SizedBox(),
            controller.categorytype.value=='Commercial'?
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
                        setState(() {
                          controller.bathroomType.value = value;
                        });

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
                        setState(() {
                          controller.bathroomType.value = value;
                        });
                      }
                    },
                  ),
                ),
              ],
            ):const SizedBox(),
            boxH08(),
            Obx(()=>
            controller.categorytype.value=='Residential' && controller.selectedPropertyType.value!="Plot"?
            Text('BHK Type:',style: TextStyle(
                fontSize: 15,
                color: AppColor.black.withOpacity(0.6),
               ),):const SizedBox()),
            Obx(()=>
            controller.categorytype.value=='Residential' && controller.selectedPropertyType.value!="Plot"?
            boxH15():const SizedBox()),
        Obx(()=>controller.categorytype.value=='Residential' && controller.selectedPropertyType.value!="Plot"?
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

                      margin: const EdgeInsets.symmetric(horizontal: 3.0),
                      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
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
            ):const SizedBox()),

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

                      margin: const EdgeInsets.symmetric(horizontal: 3.0),
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
                    : DottedBorder(
                  color: AppColor.grey,
                  strokeWidth: 1,
                  dashPattern: [8, 4],
                  child: Container(
                    padding: const EdgeInsets.all(16),
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
      padding: const EdgeInsets.all(16),
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
                             // if(controller.getAmenitiesList[index]['user_id'] == userId )
                             //  Positioned(
                             //    top: -1,
                             //    right: 0,
                             //    child: GestureDetector(
                             //      onTap: () {
                             //        showDeleteConfirmationDialog("Amenity",context,controller.getAmenitiesList[index]['_id']);
                             //      },
                             //      child: Container(
                             //        decoration: const BoxDecoration(
                             //          shape: BoxShape.circle,
                             //          color: Colors.red,
                             //        ),
                             //        padding: const EdgeInsets.all(1),
                             //        child: const Icon(
                             //          Icons.close,
                             //          size: 13,
                             //          color: Colors.white,
                             //        ),
                             //      ),
                             //    ),
                             //  ),
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
                foregroundColor: Colors.white, backgroundColor: Colors.blueGrey,
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
      padding: const EdgeInsets.all(16),
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
                      padding: const EdgeInsets.all(16),
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
                  : const SizedBox(),
              // boxH10(),
              // controller.isIconSelected.value
              //     ? Center(
              //   child: InkWell(
              //     onTap: () {
              //       // controller.addPropertyImages(
              //       //   id: controller.PropertyId,
              //       //   image: controller.iconImg,
              //       // );
              //       for (var file in controller.pickedFiles) {
              //         if (file != null) {
              //           File imageFile = File(file.path);
              //           controller.addPropertyImages(
              //             id: controller.PropertyId,
              //             image: imageFile,
              //           );
              //         }
              //       }
              //     },
              //     child: Container(
              //       decoration: BoxDecoration(
              //         border: Border.all(
              //           color: AppColor.grey,
              //         ),
              //         borderRadius: BorderRadius.circular(12),
              //         color: Colors.grey.shade100,
              //       ),
              //       child: const Padding(
              //         padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 3),
              //         child: Text("Upload Image"),
              //       ),
              //     ),
              //   ),
              // )
              //     : const SizedBox(),

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
                                    decoration: const BoxDecoration(
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
      padding: const EdgeInsets.all(16),
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
              prefixIcon: const Icon(Icons.currency_rupee_outlined,color: AppColor.grey,size: 18,),
              controller: controller.propertyPriceController,
              keyboardType:TextInputType.number ,
              onChanged: (value) {
                controller.propertyPrice.value = value;
              },

            ):const SizedBox(),
            controller.CategoryPriceType.value=='Sell' ?
            CustomTextFormField(
              labelText: 'Property Price',
              prefixIcon: const Icon(Icons.currency_rupee_outlined,color: AppColor.grey,size: 18,),
              controller: controller.propertyPriceController,
              onChanged: (value) {
                controller.propertyPrice.value = value;
              },
              keyboardType:TextInputType.number ,
            ):const SizedBox(),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Obx(() {
                int priceAsInt = int.tryParse(controller.propertyPrice.value) ?? 0;
                String priceInWords = controller.convertNumberToWords(priceAsInt);

                return Text(
                  priceInWords.isNotEmpty ? priceInWords + "." : "Enter your amount",
                  style: TextStyle(
                    color: controller.propertyPrice != null ? Colors.green : Colors.grey,
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold
                  ),
                  maxLines: 3,
                );
              }),
            ),

            boxH10(),
            GestureDetector(
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                  controller.availableFromController.text = formattedDate;
                  controller.availableFrom.value = formattedDate;
                }
              },
              child: AbsorbPointer(
                child: CustomTextFormField(
                  labelText: 'Available From',
                  prefixIcon: const Icon(Icons.calendar_month_outlined,color: AppColor.grey,size: 18,),
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
                  firstDate: DateTime.now(),
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
                  prefixIcon: const Icon(Icons.calendar_month_outlined,color: AppColor.grey,size: 18,),
                  controller: controller.expieyController,
                ),
              ),
            ),
            boxH20(),
            controller.CategoryPriceType.value=='Rent' ||  controller.CategoryPriceType.value=='PG'?

            CustomTextFormField(
              labelText: 'Security Deposit',
              hintText: 'Enter expected safety deposit',
              prefixIcon: const Icon(Icons.currency_rupee_outlined,color: AppColor.grey,size: 18,),
              controller: controller.securityDepositController,

            ):const SizedBox(),
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
                const Divider(),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextButton.icon(
                        onPressed: () {
                         //getCameraImage(isFrom);
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
                        //  getGalleryImage(isFrom);

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
      //log("$e");
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
