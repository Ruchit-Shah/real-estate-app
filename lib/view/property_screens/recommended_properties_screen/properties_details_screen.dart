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
import 'package:real_estate_app/view/property_screens/recommended_properties_screen/propertyCard.dart';
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

  const PropertyDetailsScreen({super.key, required this.id});

  @override
  State<PropertyDetailsScreen> createState() => _PropertyDetailsScreenState();
}

class _PropertyDetailsScreenState extends State<PropertyDetailsScreen> {
  final PageController _controller = PageController(initialPage: 0);
  GoogleMapController? mapController;
  final ProfileController profileController = Get.find();
  final PostPropertyController propertyController = Get.find();
  final SubscriptionController planController = Get.find();
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
  late TextEditingController phoneController;

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


  late int freeViewCount;
  late int paidViewCount;
  List<String> getOverviewFields({
    required String propertyType,
    required String listingType, // Sale or Rent
  }) {
    propertyType = propertyType.toLowerCase();
    listingType = listingType.toLowerCase();

    if ([
      'apartment',
      'villa',
      'builder floor',
      'penthouse',
      'independent house'
    ].contains(propertyType)) {
      return [
        'availabilityStatus',
        'propertyAddedDate',
        'propertyName',
        'address',
        'area',
        'priceRent',
        'listingType',
        'buildingType',
        'propertyType',
        'bhk',
        'furnishingStatus',
        'possessionStatus',
      ];
    }

    if ([
      'office space',
      'shop',
      'office space it/sez',
      'showroom',
      'co-working space'
    ].contains(propertyType)) {
      return [
        'availabilityStatus',
        'propertyAddedDate',
        'propertyName',
        'address',
        'area',
        'priceRent',
        'listingType',
        'buildingType',
        'propertyType',
        'furnishingStatus',
        'possessionStatus',
      ];
    }

    if (propertyType == 'warehouse') {
      return [
        'availabilityStatus',
        'propertyAddedDate',
        'propertyName',
        'address',
        'area',
        'priceRent',
        'listingType',
        'buildingType',
        'propertyType',
        'possessionStatus',
      ];
    }

    if ([
      'plot',
      'land',
      'industrial plot'
    ].contains(propertyType)) {
      return [
        'availabilityStatus',
        'propertyAddedDate',
        'propertyName',
        'address',
        'area',
        'priceRent',
        'listingType',
        'buildingType',
        'propertyType',
      ];
    }

    if (propertyType == 'pg') {
      return [
        'availabilityStatus',
        'propertyAddedDate',
        'propertyName',
        'address',
        'area',
        'priceRent',
        'listingType',
        'buildingType',
        'propertyType',
        'furnishingStatus',
        'availableFrom',
        'availableFor',
        'suitedFor',
        'roomType',
        'foodChargesIncluded',
      ];
    }

    return [];
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    channelID = uuid.v4();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();
      getDetails();
      if (isLogin == true) {
// search_controller.addView(property_id: widget.id);
      }
    });
    phoneController = TextEditingController(text: profileController.mobile.value);

    print('Property images fetched: ${propertyController.getPropertyImageList}');
  }

  bool isVideo(String url) {
    if (url.isEmpty) return false;
    final uri = Uri.tryParse(url);
    final path = uri?.path ?? '';
    return path.toLowerCase().endsWith('.mp4') ||
        path.toLowerCase().endsWith('.mov') ||
        path.toLowerCase().endsWith('.webm') ||
        path.toLowerCase().endsWith('.avi');
  }
  bool isValidString(String? value) {
    return value != null && value.trim().isNotEmpty && value.trim() != '0';
  }
  getDetails() async {
    try {
      await search_controller.getPropertyDetails(property_id: widget.id);
      if (search_controller.propertyDetails.value.data != null) {
        await search_controller.addView(
            owner_id: search_controller.propertyDetails.value.data?.propertyDetails?.userId,
            property_id: search_controller.propertyDetails.value.data?.propertyDetails?.id);
        setState(() {
          propertyDetails = search_controller.propertyDetails.value.data?.propertyDetails;
          userDetails = search_controller.propertyDetails.value.data?.userDetails;
          propertyAmenities = search_controller.propertyDetails.value.data?.amenities ?? [];
          propertyImages = search_controller.propertyDetails.value.data?.propertyImages ?? [];
          user_data = search_controller.propertyDetails.value.data?.userDetails ?? [];
          projectTourSchedules = search_controller.propertyDetails.value.data?.tourSchedule ?? [];
          print('tour : ${projectTourSchedules?.length}');
          if (propertyDetails?.propertyVideo != null && propertyDetails!.propertyVideo!.isNotEmpty) {
            propertyImages?.add(PropertyImages(id: '1212', image: propertyDetails!.propertyVideo));
          }
          if (propertyImages != null && propertyImages!.isNotEmpty) {
            mediaUrls.addAll(propertyImages!.map((e) => e.image ?? '').where((url) => url.isNotEmpty));
          }
          if (mediaUrls.isEmpty && (propertyDetails?.coverImage?.isNotEmpty ?? false)) {
            mediaUrls.add(propertyDetails!.coverImage!);
          }
          if ((propertyDetails?.videoUrl?.isNotEmpty ?? false)) {
            final videoUrl = propertyDetails!.videoUrl!;
            if (isVideo(videoUrl)) {
              mediaUrls.add(videoUrl);
            }
          }
        });
      }
    } catch (e) {
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
      DateTime inputDate = DateTime.parse(dateString);
      DateTime now = DateTime.now();
      DateTime today = DateTime(now.year, now.month, now.day);
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
    isContact = (await SPManager.instance.getContactDetails(ContactDetails)) ?? "no";
    count = (await SPManager.instance.getFreeViewCount(FREE_VIEW)) ?? 0;
    freeViewCount = await SPManager.instance.getFreeViewCount(FREE_VIEW) ?? 0;
    paidViewCount = await SPManager.instance.getPaidViewCount(PAID_VIEW) ?? 0;
    print('view count ===>');
    print("freeViewCount==>$freeViewCount");
    print("paidViewCount==>$paidViewCount");
    setState(() {});
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
    final RenderBox? renderBox = key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return 0.0;
    return renderBox.localToGlobal(Offset.zero).dy;
  }

// Define a mapping of property types to their respective fields
  static const Map<String, List<Map<String, String>>> propertyFieldsMap = {
    // ------------- RESIDENTIAL (Sale + Rent) -------------
    'Apartment': [
      {'label': 'Additional Rooms', 'field': 'additionalRooms'},
      {'label': 'Age of Property (Years)', 'field': 'ageOfProperty'},
      {'label': 'Number of Bathroom', 'field': 'bathroom'},
      {'label': 'Covered Parking', 'field': 'coveredParking'},
      {'label': 'Open/Uncovered Parking', 'field': 'uncoveredParking'},
      {'label': 'Balcony', 'field': 'balcony'},
      {'label': 'Power Back-up', 'field': 'powerBackup'},
      {'label': 'Lift Availability', 'field': 'liftAvailability'},
      {'label': 'Water Source', 'field': 'waterSource'},
      {'label': 'Facing', 'field': 'facing'},
      {'label': 'View', 'field': 'view'},
      {'label': 'Flooring', 'field': 'flooring'},
      {'label': 'Floor Number', 'field': 'propertyFloor'},
      {'label': 'Tower/Block', 'field': 'block'},
      {'label': 'Total Floor Count', 'field': 'totalFloor'},
      {'label': 'Unit No', 'field': 'units'},
    ],
    'Villa': [
      {'label': 'Additional Rooms', 'field': 'additionalRooms'},
      {'label': 'Age of Property (Years)', 'field': 'ageOfProperty'},
      {'label': 'Number of Bathroom', 'field': 'bathroom'},
      {'label': 'Covered Parking', 'field': 'coveredParking'},
      {'label': 'Open/Uncovered Parking', 'field': 'uncoveredParking'},
      {'label': 'Balcony', 'field': 'balcony'},
      {'label': 'Power Back-up', 'field': 'powerBackup'},
      {'label': 'Lift Availability', 'field': 'liftAvailability'},
      {'label': 'Water Source', 'field': 'waterSource'},
      {'label': 'Facing', 'field': 'facing'},
      {'label': 'View', 'field': 'view'},
      {'label': 'Flooring', 'field': 'flooring'},
      {'label': 'Floor Number', 'field': 'propertyFloor'},
      {'label': 'Tower/Block', 'field': 'block'},
      {'label': 'Total Floor Count', 'field': 'totalFloor'},
      {'label': 'Unit No', 'field': 'units'},
    ],
    'Builder Floor': [
      {'label': 'Additional Rooms', 'field': 'additionalRooms'},
      {'label': 'Age of Property (Years)', 'field': 'ageOfProperty'},
      {'label': 'Number of Bathroom', 'field': 'bathroom'},
      {'label': 'Covered Parking', 'field': 'coveredParking'},
      {'label': 'Open/Uncovered Parking', 'field': 'uncoveredParking'},
      {'label': 'Balcony', 'field': 'balcony'},
      {'label': 'Power Back-up', 'field': 'powerBackup'},
      {'label': 'Lift Availability', 'field': 'liftAvailability'},
      {'label': 'Water Source', 'field': 'waterSource'},
      {'label': 'Facing', 'field': 'facing'},
      {'label': 'View', 'field': 'view'},
      {'label': 'Flooring', 'field': 'flooring'},
      {'label': 'Floor Number', 'field': 'propertyFloor'},
      {'label': 'Tower/Block', 'field': 'block'},
      {'label': 'Total Floor Count', 'field': 'totalFloor'},
      {'label': 'Unit No', 'field': 'units'},
    ],
    'Penthouse': [
      {'label': 'Additional Rooms', 'field': 'additionalRooms'},
      {'label': 'Age of Property (Years)', 'field': 'ageOfProperty'},
      {'label': 'Number of Bathroom', 'field': 'bathroom'},
      {'label': 'Covered Parking', 'field': 'coveredParking'},
      {'label': 'Open/Uncovered Parking', 'field': 'uncoveredParking'},
      {'label': 'Balcony', 'field': 'balcony'},
      {'label': 'Power Back-up', 'field': 'powerBackup'},
      {'label': 'Lift Availability', 'field': 'liftAvailability'},
      {'label': 'Water Source', 'field': 'waterSource'},
      {'label': 'Facing', 'field': 'facing'},
      {'label': 'View', 'field': 'view'},
      {'label': 'Flooring', 'field': 'flooring'},
      {'label': 'Floor Number', 'field': 'propertyFloor'},
      {'label': 'Tower/Block', 'field': 'block'},
      {'label': 'Total Floor Count', 'field': 'totalFloor'},
      {'label': 'Unit No', 'field': 'units'},
    ],
    'Independent House': [
      {'label': 'Additional Rooms', 'field': 'additionalRooms'},
      {'label': 'Age of Property (Years)', 'field': 'ageOfProperty'},
      {'label': 'Number of Bathroom', 'field': 'bathroom'},
      {'label': 'Covered Parking', 'field': 'coveredParking'},
      {'label': 'Open/Uncovered Parking', 'field': 'uncoveredParking'},
      {'label': 'Balcony', 'field': 'balcony'},
      {'label': 'Power Back-up', 'field': 'powerBackup'},
      {'label': 'Lift Availability', 'field': 'liftAvailability'},
      {'label': 'Water Source', 'field': 'waterSource'},
      {'label': 'Facing', 'field': 'facing'},
      {'label': 'View', 'field': 'view'},
      {'label': 'Flooring', 'field': 'flooring'},
      {'label': 'Floor Number', 'field': 'propertyFloor'},
      {'label': 'Tower/Block', 'field': 'block'},
      {'label': 'Total Floor Count', 'field': 'totalFloor'},
      {'label': 'Unit No', 'field': 'units'},
    ],

    // ------------- PLOT / LAND / INDUSTRIAL PLOT (Sale + Rent) -------------
    'Plot': [
      {'label': 'Facing', 'field': 'facing'},
      {'label': 'View', 'field': 'view'},
      {'label': 'Plot No', 'field': 'plotNo'},
      {'label': 'Loan Available', 'field': 'loanAvailability'},
    ],
    'Land': [
      {'label': 'Facing', 'field': 'facing'},
      {'label': 'View', 'field': 'view'},
      {'label': 'Plot No', 'field': 'plotNo'},
      {'label': 'Loan Available', 'field': 'loanAvailability'},
    ],
    'Industrial Plot': [
      {'label': 'Facing', 'field': 'facing'},
      {'label': 'View', 'field': 'view'},
      {'label': 'Plot No', 'field': 'plotNo'},
      {'label': 'Loan Available', 'field': 'loanAvailability'},
    ],

    // ------------- PG (Rent Only) -------------
    'PG': [
      {'label': 'Food Available', 'field': 'foodAvailable'},
      {'label': 'Notice Period (Days)', 'field': 'noticePeriod'},
      {'label': 'Operating Since (Years)', 'field': 'ageOfProperty'},
      {'label': 'Electricity Charges Included', 'field': 'electricityChargesIncluded'},
      {'label': 'Parking Available', 'field': 'parkingAvailability'},
      {'label': 'Total Number of Beds', 'field': 'totalBeds'},
      {'label': 'PG/Hostel Rules', 'field': 'pgRules'},
      {'label': 'Gate Closing Time', 'field': 'gateClosingTime'},
      {'label': 'Available PG Services', 'field': 'pgServices'},
      {'label': 'Age of Property (Years)', 'field': 'ageOfProperty'},
      {'label': 'Number of Bathroom', 'field': 'bathroom'},
      {'label': 'Balcony', 'field': 'balcony'},
      {'label': 'Power Back-up', 'field': 'powerBackup'},
      {'label': 'Water Source', 'field': 'waterSource'},
      {'label': 'Facing', 'field': 'facing'},
      {'label': 'View', 'field': 'view'},
      {'label': 'Flooring', 'field': 'flooring'},
    ],

    // ------------- OFFICE SPACES (Sale + Rent) -------------
    'Office Space': [
      {'label': 'Age of Property (Years)', 'field': 'ageOfProperty'},
      {'label': 'Office Space Type', 'field': 'officeSpaceType'},
      {'label': 'Pantry', 'field': 'pantry'},
      {'label': 'Personal Washroom', 'field': 'personalWashroom'},
      {'label': 'Covered Parking', 'field': 'coveredParking'},
      {'label': 'Open/Uncovered Parking', 'field': 'uncoveredParking'},
      {'label': 'Balcony', 'field': 'balcony'},
      {'label': 'Power Back-up', 'field': 'powerBackup'},
      {'label': 'Lift Availability', 'field': 'liftAvailability'},
      {'label': 'View', 'field': 'view'},
      {'label': 'Flooring', 'field': 'flooring'},
      {'label': 'Tower/Block', 'field': 'block'},
      {'label': 'Floor Number', 'field': 'propertyFloor'},
    ],
    'Office Space IT/SEZ': [
      {'label': 'Age of Property (Years)', 'field': 'ageOfProperty'},
      {'label': 'Office Space Type', 'field': 'officeSpaceType'},
      {'label': 'Pantry', 'field': 'pantry'},
      {'label': 'Personal Washroom', 'field': 'personalWashroom'},
      {'label': 'Covered Parking', 'field': 'coveredParking'},
      {'label': 'Open/Uncovered Parking', 'field': 'uncoveredParking'},
      {'label': 'Balcony', 'field': 'balcony'},
      {'label': 'Power Back-up', 'field': 'powerBackup'},
      {'label': 'Lift Availability', 'field': 'liftAvailability'},
      {'label': 'View', 'field': 'view'},
      {'label': 'Flooring', 'field': 'flooring'},
      {'label': 'Tower/Block', 'field': 'block'},
      {'label': 'Floor Number', 'field': 'propertyFloor'},
    ],

    // ------------- WAREHOUSE -------------
    'Warehouse': [
      {'label': 'Age of Property (Years)', 'field': 'ageOfProperty'},
      {'label': 'Personal Washroom', 'field': 'personalWashroom'},
      {'label': 'Covered Parking', 'field': 'coveredParking'},
      {'label': 'Open/Uncovered Parking', 'field': 'uncoveredParking'},
      {'label': 'Power Back-up', 'field': 'powerBackup'},
      {'label': 'Flooring', 'field': 'flooring'},
    ],

    // ------------- SHOP / SHOWROOM -------------
    'Shop': [
      {'label': 'Age of Property (Years)', 'field': 'ageOfProperty'},
      {'label': 'Pantry', 'field': 'pantry'},
      {'label': 'Personal Washroom', 'field': 'personalWashroom'},
      {'label': 'Covered Parking', 'field': 'coveredParking'},
      {'label': 'Open/Uncovered Parking', 'field': 'uncoveredParking'},
      {'label': 'Power Back-up', 'field': 'powerBackup'},
      {'label': 'Lift Availability', 'field': 'liftAvailability'},
      {'label': 'View', 'field': 'view'},
      {'label': 'Flooring', 'field': 'flooring'},
      {'label': 'Tower/Block', 'field': 'block'},
      {'label': 'Floor Number', 'field': 'propertyFloor'},
      {'label': 'Facing', 'field': 'facing'},
      {'label': 'Ceiling Height', 'field': 'ceilingHeight'},
    ],
    'Showroom': [
      {'label': 'Age of Property (Years)', 'field': 'ageOfProperty'},
      {'label': 'Pantry', 'field': 'pantry'},
      {'label': 'Personal Washroom', 'field': 'personalWashroom'},
      {'label': 'Covered Parking', 'field': 'coveredParking'},
      {'label': 'Open/Uncovered Parking', 'field': 'uncoveredParking'},
      {'label': 'Power Back-up', 'field': 'powerBackup'},
      {'label': 'Lift Availability', 'field': 'liftAvailability'},
      {'label': 'View', 'field': 'view'},
      {'label': 'Flooring', 'field': 'flooring'},
      {'label': 'Tower/Block', 'field': 'block'},
      {'label': 'Floor Number', 'field': 'propertyFloor'},
      {'label': 'Facing', 'field': 'facing'},
      {'label': 'Ceiling Height', 'field': 'ceilingHeight'},
    ],

    // ------------- CO-WORKING SPACE -------------
    'Co-Working Space': [
      {'label': 'Age of Property (Years)', 'field': 'ageOfProperty'},
      {'label': 'Pantry', 'field': 'pantry'},
      {'label': 'Personal Washroom', 'field': 'personalWashroom'},
      {'label': 'Power Back-up', 'field': 'powerBackup'},
      {'label': 'Lift Availability', 'field': 'liftAvailability'},
      {'label': 'View', 'field': 'view'},
      {'label': 'Flooring', 'field': 'flooring'},
      {'label': 'Floor Number', 'field': 'propertyFloor'},
      {'label': 'Parking Available', 'field': 'parkingAvailability'},
      {'label': 'Minimum Lock-in period preferred', 'field': 'minLockinPeriod'},
      {'label': 'Seat Type', 'field': 'seatType'},
      {'label': 'Number of Seats Available', 'field': 'numberOfSeatsAvailable'},
    ],
  };


// Helper method to get field value from propertyDetails
  String getFieldValue(PropertyDetails? propertyDetails, String field) {
    if (propertyDetails == null) {
      print('PropertyDetails is null for field: $field');
      return 'N/A';
    }
    final PostPropertyController propertyController = Get.find();

// Debugging: Print field values
    void logField(String fieldName, dynamic value) {
      print('$fieldName value: $value');
    }

    switch (field) {
      case 'propertyPrice':
        if (propertyDetails.propertyCategoryType == "Rent") {
          logField('Property Price', 'N/A (Rent property)');
          return 'N/A';
        }
        final price = propertyDetails.propertyPrice?.toString() ?? 'N/A';
        logField('Property Price', price);
        return price == 'N/A' ? 'N/A' : propertyController.formatIndianPrice(price);
      case 'rent':
        if (propertyDetails.propertyCategoryType != "Rent") {
          logField('Rent', 'N/A (Not a Rent property)');
          return 'N/A';
        }
        final rent = propertyDetails.rent?.toString() ?? 'N/A';
        logField('Rent', rent);
        return rent == 'N/A' ? 'N/A' : propertyController.formatIndianPrice(rent);
      case 'customDepositAmount':
        if (propertyDetails.propertyCategoryType != "Rent") {
          logField('Security Deposit', 'N/A (Not a Rent property)');
          return 'N/A';
        }
        final deposit =  propertyDetails.propertyPrice?.toString()==null?propertyDetails.customDepositAmount?.toString():  propertyDetails.propertyPrice?.toString()?? 'N/A';
        // propertyDetails.propertyPrice?.toString() ?? 'N/A'
        logField('Security Deposit', deposit);
        return deposit == 'N/A' ? 'N/A' : propertyController.formatIndianPrice(deposit);

      case 'address':
        final address = propertyDetails.address ?? 'N/A';
        logField('Address', address);
        return address;
      case 'furnishedType':
        final furnished = propertyDetails.furnishedType ?? 'N/A';
        logField('Furnishing', furnished);
        return furnished;
      case 'flooring':
        final flooring = propertyDetails.flooring ?? 'N/A';
        logField('Flooring', flooring);
        return flooring;
      case 'bathroom':
        final bathroom = propertyDetails.bathroom?.toString() ?? 'N/A';
        logField('Bathroom Number', bathroom);
        return bathroom;
      case 'ageOfProperty':
        final age = propertyDetails.ageOfProperty ?? 'N/A';
        logField('Age of Property', age);
        return age == 'N/A' || age == "" ? 'N/A' : '$age Year';
      case 'coveredParking':
        final parking = propertyDetails.coveredParking ?? 'N/A';
        logField('Covered Parking', parking);
        return parking;
      case 'uncoveredParking':
        final parking = propertyDetails.uncoveredParking ?? 'N/A';
        logField('Uncovered Parking', parking);
        return parking;
      case 'balcony':
        final balcony = propertyDetails.balcony ?? 'N/A';
        logField('Balcony', balcony);
        return balcony;
      case 'powerBackup':
        final powerBackup = propertyDetails.powerBackup ?? 'N/A';
        logField('Power Backup', powerBackup);
        return powerBackup;
      case 'waterSource':
        final waterSource = propertyDetails.waterSource ?? 'N/A';
        logField('Water Source', waterSource);
        return waterSource;
      case 'facing':
        final facing = propertyDetails.facing ?? 'N/A';
        logField('Facing', facing);
        return facing;
      case 'view':
        final view = propertyDetails.view ?? 'N/A';
        logField('View', view);
        return view;
      case 'availableFor':
        final availableFor = propertyDetails.availableFor ?? 'N/A';
        logField('Available For', availableFor);
        return availableFor;
      case 'suitedFor':
        final suitedFor = propertyDetails.suitedFor ?? 'N/A';
        logField('Suited For', suitedFor);
        return suitedFor;
      case 'roomType':
        final roomType = propertyDetails.roomType ?? 'N/A';
        logField('Room Type', roomType);
        return roomType;
      case 'foodAvailable':
        final foodAvailable = propertyDetails.foodAvailable ?? 'N/A';
        logField('Food Available', foodAvailable);
        return foodAvailable;
      case 'foodChargesIncluded':
        final foodCharges = propertyDetails.foodChargesIncluded ?? 'N/A';
        logField('Food Charges Included', foodCharges);
        return foodCharges;
      case 'noticePeriod':
        final noticePeriod = propertyDetails.noticePeriod ?? 'N/A';
        logField('Notice Period', noticePeriod);
        return noticePeriod;
      case 'noticePeriodOtherDays':
        final noticeDays = propertyDetails.noticePeriodOtherDays?.toString() ?? 'N/A';
        logField('Notice Period Other Days', noticeDays);
        return noticeDays;
      case 'electricityChargesIncluded':
        final electricity = propertyDetails.electricityChargesIncluded ?? 'N/A';
        logField('Electricity Charges Included', electricity);
        return electricity;
      case 'totalBeds':
        final totalBeds = propertyDetails.totalBeds ?? 'N/A';
        logField('Total Beds', totalBeds);
        return totalBeds;
      case 'pgRules':
        final pgRules = propertyDetails.pgRules ?? 'N/A';
        logField('PG Rules', pgRules);
        return pgRules;
      case 'gateClosingTime':
        final gateTime = propertyDetails.gateClosingTime ?? 'N/A';
        logField('Gate Closing Time', gateTime);
        return gateTime;
      case 'pgServices':
        final pgServices = propertyDetails.pgServices ?? 'N/A';
        logField('PG Services', pgServices);
        return pgServices;
      case 'parkingAvailability':
        final parking = propertyDetails.parkingAvailability ?? 'N/A';
        logField('Parking Availability', parking);
        return parking;
      case 'additionalRooms':
        final rooms = propertyDetails.additionalRooms ?? 'N/A';
        logField('Additional Rooms', rooms);
        return rooms;
      // case 'propertyFloor':
      //   final floor = propertyDetails.propertyFloor ?? 'N/A';
      //   final totalFloor = propertyDetails.totalFloor ?? 'N/A';
      //   logField('Property Floor', '$floor (Out of $totalFloor Floors)');
      //  return '$floor (Out of $totalFloor Floors)';

    ///
      // case 'propertyFloor':
      //   final floor = propertyDetails.propertyFloor;
      //   final totalFloor = propertyDetails.totalFloor;
      //
      //   final hasFloor = floor != null && floor.trim().isNotEmpty;
      //   final hasTotalFloor = totalFloor != null && totalFloor.trim().isNotEmpty;
      //
      //   if (!hasFloor && !hasTotalFloor) {
      //     logField('Property Floor', 'N/A');
      //     return 'N/A';
      //   }
      //
      //   final floorText = hasFloor ? floor : 'N/A';
      //   final totalFloorText = hasTotalFloor ? totalFloor : 'N/A';
      //
      //   final result = '$floorText (Out of $totalFloorText Floors)';
      //   logField('Property Floor', result);
      //   return result;
      case 'propertyFloor':
        final floor = propertyDetails.propertyFloor;


        final hasFloor = floor != null && floor.trim().isNotEmpty;


        if (!hasFloor) {
          logField('Property Floor', 'N/A');
          return 'N/A';
        }

        final floorText = hasFloor ? floor : 'N/A';


        final result = floorText;
        logField('Property Floor', result);
        return result;


      case 'block':
        final block = propertyDetails.block ?? 'N/A';
        logField('Tower/Block', block);
        return block;
      case 'totalFloor':
        final totalFloor = propertyDetails.totalFloor ?? 'N/A';
        logField('Total Floor Count', totalFloor);
        return totalFloor;
      case 'units':
        final units = propertyDetails.units;
        if (units == null || units.trim().isEmpty || units == '0') {
          logField('Unit No', 'N/A');
          return 'N/A';
        }
        logField('Unit No', units);
        return units;

      case 'liftAvailability':
        final lift = propertyDetails.liftAvailability ?? 'N/A';
        logField('Lift Availability', lift);
        return lift;
      case 'plotNo':
        final plotNo = propertyDetails.plotNo ?? 'N/A';
        logField('Plot No', plotNo);
        return plotNo;
      case 'loanAvailability':
        final loan = propertyDetails.loanAvailability ?? 'N/A';
        logField('Loan Availability', loan);
        return loan;
      case 'officeSpaceType':
        final officeType = propertyDetails.officeSpaceType ?? 'N/A';
        logField('Office Space Type', officeType);
        return officeType;
      case 'pantry':
        final pantry = propertyDetails.pantry ?? 'N/A';
        logField('Pantry', pantry);
        return pantry;
      case 'personalWashroom':
        final washroom = propertyDetails.personalWashroom ?? 'N/A';
        logField('Personal Washroom', washroom);
        return washroom;
      case 'minLockinPeriod':
        final lockin = propertyDetails.minLockinPeriod ?? 'N/A';
        logField('Min Lock-in Period', lockin);
        return lockin;
      case 'availableFrom':
        final availableFrom = propertyDetails.availableFrom ?? 'N/A';
        logField('availableFrom', availableFrom);
        return availableFrom;

      default:
        print('Unhandled field: $field');
        return 'N/A';
    }
  }


// Build the More Details section dynamically
  Widget _buildDetailsSection() {
    if (propertyDetails == null) {
      return const SizedBox.shrink();
    }

    final propertyType = propertyDetails!.propertyType;

    print("propertyType111==>${propertyDetails!.propertyType}");
    final fields = propertyFieldsMap[propertyType]!;

    return Container(
      key: _detailsKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'More Details',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          boxH10(),
          Column(
            children: fields.map((field) {
              final label = field['label']!;
              final fieldName = field['field']!;
              final condition = field['condition'];
              if (condition != null && propertyDetails!.propertyCategoryType != condition) {
                return const SizedBox.shrink();
              }
              final value = getFieldValue(propertyDetails!, fieldName);
              if ( value == "" || value == null || value == 'N/A' || value.isEmpty ) {
                return const SizedBox.shrink();
              }
              return PropertyDetailRow(
                label: label,
                value: value,
                image: '',
              );
            }).toList(),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width * 1;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, propertyDetails?.isFavorite);
        return false;
      },
      child: Scaffold(
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
                  color: Colors.black,
                  width: 0.1,
                ),
              ),
              child: InkWell(
                onTap: () {
      
                  Navigator.pop(context, propertyDetails?.isFavorite);
      
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
                    color: Colors.black,
                    width: 0.01,
                  ),
                ),
                child: InkWell(
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
                      } else {
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
                      (propertyDetails != null && propertyDetails?.isFavorite == true)
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
                    color: Colors.black,
                    width: 0.01,
                  ),
                ),
                child: InkWell(

                  onTap: () async {

                    shareProperty(propertyDetails?.id??"");

                  },
                  borderRadius: BorderRadius.circular(50),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Image.asset(
                      "assets/image_rent/share.png",
                      height: 10,
                      width: 15,
                      color: Colors.black.withOpacity(0.6),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: propertyDetails == null
            ? const Center(child: CircularProgressIndicator())
            :  SingleChildScrollView(
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
                        propertyDetails != null
                            ? propertyDetails?.propertyName ?? 'N/A'
                            : 'N/A',
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
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
                      propertyDetails?.propertyCategoryType =="Rent"?
                      // Text(
                      //   '${propertyController.formatIndianPrice(
                      //       (propertyDetails?.propertyPrice == null ||
                      //           int.tryParse(propertyDetails!.propertyPrice.toString()) == 0)
                      //           ? propertyDetails?.customDepositAmount?.toString() ?? '0'
                      //           : propertyDetails?.propertyPrice?.toString() ?? '0'
                      //   )} / ${propertyController.formatIndianPrice(
                      //       propertyDetails?.rent?.toString() ?? '0'
                      //   )} Month',
                      //   style: const TextStyle(
                      //     fontSize: 24,
                      //     color: AppColor.primaryThemeColor,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // )
                      Text(
                        propertyController.formatRentAndDeposit(
                          rent: propertyDetails?.rent?.toString(),
                          deposit: propertyDetails?.propertyPrice?.toString(),
                          customDeposit: propertyDetails?.customDepositAmount?.toString(),
                        ),
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
                        // style: const TextStyle(
                        //     fontSize: 17,
                        //     fontWeight: FontWeight.bold),
                        style: const TextStyle(
                          fontSize: 24,
                          color: AppColor.primaryThemeColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      boxH15(),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (propertyDetails?.bhkType != null && propertyDetails?.bhkType != "")
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
                          if (propertyDetails?.area.toString() != null && propertyDetails?.area.toString() != "")
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
                          if (propertyDetails?.bathroom != null || propertyDetails?.bathroom != "")
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
                                ),
                              ],
                            ),
                        ],
                      ),
                      boxH20(),
                      Row(
                        children: [
                          if (propertyDetails?.virtualTourAvailability == "Yes")
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
                            )
                                : (projectTourSchedules != null &&
                                projectTourSchedules!.isNotEmpty &&
                                !isDateExpiredFromString(projectTourSchedules?.last.scheduleDate ?? ''))
                                ? Expanded(
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
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Flexible(
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
                            )
                                : OutlinedButton(
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
                            ),
                          const SizedBox(width: 10),
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
                        itemCount: (propertyImages?.length ?? 0) +
                            ((propertyDetails?.coverImage?.isNotEmpty ?? false) ? 1 : 0),
                        itemBuilder: (context, index) {
                          final hasCover = propertyDetails?.coverImage?.isNotEmpty ?? false;
                          final isLastIndex = hasCover && index == (propertyImages?.length ?? 0);
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
                          if (propertyImages == null || index >= propertyImages!.length) {
                            return const SizedBox.shrink();
                          }
                          final mediaUrl = propertyImages![index].image ?? '';
                          final isVideoType = isVideo(mediaUrl);
                          final patternIndex = index % 3;
                          if (patternIndex == 0) {
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
                    : Padding(
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
                                width: Get.width * 0.9,
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
                const SizedBox(height: 10),
                if (propertyDetails?.videoUrl != null && propertyDetails?.videoUrl != "")
                  Padding(
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
                  ),
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

                          Builder(
                            builder: (_) {
                              final type = propertyDetails?.propertyType ?? '';
                              final listingType = propertyDetails?.propertyCategoryType ?? '';
                              final fields = getOverviewFields(
                                propertyType: type,
                                listingType: listingType,
                              );

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: fields.map((key) {
                                  switch (key) {
                                    case 'availabilityStatus':
                                      return PropertyDetailRow(
                                        label: "Availability Status",
                                        value: propertyDetails?.availableStatus??"",
                                        image: '',
                                      );

                                    case 'propertyAddedDate':
                                      return PropertyDetailRow(
                                        label: "Property Added Date",
                                        value: propertyDetails?.propertyAddedDate ?? 'N/A',
                                        image: '',
                                      );

                                    case 'propertyName':
                                      return PropertyDetailRow(
                                        label: "Property Name",
                                        value: propertyDetails?.propertyName ?? 'N/A',
                                        image: '',
                                      );

                                    case 'address':
                                      return PropertyDetailRow(
                                        label: "Address",
                                        value: propertyDetails?.address ?? 'N/A',
                                        image: '',
                                      );

                                    case 'area':
                                      final area = double.tryParse(propertyDetails?.area.toString() ?? '') ?? 0.0;
                                      final unit = propertyDetails?.areaIn ?? 'Sq Ft';
                                      final convertedArea = propertyController.convertToSqFt(area, unit);
                                      final type = propertyDetails?.areaType ?? '';
                                      return PropertyDetailRow(
                                        label: "Area",
                                        value: '${convertedArea.toStringAsFixed(0)} Sq Ft ($type)',
                                        image: '',
                                      );
                                    case 'priceRent':
                                      if (listingType.toLowerCase() == 'rent') {
                                        // 🏠 For RENT properties -> show "₹X/month (Deposit - ₹Y)"
                                        final rentText = propertyController.formatRentAndDeposit(
                                          rent: propertyDetails?.rent?.toString(),
                                          deposit: propertyDetails?.propertyPrice?.toString(),
                                          customDeposit: propertyDetails?.customDepositAmount?.toString(),
                                        );



                                        return PropertyDetailRow(
                                          label: 'Rent',
                                          value: rentText,
                                          image: '',
                                        );
                                      } else {
                                        // 💰 For SALE properties -> show "₹X" formatted nicely
                                        final priceStr = propertyDetails?.propertyPrice?.toString();
                                        if (priceStr == null || priceStr.trim().isEmpty || priceStr == '0') {

                                          return PropertyDetailRow(
                                            label: 'Price',
                                            value: 'N/A',
                                            image: '',
                                          );
                                        }

                                        final formattedPrice = propertyController.formatIndianPrice(priceStr);


                                        return PropertyDetailRow(
                                          label: 'Price',
                                          value: formattedPrice,
                                          image: '',
                                        );
                                      }


                                    case 'listingType':
                                      return PropertyDetailRow(
                                        label: "Listing Type",
                                        value: propertyDetails?.propertyCategoryType ?? 'N/A',
                                        image: '',
                                      );

                                    case 'buildingType':
                                      String buildingType;
                                      if ([
                                        'office space',
                                        'shop',
                                        'office space it/sez',
                                        'showroom',
                                        'co-working space',
                                        'warehouse',
                                        'land',
                                        'industrial plot'
                                      ].contains(type.toLowerCase())) {
                                        buildingType = 'Commercial';
                                      } else {
                                        buildingType = 'Residential';
                                      }
                                      return PropertyDetailRow(
                                        label: "Building Type",
                                        value: buildingType,
                                        image: '',
                                      );

                                    case 'propertyType':
                                      return PropertyDetailRow(
                                        label: "Property Type",
                                        value: propertyDetails?.propertyType ?? 'N/A',
                                        image: '',
                                      );

                                    case 'bhk':
                                      return PropertyDetailRow(
                                        label: "BHK",
                                        value: propertyDetails?.bhkType ?? 'N/A',
                                        image: '',
                                      );

                                    case 'furnishingStatus':
                                      return PropertyDetailRow(
                                        label: "Furnishing Status",
                                        value: propertyDetails?.furnishedType ?? 'N/A',
                                        image: '',
                                      );

                                    case 'possessionStatus':
                                      return PropertyDetailRow(
                                        label: "Possession Status",
                                        value: propertyDetails?.possessionStatus ?? 'N/A',
                                        image: '',
                                      );

                                    case 'availableFrom':
                                      return PropertyDetailRow(
                                        label: "Available From",
                                        value: propertyDetails?.availableFrom ?? 'N/A',
                                        image: '',
                                      );

                                    case 'availableFor':
                                      return PropertyDetailRow(
                                        label: "Available For",
                                        value: propertyDetails?.availableFor ?? 'N/A',
                                        image: '',
                                      );

                                    case 'suitedFor':
                                      return PropertyDetailRow(
                                        label: "Suited For",
                                        value: propertyDetails?.suitedFor ?? 'N/A',
                                        image: '',
                                      );

                                    case 'roomType':
                                      return PropertyDetailRow(
                                        label: "Room Type",
                                        value: propertyDetails?.roomType ?? 'N/A',
                                        image: '',
                                      );

                                    case 'foodChargesIncluded':
                                      return PropertyDetailRow(
                                        label: "Food Charges Included",
                                        value: propertyDetails?.foodChargesIncluded ?? 'No',
                                        image: '',
                                      );

                                    default:
                                      return const SizedBox.shrink();
                                  }
                                }).toList(),
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    boxH10(),
                      const Divider(),
                      boxH10(),
                      _buildDetailsSection(), // Dynamic More Details section
                      boxH20(),
                      const Divider(thickness: 0.2, color: Colors.grey),
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
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: _buildAmenitiesList(
                                              propertyAmenities!.sublist(0, (propertyAmenities!.length / 2).ceil()),
                                            ),
                                          ),
                                        ),
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
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            boxH10(),
                            Text(propertyDetails?.propertyDescription ?? "N/A"),
                          ],
                        ),
                      ),
                      boxH30(),
                      const Divider(thickness: 0.2, color: Colors.grey),
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
                                    zoom: 15,
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
                                  zoomGesturesEnabled: true,
                                  scrollGesturesEnabled: true,
                                  rotateGesturesEnabled: true,
                                  tiltGesturesEnabled: true,
                                  zoomControlsEnabled: true,
                                  myLocationButtonEnabled: false,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      boxH20(),

                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          height: 70,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.withOpacity(0.4)),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
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
                                  maxLines: 2,
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
                    commonButton(
                      width: _width * 0.4,
                      buttonColor: AppColor.primaryThemeColor,
                      text: 'Send an Enquiry',
                      textStyle: const TextStyle(fontSize: 14, color: Colors.white),
                      onPressed: () {
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
      print("freeViewCount=>${freeViewCount}");
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
