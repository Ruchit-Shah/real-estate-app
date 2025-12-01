import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart' as d;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:real_estate_app/Routes/app_pages.dart';
import 'package:real_estate_app/global/constant.dart';
import 'package:real_estate_app/global/widgets/loading_dialog.dart';
import 'package:real_estate_app/utils/common_snackbar.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/profile_screen/profile_controller.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/profile_screen/profile_section_screens/My%20Properties/MyProperties.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/profile_screen/profile_section_screens/MyProjects/MyProjects.dart';
import 'package:real_estate_app/view/subscription%20model/controller/SubscriptionController.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_compress/video_compress.dart';
import 'dart:io';

import '../../../common_widgets/loading_dart.dart';
import '../../../global/api_string.dart';
import '../../../global/app_color.dart';
import '../../../utils/String_constant.dart';
import '../../../utils/network_http.dart';
import '../../../utils/shared_preferences/shared_preferances.dart';
import '../../dashboard/bottom_navbar_screens/search_screen/searchController.dart';
import '../../dashboard/view/BottomNavbar.dart';
import '../post_property_screen/NewChanges/post_property_start_page.dart';

class PostPropertyController extends GetxController {
  final isPaginationLoading = false.obs;
  final isEditPageLoading = false.obs;
  final hasMore = true.obs;
  final currentPage = 1.obs;
  final totalPages = 1.obs;
  final total_count = 0.obs;
  final scrollController = ScrollController();
  var currentIndex = 0.obs;
  var Ismap= false.obs;

  var isVirtualTourAvailable = false.obs;
  Map<int, int> carouselIndexMap = {};
  RxBool isUploading = false.obs; // Inside your controller

  TextEditingController searchController = TextEditingController();
  final ProfileController profileController = Get.find();

  ///validation variable
  final List<PriceDetail> priceDetailsList = [];
  var showCategoryPriceError = false.obs;
  var showCategorError = false.obs;
  var showpropertyForError = false.obs;
  var showbhkError = false.obs;
  var showprojectError = false.obs;

  var showimageError = false.obs;
  var showLogoError = false.obs;
  var showbhatroomError = false.obs;
  var showadditionaimagesError = false.obs;
  final RxBool showSqfitError = false.obs;
  final RxBool showAreaTypeError = false.obs;
  final GlobalKey<FormState> moreDetailsFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> priceFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> aboutFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> floorPlanFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> doorWindowFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> projectPriceAreaKey = GlobalKey<FormState>();
  void removeCoverImage() {
    coverImgs.value = null;
  }
  final GlobalKey<FormState> ceilingFormKey = GlobalKey<FormState>();

  final RxBool showFurnishTypeError = false.obs;
  final RxBool showRoomTypeError = false.obs;
  final RxBool showSuitedForError = false.obs;
  final RxBool showFoodChargeError = false.obs;
  final RxBool showAvailableForError = false.obs;
  final GlobalKey<FormState> basicInfo1 = GlobalKey<FormState>();
  final GlobalKey<FormState> basicInfo = GlobalKey<FormState>();
  final GlobalKey<FormState> areaFormKey = GlobalKey<FormState>();
  RxList buildersProjectList = [].obs;
  RxBool isBuyerSelected = true.obs;
  RxInt currentViewIndex = 0.obs;
  RxList<File> images1 = <File>[].obs;
  RxList<File> projectPropertyImage = <File>[].obs;
  final Rx<File?> coverImgs = Rx<File?>(null);
  final Rx<File?> logoImgs = Rx<File?>(null);
  final Rx<File?> videoFile = Rx<File?>(null);
  final RxString videoPath = ''.obs;
  var selectedVideoOption = 'Upload Video'.obs;
  Rx<File?> pdfFile = Rx<File?>(null);
  RxString pdfFileName = ''.obs;
  RxString logoString = ''.obs;
  RxString videoString = ''.obs;
  RxString pdfUrlFromServer = ''.obs;

  Future<void> updatePdfFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        pdfFile.value = File(result.files.single.path!);
        pdfFileName.value = result.files.single.name;
      } else {
        // User canceled the picker
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick PDF: $e');
    }
  }
  // String formatIndianPrice1(String value) {
  //   final number = int.tryParse(value.replaceAll(',', '').trim());
  //   if (number == null) return value;
  //
  //   final formatter = NumberFormat.decimalPattern('en_IN');
  //   return '₹${formatter.format(number)}';
  // }

  String formatPriceRange(String rawRange) {
    if (rawRange.contains('-')) {
      final parts = rawRange.split('-');
      if (parts.length != 2) return rawRange.trim();

      final start = formatIndianPrice(parts[0].trim());
      final end = formatIndianPrice(parts[1].trim());

      return '$start - $end';
    } else {
      return formatIndianPrice(rawRange.trim());
    }
  }

  String formatIndianCurrency(String price) {
    double amount = double.tryParse(price) ?? 0.0;

    if (amount >= 1e7) {
      return '₹${(amount / 1e7).toStringAsFixed(0)} Cr';
    } else if (amount >= 1e5) {
      return '₹${(amount / 1e5).toStringAsFixed(0)} L';
    } else if (amount >= 1e3) {
      return '₹${(amount / 1e3).toStringAsFixed(0)} K';
    } else {
      return '₹${amount.toStringAsFixed(0)}';
    }
  }

  final List<Map<String, dynamic>> propertyCategories = [

    {
      'title': 'Modern Residences',
      'description': 'Beautifully curated residential properties'
          ' perfect for individuals and families — from apartments to villas.',
      'property_type':
          'Apartment, Plot, Villa,Independent House,Builder Floor,Penthouse'
    },
    {
      'title': 'Smart Spaces for Business',
      'description': 'Top commercial spaces for offices, retail, and startups.',
      'property_type': 'Office Space,Shop,Office Space IT/SEZ,Co-Working Space,Showroom'
    },
    {
      'title': 'Industrial & Investment Land',
      'description':
          'Warehouses, industrial plots, and raw land — perfect for factories, logistics, '
              'or future projects.',
      'property_type': 'Warehouse,Industrial Plot,Land'
    },
    {
      'title': 'PG & Co-Living Spaces',
      'description':
          'Affordable and community-style living for students and working professionals with shared amenities.',
      'property_type': 'PG'

    },
  ];

  final List<Map<String, dynamic>> items = [
    {
      'title': 'New Property',
      'image': 'assets/welcomePage/welcomeHouse.png',
    },
    {
      'title': 'Builder Project',
      'image': 'assets/welcomePage/welcomeHouse.png',
    },
  ];

  final List<Map<String, dynamic>> property_add_type = [
    {
      'title': '1. Upload your property Images',
      'subtitle': 'At least 5 images add ',
      'image': 'assets/welcomePage/welcomeHouse.png',
    },
    {
      'title': '2. Houzza AI will generate content of your ',
      'subtitle':
          'Houzza Ai help you to generate automate content from Photos ',
      'image': 'assets/welcomePage/welcomeHouse.png',
    },
    {
      'title': '3. Publish your property ',
      'subtitle': 'Verify your details and Punish and reach your customer ',
      'image': 'assets/welcomePage/welcomeHouse.png',
    },
  ];

  final RxInt selectedIndex = (-1).obs;

  String formatIndianPrice(String? priceStr) {
    try {
      final price = double.tryParse(priceStr ?? "0") ?? 0;

      if (price >= 10000000) {
        double crore = price / 10000000;
        return '₹${_formatRounded(crore)} Cr';
      } else if (price >= 100000) {
        double lakh = price / 100000;
        return '₹${_formatRounded(lakh)} L';
      } else if (price >= 1000) {
        double thousand = price / 1000;
        return '₹${_formatRounded(thousand)} K';
      } else {
        return '₹${_formatRounded(price)}';
      }
    } catch (e) {
      return priceStr ?? "";
    }
  }

  String _formatRounded(double value) {
    if (value % 1 == 0) {
      return value.toStringAsFixed(0); // e.g., 3K
    } else {
      return value.toStringAsFixed(1); // e.g., 3.5K
    }
  }




  Future<void> pickNewPdfFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      if (result != null && result.files.single.path != null) {
        pdfFile.value = File(result.files.single.path!);
        pdfFileName.value = result.files.single.name;
        pdfUrlFromServer.value = '';
        Get.snackbar('Success', 'PDF file selected: ${pdfFileName.value}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick PDF: $e');
    }
  }
  Future<void> previewPdf() async {
    if (pdfFile.value != null) {
      Get.defaultDialog(
          title: "PDF Preview",
          middleText:
          "You have selected a new PDF file: \n'${pdfFileName.value}'.\n\nThis new file will be uploaded when you save your changes. You cannot preview it from here, but you can open it from your device's file manager.",
          textConfirm: "OK",
          onConfirm: () => Get.back());
      return;
    }

    if (pdfUrlFromServer.value.isNotEmpty) {
      final Uri url = Uri.parse(pdfUrlFromServer.value);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar('Error', 'Could not open the PDF file.');
      }
    }
  }
  void clearPdfSelection() {
    pdfFile.value = null;
    pdfFileName.value = '';
    pdfUrlFromServer.value = '';
    Get.snackbar('Removed', 'PDF selection has been cleared.');
  }

  void clearFields() {
    categoryPriceselected.value = -1;
    categorySelected.value = -1;

    coverImgs.value = null;
    images1.clear();
    getPropertyImageList.clear();
    logoImgs.value = null;
    pdfFile.value = null;
    videoFile.value = null;

    pdfUrlFromServer.value = '';

    amenitiesString = '';

    reraIDController.clear();
    aboutController.clear();
  }

  String formatDayMonthYear(String inputDate) {
    try {
      final DateTime parsedDate = DateTime.parse(inputDate);
      final DateFormat formatter = DateFormat('dd MMMM yyyy');
      return formatter.format(parsedDate);
    } catch (e) {
      return inputDate;
    }
  }

  String formatDayThreeMonthYear(String inputDate) {
    try {
      final DateTime parsedDate = DateTime.parse(inputDate);
      final DateFormat formatter = DateFormat('dd MMM yy'); // Short month and 2-digit year
      return formatter.format(parsedDate);
    } catch (e) {
      return inputDate;
    }
  }

  List<Widget> views = [];

  List uploadedImages = [
    'assets/recommended_img/imgbed1.png',
    'assets/recommended_img/imgbed2.jpeg',
    'assets/recommended_img/imgbed3.jpeg',
    'assets/recommended_img/img bed4.png',
    'assets/recommended_img/imgbed5.jpeg',
    'assets/recommended_img/imgbed6.jpeg',
    'assets/recommended_img/imgbed7.jpeg'
  ];

  Future<void> updateCoverImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      showimageError.value = false;
      coverImgs.value = File(pickedFile.path);
    }
  }
  Future<void> updateLogoImg() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      showLogoError.value = false;
      logoImgs.value = File(pickedFile.path);
    }
  }

  // Method to add multiple images
  Future<void> addImages() async {
    // Calculate remaining slots for images
    final remainingSlots = 5 - images1.length;

    if (remainingSlots <= 0) {
      showadditionaimagesError.value = true;
      //Fluttertoast.showToast(msg: 'You can only select up to 5 images.');
      return;
    }

    // Pick multiple images without maxFiles (for older image_picker versions)
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles != null) {
      // Check if selected files exceed the remaining slots
      if (pickedFiles.length <= remainingSlots) {
        for (var pickedFile in pickedFiles) {
          images1.add(File(pickedFile.path));
          showadditionaimagesError.value = false;
        }
      } else {
        showadditionaimagesError.value = true;
        Fluttertoast.showToast(msg: 'You can only select up to $remainingSlots more image(s).');
      }
    }
  }

  void deleteImg(int index) {
    uploadedImages.removeAt(index);
  }

  var propertyType = ''.obs;
  String? address;
  String? lat;
  String? long;
  // late File icon_img;
  File? iconImg;
  File? coverImg;
  List<XFile?> pickedFiles = [];
  late XFile pickedImageFile;
  RxBool isIconSelected = false.obs;
  String? stateValue = '';
  String? cityValue = '';
  bool isSecurity = false;
  RxBool isFeatured = false.obs;
  var propertyOwnerType = ''.obs;
  var CategoryPriceType = ''.obs;
  var categorytype = ''.obs;
  var propertytype = ''.obs;
  var propertyDetails = ''.obs;
  var propertyLocality = ''.obs;

  String amenitiesString = '';

  bool isPropertyPosted = false;
  RxBool editMode = false.obs;
  RxBool addMode = false.obs;
  RxBool saveMode = false.obs;

  var bhkType = ''.obs;

  var bathrrom = ''.obs;

  final furnishType = Rx<String?>(null); // Nullable type
  final isParkingAvailable = Rx<String?>(null); // Nullable type
  final selectedSeatsType = Rx<String?>(null); // Nullable type
  final PoweBackup = Rx<String?>(null); // Nullable type
  final Facing = Rx<String?>(null); // Nullable type
  final LiftAvailability = Rx<String?>(null); // Nullable type
  final View = Rx<String?>(null); // Nullable type
  final OfficeSpaceType = Rx<String?>(null); // Nullable type
  final Pantry = Rx<String?>(null); // Nullable type
  final selectedPersonalWashroom = Rx<String?>(null); // Nullable type
  final Flooring = Rx<String?>(null); // Nullable type
  final selectedAvailableFrom = Rx<String?>(null); // Nullable type
  final selectedAvailableFor = Rx<String?>(null); // Nullable type
  final selectedSuitedFor = Rx<String?>(null); // Nullable type
  final AgeProperty = Rx<String?>(null); // Nullable type
  final CoveredParking = Rx<String?>(null); // Nullable type
  final numberOfBathroom = Rx<String?>(null); // Nullable type
  final UnCoveredParking = Rx<String?>(null); // Nullable type
  final additionalRoom = Rx<String?>(null); // Nullable type
  final PersonalWashroom = Rx<String?>(null);
  final roomType = Rx<String?>(null);
  final pgFood = Rx<String?>(null);
  final foodCharges = Rx<String?>(null);
  final electricityCharges = Rx<String?>(null);
  final parkingAvailable = Rx<String?>(null);
  final gateClosingTime = Rx<String?>(null);
  final noticeDays = Rx<String?>(null);
  final operatingYears = Rx<String?>(null);
  RxString coverImage = ''.obs;
  RxBool locationError = false.obs;

  var propertyPrice = ''.obs;
  var deposite = ''.obs;
  var availableFrom = ''.obs;
  var expiryOn = ''.obs;

  var bathroomType = ''.obs;
  RxString searchText = ''.obs;

  var isLoading = false.obs;
  var isFailedTo = false.obs;
  var isPostingProperty = false.obs;
  final TextEditingController offerNameController = TextEditingController();
  final TextEditingController offerDurationController = TextEditingController();
  final TextEditingController offerDescriptionController =
      TextEditingController();

  final TextEditingController buildUpAreaController = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  final TextEditingController LivingController = TextEditingController();
  final TextEditingController internalDoorController = TextEditingController();
  final TextEditingController ExternalGlazingController =
      TextEditingController();
  final TextEditingController elertricalController = TextEditingController();
  final TextEditingController backupController = TextEditingController();
  final TextEditingController securitySystemController =
      TextEditingController();
  final TextEditingController aboutController = TextEditingController();
  final TextEditingController develoeperController = TextEditingController();
  final TextEditingController KitchenController = TextEditingController();
  final TextEditingController BedroomController = TextEditingController();
  final TextEditingController florController = TextEditingController();
  final TextEditingController TowerBlockController = TextEditingController();
  final TextEditingController totalProjectSizeController =
      TextEditingController();
  final TextEditingController avgProjectPriceController =
      TextEditingController();
  final TextEditingController configurationController = TextEditingController();
  final TextEditingController reraIDController = TextEditingController();
  final TextEditingController pgNoOfBedsController = TextEditingController();
  final TextEditingController pgSevicesController = TextEditingController();
  final TextEditingController transactionController = TextEditingController();
  final TextEditingController floorNumberController = TextEditingController();
  final TextEditingController numberofSeatsAvailableController =
      TextEditingController();

  final TextEditingController ceilingHeightController = TextEditingController();
  final TextEditingController possessionDateController = TextEditingController();
  final TextEditingController miniumLockController = TextEditingController();
  final TextEditingController launchDateController = TextEditingController();
  final TextEditingController DiningController = TextEditingController();
  final TextEditingController BalconyController = TextEditingController();
  final TextEditingController RoomsConroller = TextEditingController();
  final TextEditingController ToiletsConroller = TextEditingController();
  final TextEditingController ServantConroller = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController externalGlazingController =
      TextEditingController();
  final TextEditingController ceilingLivingController = TextEditingController();
  final TextEditingController ceilingServantController =
      TextEditingController();
  final TextEditingController electricalController = TextEditingController();

  final TextEditingController counterKitchenController =
      TextEditingController();
  final TextEditingController fittingKitchenController =
      TextEditingController();
  final TextEditingController fittingToiletController = TextEditingController();
  final TextEditingController videoUrlController = TextEditingController();
  final TextEditingController availableFromController = TextEditingController();
  final TextEditingController expieyController = TextEditingController();
  final TextEditingController securityDepositController =
      TextEditingController();
  final TextEditingController MinimumPreferredController =
      TextEditingController();
  final TextEditingController propertyNameController = TextEditingController();
  final TextEditingController flatHouseNoController = TextEditingController();
  final TextEditingController streetAddressController = TextEditingController();
  final TextEditingController landmarkController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController pinCodeController = TextEditingController();
  final TextEditingController localityController = TextEditingController();
  final TextEditingController propertyDescriptionController =
      TextEditingController();
  final TextEditingController phNoController = TextEditingController();
  final TextEditingController propertyPriceController = TextEditingController();
  final TextEditingController totalFloorController = TextEditingController();
  final TextEditingController UnitController = TextEditingController();
  final TextEditingController propertyFloorController = TextEditingController();
  final TextEditingController amenetiesName = TextEditingController();

  SubscriptionController searcontroller = Get.put(SubscriptionController());
  RxString selectedsqfit = ''.obs;
  RxString selectedarea = ''.obs;
  RxString furnishedtype= ''.obs;
  RxString address_area= ''.obs;
 // RxnString selectedarea = RxnString('Carpet Area'); // Only if 'Carpet Area' is in areaType


  clearData() {
    pickedFiles.clear();
    categorySelected = (-1).obs;
    categoryPriceselected = (-1).obs;
    selectedProperty = (-1).obs;
    selectedBhk = (-1).obs;
    selectedFurnished = (-1).obs;
    categorytype = ''.obs;
    expiryOn = ''.obs;
    propertyPrice = ''.obs;
    availableFrom = ''.obs;
    lat = '';
    long = '';
    address = '';
    cityValue = '';
    propertyNameController.clear();
    propertyDescriptionController.clear();
    expieyController.clear();
    buildUpAreaController.clear();
    availableFromController.clear();
    totalFloorController.clear();
    UnitController.clear();
    propertyFloorController.clear();
    propertyPriceController.clear();
    bathroomType = ''.obs;
    coverImg = null;
    isIconSelected.value = false;
    isSecurity = false;
    isFeatured.value = false;
    iconImg = null;
    isIconSelected.value = false;
    selectedamenities = <String>{}.obs;
    CategoryPriceType = ''.obs;
    isPropertyPosted = false;
    PropertyId = "";
    getPropertyImageList.clear();
    videoFile.close();
    videoPath.value = '';
    bhkType.value = '';
    bathrrom.value = '';
  }

  String PropertyId = "";

  final ImagePicker picker = ImagePicker();
  int maxImages = 10;
  final List<Map<String, dynamic>> sectionData = [
    {
      'section': 'Residential',
      'percentage': 20,
      'color': AppColor.primaryThemeColor
    },
    {'section': 'Commercial', 'percentage': 35, 'color': Colors.green},
    {'section': 'Industrial', 'percentage': 15, 'color': AppColor.amber},
  ];
  List<String> categoryOwnerType = ["Buyer/Owner", "Agent", "Builder"];

  // List<String> categoryPriceType = ["Buy", "Rent", "PG"];
  //  List<String> categoryPriceType = ["Sell", "Rent", "PG"];
  List<String> categoryPriceType = [
    "Sell",
    "Rent",
  ];
  List<String> sellerViewType = [
    "Property",
    "Projects",
  ];


  List<String> categoryType = ["Residential","Commercial" ];
  List<String> OfficeSpaceTypeList = [
    "Semi-Fitted",
    "Fitted Space",
    "Shell and Core"
  ];
  List<String> PantryList = ["Wet", "Dry", "None"];
  List<String> PersonalWashroomList = ["Yes", "No"];
  final List<String> commercialPropertyType = [
    'Office Space',
    'Shop',
    'Land',
    'Office Space IT/SEZ',
    'Showroom',
    'Warehouse',
    'Industrial Plot',
    'Co-Working Space'
  ];

  RxList<String> PoweBackupList = <String>[].obs;
  RxList<String> FacingList = <String>[].obs;
  RxList<String> seatsTypeList = <String>[].obs;
  RxList<String> ViewList = <String>[].obs;
  RxList<String> LiftAvailabilityList = <String>[].obs;
  RxList<String> FlooringList = <String>[].obs;
  RxList<String> residentalpropertyTypes = <String>[].obs;
  RxList<String> bathroomypes = <String>[].obs;
  RxList<String> bhkTypes = <String>[].obs;
  RxList<String> additionalType = <String>[].obs;
  RxList<String> WaterSourceList = <String>[].obs;
  RxList<String> BalconyList = <String>[].obs;
  RxList<String> PossessionStatus = <String>[].obs;
  RxMap<String,String> projectConstructionStatus = <String,String>{}.obs;
  RxList<String> AgeofProperty = <String>[].obs;
  RxList<String> CoveredParkingList = <String>[].obs;
  RxList<String> UnCoveredParkingList = <String>[].obs;
  RxList<String> roomTypeList = <String>[].obs;
  RxList<String> NoticePeriodDaysList = <String>[].obs;
  RxList<String> OperatingSinceYearsList = <String>[].obs;
  RxList<String> PG_HostelRulesList = <String>[].obs;
  RxList<String> AvailablePGServicesList = <String>[].obs;
  RxList<String> foodAvailableList = <String>[].obs;
  RxList<String> selectedAdditionalRooms = RxList<String>();
  RxList<String> selectedWaterSourceList = <String>[].obs;
  RxList<String> selectedBalconyList = RxList<String>();
  RxList<String> selectedPGRulesList = RxList<String>();
  RxList<String> selectedPGServiceList = RxList<String>();
  RxList<String> selectedRoomTypesList = RxList<String>();
  RxString selectedPossessionStatus = ''.obs;
  RxString selectedConstructionStatus = ''.obs;
  final List<String> filterpropertyTypes = [
    'Apartment',
    'Villa',
    'Plot',
    'Builder Floor',
    'Penthouse',
    'Independent House',
    'PG',
    'Office Space',
    'Shop',
    'Land',
    'Office Space IT/SEZ',
    'Showroom',
    'Industrial Plot',
    'Co-Working Space',
    'Warehouse',
  ];



  final List<String> ProjectType = [
    'Apartment',
    'Villa',
    'Plot',
    'Builder Floor',
    'Penthouse',
    'Independent House',
  ];

  final FocusNode propertyNameFocusNode = FocusNode();
  final FocusNode addressFocusNode = FocusNode();
  double convertToSqFt(double area, String? unit) {
    switch (unit) {
      case 'Sq Ft':
        return area;
      case 'Sq Yd':
        return area * 9;
      case 'Sq Mt':
        return area * 10.7639;
      case 'Acre':
        return area * 43560;
      default:
        return area;
    }
  }

  String formatRentAndDeposit({
    String? rent,
    String? deposit,
    String? customDeposit,
  }) {
    // Parse rent
    final double rentValue = double.tryParse(rent ?? '0') ?? 0;
    final double depositValue =
        double.tryParse(deposit ?? customDeposit ?? '0') ?? 0;

    String formatINR(double amount) {
      // Format small rents properly (e.g., 5.6 instead of 6)
      if (amount < 1000) return '₹${amount.toStringAsFixed(1)}';
      // Format with Indian numbering (K, L, Cr)
      if (amount >= 10000000) {
        return '₹${(amount / 10000000).toStringAsFixed(2)} Cr';
      } else if (amount >= 100000) {
        return '₹${(amount / 100000).toStringAsFixed(2)} L';
      } else if (amount >= 1000) {
        return '₹${(amount / 1000).toStringAsFixed(1)} K';
      } else {
        return '₹${amount.toStringAsFixed(0)}';
      }
    }

    final rentText = rentValue > 0 ? '${formatINR(rentValue)}/month' : '';
    final depositText =
    depositValue > 0 ? '(Deposit – ${formatINR(depositValue)})' : '';

    // Combine them smartly
    if (rentText.isNotEmpty && depositText.isNotEmpty) {
      return '$rentText $depositText';
    } else if (rentText.isNotEmpty) {
      return rentText;
    } else if (depositText.isNotEmpty) {
      return depositText;
    } else {
      return '₹0';
    }
  }


  List<String> sqFitType = ['Sq Ft', 'Sq Yd', 'Sq Mt', 'Acre'];
  List<String> availableFromList = [
    'Immediately',
    'Later',
  ];
  List<String> availableForList = ['Girls', 'Boys', 'All'];
  List<String> suitedForList = ['Students', 'Working Professionals', 'Any'];

  List<String> areaType = [
    'Carpet Area',
    'Plot Area',
    'Saleable Area',
    'Built-up Area'
  ];
  // final List<String> bathroomypes = ['1', '2', '3', '4+'];
  final List<String> furnishTypes =
      ['Furnished', 'UnFurnished', 'SemiFurnished'].obs;
  final List<String> yesOrNoValue = ["Yes", 'No'].obs;

  final RxInt selected = (-1).obs;
  var categoryPriceselected = (-1).obs;
  var categorySelected = (-1).obs;
  var selectedProperty = (-1).obs;
  RxString selectedPropertyType = ''.obs;
  var selectedBhk = (-1).obs;
  var selectebathroom = (-1).obs;
  var selectedFurnished = (-1).obs;

  String currentCountryCode = "IN-91";
  RxList getAmenitiesList = [].obs;
  RxList getProjectPropertyList = [].obs;

  RxList getOfferdPropertyList = [].obs;
  RxList getPropertyList = [].obs;
  RxList getPropertyImageList = [].obs;
  RxList getOfferList = [].obs;
  RxList filteredOfferList = [].obs;
  RxList getUpcomingProject = [].obs;

  RxList getFeaturedPropery = [].obs;
  RxList getRecommendedPropertyList = [].obs;
  RxList getCommonPropertyList = [].obs;
  RxList getCommonProjectsList = [].obs;

  RxList getProperyEnquiryList = [].obs;
  RxList getProjectEnquiryList = [].obs;
  RxList getDeveloperEnquiryList = [].obs;
  RxList descriptionList = [].obs;

  RxList getCities = [].obs;
  RxList OwnerListedBy = [].obs;
  RxList getSearchList = [].obs;
