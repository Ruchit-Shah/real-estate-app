import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:real_estate_app/Routes/app_pages.dart';
import 'package:real_estate_app/common_widgets/height.dart';
import 'package:real_estate_app/global/app_color.dart';
import 'package:real_estate_app/global/constant.dart';
import 'package:real_estate_app/global/services/api_shorts_string.dart';
import 'package:real_estate_app/utils/String_constant.dart';
import 'package:real_estate_app/utils/enum/enum.dart';
import 'package:real_estate_app/utils/text_style.dart';
import 'package:real_estate_app/view/auth/login_screen/login_screen.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/profile_screen/profile_screen.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/profile_screen/profile_section_screens/MyLeads/MyLeads.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/search_screen/offer_details_screen.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/search_screen/searchController.dart';
import 'package:real_estate_app/view/filter_search/view/ExploreCityFilter.dart';
import 'package:real_estate_app/view/filter_search/view/ExploreServiceFilter.dart';
import 'package:real_estate_app/view/property_screens/recommended_properties_screen/propertyCard.dart';
import 'package:real_estate_app/view/shorts/controller/home_controller.dart';
import 'package:real_estate_app/view/shorts/controller/profile_videos_controller.dart';
import 'package:real_estate_app/view/top_developer/offerCard.dart';
import '../../../../common_widgets/custom_textformfield.dart';
import '../../../../common_widgets/loading_dart.dart';
import '../../../../global/api_string.dart';
import '../../../../global/widgets/loading_dialog.dart';
import '../../../../utils/shared_preferences/shared_preferances.dart';
import '../../../filter_search/view/FilterSearchController.dart';
import '../../../filter_search/view/OwnerTypeFilter.dart';
import '../../../filter_search/view/filterListScreen.dart';
import '../../../notifications/notification_screen.dart';
import '../../../property_screens/properties_controllers/post_property_controller.dart';
import '../../../property_screens/property_search_location/property_search_location_screen.dart';
import '../../../property_screens/recommended_properties_screen/properties_details_screen.dart';
import '../../../property_screens/recommended_properties_screen/properties_list_screen.dart';
import '../../../splash_screen/splash_screen.dart';
import '../../../subscription model/controller/SubscriptionController.dart';
import '../../../top_developer/offerList.dart';
import '../../../top_developer/top_developer_controller.dart';
import '../../../top_developer/top_developer_details.dart';
import '../../../top_developer/top_rated_developer_list_screen.dart';
import '../../deshboard_controllers/bottom_bar_controller.dart';
import '../profile_screen/profile_controller.dart';
import 'dart:ui'; // For ImageFilter
import 'package:url_launcher/url_launcher.dart';

