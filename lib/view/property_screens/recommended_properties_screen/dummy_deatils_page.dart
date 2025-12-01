import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:real_estate_app/common_widgets/custom_textformfield.dart';
import 'package:real_estate_app/common_widgets/height.dart';
import 'package:real_estate_app/common_widgets/loading_dart.dart';
import 'package:real_estate_app/global/app_color.dart';
import 'package:real_estate_app/view/auth/login_screen/login_screen.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/CustomBottomNavBar.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/profile_screen/profile_section_screens/PlansAndSubscriptions/PlansAndSubscription.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/profile_screen/profile_section_screens/my_virtual_tour/GetScheduleBottomSheet.dart';
import 'package:real_estate_app/view/property_screens/agent_profile.dart';
import 'package:real_estate_app/view/property_screens/models/property_details_model.dart';
import 'package:real_estate_app/view/property_screens/recommended_properties_screen/PropertyDetailRow.dart';
import 'package:real_estate_app/view/subscription%20model/controller/SubscriptionController.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import '../../../global/api_string.dart';
import '../../../utils/CommonEnquirySheet.dart';
import '../../../utils/String_constant.dart';
import '../../../utils/shared_preferences/shared_preferances.dart';
import '../../../utils/text_style.dart';
import '../../dashboard/bottom_navbar_screens/profile_screen/profile_controller.dart';
import '../../dashboard/bottom_navbar_screens/profile_screen/profile_section_screens/my_virtual_tour/my_virtual_tour_screen.dart';
import '../../dashboard/bottom_navbar_screens/search_screen/searchController.dart';
import '../../splash_screen/splash_screen.dart';
import '../post_property_screen/NewChanges/video_player.dart';
import '../properties_controllers/post_property_controller.dart';

class PropertyDetailsScreen extends StatefulWidget {
  final String id;

  PropertyDetailsScreen({super.key, required this.id});

  @override
  State<PropertyDetailsScreen> createState() => _PropertyDetailsScreenState();
}

class _PropertyDetailsScreenState extends State<PropertyDetailsScreen> {

  final PageController _controller = PageController(initialPage: 0);
  GoogleMapController? mapController;
  final ProfileController profileController =  Get.find();
  final propertyController = Get.find<PostPropertyController>();
  final planController = Get.find<SubscriptionController>();
  final searchController search_controller = Get.find();
  String isContact = "", tour_schedule_date = '';
  int count = 0;
  final Uuid uuid = const Uuid();
  late String channelID;
  bool isVirtualTourSelected = false;
  bool isContactDetailsSelected = false;
  final _formKey = GlobalKey<FormState>();
  final List<String> mediaUrls = [];
  TextEditingController msgController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  late TextEditingController phoneController ;

  final ScrollController _scrollController = ScrollController();

  final GlobalKey _overviewKey = GlobalKey();

  final GlobalKey _detailsKey = GlobalKey();

  final GlobalKey _amenitiesKey = GlobalKey();

  final GlobalKey _aboutKey = GlobalKey();

  final GlobalKey _locationKey = GlobalKey();

  String _currentSection = 'Overview';

  PropertyDetails? propertyDetails;

  List<UserDetails>? userDetails;

  List<Amenities>? propertyAmenities;
  List<UserDetails>? user_data;

  List<PropertyImages>? propertyImages;

  List<TourSchedule>? projectTourSchedules;

  bool isVideo(String url) {
    if (url.isEmpty) return false;
    final uri = Uri.tryParse(url);
    final path = uri?.path ?? '';
    return path.toLowerCase().endsWith('.mp4') ||
        path.toLowerCase().endsWith('.mov') ||
        path.toLowerCase().endsWith('.webm') ||
        path.toLowerCase().endsWith('.avi');
  }

  late int freeViewCount;

  late int paidViewCount;

  // void checkPlan()async{
  //   freeViewCount =  await SPManager.instance.getFreeViewCount(FREE_VIEW) ?? 0;
  //   paidViewCount =  await SPManager.instance.getPaidViewCount(PAID_VIEW) ?? 0;
  //   print('view count ===>');
  //   print(freeViewCount);
  //   print(paidViewCount);
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(_onScroll);

    channelID = uuid.v4();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();
      getDetails();