//  RxList getCategoryProperty = [].obs;
  RxList getCategoryProperty = List.filled(4, null, growable: true).obs;



  List<Map<String, dynamic>> staticCities = [
    {'city_name': 'Mumbai', 'city_image': 'assets/image_rent/mumbai.jpg'},
    {'city_name': 'Hydrabaad', 'city_image': 'assets/image_rent/hyderabad.jpg'},
    {'city_name': 'Delhi', 'city_image': 'assets/image_rent/delhi.jpg'},
    {'city_name': 'Kolkatta', 'city_image': 'assets/image_rent/kolkatta.jpg'},
    {'city_name': 'Bangolre', 'city_image': 'assets/image_rent/banglore.jpg'},
    {'city_name': 'Pune', 'city_image': 'assets/image_rent/pune.jpg'},
    {'city_name': 'Chenni', 'city_image': 'assets/image_rent/Chennai.jpg'},
    {'city_name': 'Ahemdabad', 'city_image': 'assets/image_rent/ahemdabad.jpg'},
  ];


  RxList selectedOfferedProperties = [].obs;

  String offeredPropertyId = "";

  var selectedamenities = <String>{}.obs;
  // RxList getSearchList = [].obs;
  String city='';



  void toggleSelection(String id) {
    if (selectedamenities.contains(id)) {
      selectedamenities.remove(id);
    } else {
      selectedamenities.add(id);
    }
    update();
  }

  bool isAdded(String id) {
    bool result = selectedamenities.contains(id);
    return result;
  }

  // Future<void> pickVideoFromGallery() async {
  //   try {
  //     final pickedFile = await ImagePicker().pickVideo(
  //       source: ImageSource.gallery,
  //       maxDuration: const Duration(minutes: 10), // Optional: set max duration
  //     );
  //
  //     if (pickedFile != null) {
  //       videoFile.value = File(pickedFile.path);
  //       videoPath.value = pickedFile.path;
  //       // Get.snackbar('Success', 'Video selected successfully');
  //       print("'Success', 'Video selected successfully'");
  //     } else {
  //       print("'Cancelled', 'No video was selected'");
  //     }
  //   } catch (e) {
  //     print("'Error', 'Failed to pick video: ${e.toString()}'");
  //   }
  // }
  var isCompressingVideo = false.obs;

  // Future<void> pickVideoFromGallery() async {
  //   try {
  //     final pickedFile = await ImagePicker().pickVideo(
  //       source: ImageSource.gallery,
  //       maxDuration: const Duration(minutes: 10),
  //     );
  //
  //     if (pickedFile != null) {
  //       print("Original size: ${File(pickedFile.path).lengthSync() / (1024 * 1024)} MB");
  //
  //       isCompressingVideo.value = true; // Start loader
  //
  //       // Compress the video
  //       final MediaInfo? compressedVideo = await VideoCompress.compressVideo(
  //         pickedFile.path,
  //         quality: VideoQuality.MediumQuality,
  //         deleteOrigin: false,
  //       );
  //
  //       isCompressingVideo.value = false; // Stop loader
  //
  //       if (compressedVideo != null && compressedVideo.file != null) {
  //         videoFile.value = File(compressedVideo.file!.path);
  //         videoPath.value = compressedVideo.file!.path;
  //
  //         print("Compressed size: ${videoFile.value!.lengthSync() / (1024 * 1024)} MB");
  //         print("Video compressed and selected successfully");
  //       } else {
  //         print("Video compression failed");
  //       }
  //     } else {
  //       print("No video was selected");
  //     }
  //   } catch (e) {
  //     isCompressingVideo.value = false;
  //     print("Failed to pick or compress video: ${e.toString()}");
  //   }
  // }

  Future<void> pickVideoFromGallery() async {
    try {
      final pickedFile = await ImagePicker().pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(minutes: 10),
      );

      if (pickedFile != null) {
        final originalFile = File(pickedFile.path);
        final fileSizeMB = originalFile.lengthSync() / (1024 * 1024); // in MB

        print("Original size: $fileSizeMB MB");

        if (fileSizeMB > 30) {
          // Show warning if video is larger than 50MB
          Get.snackbar(
            "Video too large",
            "Please select a video smaller than 30 MB.",
            backgroundColor: Colors.red.withOpacity(0.7),
            colorText: Colors.white,
          );
          return;
        }

        isCompressingVideo.value = true; // Start loader

        // Compress the video
        final MediaInfo? compressedVideo = await VideoCompress.compressVideo(
          pickedFile.path,
          quality: VideoQuality.MediumQuality,
          deleteOrigin: false,
        );

        isCompressingVideo.value = false;

        if (compressedVideo != null && compressedVideo.file != null) {
          videoFile.value = File(compressedVideo.file!.path);
          videoPath.value = compressedVideo.file!.path;

          print("Compressed size: ${videoFile.value!.lengthSync() / (1024 * 1024)} MB");
          print("Video compressed and selected successfully");
        } else {
          print("Video compression failed");
        }
      } else {
        print("No video was selected");
      }
    } catch (e) {
      isCompressingVideo.value = false;
      print("Failed to pick or compress video: ${e.toString()}");
    }
  }


  var countryName = ''.obs;
  var leadsData = [].obs;
  var viewsData = [].obs;
  var virtualTourData = [].obs;
  /// seller panel  apis
  Future<void> getLeadsMapData(var fromDate,var toDate) async {
    String? userId = await SPManager.instance.getUserId(USER_ID);
    leadsData.clear();
    String startDate = DateFormat('yyyy-MM-dd').format(fromDate ?? DateTime.now());
    String todate = DateFormat('yyyy-MM-dd').format(toDate ?? DateTime.now());

    try {
      var response = await HttpHandler.postHttpMethod(
        url: APIString.get_leads_data,
        data: {
          'user_id': userId,
          'start_date': startDate,
          'end_date': todate,
        },
      );

      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          log("response[data]  ---- ${response['body']["data"]}");
          var respData = response['body'];

          // getAmenitiesList.add(response['body']["data"]);
          leadsData.value = respData["data"];

          ////Fluttertoast.showToast(msg: 'Fetch successfully');
        }
      } else if (response['error'] != null) {
        // var responseBody = json.decode(response['body']);
        // //Fluttertoast.showToast(msg: responseBody['msg']);
      }
    } catch (e) {
      debugPrint("Login Error: $e");
      //  //Fluttertoast.showToast(msg: 'An error occurred. Please try again.');
    }
  }

  Future<void> getViewMapData(var fromDate,var toDate) async {
    String? userId = await SPManager.instance.getUserId(USER_ID);
    viewsData.clear();
    String startDate = DateFormat('yyyy-MM-dd').format(fromDate ?? DateTime.now());
    String todate = DateFormat('yyyy-MM-dd').format(toDate ?? DateTime.now());

    try {
      var response = await HttpHandler.postHttpMethod(
        url: APIString.get_views_data,
        data: {
          'user_id': userId,
          'start_date': startDate,
          'end_date': todate,
        },
      );

      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          log("response[data]  ---- ${response['body']["data"]}");
          var respData = response['body'];

          // getAmenitiesList.add(response['body']["data"]);
          viewsData.value = respData["data"];

          ////Fluttertoast.showToast(msg: 'Fetch successfully');
        }
      } else if (response['error'] != null) {
        // var responseBody = json.decode(response['body']);
        // //Fluttertoast.showToast(msg: responseBody['msg']);
      }
    } catch (e) {
      debugPrint("Login Error: $e");
      //  //Fluttertoast.showToast(msg: 'An error occurred. Please try again.');
    }
  }

  Future<void> getVirtualTourMapData(var fromDate,var toDate) async {
    String? userId = await SPManager.instance.getUserId(USER_ID);
    virtualTourData.clear();
    String startDate = DateFormat('yyyy-MM-dd').format(fromDate ?? DateTime.now());
    String todate = DateFormat('yyyy-MM-dd').format(toDate ?? DateTime.now());

    try {
      var response = await HttpHandler.postHttpMethod(
        url: APIString.get_tours_data,
        data: {
          'user_id': userId,
          'start_date': startDate,
          'end_date': todate,
        },
      );

      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          log("response[data]  ---- ${response['body']["data"]}");
          var respData = response['body'];

          // getAmenitiesList.add(response['body']["data"]);
          virtualTourData.value = respData["data"];

          print("virtualTourData=>${virtualTourData.length}");

          ////Fluttertoast.showToast(msg: 'Fetch successfully');
        }
      } else if (response['error'] != null) {
        // var responseBody = json.decode(response['body']);
        // //Fluttertoast.showToast(msg: responseBody['msg']);
      }
    } catch (e) {
      debugPrint("Login Error: $e");
      //  //Fluttertoast.showToast(msg: 'An error occurred. Please try again.');
    }
  }


  // Future<void> getAddressFromLatLng(latLng) async {
  //   final apiKey = 'AIzaSyDY-oB0QysTXFJu2cOMlZvpwANBR2XS84E';
  //
  //   final url =
  //       'https://maps.googleapis.com/maps/api/geocode/json?latlng=${latLng.latitude},${latLng.longitude}&key=$apiKey';
  //   final response = await http.get(Uri.parse(url));
  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body);
  //
  //     if (data['results'] != null && data['results'].isNotEmpty) {
  //       final components = data['results'][0]['address_components'] as List;
  //       final address = data['results'][0]['formatted_address'];
  //
  //
  //
  //       for (var component in components) {
  //         final types = component['types'] as List;
  //
  //         // Print the entire component for debugging
  //         debugPrint('Component: types=$types, long_name=${component['long_name']}');
  //
  //         if (types.contains('locality')) {
  //           cityController.text = component['long_name'];
  //           debugPrint('Assigned to cityController: ${component['long_name']}');
  //         } else if (types.contains('administrative_area_level_2')) {
  //           localityController.text = component['long_name'];
  //           debugPrint('Assigned to localityController: ${component['long_name']}');
  //         } else if (types.contains('administrative_area_level_1')) {
  //           stateController.text = component['long_name'];
  //           debugPrint('Assigned to stateController: ${component['long_name']}');
  //         } else if (types.contains('postal_code')) {
  //           pinCodeController.text = component['long_name'];
  //           debugPrint('Assigned to pinCodeController: ${component['long_name']}');
  //         } else if (types.contains('country')) {
  //           countryName.value = component['long_name'];
  //           countryController.text = component['long_name'];
  //           debugPrint('Assigned to countryName and countryController: ${component['long_name']}');
  //         } else if (types.contains('sublocality_level_2')) {
  //           countryName.value = component['long_name'];
  //           debugPrint('Assigned to countryName (sublocality_level_2): ${component['long_name']}');
  //         }
  //       }
  //       if (address != '') {
  //         streetAddressController.text = address;
  //       }
  //       lat = latLng.latitude.toString();
  //       long = latLng.longitude.toString();
  //
  //       print("City: ${cityController.text},"
  //           " District: ${localityController.text},"
  //           " State: ${stateController.text},"
  //           " Pincode: ${pinCodeController.text} , country : ${countryName}");
  //     }
  //   } else {
  //     print('Failed to fetch address');
  //   }
  // }


  // Future<void> getAddressFromLatLng( latLng) async {
  //   // Check if latLng is valid
  //   if (latLng == null) {
  //     debugPrint('Error: latLng is null');
  //     return;
  //   }
  //   if (latLng.latitude == null || latLng.longitude == null) {
  //     debugPrint('Error: latLng.latitude or latLng.longitude is null');
  //     return;
  //   }
  //   if (latLng.latitude < -90 || latLng.latitude > 90 || latLng.longitude < -180 || latLng.longitude > 180) {
  //     debugPrint('Error: Invalid latLng coordinates: ${latLng.latitude}, ${latLng.longitude}');
  //     return;
  //   }
  //
  //   const apiKey = 'AIzaSyBvxPKGiyGXholpqjbnpElgrUNvcUQbZp8';
  //   final url =
  //       'https://maps.googleapis.com/maps/api/geocode/json?latlng=${latLng.latitude},${latLng.longitude}&key=$apiKey';
  //
  //   debugPrint('Requesting URL: $url');
  //
  //   try {
  //     final response = await http.get(Uri.parse(url));
  //     debugPrint('HTTP Response Status: ${response.statusCode}');
  //     debugPrint('HTTP Response Body: ${response.body}');
  //
  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       debugPrint('Parsed JSON Data: $data');
  //
  //       if (data['status'] == 'OK' && data['results'] != null && data['results'].isNotEmpty) {
  //         final components = data['results'][0]['address_components'] as List;
  //         final address = data['results'][0]['formatted_address'] ?? '';
  //         debugPrint('Address Components: $components');
  //         debugPrint('Formatted Address: $address');
  //
  //         for (var component in components) {
  //           final types = component['types'] as List;
  //           debugPrint('Component: types=$types, long_name=${component['long_name']}');
  //
  //           if (types.contains('locality')) {
  //             cityController.text = component['long_name'] ?? '';
  //             debugPrint('Assigned to cityController: ${component['long_name']}');
  //           } else if (types.contains('administrative_area_level_2')) {
  //             localityController.text = component['long_name'] ?? '';
  //             debugPrint('Assigned to localityController: ${component['long_name']}');
  //           } else if (types.contains('administrative_area_level_1')) {
  //             stateController.text = component['long_name'] ?? '';
  //             debugPrint('Assigned to stateController: ${component['long_name']}');
  //           } else if (types.contains('postal_code')) {
  //             pinCodeController.text = component['long_name'] ?? '';
  //             debugPrint('Assigned to pinCodeController: ${component['long_name']}');
  //           } else if (types.contains('country')) {
  //             countryName.value = component['long_name'] ?? '';
  //             countryController.text = component['long_name'] ?? '';
  //             debugPrint('Assigned to countryName and countryController: ${component['long_name']}');
  //           } else if (types.contains('sublocality_level_2')) {
  //             countryName.value = component['long_name'] ?? '';
  //             debugPrint('Assigned to countryName (sublocality_level_2): ${component['long_name']}');
  //           }
  //
  //
  //         }
  //
  //         if (address.isNotEmpty) {
  //           streetAddressController.text = address;
  //           debugPrint('Assigned to streetAddressController: $address');
  //         }
  //
  //         lat = latLng.latitude.toString();
  //         long = latLng.longitude.toString();
  //
  //         debugPrint('Assigned lat: $lat, long: $long');
  //
  //         debugPrint(
  //           'Final Values: City: ${cityController.text}, '
  //               'District: ${localityController.text}, '
  //               'State: ${stateController.text}, '
  //               'Pincode: ${pinCodeController.text}, '
  //               'Country: ${countryName.value}',
  //         );
  //       } else {
  //         debugPrint('Error: API status is ${data['status']}, results: ${data['results']}');
  //         if (data['error_message'] != null) {
  //           debugPrint('API Error Message: ${data['error_message']}');
  //         }
  //       }
  //     } else {
  //       debugPrint('Failed to fetch address. Status Code: ${response.statusCode}, Body: ${response.body}');
  //     }
  //   } catch (e, stackTrace) {
  //     debugPrint('Exception occurred: $e');
  //     debugPrint('Stack Trace: $stackTrace');
  //   }
  // }

  Future<void> getAddressFromLatLng(latLng) async {
    // Check if latLng is valid
    if (latLng == null) {
      debugPrint('Error: latLng is null');
      return;
    }
    if (latLng.latitude == null || latLng.longitude == null) {
      debugPrint('Error: latLng.latitude or latLng.longitude is null');
      return;
    }
    if (latLng.latitude < -90 || latLng.latitude > 90 || latLng.longitude < -180 || latLng.longitude > 180) {
      debugPrint('Error: Invalid latLng coordinates: ${latLng.latitude}, ${latLng.longitude}');
      return;
    }

    // const apiKey = 'AIzaSyBvxPKGiyGXholpqjbnpElgrUNvcUQbZp8';
    const apiKey = 'AIzaSyAt8bj4UACvakZfiSy-0c1o_ivfplm7jEU';
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${latLng.latitude},${latLng.longitude}&key=$apiKey';

    debugPrint('Requesting URL: $url');

    try {
      final response = await http.get(Uri.parse(url));
      debugPrint('HTTP Response Status: ${response.statusCode}');
      debugPrint('HTTP Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint('Parsed JSON Data: $data');

        if (data['status'] == 'OK' && data['results'] != null && data['results'].isNotEmpty) {
          final components = data['results'][0]['address_components'] as List;
          final address = data['results'][0]['formatted_address'] ?? '';
          debugPrint('Address Components: $components');
          debugPrint('Formatted Address: $address');

          // New variables for short address
          String? landmark;
          String? city;

          for (var component in components) {
            final types = component['types'] as List;
            final longName = component['long_name'];

            debugPrint('Component: types=$types, long_name=$longName');

            // Set controllers for known address parts
            if (types.contains('locality')) {
              cityController.text = longName ?? '';
              city ??= longName;
              debugPrint('Assigned to cityController: $longName');
            } else if (types.contains('administrative_area_level_2')) {
              localityController.text = longName ?? '';
              debugPrint('Assigned to localityController: $longName');
            } else if (types.contains('administrative_area_level_1')) {
              stateController.text = longName ?? '';
              debugPrint('Assigned to stateController: $longName');
            } else if (types.contains('postal_code')) {
              pinCodeController.text = longName ?? '';
              debugPrint('Assigned to pinCodeController: $longName');
            } else if (types.contains('country')) {
              countryName.value = longName ?? '';
              countryController.text = longName ?? '';
              debugPrint('Assigned to countryName and countryController: $longName');
            } else if (types.contains('sublocality_level_2')) {
              countryName.value = longName ?? '';
              debugPrint('Assigned to countryName (sublocality_level_2): $longName');
            }

            // Extract landmark/short address candidates
            if (types.contains('point_of_interest') ||
                types.contains('premise') ||
                types.contains('sublocality') ||
                types.contains('neighborhood')) {
              landmark ??= longName;
              debugPrint('Identified landmark: $landmark');
            }
          }

          // Final fallback to formatted address if needed
          if (address.isNotEmpty) {
            streetAddressController.text = address;
            debugPrint('Assigned to streetAddressController: $address');
          }

          // Assign lat/lng
          lat = latLng.latitude.toString();
          long = latLng.longitude.toString();
          debugPrint('Assigned lat: $lat, long: $long');

          // Compose custom short address

          if (landmark != null && city != null) {
            address_area.value = '$landmark, $city';
          } else if (landmark != null) {
            address_area.value = landmark!;
          } else if (city != null) {
            address_area.value = city!;
          }


          debugPrint('Custom Short Address: ${ address_area.value}');

          debugPrint(
            'Final Values: City: ${cityController.text}, '
                'District: ${localityController.text}, '
                'State: ${stateController.text}, '
                'Pincode: ${pinCodeController.text}, '
                'Country: ${countryName.value}, '
                'Short Address: ${ address_area.value}',
          );
        } else {
          debugPrint('Error: API status is ${data['status']}, results: ${data['results']}');
          if (data['error_message'] != null) {
            debugPrint('API Error Message: ${data['error_message']}');
          }
        }
      } else {
        debugPrint('Failed to fetch address. Status Code: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e, stackTrace) {
      debugPrint('Exception occurred: $e');
      debugPrint('Stack Trace: $stackTrace');
    }
  }

  Future<void> postProperty() async {
    print("postProperty()==>");
    String? userId = await SPManager.instance.getUserId(USER_ID);
    String? email = await SPManager.instance.getEmail(EMAIL) ?? "";
    String? contact = await SPManager.instance.getContact(CONTACT) ?? "";
    String? name = await SPManager.instance.getName(NAME) ?? "";

    String? userType = await SPManager.instance.getUserType(USER_TYPE) ?? "";
    print("userType==>${userType}");
    print("name==>${name}");
    int? free_count =
        await SPManager.instance.getFreePostCount(FREE_POST) ?? 0;
    int? paid_post =
        (await SPManager.instance.getPaidPostCount(PAID_POST)) ?? 0;
    int? plan_post =
        (await SPManager.instance.getPlanPostCount(PLAN_POST)) ?? 0;
    int? setting_count =
        (await SPManager.instance.getSetingPostCount(SETTING_POST)) ?? 0;
    String isPost =
        await SPManager.instance.getPostProperties(PostProperties) ??
            "no";
    String isfeatured = await SPManager.instance
        .getFeaturedProperties(FeaturedProperties) ??
        "no";
    int? featuredCount =
        (await SPManager.instance.getFeatureCount(PAID_FEATURE)) ?? 0;
    int? PlanfeaturedCount =
        (await SPManager.instance.getPlanFeatureCount(PLAN_FEATURE)) ?? 0;
    print('add_count==>');
    print(isPost);
    print(free_count);
    print(setting_count);

    try {

      // if (videoFile.value != null) {
      //   showVideoUploadDialog(Get.context!);
      // } else {
      //   showLoadingDialog1(Get.context!, 'Processing...');
      // }
      if (videoFile.value != null) {
        showVideoUploadDialog(Get.context!);
      } else {
        uploadProject(Get.context!, 'Processing...');
      }
      //showLoadingDialog1(Get.context!, 'Processing...');
      isLoading.value = true;
      Get.focusScope!.unfocus();

      XFile? xFile;
      if (coverImgs != null) {
        xFile = XFile(coverImgs.value!.path);
      }
      XFile? xFileVideo;
      if (videoFile.value != null) {
        xFileVideo = XFile(videoFile.value!.path);
      }

      var response = await HttpHandler.formDataMethod(
          url: APIString.postProperty,
          apiMethod: "POST",
          body: {
           //   "property_owner_type": userType??"",

            "user_id": userId ?? "",
            "property_name": propertyNameController.text,
            "building_type": categorytype.value,
            "property_type": propertytype.value,
            "user_type": userType??"",
            "block": TowerBlockController.text,
            "address": streetAddressController.text ?? '',
            "city_name": cityController.text ?? '',
            "country": countryName.value!=""?  countryName.value:"India",
            "state": stateController.text ?? '',
            "zip_code": pinCodeController.text ?? '',
            "latitude": lat ?? '',
            "longitude": long ?? '',
            // "property_price": propertyPriceController.value.text.isEmpty
            //     ? "0"
            //     : propertyPriceController.value.text,

            "property_price": CategoryPriceType.value == "Rent"?securityDepositController.text:propertyPriceController.value.text,

            // CategoryPriceType.value == "Rent"? propertyPriceController.value.text ?? '':securityDepositController.text,
            "property_description": aboutController.text,
            "bhk_type": bhkType.value == '' ? "" : bhkType.value,
            "bathroom": bathrrom.value == '' ? "" : bathrrom.value,
            "units": UnitController.value.text.isEmpty
                ? "0"
                : UnitController.value.text,
            "area": buildUpAreaController.text??"",
            "area_in": selectedsqfit.value ?? '',
            "area_type": selectedarea.value ?? '',
            "furnished_type": furnishType.value ?? '',
            "total_floor": totalFloorController.text,
            "property_floor": florController.text,
            "active_status": 'Active',
            "amenities": selectedamenities.join(','),
            "admin_approval": free_count!=0 && isPost=='no'?'Approved':'Approved',
            "connect_to_no": contact ?? "",
            "connect_to_name": name != '' ? name : 'unknown',
            "connect_to_email": email ?? "",
            "property_added_date":
                DateFormat('yyyy-MM-dd').format(DateTime.now()).toString(),
            "possession_status": selectedPossessionStatus.value ?? "",
            "age_of_property": AgeProperty.value ?? "",
            "covered_parking": CoveredParking.value ?? "",
            "balcony": selectedBalconyList.join(","),
            "power_backup": PoweBackup.value ?? "",
            "facing": Facing.value ?? "",
            "view": View.value ?? "",
            "flooring": Flooring.value ?? "",
            "lift_availability": LiftAvailability.value ?? "",
            "loan_availability": LiftAvailability.value ?? "",
            //"rent": CategoryPriceType.value == "Rent"?securityDepositController.text ?? '',
            "rent": CategoryPriceType.value == "Rent"? propertyPriceController.value.text ?? '':securityDepositController.text,
            "video_url_type": selectedVideoOption.value,
            "video_url": videoUrlController.text,
            "additional_rooms": selectedAdditionalRooms.join(','),
            "property_category_type": CategoryPriceType.value == "Sell"
                ? "Buy"
                : CategoryPriceType.value,
            "available_status": 'Available',
            "developer": develoeperController.text,
            "property_no": "",
            "office_space_type": OfficeSpaceType.value ?? "",
            "pantry": Pantry.value ?? "",
            "personal_washroom": PersonalWashroom.value ?? "",
            "ceiling_height": ceilingHeightController.text,
            "parking_availability": isParkingAvailable.value ?? '',
            "seat_type": selectedSeatsType.value ?? '',
            "number_of_seats_available": numberofSeatsAvailableController.text,
            "rent_duration": "", // mot available
            "maintenance_cost": "", // mot available
            "maintenance_frequency": "", // mot available
            "maintenance_included": "", // mot available
            // "security_deposit_type":securityDepositController.text, // mot available
            "custom_deposit_amount": securityDepositController.text ?? '',
            "available_for_company_lease": "", // mot available
            "available_for": selectedAvailableFor.value ?? '', // pg
            "suited_for": selectedSuitedFor.value ?? '', // pg
            "room_type": selectedRoomTypesList.join(','), // pg
            "food_available": pgFood.value ?? '', // pg
            "food_charges_included": foodCharges.value ?? '', //pg
            "notice_period": noticeDays.value ?? '', //pg
            "notice_period_other_days": "", //pg
            "electricity_charges_included": electricityCharges.value ?? '', //pg
            "total_beds": pgNoOfBedsController.text ?? '', //pg
            "pg_rules": selectedPGRulesList.join(','), //pg
            "gate_closing_time": gateClosingTime.value ?? '', //pg
            "gate_closing_hour": "", //pg
            "pg_services": pgSevicesController.text ?? '', //pg
            "min_lockin_period": miniumLockController.text,
            "dynamic_pricing": "",
           "virtual_tour_availability": isVirtualTourAvailable.value==true?'Yes':'No',
            "possession_date": possessionDateController.text ?? '',
            "flat_name": flatHouseNoController.text ?? '',
            "mark_as_featured": isFeatured.value == true ? "Yes" : 'No',

            "address_area":  address_area.value,
          },
          imageKey: "cover_image",
          imagePath: xFile?.path,
          videoKey: 'property_video',
          videoPath: xFileVideo?.path,
      );

      log('response----- ${response["body"]}');

      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          PropertyId = response['body']["data"]['_id'];
          isPropertyPosted = true;


          print('picked image count : ${images1.length}');

          for (var file in images1) {
            if (file != null) {
              File imageFile = File(file.path);
              await addPropertyImages(
                id: PropertyId,
                image: imageFile,
              );
            } else {
              print('file is empty');
            }
          }

          if( isPost =='no'){
            if( free_count != 0){
              int count = free_count-1;
              await SPManager.instance.setFreePostCount(FREE_POST, count);

              print('testing--');
              print(free_count);
            }
          }
          else {
            print('paidCount--');
            print(paid_post);
            print(plan_post);
            if (paid_post <= plan_post) {
              int count = paid_post - 1;
              await SPManager.instance.setPaidPostCount(PAID_POST, count);
              print('testing--');
              print(paid_post);
            }
          }

          if (isFeatured.value == true) {
            print('isFeatured-->');
            print(featuredCount);
            print(PlanfeaturedCount);
            if (isfeatured == 'yes') {
              if (featuredCount <= PlanfeaturedCount) {
                int count = featuredCount - 1;
                await SPManager.instance
                    .setFeatureCount(FREE_POST, count);
                print('testing--');
                print(free_count);
              }
            }
          };
          print('wanting for navigation');
          isLoading.value = false;
          hideLoadingDialog();
          Get.offAll(() => MyProperties(isFrom: 'post',));
          print('navigate successfully');
          //Fluttertoast.showToast(msg: "Property details added successfully!!!");
        } else {
          //Fluttertoast.showToast(msg: response['body']['msg'].toString());
        }
      } else {
        var responseBody = json.decode(response['body']);
        ////Fluttertoast.showToast(msg: responseBody['msg']);
      }
    } catch (e, s) {
      debugPrint("postProperty Error -- $e  $s");
    } finally {
      isLoading.value = false;
      hideLoadingDialog();
      // Get.to(() =>  MyProperties());
      // if (Navigator.canPop(Get.context!)) {
      //   Navigator.of(Get.context!).pop();
      // }
    }
  }

  Future<void> deleteProjectProperty({String? id}) async {
    showHomLoading(Get.context!, 'Processing...');
    try {
      var response = await HttpHandler.deleteHttpMethod(
        url: APIString.remove_project_property,
        data: {
          'project_property_id': id,
        },
      );
      if (response['error'] == null) {
        //   getPropertyProject(id!);
      } else if (response['error'] != null) {
        var responseBody = json.decode(response['body']);
        //Fluttertoast.showToast(msg: responseBody['msg']);
      }
    } catch (e) {
      debugPrint("Login Error: $e");
      //Fluttertoast.showToast(msg: 'An error occurred. Please try again.');
    } finally {
      isLoading.value = false;
      hideLoadingDialog();
    }
  }

  Future<void> postProjectProperty({
    required String project_id,
    required String price,
    required String bhk,
    required String area,
    required String area_in,
    required String area_type,
    required XFile xFile,
    required String isfrom,
  }) async {
    try {


      var response = await HttpHandler.formDataMethod(
        url: APIString.add_project_property,
        apiMethod: "POST",
        body: {
          //   project_id, price,bhk,area,area_in,area_type,image
          //   "property_owner_type": userType??"",
          "project_id": project_id ?? '',
          "price": price ?? '',
          "bhk": bhk ?? '',
          "area": area ?? '',
          "area_in": area_in ?? '',
          "area_type": area_type ?? '',
        },
        imageKey: "image",
        imagePath: xFile.path,
      );

      log('response----- ${response["body"]}');

      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          if (isfrom == "edit") {
            getPropertyProject(project_id);
            print("Property in prject suucessfully added");
          }
          print("Property in prject suucessfully added");
        } else {
          if (isfrom == "edit") {
            getPropertyProject(project_id);
            print("Property in prject suucessfully added");
          }
        }
      } else {
        var responseBody = json.decode(response['body']);
        ////Fluttertoast.showToast(msg: responseBody['msg']);
      }
    } catch (e, s) {
      debugPrint("postProperty Error -- $e  $s");
    } finally {
      isLoading.value = false;
      // hideLoadingDialog();
      // if (Navigator.canPop(Get.context!)) {
      //   Navigator.of(Get.context!).pop();
      // }
    }
  }

  Future<void> postProject() async {
    String? userId = await SPManager.instance.getUserId(USER_ID);
    String? email = await SPManager.instance.getEmail(EMAIL) ?? "";
    String? contact = await SPManager.instance.getContact(CONTACT) ?? "";
    String? name = await SPManager.instance.getName(NAME) ?? "";



    String isMarkDeveloper = await SPManager.instance
        .getMarkAs(MARKAS) ??
        "no";
    int? paidMarks =
        (await SPManager.instance.getMarkDeveloperCount(PAID_MARKDEVELOPER)) ?? 0;
    int? PlanMarkCount =
        (await SPManager.instance.getPlanMarkCount(PLAN_MARKDEVELOPER)) ?? 0 ;

    try {
      // showLoadingDialog1(Get.context!, 'Processing...');
      if (videoFile.value != null) {
        showVideoUploadDialog(Get.context!);
      } else {
        uploadProject(Get.context!, 'Processing...');
      }

      isLoading.value = true;
      Get.focusScope!.unfocus();

      XFile? xFile;
      final cover = coverImgs?.value;
      if (cover != null) {
        xFile = XFile(cover.path);
      }

      XFile? xFileVideo;
      final video = videoFile.value;
      if (video != null) {
        xFileVideo = XFile(video.path);
      }

      XFile? pdfXfile;
      final pdf = pdfFile?.value;
      if (pdf != null) {
        pdfXfile = XFile(pdf.path);
      }

      XFile? logoXfile;
      final logo = logoImgs?.value;
      if (logo != null) {
        logoXfile = XFile(logo.path);
      }

      var response = await HttpHandler.formDataMethod(
          url: APIString.post_project,
          apiMethod: "POST",
          body: {
            "user_id": userId ?? "",
            "latitude": lat ?? "",
            "longitude": long ?? "",
            "admin_approval": 'Approved',
            "block": flatHouseNoController.text,
            "project_name": propertyNameController.text,
            "building_type": categorytype.value,
            "project_type": propertytype.value,
            "address": streetAddressController.text,
            "country": countryName.value!=""?  countryName.value:"India",
            "state": stateController.text,
            "city_name": cityController.text,
            "zip_code": pinCodeController.text,
            "project_price": propertyPriceController.value.text.isEmpty
                ? "0"
                : propertyPriceController.value.text,
            "bhk": bhkType.value,
            "area": buildUpAreaController.text,
            "area_in": buildUpAreaController.text,
            "area_type": selectedarea.value ?? '',
            "average_project_price": avgProjectPriceController.text,
            "congfigurations": configurationController.text,
            "launch_date": launchDateController.text,
            "possession_start": possessionDateController.text,
            "construction_status": selectedConstructionStatus.value ?? '',
            "rera_id": reraIDController.text??"",
            "floor_living_dining":LivingController.text,
            "floor_kitchen_toilet": KitchenController.text,
            "floor_bedroom": BedroomController.text,
            "floor_balcony": BalconyController.text,
            "walls_living_dining": DiningController.text,
            "walls_kitchen_toilet": ToiletsConroller.text,
            "walls_servant_room": ServantConroller.text,
            "ceiling": ceilingLivingController.text,
            "ceilings_servant_room": ceilingServantController.text,
            "counters_kitchen_toilet": counterKitchenController.text,
            "fittings_fixtures_kitchen_toilet": fittingKitchenController.text,
            "fittings_fixtures_servant_room_toilet": fittingToiletController.text,
            "door_window_internal_door": internalDoorController.text,
            "door_window_external_glazing": externalGlazingController.text,
            "electrical": electricalController.text,
            "backup": backupController.text,
            "security_system": securitySystemController.text,
            "internal_door": internalDoorController.text,
            "external_glazings": ExternalGlazingController.text,
            "about_project": aboutController.text,
            "amenities": selectedamenities.join(','),
            "connect_to_name": name.isNotEmpty ? name : 'unknown',
            "connect_to_no": contact,
            "connect_to_email": email,
            "active_status": 'Active',
            "available_status": 'Available',
            "rating": '0',
            "video_url_type": selectedVideoOption.value,
            "video_url": videoUrlController.text,
            "project_description": aboutController.text,
            "mark_as_featured": isFeatured.value == true ? "Yes" : 'No',

            "address_area":  address_area.value,
            "virtual_tour_availability": isVirtualTourAvailable.value==true?'Yes':'No',
          },
          imageKey: "cover_image",
          imagePath: xFile?.path,
          videoKey: 'property_video',
          videoPath: xFileVideo?.path,
          pdfKey: 'brochure_doc',
          pdfFile: pdfXfile?.path,
        logoKey: 'logo',
        logoPath: logoXfile?.path

      );

      log('response----- ${response["body"]}');

      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          PropertyId = response['body']["data"]['_id'];
          isPropertyPosted = true;

          // Upload images
          for (var file in images1) {
            if (file != null) {
              File imageFile = File(file.path);
              await addProjectImages(id: PropertyId, image: imageFile);
            }
          }

          await Future.forEach(priceDetailsList, (item) async {
            print('BHK Type: ${item.bhkType}');
            await postProjectProperty(
              project_id: PropertyId,
              price: item.price,
              bhk: item.bhkType,
              area: item.builtUpArea,
              area_in: item.areaIn,
              area_type: item.areaType,

              isfrom: '',
              xFile: XFile(item.images[0].path),
            );
          });
          String  Project= (await SPManager.instance.getUpcomingProjects(UpcomingProjects))??"no";
         int projectCount =  await SPManager.instance.getProjectCount(PAID_PROJECT) ?? 0;


          if( Project =='yes'){
            print('paidCount--');
            print(projectCount);
            print(projectCount);
            if (projectCount > 0) {
              int count = projectCount - 1;
              await SPManager.instance.setProjectCount(PAID_PROJECT, count);
              print('testing--');
              print(count);
          }}

          if (isFeatured.value == true) {
            print('isFeatured-->');
            print(isMarkDeveloper);
            print(PlanMarkCount);
            if (isMarkDeveloper == 'yes') {
              if (paidMarks <= PlanMarkCount) {
                int count = paidMarks - 1;
                await SPManager.instance
                    .setMarkDeveloperCount(PAID_MARKDEVELOPER, count);
                print('testing--');
                print(paidMarks);
              }
            }
          }

          isLoading.value = false;
          isUploading.value = false;
          hideLoadingDialog();
          Get.offAll(() => MyProjects(isFrom: 'post',));
          //Fluttertoast.showToast(msg: "Project details added successfully!!!");
        } else {
          //Fluttertoast.showToast(msg: response['body']['msg'].toString());
        }
      } else {
        var responseBody = json.decode(response['body']??"");
      }
    } catch (e, s) {
      debugPrint("post Project Error -- $e  $s");
    } finally {
      isLoading.value = false;
      hideLoadingDialog();
      if (Navigator.canPop(Get.context!)) {
        Navigator.of(Get.context!).pop();
      }
    }
  }


