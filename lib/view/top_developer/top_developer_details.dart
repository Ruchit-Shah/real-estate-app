import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:real_estate_app/common_widgets/custom_textformfield.dart';
import 'package:real_estate_app/common_widgets/height.dart';
import 'package:real_estate_app/common_widgets/loading_dart.dart';
import 'package:real_estate_app/utils/String_constant.dart';
import 'package:real_estate_app/utils/shared_preferences/shared_preferances.dart';
import 'package:real_estate_app/view/auth/login_screen/login_screen.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/CustomBottomNavBar.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/profile_screen/profile_section_screens/PlansAndSubscriptions/PlansAndSubscription.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/profile_screen/profile_section_screens/my_virtual_tour/GetScheduleBottomSheet.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/profile_screen/profile_section_screens/my_virtual_tour/my_virtual_tour_screen.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/search_screen/searchController.dart';
import 'package:real_estate_app/view/property_screens/models/project_details_model.dart';
import 'package:real_estate_app/view/property_screens/properties_controllers/post_property_controller.dart';
import 'package:real_estate_app/view/property_screens/recommended_properties_screen/PropertyDetailRow.dart';
import 'package:real_estate_app/view/shorts/controller/my_profile_controller.dart';
import 'package:real_estate_app/view/splash_screen/splash_screen.dart';
import 'package:real_estate_app/view/subscription%20model/controller/SubscriptionController.dart';
import 'package:real_estate_app/view/top_developer/top_rated_developer_list_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../global/app_color.dart';
import '../../utils/text_style.dart';
import '../dashboard/bottom_navbar_screens/profile_screen/profile_controller.dart';
import '../property_screens/agent_profile.dart';
import '../property_screens/poroject_agent_profile.dart';
import '../property_screens/post_property_screen/NewChanges/video_player.dart';
import 'dart:io'; // For File class
import 'package:dio/dio.dart'; // For Dio and Options
import 'package:open_filex/open_filex.dart'; // For opening files
import 'package:path_provider/path_provider.dart'; // For getApplicationDocumentsDirectory
import 'package:permission_handler/permission_handler.dart';

import '../property_screens/recommended_properties_screen/properties_details_screen.dart'; // For storage permissions

class TopDevelopersDetails extends StatefulWidget {
  final projectID;

  TopDevelopersDetails({super.key,  this.projectID});

  @override
  State<TopDevelopersDetails> createState() => _TopDevelopersDetailsState();
}

class _TopDevelopersDetailsState extends State<TopDevelopersDetails> {
  // final PostPropertyController controller = Get.put(PostPropertyController());
  // ProfileController profileController = Get.put(ProfileController());
  final ScrollController _controllerOne = ScrollController();
  final ProfileController controller =  Get.find();
  final searchController search_controller = Get.find();
  final MyProfileController profileController =  Get.find();
  final PostPropertyController postPropertyController = Get.find();
  final planController = Get.find<SubscriptionController>();
  final _formkey = GlobalKey<FormState>();
  int _selectedPropertyIndex = 0;
  bool isVirtualTourSelected = false;
  bool isContactDetailsSelected = false;
  bool isDownloadSelected = false;

  final GlobalKey _overviewKey = GlobalKey();
  final GlobalKey _detailsKey = GlobalKey();
  final GlobalKey _amenitiesKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _locationKey = GlobalKey();
  final GlobalKey _locationNameKey = GlobalKey();
  final GlobalKey _priceFloorKey = GlobalKey();
  final GlobalKey _floorsKey = GlobalKey();
  final GlobalKey _moredetails = GlobalKey();

  String _currentSection = 'About';

  final ScrollController _scrollController = ScrollController();
  GoogleMapController? mapController;
  TextEditingController msgController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  late TextEditingController phoneController ;

   ProjectDetails? projectDetails;
   List<Amenities>? projectAmenities;
   List<ProjectImages>? projectImages;
   List<ProjectProperties>? projectProperties;
   List<TourSchedule>? projectTourSchedules;
  List<UserDetails>? user_data;
  final List<String> mediaUrls = [];
  String isContact = "";
  int count = 0;

  bool isVideo(String url) {
    if (url.isEmpty) return false;
    final uri = Uri.tryParse(url);
    final path = uri?.path ?? '';
    return path.toLowerCase().endsWith('.mp4') ||
        path.toLowerCase().endsWith('.mov') ||
        path.toLowerCase().endsWith('.webm') ||
        path.toLowerCase().endsWith('.avi');
  }

  bool isDateExpiredFromString(String dateString) {
    try {
      // Parse the input string into a DateTime object
      DateTime inputDate = DateTime.parse(dateString);

      // Get today's date without time
      DateTime now = DateTime.now();
      DateTime today = DateTime(now.year, now.month, now.day);

      // Compare just the date part
      return inputDate.isBefore(today);
    } catch (e) {
      print("Invalid date format: $e");
      return false;
    }
  }


  
  String formatMonthYear(String inputDate) {
    try {
      final DateTime parsedDate = DateTime.parse(inputDate);
      final DateFormat formatter = DateFormat('MMMM yyyy');
      return formatter.format(parsedDate);
    } catch (e) {
      return 'Invalid Date';
    }
  }
  
  String formatDayMonthYear(String inputDate) {
    try {
      final DateTime parsedDate = DateTime.parse(inputDate);
      final DateFormat formatter = DateFormat('dd MMMM yyyy');
      return formatter.format(parsedDate);
    } catch (e) {
      return 'Invalid Date';
    }
  }
  bool isValidString(String? value) {
    return value != null && value.trim().isNotEmpty && value.trim() != '0';
  }
  // String generatePriceRangeFromAverage({
  //   required double totalPrice,
  //   required double area,
  //   required String unit,
  //   double percentageRange = 0.10, // ±10% by default
  // }) {
  //   if (totalPrice <= 0 || area <= 0) return "N/A";
  //
  //   double avgPricePerUnit = totalPrice / area;
  //   double minPrice = avgPricePerUnit * (1 - percentageRange);
  //   double maxPrice = avgPricePerUnit * (1 + percentageRange);
  //
  //   String format(double value) {
  //     return value.toStringAsFUniixed(0).replaceAllMapped(
  //       RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
  //           (Match m) => "${m[1]},",
  //     );
  //   }
  //
  //   return "₹${format(minPrice)} – ₹${format(maxPrice)} per $unit";
  // }