import '../profile_screen/profile_section_screens/my_virtual_tour/GetScheduleBottomSheet.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchBoxController = TextEditingController();
  final searchApiController = Get.find<searchController>();
  final postPropertyController = Get.find<PostPropertyController>();
  final BottomBarController bottomBarController = Get.find();
  int _selectedCategoryIndex = -1;
  final ScrollController _controllerOne = ScrollController();
  final ScrollController _controller2 = ScrollController();
  final ScrollController _controller3 = ScrollController();
  final ScrollController _controller4 = ScrollController();
  final ScrollController _controller5 = ScrollController();
  final ScrollController _controller6 = ScrollController();
  final ScrollController _controller7 = ScrollController();
  final ScrollController _controller8 = ScrollController();
  final ScrollController _controller9 = ScrollController();
  final ScrollController _controller10 = ScrollController();
  final ScrollController _controller11 = ScrollController();
  int _currentIndex = 0;
  int _currentIndex2 = 0;
  int touchedIndex = -1;
  final List<Map<String, dynamic>> categoryType1 = [
    {'title': 'Buy', 'icon': 'assets/buy-home.png'},
    {'title': 'Rent', 'icon': 'assets/rent_house.png'},
    {'title': 'Commercial', 'icon': 'assets/commerical_icon.png'},
    {'title': 'Residential', 'icon': 'assets/pg_icon.png'},
    {'title': 'PG', 'icon': 'assets/plot_icon.png'},
  ];
  Future<void> callPhoneNumber(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }
  String city = "Fetching city...";
  final PostPropertyController controller = Get.find();
  final homeController = Get.find<HomeController>();
  final videoController = Get.find<ProfileVideosController>();
  final top_developer_controller Developercontroller =
      Get.put(top_developer_controller());
  final FilterSearchController filterController = Get.find();
  final SubscriptionController Controller = Get.put(SubscriptionController());
  ProfileController profileController = Get.put(ProfileController());

  final PageController _pageController = PageController();

  Timer? _timer;

  List<String> imgList = [
    'assets/image_rent/langAsiaCity.png',
    'assets/image_rent/langAsiaCity.png',
    'assets/image_rent/LandAsiaCity.png',
    'assets/image_rent/langAsiaCity.png',
    'assets/image_rent/LandAsiaCity.png',
    'assets/image_rent/LandAsiaCity.png',
    'assets/image_rent/LandAsiaCity.png',
    'assets/image_rent/LandAsiaCity.png',
  ];

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        int nextPage = (_pageController.page ?? 0).round() + 1;
        if (nextPage >=
            (Developercontroller.getdeveloperList.length > 4
                ? 4
                : Developercontroller.getdeveloperList.length)) {
          nextPage = 0;
        }

        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    _controllerOne.dispose();
    scrollController.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _controller4.dispose();
    _controller5.dispose();
    _controller6.dispose();
    _controller7.dispose();
    _controller8.dispose();
    _controller9.dispose();
    _controller10.dispose();
    _controller11.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoScroll();
      controller.categorySelected.value = 0;
      controller.categorytype.value = "Property";

      getData(context);

      print('pie chart data ${profileController.postPropertiesPercentage}');
    });
  }


  // getData() async {
  //   await  controller.enquiryCallBack(controller.categorytype.value);
  //   await profileController.getProfile();
  //   await controller.getBuildersProjects(page: '1');
  //   await Controller.getSubscriptionHistory();
  //   await controller.getRecommendedProperty(page: '1');
  //   await controller.getOwnerListedBy();
  //   await videoController.myVideosApi();
  //   print('recommended property : ${controller.getRecommendedPropertyList.length}');
  //   print('houzza shorts count : ${homeController.homeVideosDataList.length}');
  //   await controller.getProperty();
  //   await controller.getCitiesProperty();
  //   await controller.getFeaturedProperty(page: '1');
  //   // await Developercontroller.getDeveloper();
  //   if (controller.isBuyerSelected.value == false) {
  //     await profileController.getMyListingProperties(isfrom: "");
  //   }
  //   await controller.getOffer(isfrom: 'search');
  //   await filterController.getSaveSearch(search_by: 'Normal',page: '1');
  //   city = (await SPManager.instance.getCity(CITY)) ?? "";
  //   print("city-->");
  //   print(city);
  //   setState(() {});
  //   getSellerView();
  // }

  getData(BuildContext context) async {
    showHomLoading(context, 'Loading...');
    await Future.delayed(const Duration(seconds: 1));

    await Controller.getSubscriptionHistory();

    ///uncomment
   // await filterController.getCurrentLocation();

    await  controller.enquiryCallBack(controller.categorytype.value);
    await profileController.getProfile();
    if(  controller.isBuyerSelected.value == true){

      await controller.getHomeData(city: filterController.currentCity.value);

      await Controller.getSubscriptionHistory();

      // await videoController.myVideosApi();

      await controller.getCitiesProperty();


    }else{
      getSellerView();
      await profileController.getMyListingProperties(isfrom: "");
    }
    city = (await SPManager.instance.getCity(CITY)) ?? "";




    hideLoadingDialog();
    setState(() {});

  }

  void getSellerView() async {
  await controller.getLeadsMapData(homeController.fromDate.value,homeController.toDate.value);
  await controller.getViewMapData(homeController.fromDate.value,homeController.toDate.value);
  await controller.getVirtualTourMapData(homeController.fromDate.value,homeController.toDate.value);
}
  void _showLoadingDialog() {
    showHomLoading(Get.context!, 'Processing...');
    Future.delayed(const Duration(seconds: 1), () {
      if (Get.context != null && Navigator.canPop(Get.context!)) {
        Navigator.of(Get.context!).pop();
      }
    });
  }
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    var _height = MediaQuery.of(context).size.height;

    return Obx(()=>
        // SafeArea(
        //   child:
     SafeArea(
       child: Scaffold(
          backgroundColor: AppColor.grey.shade100,
          appBar:
          controller.isBuyerSelected.value == false? AppBar(
            title:     Row(
              children: [
                Image.asset(
                  'assets/image_rent/appLogo.png',
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
                const Spacer(),
                Container(
                  height: 45,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.grey.shade100,
                      width: 1,
                    ),
                  ),
                  child: Obx(
                        () => Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          // onTap: () {
                          //   controller.isBuyerSelected.value = true;
                          // },
                          onTap: () {
                            controller.isBuyerSelected.value = true;
       
                            // Scroll to top
                            scrollController.animateTo(
                              0,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
       
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 20),
                            decoration: BoxDecoration(
                              color:
                              controller.isBuyerSelected.value
                                  ? Colors.amber
                                  : Colors.white,
                              borderRadius:
                              BorderRadius.circular(16),
                            ),
                            child: Text(
                              'Buyer',
                              style: TextStyle(
                                fontSize: 12,
                                color:
                                controller.isBuyerSelected.value
                                    ? Colors.black
                                    : Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          // onTap: () {
                          //   if (isLogin == true) {
                          //     controller.isBuyerSelected.value = false;
                          //   } else {
                          //     Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                          //   }
                          //
                          // },
                          onTap: () {
                            if (isLogin == true) {
                              controller.isBuyerSelected.value = false;
                              controller.categorySelected.value = 0;
                              controller.categorytype.value = "Property";
                              scrollController.animateTo(
                                0,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                               getSellerView();
                            } else {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                            }
                          },
       
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 20),
                            decoration: BoxDecoration(
                              color:
                              !controller.isBuyerSelected.value
                                  ? Colors.amber
                                  : Colors.white,
                              borderRadius:
                              BorderRadius.circular(16),
                            ),
                            child: Text(
                              'Seller',
                              style: TextStyle(
                                fontSize: 12,
                                color: !controller
                                    .isBuyerSelected.value
                                    ? Colors.black
                                    : Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                if(isLogin == true)
                GestureDetector(
                  onTap: () {
                    Get.to(const NotificationList());
                  },
                  child:
       
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.black.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: ClipOval(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          'assets/image_rent/notification.png',
                          width: 18,
                          height: 18,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                if(isLogin == true)
                boxW10(),
                GestureDetector(
                  onTap: () {
                    print("ProfileScreen");
                    Get.to(ProfileScreen());
                  },
                  child:  profileController.profileImage.isNotEmpty
                      ? CircleAvatar(
                    radius: 18,
                    backgroundImage: CachedNetworkImageProvider(
                      profileController.profileImage.value,
                    ),
                  ):
                  Container(
                      decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.black.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/image_rent/profile.png',
                          width: 18,
                          height: 18,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ):null,
          body: SingleChildScrollView(
            controller: scrollController,
            scrollDirection: Axis.vertical,
            child: Container(
              color: AppColor.white.withOpacity(0.6),
              child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (controller.isBuyerSelected.value == true) ...[
                      Stack(clipBehavior: Clip.none, children: [
                        /// search properties
                        Container(
                          height: _height * 0.36,
                          width: _width,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(2),
                                bottomLeft: Radius.circular(2)),
                            image: DecorationImage(
                              image:
                                  AssetImage('assets/image_rent/introSignup.png'),
                              opacity: 0.8,
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 16.0, left: 16.0, top: 48.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/image_rent/appLogo.png',
                                          width: 40,
                                          height: 40,
                                          fit: BoxFit.cover,
                                        ),
                                        boxW30(),
                                        const Spacer(),
                                        Container(
                                          height: _height * 0.043,
                                          padding: const EdgeInsets.all(3),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Obx(
                                            () => Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    controller.isBuyerSelected
                                                        .value = true;
                                                  },
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                            vertical: 4,
                                                            horizontal: 20),
                                                    decoration: BoxDecoration(
                                                      color: controller
                                                              .isBuyerSelected.value
                                                          ? Colors.amber
                                                          : Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(16),
                                                    ),
                                                    child: Text(
                                                      'Buyer',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: controller
                                                                .isBuyerSelected
                                                                .value
                                                            ? Colors.black
                                                            : Colors.grey,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    // controller.isBuyerSelected
                                                    //     .value = false;
                                                    // controller.categorySelected.value = 0;
                                                    // controller.categorytype.value = "Property";
                                                    if (isLogin == true) {
                                                      controller.isBuyerSelected.value = false;
                                                      controller.categorySelected.value = 0;
                                                      controller.categorytype.value = "Property";
                                                      getSellerView();
                                                    } else {
                                                      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                                                    }
                                                  },
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                            vertical: 4,
                                                            horizontal: 20),
                                                    decoration: BoxDecoration(
                                                      color: !controller
                                                              .isBuyerSelected.value
                                                          ? Colors.amber
                                                          : Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(16),
                                                    ),
                                                    child: Text(
                                                      'Seller',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: !controller
                                                                .isBuyerSelected
                                                                .value
                                                            ? Colors.black
                                                            : Colors.grey,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const Spacer(),
                                        if(isLogin == true)
                                        GestureDetector(
                                          onTap: () {
                                            Get.to(const NotificationList());
                                          },
                                          child:    Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20),
                                              color: Colors.white,
                                              border: Border.all(
                                                color: Colors.black.withOpacity(0.2),
                                                width: 1,
                                              ),
                                            ),
                                            child: ClipOval(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Image.asset(
                                                  'assets/image_rent/notification.png',
                                                  width: 18,
                                                  height: 18,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        if(isLogin == true)
                                        boxW10(),
                                        InkWell(
                                          onTap: () {
                                            print("ProfileScreen");
                                            //Get.to(ProfileScreen());
                                            Get.to(ProfileScreen());
                                          },
                                          child: CircleAvatar(
                                            radius: 18,
                                            backgroundColor:
                                                AppColor.white.withOpacity(0.8),
                                            child: profileController.profileImage.isNotEmpty
                                                ? ClipOval(
                                              child: (profileController.profileImage.isEmpty ||
                                                  profileController.profileImage.contains('default_profile'))
                                                  ? Image.asset(
                                                'assets/image_rent/profile.png',
                                                width: 18,
                                                height: 18,
                                                fit: BoxFit.cover,
                                              )
                                                  : Image.network(
                                                profileController.profileImage.value,
                                                fit: BoxFit.cover,
                                                width: 50,
                                                height: 50,
                                                errorBuilder: (_, __, ___) => Image.asset(
                                                  'assets/image_rent/profileImg.png',
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            )
       
                                            // CircleAvatar(
                                            //   radius: 18,
                                            //   backgroundImage: CachedNetworkImageProvider(
                                            //     profileController.profileImage.value,
                                            //   ),
                                            // )
       
                                                :
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(20),
                                                color: Colors.white,
                                                border: Border.all(
                                                  color: Colors.black.withOpacity(0.2),
                                                  width: 1,
                                                ),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: ClipOval(
                                                  child: Image.asset(
                                                    'assets/image_rent/profile.png',
                                                    width: 18,
                                                    height: 18,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    boxH50(),
                                    const Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      // mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Let’s find your home that’s",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "perfect for you",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
       
                        boxH10(),
       
                        /// search field
                        Positioned(
                          bottom: -(_height * 0.03),
                          right: 25,
                          left: 25,
                          child: InkWell(
                            onTap: () {
                              Get.to( PropertySearchLocationScreen(
                                data: '',longitude: filterController.longitude.value,latitude: filterController.latitude.value,
                              ));
                            },
                            child: Container(
                              height: _height * 0.07,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: AppColor.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Text(
                                        'Search by Project, Locality, Pro...',
                                        maxLines: 1,
                                        style: TextStyle(
                                            color:
                                                AppColor.blueGrey.withOpacity(0.6),
                                            fontSize: 15,
                                        overflow: TextOverflow.ellipsis),
                                      ),
                                    ),
                                    const Spacer(),
                                    Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20.0),
                                        color: Colors.pink.withOpacity(0.7),
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          Icons.search,
                                          color: AppColor.white,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ]),
       
                      ///New Code
                      boxH30(),
       
                      /// new Continue last searches section horizontal
                      ///
       
                      // Obx(() {
                      //   if (filterController.getSaveList.isNotEmpty) {
                      //     return    SizedBox(
                      //       height: _height * 0.22,
                      //       child: Padding(
                      //         padding: const EdgeInsets.symmetric(
                      //             horizontal: 16.0, vertical: 12.0),
                      //         child: Column(
                      //           crossAxisAlignment: CrossAxisAlignment.start,
                      //           children: [
                      //             // Header Row
                      //
                      //             Row(
                      //               children: [
                      //                 const Column(
                      //                   crossAxisAlignment: CrossAxisAlignment.start,
                      //                   children: [
                      //                     Text(
                      //                       "Continue Last Searches",
                      //                       style: TextStyle(
                      //                         color: Colors.black,
                      //                         fontSize: 16,
                      //                         fontWeight: FontWeight.bold,
                      //                       ),
                      //                     ),
                      //                     SizedBox(height: 4),
                      //                     Text(
                      //                       "Go from browsing to buying",
                      //                       style: TextStyle(
                      //                         color: Colors.grey,
                      //                         fontSize: 14,
                      //                       ),
                      //                     ),
                      //                   ],
                      //                 ),
                      //                 const Spacer(),
                      //                 // Arrow Icon Container
                      //                 GestureDetector(
                      //                   onTap: (){
                      //                    setState(() {
                      //                      controller.isBuyerSelected.value=true;
                      //                      bottomBarController.selectedBottomIndex.value= 2;
                      //                    });
                      //                   },
                      //                   child: Container(
                      //                     decoration: BoxDecoration(
                      //                       borderRadius: BorderRadius.circular(20),
                      //                       color: Colors.white.withOpacity(0.7),
                      //                       border: Border.all(
                      //                         color: Colors.black.withOpacity(0.2),
                      //                         width: 1,
                      //                       ),
                      //                     ),
                      //                     child: const Padding(
                      //                       padding: EdgeInsets.all(10.0),
                      //                       child: Icon(
                      //                         Icons.arrow_forward,
                      //                         size: 18,
                      //                         color: Colors.black,
                      //                       ),
                      //                     ),
                      //                   ),
                      //                 ),
                      //               ],
                      //             ),
                      //             boxH10(),
                      //             // Horizontal ListView
                      //             Expanded(
                      //               child: Obx(()=>
                      //               ListView.builder(
                      //                 itemCount:
                      //                 filterController.getSaveList.length,
                      //                 scrollDirection: Axis.horizontal,
                      //
                      //                   itemBuilder: (context, index) {
                      //                     return GestureDetector(
                      //                       onTap: ()  {
                      //
                      //                         Get.to(() =>  FilterListScreen(
                      //                           isFrom: 'searchScreen',
                      //                           property_category_type: '',
                      //                           category_price_type: '',
                      //                           bhk_type: '',
                      //                           min_price: '',
                      //                           max_area: '',
                      //                           min_area: '',
                      //                           property_listed_by: '',
                      //                           max_price: '',
                      //                           furnish_status: '',
                      //                           property_type: '',
                      //                           amenties: '',
                      //                           city_name: filterController.getSaveList[index]['property_name'],
                      //                          // city_name:  'Pune',
                      //                         ));
                      //                       },
                      //                       child: Padding(
                      //                         padding: const EdgeInsets.only(right: 8.0),
                      //                         child: Container(
                      //                           width: 280,
                      //                           decoration: BoxDecoration(
                      //                             borderRadius: BorderRadius.circular(20),
                      //                             color: Colors.white.withOpacity(0.7),
                      //                             border: Border.all(
                      //                               color: Colors.black.withOpacity(0.2),
                      //                               width: 0.4,
                      //                             ),
                      //                           ),
                      //                           child: Padding(
                      //                             padding: const EdgeInsets.all(12.0),
                      //                             child: Row(
                      //                               children: [
                      //                                 // Text Column
                      //                                 Column(
                      //                                   crossAxisAlignment:
                      //                                   CrossAxisAlignment.start,
                      //                                   mainAxisAlignment:
                      //                                   MainAxisAlignment.center,
                      //                                   children: [
                      //                                     Text(
                      //                                      // "Buy in Kandivali West",
                      //                                       "Buy in ${filterController.getSaveList[index]['property_name']}",
                      //                                       style: const TextStyle(
                      //                                         fontSize: 16,
                      //                                         fontWeight: FontWeight.bold,
                      //                                       ),
                      //                                     ),
                      //                                     const SizedBox(height: 4),
                      //                                     Text(
                      //
                      //                                       "Save On ${DateFormat('yyyy-MM-dd').format(DateTime.parse(filterController.getSaveList[index]['saved_on']))}",
                      //                                       // DateFormat('yyyy-MM-dd').format(DateTime.parse(filterController.getSaveList[index]['saved_on'])),
                      //                                       style: TextStyle(
                      //                                         fontSize: 14,
                      //                                         color: Colors.grey.shade600,
                      //                                       ),
                      //                                     ),
                      //                                   ],
                      //                                 ),
                      //                                 const Spacer(),
                      //                                 // Icons Column
                      //                                 Column(
                      //                                   mainAxisAlignment:
                      //                                   MainAxisAlignment.center,
                      //                                   children: [
                      //                                     Icon(
                      //                                       Icons.share,
                      //                                       color: Colors.black
                      //                                           .withOpacity(0.7),
                      //                                     ),
                      //
                      //                                     /// dont delete this code
                      //                                     // CircleAvatar(
                      //                                     //     radius: 15,
                      //                                     //     backgroundColor:
                      //                                     //         Colors.grey.shade100,
                      //                                     //     child: IconButton(
                      //                                     //       onPressed: () {},
                      //                                     //       icon: const Icon(
                      //                                     //         Icons.save,
                      //                                     //         size: 15,
                      //                                     //         color: Colors.black,
                      //                                     //       ),
                      //                                     //     )),
                      //                                     // boxH15(),
                      //                                     // CircleAvatar(
                      //                                     //     radius: 15,
                      //                                     //     backgroundColor:
                      //                                     //         Colors.grey.shade100,
                      //                                     //     child: IconButton(
                      //                                     //       onPressed: () {},
                      //                                     //       icon: Icon(
                      //                                     //         Icons
                      //                                     //             .arrow_forward_ios_sharp,
                      //                                     //         size: 15,
                      //                                     //         color: Colors.black,
                      //                                     //       ),
                      //                                     //     )),
                      //                                   ],
                      //                                 ),
                      //                               ],
                      //                             ),
                      //                           ),
                      //                         ),
                      //                       ),
                      //                     );
                      //                   },
                      //                 ),
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //     );
                      //   } else {
                      //     return const SizedBox();
                      //   }
                      // }),
                      //
                      boxH20(),
                      Divider(color: Colors.grey.withOpacity(0.3), thickness: 0.2),
       
                      Obx(() {
                        if (controller.getCities.isNotEmpty) {
                          return SizedBox(
                            height: 270.h,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Explore Real Estate in Popular Indian Cities",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  boxH10(),
                                  SizedBox(
                                    height: _height * 0.25.h,
                                    width: Get.width,
                                    child: RawScrollbar(
                                      thickness: 2,
                                      thumbColor: Colors.blue,
                                      trackColor: Colors.grey,
                                      trackRadius: const Radius.circular(10),
                                      controller: _controller11,
                                      thumbVisibility: true,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 6, right: 6),
                                        child: GridView.count(
                                          childAspectRatio: 0.33,
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 6,
                                          mainAxisSpacing: 6,
                                          physics: const ClampingScrollPhysics(),
                                          scrollDirection: Axis.horizontal,
                                          controller: _controller2,
                                          children: List.generate(
                                            controller.getCities.length,
                                                (index) {
                                              return InkWell(
                                                onTap: () {
                                                  Get.to(() => ExploreCityFilter(
                                                    isFrom: 'popularCity',
                                                    city_name: controller.getCities[index]['city_name'].toString(),
                                                  ));
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(8),
                                                    border: Border.all(
                                                      color: AppColor.grey.shade200,
                                                      width: 2,
                                                    ),
                                                    color: AppColor.white,
                                                  ),
                                                  child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius: BorderRadius.circular(8),
                                                        child: controller.getCities[index]['city_img'] != null
                                                            ? Image.asset(
                                                          controller.getCities[index]['city_img'],
                                                          width: Get.width * 0.35.w,
                                                          height: _height * 0.15.h,
                                                          fit: BoxFit.cover,
                                                        )
                                                            : Container(
                                                          width: Get.width * 0.35.w,
                                                          height: _height * 0.15.h,
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(8),
                                                          ),
                                                          child: Center(
                                                            child: ClipRRect(
                                                              borderRadius: BorderRadius.circular(8),
                                                              child: Image.asset(
                                                                "assets/image_rent/delhiNcr.png",
                                                                width: Get.width * 0.35,
                                                                height: _height * 0.15,
                                                                fit: BoxFit.cover,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      boxW15(),
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Text(
                                                              controller.getCities[index]['city_name'].toString(),
                                                              style: const TextStyle(
                                                                fontSize: 16,
                                                                fontWeight: FontWeight.bold,
                                                                color: AppColor.black87,
                                                              ),
                                                            ),
                                                            boxH10(),
                                                            Text(
                                                              "${controller.getCities[index]['property_count']}+ Properties",
                                                              style: const TextStyle(
                                                                fontSize: 14,
                                                                color: Colors.grey,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        } else {
                          return const SizedBox();
                        }
                      }),
                      boxH10(),
                      Divider(color: Colors.grey.withOpacity(0.3), thickness: 0.2),
                      /// without condition Top rated builders/developers
                      boxH10(),
       
                      Container(
                        height: MediaQuery.of(context).size.height * 0.70,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(15),
                            topLeft: Radius.circular(15),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                children: [
                                  const Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Builders Projects",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        "Go from browsing to buying",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const top_rated_developer_listScreen(),)).then((value) {
                                                  postPropertyController.getHomeData(city: filterController.currentCity.value);
       
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.white.withOpacity(0.7),
                                        border: Border.all(
                                          color: Colors.black.withOpacity(0.2),
                                          width: 1,
                                        ),
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Icon(
                                          Icons.arrow_forward,
                                          size: 18,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 15),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.60,
                              width: MediaQuery.of(context).size.width,
       
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount:controller.buildersProjectList.length,
                                itemBuilder: (context, index) {
                                  return _buildProjectCard(context, controller.buildersProjectList[index]);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
       
                      /// new Explore Real Estate in Popular Indian Cities
                      Divider(color: Colors.grey.withOpacity(0.3), thickness: 0.2),
       
       
                      /// new Offers for you
                      Obx(() {
                        if (controller.getOfferList.isNotEmpty) {
                          return Container(
                            // color: Colors.grey.shade100,
                           // height: _height * 0.45,
                            height: 380.h,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Hot Deals,Discount & Offers",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: AppColor.black,
                                            ),
                                          ),
                                          Text(
                                            "Go from browsing to buying",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: AppColor.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      InkWell(
                                        onTap: () {
                                          Get.to(const offerList());
                                          if (kDebugMode) {
                                            print(controller.getOfferList);
                                          }
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            color: Colors.white.withOpacity(0.7),
                                            border: Border.all(
                                              color: Colors.black.withOpacity(0.2),
                                              width: 1,
                                            ),
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.all(10.0),
                                            child: Icon(
                                              Icons.arrow_forward,
                                              size: 18,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  boxH10(),
                                  SizedBox(
                                   // height: _height * 0.35,
                                    height: 300.h,
                                    child: ListView.builder(
                                      //itemCount: controller.getOfferList.length,
                                      itemCount: controller.getOfferList.length > 4
                                          ? 4
                                          : controller.getOfferList.length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        return  offer_card( offer_data: controller.getOfferList[index], index: index,);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return const SizedBox();
                        }
                      }),
       
                      Divider(color: Colors.grey.withOpacity(0.3), thickness: 0.2),
       
                      /// new featured properties section
                      Obx(() {
                        if (controller.getFeaturedPropery.isNotEmpty) {
                          return SizedBox(
                           // height: _height * 0.79,
                            height: 620.h,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Featured Properties",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: AppColor.black,
                                            ),
                                          ),
                                          Text(
                                            "Go from browsing to buying",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: AppColor.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      InkWell(
                                        onTap: () {
                                          Get.to(const PropertiesListScreen(
                                            isFrom: 'featured',
       
                                          ))?.then((value) {
                                            postPropertyController.getHomeData(city: filterController.currentCity.value);
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            color: Colors.white.withOpacity(0.7),
                                            border: Border.all(
                                              color: Colors.black.withOpacity(0.2),
                                              width: 1,
                                            ),
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.all(10.0),
                                            child: Icon(
                                              Icons.arrow_forward,
                                              size: 18,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  boxH15(),
                                  SizedBox(
                                    //height: _height * 0.67,
                                    height: 550.h,
                                    child: RawScrollbar(
                                      thickness: 2,
                                      thumbColor: Colors.blue,
                                      trackColor: Colors.grey,
                                      trackRadius: const Radius.circular(10),
                                      controller: _controllerOne,
                                      thumbVisibility: true,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        physics: const ClampingScrollPhysics(),
                                        controller: _controller3,
                                        itemCount:
                                            controller.getFeaturedPropery.length > 4
                                                ? 4
                                                : controller
                                                    .getFeaturedPropery.length,
                                        itemBuilder: (context, index) {
                                          return propertyCard( property_data: controller.getFeaturedPropery[index], index: index, propertyList: controller.getFeaturedPropery,);
       
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return const SizedBox();
                        }
                      }),
                     boxH15(),
                      /// new Houzza Shots
                      // SizedBox(
                      //   height: _height * 0.84,
                      //   width: Get.width,
                      //   child: Padding(
                      //     padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      //     child: Column(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         Row(
                      //           children: [
                      //             const Column(
                      //               crossAxisAlignment: CrossAxisAlignment.start,
                      //               mainAxisAlignment: MainAxisAlignment.start,
                      //               children: [
                      //                 Text(
                      //                   "Houzza Shorts",
                      //                   style: TextStyle(
                      //                     fontSize: 16,
                      //                     fontWeight: FontWeight.bold,
                      //                     color: AppColor.black,
                      //                   ),
                      //                 ),
                      //                 Text(
                      //                   "Go from browsing to buying",
                      //                   style: TextStyle(
                      //                     fontSize: 14,
                      //                     color: AppColor.grey,
                      //                   ),
                      //                 ),
                      //               ],
                      //             ),
                      //             const Spacer(),
                      //             InkWell(
                      //               onTap: () {
                      //                 // Get.to(PropertiesListScreen(
                      //                 //   isFrom: 'featured',
                      //                 //   data: controller.getFeaturedPropery,
                      //                 // ));
                      //               },
                      //               child: Container(
                      //                 decoration: BoxDecoration(
                      //                   borderRadius: BorderRadius.circular(20),
                      //                   color: Colors.white.withOpacity(0.7),
                      //                   border: Border.all(
                      //                     color: Colors.black.withOpacity(0.2),
                      //                     width: 1,
                      //                   ),
                      //                 ),
                      //                 child:  Padding(
                      //                   padding: const EdgeInsets.all(10.0),
                      //                   child: GestureDetector(
                      //                     onTap: goToAppStore,
                      //                     child: const Icon(
                      //                       Icons.arrow_forward,
                      //                       size: 18,
                      //                       color: Colors.black,
                      //                     ),
                      //                   ),
                      //                 ),
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //         SizedBox(
                      //           height: _height * 0.74,
                      //           width: Get.width,
                      //           child: RawScrollbar(
                      //             thickness: 2,
                      //             thumbColor: Colors.blue,
                      //             trackColor: Colors.grey,
                      //             trackRadius: const Radius.circular(10),
                      //             controller: _controller4,
                      //             thumbVisibility: true,
                      //             child: Padding(
                      //               padding: const EdgeInsets.only(top: 8.0),
                      //               child: GridView.builder(
                      //                 scrollDirection: Axis.horizontal,
                      //                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      //                   crossAxisCount: 2,
                      //                   crossAxisSpacing: 8.0,
                      //                   mainAxisSpacing: 8.0,
                      //                   childAspectRatio: 1.6,
                      //                 ),
                      //                 itemCount: videoController.myVideosDataList?.length ?? 0,
                      //                 physics: const AlwaysScrollableScrollPhysics(),
                      //                 itemBuilder: (context, index) {
                      //                   final videoItem = videoController.myVideosDataList?[index];
                      //                   if (videoItem == null) return Container();
                      //
                      //                   // Safely access nested properties
                      //                   final videoData = videoItem['video'] as Map<String, dynamic>?;
                      //                   final thumbnailUrl = videoData?['thumbnail']?.toString();
                      //                   final caption = videoData?['video_caption']?.toString() ?? 'No Title';
                      //
                      //                   return GestureDetector(
                      //                     // onTap: goToAppStore,
                      //                     onTap: () {
                      //                       videoController.currentPage.value = index;
                      //
                      //                       Get.toNamed(Routes.PROFILE_VIDEOS_SCREEN)!.whenComplete(() async {
                      //                         if (videoController.myVideosDataList.isNotEmpty) {
                      //                           videoController.myVideosDataList[videoController.currentPage.value]["controller"]!
                      //                               .pause();
                      //                         }
                      //                       });
                      //
                      //                       // Wait 10 seconds, then go to App Store page
                      //                       Future.delayed(const Duration(seconds: 10), () {
                      //                       Navigator.pop(context);
                      //                         goToAppStore();
                      //                       });
                      //                     },
                      //
                      //                     child: Container(
                      //                       width: Get.width * 0.2,
                      //                       decoration: BoxDecoration(
                      //                         borderRadius: BorderRadius.circular(20),
                      //                         border: Border.all(color: Colors.grey, width: 0.1),
                      //                       ),
                      //                       child: ClipRRect(
                      //                         borderRadius: BorderRadius.circular(20),
                      //                         child: Stack(
                      //                           children: [
                      //                             // CachedNetworkImage with proper null checks
                      //                             if (thumbnailUrl != null && thumbnailUrl.isNotEmpty)
                      //                               CachedNetworkImage(
                      //                                 imageUrl: '${APIShortsString.thumbnailBaseUrl}$thumbnailUrl',
                      //                                 fit: BoxFit.cover,
                      //                                 width: double.infinity,
                      //                                 height: double.infinity,
                      //                                 placeholder: (context, url) => Container(
                      //                                   color: Colors.grey[200],
                      //                                   child: const Center(
                      //                                     child: CircularProgressIndicator(),
                      //                                   ),
                      //                                 ),
                      //                                 errorWidget: (context, url, error) {
                      //                                   print('Error loading image: $url, $error');
                      //                                   return Container(
                      //                                     color: Colors.grey[200],
                      //                                     child: const Icon(Icons.error),
                      //                                   );
                      //                                 },
                      //                               )
                      //                             else
                      //                               Container(
                      //                                 color: Colors.grey[200],
                      //                                 child: const Center(child: Icon(Icons.image_not_supported)),
                      //                               ),
                      //
                      //                             // Gradient Overlay
                      //                             Positioned(
                      //                               bottom: 0,
                      //                               left: 0,
                      //                               right: 0,
                      //                               child: Container(
                      //                                 height: 120,
                      //                                 decoration: BoxDecoration(
                      //                                   gradient: LinearGradient(
                      //                                     begin: Alignment.bottomCenter,
                      //                                     end: Alignment.topCenter,
                      //                                     colors: [
                      //                                       Colors.black.withOpacity(0.6),
                      //                                       Colors.black.withOpacity(0.0),
                      //                                     ],
                      //                                   ),
                      //                                 ),
                      //                               ),
                      //                             ),
                      //
                      //                             // Title and Duration
                      //                             Positioned(
                      //                               bottom: 12,
                      //                               left: 12,
                      //                               right: 12,
                      //                               child: Column(
                      //                                 crossAxisAlignment: CrossAxisAlignment.start,
                      //                                 children: [
                      //                                   CircleAvatar(
                      //                                     radius: 20,
                      //                                     backgroundColor: Colors.white,
                      //                                     child: ClipRRect(
                      //                                       borderRadius: BorderRadius.circular(20),
                      //                                       child: Image.asset(
                      //                                         'assets/property.png',
                      //                                         fit: BoxFit.cover,
                      //                                         width: 36,
                      //                                         height: 36,
                      //                                       ),
                      //                                     ),
                      //                                   ),
                      //                                   const SizedBox(height: 4),
                      //                                   Text(
                      //                                     caption,
                      //                                     style: const TextStyle(
                      //                                       color: Colors.white,
                      //                                       fontSize: 16,
                      //                                       fontWeight: FontWeight.bold,
                      //                                     ),
                      //                                     overflow: TextOverflow.ellipsis,
                      //                                     maxLines: 2,
                      //                                   ),
                      //                                   const Text(
                      //                                     '30 Min',
                      //                                     style: TextStyle(
                      //                                       color: Colors.white70,
                      //                                       fontSize: 12,
                      //                                     ),
                      //                                   ),
                      //                                 ],
                      //                               ),
                      //                             ),
                      //                           ],
                      //                         ),
                      //                       ),
                      //                     ),
                      //                   );
                      //                 },
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
       
                      /// new ui recommended properties section

                      Obx(() {
                        if (controller.getRecommendedPropertyList.isNotEmpty) {
                          return SizedBox(
                            // height: _height * 0.8,
                            height: 620.h,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Exclusive Recommended",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight:
                                              FontWeight.bold,
                                              color: AppColor.black,
                                            ),
                                          ),
                                          Text(
                                            "Go from browsing to buying",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: AppColor.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      InkWell(
                                        onTap: () {
                                          // Get.to(
                                          //     const PropertiesListScreen(
                                          //       isFrom: 'recommended',
                                          //
                                          //     ));
       
                                          Get.to(const PropertiesListScreen(
                                            isFrom: 'recommended',
                                          ))?.then((value) {
                                            postPropertyController.getHomeData(city: filterController.currentCity.value);
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius
                                                .circular(20),
                                            color: Colors.white
                                                .withOpacity(0.7),
                                            border: Border.all(
                                              color: Colors.black
                                                  .withOpacity(0.2),
                                              width: 1,
                                            ),
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.all(
                                                10.0),
                                            child: Icon(
                                              Icons.arrow_forward,
                                              size: 18,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  boxH20(),
                                  SizedBox(
                                    // height: _height * 0.68,
                                    height: 550.h,
                                    child: RawScrollbar(
                                      thickness: 2,
                                      thumbColor: Colors.blue,
                                      trackColor: Colors.grey,
                                      trackRadius: const Radius.circular(10),
                                      controller: _controller5,
                                      thumbVisibility: true,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        physics: const ClampingScrollPhysics(),
                                        controller: _controller6,
                                        itemCount: controller.getRecommendedPropertyList.length > 4
                                            ? 4
                                            : controller.getRecommendedPropertyList.length,
                                        itemBuilder: (context, index) {
                                          return   propertyCard( property_data: controller.getRecommendedPropertyList[index],
                                            index: index, propertyList: controller.getRecommendedPropertyList,);
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return const SizedBox();
                        }
                      }),
       
                      /// new ui Select the category go from browsing to buying
                      SizedBox(
                        // height: _height * 0.48,
                        height: 400.h,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              boxH20(),
                              const Row(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Select Category",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: AppColor.black,
                                        ),
                                      ),
                                      Text(
                                        "Go from browsing to buying",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppColor.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              boxH10(),
                              SizedBox(
                                // height: _height * 0.38,
                                height: 300.h,
                                width: Get.width,
                                child: RawScrollbar(
                                  thickness: 2,
                                  thumbColor: Colors.blue,
                                  trackColor: Colors.grey,
                                  trackRadius: const Radius.circular(20),
                                  controller: _controller7,
                                  thumbVisibility: true,
                                  child: Obx(()=>


                                      ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        physics: const ClampingScrollPhysics(),
                                        controller: _controller8,
                                        itemCount: controller.OwnerListedBy.length,
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                            onTap: () {
                                              Get.to(() =>  OwnerTypeFilter(
                                                //controller.OwnerListedBy[index]['user_type'],
                                                isFrom: 'selectCategory',

                                                property_listed_by: controller.OwnerListedBy[index]['user_type'],


                                                city_name:filterController.currentCity.value,
                                                // city_name:  'Pune',
                                              ));

                                            },
                                            child: Container(
                                              width: Get.width * 0.6,
                                              margin: const EdgeInsets.symmetric(
                                                  horizontal: 2),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(20),
                                                border: Border.all(
                                                    color: AppColor.grey
                                                        .withOpacity(0.01)),
                                                color: AppColor.white,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                                children: [
                                                  // Main Image
                                                  Padding(
                                                    padding: const EdgeInsets.all(4.0),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                      BorderRadius.circular(5),
                                                      child: Center(
                                                        child: Image.asset(
                                                          "assets/image_rent/categoryProperty.png",
                                                          width: 190,
                                                          height: 100,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment.center,
                                                        children: List.generate(2, (i) {
                                                          return ClipRRect(
                                                            borderRadius:
                                                            BorderRadius.circular(
                                                                5),
                                                            child: Center(
                                                              child: Image.asset(
                                                                "assets/image_rent/propertyPlan.png",
                                                                width: 90,
                                                                height:
                                                                60, // Increased from 80 to 100
                                                                fit: BoxFit
                                                                    .cover, // Added to maintain aspect ratio
                                                              ),
                                                            ),
                                                          );
                                                        }),
                                                      ),
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets.symmetric(
                                                          vertical: 8.0,
                                                          horizontal: 30.0,
                                                        ),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              controller.OwnerListedBy[index]['property_count'].toString(),
                                                              style: const TextStyle(
                                                                color:
                                                                Color(0xFF813BEA),
                                                                fontSize: 18,
                                                                fontWeight:
                                                                FontWeight.bold,
                                                              ),
                                                            ),
                                                            Text(
                                                              controller.OwnerListedBy[index]['user_type'],
                                                              style: TextStyle(
                                                                color: black
                                                                    .withOpacity(0.7),
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                            boxH20(),
                                                            Row(
                                                              children: [
                                                                const Text(
                                                                  "Explore",
                                                                  style: TextStyle(
                                                                    color: Color(
                                                                        0xFF563EE2),
                                                                    fontSize: 16,
                                                                    fontWeight:
                                                                    FontWeight.w600,
                                                                  ),
                                                                ),
                                                                boxW10(),
                                                                const Icon(
                                                                  Icons.arrow_forward,
                                                                  color:
                                                                  Color(0xFF563EE2),
                                                                  size: 20,
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
       
                      ///new ui Explore our services
                      SizedBox(
                        // height: _height * 0.52,
                        height:400.h,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Explore our services",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: AppColor.black,
                                        ),
                                      ),
                                      Text(
                                        "Go from browsing to buying",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppColor.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              boxH10(),
                              SizedBox(
                                // height: _height * 0.45,
                                height: 300.h,
                                width: Get.width,
                                child: RawScrollbar(
                                  thickness: 2,
                                  thumbColor: Colors.blue,
                                  trackColor: Colors.grey,
                                  trackRadius: const Radius.circular(20),
                                  controller: _controller9,
                                  thumbVisibility: true,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    physics: const ClampingScrollPhysics(),
                                    controller: _controller10,
                                    itemCount: controller.propertyCategories.length,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {

                                          Get.to(() =>  ExploreServiceFilterList(
                                            //controller.OwnerListedBy[index]['user_type'],
                                            isFrom: 'searchScreen',
                                            property_type: controller.propertyCategories[index]['property_type'],

                                            // city_name:  'Pune',
                                          ));
                                        },
                                        child: Container(
                                          width: 250.w,
                                          margin: const EdgeInsets.symmetric(horizontal: 2),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            border: Border.all(color: AppColor.grey.withOpacity(0.01)),
                                            color: AppColor.white,
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              // Top main image
                                              Padding(
                                                padding: const EdgeInsets.all(4.0),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(5),
                                                  child: Image.asset(
                                                    "assets/image_rent/propertyPlan.png",
                                                    width: 250.w,
                                                    height: 100.h,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),

                                              // Two side-by-side images
                                              Row(
                                                children: List.generate(2, (i) {
                                                  return Expanded(
                                                    child: Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(5),
                                                        child: Image.asset(
                                                          "assets/image_rent/categoryProperty.png",
                                                          height: 60.h,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }),
                                              ),

                                              // Text content
                                              Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      controller.propertyCategories[index]['title'],
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      controller.propertyCategories[index]['description'],
                                                      style: TextStyle(
                                                        color: black.withOpacity(0.7),
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
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
                      boxH50(),
                      boxH10(),
                      // boxH50(),
       
                    ],
       
                    if (controller.isBuyerSelected.value == false) ...[
       
                      Padding(
                        padding: const EdgeInsets.only(
                            right: 16.0, left: 16.0, top: 48.0),
                        child: Column(
                          children: [
       
                            // Row(
                            //   children: [
                            //     Image.asset(
                            //       'assets/image_rent/appLogo.png',
                            //       width: 40,
                            //       height: 40,
                            //       fit: BoxFit.cover,
                            //     ),
                            //     const Spacer(),
                            //     Container(
                            //       height: 45,
                            //       padding: const EdgeInsets.all(4),
                            //       decoration: BoxDecoration(
                            //         color: Colors.white,
                            //         borderRadius: BorderRadius.circular(20),
                            //         border: Border.all(
                            //           color: Colors.grey.shade100,
                            //           width: 1,
                            //         ),
                            //       ),
                            //       child: Obx(
                            //             () => Row(
                            //           mainAxisSize: MainAxisSize.min,
                            //           children: [
                            //             GestureDetector(
                            //               onTap: () {
                            //                 controller.isBuyerSelected.value = true;
                            //               },
                            //               child: Container(
                            //                 padding: const EdgeInsets.symmetric(
                            //                     vertical: 8, horizontal: 20),
                            //                 decoration: BoxDecoration(
                            //                   color:
                            //                   controller.isBuyerSelected.value
                            //                       ? Colors.amber
                            //                       : Colors.white,
                            //                   borderRadius:
                            //                   BorderRadius.circular(16),
                            //                 ),
                            //                 child: Text(
                            //                   'Buyer',
                            //                   style: TextStyle(
                            //                     fontSize: 12,
                            //                     color:
                            //                     controller.isBuyerSelected.value
                            //                         ? Colors.black
                            //                         : Colors.grey,
                            //                     fontWeight: FontWeight.bold,
                            //                   ),
                            //                 ),
                            //               ),
                            //             ),
                            //             GestureDetector(
                            //               onTap: () {
                            //                 if (isLogin == true) {
                            //                   controller.isBuyerSelected.value = false;
                            //                 } else {
                            //                   Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                            //                 }
                            //
                            //               },
                            //               child: Container(
                            //                 padding: const EdgeInsets.symmetric(
                            //                     vertical: 8, horizontal: 20),
                            //                 decoration: BoxDecoration(
                            //                   color:
                            //                   !controller.isBuyerSelected.value
                            //                       ? Colors.amber
                            //                       : Colors.white,
                            //                   borderRadius:
                            //                   BorderRadius.circular(16),
                            //                 ),
                            //                 child: Text(
                            //                   'Seller',
                            //                   style: TextStyle(
                            //                     fontSize: 12,
                            //                     color: !controller
                            //                         .isBuyerSelected.value
                            //                         ? Colors.black
                            //                         : Colors.grey,
                            //                     fontWeight: FontWeight.bold,
                            //                   ),
                            //                 ),
                            //               ),
                            //             ),
                            //           ],
                            //         ),
                            //       ),
                            //     ),
                            //     const Spacer(),
                            //     GestureDetector(
                            //       onTap: () {
                            //         Get.to(const NotificationList());
                            //       },
                            //       child: CircleAvatar(
                            //         radius: 18,
                            //         backgroundColor:
                            //         AppColor.white.withOpacity(0.8),
                            //         child: ClipOval(
                            //           child: Image.asset(
                            //             'assets/image_rent/notification.png',
                            //             width: 18,
                            //             height: 18,
                            //             fit: BoxFit.cover,
                            //           ),
                            //         ),
                            //       ),
                            //     ),
                            //     boxW10(),
                            //     GestureDetector(
                            //       onTap: () {
                            //         print("ProfileScreen");
                            //         Get.to(ProfileScreen());
                            //       },
                            //       child:  profileController.profileImage.isNotEmpty
                            //           ? CircleAvatar(
                            //         radius: 18,
                            //         backgroundImage: CachedNetworkImageProvider(
                            //           profileController.profileImage.value,
                            //         ),
                            //       ):
                            //       CircleAvatar(
                            //         radius: 18,
                            //         backgroundColor:
                            //         AppColor.white.withOpacity(0.8),
                            //         child: ClipOval(
                            //           child: Image.asset(
                            //             'assets/image_rent/profile.png',
                            //             width: 18,
                            //             height: 18,
                            //             fit: BoxFit.cover,
                            //           ),
                            //         ),
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            // boxH20(),
       
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Your Leads",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "Go from browsing to buying",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 13,
                                      ),
                                    )
                                  ],
                                ),
                                customIconButton(
                                  icon: Icons.arrow_forward,
                                  onTap: ()  => Get.to(const MyLeads()),
                                ),
                              ],
                            ),
                            boxH20(),
       
                            // SizedBox(
                            //   height: 45,
                            //   child: ListView.builder(
                            //     scrollDirection: Axis.horizontal,
                            //     itemCount: controller.sellerViewType.length,
                            //     itemBuilder: (context, index) {
                            //       bool categoryIsSelected =
                            //           controller.categorySelected.value == index;
                            //       return GestureDetector(
                            //         onTap: () async {
                            //           setState(() {
                            //             controller.categorySelected.value = index;
                            //             controller.categorytype.value =
                            //                 controller.sellerViewType[index];
                            //             print('selected view ${controller.sellerViewType[index]}');
                            //           });
                            //           await  controller.enquiryCallBack(controller.sellerViewType[index]);
                            //         },
                            //         child: Container(
                            //           width: 100,
                            //           margin: const EdgeInsets.symmetric(
                            //               horizontal: 4.0),
                            //           padding: const EdgeInsets.symmetric(
                            //               horizontal: 5.0, vertical: 5.0),
                            //           decoration: BoxDecoration(
                            //             borderRadius: BorderRadius.circular(10),
                            //             color: categoryIsSelected
                            //                 ? AppColor.secondaryThemeColor
                            //                 : Colors.white.withOpacity(0.7),
                            //             border: Border.all(
                            //               color: categoryIsSelected
                            //                   ? AppColor.secondaryThemeColor
                            //                   : Colors.grey,
                            //               width: 1,
                            //             ),
                            //           ),
                            //           child: Row(
                            //             mainAxisAlignment: MainAxisAlignment.center,
                            //             crossAxisAlignment:
                            //                 CrossAxisAlignment.center,
                            //             children: [
                            //               Center(
                            //                 child: Text(
                            //                   controller.sellerViewType[index],
                            //                   style: TextStyle(
                            //                     color: categoryIsSelected
                            //                         ? Colors.black
                            //                         : Colors.grey,
                            //                     fontSize: 14,
                            //                   ),
                            //                 ),
                            //               ),
                            //             ],
                            //           ),
                            //         ),
                            //       );
                            //     },
                            //   ),
                            // ),
                            SizedBox(
                              height: 45,
                              child: Row(
                                children: [
                                  if (/* showPropertyButton condition */ true) // Replace with actual condition
                                    GestureDetector(
                                      onTap: () async {
                                        setState(() {
                                          controller.categorySelected.value = 0;
                                          controller.categorytype.value = "Property";
                                          print('selected view Property');
                                        });
                                        await controller.enquiryCallBack("Property");
                                      },
                                      child: Container(
                                        width: 100,
                                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                                        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: controller.categorySelected.value == 0
                                              ? AppColor.secondaryThemeColor
                                              : Colors.white.withOpacity(0.7),
                                          border: Border.all(
                                            color: controller.categorySelected.value == 0
                                                ? AppColor.secondaryThemeColor
                                                : Colors.grey,
                                            width: 1,
                                          ),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            "Property",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  if (profileController.userType.value.toLowerCase() != 'owner')
                                    GestureDetector(
                                      onTap: () async {
                                        setState(() {
                                          controller.categorySelected.value = 1;
                                          controller.categorytype.value = "Projects";
                                          print('selected view Projects');
                                        });
                                        await controller.enquiryCallBack("Projects");
                                      },
                                      child: Container(
                                        width: 100,
                                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                                        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: controller.categorySelected.value == 1
                                              ? AppColor.secondaryThemeColor
                                              : Colors.white.withOpacity(0.7),
                                          border: Border.all(
                                            color: controller.categorySelected.value == 1
                                                ? AppColor.secondaryThemeColor
                                                : Colors.grey,
                                            width: 1,
                                          ),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            "Projects",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
       
                            boxH20(),
                            //// Your leads properties all
       
                            SizedBox(
                              height: _height * 0.40,
                              width: MediaQuery.of(context).size.width,
                              child: Obx(() {
                                final isProperty = controller.categorySelected.value == 0;
                                final leads = isProperty
                                    ? controller.getProperyEnquiryList
                                    : controller.getProjectEnquiryList;
       
                                if (leads.isEmpty) {
                                  return const Center(
                                    child: Text(
                                      'No Leads found',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.blueGrey,
                                      ),
                                    ),
                                  );
                                }
       
                                return ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: leads.length,
                                  itemBuilder: (context, index) {
                                    var lead = leads[index];
                                    return isProperty
                                        ? propertyLeadsCard(lead, context)
                                        : ProjectLeadsCard(lead, context);
                                  },
                                );
                              }),
                            ),
       
                            boxH20(),
                            const Text(
                              "Statistics Locked",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
       
                            boxH20(),
                            if (profileController.userType.value.toLowerCase() != 'owner')
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              height: _height * 0.4,
                              width: _width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white.withOpacity(0.7),
                                border: Border.all(
                                  color: Colors.grey.shade200,
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                children: [
       
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                       Text(
                                        controller.categorySelected.value == 0 ?
                                        "Property Leads":"Project Leads",
                                        style: const TextStyle(
                                            color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,),
                                      ),
                                      Obx(() {
                                        final from = homeController.fromDate.value !=
                                                null
                                            ? DateFormat('MMM d')
                                                .format(homeController.fromDate.value!)
                                            : 'Select';
       
                                        final to = homeController.toDate.value != null
                                            ? DateFormat('MMM d')
                                                .format(homeController.toDate.value!)
                                            : 'Select';
       
                                        return Align(
                                          alignment: Alignment.topRight,
                                          child: GestureDetector(
                                            onTap: () {
                                              homeController.selectDateRange(context).then((value) => getSellerView());
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                color: Colors.white.withOpacity(0.7),
                                                border: Border.all(
                                                  color: Colors.grey.shade400,
                                                  width: 1,
                                                ),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text('$from - $to'),
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                    ],
                                  ),
                                  Expanded(
                                    child: BarChart(
                                      BarChartData(
                                        // barTouchData: BarTouchData(
                                        //   enabled: false,
                                        // ),
                                        barTouchData: BarTouchData(
                                          enabled: true,
                                          touchTooltipData: BarTouchTooltipData(
       
                                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                              return BarTooltipItem(
                                                rod.toY.toStringAsFixed(0),
                                                const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
       
                                        titlesData: FlTitlesData(
                                          show: true,
                                          bottomTitles: AxisTitles(
                                            sideTitles: SideTitles(
                                                showTitles: true,
                                                reservedSize: 45,
                                                getTitlesWidget: getTitles),
                                          ),
                                          leftTitles: const AxisTitles(
                                              sideTitles:
                                                  SideTitles(showTitles: false)),
                                          topTitles: const AxisTitles(
                                              sideTitles:
                                                  SideTitles(showTitles: false)),
                                          rightTitles: const AxisTitles(
                                              sideTitles:
                                                  SideTitles(showTitles: false)),
                                        ),
                                        borderData: FlBorderData(show: false),
                                        barGroups: controller.categorySelected.value == 0 ? propertyBarGroups : projectBarGroups,
                                        gridData: const FlGridData(show: false),
                                        alignment: BarChartAlignment.spaceBetween,
                                        maxY: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (profileController.userType.value.toLowerCase() != 'owner')
                            boxH20(),
       
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              height: Get.height * 0.4,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white.withOpacity(0.7),
                                border: Border.all(
                                  color: Colors.grey.shade200,
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Views",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Obx(() {
                                        final from =
                                            homeController.fromDate.value != null
                                                ? DateFormat('MMM d').format(
                                                    homeController.fromDate.value!)
                                                : 'Select';
       
                                        final to =
                                            homeController.toDate.value != null
                                                ? DateFormat('MMM d').format(
                                                    homeController.toDate.value!)
                                                : 'Select';
       
                                        return Align(
                                          alignment: Alignment.topRight,
                                          child: GestureDetector(
                                            onTap: () {
                                              homeController
                                                  .selectDateRange(context).then((value) => getSellerView());
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color:
                                                    Colors.white.withOpacity(0.7),
                                                border: Border.all(
                                                  color: Colors.grey.shade400,
                                                  width: 1,
                                                ),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text('$from - $to'),
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Expanded(
                                    child:
                                    // Obx(() => CombinedBarLineChart(
                                    //   rawData: controller.viewsData.cast<Map<String, dynamic>>().toList(),
                                    // ))
                                    Stack(
                                      children: [
                                        /// Bar Chart - with proper date-based X values
                                        BarChart(
                                          BarChartData(
                                            barGroups: propertyBarGroupsForViews, // x: date as index
                                            titlesData: FlTitlesData(
                                              bottomTitles: AxisTitles(sideTitles: bottomTitles),
                                              leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                            ),
                                            borderData: FlBorderData(show: false),
                                            gridData: const FlGridData(show: false),
                                            barTouchData: BarTouchData(
                                              enabled: true,
                                              touchTooltipData: BarTouchTooltipData(
                                                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                                  return BarTooltipItem(
                                                    '${rod.toY.round()}',
                                                    const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
       
                                        /// Line Chart - sharing same x-indexes
                                        Padding(
                                          padding: const EdgeInsets.all(35.0),
                                          child: LineChart(
                                            LineChartData(
                                              gridData: const FlGridData(show: false),
                                              titlesData: const FlTitlesData(show: false),
                                              borderData: FlBorderData(show: false),
                                              minY: 0,
                                              lineTouchData: LineTouchData(
                                                touchTooltipData: LineTouchTooltipData(
                                                  getTooltipItems: (touchedSpots) {
                                                    return touchedSpots.map((spot) {
                                                      return LineTooltipItem(
                                                        '${spot.y.round()} views',
                                                        const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                                      );
                                                    }).toList();
                                                  },
                                                ),
                                              ),
                                              lineBarsData: [
                                                LineChartBarData(
                                                  isCurved: true,
                                                  color: AppColor.primaryThemeColor.withOpacity(0.9),
                                                  spots: controller.viewsData.asMap().entries.map((entry) {
                                                    final index = entry.key;
                                                    final data = entry.value;
                                                    return FlSpot(
                                                      index.toDouble(), // Ensure it matches BarChartGroupData x value
                                                      (data['views'] ?? 0).toDouble(),
                                                    );
                                                  }).toList(),
                                                  dotData: const FlDotData(show: true),
                                                  belowBarData: BarAreaData(show: false),
                                                  barWidth: 2,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
       
       
                                    // Stack(
                                    //   children: [
                                    //     // BarChart(
                                    //     //   BarChartData(
                                    //     //     gridData: const FlGridData(show: false),
                                    //     //     titlesData: FlTitlesData(
                                    //     //       show: true,
                                    //     //       bottomTitles: AxisTitles(sideTitles: bottomTitles),
                                    //     //       leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                    //     //       rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                    //     //       topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                    //     //
                                    //     //     ),
                                    //     //     borderData: FlBorderData(show: false),
                                    //     //
                                    //     //     barGroups: propertyBarGroupsForViews,
                                    //     //   ),
                                    //     // ),
                                    //     BarChart(
                                    //       BarChartData(
                                    //         gridData: const FlGridData(show: false),
                                    //         borderData: FlBorderData(show: false),
                                    //         barTouchData: BarTouchData(
                                    //           enabled: true,
                                    //           touchTooltipData: BarTouchTooltipData(
                                    //
                                    //             getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                    //               return BarTooltipItem(
                                    //                 '${rod.toY.round()}',
                                    //                 const TextStyle(
                                    //                   color: Colors.white,
                                    //                   fontWeight: FontWeight.bold,
                                    //                 ),
                                    //               );
                                    //             },
                                    //           ),
                                    //         ),
                                    //         titlesData: FlTitlesData(
                                    //           show: true,
                                    //           bottomTitles: AxisTitles(sideTitles: bottomTitles),
                                    //           leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                    //           rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                    //           topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                    //         ),
                                    //         barGroups: propertyBarGroupsForViews,
                                    //       ),
                                    //     ),
                                    //
                                    //     // LineChart(
                                    //     //   LineChartData(
                                    //     //     gridData: const FlGridData(show: false), // Hide grid for cleaner overlap
                                    //     //     titlesData: const FlTitlesData(show: false), // Hide all titles
                                    //     //     borderData: FlBorderData(show: false),
                                    //     //     minY: 0, // Start from 0 for better visualization
                                    //     //     lineBarsData: [
                                    //     //       LineChartBarData(
                                    //     //         color: AppColor.primaryThemeColor.withOpacity(0.8),
                                    //     //         spots: controller.viewsData.asMap().entries.map((entry) {
                                    //     //           final index = entry.key;
                                    //     //           final data = entry.value;
                                    //     //           return FlSpot(
                                    //     //             index.toDouble(),
                                    //     //             (data['views'] ?? 0).toDouble(),
                                    //     //           );
                                    //     //         }).toList(),
                                    //     //         // isCurved: true, // Make it curved for better visual
                                    //     //         dotData: const FlDotData(show: true),
                                    //     //         belowBarData: BarAreaData(show: false),
                                    //     //         barWidth: 2, // Make line thinner
                                    //     //       ),
                                    //     //     ],
                                    //     //   ),
                                    //     // ),
                                    //   ],
                                    // ),
                                  ),
                                ],
                              ),
                            ),
       
                            boxH20(),
       
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              height: Get.height * 0.5,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white.withOpacity(0.7),
                                border: Border.all(
                                  color: Colors.grey.shade200,
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Virtual Tour",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Obx(() {
                                        final from =
                                            homeController.fromDate.value != null
                                                ? DateFormat('MMM d').format(
                                                    homeController.fromDate.value!)
                                                : 'Select';
       
                                        final to =
                                            homeController.toDate.value != null
                                                ? DateFormat('MMM d').format(
                                                    homeController.toDate.value!)
                                                : 'Select';
       
                                        return Align(
                                          alignment: Alignment.topRight,
                                          child: GestureDetector(
                                            onTap: () {
                                              homeController
                                                  .selectDateRange(context).then((value) => getSellerView());
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color:
                                                    Colors.white.withOpacity(0.7),
                                                border: Border.all(
                                                  color: Colors.grey.shade400,
                                                  width: 1,
                                                ),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text('$from - $to'),
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Expanded(
                                    child:
       
                                        BarChart(
                                      BarChartData(
                                        barTouchData: BarTouchData(
                                          enabled: true,
                                          touchTooltipData: BarTouchTooltipData(
                                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                              return BarTooltipItem(
                                                '${rod.toY.round()}', // tooltip content
                                                const TextStyle(
                                                  color: Colors.white,  // ✅ Set tooltip text color to white
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        titlesData: FlTitlesData(
                                          show: true,
                                          bottomTitles: AxisTitles(
                                            sideTitles: SideTitles(
                                                showTitles: true,
                                                reservedSize: 30,
                                                getTitlesWidget: getTitles),
                                          ),
                                          leftTitles: const AxisTitles(
                                              sideTitles:
                                                  SideTitles(showTitles: false)),
                                          topTitles: const AxisTitles(
                                              sideTitles:
                                                  SideTitles(showTitles: false)),
                                          rightTitles: const AxisTitles(
                                              sideTitles:
                                                  SideTitles(showTitles: false)),
                                        ),
                                        borderData: FlBorderData(show: false),
                                        barGroups:  controller.categorySelected.value == 0 ? propertyBarGroupsForTour : projectBarGroupsForTour,
                                        gridData: const FlGridData(show: false),
                                        alignment: BarChartAlignment.spaceAround,
                                        maxY: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
       
                            boxH20(),
       
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              height: Get.height * 0.5,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white.withOpacity(0.7),
                                border: Border.all(
                                  color: Colors.grey.shade200,
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Obx(() {
       
                                    return Text(
                                      controller.categorySelected.value == 0 ? 'Posted Properties' : 'Posted Projects',
                                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                    );
                                  }),
                                  const SizedBox(height: 20),
                                  Expanded(
                                    child: PieChart(
                                      PieChartData(
                                        pieTouchData: PieTouchData(
                                          touchCallback: (FlTouchEvent event,
                                              pieTouchResponse) {
                                            setState(() {
                                              if (!event
                                                      .isInterestedForInteractions ||
                                                  pieTouchResponse == null ||
                                                  pieTouchResponse.touchedSection ==
                                                      null) {
                                                touchedIndex = -1;
                                                return;
                                              }
                                              touchedIndex = pieTouchResponse
                                                  .touchedSection!
                                                  .touchedSectionIndex;
                                            });
                                          },
                                        ),
                                        borderData: FlBorderData(
                                          show: false,
                                        ),
                                        sectionsSpace: 0,
                                        centerSpaceRadius: 60,
                                        sections: showingSections(),
                                      ),
                                    ),
                                  ),
                                  Obx(() => ListView(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    children: [
                                      controller.categorySelected.value == 0?
                                      _buildLegendRow(
                                        color: AppColor.primaryThemeColor,
                                        label: 'Property',
                                        percentage: profileController.postPropertiesPercentage['property_percentage'] ?? 0,
                                      ):
                                      _buildLegendRow(
                                        color: AppColor.amber,
                                        label: 'Project',
                                        percentage: profileController.postPropertiesPercentage['project_percentage'] ?? 0,
                                      ),
                                      _buildLegendRow(
                                        color: AppColor.green,
                                        label: 'Residential',
                                        percentage: profileController.postPropertiesPercentage['residential_percentage'] ?? 0,
                                      ),
                                      _buildLegendRow(
                                        color: AppColor.lightBlue,
                                        label: 'Commercial',
                                        percentage: profileController.postPropertiesPercentage['commercial_percentage'] ?? 0,
                                      ),
                                    ],
                                  ))
       
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 100,
                            )
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
     ),
    );
  }
  Widget _buildLegendRow({
    required Color color,
    required String label,
    required dynamic percentage,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            color: color,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            '$percentage%',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
  void openStoreUrl(String url, {required String storeName}) async {
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched) {
        _showStoreUnavailableMessage(storeName);
      }
    } else {
      _showStoreUnavailableMessage(storeName);
    }
  }

  void _showStoreUnavailableMessage(String storeName) {
    Get.snackbar(
      "$storeName Unavailable",
      "We're currently working on making the app available on the $storeName. Please check back soon!",
      backgroundColor: Colors.black87,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 4),
      margin: const EdgeInsets.all(10),
    );
  }
  Future<bool> goToAppStore() async {
    return await showModalBottomSheet<bool>(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (context) => Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColor.grey[50],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Wrap(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 50,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Back button aligned to the start (left)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 0.1,
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
                          ),

                          // Exit text centered
                          const Text(
                            'Download Houzza Short',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColor.black87,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Text(
                      'Go to App Store',
                      style: TextStyle(
                          fontSize: 18,
                          color: AppColor.black.withOpacity(0.7),
                          fontWeight: FontWeight.bold),
                    ),
                    boxH10(),
                    Center(
                      child: Text(
                        'Get the buzz, the trends, and the talk—jump into the Houzza Shot and vibe with the real estate tribe!',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColor.black.withOpacity(0.7),
                        ),
                        textAlign: TextAlign.center, // <-- Add this line
                      ),
                    ),

                    boxH30(),
                    Row(
                      children: [
                        // Apple Store Button (Black)
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => openStoreUrl(
                              'https://apps.apple.com/app/idYOUR_APP_ID',
                              storeName: 'Apple Store',
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black, // <-- Black color
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Download via Apple Store",
                                style: TextStyle(
                                  color: Colors.white, // Keep text white for contrast
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),

                        // Google Play Store Button (Purple)
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => openStoreUrl(
                              'https://play.google.com/store/apps/details?id=com.houzzaapp&hl=en',
                              storeName: 'Google Play Store',
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.lightPurple, // Your custom purple
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Download via Play Store",
                                style: TextStyle(
                                  color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    boxH05(),
                  ],
                ),
              ],
            ),
          ),
        ) ??
        false;
  }

  // Helper widget for project card
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
        });;
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
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
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Padding(
            //       padding: const EdgeInsets.only(right: 8.0),
            //       child: Container(
            //         height: 36,
            //         width: 36,
            //         decoration: BoxDecoration(
            //           shape: BoxShape.circle,
            //           border: Border.all(
            //             color: Colors.black, // Border color
            //             width: 0.01, // Border width
            //           ),
            //         ),
            //         child: InkWell(
            //           // Fix for the favorite button logic
            //           onTap: () {
            //             if (isLogin == true) {
            //               if (project['is_favorite'] ?? false) {
            //                 searchApiController
            //                     .removeFavoriteProject(
            //                   project_id: project['_id'],
            //                   favorite_id: project['favorite_id'],
            //                 )
            //                     .then((_) {
            //                   project['favorite_id'] = false;
            //                 });
            //               }
            //               else {
            //                 searchApiController
            //                     .addFavoriteProject(
            //                   project_id: project['_id'],
            //                 )
            //                     .then((_) {
            //                   project['favorite_id'] = true;
            //
            //                 });
            //               }
            //
            //               setState(() {});
            //             } else {
            //               Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
            //             }
            //           },
            //           borderRadius: BorderRadius.circular(50),
            //           child: Padding(
            //             padding: const EdgeInsets.all(6),
            //             child: Icon(
            //               (project != null && project['is_favorite']== true)
            //                   ? Icons.favorite
            //                   : Icons.favorite_border,
            //               color: (project != null &&project['is_favorite'] == true)
            //                   ? Colors.red
            //                   : Colors.black.withOpacity(0.6),
            //               size: 25.0,
            //             ),
            //           ),
            //         ),
            //       ),
            //     ),
            //     ///share option
            //     Padding(
            //       padding: const EdgeInsets.only(right: 8.0),
            //       child: Container(
            //         height: 36,
            //         width: 36,
            //         decoration: BoxDecoration(
            //           shape: BoxShape.circle,
            //           border: Border.all(
            //             color: Colors.black, // Border color
            //             width: 0.01, // Border width
            //           ),
            //         ),
            //         child: InkWell(
            //           onTap: () {
            //
            //           },
            //           borderRadius: BorderRadius.circular(50),
            //           child: Padding(
            //               padding: const EdgeInsets.all(8),
            //               child: Image.asset(
            //                 "assets/image_rent/share.png",
            //                 height: 10,
            //                 width: 15,
            //                 color: Colors.black.withOpacity(0.6),
            //               )),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
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
              right: 20.0,
              left: 20.0,
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
                        width: width * 0.9,
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
                        width: width * 0.9,
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

                            // Row(
                            //   crossAxisAlignment: CrossAxisAlignment.start,
                            //   children: [
                            //     Image.asset(
                            //       "assets/address-location.png",
                            //       height: 25,
                            //       width: 25,
                            //     ),
                            //     const SizedBox(width: 5),
                            //     Expanded(
                            //       child: Text(
                            //         project['address'],
                            //         maxLines: 3,
                            //         overflow: TextOverflow.ellipsis,
                            //         style: const TextStyle(
                            //           fontFamily: "Muli",
                            //         ),
                            //       ),
                            //     ),
                            //   ],
                            // ),
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

  Widget getTitles(double value, TitleMeta meta) {
    int index = value.toInt();
    if (index < 0 || index >= controller.leadsData.length) return const SizedBox();

    final dateStr = controller.leadsData[index]['date'];
    final date = DateFormat('dd/MM/yy').parse(dateStr);

    final monthDay = DateFormat('MMM d').format(date);
    final weekday = DateFormat('E').format(date);
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 8.0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(monthDay, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500)),
          Text(weekday, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        ],
      ),
    );
  }


  List<BarChartGroupData> get propertyBarGroups {
    if (controller.leadsData.isEmpty) {
      return [];
    }
    List<double> values = controller.leadsData
        .map<double>((e) => (e['property_leads'] as num).toDouble())
        .toList();
    double maxValue = values.reduce((a, b) => a > b ? a : b);

    return List.generate(values.length, (index) {
      final value = values[index];
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: value,
            color: value == maxValue
                ? AppColor.primaryThemeColor
                : AppColor.baarColor,
            width: 20,
          ),
        ],
      );
    });
  }

  List<BarChartGroupData> get projectBarGroups {
    if (controller.leadsData.isEmpty) {
      return [];
    }
    List<double> values = controller.leadsData
        .map<double>((element) => (element['project_leads'] as num).toDouble())
        .toList();
    // List<double> values = [8, 10, 14, 15, 13, 10, 16];
    double maxValue = values.reduce((a, b) => a > b ? a : b);

    return List.generate(values.length, (index) {
      Color barColor = values[index] == maxValue
          ? AppColor.primaryThemeColor
          : AppColor.baarColor;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: values[index],
            color: barColor,
            width: 20,
          ),
        ],
      );
    });
  }

  List<BarChartGroupData> get propertyBarGroupsForViews {
    if (controller.viewsData.isEmpty) {
      return [];
    }
    List<double> values = controller.viewsData
        .map<double>((e) => (e['views'] ?? 0).toDouble())
        .toList();

    double maxValue = values.isNotEmpty
        ? values.reduce((a, b) => a > b ? a : b)
        : 0;

    return List.generate(values.length, (index) {
      final value = values[index];
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: value,
            color: value == maxValue
                ? AppColor.primaryThemeColor
                : AppColor.baarColor,
            width: 20,
          ),
        ],
      );
    });
  }
  // SideTitles get bottomTitles {
  //   return SideTitles(
  //     showTitles: true,
  //     getTitlesWidget: (double value, TitleMeta meta) {
  //       int index = value.toInt();
  //       if (index < 0 || index >= controller.viewsData.length) {
  //         return const SizedBox.shrink();
  //       }
  //
  //       String dateStr = controller.viewsData[index]['date'] ?? '';
  //       DateTime? parsedDate;
  //       try {
  //         parsedDate = DateFormat('dd/MM/yy').parse(dateStr);
  //       } catch (_) {}
  //
  //       String display = parsedDate != null
  //           ? DateFormat('d MMM').format(parsedDate)
  //           : '';
  //
  //       return SideTitleWidget(
  //         axisSide: meta.axisSide,
  //         child: Text(display, style: const TextStyle(fontSize: 10)),
  //       );
  //     },
  //     reservedSize: 32,
  //   );
  // }
  SideTitles get bottomTitles {
    return SideTitles(
      showTitles: true,
      getTitlesWidget: (double value, TitleMeta meta) {
        int index = value.toInt();
        if (index < 0 || index >= controller.viewsData.length) {
          return const SizedBox.shrink();
        }

        String dateStr = controller.viewsData[index]['date'] ?? '';
        DateTime? parsedDate;
        try {
          parsedDate = DateFormat('dd/MM/yy').parse(dateStr);
        } catch (_) {}

        if (parsedDate == null) return const SizedBox.shrink();

        String datePart = DateFormat('d MMM').format(parsedDate); // e.g., 27 Aug
        String dayPart = DateFormat('E').format(parsedDate);      // e.g., Tue

        return SideTitleWidget(
          axisSide: meta.axisSide,
          space: 4.0, // spacing between chart and text
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(datePart, style: const TextStyle(fontSize: 10)),
              Text(dayPart, style: const TextStyle(fontSize: 10, color: Colors.grey)),
            ],
          ),
        );
      },
      reservedSize: 36, // Adjust if needed for better spacing
    );
  }

  List<BarChartGroupData> get propertyBarGroupsForTour{
    if (controller.virtualTourData.isEmpty) {
      return [];
    }
    List<double> values = controller.virtualTourData
        .map<double>((e) => (e['property_tours'] as num).toDouble())
        .toList();
    double maxValue = values.reduce((a, b) => a > b ? a : b);

    return List.generate(values.length, (index) {
      final value = values[index];
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: value,
            color: value == maxValue
                ? AppColor.primaryThemeColor
                : AppColor.baarColor,
            width: 20,
          ),
        ],
      );
    });
  }
  List<BarChartGroupData> get projectBarGroupsForTour {
    if (controller.virtualTourData.isEmpty) {
      return [];
    }
    List<double> values = controller.virtualTourData
        .map<double>((element) => (element['project_tours'] as num).toDouble())
        .toList();
    // List<double> values = [8, 10, 14, 15, 13, 10, 16];
    double maxValue = values.reduce((a, b) => a > b ? a : b);

    return List.generate(values.length, (index) {
      Color barColor = values[index] == maxValue
          ? AppColor.primaryThemeColor
          : AppColor.baarColor;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: values[index],
            color: barColor,
            width: 20,
          ),
        ],
      );
    });
  }


  List<PieChartSectionData> showingSections() {
    // Helper function to safely parse a value to double
    double safeParse(dynamic value, {double defaultValue = 0.0}) {
      if (value == null) return defaultValue;
      try {
        return double.parse(value.toString());
      } catch (e) {
        return defaultValue;
      }
    }

    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 14.0;
      final radius = isTouched ? 80.0 : 60.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      switch (i) {
        case 0:
          return PieChartSectionData(
            color: AppColor.primaryThemeColor,
            value: safeParse(profileController.postPropertiesPercentage['property_percentage']),
            title: '${safeParse(profileController.postPropertiesPercentage['property_percentage']).toStringAsFixed(0)}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: AppColor.white,
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: AppColor.amber,
            value: safeParse(profileController.postPropertiesPercentage['project_percentage']),
            title: '${safeParse(profileController.postPropertiesPercentage['project_percentage']).toStringAsFixed(0)}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: AppColor.white,
              shadows: shadows,
            ),
          );
        case 2:
          return PieChartSectionData(
            color: AppColor.green,
            value: safeParse(profileController.postPropertiesPercentage['residential_percentage']),
            title: '${safeParse(profileController.postPropertiesPercentage['residential_percentage']).toStringAsFixed(0)}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: AppColor.white,
              shadows: shadows,
            ),
          );
        case 3:
          return PieChartSectionData(
            color: AppColor.lightBlue,
            value: safeParse(profileController.postPropertiesPercentage['commercial_percentage']),
            title: '${safeParse(profileController.postPropertiesPercentage['commercial_percentage']).toStringAsFixed(0)}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: AppColor.white,
              shadows: shadows,
            ),
          );
        default:
          throw Error();
      }
    });
  }

  Widget propertyLeadsCard(Map<String,dynamic> lead,BuildContext context){
    print("leadsss $lead");
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 4.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width *
            0.95,
        child: Container(
          decoration: BoxDecoration(
            borderRadius:
            BorderRadius.circular(10),
            color: Colors.white.withOpacity(0.7),
            border: Border.all(
              color: Colors.grey.shade200,
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // GestureDetector(
                    //   onTap: () {},
                    //   child: CircleAvatar(
                    //     radius: 30,
                    //     backgroundColor: AppColor
                    //         .primaryThemeColor
                    //         .withOpacity(0.1),
                    //     child: ClipOval(
                    //       child: Image.asset(
                    //         'assets/image_rent/profile.png',
                    //         width: 25,
                    //         height: 25,
                    //         fit: BoxFit.cover,
                    //         color: AppColor
                    //             .primaryThemeColor,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    CircleAvatar(
                      radius: 24,
                      backgroundImage: (lead.containsKey('property_owner_image') &&
                          lead['property_owner_image'] != null &&
                          lead['property_owner_image'].toString().isNotEmpty)
                          ? CachedNetworkImageProvider(
                        "http://13.127.244.70:4444/media/"+lead['property_owner_image'],
                      )
                          : null,
                      backgroundColor: AppColor.grey.withOpacity(0.1),
                      child: ( lead.containsKey('property_owner_image') &&
                          lead['property_owner_image'] != null &&
                          lead['property_owner_image'].toString().isNotEmpty)
                          ? null
                          : CircleAvatar(
                        backgroundColor: Colors.purple.withOpacity(0.2),
                        radius: 22,
                        child: const Icon(
                          Icons.person,
                          color: Colors.purple,
                        ),
                      ),
                    ),
                    boxW15(),
                    RichText(
                      text:  TextSpan(
                        children: [
                          TextSpan(
                            text: lead['name'] ?? 'N/A',
                            style: const TextStyle(
                                fontSize: 18,
                                color:
                                Colors.black,
                                fontWeight:
                                FontWeight
                                    .w700),
                          ),
                          const TextSpan(text: '\n'),
                          TextSpan(
                            text: lead['user_type'] ?? 'N/A',
                            style: const TextStyle(
                              fontSize: 14,
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
                  mainAxisAlignment:
                  MainAxisAlignment
                      .spaceBetween,
                  children: [
                    RichText(
                      text:  TextSpan(
                        children: [
                          TextSpan(
                            text: controller.formatDayMonthYear(lead['created_at'] ?? 'N/A'),
                            style: const TextStyle(
                                fontSize: 14,
                                color:
                                Colors.black,
                                fontWeight:
                                FontWeight
                                    .w900),
                          ),
                          const TextSpan(text: '\n'),
                          const TextSpan(
                            text: "Received On",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    // GestureDetector(
                    //   onTap: () => callPhoneNumber(lead['contact_number'] ?? 'N/A'),
                    //   child: Image.asset(
                    //     "assets/image_rent/mobileui.png",
                    //     height: 30,
                    //     width: 30,
                    //   ),
                    // ),
                    GestureDetector(
                      onTap: () => callPhoneNumber(lead['contact_number'] ?? ''),
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/image_rent/mobileui.png",
                            width: 45,
                            height: 40,
                          ),
                          Text(
                            lead['contact_number'] ?? '',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),

                    ),

                  ],
                ),
                Divider(
                    height: 12,
                    thickness: 0.8,
                    color: Colors.grey.shade300),
                GestureDetector(
                  onTap: () => Get.to(PropertyDetailsScreen(
                    id: lead['property_id'].toString(),
                  )),
                  child: Row(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius:
                        BorderRadius.circular(
                            5),
                        child: Stack(
                          children: [
                            lead['enquiry_cover_image'] != null ?
                            CachedNetworkImage(
                              imageUrl: APIString.imageMediaBaseUrl+lead['enquiry_cover_image'], width: 120,
                              height: 90,fit: BoxFit.cover,
                              progressIndicatorBuilder: (context, url, downloadProgress) =>
                                  CircularProgressIndicator(value: downloadProgress.progress),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                            ) :
                            Image.asset(
                              'assets/image_rent/profilePropertyImg.png',
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              left: 0,
                              top: 0,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 4),
                                decoration: BoxDecoration(
                                  color:lead['enquiry_property_category_type'].toString() =="Rent"?
                                  AppColor.primaryThemeColor:AppColor.green,
                                  borderRadius:
                                  BorderRadius.circular(6),
                                ),
                                child:  Text(

                                  "FOR ${ lead['enquiry_property_category_type'] == "Buy"
                                      ? "SELL"
                                      : lead['enquiry_property_category_type'].toString().toUpperCase()}",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      boxW10(),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                          children: [
                            Text(
                              lead['enquiry_property_name']?? 'N/A',
                              style: const TextStyle(
                                  fontSize: 20,
                                  color:
                                  Colors.black,
                                  fontWeight:
                                  FontWeight
                                      .w500,
                                  overflow:
                                  TextOverflow
                                      .ellipsis),
                            ),
                            boxH05(),
                            // Text(
                            //   lead['enquiry_address']?? 'N/A',
                            //   style:const TextStyle(
                            //       fontSize: 14,
                            //       fontWeight:
                            //       FontWeight
                            //           .bold,
                            //       color:
                            //       Colors.black),
                            //     overflow:TextOverflow.ellipsis
                            // ),
                            Text(
                            (lead['property_details']?['address_area']?.toString().isNotEmpty == true
                                  ? lead['property_details']!['address_area'].toString()
                                  : lead['property_details']?['address']?.toString() ?? 'No Address'),
                              style: const TextStyle(color: Colors.grey, fontSize: 14),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            boxH05(),
                            const SizedBox(
                                height: 8),
                        //     Row(
                        //       children: [
                        //         RichText(
                        //           text:
                        //           TextSpan(
                        //             children: [
                        //               TextSpan(
                        //                 text:
                        //                 //controller.formatIndianPrice(lead['enquiry_property_price']?? '0'),
                        // '${controller.formatIndianPrice(lead['property_details']?['rent'].toString())}/Month',
                        //
                        // style:const
                        //                 TextStyle(
                        //                   fontSize:
                        //                   16,
                        //                   fontWeight:
                        //                   FontWeight
                        //                       .bold,
                        //                   color: Colors
                        //                       .black,
                        //                 ),
                        //               ),
                        //               const TextSpan(
                        //                 text:
                        //                 ' /month',
                        //                 style:
                        //                 TextStyle(
                        //                   fontSize:
                        //                   14,
                        //                   color: Colors
                        //                       .grey,
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                            lead['property_details']?['property_category_type']=="Rent"?
                            Text(
                              // '${_postPropertyController.formatIndianPrice(property['property_price'].toString())} /'
                              //     ' ${_postPropertyController.formatIndianPrice(property['rent'].toString())} Month',
                              '${controller.formatIndianPrice(lead['property_details']?['rent'].toString())}/Month',
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                                :
                            Text(
                              //   _postPropertyController.formatIndianPrice(property['rent']),
                              controller.formatIndianPrice(lead['property_details']?['property_price'].toString()),
                              style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                boxH15(),
                const Text(
                  'Message',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  lead['message']?? 'N/A',
                  style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget ProjectLeadsCard(Map<String,dynamic> lead,BuildContext context){
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 4.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width *
            0.9,
        child: Container(
          decoration: BoxDecoration(
            borderRadius:
            BorderRadius.circular(10),
            color: Colors.white.withOpacity(0.7),
            border: Border.all(
              color: Colors.grey.shade200,
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // CircleAvatar(
                    //   radius: 30,
                    //   backgroundColor: AppColor
                    //       .primaryThemeColor
                    //       .withOpacity(0.1),
                    //   child: ClipOval(
                    //     child: Image.asset(
                    //       'assets/image_rent/profile.png',
                    //       width: 25,
                    //       height: 25,
                    //       fit: BoxFit.cover,
                    //       color: AppColor
                    //           .primaryThemeColor,
                    //     ),
                    //   ),
                    // ),
                    CircleAvatar(
                      radius: 24,
                      backgroundImage: (lead.containsKey('property_owner_image') &&
                          lead['property_owner_image'] != null &&
                          lead['property_owner_image'].toString().isNotEmpty)
                          ? CachedNetworkImageProvider(
                        "http://13.127.244.70:4444/media/"+lead['property_owner_image'],
                      )
                          : null,
                      backgroundColor: AppColor.grey.withOpacity(0.1),
                      child: ( lead.containsKey('property_owner_image') &&
                          lead['property_owner_image'] != null &&
                          lead['property_owner_image'].toString().isNotEmpty)
                          ? null
                          : CircleAvatar(
                        backgroundColor: Colors.purple.withOpacity(0.2),
                        radius: 22,
                        child: const Icon(
                          Icons.person,
                          color: Colors.purple,
                        ),
                      ),
                    ),
                    boxW15(),
                    RichText(
                      text:  TextSpan(
                        children: [
                          TextSpan(
                            text: lead['name'] ?? 'N/A',
                            style: const TextStyle(
                                fontSize: 18,
                                color:
                                Colors.black,
                                fontWeight:
                                FontWeight
                                    .w700),
                          ),
                          const TextSpan(text: '\n'),
                          TextSpan(
                            text: lead['user_type'] ?? 'N/A',
                            style: const TextStyle(
                              fontSize: 14,
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
                  mainAxisAlignment:
                  MainAxisAlignment
                      .spaceBetween,
                  children: [
                    RichText(
                      text:  TextSpan(
                        children: [
                          TextSpan(
                            text: controller.formatDayMonthYear(lead['created_at'] ?? 'N/A'),
                            style: const TextStyle(
                                fontSize: 14,
                                color:
                                Colors.black,
                                fontWeight:
                                FontWeight
                                    .w900),
                          ),
                          const TextSpan(text: '\n'),
                          const TextSpan(
                            text: "Received On",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => callPhoneNumber(lead['contact_number'] ?? ''),
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/image_rent/mobileui.png",
                            width: 45,
                            height: 40,
                          ),
                          Text(
                            lead['contact_number'] ?? '',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),

                    ),
                  ],
                ),
                Divider(
                    height: 12,
                    thickness: 0.8,
                    color: Colors.grey.shade300),
                GestureDetector(
                  // onTap: () => Get.to(TopDevelopersDetails(
                  //   projectID: lead['project_id'].toString(),
                  // )),
                  onTap: () {
                    Get.to(TopDevelopersDetails(
                      projectID: lead['_id'].toString(),
                    ))?.then((value) {
                      if (value != null) {
                        setState(() {
                          // If you're just updating isFavorite
                          lead['is_favorite'] = value;

                          print("widget.property_data['isFavorite']--->");
                          print(lead['is_favorite']);
                          print(value);


                        });
                      }
                    });;
                  },
                  child: Row(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius:
                        BorderRadius.circular(
                            5),
                        child: Stack(
                          children: [
                            lead['enquiry_cover_image'] != null ?
                            CachedNetworkImage(
                              imageUrl: APIString.imageMediaBaseUrl+lead['enquiry_cover_image'], width: 120,
                              height: 90,fit: BoxFit.cover,
                              progressIndicatorBuilder: (context, url, downloadProgress) =>
                                  CircularProgressIndicator(value: downloadProgress.progress),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                            ) :
                            Image.asset(
                              'assets/image_rent/profilePropertyImg.png',
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                            //
                          ],
                        ),
                      ),
                      boxW10(),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                          children: [
                            Text(
                              lead['project_name']?? 'N/A',
                              style: const TextStyle(
                                  fontSize: 20,
                                  color:
                                  Colors.black,
                                  fontWeight:
                                  FontWeight
                                      .w500,
                                  overflow:
                                  TextOverflow
                                      .ellipsis),
                            ),
                            boxH05(),
                            Text(
                              // lead['enquiry_address']?? 'N/A',
                                (lead['project_details']?['address_area']?.toString().isNotEmpty == true
                                    ? lead['project_details']!['address_area'].toString()
                                    : lead['project_details']?['address']?.toString() ?? 'No Address'),
                              style:const TextStyle(
                                  fontSize: 14,
                                  fontWeight:
                                  FontWeight
                                      .bold,
                                  color:
                                  Colors.black),
                                overflow:TextOverflow.ellipsis
                            ),



                            boxH05(),
                            const SizedBox(
                                height: 8),
                            Row(
                              children: [
                                RichText(
                                  text:
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text:
                                      controller.formatPriceRange(lead['project_details']?['average_project_price'])    ,                                    style:const
                                        TextStyle(
                                          fontSize:
                                          16,
                                          fontWeight:
                                          FontWeight
                                              .bold,
                                          color: Colors
                                              .black,
                                        ),
                                      ),

                                    ],
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
                boxH15(),
                const Text(
                  'Message',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  lead['message']?? 'N/A',
                  style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void showDownloadHouzzaShortApp(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        content: const Text(
          "Are you sure you want to delete this listing?",
          style: TextStyle(fontSize: 14),
        ),
        actions: [
          commonButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            text: 'Download',
          ),
        ],
      );
    },
  );
}