///using Dio Pavkage

  // Future<void> postProject() async {
  //   String? userId = await SPManager.instance.getUserId(USER_ID);
  //   String? email = await SPManager.instance.getEmail(EMAIL) ?? "";
  //   String? contact = await SPManager.instance.getContact(CONTACT) ?? "";
  //   String? name = await SPManager.instance.getName(NAME) ?? "";
  //
  //   try {
  //     showLoadingDialog1(Get.context!, 'Processing...');
  //     isLoading.value = true;
  //     Get.focusScope?.unfocus();
  //
  //     d.Dio dio = d.Dio();
  //     d.FormData formData = d.FormData();
  //
  //     // Add fields
  //     formData.fields.addAll([
  //       MapEntry("user_id", userId ?? ""),
  //       MapEntry("latitude", lat ?? ""),
  //       MapEntry("longitude", long ?? ""),
  //       MapEntry("admin_approval", "Approved"),
  //       MapEntry("block", flatHouseNoController.text),
  //       MapEntry("project_name", propertyNameController.text),
  //       MapEntry("building_type", categorytype.value),
  //       MapEntry("project_type", propertytype.value),
  //       MapEntry("address", streetAddressController.text),
  //       MapEntry("country", countryName.value.isNotEmpty ? countryName.value : "India"),
  //       MapEntry("state", stateController.text),
  //       MapEntry("city_name", cityController.text),
  //       MapEntry("zip_code", pinCodeController.text),
  //       MapEntry("project_price", propertyPriceController.value.text.isEmpty ? "0" : propertyPriceController.value.text),
  //       MapEntry("bhk", bhkType.value),
  //       MapEntry("area", buildUpAreaController.text),
  //       MapEntry("area_in", buildUpAreaController.text),
  //       MapEntry("area_type", selectedarea.value ?? ''),
  //       MapEntry("average_project_price", avgProjectPriceController.text),
  //       MapEntry("congfigurations", configurationController.text),
  //       MapEntry("launch_date", launchDateController.text),
  //       MapEntry("possession_start", possessionDateController.text),
  //       MapEntry("construction_status", selectedConstructionStatus.value ?? ''),
  //       MapEntry("rera_id", reraIDController.text),
  //       MapEntry("floor_living_dining", LivingController.text),
  //       MapEntry("floor_kitchen_toilet", KitchenController.text),
  //       MapEntry("floor_bedroom", BedroomController.text),
  //       MapEntry("floor_balcony", BalconyController.text),
  //       MapEntry("walls_living_dining", DiningController.text),
  //       MapEntry("walls_kitchen_toilet", ToiletsConroller.text),
  //       MapEntry("walls_servant_room", ServantConroller.text),
  //       MapEntry("ceiling", ceilingLivingController.text),
  //       MapEntry("ceilings_servant_room", ceilingServantController.text),
  //       MapEntry("counters_kitchen_toilet", counterKitchenController.text),
  //       MapEntry("fittings_fixtures_kitchen_toilet", fittingKitchenController.text),
  //       MapEntry("fittings_fixtures_servant_room_toilet", fittingToiletController.text),
  //       MapEntry("door_window_internal_door", internalDoorController.text),
  //       MapEntry("door_window_external_glazing", externalGlazingController.text),
  //       MapEntry("electrical", electricalController.text),
  //       MapEntry("backup", backupController.text),
  //       MapEntry("security_system", securitySystemController.text),
  //       MapEntry("internal_door", internalDoorController.text),
  //       MapEntry("external_glazings", ExternalGlazingController.text),
  //       MapEntry("about_project", aboutController.text),
  //       MapEntry("amenities", selectedamenities.join(',')),
  //       MapEntry("connect_to_name", name.isNotEmpty ? name : 'unknown'),
  //       MapEntry("connect_to_no", contact),
  //       MapEntry("connect_to_email", email),
  //       MapEntry("active_status", 'Active'),
  //       MapEntry("available_status", 'Available'),
  //       MapEntry("rating", '0'),
  //       MapEntry("video_url_type", selectedVideoOption.value),
  //       MapEntry("video_url", videoUrlController.text),
  //     ]);
  //
  //     // Add files if exist
  //     if (coverImgs?.value != null) {
  //       formData.files.add(MapEntry(
  //         "cover_image",
  //         await d.MultipartFile.fromFile(coverImgs!.value!.path, filename: coverImgs!.value!.path.toString()),
  //       ));
  //     }
  //
  //     if (videoFile.value != null) {
  //       formData.files.add(MapEntry(
  //         "property_video",
  //         await d.MultipartFile.fromFile(videoFile.value!.path, filename: videoFile.value!.path.toString()),
  //       ));
  //     }
  //
  //     if (pdfFile?.value != null) {
  //       formData.files.add(MapEntry(
  //         "brochure_doc",
  //         await d.MultipartFile.fromFile(pdfFile!.value!.path, filename: pdfFile!.value!.path.toString()),
  //       ));
  //     }
  //
  //     if (logoImgs?.value != null) {
  //       formData.files.add(MapEntry(
  //         "logo",
  //         await d.MultipartFile.fromFile(logoImgs!.value!.path, filename: logoImgs!.value!.path.toString()),
  //       ));
  //     }
  //
  //     // Send request
  //     d.Response response = await dio.post(
  //       APIString.baseUrl+APIString.post_project,
  //       data: formData,
  //       options: d.Options(
  //         method: "POST",
  //         contentType: "multipart/form-data",
  //         headers: {
  //
  //         },
  //       ),
  //       onSendProgress: (sent, total) {
  //         print("Uploading: ${(sent / total * 100).toStringAsFixed(2)}%");
  //       },
  //     );
  //
  //     print('response: ${response.data}');
  //
  //     if (response.data["status"].toString() == "1") {
  //       PropertyId = response.data["data"]["_id"];
  //       isPropertyPosted = true;
  //
  //       for (var file in images1) {
  //         if (file != null) {
  //           await addProjectImages(id: PropertyId, image: File(file.path));
  //         }
  //       }
  //
  //       await Future.forEach(priceDetailsList, (item) async {
  //         await postProjectProperty(
  //           project_id: PropertyId,
  //           price: item.price,
  //           bhk: item.bhkType,
  //           area: item.builtUpArea,
  //           area_in: item.areaIn,
  //           area_type: item.areaType,
  //           isfrom: '',
  //         );
  //       });
  //
  //       isLoading.value = false;
  //       hideLoadingDialog();
  //       Get.offAll(() => MyProjects(isFrom: 'post'));
  //     } else {
  //       // Handle API-level failure
  //       print("Error: ${response.data['msg']}");
  //     }
  //   } catch (e, s) {
  //     print("Upload failed: $e\n$s");
  //   } finally {
  //     isLoading.value = false;
  //     hideLoadingDialog();
  //     if (Navigator.canPop(Get.context!)) {
  //       Navigator.of(Get.context!).pop();
  //     }
  //   }
  // }


  Future<void> editProject({String? property_id}) async {
    String? userId = await SPManager.instance.getUserId(USER_ID);
    String? email = await SPManager.instance.getEmail(EMAIL) ?? "";
    String? contact = await SPManager.instance.getContact(CONTACT) ?? "";
    String? name = await SPManager.instance.getName(NAME) ?? "";

    try {
      showHomLoading(Get.context!, 'Processing...');
      isLoading.value = true;
      Get.focusScope!.unfocus();

      XFile? xFile;
      if (coverImgs.value != null) {
        xFile = XFile(coverImgs.value!.path);
      }
      XFile? xFileVideo;
      if (videoFile.value != null) {
        xFileVideo = XFile(videoFile.value!.path);
      }
      var response = await HttpHandler.formDataMethod(
          url: APIString.edit_project,
          apiMethod: "POST",
          body: {
            "project_id": property_id!,
            "user_id": userId ?? "",
            "block": flatHouseNoController.text,
            "admin_approval": 'Approved',
            "project_name": propertyNameController.text,
            // "building_type": categorytype.value,
            "building_type":"Residential",
            "project_type": propertytype.value,
            "address": streetAddressController.text,
            "country": countryName.value!=""?  countryName.value:"India",
            "state": stateController.text,
            "city_name": cityController.text,
            "zip_code": pinCodeController.text,
            "project_price": propertyPriceController.value.text.isEmpty
                ? "0"
                : propertyPriceController.value.text,
            "bhk": bhkType.value,
            "area": buildUpAreaController.text,
            "area_in": buildUpAreaController.text,
            "area_type": selectedarea.value ?? '',
            "average_project_price": avgProjectPriceController.text,
            "congfigurations": configurationController.text,
            "launch_date": launchDateController.text,
            "possession_start": possessionDateController.text,
            "construction_status": selectedConstructionStatus.value ?? '',
            "rera_id": reraIDController.text??"",
            "floor_living_dining":LivingController.text,
            "floor_kitchen_toilet": KitchenController.text,
            "floor_bedroom": BedroomController.text,
            "floor_balcony": BalconyController.text,
            "walls_living_dining": DiningController.text,
            "walls_kitchen_toilet": ToiletsConroller.text,
            "walls_servant_room": ServantConroller.text,
            "ceiling": ceilingLivingController.text,
            "ceilings_servant_room": ceilingServantController.text,
            "counters_kitchen_toilet": counterKitchenController.text,
            "fittings_fixtures_kitchen_toilet": fittingKitchenController.text,
            "fittings_fixtures_servant_room_toilet": fittingToiletController.text,
            "door_window_internal_door": internalDoorController.text,
            "door_window_external_glazing": externalGlazingController.text,
            "electrical": electricalController.text,
            "backup": backupController.text,
            "security_system": securitySystemController.text,
            "internal_door": internalDoorController.text,
            "external_glazings": ExternalGlazingController.text,
            "about_project": aboutController.text,
            "amenities": selectedamenities.join(','),
            "connect_to_name": name.isNotEmpty ? name : 'unknown',
            "connect_to_no": contact,
            "connect_to_email": email,
            "active_status": 'Active',
            "available_status": 'Available',
            "rating": '0',
            "video_url_type": selectedVideoOption.value,
            "video_url": videoUrlController.text,
            "project_description": aboutController.text,
            "mark_as_featured": isFeatured.value == true ? "Yes" : 'No',

            "address_area":  address_area.value,
            "virtual_tour_availability": isVirtualTourAvailable.value==true?'Yes':'No',
            // "admin_approval": 'Approved',
            // "project_name": propertyNameController.text,
            // "building_type": categorytype.value,
            // "project_type": propertytype.value,
            // "address": streetAddressController.text,
            // "country": countryName.value!=""?  countryName.value:"India",
            // "state": stateController.text,
            // "city_name": cityController.text,
            // "zip_code": pinCodeController.text,
            // "project_price": propertyPriceController.value.text.isEmpty
            //     ? "0"
            //     : propertyPriceController.value.text,
            // "bhk": bhkType.value,
            // "area": buildUpAreaController.text,
            // "area_in": buildUpAreaController.text,
            // "area_type": selectedarea.value ?? '',
            // "total_unit": '1',
            // "average_project_price": avgProjectPriceController.text,
            // "congfigurations": configurationController.text,
            // "launch_date": '',
            // "possession_starts": '',
            // "construction_status": selectedConstructionStatus.value ?? '',
            // "rera_id": '',
            // "living_dining": LivingController.text,
            // "kitchen_toilets": KitchenController.text,
            // "bedroom": BedroomController.text,
            // "balcony": BalconyController.text,
            // "servant_room": '',
            // "ceilings": '',
            // "servant_room_toilet": '',
            // "internal_door": internalDoorController.text,
            // "external_glazings": ExternalGlazingController.text,
            // "electrical": elertricalController.text,
            // "backup": backupController.text,
            // "security_system": securitySystemController.text,
            // "about_project": aboutController.text,
            // "amenities": selectedamenities.join(','),
            // "connect_to_name": name.isNotEmpty ? name : 'unknown',
            // "connect_to_no": contact,
            // "connect_to_email": email,
            // "active_status": 'Active',
            // "available_status": 'Available',
            // "virtual_tour_availability": isVirtualTourAvailable.value==true?'Yes':'No',
            // "rating": '0',
            // "video_url_type": selectedVideoOption.value,
            // "video_url": videoUrlController.text,
            // "flat_name": flatHouseNoController.text ?? '',
            // "project_description": aboutController.text,
            // "mark_as_featured": isFeatured.value == true ? "Yes" : 'No',
            //
            // "address_area":  address_area.value,
          },
          imageKey: "upload_photo",
          imagePath: xFile?.path,
          videoKey: 'property_video',
          videoPath: xFileVideo?.path);

      log('response----- ${response["body"]}');

      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          //  PropertyId = response['body']["data"]['_id'];
          isPropertyPosted = true;

          //Upload images
          for (var file in images1) {
            if (file != null) {
              File imageFile = File(file.path);
              await addProjectImages(id: property_id, image: imageFile);
            }
          }

          // await Future.forEach(priceDetailsList, (item) async {
          //   print('BHK Type: ${item.bhkType}');
          //   await postProjectProperty(
          //     project_id: property_id!,
          //     price: item.price,
          //     bhk: item.bhkType,
          //     area: item.builtUpArea,
          //     area_in: item.areaIn,
          //     area_type: item.areaType,
          //     isfrom: '',
          //     xFile: XFile(item.images[0].path),
          //   );
          // });
          Get.back();
          //Fluttertoast.showToast(msg: "Project details updated successfully!!!");
        } else {
          //Fluttertoast.showToast(msg: response['body']['msg'].toString());
        }
      } else {
        var responseBody = json.decode(response['body']);
      }
    } catch (e, s) {
      debugPrint("post Project Error -- $e  $s");
    } finally {
      isLoading.value = false;
      hideLoadingDialog();
      if (Navigator.canPop(Get.context!)) {
        Navigator.of(Get.context!).pop();
      }
    }
  }

  Future<void> editProperty({String? property_id, int? index}) async {
    String? userId = await SPManager.instance.getUserId(USER_ID);
    String? email = await SPManager.instance.getEmail(EMAIL) ?? "";
    String? contact = await SPManager.instance.getContact(CONTACT) ?? "";
    String? name = await SPManager.instance.getName(NAME) ?? "";
    String? userType = await SPManager.instance.getUserType(USER_TYPE) ?? "";
    try {
      showHomLoading(Get.context!, 'Processing...');
      isLoading.value = true;
      Get.focusScope!.unfocus();

      // XFile? xFile;
      // if (coverImgs != null) {
      //   xFile = XFile(coverImgs.value!.path);
      // }
      // XFile? xFileVideo;
      // if (videoFile.value != null) {
      //   xFileVideo = XFile(videoFile.value!.path);
      // }

      XFile? xFile;
      if (coverImgs != null && coverImgs.value != null) {
        xFile = XFile(coverImgs.value!.path);
      }

      XFile? xFileVideo;
      if (videoFile != null && videoFile.value != null) {
        xFileVideo = XFile(videoFile.value!.path);
      }

      var response = await HttpHandler.formDataMethod(
          url: APIString.editProperty,
          apiMethod: "POST",
          body: {
            //   "property_owner_type": userType??"",
            "property_id": property_id!,
            "user_id": userId ?? "",
            "property_name": propertyNameController.text,
            "property_category_type": CategoryPriceType.value,
            "building_type": categorytype.value,
            "property_type": propertytype.value,
            "user_type": userType??"",
            "address": streetAddressController.text ?? '',
            "city_name": cityController.text ?? '',
            "country": countryName.value!=""?  countryName.value:"India",
            "state": stateController.text ?? '',
            "zip_code": pinCodeController.text ?? '',
            "latitude": lat ?? '',
            "longitude": long ?? '',
            "property_price": propertyPriceController.value.text.isEmpty
                ? "0"
                : propertyPriceController.value.text,
            "property_description": aboutController.text,
            "bhk_type": bhkType.value == '' ? "" : bhkType.value,
            "bathroom": bathrrom.value == '' ? "" : bathrrom.value,
            "units": UnitController.value.text.isEmpty
                ? "0"
                : UnitController.value.text,
            "area": buildUpAreaController.text,
            "area_in": selectedsqfit.value ?? '',
            "area_type": selectedarea.value ?? '',
            "furnished_type": furnishType.value ?? '',
            "total_floor": totalFloorController.text,
            "property_floor": florController.text,
            "active_status": 'Active',
            "amenities": selectedamenities.join(','),
            "admin_approval": 'Approved',
            "connect_to_no": contact ?? "",
            "connect_to_name": name != '' ? name : 'unknown',
            "connect_to_email": email ?? "",
            "property_added_date":
                DateFormat('yyyy-MM-dd').format(DateTime.now()).toString(),
            "possession_status": selectedPossessionStatus.value ?? "",
            "age_of_property": AgeProperty.value ?? "",
            "covered_parking": CoveredParking.value ?? "",
            "balcony": selectedBalconyList.join(","),
            "power_backup": PoweBackup.value ?? "",
            "facing": Facing.value ?? "",
            "view": View.value ?? "",
            "flooring": Flooring.value ?? "",
            "lift_availability": LiftAvailability.value ?? "",
            "loan_availability": LiftAvailability.value ?? "",
            "rent": securityDepositController.text ?? '',

            "video_url_type": selectedVideoOption.value,
            "video_url": videoUrlController.text,
            "additional_rooms": selectedAdditionalRooms.join(','),
            "property_category_type": CategoryPriceType.value == "Sell"
                ? "Buy"
                : CategoryPriceType.value,
            "available_status": statusController.text ?? '',
            "property_no": "",
            "office_space_type": OfficeSpaceType.value ?? "",
            "pantry": Pantry.value ?? "",
            "personal_washroom": PersonalWashroom.value ?? "",
            "ceiling_height": ceilingHeightController.text,
            "parking_availability": isParkingAvailable.value ?? '',
            "seat_type": selectedSeatsType.value ?? '',
            "number_of_seats_available": numberofSeatsAvailableController.text,
            "rent_duration": "", // mot available
            "maintenance_cost": "", // mot available
            "maintenance_frequency": "", // mot available
            "maintenance_included": "", // mot available
            // "security_deposit_type":securityDepositController.text ?? '',
            "custom_deposit_amount": securityDepositController.text ?? '',
            "available_for_company_lease": "", // mot available
            "available_for": selectedAvailableFor.value ?? '', // pg
            "suited_for": selectedSuitedFor.value ?? '', // pg
            "room_type": selectedRoomTypesList.join(','), // pg
            "food_available": pgFood.value ?? '', // pg
            "food_charges_included": foodCharges.value ?? '', //pg
            "notice_period": noticeDays.value ?? '', //pg
            "notice_period_other_days": "", //pg
            "electricity_charges_included": electricityCharges.value ?? '', //pg
            "total_beds": pgNoOfBedsController.text ?? '', //pg
            "pg_rules": selectedPGRulesList.join(','), //pg
            "gate_closing_time": gateClosingTime.value ?? '', //pg
            "gate_closing_hour": "", //pg
            "pg_services": selectedPGServiceList.join(','), //pg


            "min_lockin_period": miniumLockController.text,
            "dynamic_pricing": "",

            "possession_date": possessionDateController.text ?? '',
            "mark_as_featured": isFeatured.value == true ? "Yes" : 'No',
            "address_area":  address_area.value,
            "virtual_tour_availability": isVirtualTourAvailable.value==true?'Yes':'No',
            "block": TowerBlockController.text,
          },
          imageKey: "cover_image",
          imagePath: xFile?.path,
          videoKey: 'property_video',
          videoPath: xFileVideo?.path);

      log('response----- ${response["body"]}');

      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          // PropertyId=response['body']["data"]['_id'];
          isPropertyPosted = true;

          int? free_count =
              await SPManager.instance.getFreePostCount(FREE_POST) ?? 0;
          int? paid_post =
              (await SPManager.instance.getPaidPostCount(PAID_POST)) ?? 0;
          int? plan_post =
              (await SPManager.instance.getPlanPostCount(PLAN_POST)) ?? 0;
          int? setting_count =
              (await SPManager.instance.getSetingPostCount(SETTING_POST)) ?? 0;
          String isPost =
              await SPManager.instance.getPostProperties(PostProperties) ??
                  "no";
          String isfeatured = await SPManager.instance
                  .getFeaturedProperties(FeaturedProperties) ??
              "no";
          int? featuredCount =
              (await SPManager.instance.getFeatureCount(PAID_FEATURE)) ?? 0;
          int? PlanfeaturedCount =
              (await SPManager.instance.getPlanFeatureCount(PLAN_FEATURE)) ?? 0;
          print('add_count==>');
          print(isPost);
          print(free_count);
          print(setting_count);
          print('picked image count : ${images1.length}');

          for (var file in images1) {
            if (file != null) {
              File imageFile = File(file.path);
              await addPropertyImages(
                id: property_id,
                image: imageFile,
              );
            } else {
              print('file is empty');
            }
          }

          if (isPost == 'no') {
            if (free_count <= setting_count) {
              int count = free_count + 1;
              searcontroller
                  .add_count(isfrom: 'free_post', count: count)
                  .then((value) async {
                await SPManager.instance
                    .setFreePostCount(FREE_POST, free_count + 1);
              });
              print('testing--');
              print(free_count);
            }
          } else {
            print('paidCount--');
            print(paid_post);
            print(plan_post);
            if (paid_post <= plan_post) {
              int count = paid_post + 1;
              searcontroller
                  .add_count(isfrom: 'paid_post', count: count)
                  .then((value) async {
                await SPManager.instance.setPaidPostCount(PAID_POST, count);
              });
              print('testing--');
              print(paid_post);
            }
          }

          if (isFeatured == true) {
            print('isFeatured-->');
            print(featuredCount);
            print(PlanfeaturedCount);
            if (isfeatured == 'yes') {
              if (featuredCount <= PlanfeaturedCount) {
                int count = featuredCount + 1;
                searcontroller
                    .add_count(isfrom: 'feature', count: count)
                    .then((value) async {
                  await SPManager.instance
                      .setFeatureCount(FREE_POST, featuredCount + 1);
                });
                print('testing--');
                print(free_count);
              }
            }
          }

          //Get.back(result: {'property_id': property_id, 'index': index});

          //Fluttertoast.showToast( msg: "Property details updated successfully!!!");
        } else {
          //Fluttertoast.showToast(msg: response['body']['msg'].toString());
        }
      } else {
        var responseBody = json.decode(response['body']);
        ////Fluttertoast.showToast(msg: responseBody['msg']);
      }
    } catch (e, s) {
      debugPrint("postProperty Error -- $e  $s");
    } finally {
      isLoading.value = false;
      hideLoadingDialog();
      // if (Navigator.canPop(Get.context!)) {
      //   Navigator.of(Get.context!).pop();
      // }
    }
  }

  Future<void> getAmenities() async {
    String? userId = await SPManager.instance.getUserId(USER_ID);
    getAmenitiesList.clear();

    try {
      var response = await HttpHandler.postHttpMethod(
        url: APIString.get_amenities,
        data: {
          'user_id': '',
        },
      );

      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          log("response[data]  ---- ${response['body']["data"]}");
          var respData = response['body'];

          // getAmenitiesList.add(response['body']["data"]);
          getAmenitiesList.value = respData["data"];

          ////Fluttertoast.showToast(msg: 'Fetch successfully');
        }
      } else if (response['error'] != null) {
        // var responseBody = json.decode(response['body']);
        // //Fluttertoast.showToast(msg: responseBody['msg']);
      }
    } catch (e) {
      debugPrint("Login Error: $e");
      //  //Fluttertoast.showToast(msg: 'An error occurred. Please try again.');
    }
  }

  Future<void> getPropertyProject(String project_id) async {
    getProjectPropertyList.clear();

    try {
      var response = await HttpHandler.postHttpMethod(
        url: APIString.get_project_property,
        data: {
          'project_id': project_id,
        },
      );

      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          log("response[data]  ---- ${response['body']["data"]}");
          var respData = response['body'];

          // getAmenitiesList.add(response['body']["data"]);
          getProjectPropertyList.value = respData["data"];

          ////Fluttertoast.showToast(msg: 'Fetch successfully');
        }
      } else if (response['error'] != null) {
        // var responseBody = json.decode(response['body']);
        // //Fluttertoast.showToast(msg: responseBody['msg']);
      }
    } catch (e) {
      debugPrint("Login Error: $e");
      //  //Fluttertoast.showToast(msg: 'An error occurred. Please try again.');
    }
  }

  Future<void> addAmenities({String? name, var image}) async {
    String? userId = await SPManager.instance.getUserId(USER_ID);

    try {
      showHomLoading(Get.context!, 'Processing...');
      isLoading.value = true;
      Get.focusScope!.unfocus();
      XFile? xFile;
      if (image != null) {
        xFile = XFile(image.path);
      }
      var response = await HttpHandler.formDataMethod(
        url: APIString.addPropertyAmenities,
        apiMethod: "POST",
        body: {
          "amenity_name": name!,
          "user_id": userId!,
        },
        imageKey: "amenity_icon",
        imagePath: xFile?.path,
      );
      log('response----- ${response["body"]}');

      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          //Fluttertoast.showToast(msg: response['body']['msg'].toString());
          amenetiesName.clear();
          iconImg = null;
          getAmenities();
          Navigator.of(Get.context!).pop();
          isLoading.value = false;
        } else if (response['body']['status'].toString() == "0") {
          //Fluttertoast.showToast(msg: response['body']['msg'].toString());
        }
      } else if (response['error'] != null) {
        var responseBody = json.decode(response['body']);
        //Fluttertoast.showToast(msg: responseBody['msg']);
      }
    } catch (e, s) {
      debugPrint("updateProfile Error -- $e  $s");
    } finally {
      isLoading.value = false;

      if (Navigator.canPop(Get.context!)) {
        Navigator.of(Get.context!).pop();
      }
    }
  }

  Future<void> removeAmenities({String? id}) async {
    try {
      var response = await HttpHandler.deleteHttpMethod(
        url: APIString.removePropertyAmenity,
        data: {
          'property_amenity_id': id,
        },
      );
      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          getAmenities();
          //Fluttertoast.showToast(msg: 'Successfully deleted');
        }
      } else if (response['error'] != null) {
        var responseBody = json.decode(response['body']);
        //Fluttertoast.showToast(msg: responseBody['msg']);
      }
    } catch (e) {
      debugPrint("Login Error: $e");
      //Fluttertoast.showToast(msg: 'An error occurred. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addPropertyImages({String? id, var image}) async {
    try {
      print('add property image api calling....');
      Get.focusScope!.unfocus();
      XFile? xFile;
      if (image != null) {
        xFile = XFile(image.path);
      }
      var response = await HttpHandler.formDataMethod(
        url: APIString.addPropertyImages,
        apiMethod: "POST",
        body: {
          //"property_id": id!,
          "property_id": id!,
        },
        imageKey: "property_image",
        imagePath: xFile?.path,
      );
      log('response----- ${response["body"]}');
      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          //Fluttertoast.showToast(msg: response['body']['msg'].toString());
          pickedFiles.clear();
          getPropertyImage(id: id);
          print('property image added successfully');
        } else if (response['body']['status'].toString() == "0") {
          print('ERROR while adding property image code 0');
          //Fluttertoast.showToast(msg: response['body']['msg'].toString());
        }
      } else if (response['error'] != null) {
        print('ERROR while adding property image ');
        var responseBody = json.decode(response['body']);
        //Fluttertoast.showToast(msg: responseBody['msg']);
      }
    } catch (e, s) {
      debugPrint("updateProfile Error -- $e  $s");
    }
  }

  Future<void> addProjectImages({String? id, var image}) async {
    try {
      print('add property image api calling....');
      Get.focusScope!.unfocus();
      XFile? xFile;
      if (image != null) {
        xFile = XFile(image.path);
      }
      var response = await HttpHandler.formDataMethod(
        url: APIString.add_project_images,
        apiMethod: "POST",
        body: {
          "project_id": id!,
        },
        imageKey: "project_image",
        imagePath: xFile?.path,
      );
      log('response----- ${response["body"]}');
      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          //Fluttertoast.showToast(msg: response['body']['msg'].toString());
          pickedFiles.clear();
          getPropertyImage(id: id);
          print('property image added successfully');
        } else if (response['body']['status'].toString() == "0") {
          print('ERROR while adding property image code 0');
          //Fluttertoast.showToast(msg: response['body']['msg'].toString());
        }
      } else if (response['error'] != null) {
        print('ERROR while adding property image ');
        var responseBody = json.decode(response['body']);
        //Fluttertoast.showToast(msg: responseBody['msg']);
      }
    } catch (e, s) {
      debugPrint("updateProfile Error -- $e  $s");
    }
  }

  Future<void> removePropertyImages({String? id, String? p_id}) async {
    try {
      var response = await HttpHandler.deleteHttpMethod(
        url: APIString.removePropertyImage,
        data: {
          'property_image_id': id,
        },
      );
      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          //Fluttertoast.showToast(msg: 'Successfully deleted');
          getPropertyImageList.removeWhere((image) => image['_id'] == id);
        }
      } else if (response['error'] != null) {
        var responseBody = json.decode(response['body']);
        //Fluttertoast.showToast(msg: responseBody['msg']);
      }
    } catch (e) {
      debugPrint(" Error: $e");
      //Fluttertoast.showToast(msg: 'An error occurred. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> removeProjectImages({String? id, String? p_id}) async {
    try {
      var response = await HttpHandler.deleteHttpMethod(
        url: APIString.removePropertyImage,
        data: {
          'project_image_id, ': id,
        },
      );
      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          //Fluttertoast.showToast(msg: 'Successfully deleted');
          getPropertyImageList.removeWhere((image) => image['_id'] == id);
        }
      } else if (response['error'] != null) {
        var responseBody = json.decode(response['body']);
        //Fluttertoast.showToast(msg: responseBody['msg']);
      }
    } catch (e) {
      debugPrint(" Error: $e");
      //Fluttertoast.showToast(msg: 'An error occurred. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getProperty() async {
    getPropertyList.clear();
    try {
      var response = await HttpHandler.postHttpMethod(
        url: APIString.get_property_list,
      );
      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          log("response[data]  ---- ${response['body']["data"]}");
          var respData = response['body'];
          getPropertyList.value = respData["data"];
          print('my property list count : ${getPropertyList.length}');
        }
      } else if (response['error'] != null) {
        //  //Fluttertoast.showToast(msg: 'An error occurred. Please try again.');
      }
    } catch (e) {
      debugPrint(" Error: $e");
      //  //Fluttertoast.showToast(msg: 'An error occurred. Please try again.');
    }
  }

  Future<void> getCitiesProperty() async {
    getCities.clear();
    try {
      var response = await HttpHandler.getHttpMethod(
        url: APIString.get_citywise_property_count,
      );
      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          log("response[data]  ---- ${response['body']['data']}");
          var respData = response['body'];

          // Static city list with images
          final Map<String, Map<String, dynamic>> staticCities = {
            'pune': {'city_name': 'Pune', 'city_img': 'assets/images/cities/pune.png'},
            'mumbai': {'city_name': 'Mumbai', 'city_img': 'assets/images/cities/mumbai.png'},
            'delhi': {'city_name': 'Delhi', 'city_img': 'assets/images/cities/delhi.png'},
            'bangalore': {'city_name': 'Bangalore', 'city_img': 'assets/images/cities/bangalore.png'},
            'chennai': {'city_name': 'Chennai', 'city_img': 'assets/images/cities/chennai.png'},
            'hyderabad': {'city_name': 'Hyderabad', 'city_img': 'assets/images/cities/hyderabad.png'},
            'kolkata': {'city_name': 'Kolkata', 'city_img': 'assets/images/cities/kolkata.png'},
            'ahmedabad': {'city_name': 'Ahmedabad', 'city_img': 'assets/images/cities/ahmedabad.png'},
          };

          // Initialize property_count to 0 for all static cities
          Map<String, Map<String, dynamic>> mergedCities = Map.from(staticCities);
          mergedCities.forEach((key, value) {
            value['property_count'] = 0;
          });

          // Process API data to update property counts
          List<dynamic> apiData = respData["data"];
          for (var item in apiData) {
            String cityName = item['city_name'].toString().toLowerCase();
            if (mergedCities.containsKey(cityName)) {
              // Update property count for matching city
              mergedCities[cityName]!['property_count'] += item['property_count'];
            }
          }

          // Convert merged map to list
          getCities.value = mergedCities.values.toList();
          // //Fluttertoast.showToast(msg: 'Fetched successfully');
        }
      } else if (response['error'] != null) {
        // //Fluttertoast.showToast(msg: 'An error occurred. Please try again.');
      }
    } catch (e) {
      debugPrint("Error: $e");
      // //Fluttertoast.showToast(msg: 'An error occurred. Please try again.');
    }
  }

  Future<void> getOwnerListedBy() async {
    OwnerListedBy.clear();
    try {
      var response = await HttpHandler.getHttpMethod(
        url: APIString.get_user_property_count,
      );
      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          log("response[data]  ---- ${response['body']["data"]}");
          var respData = response['body'];
          OwnerListedBy.value = respData["data"];
          // //Fluttertoast.showToast(msg: 'Fetch successfully');
        }
      } else if (response['error'] != null) {
        //  //Fluttertoast.showToast(msg: 'An error occurred. Please try again.');
      }
    } catch (e) {
      debugPrint(" Error: $e");
      //  //Fluttertoast.showToast(msg: 'An error occurred. Please try again.');
    }
  }
  var sortBY = ''.obs;
  Future<void> getMySearchProperty({
    String? searchKeyword,
    String? page = '1',
    String? showFatured,
    String? isFrom,
    String? property_category_type,
    String? city,
    String? locality,
    String? property_type,
    String? min_price,
    String? max_price,
    String? furnishtype,
    String? bhktype,
  }) async {
    String? userId = await SPManager.instance.getUserId(USER_ID);
    if (page == '1') {
      if (isFrom == 'profile') {
        profileController.myListingPrperties.clear();
        profileController.isLoading.value = true;
      } else {
        getCommonPropertyList.clear();
        isLoading.value = true;
      }
      showHomLoading(Get.context!, 'Processing...');
    } else {
      if (isFrom == 'profile') {
        profileController.isPaginationLoading.value = true;
      } else {
        isPaginationLoading.value = true;
      }
    }

    try {
      Get.focusScope?.unfocus();

      bool isValidValue(String? value) {
        if (value == null || value.trim().isEmpty) return false;
        final cleaned = value.trim().replaceAll(RegExp(r'^0+'), '');
        return cleaned.isNotEmpty && cleaned != '0';
      }

      final Map<String, dynamic> data = {};
      if (isFrom == 'profile' && isValidValue(userId)) {
        data['user_id'] = userId;
      }
      if (isValidValue(searchKeyword)) {
        data['search_keyword'] = searchKeyword;
      }
      if (isValidValue(page)) {
        data['page'] = page;
      }
      if (isValidValue(showFatured)) {
        data['show_featured'] = showFatured;
      }
      if (isValidValue(APIString.Index)) {
        data['page_size'] = APIString.Index ?? '10';
      }
      if (isValidValue(property_category_type)) {
        data['property_category_type'] = property_category_type;
      }
      if (isValidValue(city)) {
        data['city'] = city;
      }
      if (isValidValue(locality)) {
        data['locality'] = locality;
      }
      if (isValidValue(property_type)) {
        data['property_type'] = property_type;
      }
      if (isValidValue(sortBY.value)) {
        data['sort_by'] = sortBY.value;
      }
      if (isValidValue(furnishtype)) {
        data['furnish_type'] = furnishtype;
      }
      if (isValidValue(bhktype)) {
        data['bhk_type'] = bhktype;
      }
      if (isValidValue(min_price)) {
        data['min_price'] = min_price;
      }
      if (isValidValue(max_price)) {
        data['max_price'] = max_price;
      }

      if (data.isEmpty) {
        debugPrint("No valid parameters provided for the API request.");
        if (isFrom == 'profile') {
          profileController.myListingPrperties.clear();
        } else {
          getCommonPropertyList.clear();
        }
        return;
      }

      var response = await HttpHandler.postHttpMethod(
        url: APIString.my_properties_search_filter,
        data: data,
      );

      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          final respData = response['body'];
          List<dynamic> newItems = respData["data"];

          if (isFrom == 'profile') {
            profileController.currentPage.value = int.tryParse(respData["current_page"].toString()) ?? 1;
            profileController.totalPages.value = int.tryParse(respData["total_pages"].toString()) ?? 1;
            profileController.total_count.value = int.tryParse(respData["total_count"].toString()) ?? 1;
            profileController.hasMore.value = profileController.currentPage.value < profileController.totalPages.value;
            profileController.myListingPrperties.addAll(newItems);
          } else {
            currentPage.value = int.tryParse(respData["current_page"].toString()) ?? 1;
            totalPages.value = int.tryParse(respData["total_pages"].toString()) ?? 1;
            total_count.value = int.tryParse(respData["total_count"].toString()) ?? 1;
            hasMore.value = currentPage.value < totalPages.value;
            getCommonPropertyList.addAll(newItems);
          }
        } else {
          if (page == '1') {
            if (isFrom == 'profile') {
              profileController.myListingPrperties.clear();
            } else {
              getCommonPropertyList.clear();
            }
          }
          hasMore.value = false;
        }
      } else {
        if (page == '1') {
          if (isFrom == 'profile') {
            profileController.myListingPrperties.clear();
          } else {
            getCommonPropertyList.clear();
          }
        }
        var responseBody = json.decode(response['body']);
        // Fluttertoast.showToast(msg: responseBody['msg']);
      }
    } catch (e) {
      debugPrint("Search Error: $e");
      if (page == '1') {
        if (isFrom == 'profile') {
          profileController.myListingPrperties.clear();
        } else {
          getCommonPropertyList.clear();
        }
      }
    } finally {
      if (isFrom == 'profile') {
        profileController.isLoading.value = false;
        profileController.isPaginationLoading.value = false;
      } else {
        isLoading.value = false;
        isPaginationLoading.value = false;
      }

      if (page == '1') {
        hideLoadingDialog();
      }
    }
  }


  Future<void> getMySearchProject({
    String? searchKeyword,
    String? page = '1',
    String? isFrom,
    String? project_type,
    String? city,
    String? locality,
    String? min_price,
    String? max_price,
    String? furnishtype,
    String? bhktype,
    String? sortBY,
  }) async {
    String? userId = await SPManager.instance.getUserId(USER_ID);

    if (page == '1') {
      if (isFrom == 'profile') {
        profileController.myListingProject.clear();
        profileController.isLoading.value = true;
      } else {
        getCommonProjectsList.clear();
        isLoading.value = true;
      }
      showHomLoading(Get.context!, 'Processing...');
    } else {
      if (isFrom == 'profile') {
        profileController.isPaginationLoading.value = true;
      } else {
        isPaginationLoading.value = true;
      }
    }

    try {
      Get.focusScope?.unfocus();

      // Helper to check for '0', '00000', etc.
      bool isZeroOrEmpty(String? value) {
        if (value == null || value.trim().isEmpty) return true;
        final cleaned = value.trim().replaceAll(RegExp(r'^0+'), '');
        return cleaned.isEmpty || cleaned == '0';
      }

      // Build request body
      final Map<String, dynamic> data = {
        'user_id': isFrom == 'profile' ? (userId ?? '') : '',
        'search_keyword': searchKeyword,
        'page': page,
        'page_size': APIString.Index ?? '10',
        'project_type': project_type,
        'city': city,
        'locality': locality,
        'sort_by': sortBY,
        'furnish_type': furnishtype,
        'bhk_type': bhktype,
      };

      // Only include min_price and max_price if not zero
      if (!isZeroOrEmpty(min_price)) {
        data['min_price'] = min_price;
      }

      if (!isZeroOrEmpty(max_price)) {
        data['max_price'] = max_price;
      }

      // Remove any remaining empty/null fields
      data.removeWhere((key, value) => value == null || (value is String && value.trim().isEmpty));

      var response = await HttpHandler.postHttpMethod(
        url: APIString.my_project_search_filter,
        data: data,
      );

      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          final respData = response['body'];
          List<dynamic> newItems = respData["data"];

          if (isFrom == 'profile') {
            profileController.currentPage.value = int.tryParse(respData["current_page"].toString()) ?? 1;
            profileController.totalPages.value = int.tryParse(respData["total_pages"].toString()) ?? 1;
            profileController.total_count.value = int.tryParse(respData["total_count"].toString()) ?? 0;
            profileController.hasMore.value = profileController.currentPage.value < profileController.totalPages.value;
            profileController.myListingProject.addAll(newItems);
          } else {
            currentPage.value = int.tryParse(respData["current_page"].toString()) ?? 1;
            totalPages.value = int.tryParse(respData["total_pages"].toString()) ?? 1;
            total_count.value = int.tryParse(respData["total_count"].toString()) ?? 0;
            hasMore.value = currentPage.value < totalPages.value;
            getCommonProjectsList.addAll(newItems);
          }
        } else {
          if (page == '1') {
            if (isFrom == 'profile') {
              profileController.myListingProject.clear();
            } else {
              getCommonProjectsList.clear();
            }
          }
          hasMore.value = false;
        }
      } else {
        if (page == '1') {
          if (isFrom == 'profile') {
            profileController.myListingProject.clear();
          } else {
            getCommonProjectsList.clear();
          }
        }
      }
    } catch (e) {
      debugPrint("Search Error: $e");
      if (page == '1') {
        buildersProjectList.clear();
        if (isFrom == 'profile') {
          profileController.myListingProject.clear();
        } else {
          getCommonProjectsList.clear();
        }
      }
    } finally {
      if (isFrom == 'profile') {
        profileController.isLoading.value = false;
        profileController.isPaginationLoading.value = false;
      } else {
        isLoading.value = false;
        isPaginationLoading.value = false;
      }

      if (page == '1') {
        hideLoadingDialog();
      }
    }
  }



  List<Map<String, dynamic>> filterProperties(
      List<Map<String, dynamic>> properties, Map<String, dynamic> filters)
  {
    // Extract filter parameters with default values
    final List<String> propertyType = filters['property_type']?.cast<String>() ?? [];
    final List<String> bhkType = filters['bhk_type']?.cast<String>() ?? [];
    final Map<String, double> priceRange = filters['price_range'] != null
        ? {
      'min': (filters['price_range']['min'] as num?)?.toDouble() ?? 0.0,
      'max': (filters['price_range']['max'] as num?)?.toDouble() ?? double.infinity,
    }
        : {'min': 0.0, 'max': double.infinity};
    final List<String> furnishedType = filters['furnished_type']?.cast<String>() ?? [];

    return properties.where((property) {
      // Check if property_type matches (if filter is provided)
      final bool matchesPropertyType = propertyType.isEmpty ||
          propertyType.contains(property['property_type'] as String?);

      // Check if bhk_type matches (if filter is provided)
      final bool matchesBhkType = bhkType.isEmpty ||
          bhkType.contains(property['bhk_type'] as String?);

      // Check if price is within range
      final double propertyPrice = (property['property_price'] as num?)?.toDouble() ?? 0.0;
      final bool matchesPrice =
          propertyPrice >= priceRange['min']! && propertyPrice <= priceRange['max']!;

      // Check if furnished_type matches (if filter is provided)
      final bool matchesFurnishedType = furnishedType.isEmpty ||
          furnishedType.contains(property['furnished_type'] as String?);

      // Return true only if all conditions are met
      return matchesPropertyType && matchesBhkType && matchesPrice && matchesFurnishedType;
    }).toList();
  }

  // Future<void> getBuildersProjects({String? page = '1'}) async {
  //   if (page == '1') {
  //     buildersProjectList.clear();
  //     getCommonProjectsList.clear();
  //     isLoading.value = true;
  //     // showLoadingDialog1(Get.context!, 'Processing...');
  //   } else {
  //     isPaginationLoading.value = true;
  //   }
  //
  //   try {
  //     Get.focusScope?.unfocus();
  //
  //     var response = await HttpHandler.postHttpMethod(
  //       url: APIString.get_project_list,
  //       data: {
  //         'page': page,
  //         'page_size': APIString.Index,
  //       },
  //     );
  //
  //     if (response['error'] == null) {
  //       if (response['body']['status'].toString() == "1") {
  //         final respData = response['body'];
  //         List<dynamic> data = respData["data"];
  //
  //         currentPage.value = respData["current_page"] is int
  //             ? respData["current_page"]
  //             : int.tryParse(respData["current_page"].toString()) ??
  //                 currentPage.value;
  //
  //         totalPages.value = respData["total_pages"] is int
  //             ? respData["total_pages"]
  //             : int.tryParse(respData["total_pages"].toString()) ??
  //                 totalPages.value;
  //
  //         hasMore.value = currentPage.value < totalPages.value;
  //
  //         buildersProjectList.addAll(data);
  //         getCommonProjectsList.value = data;
  //       } else {
  //         if (page == '1') {
  //           buildersProjectList.clear();
  //           getCommonProjectsList.clear();
  //           //Fluttertoast.showToast(msg: 'No Listing Found');
  //         }
  //         hasMore.value = false;
  //       }
  //     } else {
  //       buildersProjectList.clear();
  //       getCommonProjectsList.clear();
  //       var responseBody = json.decode(response['body']);
  //       //Fluttertoast.showToast(msg: responseBody['msg']);
  //     }
  //   } catch (e) {
  //     debugPrint("Listing Error: $e");
  //     if (page == '1') {
  //       buildersProjectList.clear();
  //       getCommonProjectsList.clear();
  //     }
  //     //Fluttertoast.showToast(msg: 'No Listing Found');
  //   } finally {
  //     isLoading.value = false;
  //     isPaginationLoading.value = false;
  //     if (page == '1') {
  //       // hideLoadingDialog();
  //     } else {}
  //   }
  // }

  Future<void> getBuildersProjects({String? page = '1'}) async {
    print("getBuildersProjects: Fetching page $page");
    String?   userId = await SPManager.instance.getUserId(USER_ID);
    if (page == '1') {
      print("getBuildersProjects: Clearing lists for first page");
      buildersProjectList.clear();
      getCommonProjectsList.clear();
      isLoading.value = true;
    } else {
      isPaginationLoading.value = true;
    }

    try {
      Get.focusScope?.unfocus();

      var response = await HttpHandler.postHttpMethod(
        url: APIString.all_project_list,
        data: {
          'user_id': userId,
          'page': page,
          'page_size': APIString.Index,
        },
      );

      print("getBuildersProjects: API Response: $response");

      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          final respData = response['body'];
          List<dynamic> data = respData["data"];
          print("getBuildersProjects: Received ${data.length} items for page $page");

          currentPage.value = respData["current_page"] is int
              ? respData["current_page"]
              : int.tryParse(respData["current_page"].toString()) ?? 1;

          totalPages.value = respData["total_pages"] is int
              ? respData["total_pages"]
              : int.tryParse(respData["total_pages"].toString()) ?? 1;

          total_count.value = respData["total_count"] is int
              ? respData["total_count"]
              : int.tryParse(respData["total_count"].toString()) ?? 1;

          hasMore.value = currentPage.value < totalPages.value;
          print("getBuildersProjects: Updated: currentPage=${currentPage.value}, totalPages=${totalPages.value}, hasMore=${hasMore.value}");

          buildersProjectList.addAll(data);
          getCommonProjectsList.addAll(data); // Append instead of assign
          print("getBuildersProjects: Total items in getCommonProjectsList: ${getCommonProjectsList.length}");
        } else {
          print("getBuildersProjects: No data found for page: $page, status: ${response['body']['status']}");
          if (page == '1') {
            buildersProjectList.clear();
            getCommonProjectsList.clear();
          }
          hasMore.value = false;
        }
      } else {
        print("getBuildersProjects: API error: ${response['body']}");
        if (page == '1') {
          buildersProjectList.clear();
          getCommonProjectsList.clear();
        }
        hasMore.value = false;
        // Fluttertoast.showToast(msg: json.decode(response['body'])['msg'] ?? 'Error fetching data');
      }
    } catch (e) {
      print("getBuildersProjects: Error: $e");
      if (page == '1') {
        buildersProjectList.clear();
        getCommonProjectsList.clear();
      }
      hasMore.value = false;
      // Fluttertoast.showToast(msg: 'No Listing Found');
    } finally {
      isLoading.value = false;
      isPaginationLoading.value = false;
      print("getBuildersProjects: Finished: isLoading=${isLoading.value}, isPaginationLoading=${isPaginationLoading.value}");
      if (page == '1') {
        // hideLoadingDialog();
      }
    }
  }

  getPropertyImage({String? id}) async {
    getPropertyImageList.clear();

    try {
      var response = await HttpHandler.postHttpMethod(
        url: APIString.get_property_images,
        data: {
          'property_id': id!,
        },
      );
    print("property images ${response}");
      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          log("response[data]  ---- ${response['body']["data"]}");
          var respData = response['body'];

          getPropertyImageList.value = respData["data"];
        } else {
          getPropertyImageList.clear();
        }
      } else if (response['error'] != null) {
        getPropertyImageList.clear();
      }
    } catch (e) {
      getPropertyImageList.clear();
      debugPrint("Login Error: $e");
      // //Fluttertoast.showToast(msg: 'An error occurred. Please try again.');
    }
  }
  getProjectImage({String? id}) async {
    getPropertyImageList.clear();

    try {
      var response = await HttpHandler.postHttpMethod(
        url: APIString.get_project_images,
        data: {
          'project_id': id!,
        },
      );
      print("property images ${response}");
      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          log("response[data]  ---- ${response['body']["data"]}");
          var respData = response['body'];

          getPropertyImageList.value = respData["data"];
        } else {
          getPropertyImageList.clear();
        }
      } else if (response['error'] != null) {
        getPropertyImageList.clear();
      }
    } catch (e) {
      getPropertyImageList.clear();
      debugPrint("Login Error: $e");
      // //Fluttertoast.showToast(msg: 'An error occurred. Please try again.');
    }
  }
  bool validateBasicDetails() {
    // if (selected.value == -1) {
    //   //Fluttertoast.showToast(
    //     msg: "Please select your owner type.",
    //
    //   );
    //   return false;
    // }

    if (categorySelected.value == -1) {
      //Fluttertoast.showToast( msg: "Please select a category.",);
      return false;
    }

    if (address == null || address!.isEmpty) {
      //Fluttertoast.showToast(msg: "Please enter your locality/apartment.", );
      return false;
    }

    if (cityValue == null || cityValue!.isEmpty) {
      //Fluttertoast.showToast(msg: "Please enter your city.",);
      return false;
    }
    // if (phNoController.text.length != 10) {
    //   //Fluttertoast.showToast(
    //     msg: "Please enter a valid 10-digit mobile number.",
    //
    //   );
    //   return false;
    // }
    return true;
  }

  bool validatePropertyDetails() {
    if (selectedProperty.value == -1) {
      //Fluttertoast.showToast(msg: "Please select a property type.",);
      return false;
    }

    if (propertyNameController.text.isEmpty) {
      //Fluttertoast.showToast(msg: "Please enter the property name.",);
      return false;
    }

    if (propertyDescriptionController.text.isEmpty) {
      //Fluttertoast.showToast(msg: "Please enter the property description.",);
      return false;
    }

    if (buildUpAreaController.text.isEmpty) {
      //Fluttertoast.showToast(msg: "Please enter the built-up area.",);
      return false;
    }

    if (totalFloorController.text.isEmpty) {
      //Fluttertoast.showToast(msg: "Please enter the total floors.",);
      return false;
    }

    if (propertyFloorController.text.isEmpty) {
      //Fluttertoast.showToast(msg: "Please enter the property floor.",);
      return false;
    }

    if (bathroomType.value.isEmpty && categorytype.value == 'Commercial') {
      //Fluttertoast.showToast(msg: "Please select a bathroom type.",);
      return false;
    }

    if (selectedBhk.value == -1 && categorytype.value == 'Residential') {
      //Fluttertoast.showToast(msg: "Please select a BHK type.",);
      return false;
    }

    if (selectedFurnished.value == -1) {
      //Fluttertoast.showToast(msg: "Please select a furnishing type.",);
      return false;
    }

    if (coverImg == null && coverImage.value.isEmpty) {
      //Fluttertoast.showToast(msg: "Please add a property cover image.",);
      return false;
    }

    return true;
  }

  bool validateAmenities() {
    if (selectedamenities.isEmpty) {
      //Fluttertoast.showToast(msg: "Please select a amenities",);
      return false;
    }
    return true;
  }

  bool validatePrice() {
    if (selectedamenities.isEmpty) {
      //Fluttertoast.showToast(msg: "Please select a amenities", );
      return false;
    }
    return true;
  }

  // Future<void> addOffer(
  //     {String? name,
  //     String? des,
  //     String? property_id,
  //     String? time,
  //     var image}) async {
  //   String? userId = await SPManager.instance.getUserId(USER_ID);
  //
  //   try {
  //     showLoadingDialog1(Get.context!, 'Processing...');
  //     isLoading.value = true;
  //     Get.focusScope!.unfocus();
  //     XFile? xFile;
  //     if (image != null) {
  //       xFile = XFile(image.path);
  //     }
  //     // property_id (comma separated) , offer_name, offer_img, offer_description,user_id
  //     var response = await HttpHandler.formDataMethod(
  //       url: APIString.add_offer,
  //       apiMethod: "POST",
  //       body: {
  //         //property_id (comma separated) , offer_name, offer_img, offer_description,user_id
  //         "offer_name": name!,
  //         "property_id": property_id!,
  //         "offer_description": des!,
  //         "user_id": userId!,
  //         "offer_time": time!,
  //         "approval_status": 'Pending',
  //         // "approval_status": 'Approved',
  //       },
  //       imageKey: "offer_img",
  //       imagePath: xFile?.path,
  //     );
  //     log('response----- ${response["body"]}');
  //
  //     if (response['error'] == null) {
  //       if (response['body']['status'].toString() == "1") {
  //         print('Offer1123-->');
  //         //Fluttertoast.showToast(msg: response['body']['msg'].toString());
  //         String Offer = (await SPManager.instance.getOffers(Offers)) ?? "no";
  //         int? offerCount =
  //             (await SPManager.instance.getOfferCount(PAID_OFFER)) ?? 0;
  //         int? offerPlanCount =
  //             (await SPManager.instance.getPlanOfferCount(PLAN_OFFER)) ?? 0;
  //         print('Offer1123-->');
  //         print(Offer);
  //         print(offerCount);
  //         print(offerPlanCount);
  //
  //         if (Offer == 'yes') {
  //           if (offerCount > 0) {
  //             await SPManager.instance
  //                 .setOfferCount(PAID_OFFER, offerCount - 1);
  //             // searcontroller
  //             //     .add_count(isfrom: 'offer', count: -1)
  //             //     .then((value) async {
  //             //   await SPManager.instance
  //             //       .setOfferCount(PAID_OFFER, offerCount - 1);
  //             // });
  //             print('testing--');
  //             print(offerCount - 1);
  //           }
  //           isLoading.value = false;
  //         }
  //         getOffer(page: '1');
  //         Navigator.of(Get.context!).pop();
  //         isLoading.value = false;
  //       } else if (response['body']['status'].toString() == "0") {
  //         //Fluttertoast.showToast(msg: response['body']['msg'].toString());
  //       }
  //     }
  //     else if (response['error'] != null) {
  //       var responseBody = json.decode(response['body']);
  //       //Fluttertoast.showToast(msg: responseBody['msg']);
  //     }
  //   } catch (e, s) {
  //     debugPrint("updateProfile Error -- $e  $s");
  //   } finally {
  //     isLoading.value = false;
  //
  //     if (Navigator.canPop(Get.context!)) {
  //       Navigator.of(Get.context!).pop();
  //     }
  //   }
  // }

  Future<void> addOffer(
      {String? name,
        String? des,
        String? property_id,
        String? time,
        var image}) async {
    String? userId = await SPManager.instance.getUserId(USER_ID);

    try {
      showHomLoading(Get.context!, 'Processing...');
      isLoading.value = true;
      Get.focusScope!.unfocus();
      XFile? xFile;
      if (image != null) {
        xFile = XFile(image.path);
      }
      // property_id (comma separated) , offer_name, offer_img, offer_description,user_id
      var response = await HttpHandler.formDataMethod(
        url: APIString.add_offer,
        apiMethod: "POST",
        body: {
          //property_id (comma separated) , offer_name, offer_img, offer_description,user_id
          "offer_name": name!,
          "property_id": property_id!,
          "offer_description": des!,
          "user_id": userId!,
          "offer_time": time!,
          "approval_status": 'Pending',
          // "approval_status": 'Approved',
        },
        imageKey: "offer_img",
        imagePath: xFile?.path,
      );
      log('response----- ${response["body"]}');

      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          print('Offer1123-->');
          String Offer = (await SPManager.instance.getOffers(Offers)) ?? "no";
          int? offerCount =
              (await SPManager.instance.getOfferCount(PAID_OFFER)) ?? 0;
          int? offerPlanCount =
              (await SPManager.instance.getPlanOfferCount(PLAN_OFFER)) ?? 0;
          print('Offer1123-->');
          print(Offer);
          print(offerCount);
          print(offerPlanCount);

          if (Offer == 'yes') {
            if (offerCount > 0) {
              await SPManager.instance
                  .setOfferCount(PAID_OFFER, offerCount - 1);
              print('testing--');
              print(offerCount - 1);

              Fluttertoast.showToast(
                  msg: "Offer Created Successfully",);
            }
            //isLoading.value = false;



          }
          getOffer(page: '1');
          Navigator.of(Get.context!).pop();
          isLoading.value = false;
          isFailedTo.value = false;
        }
        else if (response['body']['status'].toString() == "0") {
          Fluttertoast.showToast(
            msg: response['body']['msg'].toString());
          isFailedTo.value = true;

        }

      }
      else if (response['error'] != null) {
        Fluttertoast.showToast(
            msg: "Offer already created on this property");
        isFailedTo.value = true;

      }
    } catch (e, s) {
      debugPrint("updateProfile Error -- $e  $s");
    } finally {
      isLoading.value = false;

      if (Navigator.canPop(Get.context!)) {
        Navigator.of(Get.context!).pop();
      }
    }
  }
  Future<void> UpdateOffer(
      {required String id,
      String? name,
      String? des,
      String? property_id,
      String? time,
      var image}) async {
    String? userId = await SPManager.instance.getUserId(USER_ID);

    try {
      showHomLoading(Get.context!, 'Processing...');
      isLoading.value = true;
      Get.focusScope!.unfocus();
      XFile? xFile;
      if (image != null) {
        xFile = XFile(image.path);
      }
      // property_id (comma separated) , offer_name, offer_img, offer_description,user_id
      var response = await HttpHandler.formDataMethod(
        url: APIString.update_offer,
        apiMethod: "POST",
        body: {
          //property_id (comma separated) , offer_name, offer_img, offer_description,user_id
          "offer_auto_id": id,
          "offer_name": name!,
          "property_id": property_id!,
          "offer_description": des!,
          "user_id": userId!,
          "offer_time": time!,
          "approval_status": 'Pending',
          // "approval_status": 'Approved',
        },
        imageKey: "offer_img",
        imagePath: xFile?.path,
      );
      log('response----- ${response["body"]}');

      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          //Fluttertoast.showToast(msg: response['body']['msg'].toString());

          isLoading.value = false;
       //   getOffer(page: '1');
        } else if (response['body']['status'].toString() == "0") {
          //Fluttertoast.showToast(msg: response['body']['msg'].toString());
        }
      } else if (response['error'] != null) {
        var responseBody = json.decode(response['body']);
        //Fluttertoast.showToast(msg: responseBody['msg']);
      }
    } catch (e, s) {
      debugPrint("updateProfile Error -- $e  $s");
    } finally {
      isLoading.value = false;

      if (Navigator.canPop(Get.context!)) {
        Navigator.of(Get.context!).pop();
      }
    }
  }

  Future getOffer(
      {String? isfrom, String? otherUserId, String? page = '1'}) async {
    if (page == '1') {
      getOfferList.clear();
      filteredOfferList.clear();
      isLoading.value = true;
       //showLoadingDialog1(Get.context!, 'Processing...');
    } else {
      isPaginationLoading.value = true;
    }
    String? userId;
    if (isfrom == 'search') {
      userId = "";
    } else if (isfrom == 'developer') {
      userId = otherUserId;
    } else {
      userId = await SPManager.instance.getUserId(USER_ID);
    }
    try {
      var response = await HttpHandler.postHttpMethod(
        url: APIString.get_offer,
        data: {
          'user_id': userId,
          'page': page,
          'page_size': APIString.Index,
        },
      );
      if (response['error'] == null &&
          response['body']['status'].toString() == "1") {
        final respData = response['body'];
        List<dynamic> data = respData["data"];

        currentPage.value = respData["current_page"] is int
            ? respData["current_page"]
            : int.tryParse(respData["current_page"].toString()) ??
                currentPage.value;

        totalPages.value = respData["total_pages"] is int
            ? respData["total_pages"]
            : int.tryParse(respData["total_pages"].toString()) ??
                totalPages.value;

        hasMore.value = currentPage.value < totalPages.value;

        print("Called getMyListingProperties with page: $page");
        print(
            "→ Updated currentPage: ${currentPage.value}, totalPages: ${totalPages.value}");

        filteredOfferList.addAll(data);
        getOfferList.addAll(data);
      } else {
        if (page == '1') {
          filteredOfferList.clear();
          getOfferList.clear();
          //Fluttertoast.showToast(msg: 'No Listing Found');
        }
        hasMore.value = false;

        // //Fluttertoast.showToast(msg: 'No offer found');
      }
    } catch (e) {
      debugPrint("Listing Error: $e");
      if (page == '1') {
        getOfferList.clear();
        filteredOfferList.clear();
      }
      //Fluttertoast.showToast(msg: 'No Listing Found');
    } finally {
      isLoading.value = false;
      isPaginationLoading.value = false;
      if (page == '1') {
        // hideLoadingDialog();
      } else {}
    }
  }
  bool offerApplied = false; // This will hold the status of the offer

  Future checkOffer({String? id}) async {
    String? userId = await SPManager.instance.getUserId(USER_ID);

    try {
      var response = await HttpHandler.postHttpMethod(
        url: APIString.check_offer_property,
        data: {
          'user_id': userId,
          'property_id': id,
        },
      );

      if (response['error'] == null && response['body']['status'].toString() == "0") {
        // If the status is 0, the offer has already been applied
        offerApplied = true; // Offer is already applied
      } else {
        offerApplied = false; // Offer is not applied
      }
    } catch (e) {
      debugPrint("Error: $e");
      offerApplied = false; // Handle error and set to false
    } finally {
      // Final cleanup if needed
    }
  }


  Future getOfferProperty({String? offerId}) async {
    getOfferdPropertyList.clear();

    try {
      showHomLoading(Get.context!, 'Processing...');
      var response = await HttpHandler.postHttpMethod(
        url: APIString.get_offered_property,
        data: {'offer_id': offerId},
      );
      if (response['error'] == null &&
          response['body']['status'].toString() == "1") {
        log("response[data]  ---- ${response['body']["data"]}");
        var respData = response['body'];
        getOfferdPropertyList.value = respData["data"];
        //Fluttertoast.showToast(msg: 'Fetch successfully');
      } else {
        getOfferdPropertyList.clear();
        var responseBody = json.decode(response['body']);
        //Fluttertoast.showToast(msg: responseBody['msg']);
      }
    } catch (e) {
      getOfferdPropertyList.clear();
      debugPrint("Error: $e");
      //Fluttertoast.showToast(msg: 'An error occurred. Please try again.');
    }
    finally{
      hideLoadingDialog();
    }
  }

  Future<void> deleteOffer({String? id}) async {
    String? userId = await SPManager.instance.getUserId(USER_ID);
    try {
      var response = await HttpHandler.deleteHttpMethod(
        url: APIString.delete_offer,
        data: {
          'offer_auto_id': id,
          'user_id': userId,
        },
      );
      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          getOffer(page: '1');
          update();
          //Fluttertoast.showToast(msg: 'Successfully deleted');
        }
      } else if (response['error'] != null) {
        var responseBody = json.decode(response['body']);
        //Fluttertoast.showToast(msg: responseBody['msg']);
      }
    } catch (e) {
      debugPrint("Login Error: $e");
      //Fluttertoast.showToast(msg: 'An error occurred. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addUpcomingProjects(
      {String? name, String? des, var image}) async {
    String? userId = await SPManager.instance.getUserId(USER_ID);

    try {
      showHomLoading(Get.context!, 'Processing...');
      isLoading.value = true;
      Get.focusScope!.unfocus();
      XFile? xFile;
      if (image != null) {
        xFile = XFile(image.path);
      }
      // user_id, project_image, project_name, description
      var response = await HttpHandler.formDataMethod(
        url: APIString.upcoming_project,
        apiMethod: "POST",
        body: {
          "project_name": name!,
          "description": des!,
          "user_id": userId!,
        },
        imageKey: "project_image",
        imagePath: xFile?.path,
      );
      log('response----- ${response["body"]}');

      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          //Fluttertoast.showToast(msg: response['body']['msg'].toString());

          String Project = (await SPManager.instance
                  .getUpcomingProjects(UpcomingProjects)) ??
              "no";

          int? projectCount =
              (await SPManager.instance.getProjectCount(PAID_PROJECT)) ?? 0;

          int? projectPlanCount =
              (await SPManager.instance.getPlanProjectCount(PLAN_PROJECT)) ?? 0;
          print('Offer-->');
          print(Project);
          print(projectCount);
          print(projectPlanCount);

          if (Project == 'yes') {
            if (projectCount <= projectPlanCount) {
              int count = projectCount + 1;
              searcontroller
                  .add_count(isfrom: 'project', count: count)
                  .then((value) async {
                await SPManager.instance
                    .setProjectCount(PAID_PROJECT, count + 1);
              });
              print('testing--');
              print(count);
            }
          }
          getUpcomingProjects();
          Navigator.of(Get.context!).pop();
          isLoading.value = false;
        } else if (response['body']['status'].toString() == "0") {
          //Fluttertoast.showToast(msg: response['body']['msg'].toString());
        }
      } else if (response['error'] != null) {
        var responseBody = json.decode(response['body']);
        //Fluttertoast.showToast(msg: responseBody['msg']);
      }
    } catch (e, s) {
      debugPrint("updateProfile Error -- $e  $s");
    } finally {
      isLoading.value = false;

      if (Navigator.canPop(Get.context!)) {
        Navigator.of(Get.context!).pop();
      }
    }
  }

  Future getUpcomingProjects({String? isfrom, String? otherUserId}) async {
    String? userId;
    if (isfrom == 'search') {
      userId = "";
    } else if (isfrom == 'developer') {
      userId = otherUserId;
    } else {
      userId = await SPManager.instance.getUserId(USER_ID);
    }

    getUpcomingProject.clear();

    try {
      var response = await HttpHandler.postHttpMethod(
        url: APIString.get_upcoming_project,
        data: {'user_id': userId},
      );
      if (response['error'] == null &&
          response['body']['status'].toString() == "1") {
        log("response[data]  ---- ${response['body']["data"]}");
        var respData = response['body'];
        getUpcomingProject.value = respData["data"];
        //  //Fluttertoast.showToast(msg: 'Fetch successfully');
      } else {
        getUpcomingProject.clear();
        var responseBody = json.decode(response['body']);
        //  //Fluttertoast.showToast(msg: responseBody['msg']);
      }
    } catch (e) {
      debugPrint("Error: $e");
      ////Fluttertoast.showToast(msg: 'An error occurred. Please try again.');
    }
  }

  Future<void> deleteUpcomingProjects({String? id}) async {
    String? userId = await SPManager.instance.getUserId(USER_ID);
    try {
      var response = await HttpHandler.deleteHttpMethod(
        url: APIString.delete_upcoming_project,
        data: {
          'upcoming_project_auto_id': id,
          'user_id': userId,
        },
      );
      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          getUpcomingProjects();
          //Fluttertoast.showToast(msg: 'Successfully deleted');
        }
      } else if (response['error'] != null) {
        var responseBody = json.decode(response['body']);
        //Fluttertoast.showToast(msg: responseBody['msg']);
      }
    } catch (e) {
      debugPrint("Login Error: $e");
      //Fluttertoast.showToast(msg: 'An error occurred. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  // Future<void> getFeaturedProperty({String? isfrom, String? page = '1'}) async {
  //
  //   print("page-->");
  //   print(page);
  //   if (page == '1') {
  //     getFeaturedPropery.clear();
  //     getCommonPropertyList.clear();
  //     isLoading.value = true;
  //      //showLoadingDialog1(Get.context!, 'Processing...');
  //   } else {
  //     isPaginationLoading.value = true;
  //   }
  //
  //   String? userId = await SPManager.instance.getUserId(USER_ID);
  //
  //   try {
  //     Get.focusScope?.unfocus();
  //
  //     var response = await HttpHandler.postHttpMethod(
  //       url: APIString.get_featured_property,
  //       data: {
  //         'user_id': userId,
  //         'owner_id': "",
  //         'page': page,
  //         'page_size': APIString.Index,
  //       },
  //     );
  //
  //     if (response['error'] == null) {
  //       if (response['body']['status'].toString() == "1") {
  //         final respData = response['body'];
  //         List<dynamic> data = respData["data"];
  //
  //         currentPage.value = respData["current_page"] is int
  //             ? respData["current_page"]
  //             : int.tryParse(respData["current_page"].toString()) ??
  //                 currentPage.value;
  //
  //         totalPages.value = respData["total_pages"] is int
  //             ? respData["total_pages"]
  //             : int.tryParse(respData["total_pages"].toString()) ??
  //                 totalPages.value;
  //
  //         hasMore.value = currentPage.value < totalPages.value;
  //
  //         getFeaturedPropery.addAll(data);
  //         getCommonPropertyList.addAll(data);
  //       } else {
  //         if (page == '1') {
  //           getFeaturedPropery.clear();
  //           getCommonPropertyList.clear();
  //           //Fluttertoast.showToast(msg: 'No Listing Found');
  //         }
  //         hasMore.value = false;
  //       }
  //     } else {
  //       getFeaturedPropery.clear();
  //       getCommonPropertyList.clear();
  //       var responseBody = json.decode(response['body']);
  //       //Fluttertoast.showToast(msg: responseBody['msg']);
  //     }
  //   } catch (e) {
  //     debugPrint("Listing Error: $e");
  //     if (page == '1') {
  //       getFeaturedPropery.clear();
  //       getCommonPropertyList.clear();
  //     }
  //     //Fluttertoast.showToast(msg: 'No Listing Found');
  //   } finally {
  //     isLoading.value = false;
  //     isPaginationLoading.value = false;
  //     if (page == '1') {
  //       // hideLoadingDialog();
  //     } else {}
  //   }
  // }


  Future<void> getFeaturedProperty({String? isfrom, String? page = '1'}) async {
    print("getFeaturedProperty called for page: $page");
    if (page == '1') {
      print("Clearing lists for first page");
      getFeaturedPropery.clear();
      getCommonPropertyList.clear();
      isLoading.value = true;
    } else {
      isPaginationLoading.value = true;
    }

    String? userId = await SPManager.instance.getUserId(USER_ID);
    print("User ID: $userId");

    try {
      Get.focusScope?.unfocus();

      var response = await HttpHandler.postHttpMethod(
        url: APIString.get_featured_property,
        data: {
          'user_id': userId,
          'owner_id': "",
          'page': page,
          'page_size': APIString.Index,
        },
      );

      print("API Response: $response");

      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          final respData = response['body'];
          List<dynamic> data = respData["data"];
          print("Received ${data.length} items for page $page");

          currentPage.value = respData["current_page"] is int
              ? respData["current_page"]
              : int.tryParse(respData["current_page"].toString()) ?? 1;

          total_count.value = respData["total_count"] is int
              ? respData["total_count"]
              : int.tryParse(respData["total_count"].toString()) ?? 1;

          totalPages.value = respData["total_pages"] is int
              ? respData["total_pages"]
              : int.tryParse(respData["total_pages"].toString()) ?? 1;

          hasMore.value = currentPage.value < totalPages.value;
          print("Updated: currentPage=${currentPage.value}, totalPages=${totalPages.value}, hasMore=${hasMore.value}");

          getFeaturedPropery.addAll(data);
          getCommonPropertyList.addAll(data);
          print("Total items in getCommonPropertyList: ${getCommonPropertyList.length}");
        } else {
          print("No data found for page: $page, status: ${response['body']['status']}");
          if (page == '1') {
            getFeaturedPropery.clear();
            getCommonPropertyList.clear();
          }
          hasMore.value = false;
        }
      } else {
        print("API error: ${response['body']}");
        if (page == '1') {
          getFeaturedPropery.clear();
          getCommonPropertyList.clear();
        }
        hasMore.value = false;
        // Fluttertoast.showToast(msg: json.decode(response['body'])['msg'] ?? 'Error fetching data');
      }
    } catch (e) {
      print("Error in getFeaturedProperty: $e");
      if (page == '1') {
        getFeaturedPropery.clear();
        getCommonPropertyList.clear();
      }
      hasMore.value = false;
      // Fluttertoast.showToast(msg: 'No Listing Found');
    } finally {
      isLoading.value = false;
      isPaginationLoading.value = false;
      print("Finished getFeaturedProperty: isLoading=${isLoading.value}, isPaginationLoading=${isPaginationLoading.value}");
      if (page == '1') {
        // hideLoadingDialog();
      }
    }
  }
  Future<void> getRecommendedProperty(
      {String? isfrom, String? page = '1'}) async {
    String? userId = await SPManager.instance.getUserId(USER_ID);
    print("User ID: $userId");
    if (page == '1') {
      getRecommendedPropertyList.clear();
      getCommonPropertyList.clear();
      isLoading.value = true;
      // showLoadingDialog1(Get.context!, 'Processing...');
    } else {
      isPaginationLoading.value = true;
    }
    try {
      Get.focusScope?.unfocus();

      var response = await HttpHandler.postHttpMethod(
        url: APIString.getRecommendedProperties,
        data: {
          'user_id': userId,
          'page': page,
          'page_size': APIString.Index,
        },
      );

      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          final respData = response['body'];
          List<dynamic> data = respData["data"];

          total_count.value = respData["total_count"] is int
              ? respData["total_count"]
              : int.tryParse(respData["total_count"].toString()) ?? 1;
          currentPage.value = respData["current_page"] is int
              ? respData["current_page"]
              : int.tryParse(respData["current_page"].toString()) ??
                  currentPage.value;

          totalPages.value = respData["total_pages"] is int
              ? respData["total_pages"]
              : int.tryParse(respData["total_pages"].toString()) ??
                  totalPages.value;

          hasMore.value = currentPage.value < totalPages.value;

          getRecommendedPropertyList.addAll(data);
          getCommonPropertyList.addAll(data);
        } else {
          if (page == '1') {
            getRecommendedPropertyList.clear();
            getCommonPropertyList.clear();
            //Fluttertoast.showToast(msg: 'No Listing Found');
          }
          hasMore.value = false;
        }
      } else {
        getRecommendedPropertyList.clear();
        getCommonPropertyList.clear();
        var responseBody = json.decode(response['body']);
        //Fluttertoast.showToast(msg: responseBody['msg']);
      }
    } catch (e) {
      debugPrint("Listing Error: $e");
      if (page == '1') {
        getRecommendedPropertyList.clear();
        getCommonPropertyList.clear();
      }
      //Fluttertoast.showToast(msg: 'No Listing Found');
    } finally {
      isLoading.value = false;
      isPaginationLoading.value = false;
      if (page == '1') {
        // hideLoadingDialog();
      } else {}
    }
  }

  ///Enquiry
  Future enquiryCallBack(String view)async {
    if (view == 'Property') {
      await getPropertyEnquiry();
    } else {
      await getProjectEnquiry();
    }
  }

  // Future getPropertyEnquiry({String? search, String? page = '1'}) async {
  //   // Clear only when it's the first page
  //   if (page == '1') {
  //     getProperyEnquiryList.clear();
  //     isLoading.value = true;
  //     showLoadingDialog1(Get.context!, 'Processing...');
  //   } else {
  //     isPaginationLoading.value = true;
  //   }
  //
  //   try {
  //     final userId = await SPManager.instance.getUserId(USER_ID);
  //     var response = await HttpHandler.postHttpMethod(
  //       url: APIString.get_property_enquiry,
  //       data: {
  //         'user_id': userId,
  //         'page': page,
  //         if (search != null && search.isNotEmpty) 'search': search,
  //       },
  //     );
  //
  //     if (response['error'] == null) {
  //       if (response['body']['status'].toString() == "1") {
  //         var respData = response['body'];
  //         var leadsData = respData['data'] as List;
  //
  //         // Update pagination info
  //         currentPage.value = respData["current_page"] is int
  //             ? respData["current_page"]
  //             : int.tryParse(respData["current_page"].toString()) ??
  //                 currentPage.value;
  //
  //         totalPages.value = respData["total_pages"] is int
  //             ? respData["total_pages"]
  //             : int.tryParse(respData["total_pages"].toString()) ??
  //                 totalPages.value;
  //
  //         hasMore.value = currentPage.value < totalPages.value;
  //
  //         // Add only the leads data to the list
  //         getProperyEnquiryList.addAll(leadsData);
  //
  //         print(
  //             'Loaded ${leadsData.length} leads, total: ${getProperyEnquiryList.length}');
  //       } else {
  //         if (page == '1') {
  //           getProperyEnquiryList.clear();
  //           ////Fluttertoast.showToast(msg: 'No Listing Found');
  //         }
  //         hasMore.value = false;
  //       }
  //     } else {
  //       getProperyEnquiryList.clear();
  //       var responseBody = json.decode(response['body']);
  //       //Fluttertoast.showToast(msg: responseBody['msg'] ?? 'Error occurred');
  //     }
  //   } catch (e) {
  //     if (page == '1') {
  //       getProperyEnquiryList.clear();
  //     }
  //     debugPrint("Error in getPropertyEnquiry: $e");
  //    // //Fluttertoast.showToast(msg: 'An error occurred. Please try again.');
  //   } finally {
  //     isLoading.value = false;
  //     isPaginationLoading.value = false;
  //     // Only hide loading dialog if it was the first page
  //     if (page == '1') {
  //       hideLoadingDialog();
  //     }
  //   }
  // }

  Future<void> getPropertyEnquiry({
    String? searchKeyword,
    String? page = '1',
    String? showFatured,

    String? property_category_type,
    String? city,
    String? locality,
    String? property_type,
    String? min_price,
    String? max_price,
    String? furnishtype,
    String? bhktype,
  }) async {
    String? userId = await SPManager.instance.getUserId(USER_ID);
    if (page == '1') {
      getProperyEnquiryList.clear();
      isLoading.value = true;
      showHomLoading(Get.context!, 'Processing...');
    } else {
      isPaginationLoading.value = true;
    }

    try {
      Get.focusScope?.unfocus();

      bool isValidValue(String? value) {
        if (value == null || value.trim().isEmpty) return false;
        final cleaned = value.trim().replaceAll(RegExp(r'^0+'), '');
        return cleaned.isNotEmpty && cleaned != '0';
      }

      final Map<String, dynamic> data = {};
      if ( isValidValue(userId)) {
        data['user_id'] = userId;
      }
      if (isValidValue(searchKeyword)) {
        data['search'] = searchKeyword;
      }
      if (isValidValue(page)) {
        data['page'] = page;
      }

      if (isValidValue(APIString.Index)) {
        data['page_size'] = APIString.Index ?? '10';
      }
      if (isValidValue(property_category_type)) {
        data['property_category_type'] = property_category_type;
      }
      if (isValidValue(city)) {
        data['city'] = city;
      }
      if (isValidValue(locality)) {
        data['locality'] = locality;
      }
      if (isValidValue(property_type)) {
        data['property_type'] = property_type;
      }
      if (isValidValue(sortBY.value)) {
        data['sort_by'] = sortBY.value;
      }
      if (isValidValue(furnishtype)) {
        data['furnish_type'] = furnishtype;
      }
      if (isValidValue(bhktype)) {
        data['bhk_type'] = bhktype;
      }
      if (isValidValue(min_price)) {
        data['min_price'] = min_price;
      }
      if (isValidValue(max_price)) {
        data['max_price'] = max_price;
      }

      if (data.isEmpty) {
        debugPrint("No valid parameters provided for the API request.");
        getProperyEnquiryList.clear();
        return;
      }

      var response = await HttpHandler.postHttpMethod(
        url: APIString.get_property_enquiry,
        data: data,
      );

      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          final respData = response['body'];
          List<dynamic> newItems = respData["data"];

          currentPage.value = int.tryParse(respData["current_page"].toString()) ?? 1;
          totalPages.value = int.tryParse(respData["total_pages"].toString()) ?? 1;
          hasMore.value = currentPage.value < totalPages.value;
          getProperyEnquiryList.addAll(newItems);
        } else {
          if (page == '1') {

            getProperyEnquiryList.clear();
          }
          hasMore.value = false;
        }
      } else {
        if (page == '1') {
          getProperyEnquiryList.clear();
        }
        var responseBody = json.decode(response['body']);
        // Fluttertoast.showToast(msg: responseBody['msg']);
      }
    } catch (e) {
      debugPrint("Search Error: $e");
      if (page == '1') {
        getProperyEnquiryList.clear();
      }
    } finally {
      isLoading.value = false;
      isPaginationLoading.value = false;

      if (page == '1') {
        hideLoadingDialog();
      }
    }
  }

  // Future getProjectEnquiry({String? search, String? page = '1'}) async {
  //   // Clear only when it's the first page
  //   if (page == '1') {
  //     getProjectEnquiryList.clear();
  //     isLoading.value = true;
  //     showLoadingDialog1(Get.context!, 'Processing...');
  //   } else {
  //     isPaginationLoading.value = true;
  //   }
  //
  //   try {
  //     final userId = await SPManager.instance.getUserId(USER_ID);
  //     var response = await HttpHandler.postHttpMethod(
  //       url: APIString.get_project_enquiry,
  //       data: {
  //         'user_id': userId,
  //         'page': page,
  //         if (search != null && search.isNotEmpty) 'search': search,
  //       },
  //     );
  //
  //     if (response['error'] == null) {
  //       if (response['body']['status'].toString() == "1") {
  //         var respData = response['body'];
  //         var leadsData = respData['data'] as List;
  //
  //         // Update pagination info
  //         currentPage.value = respData["current_page"] is int
  //             ? respData["current_page"]
  //             : int.tryParse(respData["current_page"].toString()) ??
  //             currentPage.value;
  //
  //         totalPages.value = respData["total_pages"] is int
  //             ? respData["total_pages"]
  //             : int.tryParse(respData["total_pages"].toString()) ??
  //             totalPages.value;
  //
  //         hasMore.value = currentPage.value < totalPages.value;
  //
  //         // Add only the leads data to the list
  //         getProjectEnquiryList.addAll(leadsData);
  //
  //         print(
  //             'Loaded ${leadsData.length} leads, total: ${getProjectEnquiryList.length}');
  //       } else {
  //         if (page == '1') {
  //           getProjectEnquiryList.clear();
  //           // //Fluttertoast.showToast(msg: 'No Listing Found');
  //         }
  //         hasMore.value = false;
  //       }
  //     } else {
  //       getProjectEnquiryList.clear();
  //       var responseBody = json.decode(response['body']);
  //       // //Fluttertoast.showToast(msg: responseBody['msg'] ?? 'Error occurred');
  //     }
  //   } catch (e) {
  //     if (page == '1') {
  //       getProjectEnquiryList.clear();
  //     }
  //     debugPrint("Error in getPropertyEnquiry: $e");
  //     ////Fluttertoast.showToast(msg: 'An error occurred. Please try again.');
  //   } finally {
  //     isLoading.value = false;
  //     isPaginationLoading.value = false;
  //     // Only hide loading dialog if it was the first page
  //     if (page == '1') {
  //       hideLoadingDialog();
  //     }
  //   }
  // }


  Future<void> getProjectEnquiry({
    String? searchKeyword,
    String? page = '1',
    String? showFatured,

    String? property_category_type,
    String? city,
    String? locality,
    String? property_type,
    String? min_price,
    String? max_price,
    String? furnishtype,
    String? bhktype,
  }) async {
    String? userId = await SPManager.instance.getUserId(USER_ID);
    if (page == '1') {
      getProjectEnquiryList.clear();
      isLoading.value = true;
      showHomLoading(Get.context!, 'Processing...');
    } else {
      isPaginationLoading.value = true;
    }

    try {
      Get.focusScope?.unfocus();

      bool isValidValue(String? value) {
        if (value == null || value.trim().isEmpty) return false;
        final cleaned = value.trim().replaceAll(RegExp(r'^0+'), '');
        return cleaned.isNotEmpty && cleaned != '0';
      }

      final Map<String, dynamic> data = {};
      if ( isValidValue(userId)) {
        data['user_id'] = userId;
      }
      if (isValidValue(searchKeyword)) {
        data['search'] = searchKeyword;
      }
      if (isValidValue(page)) {
        data['page'] = page;
      }

      if (isValidValue(APIString.Index)) {
        data['page_size'] = APIString.Index ?? '10';
      }
      if (isValidValue(property_category_type)) {
        data['property_category_type'] = property_category_type;
      }
      if (isValidValue(city)) {
        data['city'] = city;
      }
      if (isValidValue(locality)) {
        data['locality'] = locality;
      }
      if (isValidValue(property_type)) {
        data['property_type'] = property_type;
      }
      if (isValidValue(sortBY.value)) {
        data['sort_by'] = sortBY.value;
      }
      if (isValidValue(furnishtype)) {
        data['furnish_type'] = furnishtype;
      }
      if (isValidValue(bhktype)) {
        data['bhk_type'] = bhktype;
      }
      if (isValidValue(min_price)) {
        data['min_price'] = min_price;
      }
      if (isValidValue(max_price)) {
        data['max_price'] = max_price;
      }

      if (data.isEmpty) {
        debugPrint("No valid parameters provided for the API request.");
        getProjectEnquiryList.clear();
        return;
      }

      var response = await HttpHandler.postHttpMethod(
        url: APIString.get_project_enquiry,
        data: data,
      );

      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          final respData = response['body'];
          List<dynamic> newItems = respData["data"];

          currentPage.value = int.tryParse(respData["current_page"].toString()) ?? 1;
          totalPages.value = int.tryParse(respData["total_pages"].toString()) ?? 1;
          hasMore.value = currentPage.value < totalPages.value;
          getProjectEnquiryList.addAll(newItems);
        } else {
          if (page == '1') {

            getProjectEnquiryList.clear();
          }
          hasMore.value = false;
        }
      } else {
        if (page == '1') {
          getProjectEnquiryList.clear();
        }
        var responseBody = json.decode(response['body']);
        // Fluttertoast.showToast(msg: responseBody['msg']);
      }
    } catch (e) {
      debugPrint("Search Error: $e");
      if (page == '1') {
        getProjectEnquiryList.clear();
      }
    } finally {
      isLoading.value = false;
      isPaginationLoading.value = false;

      if (page == '1') {
        hideLoadingDialog();
      }
    }
  }


  Future<void> addDeveloperEnquiry(
      {String? developer_id, String? message}) async {
    String? userId = await SPManager.instance.getUserId(USER_ID);
    String? name = await SPManager.instance.getName(NAME);
    String? contact = await SPManager.instance.getContact(CONTACT);
    String? email = await SPManager.instance.getEmail(EMAIL);
    try {
      // developer_id, name, user_id, email, contact_number,message
      var response = await HttpHandler.postHttpMethod(
        url: APIString.add_developer_enquiry,
        data: {
          'user_id': userId,
          'name': name,
          'email': email,
          'developer_id': developer_id,
          'message': message,
          'contact_number': contact,
          'time_date': DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now()),
        },
      );
      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          //Fluttertoast.showToast(msg: response['body']['msg'].toString());
        }
      } else if (response['error'] != null) {
        var responseBody = json.decode(response['body']);
        //Fluttertoast.showToast(msg: responseBody['msg']);
      }
    } catch (e) {
      debugPrint("Login Error: $e");
      //Fluttertoast.showToast(msg: 'An error occurred. Please try again.');
    }
  }

  Future getDeveloperEnquiry({String? developer_id}) async {
    getDeveloperEnquiryList.clear();

    try {
      var response = await HttpHandler.postHttpMethod(
        url: APIString.get_developer_enquiry,
        data: {
          'developer_id': developer_id,
        },
      );
      if (response['error'] == null &&
          response['body']['status'].toString() == "1") {
        log("response[data]  ---- ${response['body']["data"]}");
        var respData = response['body'];
        getDeveloperEnquiryList.value = respData["data"];
        //Fluttertoast.showToast(msg: 'Fetch successfully');
      } else {
        getDeveloperEnquiryList.clear();
        //var responseBody = json.decode(response['body']);
        //Fluttertoast.showToast(msg: 'No data');
      }
    } catch (e) {
      getDeveloperEnquiryList.clear();
      debugPrint("Error: $e");
      //Fluttertoast.showToast(msg: 'An error occurred. Please try again.');
    }
  }

  String convertNumberToWords(int number) {
    if (number == 0) return 'Zero';

    const units = [
      '',
      'One',
      'Two',
      'Three',
      'Four',
      'Five',
      'Six',
      'Seven',
      'Eight',
      'Nine',
      'Ten',
      'Eleven',
      'Twelve',
      'Thirteen',
      'Fourteen',
      'Fifteen',
      'Sixteen',
      'Seventeen',
      'Eighteen',
      'Nineteen'
    ];

    const tens = [
      '',
      '',
      'Twenty',
      'Thirty',
      'Forty',
      'Fifty',
      'Sixty',
      'Seventy',
      'Eighty',
      'Ninety'
    ];

    String words = '';

    if (number >= 10000000) {
      // Crores
      words += '${convertNumberToWords(number ~/ 10000000)} Crore ';
      number %= 10000000;
    }

    if (number >= 100000) {
      // Lakhs
      words += '${convertNumberToWords(number ~/ 100000)} Lakh ';
      number %= 100000;
    }

    if (number >= 1000) {
      // Thousands
      words += '${convertNumberToWords(number ~/ 1000)} Thousand ';
      number %= 1000;
    }

    if (number >= 100) {
      // Hundreds
      words += '${units[number ~/ 100]} Hundred ';
      number %= 100;
    }

    if (number >= 20) {
      // Tens
      words += '${tens[number ~/ 10]} ';
      number %= 10;
    }

    if (number > 0) {
      // Units
      words += units[number] + ' ';
    }

    return words.trim();
  }

  String NumberToWords(String number) {
    int num = int.tryParse(number) ?? 0;
    return convertNumberToWords(num);
  }

  Future<void> getDescription({String? Category}) async {
    descriptionList.clear();
    try {
      showHomLoading(Get.context!, 'Processing...');
      isLoading.value = true;
      Get.focusScope!.unfocus();
      var response = await HttpHandler.postHttpMethod(
        url: APIString.get_descriptions_property,
        data: {
          'category_type': Category,
        },
      );
      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          log("response[data]  ---- ${response['body']["data"]}");
          var respData = response['body'];
          descriptionList.value = respData["data"];
          //Fluttertoast.showToast(msg: 'Fetch successfully');
          isLoading.value = false;
        } else {
          getDeveloperEnquiryList.clear();
          //Fluttertoast.showToast(msg: 'No description Found');
        }
      } else if (response['error'] != null) {
        var responseBody = json.decode(response['body']);
        //Fluttertoast.showToast(msg: responseBody['msg']);
      }
    } catch (e) {
      debugPrint("Login Error: $e");
      //Fluttertoast.showToast(msg: 'No description Found');
    } finally {
      isLoading.value = false;

      if (Navigator.canPop(Get.context!)) {
        Navigator.of(Get.context!).pop();
      }
    }
  }

  Future<void> add_virtual_tour(
      {String? property_owner_id,
      String? schedule_date,
      String? time_unit,
      String? tour_type,
      String? timeslot,
      String? channel_name,
      String? property_id}) async {
    String? userId = await SPManager.instance.getUserId(USER_ID);
    descriptionList.clear();
    try {
      showHomLoading(Get.context!, 'Processing...');
      isLoading.value = true;
      Get.focusScope!.unfocus();
      var response = await HttpHandler.postHttpMethod(
        url: APIString.add_virtual_tour_schedule,
        data: {
          'user_id': userId,
          'property_id': property_id,
          'property_owner_id': property_owner_id,
          'schedule_date': schedule_date,
          'timeslot': timeslot,
          'time_unit': time_unit,
          'tour_type': tour_type,
          'channel_name': channel_name,
        },
      );

      if (response['error'] == null) {
        if (response['body']['status'].toString() == "1") {
          log("response[data]  ---- ${response['body']["data"]}");
          var respData = response['body'];

          //Fluttertoast.showToast(msg: 'Fetch successfully');
          Get.back();
          isLoading.value = false;
        } else {
          //Fluttertoast.showToast(msg: 'Virtual tour not scheduled');
        }
      } else if (response['error'] != null) {
        var responseBody = json.decode(response['body']);
        //Fluttertoast.showToast(msg: responseBody['msg']);
      }
    } catch (e) {
      debugPrint("Login Error: $e");
      //Fluttertoast.showToast(msg: 'No description Found');
    } finally {
      isLoading.value = false;

      if (Navigator.canPop(Get.context!)) {
        Navigator.of(Get.context!).pop();
      }
    }
  }


  Future<void> getHomeData({String? city}) async {
    String? userId = await SPManager.instance.getUserId(USER_ID);
    print("User ID: $userId");

    buildersProjectList.clear();
    getRecommendedPropertyList.clear();
    OwnerListedBy.clear();
    getFeaturedPropery.clear();
    getOfferList.clear();

    try {
      Get.focusScope?.unfocus();

      var response = await HttpHandler.postHttpMethod(
        url: APIString.get_home_data,
        data: {
          'user_id': userId ?? "",
         'city_name': city??"",
         //  'city_name': "Pune",
        },
      );

      print("API Response: $response");

      if (response['error'] == null) {
        final respData = response['body'];

        print("Projects data: ${respData['projects']['data']}");

        buildersProjectList.addAll(respData['projects']['data']);
        getRecommendedPropertyList.addAll(respData['recommended_properties']['data']);
        OwnerListedBy.addAll(respData['user_type_property_count']['data']);
        getFeaturedPropery.addAll(respData['featured_properties']['data']);
        getOfferList.addAll(respData['offers']['data']);
      }
    } catch (e) {
      debugPrint("Listing Error: $e");
    } finally {
      isLoading.value = false;
      isPaginationLoading.value = false;
    }
  }

  String getTimeAgo(DateTime postedDate) {
    final now = DateTime.now();
    final difference = now.difference(postedDate);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays <= 30) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays <= 365) {

      return DateFormat('d MMMM').format(postedDate);
    } else {
      return DateFormat('d MMMM yyyy').format(postedDate);
    }
  }
  RxBool isLoadingMap = false.obs;
  RxBool hasMoreDataMap = true.obs;
  RxString citiesMap = ''.obs;
  RxString area = ''.obs;
  int currentPageMap = 1;
  RxInt total_count_map = 0.obs;
  final int pageSize = 10;

  Future<void> getLocationSearchData(
      String properties_latitude,
      String properties_longitude,
      String page,
      String page_size,
      String property_category_type,
      String category_price_type,
      String property_type,
      String bhk_type,
      String city_name,
      {bool reset = false}) async {

    print("getLocationSearchData controler API Called");

    if (isLoadingMap.value || (!hasMoreDataMap.value && !reset)) return;

    isLoadingMap.value = true;

    final stopwatch = Stopwatch()..start();

    try {
      if (reset) {
        getSearchList.clear();
        currentPageMap = 1;
        hasMoreDataMap.value = true;
      }

      var response = await HttpHandler.postHttpMethod(
        url: APIString.searchLocation,
        data: {

          'page': page,
          'page_size': page_size,
          // 'property_category_type': property_category_type,
          // 'category_price_type': category_price_type,
          // 'property_type': property_type,

          'building_type': property_category_type=="Commercial" ? property_category_type:"",
          'property_category_type': category_price_type=="Buy" || category_price_type=="Rent"? category_price_type:"",
          'property_type': property_type == "PG" ?property_type : "",

          'bhk_type': bhk_type,
          'city_name': city_name,
          'user_id': "",
          'min_price': "",
          'max_price': "",
          'amenities': "",
          'area':area.value.isEmpty?citiesMap.value:area.value,
        },
      ).timeout(const Duration(seconds: 10), onTimeout: () {
        throw TimeoutException('API call timed out after 10 seconds');
      });

      print('API call completed in ${stopwatch.elapsedMilliseconds}ms');
      print('Response status: ${response['body']['status']}');
      print('Response data length: ${response['body']['data']?.length ?? 0}');
      print('Current page: $page, Total pages: ${response['body']['total_pages']}, Total count: ${response['body']['total_count']}');
      total_count_map.value = int.tryParse(response['body']['total_count']?.toString() ?? "0") ?? 0;

      if (response['error'] == null &&
          response['body']['status'].toString() == "1" &&
          response['body']['data'] != null) {
        final data = response['body']['data'] ?? [];

        final newData = data.where((property) {
          final latStr = property['latitude']?.toString();
          final lngStr = property['longitude']?.toString();
          if (latStr == null ||
              lngStr == null ||
              latStr == "null" ||
              lngStr == "null" ||
              latStr.isEmpty ||
              lngStr.isEmpty) {
            print(
                'Skipping invalid property ${property['_id'] ?? 'unknown'}: lat=$latStr, lng=$lngStr');
            return false;
          }
          final lat = double.tryParse(latStr);
          final lng = double.tryParse(lngStr);
          if (lat == null || lng == null || lat == 0.0 || lng == 0.0) {
            print(
                'Skipping invalid coordinates for property ${property['_id'] ?? 'unknown'}: lat=$latStr, lng=$lngStr');
            return false;
          }
          return true;
        }).toList();

        if (int.parse(page) == 1) {
          getSearchList.clear();
        }
        getSearchList.addAll(newData);

        final totalCount = response['body']['total_count'] ?? 0;
        final totalPages = response['body']['total_pages'] ?? 1;

        hasMoreDataMap.value =
            int.parse(page) < totalPages || getSearchList.length < totalCount;
        if (hasMoreDataMap.value && !reset) {
          currentPageMap = int.parse(page) + 1;
        }
        print('getSearchList size: ${controller.getSearchList.length}');

       total_count.value = int.tryParse(response['body']['total_count']?.toString() ?? "0") ?? 0;
        print('getSearchList size: ${getSearchList.length}');
        // Fluttertoast.showToast(msg: 'Fetched successfully');
      } else {
        final errorMsg =
            response['body']['msg'] ?? response['error'] ?? 'Property not found';
        print('API error: $errorMsg');
        hasMoreDataMap.value = false;
        // Fluttertoast.showToast(msg: errorMsg);
      }
    } catch (e, stackTrace) {
      print('API call error: $e');
      print('Stack trace: $stackTrace');
      hasMoreDataMap.value = false;
      // Fluttertoast.showToast(msg: 'Error fetching data: $e');
    } finally {
      isLoadingMap.value = false;
      print('getLocationSearchData completed in ${stopwatch.elapsedMilliseconds}ms');
    }
  }

  void clearSearchData() {
    getSearchList.clear();
    currentPageMap = 1;
    hasMoreDataMap.value = true;
    isLoadingMap.value = false;
  }





}