      if (isLogin == true) {
        //  search_controller.addView(property_id: widget.id);
      }
      // Future.delayed(const Duration(seconds: 3), () {
      //   profileController.get_OwnerTimeslot(propertyDetails?.id ?? '');
      // });
    });
    phoneController = TextEditingController(text: profileController.mobile.value);
    print('Property details fetched: ${search_controller.propertyDetails}');
    print('Property images fetched: ${propertyController.getPropertyImageList}');
  }

  getDetails() async {
    try {

      await search_controller.getPropertyDetails(property_id: widget.id);

      if (search_controller.propertyDetails.value.data != null) {
        await search_controller.addView(owner_id: search_controller.propertyDetails.value.data?.propertyDetails?.userId,
            property_id:search_controller.propertyDetails.value.data?.propertyDetails?.id );
        setState(()  {
          propertyDetails = search_controller.propertyDetails.value.data?.propertyDetails;
          userDetails = search_controller.propertyDetails.value.data?.userDetails;
          propertyAmenities = search_controller.propertyDetails.value.data?.amenities ?? [];
          propertyImages = search_controller.propertyDetails.value.data?.propertyImages ?? [];
          user_data = search_controller.propertyDetails.value.data?.userDetails ?? [];
          projectTourSchedules = search_controller.propertyDetails.value.data?.tourSchedule ?? [];
          print('tour : ${projectTourSchedules?.length}');
          // Add null check for propertyVideo
          if (propertyDetails?.propertyVideo != null && propertyDetails!.propertyVideo!.isNotEmpty) {
            propertyImages?.add(PropertyImages(id: '1212', image: propertyDetails!.propertyVideo));
          }
// Add property images if available
          if (propertyImages != null && propertyImages!.isNotEmpty) {
            mediaUrls.addAll(propertyImages!
                .map((e) => e.image ?? '')
                .where((url) => url.isNotEmpty));
          }

// If no property images, show cover image (if available)
          if (mediaUrls.isEmpty && (propertyDetails?.coverImage?.isNotEmpty ?? false)) {
            mediaUrls.add(propertyDetails!.coverImage!);
          }

// Optionally add video at the end if uploaded
          // Optionally add video at the end if uploaded and it's a video file
          if ((propertyDetails?.videoUrl?.isNotEmpty ?? false)) {
            final videoUrl = propertyDetails!.videoUrl!;
            if (isVideo(videoUrl)) {
              mediaUrls.add(videoUrl);
            }
          }

        });


      }
    }
    catch (e) {
      debugPrint("Error in getDetails: $e");
      setState(() {
        propertyDetails = null;
        propertyAmenities = [];
        propertyImages = [];
        projectTourSchedules = [];
      });
    }
  }

  List<Widget> _buildAmenitiesList(List<Amenities> amenities) {
    return amenities.map<Widget>((amenity) {
      String amenityName = amenity.name ?? '';
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.circle,
              size: 8,
              color: Colors.black,
            ),
            boxW10(),
            Expanded(
              child: Text(
                amenityName,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black.withOpacity(0.8),
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
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

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
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

  void _onScroll() {
    final double scrollPosition = _scrollController.position.pixels;

    // Calculate which section is currently visible
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
    final RenderBox? renderBox = key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return 0.0;
    return renderBox.localToGlobal(Offset.zero).dy;
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width * 1;


    return Scaffold(
      backgroundColor: Colors.grey.shade100,
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
                    if (propertyDetails?.isFavorite ?? false) {
                      search_controller
                          .removeFavorite(
                        property_id: propertyDetails?.id,
                        favorite_id: propertyDetails?.favoriteId,
                      )
                          .then((_) {
                        propertyDetails?.isFavorite = false;
                      });
                    }
                    else {
                      search_controller
                          .addFavorite(property_id: propertyDetails?.id)
                          .then((_) {
                        propertyDetails?.isFavorite = true;

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
                    (propertyDetails != null && propertyDetails?.isFavorite ==
                        true)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: (propertyDetails != null && propertyDetails?.isFavorite == true)
                        ? Colors.red
                        : Colors.black.withOpacity(0.6),
                    size: 25.0,
                  ),
                ),
              ),
            ),
          ),
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
                onTap: () {},
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
      body: propertyDetails == null
          ? const Center(child: CircularProgressIndicator())
          :  Stack(
        children: <Widget>[
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              color: Colors.white.withOpacity(0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          propertyDetails!=
                              null
                              ? propertyDetails?.propertyName ?? 'N/A' : 'N/A',
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ) ,

                        boxH08(),
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
                                propertyDetails?.address ?? "",
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontFamily: "Muli",
                                ),
                              ),
                            ),
                          ],
                        ),

                        boxH10(),
                        // Text(
                        //   propertyDetails != null
                        //       ? propertyDetails?.propertyCategoryType == 'Buy' || propertyDetails?.propertyCategoryType == ''
                        //       ? propertyController.formatIndianPrice(propertyDetails?.propertyPrice.toString() ?? '0')
                        //       : "${propertyController.formatIndianPrice(propertyDetails?.propertyPrice.toString() ?? '0')} / Month (₹ ${propertyDetails?.rent != null ? '${(double.tryParse(propertyDetails!.customDepositAmount!) ?? 0 / 1000).toStringAsFixed(1)} K' : "0.0 K"} deposit)"
                        //       : "",
                        //   style: const TextStyle(
                        //     fontSize: 24,
                        //     color: AppColor.primaryThemeColor,
                        //     fontWeight: FontWeight.bold,
                        //   ),
                        // ),

                        propertyDetails?.propertyCategoryType =="Rent"?
                        Text(
                          '${propertyController.formatIndianPrice( propertyDetails?.propertyPrice.toString())} /'
                              ' ${propertyController.formatIndianPrice(propertyDetails?.rent.toString())} Month',
                          // ' ${propertyController.formatIndianPrice( propertyDetails?.rent.toString())}/ Month',
                          style: const TextStyle(
                            fontSize: 24,
                            color: AppColor.primaryThemeColor,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                            :
                        Text(
                          //   _postPropertyController.formatIndianPrice(property['rent']),
                          propertyController.formatIndianPrice(propertyDetails?.propertyPrice.toString()),
                          style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                        ),
                        boxH15(),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if( propertyDetails?.bhkType != null && propertyDetails?.bhkType != "")
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    "assets/image_rent/house.png",
                                    width: 24,
                                    height: 24,
                                  ),
                                  boxW02(),
                                  Text(
                                    propertyDetails?.bhkType ?? "",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),




                            // Area in Sq. Ft
                            if( propertyDetails?.area.toString() != null && propertyDetails?.area.toString() != "")
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    "assets/image_rent/format-square.png",
                                    width: 24,
                                    height: 24,
                                  ),
                                  boxW02(),
                                  Text(
                                        () {
                                      if (propertyDetails != null) {
                                        final area = double.tryParse(propertyDetails!.area.toString()) ?? 0.0;
                                        final unit = propertyDetails!.areaIn ?? 'Sq Ft';

                                        double areaInSqFt = propertyController.convertToSqFt(area, unit);
                                        return '${unit == "Sq Ft" ? area.toStringAsFixed(0) : areaInSqFt.toStringAsFixed(0)} Sq Ft';
                                      } else {
                                        return '';
                                      }
                                    }(),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),

                            propertyDetails?.bathroom!=null ||  propertyDetails?.bathroom!=""?
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset(
                                  "assets/image_rent/bathtub 1.png",
                                  width: 24,
                                  height: 24,
                                ),
                                boxW02(),
                                Text(
                                  (propertyDetails?.bathroom != null)
                                      ? '${propertyDetails!.bathroom} Bathroom${propertyDetails!.bathroom != 1 ? "s" : ""}'
                                      : "",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                )
                              ],
                            ):const SizedBox(),



                          ],
                        ),
                        boxH20(),

                        Row(
                          children: [
                            // Virtual Tour Button (Outlined)
                            propertyDetails?.virtualTourAvailability=="Yes"?

                            (projectTourSchedules != null &&
                                projectTourSchedules!.isNotEmpty &&
                                (projectTourSchedules!.last.status == "Rejected" ||
                                    projectTourSchedules!.last.status == "Expired"))

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
                                      name: userDetails?[0].fullName ?? "",
                                      userType: userDetails?[0].userType ?? "",
                                      propertyOwnerID: propertyDetails?.userId,
                                      propertyID: propertyDetails?.id,
                                      tour_type: 'property',
                                      image: user_data![0].profileImage.toString(),
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
                                !isDateExpiredFromString(projectTourSchedules?.last.scheduleDate ?? ''))
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
                                          "Scheduled ${propertyController.formatDayMonthYear(projectTourSchedules?.last.scheduleDate ?? '')}",
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
                                      name: userDetails?[0].fullName ?? "",
                                      userType: userDetails?[0].userType ?? "",
                                      propertyOwnerID: propertyDetails?.userId,
                                      propertyID: propertyDetails?.id,
                                      tour_type: 'property',
                                      image:user_data![0].profileImage.toString() ,
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

                            const SizedBox(width: 10),

                            // Contact Details Button (Elevated)

                            ElevatedButton(
                              onPressed: () {

                                if (isLogin == true) {
                                  _showContactDetailsBottomSheet(context, userDetails?[0].fullName, userDetails?[0].mobileNumber);
                                } else {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                                }

                              },
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(

                                  MediaQuery.of(context).size.width * 0.41,
                                  MediaQuery.of(context).size.height * 0.06,
                                ),
                                backgroundColor: AppColor.primaryThemeColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: const EdgeInsets.all(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    "assets/image_rent/formatContact.png",
                                    width: 24,
                                    height: 24,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 4),
                                  const Text(
                                    "Contact Details",
                                    style: TextStyle(
                                      color: Colors.white,
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
                  (propertyImages?.isNotEmpty ?? false || (propertyDetails?.coverImage ?? '').isNotEmpty)
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
                          itemCount: (propertyImages?.length ?? 0) + ((propertyDetails?.coverImage?.isNotEmpty ?? false) ? 1 : 0),
                          itemBuilder: (context, index) {
                            final hasCover = propertyDetails?.coverImage?.isNotEmpty ?? false;
                            final isLastIndex = hasCover && index == (propertyImages?.length ?? 0);

                            // If last index and cover image present - show cover image
                            if (isLastIndex) {
                              final coverUrl = propertyDetails!.coverImage!;
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
                            if (propertyImages == null || index >= propertyImages!.length) {
                              return const SizedBox.shrink();
                            }

                            final mediaUrl = propertyImages![index].image ?? '';
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
                              final hasNextMedia = index + 1 < propertyImages!.length;

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
                                              final nextUrl = propertyImages![index + 1].image ?? '';
                                              final nextIsVideo = isVideo(nextUrl);
                                              showFullScreenMedia(nextUrl, nextIsVideo);
                                            },
                                            child: isVideo(propertyImages![index + 1].image ?? '')
                                                ? VideoPlayerWidget(
                                                videoPath: propertyImages![index + 1].image ?? '',
                                                autoPlay: false)
                                                : CachedNetworkImage(
                                              imageUrl: propertyImages![index + 1].image ?? '',
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



                  const SizedBox(
                    height: 10,
                  ),
                  propertyDetails?.videoUrl != null &&  propertyDetails?.videoUrl!=""
                      ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RichText(
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
                            text: propertyDetails?.videoUrl ?? '',
                            style: const TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                              fontSize: 16,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                final url = propertyDetails?.videoUrl;
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
                    ),
                  )
                      : const SizedBox(),

                  SizedBox(
                    height: 50,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildSectionButton('Overview', _overviewKey),
                        _buildSectionButton('Details', _detailsKey),
                        _buildSectionButton('Amenities', _amenitiesKey),
                        _buildSectionButton('About', _aboutKey),
                        _buildSectionButton('Location', _locationKey),
                      ],
                    ),
                  ),
                  const Divider(thickness: 0.2, color: Colors.grey),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0, left: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        boxH05(),

                        /// overview properties
                        Container(
                          key: _overviewKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Overview',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              boxH10(),
                              Column(
                                children: [

                                  (propertyDetails?.area != null)
                                      ? PropertyDetailRow(
                                    label: "Area (Sq Ft)",
                                    value: () {
                                      final area = double.tryParse(propertyDetails?.area.toString() ?? '') ?? 0.0;
                                      final unit = propertyDetails?.areaIn ?? 'Sq Ft';

                                      final convertedArea = propertyController.convertToSqFt(area, unit);
                                      return '${convertedArea.toStringAsFixed(0)} Sq Ft';
                                    }(),
                                    image: '',
                                  )
                                      : const SizedBox.shrink(),

                                  (propertyDetails?.areaType != null)
                                      ? PropertyDetailRow(
                                    label: "Area Type",
                                    value:propertyDetails?.areaType ?? "N/A", image: '',

                                  )
                                      : const SizedBox.shrink(),

                                  // Developer
                                  (propertyDetails?.developer?.isNotEmpty ?? false ) ?  PropertyDetailRow(
                                    label: "Developer",
                                    value:  propertyDetails?.developer ?? "N/A", image: '',
                                  ) : const SizedBox.shrink(),

                                  // Project
                                  (propertyDetails?.propertyName?.isNotEmpty ?? false) ?  PropertyDetailRow(
                                    label: "Property Name",
                                    value:propertyDetails?.propertyName ?? "N/A", image: '',

                                  ) : const SizedBox.shrink(),

                                  (propertyDetails?.propertyAddedDate?.isNotEmpty ?? false) ?  PropertyDetailRow(
                                    label: "Property Added Date",
                                    value:propertyDetails?.propertyAddedDate ?? "N/A", image: '',

                                  ) : const SizedBox.shrink(),

                                  (propertyDetails?.propertyCategoryType?.isNotEmpty ?? false) ?  PropertyDetailRow(
                                    label: "Listing Type",
                                    value:propertyDetails?.propertyCategoryType ?? "N/A", image: '',

                                  ) : const SizedBox.shrink(),

                                  (propertyDetails?.buildingType?.isNotEmpty ?? false) ?  PropertyDetailRow(
                                    label: "Building Type",
                                    value:propertyDetails?.buildingType ?? "N/A", image: '',

                                  ) : const SizedBox.shrink(),

                                  (propertyDetails?.propertyType?.isNotEmpty ?? false) ?  PropertyDetailRow(
                                    label: "Property Type",
                                    value:propertyDetails?.propertyType ?? "N/A", image: '',

                                  ) : const SizedBox.shrink(),

                                  (propertyDetails?.propertyNo.toString().isNotEmpty ?? false) ?  PropertyDetailRow(
                                    label: "Property No",
                                    value: propertyDetails?.propertyNo.toString() ?? "N/A", image: '',
                                  ) : const SizedBox.shrink(),




                                  (propertyDetails?.plotNo != null && propertyDetails!.plotNo.toString().trim().isNotEmpty)
                                      ? PropertyDetailRow(
                                    label: "Plot No",
                                    value: propertyDetails!.plotNo.toString(),
                                    image: '',
                                  )
                                      : const SizedBox.shrink(),


                                  (propertyDetails?.officeSpaceType.toString().isNotEmpty ?? false) ?  PropertyDetailRow(
                                    label: "Office Space Type",
                                    value: propertyDetails?.officeSpaceType.toString() ?? "N/A", image: '',
                                  ) : const SizedBox.shrink(),
                                  // Floor
                                  (propertyDetails?.propertyFloor?.isNotEmpty ?? false) ?  PropertyDetailRow(
                                    label: "Floor",
                                    value: propertyDetails !=null
                                        ? "${propertyDetails?.propertyFloor ?? "N/A"} (Out of ${propertyDetails?.totalFloor ?? "N/A"} Floors)"
                                        : "N/A", image: '',
                                  ) : const SizedBox.shrink(),

                                  (propertyDetails?.flatName?.isNotEmpty ?? false) ?  PropertyDetailRow(
                                    label: "Flat Name",
                                    value: propertyDetails !=null
                                        ? "${propertyDetails?.flatName ?? "N/A"} (Out of ${propertyDetails?.flatName ?? "N/A"} Floors)"
                                        : "N/A", image: '',
                                  ) : const SizedBox.shrink(),
                                  // Transaction Type
                                  (propertyDetails?.transactionType?.isNotEmpty?? false) ?  PropertyDetailRow(
                                    label: "Transaction Type",
                                    value:  propertyDetails?.transactionType ?? "N/A", image: '',
                                  ) : const SizedBox.shrink(),

                                  // Status
                                  (propertyDetails?.availableStatus?.isNotEmpty ?? false) ?  PropertyDetailRow(
                                    label: "Availability Status",
                                    value: propertyDetails?.availableStatus ?? "N/A", image: '',

                                  ) : const SizedBox.shrink(),


                                  // Additional Rooms

                                  // Facing
                                  (propertyDetails?.facing?.isNotEmpty ?? false) ?  PropertyDetailRow(
                                    label: "Facing",
                                    value: propertyDetails?.facing ?? "N/A", image: '',
                                  ) : const SizedBox.shrink(),

                                  // Lifts
                                  (propertyDetails?.liftAvailability?.isNotEmpty ?? false) ?  PropertyDetailRow(
                                    label: "Lifts",
                                    value: propertyDetails?.liftAvailability ?? "N/A", image: '',
                                  ) : const SizedBox.shrink(),

                                ],
                              ),
                            ],
                          ),
                        ),
                        boxH10(),

                        const Divider(),
                        boxH10(),
                        Container(
                          key: _detailsKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'More Details',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              boxH10(),
                              Column(
                                children: [

                                  (propertyDetails?.propertyPrice?.toString().isNotEmpty ?? false) ?  PropertyDetailRow(
                                    label: propertyDetails?.propertyCategoryType=="Rent"?"Rent":"Price",
                                    value: '${propertyController.formatIndianPrice(propertyDetails?.rent.toString() ?? '0')} ' ?? "N/A", image: '',
                                  ) : const SizedBox.shrink(),

                                  // Developer
                                  (propertyDetails?.propertyCategoryType == "Rent" &&
                                      propertyDetails?.propertyPrice.toString() != null &&
                                      propertyDetails!.propertyPrice.toString().isNotEmpty)
                                      ? PropertyDetailRow(
                                    label: "Security Deposit",
                                    value: propertyController.formatIndianPrice(propertyDetails?.propertyPrice.toString()??"0"),
                                    image: '',
                                  )
                                      : const SizedBox.shrink(),


                                  // address
                                  (propertyDetails?.address?.isNotEmpty ?? false) ?  PropertyDetailRow(
                                    label: "Address",
                                    //value: propertyDetails?.address ?? "N/A", image: 'assets/address-location.png',
                                    value: propertyDetails?.address ?? "N/A", image: '',
                                  ) : const SizedBox.shrink(),

                                  // Furnishing
                                  (propertyDetails?.furnishedType?.isNotEmpty ?? false) ?  PropertyDetailRow(
                                    label: "Furnishing",
                                    value: propertyDetails?.furnishedType ?? "N/A", image: '',
                                  ) : const SizedBox.shrink(),

                                  // Floor
                                  (propertyDetails?.flooring?.isNotEmpty ?? false) ?  PropertyDetailRow(
                                    label: "Flooring",
                                    value: propertyDetails?.flooring ?? "N/A", image: '',
                                  ) : const SizedBox.shrink(),

                                  (propertyDetails?.bathroom.toString().isNotEmpty ?? false) ?  PropertyDetailRow(
                                    label: "Bathroom Number",
                                    value: propertyDetails?.bathroom.toString() ?? "N/A", image: '',
                                  ) : const SizedBox.shrink(),

                                  (propertyDetails?.ageOfProperty.toString().isNotEmpty ?? false) ?  PropertyDetailRow(
                                    label: "Age of property",
                                    value: "${propertyDetails!.ageOfProperty} Year" ?? "N/A", image: '',
                                  ) : const SizedBox.shrink(),

                                  (propertyDetails?.coveredParking.toString().isNotEmpty ?? false) ?  PropertyDetailRow(
                                    label: "Covered Parking",
                                    value: propertyDetails?.coveredParking.toString() ?? "N/A", image: '',
                                  ) : const SizedBox.shrink(),

                                  (propertyDetails?.uncoveredParking.toString().isNotEmpty ?? false) ?  PropertyDetailRow(
                                    label: "Uncovered Parking",
                                    value: propertyDetails?.uncoveredParking.toString() ?? "N/A", image: '',
                                  ) : const SizedBox.shrink(),

                                  (propertyDetails?.balcony.toString().isNotEmpty ?? false) ?  PropertyDetailRow(
                                    label: "Balcony",
                                    value: propertyDetails?.balcony.toString() ?? "N/A", image: '',
                                  ) : const SizedBox.shrink(),

                                  (propertyDetails?.powerBackup.toString().isNotEmpty ?? false) ?  PropertyDetailRow(
                                    label: "Power Backup",
                                    value: propertyDetails?.powerBackup.toString() ?? "N/A", image: '',
                                  ) : const SizedBox.shrink(),

                                  (propertyDetails?.view.toString().isNotEmpty ?? false) ?  PropertyDetailRow(
                                    label: "View",
                                    value: propertyDetails?.view.toString() ?? "N/A", image: '',
                                  ) : const SizedBox.shrink(),

                                  (propertyDetails?.waterSource != null && propertyDetails!.waterSource.toString().trim().isNotEmpty)
                                      ? PropertyDetailRow(
                                    label: "Water Source",
                                    value: propertyDetails!.waterSource.toString(),
                                    image: '',
                                  )
                                      : const SizedBox.shrink(),


                                  (propertyDetails?.additionalRooms.toString().isNotEmpty ?? false) ?  PropertyDetailRow(
                                    label: "Additional Rooms",
                                    value: propertyDetails?.additionalRooms.toString() ?? "N/A", image: '',
                                  ) : const SizedBox.shrink(),

                                  (propertyDetails?.additionalRooms.toString().isNotEmpty ?? false) ?  PropertyDetailRow(
                                    label: "Lift Availability",
                                    value: propertyDetails?.liftAvailability.toString() ?? "N/A", image: '',
                                  ) : const SizedBox.shrink(),

                                  (propertyDetails?.loanAvailability.toString().isNotEmpty ?? false) ?  PropertyDetailRow(
                                    label: "Loan Availability",
                                    value: propertyDetails?.loanAvailability.toString() ?? "N/A", image: '',
                                  ) : const SizedBox.shrink(),

                                  (propertyDetails?.loanAvailability.toString().isNotEmpty ?? false) ?  PropertyDetailRow(
                                    label: "Loan Availability",
                                    value: propertyDetails?.loanAvailability.toString() ?? "N/A", image: '',
                                  ) : const SizedBox.shrink(),


                                  (propertyDetails?.pantry.toString().isNotEmpty ?? false) ?  PropertyDetailRow(
                                    label: "Pantry",
                                    value: propertyDetails?.pantry.toString() ?? "N/A", image: '',
                                  ) : const SizedBox.shrink(),


                                  (propertyDetails?.personalWashroom.toString().isNotEmpty ?? false) ?  PropertyDetailRow(
                                    label: "Personal Washroom",
                                    value: propertyDetails?.personalWashroom.toString() ?? "N/A", image: '',
                                  ) : const SizedBox.shrink(),

                                  (propertyDetails?.ceilingHeight.toString().isNotEmpty ?? false) ?  PropertyDetailRow(
                                    label: "Ceiling Height",
                                    value: propertyDetails?.ceilingHeight.toString() ?? "N/A", image: '',
                                  ) : const SizedBox.shrink(),


                                  (propertyDetails?.parkingAvailability.toString().isNotEmpty ?? false) ?  PropertyDetailRow(
                                    label: "Parking Availability",
                                    value: propertyDetails?.parkingAvailability.toString() ?? "N/A", image: '',
                                  ) : const SizedBox.shrink(),


                                  (propertyDetails?.parkingAvailability.toString().isNotEmpty ?? false) ?  PropertyDetailRow(
                                    label: "Parking Availability",
                                    value: propertyDetails?.parkingAvailability.toString() ?? "N/A", image: '',
                                  ) : const SizedBox.shrink(),

                                  (propertyDetails?.seatType.toString().isNotEmpty ?? false) ?  PropertyDetailRow(
                                    label: "Seat Type",
                                    value: propertyDetails?.seatType.toString() ?? "N/A", image: '',
                                  ) : const SizedBox.shrink(),


                                  (propertyDetails?.numberOfSeatsAvailable.toString().isNotEmpty ?? false) ?  PropertyDetailRow(
                                    label: "Number of Seats Available",
                                    value: propertyDetails?.numberOfSeatsAvailable.toString() ?? "N/A", image: '',
                                  ) : const SizedBox.shrink(),



                                  (propertyDetails?.availableFor.toString().isNotEmpty ?? false) ?  PropertyDetailRow(
                                    label: "Available For",
                                    value: propertyDetails?.availableFor.toString() ?? "N/A", image: '',
                                  ) : const SizedBox.shrink(),

                                  (propertyDetails?.suitedFor.toString().isNotEmpty ?? false) ?  PropertyDetailRow(
                                    label: "Suited For",
                                    value: propertyDetails?.suitedFor.toString() ?? "N/A", image: '',
                                  ) : const SizedBox.shrink(),


                                  (propertyDetails?.roomType.toString().isNotEmpty ?? false) ?  PropertyDetailRow(
                                    label: "Room Type",
                                    value: propertyDetails?.roomType.toString() ?? "N/A", image: '',
                                  ) : const SizedBox.shrink(),

                                  (propertyDetails?.foodAvailable.toString().isNotEmpty ?? false) ?  PropertyDetailRow(
                                    label: "Food Available",
                                    value: propertyDetails?.foodAvailable.toString() ?? "N/A", image: '',
                                  ) : const SizedBox.shrink(),


                                  (propertyDetails?.foodChargesIncluded.toString().isNotEmpty ?? false) ?  PropertyDetailRow(
                                    label: "Food Charges Included",
                                    value: propertyDetails?.foodChargesIncluded.toString() ?? "N/A", image: '',
                                  ) : const SizedBox.shrink(),

                                  (propertyDetails?.noticePeriod.toString().isNotEmpty ?? false) ?  PropertyDetailRow(
                                    label: "Notice Period",
                                    value: propertyDetails?.noticePeriod.toString() ?? "N/A", image: '',
                                  ) : const SizedBox.shrink(),


                                  (propertyDetails?.noticePeriodOtherDays != null && propertyDetails!.noticePeriodOtherDays.toString().trim().isNotEmpty)
                                      ? PropertyDetailRow(
                                    label: "Notice Period Other Days",
                                    value: propertyDetails!.noticePeriodOtherDays.toString(),
                                    image: '',
                                  )
                                      : const SizedBox.shrink(),

                                  (propertyDetails?.electricityChargesIncluded != null && propertyDetails!.electricityChargesIncluded.toString().trim().isNotEmpty)
                                      ? PropertyDetailRow(
                                    label: "Electricity Charges Included",
                                    value: propertyDetails!.electricityChargesIncluded.toString(),
                                    image: '',
                                  )
                                      : const SizedBox.shrink(),

                                  (propertyDetails?.totalBeds != null && propertyDetails!.totalBeds.toString().trim().isNotEmpty)
                                      ? PropertyDetailRow(
                                    label: "Total Beds",
                                    value: propertyDetails!.totalBeds.toString(),
                                    image: '',
                                  )
                                      : const SizedBox.shrink(),

                                  (propertyDetails?.pgRules != null && propertyDetails!.pgRules.toString().trim().isNotEmpty)
                                      ? PropertyDetailRow(
                                    label: "PG Rules",
                                    value: propertyDetails!.pgRules.toString(),
                                    image: '',
                                  )
                                      : const SizedBox.shrink(),

                                  (propertyDetails?.pgRules != null && propertyDetails!.pgRules.toString().trim().isNotEmpty)
                                      ? PropertyDetailRow(
                                    label: "PG Rules",
                                    value: propertyDetails!.pgRules.toString(),
                                    image: '',
                                  )
                                      : const SizedBox.shrink(),


                                  (propertyDetails?.gateClosingTime != null && propertyDetails!.gateClosingTime.toString().trim().isNotEmpty)
                                      ? PropertyDetailRow(
                                    label: "Gate Closing Time",
                                    value: propertyDetails!.gateClosingTime.toString(),
                                    image: '',
                                  )
                                      : const SizedBox.shrink(),

                                  (propertyDetails?.pgServices != null && propertyDetails!.pgServices.toString().trim().isNotEmpty)
                                      ? PropertyDetailRow(
                                    label: "PG Services",
                                    value: propertyDetails!.pgServices.toString(),
                                    image: '',
                                  )
                                      : const SizedBox.shrink(),



                                  (propertyDetails?.minLockinPeriod != null && propertyDetails!.minLockinPeriod.toString().trim().isNotEmpty)
                                      ? PropertyDetailRow(
                                    label: "Minimum Lock-in period preferred",
                                    value: propertyDetails!.minLockinPeriod.toString(),
                                    image: '',
                                  )
                                      : const SizedBox.shrink(),






                                ],
                              ),
                            ],
                          ),
                        ),
                        boxH20(),

                        const Divider(thickness: 0.2, color: Colors.grey),

                        /// Amenities
                        Container(
                          key: _amenitiesKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (propertyAmenities != null && propertyAmenities!.isNotEmpty)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.symmetric(vertical: 8),
                                      child: Text(
                                        'Amenities',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Container(
                                      width: _width,
                                      padding: const EdgeInsets.all(8),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // First column (left side)
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: _buildAmenitiesList(
                                                propertyAmenities!.sublist(0, (propertyAmenities!.length / 2).ceil()),
                                              ),
                                            ),
                                          ),
                                          // Second column (right side)
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: _buildAmenitiesList(
                                                propertyAmenities!.sublist((propertyAmenities!.length / 2).ceil()),
                                              ),
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

                        boxH20(),
                        const Divider(thickness: 0.2, color: Colors.grey),
                        Container(
                          key: _aboutKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: Text(
                                  'About Property',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              boxH10(),
                              Text(propertyDetails?.propertyDescription ?? "N/A"),
                            ],
                          ),
                        ),
                        boxH30(),
                        const Divider(thickness: 0.2, color: Colors.grey),

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
                                  child: GoogleMap(
                                    initialCameraPosition: CameraPosition(
                                      target: LatLng(
                                        getLatitude(propertyDetails?.latitude),
                                        getLongitude(propertyDetails?.longitude),
                                      ),
                                      zoom: 15, // Focus closer on property location
                                    ),
                                    onMapCreated: (GoogleMapController controller) {
                                      mapController = controller;
                                    },
                                    markers: {
                                      Marker(
                                        markerId: const MarkerId('property_location'),
                                        position: LatLng(
                                          getLatitude(propertyDetails?.latitude),
                                          getLongitude(propertyDetails?.longitude),
                                        ),
                                        infoWindow: const InfoWindow(title: 'Property Location'),
                                      ),
                                    },
                                    zoomGesturesEnabled: true,       // ✅ Enable pinch zoom
                                    scrollGesturesEnabled: true,     // ✅ Enable scrolling/panning
                                    rotateGesturesEnabled: true,     // Optional
                                    tiltGesturesEnabled: true,       // Optional
                                    zoomControlsEnabled: true,      // Optional: show on-screen zoom buttons
                                    myLocationButtonEnabled: false,  // Optional
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ),
                        boxH20(),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey.withOpacity(0.4)),
                              borderRadius: BorderRadius.circular(18)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //   crossAxisAlignment: CrossAxisAlignment.center,
                                //   children: [
                                //     /// Left Side: Avatar + Name + Agent Label
                                //     Row(
                                //       children: [
                                //
                                //         GestureDetector(
                                //           onTap: () {
                                //             Get.to(agent_profile(
                                //               agent_name: propertyDetails?.connectToName ?? "",
                                //               agent_id: propertyDetails?.userId ?? "",
                                //             ));
                                //           },
                                //           child: CircleAvatar(
                                //
                                //             radius: 24,
                                //             backgroundImage: (user_data != null &&
                                //                 user_data!.isNotEmpty &&
                                //                 user_data![0].profileImage != null &&
                                //                 user_data![0].profileImage.toString().isNotEmpty)
                                //                 ? CachedNetworkImageProvider(
                                //               user_data![0].profileImage.toString(),
                                //             )
                                //                 : null,
                                //             backgroundColor: AppColor.grey.withOpacity(0.1),
                                //             child: (user_data == null ||
                                //                 user_data!.isEmpty ||
                                //                 user_data![0].profileImage == null ||
                                //                 user_data![0].profileImage.toString().isEmpty)
                                //                 ? ClipOval(
                                //               child: Image.asset(
                                //                 'assets/image_rent/profile.png',
                                //                 width: 30,
                                //                 height: 30,
                                //                 fit: BoxFit.cover,
                                //               ),
                                //             )
                                //                 : null,
                                //           ),
                                //         ),
                                //
                                //         boxW08(),
                                //         Column(
                                //           crossAxisAlignment: CrossAxisAlignment.start,
                                //           children: [
                                //             Text(
                                //                 //userDetails?[0].fullName ?? "",
                                //                "Rajesh kumar santosh Shrama",
                                //                 style: const TextStyle(
                                //                   fontWeight: FontWeight.bold,
                                //                   fontSize: 16.0,
                                //                   color: Colors.black,
                                //
                                //                   overflow: TextOverflow.ellipsis
                                //                 )),
                                //             Text(
                                //               userDetails?[0].userType ?? "",
                                //               style: const TextStyle(
                                //                 fontSize: 14.0,
                                //               ),
                                //             ),
                                //           ],
                                //         ),
                                //       ],
                                //     ),
                                //
                                //     /// Spacer pushes the button to the right
                                //     Spacer(),
                                //
                                //     /// Right Side: Custom Button
                                //     commonButton(
                                //       width: _width * 0.4,
                                //       buttonColor: AppColor.primaryThemeColor,
                                //       text: 'Contact Details',
                                //       textStyle:
                                //       const TextStyle(fontSize: 14, color: Colors.white),
                                //       onPressed: () {
                                //         _showSendInquiryBottomSheet(context);
                                //       },
                                //     ),
                                //   ],
                                // ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    /// Left Side: Avatar + Name + Agent Label
                                    Expanded(
                                      child: Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Get.to(agent_profile(
                                                agent_name: propertyDetails?.connectToName ?? "",
                                                agent_id: propertyDetails?.userId ?? "",
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
                                          /// Wrap text here using Expanded or Flexible
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  userDetails?[0].fullName ?? "",
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16.0,
                                                    color: Colors.black,
                                                  ),
                                                  maxLines: 2, // Allow 2 lines
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  userDetails?[0].userType ?? "",
                                                  style: const TextStyle(
                                                    fontSize: 14.0,
                                                  ),
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
                      ],
                    ),
                  ),
                  boxH50(),
                  boxH50(),
                ],
              ),
            ),
          ),

          // const Positioned(
          //   bottom: 0,
          //   left: 10,
          //   right: 10,
          //   child: CustomBottomNavBar(),
          // ),
        ],
      ),

    );
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
            key: _formKey,
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
                  hintText: 'Number',
                  readOnly: true,
                  keyboardType: TextInputType.number,

                ),
                boxH10(),
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
                commonButton(text: 'Send Enquiry', onPressed: () {
                  print("enquiry_bhk_type");
                  if(_formKey.currentState!.validate()){
                    search_controller.addPropertyEnquiry(property_id: propertyDetails?.id ,
                        name: nameController.text,
                        message: msgController.text,
                        number: phoneController.text,owner_id: propertyDetails?.userId,enquiry_bhk_type:propertyDetails?.bhkType)
                        .then((value){
                      nameController.clear();
                      msgController.clear();
                    });
                  }
                },
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
  Future<void> _launchURL() async {
    final uri = Uri.parse(propertyDetails?.videoUrl ?? '');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch ';
    }
  }
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
      if(freeViewCount >= 0){
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
                    Get.to(const PlansAndSubscription(isfrom: '',))?.then((value) async {
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


  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        DateTime selectedDate = DateTime.now();
        DateTime today = DateTime.now();
        tour_schedule_date = DateFormat('yyyy-MM-dd').format(selectedDate);
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.5,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Schedule Virtual Tour",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: Text(
                        "Schedule Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}",
                      ),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: today,
                          lastDate: today.add(const Duration(days: 7)),
                        );

                        if (pickedDate != null) {
                          setState(() {
                            selectedDate = pickedDate;
                            tour_schedule_date =
                                DateFormat('yyyy-MM-dd').format(selectedDate);
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Available Time Slots",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child:ListView.builder(
                        itemCount: profileController.owner_timeSlots.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(profileController
                                .owner_timeSlots[index]['timeslot']),
                            onTap: () {
                              Navigator.pop(context, {
                                'date': selectedDate,
                                'timeSlot': profileController
                                    .owner_timeSlots[index]['timeslot'],
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).then((value) {
      if (value != null) {
        final selectedDate = value['date'];
        final selectedTimeSlot = value['timeSlot'];
        propertyController.add_virtual_tour(
            property_owner_id: propertyDetails?.userId,
            schedule_date: tour_schedule_date,
            timeslot: selectedTimeSlot,
            channel_name: channelID,
            property_id: widget.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Scheduled on ${DateFormat('yyyy-MM-dd').format(selectedDate)} at $selectedTimeSlot",
            ),
          ),
        );
      }
    });
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

  void viewPhone(context, String name, String contact_number, String email_id,
      String owner_type, String property_id, String owner_id,String enquiry_bhk_type) async {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    showModalBottomSheet<void>(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return GetBuilder<ProfileController>(
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
                                "You Contacted",
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.person_outline,
                                    size: 20, color: Colors.blue.shade900),
                                boxW10(),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '${name ?? "Unknown"} ',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15.0,
                                          color: Colors.black,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '(${owner_type ?? "Unknown"})',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15.0,
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
                              children: [
                                CircleAvatar(
                                  radius: 12,
                                  backgroundColor:
                                  Colors.green.withOpacity(0.1),
                                  child: Icon(Icons.phone,
                                      color: Colors.blue.shade900, size: 18),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  // Add Expanded here
                                  child: Text(
                                    contact_number ?? "Unknown",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.blueGrey,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 80,
                                  child: GestureDetector(
                                    onTap: () {
                                      _makePhoneCall(contact_number);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4, horizontal: 16),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade900,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          "Call",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            boxH10(),
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 12,
                                  backgroundColor:
                                  Colors.green.withOpacity(0.1),
                                  child: Icon(Icons.email,
                                      color: Colors.blue.shade900, size: 18),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    email_id,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.blueGrey,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 80,
                                  child: GestureDetector(
                                    onTap: () async {
                                      final email = email_id;
                                      final Uri emailLaunchUri = Uri(
                                        scheme: 'mailto',
                                        path: email,
                                        query: encodeQueryParameters({
                                          // 'subject': 'Revert Back to your Enquiry',
                                          // 'body': '${'Hello '+lead['name']},',
                                          'subject': 'Response to Your Inquiry',
                                          'body': '${'Hello $name'},',
                                        }),
                                      );
                                      if (await canLaunch(
                                          emailLaunchUri.toString())) {
                                        await launch(emailLaunchUri.toString());
                                      } else {
                                        print(
                                            'Could not launch $emailLaunchUri');
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4, horizontal: 14),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade900,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          "Email",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            boxH10(),
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 12,
                                  backgroundColor:
                                  Colors.green.withOpacity(0.1),
                                  child: Icon(Icons.headset_mic_outlined,
                                      color: Colors.blue.shade900, size: 18),
                                ),
                                const SizedBox(width: 12),
                                const Expanded(
                                  child: Text(
                                    'Enquiry',
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.blueGrey,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 80,
                                  child: GestureDetector(
                                    onTap: () async {
                                      Navigator.pop(context);
                                      addEnquiry(
                                          context, property_id, owner_id,enquiry_bhk_type);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4, horizontal: 14),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade900,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          "Add",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
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
              ),
            );
          },
        );
      },
    );
  }
  void showVideoPreview(String videoPath) {
    Get.dialog(
      Dialog(
        child: Container(
          height: Get.height * 0.5,
          decoration: BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.circular(10)
          ),
          child: Column(
            children: [
              Expanded(
                child: VideoPlayerWidget(
                  videoPath: videoPath,
                  autoPlay: true,
                ),
              ),
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('Close'),
              ),
            ],
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


  void addEnquiry(BuildContext context, String propertyId, String ownerId,String enquiry_bhk_type) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController messageController = TextEditingController();

    showModalBottomSheet<void>(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return CommonBottomSheet(
          title: 'Add Enquiry',
          formKey: formKey,
          messageController: messageController,
          submitButtonText: 'Send Enquiry',
          onSubmit: () {
            search_controller
                .addPropertyEnquiry(
                property_id: propertyId,
                owner_id: ownerId,
                message: messageController.text,
                enquiry_bhk_type: enquiry_bhk_type)
                .then((value) {
              Navigator.of(context).pop();
            });
          },
        );
      },
    );
  }

  _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) =>
    '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
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
}


class FullScreenImageView extends StatelessWidget {
  final String imageUrl;

  const FullScreenImageView({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: PhotoView(
          imageProvider: NetworkImage(imageUrl),
          backgroundDecoration: const BoxDecoration(color: Colors.black),
          loadingBuilder: (context, event) => const Center(
            child: CircularProgressIndicator(),
          ),
          errorBuilder: (context, error, stackTrace) => const Center(
            child: Icon(Icons.error, color: Colors.white, size: 50),
          ),
        ),
      ),
    );
  }
}