  // String generatePriceRangeFromAverage() {
  //   if (projectProperties?.isEmpty ?? true) return '';
  //
  //   List<double> pricePerUnitList = [];
  //
  //   for (var property in projectProperties!) {
  //     final price = double.tryParse(property.price.toString()) ?? 0.0;
  //     final area = property.area ?? 0.0;
  //
  //     if (price > 0 && area > 0) {
  //       pricePerUnitList.add(price / area);
  //     }
  //   }
  //
  //   if (pricePerUnitList.isEmpty) return '';
  //
  //   double minPrice = pricePerUnitList.reduce((a, b) => a < b ? a : b);
  //   double maxPrice = pricePerUnitList.reduce((a, b) => a > b ? a : b);
  //
  //   String formatINR(double amount) {
  //     return '₹${amount.toStringAsFixed(0).replaceAllMapped(
  //       RegExp(r'(\d{1,3})(?=(\d{2})+(?!\d))'),
  //           (Match m) => '${m[1]},',
  //     )}';
  //   }
  //
  //   // If all properties have same unit, else modify accordingly
  //   String unit = projectProperties!.first.areaIn ?? 'Sq Ft';
  //  // String unit = 'Sq Ft';
  //
  //   return '${formatINR(minPrice)} - ${formatINR(maxPrice)} per $unit';
  // }
  String generatePriceRangeFromAverage() {
    if (projectProperties?.isEmpty ?? true) return '';

    List<double> pricePerSqFtList = [];

    for (var property in projectProperties!) {
      final price = double.tryParse(property.price.toString()) ?? 0.0;
      final area = property.area ?? 0.0;
      final unit = property.areaIn ?? 'Sq Ft';

      // Convert area to Sq Ft using your helper
      final convertedArea = postPropertyController.convertToSqFt(area, unit);

      if (price > 0 && convertedArea > 0) {
        pricePerSqFtList.add(price / convertedArea);
      }
    }

    if (pricePerSqFtList.isEmpty) return '';

    // Helper to format as INR
    String formatINR(double amount) {
      return '₹${amount.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{2})+(?!\d))'),
            (Match m) => '${m[1]},',
      )}';
    }

    if (pricePerSqFtList.length == 1) {

      final singlePrice = pricePerSqFtList.first;
      return '${formatINR(singlePrice)} per Sq Ft';
    } else {
      // 🟢 Multiple properties — show range
      double minPrice = pricePerSqFtList.reduce((a, b) => a < b ? a : b);
      double maxPrice = pricePerSqFtList.reduce((a, b) => a > b ? a : b);
      return '${formatINR(minPrice)} - ${formatINR(maxPrice)} per Sq Ft';
    }
  }

  String getFormattedBHKText() {
    final Set<String> bhkSet = {};

    // Null safety check
    if (projectProperties == null || projectProperties!.isEmpty) {
      return '';
    }

    for (var property in projectProperties!) {
      if (property.bhk != null) {
        bhkSet.add(property.bhk!.trim());
      }
    }

    // Separate Studio and numbered BHKs
    List<String> studios = [];
    List<String> bhkNumbers = [];

    for (var bhk in bhkSet) {
      if (bhk.toLowerCase().contains('studio')) {
        studios.add("Studio");
      } else {
        // Extract number (handles 1, 1.5, etc.)
        final match = RegExp(r'^(\d+(\.\d+)?)').firstMatch(bhk);
        if (match != null) {
          bhkNumbers.add(match.group(1)!);
        }
      }
    }

    bhkNumbers.sort((a, b) => double.parse(a).compareTo(double.parse(b)));

    // Build final result string
    String result = '';
    if (studios.isNotEmpty) {
      result += 'Studio';
      if (bhkNumbers.isNotEmpty) {
        result += ', ';
      }
    }

    if (bhkNumbers.isNotEmpty) {
      result += '${bhkNumbers.join(', ')} BHK';
    }

    return result;
  }
  String getFormattedAreaRangeText() {
    if (projectProperties == null || projectProperties!.isEmpty) {
      return '';
    }

    // Convert all areas to Sq Ft
    List<double> convertedAreas = projectProperties!.map((property) {
      return postPropertyController.convertToSqFt(
        property.area!.toDouble(),
        property.areaIn,
      );
    }).toList();

    // Find min and max values
    double minArea = convertedAreas.reduce((a, b) => a < b ? a : b);
    double maxArea = convertedAreas.reduce((a, b) => a > b ? a : b);

    // Format without decimals
    String minFormatted = minArea.toStringAsFixed(0);
    String maxFormatted = maxArea.toStringAsFixed(0);

    // If min == max, show single value, else show range
    if (minArea == maxArea) {
      return '$minFormatted Sq Ft';
    } else {
      return '$minFormatted Sq Ft - $maxFormatted Sq Ft';
    }
  }






  String formatIndianPrice(String price) {
    final int amount = int.parse(price);
    if (amount < 100000) {
      // For amounts less than 1 lakh, show in thousands
      return '₹${(amount / 1000).toStringAsFixed(amount % 1000 == 0 ? 0 : 1)} K';
    } else if (amount < 10000000) {
      // For amounts between 1 lakh and 1 crore
      double lakhs = amount / 100000;
      return '₹${lakhs.toStringAsFixed(lakhs % 1 == 0 ? 0 : 1)} L';
    } else {
      // For amounts 1 crore and above
      double crores = amount / 10000000;
      return '₹${crores.toStringAsFixed(crores % 1 == 0 ? 0 : 1)} Cr';
    }
  }
  late int freeViewCount;
  late int paidViewCount;
  // void checkPlan()async{
  //   freeViewCount =  await SPManager.instance.getFreeViewCount(FREE_VIEW) ?? 0;
  //   paidViewCount =  await SPManager.instance.getPaidViewCount(PAID_VIEW) ?? 0;
  //   print('view count ===> ');
  //   print(freeViewCount);
  //   print(paidViewCount);
  // }
  // Future<void> _launchURL() async {
  //   final uri = Uri.parse(projectDetails?.videoUrl ?? '');
  //   if (await canLaunchUrl(uri)) {
  //     await launchUrl(uri, mode: LaunchMode.externalApplication);
  //   } else {
  //     throw 'Could not launch ';
  //   }
  // }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getDetails();
      getData();
    });
    phoneController = TextEditingController(text: controller.mobile.value);
    projectDetails = ProjectDetails();
    projectProperties?.clear();
    projectImages?.clear();
    projectAmenities?.clear();
  }


  getData() async {
    isContact =
        (await SPManager.instance.getContactDetails(ContactDetails)) ?? "no";
    count = (await SPManager.instance.getFreeViewCount(FREE_VIEW)) ?? 0;
    freeViewCount =  await SPManager.instance.getFreeViewCount(FREE_VIEW) ?? 0;
    paidViewCount =  await SPManager.instance.getPaidViewCount(PAID_VIEW) ?? 0;
    print('view count ===>');
    print("freeViewCount==>$freeViewCount");
    print("paidViewCount==>$paidViewCount");

    // await search_controller.getFavorite();
    print('isContact==>');
    print(isContact);
    print("isContact==>$isContact");
    print("count==>$count");


    setState(() {});
  }

  getDetails() async {
    await controller.getProjectDetails(projectID: widget.projectID).then((value) {
     setState(() {
       projectDetails = controller.projectDetails.value.data!.projectDetails!;
       projectAmenities = controller.projectDetails.value.data!.amenities!;
       projectImages = controller.projectDetails.value.data!.projectImages!;
       user_data = controller.projectDetails.value.data!.userDetails!;
       projectProperties = controller.projectDetails.value.data!.projectProperties!;
       projectTourSchedules = controller.projectDetails.value.data!.tourSchedule!;



       user_data=controller.projectDetails.value.data!.userDetails!;

       if(projectDetails?.propertyVideo?.isNotEmpty ??false){
         projectImages?.add(ProjectImages(id: '1212',image: projectDetails?.propertyVideo));

       }
       // Add property images if available
       if (projectImages != null && projectImages!.isNotEmpty) {
         mediaUrls.addAll(projectImages!
             .map((e) => e.image ?? '')
             .where((url) => url.isNotEmpty));
       }

// If no property images, show cover image (if available)
       if (mediaUrls.isEmpty && (projectDetails?.coverImage?.isNotEmpty ?? false)) {
         mediaUrls.add(projectDetails!.coverImage!);
       }

// Optionally add video at the end if uploaded
       // Optionally add video at the end if uploaded and it's a video file
       if ((projectDetails?.videoUrl?.isNotEmpty ?? false)) {
         final videoUrl = projectDetails!.videoUrl!;
         if (isVideo(videoUrl)) {
           mediaUrls.add(videoUrl);
         }
       }
     });
    });
    await search_controller.addProjectView(owner_id:projectDetails?.userId ,project_id:projectDetails?.id);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.removeListener(_onScroll);
    _controllerOne.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, projectDetails?.isFavorite);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          leadingWidth: 46,
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
                  Navigator.pop(context, projectDetails?.isFavorite);
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
                height: 36,
                width: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.black, // Border color
                    width: 0.01, // Border width
                  ),
                ),
                child: InkWell(
                  // Fix for the favorite button logic
                  onTap: () {
                    if (isLogin == true) {
                      if (projectDetails?.isFavorite ?? false) {
                        search_controller
                            .removeFavoriteProject(
                          project_id: projectDetails?.id,
                          favorite_id: projectDetails?.favoriteId,
                        )
                            .then((_) {
                          projectDetails?.isFavorite= false;
                        });
                      }
                      else {
                        search_controller
                            .addFavoriteProject(project_id: projectDetails?.id)
                            .then((_) {
                          projectDetails?.isFavorite = true;

                        });
                      }
                      getDetails();
                      setState(() {});
                    } else {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                    }
                  },
                  borderRadius: BorderRadius.circular(50),
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Icon(
                      (projectDetails != null && projectDetails?.isFavorite == true)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: (projectDetails != null && projectDetails?.isFavorite == true)
                          ? Colors.red
                          : Colors.black.withOpacity(0.6),
                      size: 25.0,
                    ),
                  ),
                ),
              ),
            ),
            ///share option
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Container(
                height: 36,
                width: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.black, // Border color
                    width: 0.01, // Border width
                  ),
                ),
                child: InkWell(
                  onTap: () async {

                    shareProject(projectDetails?.id??"");


                  },
                  borderRadius: BorderRadius.circular(50),
                  child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Image.asset(
                        "assets/image_rent/share.png",
                        height: 10,
                        width: 15,
                        color: Colors.black.withOpacity(0.6),
                      )),
                ),
              ),
            ),
          ],
        ),

        body:   SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding:
            const EdgeInsets.only(top: 16.0, right: 16.0, left: 16.0,),
            child: Container(
              color: Colors.white.withOpacity(0.1),
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Developer Name
                          Row(
                            children: [


                              Text(
                                projectDetails?.projectName ?? 'unknown project',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              boxW10(),
                              (projectDetails?.reraId?.trim().isEmpty ?? true)
                                  ? const SizedBox()
                                  : Row(
                                children: [
                                  Image.asset(
                                    "assets/image_rent/rights.png",
                                    width: 12,
                                    height: 12,
                                    fit: BoxFit.contain,
                                  ),
                                  boxW05(),
                                  const Text(
                                    "RERA",
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              )


                            ],
                          ),
                          const SizedBox(height: 4),

                          RichText(
                            text:  TextSpan(
                              text: "By ",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black, // Purple color for "By"
                              ),
                              children: [
                                TextSpan(
                                  text:
                                  projectDetails?.connectToName ?? 'unknown user',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(
                                        0xFF813BEA), // Black color for "Sales Enquiry"
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Address
                          // Row(
                          //   children: [
                          //     Image.asset(
                          //       "assets/address-location.png",
                          //       height: 25,
                          //       width: 25,
                          //     ),
                          //     const SizedBox(width: 5),
                          //     Text(
                          //       projectDetails?.address??'',
                          //       style: TextStyle(
                          //         fontSize: 14,
                          //         color: Colors.black.withOpacity(0.7),
                          //       ),
                          //     ),
                          //   ],
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
                                child: Text(
                                  projectDetails?.address??'',
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontFamily: "Muli",
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Price Range
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              // Text((projectDetails?.averageProjectPrice?.isNotEmpty ?? false) ?
                              //   formatIndianPrice(projectDetails?.averageProjectPrice ?? '') : '₹ N/A',
                              //   style: const TextStyle(
                              //     fontSize: 22,
                              //     fontWeight: FontWeight.bold,
                              //     color: AppColor.primaryThemeColor,
                              //   ),
                              // ),

                              // Text(
                              //   (projectProperties != null && projectProperties!.isNotEmpty)
                              //       ? (() {
                              //     final sortedList = List.from(projectProperties!)
                              //       ..sort((a, b) => double.parse(a.price).compareTo(double.parse(b.price)));
                              //     final minPrice = '₹${formatPrice(sortedList.first.price)}';
                              //     if (sortedList.length == 1) {
                              //       return minPrice;
                              //     }
                              //     final maxPrice = '₹${formatPrice(sortedList.last.price)}';
                              //     return '$minPrice - $maxPrice';
                              //   })()
                              //       : 'N/A',
                              //   style: const TextStyle(
                              //     fontSize: 22,
                              //     fontWeight: FontWeight.bold,
                              //     color: AppColor.primaryThemeColor,
                              //   ),
                              // ),

                              Text(
                                postPropertyController.formatPriceRange(projectDetails?.averageProjectPrice??''),
                                // projectDetails?.averageProjectPrice??'',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.primaryThemeColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                generatePriceRangeFromAverage(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 7),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                // Features Row
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    projectDetails != null && projectProperties != null && projectProperties!.isNotEmpty?

                                    Row(
                                      children: [
                                        Image.asset(
                                          "assets/image_rent/house.png",
                                          width: 30,
                                          height: 30,
                                        ),
                                        const SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [

                                            Container(
                                              width: 100,
                                              height: 40,
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                getFormattedBHKText(),
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                                softWrap: true,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                              ),
                                            ),
                                            // Text(
                                            //
                                            //   getFormattedBHKText(),
                                            //
                                            //
                                            //   style: const TextStyle(
                                            //     fontSize: 14,
                                            //     fontWeight: FontWeight.bold,
                                            //     color: Colors.black,
                                            //   ),
                                            // ),
                                            const Text(
                                              "Configuration",
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ):const SizedBox.shrink(),
                                    projectDetails != null && projectProperties != null && projectProperties!.isNotEmpty?

                                    Row(
                                      children: [
                                        Image.asset(
                                          "assets/image_rent/format-square.png",
                                          width: 30,
                                          height: 30,
                                        ),
                                        const SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 100,   // set desired width
                                              height: 40,   // set desired height
                                              alignment: Alignment.centerLeft,  // align text to left inside container
                                              child: Text(
                                                getFormattedAreaRangeText(),
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                                softWrap: true,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                              ),
                                            ),

                                            Text(
                                              projectProperties?.isNotEmpty ?? false
                                                  ? projectProperties!.first.areaType.toString() : '-',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ):const SizedBox.shrink(),
                                  ],
                                ),
                                projectDetails != null && projectProperties != null && projectProperties!.isNotEmpty
                                    ?
                                boxH15():const SizedBox.shrink(),

                                // Possession Starts
                                projectDetails!.constructionStatus=="Ongoing"?
                                Row(
                                  children: [
                                    Image.asset(
                                      "assets/image_rent/professionalStart.png",
                                      width: 30,
                                      height: 30,
                                    ),
                                    boxW10(),

                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text( formatMonthYear(projectDetails?.possessionStart?? 'N/A'),
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          formatDate(projectDetails!.possessionStart ?? ''),


                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ):const SizedBox(),
                              ],
                            ),
                          ),

                          boxH30(),


                          Row(
                            children: [

                              projectDetails?.virtualTourAvailability=="Yes"?

                              (projectTourSchedules != null &&
                                  projectTourSchedules!.isNotEmpty &&
                                  (projectTourSchedules!.first.status == "Rejected" ||
                                      projectTourSchedules!.first.status == "Expired"))

                                  ? OutlinedButton(
                                onPressed: () {
                                  if (isLogin == true) {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                                      ),
                                      builder: (context) => GetScheduleBottomSheet(
                                          name: projectDetails?.connectToName,
                                          propertyID: projectDetails?.id,
                                          userType: user_data![0].userType ?? "",
                                          tour_type: 'Project',
                                          image:user_data![0].profileImage.toString() ,
                                          propertyOwnerID: projectDetails?.userId
                                      ),
                                    ).then((value) => setState(() {
                                      getDetails();
                                    }));
                                  } else {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                                  }
                                },
                                style: OutlinedButton.styleFrom(
                                  minimumSize: Size(
                                    MediaQuery.of(context).size.width * 0.4,
                                    MediaQuery.of(context).size.height * 0.06,
                                  ),
                                  side: const BorderSide(color: AppColor.primaryThemeColor),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  padding: const EdgeInsets.all(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset(
                                      "assets/image_rent/VirtualTour.png",
                                      width: 24,
                                      height: 24,
                                      color: AppColor.primaryThemeColor,
                                    ),
                                    const SizedBox(width: 4),
                                    const Text(
                                      "Virtual Tour",
                                      style: TextStyle(
                                        color: AppColor.primaryThemeColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ):
                              (projectTourSchedules != null
                                  && projectTourSchedules!.isNotEmpty &&
                                  !isDateExpiredFromString(projectTourSchedules?.first.scheduleDate ?? ''))
                                  ?   Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Get.to(const MyVirtualTourScreen());
                                  },
                                  child: Container(
                                    height: MediaQuery.of(context).size.height * 0.06,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: AppColor.yellowButton,
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 8), // Reduced horizontal padding
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Flexible( // Added Flexible to prevent overflow
                                          child: Text(
                                            // "Scheduled ${propertyController.formatDayMonthYear(projectTourSchedules?.last.scheduleDate ?? '')}",
                                            "Scheduled ${formatDayMonthYear(projectTourSchedules?.first.scheduleDate ?? '')}",
                                            style: const TextStyle(
                                              color: AppColor.black,
                                              fontSize: 13,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        const Icon(Icons.arrow_forward, size: 16),
                                      ],
                                    ),
                                  ),
                                ),
                              ):

                              OutlinedButton(
                                // onPressed: () {
                                //   showModalBottomSheet(
                                //     context: context,
                                //     isScrollControlled: true,
                                //     shape: const RoundedRectangleBorder(
                                //       borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                                //     ),
                                //     builder: (context) => GetScheduleBottomSheet(
                                //       name: userDetails?[0].fullName ?? "",
                                //       userType: userDetails?[0].userType ?? "",
                                //       propertyOwnerID: propertyDetails?.userId,
                                //     propertyID: propertyDetails?.id,
                                //       tour_type: 'property',
                                //     ),
                                //   ).then((value) => setState(() {
                                //     getDetails();
                                //   }));
                                //
                                //     print("tour check : ${projectTourSchedules}");
                                // },
                                onPressed: () {
                                  if (isLogin == true) {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                                      ),
                                      builder: (context) => GetScheduleBottomSheet(
                                          name: projectDetails?.connectToName,
                                          propertyID: projectDetails?.id,
                                          userType: user_data![0].userType ?? "",
                                          tour_type: 'Project',
                                          image:user_data![0].profileImage.toString() ,
                                          propertyOwnerID: projectDetails?.userId
                                      ),
                                    ).then((value) => setState(() {
                                      getDetails();
                                    }));
                                  } else {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                                  }
                                },
                                style: OutlinedButton.styleFrom(
                                  minimumSize: Size(
                                    MediaQuery.of(context).size.width * 0.4,
                                    MediaQuery.of(context).size.height * 0.06,
                                  ),
                                  side: const BorderSide(color: AppColor.primaryThemeColor),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  padding: const EdgeInsets.all(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset(
                                      "assets/image_rent/VirtualTour.png",
                                      width: 24,
                                      height: 24,
                                      color: AppColor.primaryThemeColor,
                                    ),
                                    const SizedBox(width: 4),
                                    const Text(
                                      "Virtual Tour",
                                      style: TextStyle(
                                        color: AppColor.primaryThemeColor,
                                      ),
                                    ),
                                  ],
                                ),
                              )

                                  :const SizedBox(),
                              boxW05(),
                              // Space between buttons
                              (projectDetails?.brochureDoc != null && projectDetails!.brochureDoc!.isNotEmpty)
                                  ? Expanded(
                                child: GestureDetector(
                                  onTap: () async {
                                    if (isLogin == true) {
                                      await _downloadAndViewPdf(pdfUrl: projectDetails?.brochureDoc ?? '');
                                    } else {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                                    }
                                  },
                                  child: Container(
                                    height: MediaQuery.of(context).size.height * 0.06,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(
                                        width: 1,
                                        color: AppColor.primaryThemeColor,
                                      ),
                                      color: Colors.transparent,
                                    ),
                                    padding: const EdgeInsets.all(8),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          "assets/image_rent/formatContact.png",
                                          width: 20,
                                          height: 20,
                                          color: AppColor.primaryThemeColor,
                                        ),
                                        const SizedBox(width: 5),
                                        const Text(
                                          "Download Brochure",
                                          style: TextStyle(
                                            color: AppColor.primaryThemeColor,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                                  : const SizedBox(),



                            ],
                          ),

                          boxH15(),

                          GestureDetector(
                            onTap: () {

                              if (isLogin == true) {
                                // _showContactDetailsBottomSheet(context, userDetails?[0].fullName, userDetails?[0].mobileNumber);
                                _showContactDetailsBottomSheet(context,projectDetails?.connectToName,projectDetails?.connectToNo);
                              } else {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                              }
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.06,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius:
                                const BorderRadius.all(Radius.circular(30)),
                                border: Border.all(
                                  width: 1,
                                  color: AppColor.primaryThemeColor,
                                ),
                                color:  AppColor.primaryThemeColor,
                              ),
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    "assets/image_rent/formatContact.png",
                                    width: 22,
                                    height: 22,
                                    color: Colors.white,
                                  ),
                                  boxW05(),
                                  const Text(
                                    "Contact Details",
                                    style: TextStyle(
                                        color:  Colors.white,
                                        fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          boxH30(),


                          (projectImages?.isNotEmpty ?? false || (projectDetails?.coverImage ?? '').isNotEmpty)
                              ? Padding(
                            padding: const EdgeInsets.only(left: 10, top: 10),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0),
                              ),
                              child: SizedBox(
                                height: Get.height * 0.325,
                                width: double.infinity,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  // propertyImages + 1 cover image at the end if present
                                  itemCount: (projectImages?.length ?? 0) + ((projectDetails?.coverImage?.isNotEmpty ?? false) ? 1 : 0),
                                  itemBuilder: (context, index) {
                                    final hasCover = projectDetails?.coverImage?.isNotEmpty ?? false;
                                    final isLastIndex = hasCover && index == (projectImages?.length ?? 0);

                                    // If last index and cover image present - show cover image
                                    if (isLastIndex) {
                                      final coverUrl = projectDetails!.coverImage!;
                                      final isVideoType = isVideo(coverUrl);

                                      return Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(16.0),
                                          child: SizedBox(
                                            width: Get.width * 0.6,
                                            height: Get.height * 0.4,
                                            child: GestureDetector(
                                              onTap: () => showFullScreenMedia(coverUrl, isVideoType),
                                              child: isVideoType
                                                  ? VideoPlayerWidget(videoPath: coverUrl, autoPlay: false)
                                                  : CachedNetworkImage(
                                                imageUrl: coverUrl,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }

                                    // Show property images for other indexes
                                    if (projectImages == null || index >= projectImages!.length) {
                                      return const SizedBox.shrink();
                                    }

                                    final mediaUrl = projectImages![index].image ?? '';
                                    final isVideoType = isVideo(mediaUrl);
                                    final patternIndex = index % 3;

                                    if (patternIndex == 0) {
                                      // Large media
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(16.0),
                                          child: SizedBox(
                                            width: Get.width * 0.6,
                                            height: Get.height * 0.4,
                                            child: GestureDetector(
                                              onTap: () => showFullScreenMedia(mediaUrl, isVideoType),
                                              child: isVideoType
                                                  ? VideoPlayerWidget(videoPath: mediaUrl, autoPlay: false)
                                                  : CachedNetworkImage(
                                                imageUrl: mediaUrl,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    } else if (patternIndex == 1) {
                                      final hasNextMedia = index + 1 < projectImages!.length;

                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            // First small media
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(16.0),
                                              child: SizedBox(
                                                width: Get.width * 0.5,
                                                height: Get.height * 0.14,
                                                child: GestureDetector(
                                                  onTap: () => showFullScreenMedia(mediaUrl, isVideoType),
                                                  child: isVideoType
                                                      ? VideoPlayerWidget(videoPath: mediaUrl, autoPlay: false)
                                                      : CachedNetworkImage(
                                                    imageUrl: mediaUrl,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            // Second small media (next item)
                                            if (hasNextMedia)
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(16.0),
                                                child: SizedBox(
                                                  width: Get.width * 0.5,
                                                  height: Get.height * 0.15,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      final nextUrl = projectImages![index + 1].image ?? '';
                                                      final nextIsVideo = isVideo(nextUrl);
                                                      showFullScreenMedia(nextUrl, nextIsVideo);
                                                    },
                                                    child: isVideo(projectImages![index + 1].image ?? '')
                                                        ? VideoPlayerWidget(
                                                        videoPath: projectImages![index + 1].image ?? '',
                                                        autoPlay: false)
                                                        : CachedNetworkImage(
                                                      imageUrl: projectImages![index + 1].image ?? '',
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      );
                                    } else {
                                      return const SizedBox.shrink();
                                    }
                                  },
                                ),
                              ),
                            ),
                          )
                              :
                          Padding(
                            padding: const EdgeInsets.only(left: 10, top: 10),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0),
                              ),
                              child: SizedBox(
                                height: Get.height * 0.325,
                                width: double.infinity,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: mediaUrls.length,
                                  itemBuilder: (context, index) {
                                    final mediaUrl = mediaUrls[index];
                                    final isVideoType = isVideo(mediaUrl);

                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(16.0),
                                        child: SizedBox(
                                          width: Get.width * 0.9, // Adjust for some padding
                                          height: Get.height * 0.3,
                                          child: GestureDetector(
                                            onTap: () => showFullScreenMedia(mediaUrl, isVideoType),
                                            child: isVideoType
                                                ? VideoPlayerWidget(
                                              videoPath: mediaUrl,
                                              autoPlay: false,
                                            )
                                                : CachedNetworkImage(
                                              imageUrl: mediaUrl,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
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
                    ],
                  ),
                  boxH15(),

              isValidString(projectDetails?.videoUrl)
                ? RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Check link: ',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                        TextSpan(
                          text: projectDetails?.videoUrl ?? '',
                          style: const TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                            fontSize: 16,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              final url = projectDetails?.videoUrl;
                              if (url != null) {
                                final uri = Uri.parse(url);
                                if (await canLaunchUrl(uri)) {
                                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                                }
                              }
                            },
                        ),
                      ],
                    ),
                  )
                      : const SizedBox(),

                  boxH08(),
                  SizedBox(
                    height: 50,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildSectionButton('About', _aboutKey),
                        _buildSectionButton('Address', _locationNameKey),
                        _buildSectionButton('Overview', _overviewKey),
                        _buildSectionButton(
                            'Price & floor Plan', _priceFloorKey),
                        _buildSectionButton('Amenities', _amenitiesKey),
                        _buildSectionButton('More Details', _floorsKey),

                        _buildSectionButton('Location', _locationKey),
                      ],
                    ),
                  ),
                  const Divider(thickness: 0.2, color: Colors.grey),

                  Padding(
                    padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        boxH05(),

                        /// about property
                        Container(
                          key: _aboutKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: Text(
                                  'About ${projectDetails?.projectName?.toString() ?? ''}',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              boxH10(),
                              Text( projectDetails?.projectDescription?.toString() ??'',
                                textAlign: TextAlign
                                    .justify,
                                style: const TextStyle(
                                  fontSize: 14, // Adjust as needed
                                  height: 1.4, // Line height
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(thickness: 0.2, color: Colors.grey),

                        /// Property Location
                        Container(
                          key: _locationNameKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Divider(thickness: 0.2, color: Colors.grey),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: Text(
                                  'Address',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              boxH10(),
                              Text(
                                projectDetails?.address.toString() ?? '',
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        const Divider(thickness: 0.2, color: Colors.grey),
                        boxH10(),

                        /// overview properties
                      Container(
                        key: _overviewKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Overview',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            boxH10(),

                            Column(
                              children: [
                                if (projectDetails?.createdAt != null)
                                  DeveloperPropertyDetailRow(
                                    label: "Project Added Date",
                                    value: postPropertyController.formatDayMonthYear(
                                      projectDetails!.createdAt!,
                                    ),
                                  ),


                                if (projectDetails?.projectName?.isNotEmpty ?? false)
                                  DeveloperPropertyDetailRow(
                                    label: "Project Name",
                                    value: projectDetails!.projectName!,
                                  ),


                                  DeveloperPropertyDetailRow(
                                    label: "Area",
                                    value:    getFormattedAreaRangeText(),
                                  ),

                                if (projectDetails?.averageProjectPrice?.isNotEmpty ?? false)
                                  DeveloperPropertyDetailRow(
                                    label: "Price",
                                  //  value: postPropertyController.formatPriceRange(projectDetails?.averageProjectPrice ?? "",),
                                    value: postPropertyController.formatPriceRange(projectDetails?.averageProjectPrice??''),
                                  ),


                                  DeveloperPropertyDetailRow(
                                    label: "Price per Sq. Ft",

                                    value:  generatePriceRangeFromAverage(),
                                  ),

                                if (projectDetails?.projectType?.isNotEmpty ?? false)
                                  DeveloperPropertyDetailRow(
                                    label: "Property Type",
                                    value: projectDetails!.projectType!,
                                  ),

                                if (projectDetails?.congfigurations?.isNotEmpty ?? false)
                                  DeveloperPropertyDetailRow(
                                    label: "Configuration",
                                    value: projectDetails!.congfigurations!,
                                  ),

                                if (projectDetails?.totalProjectSize?.isNotEmpty ?? false)
                                  DeveloperPropertyDetailRow(
                                    label: "Total Project Size / Units",
                                    value: projectDetails!.totalProjectSize!,
                                  ),

                                if (projectDetails?.launchDate?.isNotEmpty ?? false)
                                  DeveloperPropertyDetailRow(
                                    label: "Launch Date",
                                    value: postPropertyController.formatDayMonthYear(
                                      projectDetails!.launchDate!,
                                    ),
                                  ),

                                if (projectDetails?.possessionStart?.isNotEmpty ?? false)
                                  DeveloperPropertyDetailRow(
                                    label: "Possession Start Date",
                                    value: postPropertyController.formatDayMonthYear(
                                      projectDetails!.possessionStart!,
                                    ),
                                  ),

                                if (projectDetails?.constructionStatus?.isNotEmpty ?? false)
                                  DeveloperPropertyDetailRow(
                                    label: "Possession Status",
                                    value: projectDetails!.constructionStatus!,
                                  ),

                                if (projectDetails?.reraId?.isNotEmpty ?? false)
                                  DeveloperPropertyDetailRow(
                                    label: "RERA ID",
                                    value: projectDetails!.reraId!,
                                  ),
                              ],
                            ),

                            const Divider(thickness: 1, color: Colors.grey),
                          ],
                        ),
                      ),

                      boxH10(),

                        /// Amenities
                        if(projectAmenities?.isNotEmpty ?? false)...{
                          Container(
                            key: _amenitiesKey,
                            width: _width,
                            padding: const EdgeInsets.all(8),
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                // Default values if height is unbounded
                                final itemHeight = 24.0;
                                final verticalSpacing = 10.0;

                                // Check if height is bounded
                                final hasBoundedHeight = constraints.hasBoundedHeight;
                                final maxHeight = constraints.maxHeight;

                                // Calculate items per column - use half if height is unbounded
                                int maxItemsInFirstColumn;
                                if (hasBoundedHeight && maxHeight.isFinite) {
                                  maxItemsInFirstColumn = (maxHeight / (itemHeight + verticalSpacing)).floor();
                                } else {
                                  // If height is unbounded, just split the list in half
                                  maxItemsInFirstColumn = (projectAmenities!.length / 2).ceil();
                                }

                                // Ensure we don't go out of bounds
                                maxItemsInFirstColumn = maxItemsInFirstColumn.clamp(0, projectAmenities!.length);

                                // Split amenities
                                final firstColumnAmenities = projectAmenities!.sublist(0, maxItemsInFirstColumn);
                                final secondColumnAmenities = projectAmenities!.sublist(
                                  maxItemsInFirstColumn,
                                  projectAmenities!.length,
                                );

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Amenities',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    boxH10(),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // First column
                                        Expanded(
                                          child: Wrap(
                                            direction: Axis.vertical,
                                            spacing: verticalSpacing,
                                            runSpacing: verticalSpacing,
                                            children: firstColumnAmenities
                                                .map((amenity) => _buildAmenityItem(amenity.name ?? ''))
                                                .toList(),
                                          ),
                                        ),

                                        // Second column (only if there are items)
                                        if (secondColumnAmenities.isNotEmpty)
                                          Expanded(
                                            child: Wrap(
                                              direction: Axis.vertical,
                                              spacing: verticalSpacing,
                                              runSpacing: verticalSpacing,
                                              children: secondColumnAmenities
                                                  .map((amenity) => _buildAmenityItem(amenity.name ??''))
                                                  .toList(),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            ),
                          ) ,  boxH20(),
                          const Divider(thickness: 1, color: Colors.grey),},

                        ///  Floors
                        Container(
                          key: _floorsKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 🔹 Section Title
                              const Text(
                                'More Details',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              boxH15(),

                              // ===================== 1️⃣ FLOORS =====================
                              if (_hasFloorData(projectDetails!)) ...{
                                const Text(
                                  'Floors',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                boxH10(),
                                if (projectDetails?.floorLivingDining?.isNotEmpty ?? false)
                                  DeveloperPropertyDetailRow(
                                      label: "Living/Dining",
                                      value: projectDetails?.floorLivingDining ?? 'N/A'),
                                if (projectDetails?.floorKitchenToilet?.isNotEmpty ?? false)
                                  DeveloperPropertyDetailRow(
                                      label: "Kitchen / Toilets",
                                      value: projectDetails?.floorKitchenToilet ?? 'N/A'),
                                if (projectDetails?.floorBedroom?.isNotEmpty ?? false)
                                  DeveloperPropertyDetailRow(
                                      label: "Bedroom",
                                      value: projectDetails?.floorBedroom ?? 'N/A'),
                                if (projectDetails?.floorBalcony?.isNotEmpty ?? false)
                                  DeveloperPropertyDetailRow(
                                      label: "Balcony",
                                      value: projectDetails?.floorBalcony ?? 'N/A'),
                                boxH10(),
                                const Divider(thickness: 0.3, color: Colors.grey),
                              },

                              // ===================== 2️⃣ WALLS =====================
                              if (_hasWallsData(projectDetails!)) ...{
                                boxH10(),
                                const Text(
                                  'Walls',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                boxH10(),
                                if (projectDetails?.wallsLivingDining?.isNotEmpty ?? false)
                                  DeveloperPropertyDetailRow(
                                      label: "Living/Dining",
                                      value: projectDetails?.wallsLivingDining ?? 'N/A'),
                                if (projectDetails?.wallsKitchenToilet?.isNotEmpty ?? false)
                                  DeveloperPropertyDetailRow(
                                      label: "Kitchen / Toilets",
                                      value: projectDetails?.wallsKitchenToilet ?? 'N/A'),
                                if (projectDetails?.wallsServantRoom?.isNotEmpty ?? false)
                                  DeveloperPropertyDetailRow(
                                      label: "Servant Room",
                                      value: projectDetails?.wallsServantRoom ?? 'N/A'),
                                boxH10(),
                                const Divider(thickness: 0.3, color: Colors.grey),
                              },

                              // ===================== 3️⃣ CEILINGS =====================
                              if (_hasCeilingsData(projectDetails!)) ...{
                                boxH10(),
                                const Text(
                                  'Ceilings',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                boxH10(),
                                if (projectDetails?.ceiling?.isNotEmpty ?? false)
                                  DeveloperPropertyDetailRow(
                                      label: "Ceilings",
                                      value: projectDetails?.ceiling ?? 'N/A'),
                                if (projectDetails?.ceilingsServantRoom?.isNotEmpty ?? false)
                                  DeveloperPropertyDetailRow(
                                      label: "Servant Room",
                                      value: projectDetails?.ceilingsServantRoom ?? 'N/A'),
                                boxH10(),
                                const Divider(thickness: 0.3, color: Colors.grey),
                              },

                              // ===================== 4️⃣ COUNTERS =====================
                              if (_hasCountersData(projectDetails!)) ...{
                                boxH10(),
                                const Text(
                                  'Counters',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                boxH10(),
                                if (projectDetails?.countersKitchenToilet?.isNotEmpty ?? false)
                                  DeveloperPropertyDetailRow(
                                      label: "Kitchen / Toilets",
                                      value: projectDetails?.countersKitchenToilet ?? 'N/A'),
                                boxH10(),
                                const Divider(thickness: 0.3, color: Colors.grey),
                              },

                              // ===================== 5️⃣ FITTINGS / FIXTURES =====================
                              if (_hasFittingsData(projectDetails!)) ...{
                                boxH10(),
                                const Text(
                                  'Fittings / Fixtures',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                boxH10(),
                                if (projectDetails?.fittingsFixturesKitchenToilet?.isNotEmpty ?? false)
                                  DeveloperPropertyDetailRow(
                                      label: "Kitchen / Toilets",
                                      value: projectDetails?.fittingsFixturesKitchenToilet ?? 'N/A'),
                                if (projectDetails?.fittingsFixturesServantRoomToilet?.isNotEmpty ?? false)
                                  DeveloperPropertyDetailRow(
                                      label: "Servant Room Toilet",
                                      value: projectDetails?.fittingsFixturesServantRoomToilet ?? 'N/A'),
                                boxH10(),
                                const Divider(thickness: 0.3, color: Colors.grey),
                              },

                              // ===================== 6️⃣ DOOR AND WINDOW =====================
                              if (_hasDoorWindowData(projectDetails!)) ...{
                                boxH10(),
                                const Text(
                                  'Door and Window',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                boxH10(),
                                if (projectDetails?.doorWindowInternalDoor?.isNotEmpty ?? false)
                                  DeveloperPropertyDetailRow(
                                      label: "Internal Door",
                                      value: projectDetails?.doorWindowInternalDoor ?? 'N/A'),
                                if (projectDetails?.doorWindowExternalGlazing?.isNotEmpty ?? false)
                                  DeveloperPropertyDetailRow(
                                      label: "External Glazing",
                                      value: projectDetails?.doorWindowExternalGlazing ?? 'N/A'),
                                boxH10(),
                                const Divider(thickness: 0.3, color: Colors.grey),
                              },

                              // ===================== 7️⃣ ELECTRICAL =====================
                              if (_hasElectricalData(projectDetails!)) ...{
                                boxH10(),
                                const Text(
                                  'Electrical',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                boxH10(),
                                if (projectDetails?.electrical?.isNotEmpty ?? false)
                                  DeveloperPropertyDetailRow(
                                      label: "Electrical",
                                      value: projectDetails?.electrical ?? 'N/A'),
                                if (projectDetails?.backup?.isNotEmpty ?? false)
                                  DeveloperPropertyDetailRow(
                                      label: "Backup",
                                      value: projectDetails?.backup ?? 'N/A'),
                                boxH10(),
                                const Divider(thickness: 0.3, color: Colors.grey),
                              },

                              // ===================== 8️⃣ SECURITY SYSTEM =====================
                              if (projectDetails?.securitySystem?.isNotEmpty ?? false) ...{
                                boxH10(),
                                const Text(
                                  'Security System',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                boxH10(),
                                DeveloperPropertyDetailRow(
                                    label: "Security System",
                                    value: projectDetails?.securitySystem ?? 'N/A'),
                                boxH10(),
                                const Divider(thickness: 0.3, color: Colors.grey),
                              },

                              boxH20(),
                            ],
                          ),
                        ),


                        /// Location
                        Container(
                          key: _locationKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {},
                                child: const Text(
                                  'Location',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              boxH10(),
                              Container(
                                height: 250,
                                width: Get.width,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey.withOpacity(0.2)),
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(30.0),
                                  child: _buildMapWidget(),
                                ),
                              ),

                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 20,),


                  boxH10(),
                ],
              ),
            ),
          ),
        ),
         bottomNavigationBar:  GestureDetector(
           onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>
               ProjectAgentProfile(agent_id: projectDetails!.userId,),)),
           child: Container(
             height: 85,
             decoration: BoxDecoration(
                 color: Colors.white,
                 border: Border.all(color: Colors.grey.withOpacity(0.4)),
                 borderRadius: BorderRadius.circular(18)
             ),
             child: Padding(
               padding: const EdgeInsets.all(12.0),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Row(
                     mainAxisAlignment: MainAxisAlignment.start,
                     crossAxisAlignment: CrossAxisAlignment.center,
                     children: [
                       /// Left Side: Avatar + Name + Agent Label
                       Expanded(
                         child: Row(
                           crossAxisAlignment: CrossAxisAlignment.center,
                           children: [
                             GestureDetector(
                               onTap: () {
                                 Get.to(agent_profile(
                                   agent_name: projectDetails?.connectToName ?? '',
                                   agent_id: projectDetails?.userId ?? "",
                                 ));
                               },
                               child: CircleAvatar(
                                 radius: 24,
                                 backgroundImage: (user_data != null &&
                                     user_data!.isNotEmpty &&
                                     user_data![0].profileImage != null &&
                                     user_data![0].profileImage.toString().isNotEmpty)
                                     ? CachedNetworkImageProvider(
                                   user_data![0].profileImage.toString(),
                                 )
                                     : null,
                                 backgroundColor: AppColor.grey.withOpacity(0.1),
                                 child: (user_data == null ||
                                     user_data!.isEmpty ||
                                     user_data![0].profileImage == null ||
                                     user_data![0].profileImage.toString().isEmpty)
                                     ? ClipOval(
                                   child: Image.asset(
                                     'assets/image_rent/profile.png',
                                     width: 30,
                                     height: 30,
                                     fit: BoxFit.cover,
                                   ),
                                 )
                                     : null,
                               ),
                             ),
                             boxW08(),
                             /// Wrap text in Expanded to avoid overflow
                             Expanded(
                               child: Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   Text(
                                     (user_data != null && user_data!.isNotEmpty) ? user_data![0].fullName! : '',
                                     style: const TextStyle(
                                       fontWeight: FontWeight.bold,
                                       fontSize: 16.0,
                                       color: Colors.black,
                                     ),
                                     maxLines: 2,
                                     overflow: TextOverflow.ellipsis,
                                   ),

                                   Text(
                                     // user_data?[0].userType ?? '',
                                     (user_data != null && user_data!.isNotEmpty) ? user_data![0].userType! : '',
                                     style: const TextStyle(
                                       fontSize: 14.0,
                                     ),
                                     overflow: TextOverflow.ellipsis,
                                   ),
                                 ],
                               ),
                             ),
                           ],
                         ),
                       ),

                       /// Right Side: Custom Button
                       commonButton(
                         width: _width * 0.4,
                         buttonColor: AppColor.primaryThemeColor,
                         text: 'Send an Enquiry',
                         textStyle: const TextStyle(fontSize: 14, color: Colors.white),
                         // onPressed: () {
                         //   _showSendInquiryBottomSheet(context);
                         // },
                         onPressed: () {
                           // _showSendInquiryBottomSheet(context);

                           if (isLogin == true) {
                             _showSendInquiryBottomSheet(context);
                           } else {
                             Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                           }
                         },
                       ),
                     ],
                   ),

                 ],
               ),
             ),
           ),
         ),
      ),
    );

  }
  void showFullScreenMedia(String url, bool isVideo) {
    if (isVideo) {
      // Navigate to a fullscreen video player screen
      showVideoPreview(url);
    } else {
      // Navigate to fullscreen image viewer
      Get.to(() => FullScreenImageView(imageUrl: url));
    }
  }
  Widget _buildMapWidget() {
    final lat = double.tryParse(projectDetails?.latitude ?? '');
    final lng = double.tryParse(projectDetails?.longitude ?? '');
    print("latitude : ${projectDetails?.latitude}");
    print("longitude : ${projectDetails?.longitude}");
    if (lat == null || lng == null) {
      return const Center(
        child: Text('Location not available'),
      );
    }

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(lat, lng),
        zoom: 15,
      ),
      onMapCreated: (GoogleMapController controller) {
        mapController = controller;
      },
      markers: {
        Marker(
          markerId: const MarkerId('property_location'),
          position: LatLng(lat, lng),
          infoWindow: const InfoWindow(title: 'Property Location'),
        ),
      },
      zoomGesturesEnabled: true,
      scrollGesturesEnabled: true,
      rotateGesturesEnabled: true,
      tiltGesturesEnabled: true,
      zoomControlsEnabled: true,
      myLocationButtonEnabled: false,
    );
  }
  bool _hasFloorData(ProjectDetails project) {
    return project.floorLivingDining?.isNotEmpty == true ||
        project.floorKitchenToilet?.isNotEmpty == true ||
        project.floorBedroom?.isNotEmpty == true ||
        project.floorBalcony?.isNotEmpty == true;
  }

  bool _hasWallsData(ProjectDetails project) {
    return project.wallsLivingDining?.isNotEmpty == true ||
        project.wallsKitchenToilet?.isNotEmpty == true ||
        project.wallsServantRoom?.isNotEmpty == true;
  }
  String formatPrice(String price) {
    try {
      final value = double.parse(price);

      if (value >= 10000000) {
        return '${(value / 10000000).round()} Cr';
      } else if (value >= 100000) {
        return '${(value / 100000).round()} L';
      } else if (value >= 1000) {
        return '${(value / 1000).round()} K';
      } else {
        return value.toStringAsFixed(0);
      }
    } catch (e) {
      return price; // fallback if parsing fails
    }
  }



  bool _hasCeilingsData(ProjectDetails project) {
    return project.ceiling?.isNotEmpty == true ||
        project.ceilingsServantRoom?.isNotEmpty == true;
  }

  bool _hasCountersData(ProjectDetails project) {
    return project.countersKitchenToilet?.isNotEmpty == true;
  }

  bool _hasFittingsData(ProjectDetails project) {
    return project.fittingsFixturesKitchenToilet?.isNotEmpty == true ||
        project.fittingsFixturesServantRoomToilet?.isNotEmpty == true;
  }

  bool _hasDoorWindowData(ProjectDetails project) {
    return project.doorWindowExternalGlazing?.isNotEmpty == true ||
        project.doorWindowInternalDoor?.isNotEmpty == true;
  }

  bool _hasElectricalData(ProjectDetails project) {
    return project.electrical?.isNotEmpty == true;
  }

  bool _hasSecurityData(ProjectDetails project) {
    return project.securitySystem?.isNotEmpty == true;
  }
  // Future<void> _downloadAndViewPdf({required String pdfUrl}) async {
  //   // Replace with your actual PDF URL
  //
  //   try {
  //     // 1. Check and request storage permission
  //     final status = await Permission.storage.request();
  //     if (!status.isGranted) {
  //       if (!mounted) return;
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Storage permission denied')),
  //       );
  //       return;
  //     }
  //
  //     // 2. Show downloading indicator
  //     showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (context) => const AlertDialog(
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             CircularProgressIndicator(),
  //             SizedBox(height: 16),
  //             Text('Downloading brochure...'),
  //           ],
  //         ),
  //       ),
  //     );
  //
  //     // 3. Download the file
  //     final file = await _downloadFileWithRetry(pdfUrl, 'property_brochure.pdf');
  //
  //     // 4. Close the loading dialog
  //     if (!mounted) return;
  //     Navigator.of(context).pop();
  //
  //     // 5. Open the downloaded file
  //     final openResult = await OpenFilex.open(file.path);
  //
  //     if (openResult.type != ResultType.done) {
  //       if (!mounted) return;
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Failed to open file: ${openResult.message}')),
  //       );
  //     }
  //
  //   } on DioException catch (e) {
  //     Navigator.of(context).pop();
  //     if (!mounted) return;
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Download failed: ${e.message}')),
  //     );
  //   } catch (e) {
  //     Navigator.of(context).pop();
  //     if (!mounted) return;
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error: $e')),
  //     );
  //     debugPrint('Download error: $e');
  //   }
  // }
///
  // Future<void> _downloadAndViewPdf({required String pdfUrl}) async {
  //   try {
  //     // 1. Permission check
  //     final status = await Permission.storage.request();
  //     if (!status.isGranted) {
  //       if (!mounted) return;
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Storage permission denied')),
  //       );
  //       return;
  //     }
  //
  //     // 2. Show loading dialog
  //     showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (context) => const AlertDialog(
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             CircularProgressIndicator(),
  //             SizedBox(height: 16),
  //             Text('Downloading brochure...'),
  //           ],
  //         ),
  //       ),
  //     );
  //
  //     final isImage = pdfUrl.toLowerCase().endsWith('.jpg') ||
  //         pdfUrl.toLowerCase().endsWith('.jpeg') ||
  //         pdfUrl.toLowerCase().endsWith('.png');
  //
  //     File file;
  //
  //     if (isImage) {
  //       file = await _downloadImageAndConvertToPdf(pdfUrl);
  //     } else {
  //       file = await _downloadFileWithRetry(pdfUrl, 'property_brochure.pdf');
  //     }
  //
  //     // Close loading
  //     if (!mounted) return;
  //     Navigator.of(context).pop();
  //
  //     // Open file
  //     final openResult = await OpenFilex.open(file.path);
  //
  //     if (openResult.type != ResultType.done) {
  //       if (!mounted) return;
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Failed to open file: ${openResult.message}')),
  //       );
  //     }
  //   } catch (e) {
  //     if (!mounted) return;
  //     Navigator.of(context).pop();
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error: $e')),
  //     );
  //     debugPrint('Error: $e');
  //   }
  // }


  Future<void> _downloadAndViewPdf({required String pdfUrl}) async {
    try {
      // 1. Request storage permission
      PermissionStatus status = await Permission.storage.request();

      bool hasPermission = status.isGranted;

      File? file;

      if (hasPermission) {
        // ✅ Permission granted – download the file

        // Show loading dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Downloading brochure...'),
              ],
            ),
          ),
        );

        final isImage = pdfUrl.toLowerCase().endsWith('.jpg') ||
            pdfUrl.toLowerCase().endsWith('.jpeg') ||
            pdfUrl.toLowerCase().endsWith('.png');

        if (isImage) {
          file = await _downloadImageAndConvertToPdf(pdfUrl); // assumes this function returns a File
        } else {
          file = await _downloadFileWithRetry(pdfUrl, 'property_brochure.pdf');
        }

        if (!mounted) return;
        Navigator.of(context).pop(); // Close loading dialog

        // ✅ Open downloaded file
        final openResult = await OpenFilex.open(file.path);
        if (openResult.type != ResultType.done) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to open file: ${openResult.message}')),
          );
        }
      } else {
        // ❌ Permission denied – open URL directly

        final Uri uri = Uri.parse(pdfUrl);

        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication); // or in-app view if you prefer
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not open the PDF link.')),
          );
        }
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.of(context).pop(); // Close loading dialog if open
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      debugPrint('Error: $e');
    }
  }

  Future<File> _downloadImageAndConvertToPdf(String imageUrl) async {
    final response = await Dio().get<List<int>>(
      imageUrl,
      options: Options(responseType: ResponseType.bytes),
    );

    final Uint8List imageBytes = Uint8List.fromList(response.data!);
    final pdf = pw.Document();

    final image = pw.MemoryImage(imageBytes);

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Center(
          child: pw.Image(image),
        ),
      ),
    );

    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/converted_image.pdf');
    await file.writeAsBytes(await pdf.save());

    return file;
  }

  String formatDate(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);
      return DateFormat('d, MMM yy').format(date);
    } catch (e) {
      return dateString;
    }
  }
  Future<File> _downloadFileWithRetry(String url, String fileName,
      {int maxRetries = 2}) async
  {
    int attempt = 0;
    DioException? lastError;

    while (attempt < maxRetries) {
      try {
        final dir = await getApplicationDocumentsDirectory();
        final filePath = '${dir.path}/$fileName';
        final file = File(filePath);

        final dio = Dio();
        final response = await dio.get(
            url,
            options: Options(
              responseType: ResponseType.bytes,
              followRedirects: true,
              receiveTimeout: const Duration(seconds: 30),
            ));

            await file.writeAsBytes(response.data);
        return file;
      } on DioException catch (e) {
        lastError = e;
        attempt++;
        if (attempt >= maxRetries) rethrow;
        await Future.delayed(const Duration(seconds: 1));
      }
    }
    throw lastError ?? Exception('Unknown download error');
  }

  void _onScroll() {
    final double scrollPosition = _scrollController.position.pixels;


    if (scrollPosition < _getSectionOffset(_detailsKey)) {
      setState(() {
        _currentSection = 'Overview';
      });
    } else if (scrollPosition < _getSectionOffset(_amenitiesKey)) {
      setState(() {
        _currentSection = 'Details';
      });
    } else if (scrollPosition < _getSectionOffset(_aboutKey)) {
      setState(() {
        _currentSection = 'Amenities';
      });
    } else if (scrollPosition < _getSectionOffset(_locationKey)) {
      setState(() {
        _currentSection = 'About';
      });
    } else {
      setState(() {
        _currentSection = 'Location';
      });
    }
  }

  double _getSectionOffset(GlobalKey key) {
    final RenderBox renderBox =
        key.currentContext!.findRenderObject() as RenderBox;
    return renderBox.localToGlobal(Offset.zero).dy;
  }

  Widget _buildSectionButton(String title, GlobalKey key) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextButton(
        onPressed: () {
          Scrollable.ensureVisible(
            key.currentContext!,
            duration: const Duration(seconds: 1),
            curve: Curves.easeInOut,
          );
        },
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: _currentSection == title
                ? Colors.deepPurple
                : Colors.black.withOpacity(0.6),
          ),
        ),
      ),
    );
  }

  double getLatitude(productDetails) {
    if (productDetails != null && productDetails != null) {
      return double.tryParse(productDetails) ?? 18.5642;
    }
    return 18.5642;
  }

  double getLongitude( productDetails) {
    if (productDetails != null && productDetails != null) {
      return double.tryParse(productDetails) ?? 73.7769;
    }
    return 73.7769;
  }

  // Reusable amenity item widget
  Widget _buildAmenityItem(String amenity) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(Icons.circle, size: 8, color: Colors.black),
        const SizedBox(width: 10),
        Flexible(
          child: Text(
            amenity,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black.withOpacity(0.8),
            ),
          ),
        ),
      ],
    );
  }

 /*  _showContactDetailsBottomSheet(BuildContext context, String? name, String? phoneNo) {

    bool hasContactPlan = freeViewCount > 0;
    if(paidViewCount > 0){
      setState(() {
        hasContactPlan = true; // if user has paid count
      });
    }
    print('has plan : ${hasContactPlan}');
    print('name :$name');
    print('number :$phoneNo');
     // Mask the phone number if no active plan
      String displayedPhone = hasContactPlan
          ? phoneNo ?? ''
          : _maskPhoneNumber(phoneNo);
    String displayedName = hasContactPlan
          ? name ?? ''
          : _maskName(name);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.width * 0.72,
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
                  children: [
                    Padding(
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
                          onTap: () => Get.back(),
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
                    const Spacer(),
                    const Text(
                      "Contact Details",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
                boxH25(),
                CustomTextFormField(
                  controller: TextEditingController(text: displayedName),
                  size: 75,
                  maxLines: 3,
                  hintText: displayedName,
                  keyboardType: TextInputType.number,
                  readOnly: true,
                ),
                boxH10(),
                CustomTextFormField(
                  controller: TextEditingController(text: displayedPhone),
                  size: 75,
                  maxLines: 3,
                  hintText: displayedPhone,
                  keyboardType: TextInputType.number,
                  readOnly: true,
                ),
                // Optionally show a purchase button if no active plan
                if (!hasContactPlan) ...[
                  boxH10(),
               commonButton(text: 'Purchase Contact Plan', onPressed: () {
                 Get.to(const PlansAndSubscription());
               },)
                ],
              ],
            ),
          ),
        );
      },
    ).
    //     .then((value)async {
    //   if(freeViewCount > 0) {
    //     await planController.add_count(isfrom: 'free_contact', count: -1);
    //     await SPManager.instance.setFreeViewCount(FREE_VIEW, freeViewCount - 1);
    //   }
    //   else if(paidViewCount > 0 ){
    //     await planController.add_count(isfrom: 'paid_contact', count: -1);
    //     await SPManager.instance.setFreeViewCount(PAID_VIEW, freeViewCount - 1);
    //   }
    // },);

    then((value)async {

      print("free_contact")  ;
      print(freeViewCount)  ;
      print(paidViewCount)  ;
      if(freeViewCount > 0) {
        await planController.add_count(isfrom: 'free_contact', count:  -1);
        await SPManager.instance.setFreeViewCount(FREE_VIEW, freeViewCount - 1);

        print("free_contact")  ;
      }
      else if(paidViewCount > 0 ){
        await planController.add_count(isfrom: 'paid_contact', count: -1);
        await SPManager.instance.setPaidViewCount(PAID_VIEW, paidViewCount - 1);
      }
      print("paidViewCount==>")  ;
      print(freeViewCount)  ;
      print(paidViewCount - 1)  ;
    },);
  }*/

  _showContactDetailsBottomSheet(BuildContext context, String? name, String? phoneNo) {
    bool hasContactPlan =false;
    if(isContact == "yes"){
      print("object1");
      if(paidViewCount >= 0){
        print("object2");
        setState(() {
          hasContactPlan = true;
        });
      } else{
        print("object3");
        setState(() {
          hasContactPlan = false;
        });
      }
    }else{
      print("object4");
      if(freeViewCount > 0){
        print("object5");
        setState(() {
          hasContactPlan = true;
        });
      } else{
        print("object6");
        setState(() {
          hasContactPlan = false;
        });
      }
    }

    print(name);
    print(phoneNo);

    String displayedPhone = hasContactPlan ==true
        ? phoneNo ?? ''
        : _maskPhoneNumber(phoneNo);
    String displayedName = hasContactPlan ==true
        ? name ?? ''
        : _maskName(name);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return SizedBox(
          // height: MediaQuery.of(context).size.width * 0.75,
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
                  children: [
                    Padding(
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
                          onTap: () => Get.back(),
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
                    const Spacer(),
                    const Text(
                      "Contact Details",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
                boxH25(),
                // Name Container
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    displayedName ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
                boxH10(),


                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    displayedPhone ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
                boxH10(),
                if (hasContactPlan==false) ...[
                  boxH10(),
                  commonButton(text: 'Purchase Contact Plan', onPressed: () {
                    Get.to(const PlansAndSubscription(isfrom: 'contact',))?.then((value) async {
                      if (value != null) {
                        await getData();
                      }
                    });

                  },),
                  boxH10(),

                ],

              ],
            ),
          ),
        );
      },
    ).then((value)async {

      print("free_contact")  ;
      print(freeViewCount)  ;
      print(paidViewCount)  ;
      if(freeViewCount > 0) {
        await planController.add_count(isfrom: 'free_contact', count:  -1);
        await SPManager.instance.setFreeViewCount(FREE_VIEW, freeViewCount - 1);

        print("free_contact")  ;
      }
      else if(paidViewCount > 0 ){
        await planController.add_count(isfrom: 'paid_contact', count: -1);
        await SPManager.instance.setPaidViewCount(PAID_VIEW, paidViewCount - 1);
      }
      print("paidViewCount==>")  ;
      print(freeViewCount)  ;
      print(paidViewCount - 1)  ;
      await getData();

    },);
  }

// Helper function to mask phone number
  String _maskPhoneNumber(String? phone) {
    if (phone == null || phone.length < 4) return '****';

    // Keep first 2 and last 2 digits, mask the rest
    String masked = phone.substring(0, 2) +
        '*' * (phone.length - 4) +
        phone.substring(phone.length - 2);
    return masked;
  }
  String _maskName(String? name) {
    if (name == null || name.isEmpty) return '****';

    // Split into parts in case of multiple names
    final parts = name.split(' ');
    final maskedParts = parts.map((part) {
      if (part.length <= 2) {
        // For very short names, just show first character
        return part[0] + '*' * (part.length - 1);
      } else {
        // For longer names, show first 2 and last 1 characters
        final visibleStart = part.substring(0, 2);
        final visibleEnd = part.length > 3 ? part.substring(part.length - 1) : '';
        final maskedMiddle = '*' * (part.length - 2 - visibleEnd.length);
        return visibleStart + maskedMiddle + visibleEnd;
      }
    }).toList();

    return maskedParts.join(' ');
  }

  _showSendInquiryBottomSheet(BuildContext context) async {
    nameController.text = await SPManager.instance.getName(NAME) ?? "";

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 20,
          ),
          child: Form(
            key: _formkey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
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
                          borderRadius: BorderRadius.circular(
                              50), // Ensures ripple effect is circular
                          child: const Padding(
                            padding: EdgeInsets.all(
                                6), // Adjust padding for better spacing
                            child: Icon(
                              Icons.arrow_back_outlined,
                              size:
                              18, // Slightly increased for better visibility
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),

                    /// Spacer pushes the text to center
                    const Spacer(),

                    /// Centered Title
                    const Text(
                      "Send an Enquiry",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),

                    /// Spacer for balancing layout
                    const Spacer(),
                  ],
                ),
                boxH25(),
                CustomTextFormField(
                  controller: nameController,
                  size: 45,
                  maxLines: 2,
                  hintText: 'Name',
                  keyboardType: TextInputType.text,
                  validator: (value){
                    if (value == null || value.isEmpty) {
                      return 'Please enter name';
                    }
                    return null;
                  },
                ),
                boxH15(),
                CustomTextFormField(
                    controller: phoneController,
                    size: 45,
                    maxLines: 2,
                    readOnly: true,
                    hintText: 'Number',
                    keyboardType: TextInputType.number
                ),
                CustomTextFormField(
                    controller: msgController,
                    maxLines: 5,
                    size: Get.height * 0.2,
                    hintText: 'Message',
                    keyboardType: TextInputType.text,
                  validator: (value){
                    if (value == null || value.isEmpty) {
                      return 'Please enter Message';
                    }
                    return null;
                  },
                ),
                commonButton(text: 'Send an Enquiry', onPressed: () {
                  search_controller.addProjectEnquiry
                    (property_id: projectDetails?.id ,
                      name: nameController.text,
                      message: msgController.text,
                      number: phoneController.text,
                    owner_id: projectDetails?.userId
                  )
                      .then((value){
                    nameController.clear();
                    msgController.clear();
                  });              },
                buttonColor: AppColor.primaryThemeColor
                ),
                boxH10(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class FullPlanFloorScreenImageScreen extends StatelessWidget {
  final String imagePath;

  const FullPlanFloorScreenImageScreen({Key? key, required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Floor Plan",
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 46,
        leading: Padding(
          padding: const EdgeInsets.only(left: 15.0),
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
      ),
      body: SizedBox.expand(
        child: InteractiveViewer(
          panEnabled: true,
          boundaryMargin: EdgeInsets.zero,
          minScale: 0.5,
          maxScale: 3.0,
          child: CachedNetworkImage(
            imageUrl: imagePath,
            fit: BoxFit.contain,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      ),
    );
  }
  String formatDayMonthYear(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd MMM, yyyy').format(date);
    } catch (e) {
      return 'N/A';
    }
  }
}
