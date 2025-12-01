import 'dart:async';
import 'package:csc_picker/csc_picker.dart';
import 'dart:io';
import 'package:country_picker/country_picker.dart';
import 'package:country_state_city_pro/country_state_city_pro.dart';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:real_estate_app/common_widgets/RequiredTextWidget.dart';
import 'package:real_estate_app/common_widgets/custom_textformfield.dart';
import 'package:real_estate_app/common_widgets/height.dart';
import 'package:real_estate_app/common_widgets/subscription_dialog.dart';
import 'package:real_estate_app/global/app_color.dart';
import 'package:real_estate_app/utils/String_constant.dart';
import 'package:real_estate_app/utils/shared_preferences/shared_preferances.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/profile_screen/profile_controller.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/profile_screen/profile_section_screens/My%20Properties/MyProperties.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/profile_screen/profile_section_screens/PlansAndSubscriptions/PlansAndSubscription.dart';
import 'package:real_estate_app/view/property_screens/post_property_screen/NewChanges/fields_widgets.dart';
import 'package:real_estate_app/view/property_screens/post_property_screen/NewChanges/list_of_fields.dart';
import 'package:real_estate_app/view/property_screens/post_property_screen/NewChanges/video_player.dart';
import 'package:real_estate_app/view/property_screens/properties_controllers/post_property_controller.dart';
import '../../../../common_widgets/loading_dart.dart';
import 'package:google_places_flutter/google_places_flutter.dart';


class start_page extends StatefulWidget {
  final String? isFrom;
  const start_page({super.key,this.isFrom});

  @override
  _start_pageState createState() => _start_pageState();
}


class _start_pageState extends State<start_page> {
  final PostPropertyController controller = Get.find();
  double progress = 0.0;
  late int freePostCount;
  late int paidPostCount;
  late int projectCount;

  @override
  void initState() {
    super.initState();
    initializeControllerValues();
    clearInitialFields();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setupViewsBasedOnIndex();
      controller.selectedIndex.value = 0;
      controller.currentViewIndex.value = 0;


      controller.showpropertyForError.value = false;

      controller.selectedProperty.value = 0;

      controller.selectedPropertyType.value=  controller
          .categorytype.value ==
          'Residential'
          ? controller.residentalpropertyTypes[controller.selectedProperty.value]
          : controller.commercialPropertyType[controller.selectedProperty.value];
      controller.propertytype.value =controller.selectedPropertyType.value;

      print("controller.propertytype.value==>");
      print(controller.propertytype.value);

      SetNextButtoTap();

      updatePropertyFields(controller.selectedPropertyType.value);
      checkCount();
    });
  }

  SetNextButtoTap(){

    setState(() {
      controller.countryName.value = '';
      controller.countryController.clear();
      if (widget.isFrom == 'myprojects'){
        controller.selectedIndex.value = 1;
      }else if(widget.isFrom == 'myproperties'){
        controller.selectedIndex.value = 0;
      }else {
        controller.selectedIndex.value = (controller.selectedIndex.value == 0) ? 0 : 0;
      }
      if(controller.selectedIndex.value == 1)
      {
        controller.residentalpropertyTypes.assignAll([
          'Apartment',
          'Plot',
          'Independent House',
          'Villa',
          'Builder Floor',
          'Penthouse',
          // 'PG'
        ]);
        controller.categorytype.value = 'Residential'; // default building type for project
        print("type ==>>> ${controller.categorytype.value}");
      }
      controller.views.clear();
    });
    setState(() {
      controller.views.add(IntroView(isFrom: widget.isFrom));
      controller.views.add(PlaceView());
      controller.views.add(PropertyTypeView());
      controller.views.add(BasicInfoView());
      controller.views.add(const priceView());
      controller.views.add(const add_propertyImage());
      controller.views.add(const uploadProperyImage());
      controller.views.add(const areaView());
      controller.views.add(const moreDetailsProperty());
      controller.views.add(const aboutProperty());
      controller.views.add(const addAmenitiesView());
    });
  }

  void updatePropertyFields(String propertyType) {
    List<String> bhkTypes = [
      "Studio",
      "1 RK",
      "1 BHK",
      "1.5 BHK",
      "2 BHK",
      "2.5 BHK",
      "3 BHK",
      "3.5 BHK",
      "4 BHK",
      "5 BHK",
      "6 BHK",
    ];
    List<String> additionalTypes = [
      "Pooja Room",
      "Servant Room",
      "Study Room",
      "Extra Room"
    ];
    List<String> balconyList = ["Connected", "Individual", "Room-attached"];
    List<String> ageOfProperty = ["0-1", "2-4", "5-7", "8-10", "10+"];
    List<String> coveredParkingList = ["1", "2", "3", "4", "5", "6", "6+"];
    List<String> unCoveredParkingList = [
      "N/A",
      "1",
      "2",
      "3",
      "4",
      "5",
      "6",
      "6+"
    ];
    List<String> possessionStatus = ["Ready To Move", "Under Construction"];
    Map<String,String> constructionStatus = {"Completed":"Ready To Move", "Ongoing":"Under Construction"};
    List<String> bathroomTypes = ["1", "2", "3", "4", "5", "6", "6+"];
    List<String> powerBackupList = ["No Back-up", "Available"];
    List<String> facingList = [
      "East",
      "West",
      "North",
      "South",
      "North East",
      "North West",
      "South East",
      "South West"
    ];
    List<String> viewList = [
      "Beach View",
      "Garden View",
      "Golf View",
      "Lake View",
      "Park View",
      "Road View",
      "Community View",
      "Pool View",
      "Creek View",
      "Sea View"
    ];
    List<String> liftAvailabilityList = ["Yes", "No"];
    List<String> flooringList = [
      "Marble",
      "Concrete",
      "Cemented",
      "Carpeted",
      "Wooden",
      "Others"
    ];
    List<String> seatsTypeList = [
      "Open Seat",
      "Private Cabin",
      "Conference Cabin"
    ];
    List<String> roomtypes = [
      'Private Room',
      'Twin Sharing',
      'Triple Sharing',
      'Quad Sharing',
    ];
    List<String> pgFoods = ['Breakfast', 'Lunch', 'Dinner'];
    List<String> notice = [
      '15',
      '30',
      '45',
      'Others',
    ];
    List<String> operatingScience = [
      '0-1',
      '2-4',
      '5-8',
      '9-12',
      '13+',
    ];
    List<String> pgRule = [
      'No Smoking',
      'No Guardians Stay',
      'No Drinking',
      'No Non-Veg',
      'Visiter Allow',
      'Party',
      'Loud music',
      'Opposite Gender',
    ];
    List<String> pgService = [
      'Wifi',
      'Laundary Service',
      'Wheelchair Friendly',
      'Pet Friendy',
      'Room Cleaning',
    ];

    controller.bhkTypes.assignAll(bhkTypes);
    controller.additionalType.assignAll(additionalTypes);
    controller.BalconyList.assignAll(balconyList);
    controller.AgeofProperty.assignAll(ageOfProperty);
    controller.CoveredParkingList.assignAll(coveredParkingList);
    controller.UnCoveredParkingList.assignAll(unCoveredParkingList);
    controller.PossessionStatus.assignAll(possessionStatus);
    controller.projectConstructionStatus.value = constructionStatus;
    controller.bathroomypes.assignAll(bathroomTypes);
    controller.PoweBackupList.assignAll(powerBackupList);
    controller.FacingList.assignAll(facingList);
    controller.ViewList.assignAll(viewList);
    controller.LiftAvailabilityList.assignAll(liftAvailabilityList);
    controller.FlooringList.assignAll(flooringList);
    controller.seatsTypeList.assignAll(seatsTypeList);
    controller.WaterSourceList.assignAll(
        ["Municipal Supply", "Borewell/ Underground", "Others"]);
    if (controller.selectedPropertyType.value == "PG") {
      controller.roomTypeList.assignAll(roomtypes);
      controller.foodAvailableList.assignAll(pgFoods);
      controller.NoticePeriodDaysList.assignAll(notice);
      controller.OperatingSinceYearsList.assignAll(operatingScience);
      controller.PG_HostelRulesList.assignAll(pgRule);
      controller.AvailablePGServicesList.assignAll(pgRule);
    }

    if (controller.categorytype.value == 'Residential') {
      if (controller.CategoryPriceType.value == "Sell") {
        controller.AgeofProperty.assignAll(ageOfProperty);
        controller.selectedPropertyType.value == "Plot"
            ? controller.bhkType.value = ''
            : null;
      }
    }
  }
  Future<void> checkCount() async{
  freePostCount =  await SPManager.instance.getFreePostCount(FREE_POST) ?? 0;
  paidPostCount =  await SPManager.instance.getPaidPostCount(PAID_POST) ?? 0;
  projectCount =  await SPManager.instance.getProjectCount(PAID_PROJECT) ?? 0;
  String  Property= (await SPManager.instance.getPostProperties(PostProperties))??"no";
  String  Project= (await SPManager.instance.getUpcomingProjects(UpcomingProjects))??"no";
  print(' post count ===> ');
  if (kDebugMode) {
    print(freePostCount);
    print(Property);
    print(Project);
  }
  if (kDebugMode) {
    print(paidPostCount);
  }
  if (kDebugMode) {
    print(projectCount);
  }
}

  void initializeControllerValues() {
    controller.bhkTypes.assignAll([
      "Studio", "1 RK", "1 BHK", "1.5 BHK", "2 BHK",
      "2.5 BHK", "3 BHK", "3.5 BHK", "4 BHK", "5 BHK", "6+ BHK",
    ]);

    controller.bathroomypes.assignAll(["1", "2", "3", "4", "5", "6", "6+"]);
    print('assign bhk : ${controller.bhkTypes}');
  }

  void clearInitialFields() {
    ClearFiled();
  }

  void setupViewsBasedOnIndex() {
    List<Widget> views = [
      IntroView(isFrom: widget.isFrom,),
      PlaceView(),
      PropertyTypeView(),
      BasicInfoView(),
    ];

    if (controller.selectedIndex.value == 0) {
      views.addAll([
        const priceView(),
        const add_propertyImage(),
        const uploadProperyImage(),
        //const configurationView(),
        const areaView(),
        const moreDetailsProperty(),
        const aboutProperty(),
        const addAmenitiesView(),
      ]);
    } else {
      views.addAll([
        const projectPriceDetails(),
        const add_propertyImage(),
        const uploadProperyImage(),
        const aboutProperty(),
        const moreDetailsProperty(),
        const floorPlanView(),
        const celingView(),
        const doorView(),
        const addAmenitiesView(),
      ]);
    }

    setState(() {
      controller.views.assignAll(views);
    });
  }


  void goToNextView(String isFrom) {
    int index = controller.currentViewIndex.value;
    print("index=>$index");
    FocusScope.of(context).unfocus();

    if (controller.selectedIndex.value == 0) {
      print(
          "controller.selectedIndex.value0=>${controller.selectedIndex.value}");
      if (!validateForPropertyCurrentView(index)) return;
    } else {
      print(
          "controller.selectedIndex.value1=>${controller.selectedIndex.value}");
      if (!validateForProjectCurrentView(index)) return;
    }

    if ((controller.selectedIndex.value == 1 && controller.currentViewIndex.value == 2) ||(controller.selectedIndex.value == 0 && controller.currentViewIndex.value == 3)) {
      return ConfirmedAddView(context);
    }

    if (index == 4) {
      ContinueWithAIOrMannual(context);
      return;
    }

    if (index == 4 && controller.selectedIndex.value == 1) {
      if (controller.selectedIndex.value == 0) {
        if (controller.propertyPriceController.text.isNotEmpty &&
            controller.propertyPriceController.text != "") {
          ContinueWithAIOrMannual(context);
        }
      } else {
        if (controller.selectedIndex.value == 1 &&
            controller.priceDetailsList.isNotEmpty) {
          ContinueWithAIOrMannual(context);
        } else {

          if(controller.priceDetailsList.isEmpty){
            Get.snackbar(
              'Missing Project',
              'Please add at least one project',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.redAccent,
              colorText: Colors.white,
              margin: const EdgeInsets.all(12),
              duration: const Duration(seconds: 2),
            );
          }

        }
      }

      return;
    }

    if (index < controller.views.length - 1) {
      setState(() {
        controller.currentViewIndex.value++;
      });
    }
  }

  bool validateFloorPlanForm() {
    // return controller.floorPlanFormKey.currentState?.validate() ?? false;
    return true;
  }

  void goToPreviousView() {
    setState(() {
      if (controller.currentViewIndex.value > 0) {
        controller.currentViewIndex.value--;
      }
    });
    if ((controller.selectedIndex.value == 1 && controller.currentViewIndex.value == 2) || (controller.selectedIndex.value == 0 && controller.currentViewIndex.value == 3)) {
      return ConfirmedAddView(context);
    }
    if (controller.currentViewIndex.value == 4) {
      ContinueWithAIOrMannual(context);
      return;
    }
  }

  double getProgress(int start, int end) {
    int current = controller.currentViewIndex.value;
    if (current < start) return 0;
    if (current >= end) return 1;
    return (current - start + 1) / (end - start);
  }

  void ClearFiled() {
    controller.views.clear();
    controller.propertyPrice.value="";
    controller.propertyPriceController.clear();
    controller.videoUrlController.clear();
    controller.isFeatured.value = false;
    controller.isUploading.value = false;
    controller.countryName.value = '';
    controller.countryController.clear();
    controller.categoryPriceselected.value = -1;
    controller.categorySelected.value = -1;
    controller.selectedProperty.value = 0;
    controller.propertyNameController.clear();
    controller.flatHouseNoController.clear();
    controller.streetAddressController.clear();
    controller.landmarkController.clear();
    controller.localityController.clear();
    controller.cityController.clear();
    controller.stateController.clear();
    controller.pinCodeController.clear();
    controller.addressController.clear();
    controller.coverImgs.value = null;
    controller.logoImgs.value = null;
    controller.pdfFile.value = null;
    controller.videoFile.value = null;
    controller.images1.clear();
    controller.selectedBhk.value = -1;
    controller.selectebathroom.value = -1;
    controller.selectedsqfit.value = '';
    controller.selectedarea.value = '';
    controller.statusController.clear();
    controller.develoeperController.clear();
    controller.buildUpAreaController.clear();
    controller.florController.clear();
    controller.totalFloorController.clear();
    controller.transactionController.clear();
    controller.aboutController.clear();
    controller.RoomsConroller.clear();
    controller.selectedamenities.clear();
    controller.furnishType.value = null;

    controller.LivingController.clear();
    controller.KitchenController.clear();
    controller.BedroomController.clear();
    controller.BalconyController.clear();

    controller.DiningController.clear();
    controller.ToiletsConroller.clear();
    controller.ServantConroller.clear();
    controller.ceilingLivingController.clear();
    controller.ceilingServantController.clear();
    controller.counterKitchenController.clear();
    controller.fittingKitchenController.clear();
    controller.fittingToiletController.clear();

    controller.internalDoorController.clear();
    controller.externalGlazingController.clear();
    controller.electricalController.clear();
    controller.backupController.clear();
    controller.securitySystemController.clear();
    controller.priceDetailsList.clear();
    controller.bathrrom.value = '';
    controller.bhkType.value = '';
    controller.selectedConstructionStatus.value = '';
    controller.totalProjectSizeController.clear();
    controller.UnitController.clear();
    controller.securityDepositController.clear();
    controller.Facing.value = '';
    controller.View.value = '';
    controller.LiftAvailability.value = '';
  }

  bool validateCeilingForm() {
    //return controller.ceilingFormKey.currentState?.validate() ?? false;
    return true;
  }

  bool validateDoorWindowForm() {
   // return controller.doorWindowFormKey.currentState?.validate() ?? false;
    return true;
  }

  bool validateaboutForm() {
    final isFormValid = controller.aboutFormKey.currentState!.validate();
    bool isValid = isFormValid;

    return isValid;
  }
  bool validationProjectAndArea() {
    bool isValid = true;

    // ✅ Block if user is editing and hasn't saved yet
    // if (controller.editMode.value) {
    //   Fluttertoast.showToast(
    //     msg: 'Please update and save the current editing item',
    //   );
    //   return false;
    // }

    final isListEmpty = controller.priceDetailsList.isEmpty;

    // ✅ If list is empty, run validation on form fields
    if (isListEmpty) {
      isValid = controller.projectPriceAreaKey.currentState!.validate();

      final isNotPlot = controller.selectedPropertyType.value != "Plot";
      final isBhkEmpty = controller.bhkType.value.isEmpty;

      controller.showbhkError.value = isNotPlot && isBhkEmpty;
      if (controller.showbhkError.value) isValid = false;

      controller.showimageError.value = controller.projectPropertyImage.isEmpty;
      if (controller.showimageError.value) isValid = false;

      controller.showprojectError.value = controller.priceDetailsList.isEmpty;
      if (controller.showprojectError.value) isValid = false;

      if (!isValid) {

        //replace existing message with this tex ""Please fill all fields before adding more projects""
        Fluttertoast.showToast(
          msg: 'Please fill all fields before adding more projects',
        );
      }
      // if (controller.priceDetailsList.isEmpty) {
      //   Fluttertoast.showToast(
      //     msg: 'Add at least one project plan or fill the fields properly',
      //   );
      // }

      print("App project");
      print(controller.priceDetailsList.isEmpty);
    } else {
      // ✅ If list is not empty, skip field validation
      controller.showbhkError.value = false;
      controller.showimageError.value = false;
      isValid = true;
    }

    if(controller.editMode.value){
      //replace existing message with this tex ""Please fill all fields before adding more projects""
      Fluttertoast.showToast(
        msg: 'Please update the current project before proceeding to the next one.',

      );
      isValid = false;
    }

    return isValid;
  }


  bool validateMoreDetailsForm() {
    final isFormValid = controller.moreDetailsFormKey.currentState!.validate();
    bool isValid = isFormValid;
    String type = controller.selectedPropertyType.value.trim();
    if (type != 'Land' &&
        type != 'Industrial Plot' &&
        type != 'Warehouse' &&
        type != 'Plot') {
      if (controller.furnishType.value == null) {
        controller.showFurnishTypeError.value = true;
        isValid = false;
      }
    }
    if(type == 'PG'){
      if(controller.selectedRoomTypesList.isEmpty){
        controller.showRoomTypeError.value = true;
        isValid = false;
      }
      final suitedFor = controller.selectedSuitedFor.value;
      if (suitedFor == null || suitedFor.isEmpty) {
        controller.showSuitedForError.value = true;
        isValid = false;
      }
      final foodCharge = controller.foodCharges.value;
      if (foodCharge == null || foodCharge.isEmpty) {
        controller.showFoodChargeError.value = true;
        isValid = false;
      }
      final availableFor = controller.selectedAvailableFor.value;
      if (availableFor == null || availableFor.isEmpty) {
        controller.showAvailableForError.value = true;
        isValid = false;
      }
    }

    return isValid;
  }

  bool validationAmanetity() {
    if (controller.selectedamenities.isEmpty) {
      Get.snackbar(
        'Missing Amenity',
        'Please select Amenity.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
        duration: const Duration(seconds: 2),
      );
      return false;
    }

    return true;
  }

  bool validationPlaceView() {
    if (controller.selectedIndex.value == 0 &&
        controller.categoryPriceselected.value == -1) {
      controller.showCategoryPriceError.value = true;
      return false;
    }
    if (controller.categorySelected.value == -1) {
      controller.showCategorError.value = true;
      return false;
    }

    if (controller.categoryPriceselected.value == 0 &&
        controller.categorySelected.value == 0) {
      controller.residentalpropertyTypes.assignAll([
        'Apartment',
        'Plot',
        'Independent House',
        'Villa',
        'Builder Floor',
        'Penthouse'
      ]);
    } else {
      controller.residentalpropertyTypes.assignAll([
        'Apartment',
        'Plot',
        'Independent House',
        'Villa',
        'Builder Floor',
        'Penthouse'
      ]);
    }

    if (controller.categoryPriceselected.value == 1 &&
        controller.categorySelected.value == 0) {
      controller.residentalpropertyTypes.assignAll([
        'Apartment',
        'Plot',
        'Independent House',
        'Villa',
        'Builder Floor',
        'Penthouse',
        'PG'
      ]);
    } else {
      controller.residentalpropertyTypes.assignAll([
        'Apartment',
        'Plot',
        'Independent House',
        'Villa',
        'Builder Floor',
        'Penthouse'
      ]);
    }

    controller.showCategoryPriceError.value = false;
    controller.showCategorError.value = false;
    return true;
  }

  bool validationPropertyType() {
    if (controller.selectedProperty.value == -1) {
      controller.showpropertyForError.value = true;
      return false;
    }
    controller.showpropertyForError.value = false;
    return true;
  }
  bool validationBasicInfo() {
   return controller.basicInfo1.currentState?.validate() ?? false;
  }
  bool validationPropertyPrice() {
    return controller.priceFormKey.currentState?.validate() ?? false;

  }

  bool validationAddImages() {
    //  controller.selectedBhk.value
    if (controller.coverImgs.value == null) {
      controller.showimageError.value = true;
      return false;
    }
    if (controller.selectedIndex.value == 1 && controller.logoImgs.value == null) {
      controller.showLogoError.value = true;
      return false;
    }

    // if (controller.images1.length == 0) {
    //   controller.showadditionaimagesError.value = true;
    //   return false;
    // }

    controller.showimageError.value = false;
    controller.showLogoError.value = false;
    // controller.showadditionaimagesError.value = false;
    return true;
  }

  bool validateAreaForm() {
    final isFormValid = controller.areaFormKey.currentState!.validate();

    bool isValid = isFormValid;
    print(controller.bhkType.value.isEmpty);

    if (controller.bhkType.value.isEmpty
        && controller.categorySelected.value == 0 && controller.selectedPropertyType.value != "Plot"
        && controller.selectedPropertyType.value != "PG") {
      controller.showbhkError.value = true;
      isValid = false;
    }
    if (controller.bathrrom.value.isEmpty
        && controller.selectedPropertyType.value != "Plot" && controller.selectedPropertyType.value != "Land" && controller.selectedPropertyType.value != "Warehouse") {
      controller.showbhatroomError.value = true;
      isValid = false;
    }

    if (controller.selectedsqfit.value == '') {
      controller.showSqfitError.value = true;
      isValid = false;
    }

    if(controller.selectedPropertyType.value != "Plot" && controller.selectedPropertyType.value != "Land"
        && controller.selectedPropertyType.value != "Industrial Plot"){
      if (controller.selectedarea.value  == '') {
        controller.showAreaTypeError.value = true;
        isValid = false;
      }
    }


    return isValid;
  }

  bool validateForPropertyCurrentView(int index) {
    switch (index) {
      case 0:
        return true;
      case 1:
        return validationPlaceView();
      case 2:
        return validationPropertyType();
        case 3:
        return validationBasicInfo();
        case 4:
        return validationPropertyPrice();
      case 6:
        return validationAddImages();
      case 7:
        return validateAreaForm();
      case 8:
        return validateMoreDetailsForm();
      case 9:
        return validateaboutForm();
      case 10:
        return validationAmanetity();

      default:
        return true;
    }
  }

  bool validateForProjectCurrentView(int index) {
    switch (index) {
      case 0:
        return true;
      case 1:
        return validationPropertyType();
      case 2:
        return validationBasicInfo();
        case 3:
        return validationProjectAndArea();
      case 5:
        return validationAddImages();
      case 6:
        return validateaboutForm();
      case 7:
        return validateMoreDetailsForm();
      case 8:
        return validateFloorPlanForm();
      case 9:
        return validateCeilingForm();
      case 10:
        return validateDoorWindowForm();
      case 11:
        return validationAmanetity();
      default:
        return true;
    }
  }

  void ContinueWithAIOrMannual(BuildContext context) async {
    showModalBottomSheet<void>(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: MediaQuery.of(context).viewInsets.top,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  boxH25(),
                  customIconButton(
                    icon: Icons.arrow_back,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  boxH10(),
                  const Text(
                    "Post your property using Houzza AI",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  boxH10(),
                  ListView.builder(
                    itemCount: controller.property_add_type.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final property = controller.property_add_type[index];

                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              controller.selectedIndex.value =
                                  (controller.selectedIndex.value == index)
                                      ? 0
                                      : index;
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          property['title'],
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 15,
                                          ),
                                        ),
                                        Text(
                                          property['subtitle'],
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Colors.black45,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  Image.asset(
                                    property['image'],
                                    height: 70,
                                    width: 70,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Divider()
                        ],
                      );
                    },
                  ),
                  const SizedBox(
                    height: 150,
                  ),
                  SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: commonButton(
                        text: "Let's Start",
                        onPressed: () async {
                          print("object");
                          Navigator.pop(context);
                          setState(() {
                            controller.currentViewIndex.value++;
                          });
                        },
                      )),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void ConfirmedAddView(BuildContext context) {

    showModalBottomSheet<void>(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 15,
            right: 15,
            top: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: controller.basicInfo,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    boxH10(),
                    customIconButton(
                      icon: Icons.arrow_back,
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    boxH10(),
                    const Text(
                      "Confirm your address",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    boxH20(),
                    CustomTextFormField(
                      controller: controller.propertyNameController,
                      size: 50,
                      maxLines: 2,
                      maxLength: 250,
                      labelText: controller.selectedIndex.value == 0 ? 'Property Name' : 'Project Name',
                      isRequired: true,
                      validator: (value) {
                        if (controller.selectedPropertyType.value != "Land" &&
                            controller.selectedPropertyType.value != "Plot") {
                          if (value == null || value.isEmpty) {
                            return controller.selectedIndex.value == 0
                                ? 'Please Enter Property Name'
                                : 'Please Enter Project Name';
                          }
                          if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                            return 'Please enter only alphabets';
                          }
                        }
                        return null;
                      },
                    ),
                    boxH10(),
                    CustomTextFormField(
                      controller: controller.flatHouseNoController,
                      keyboardType: TextInputType.number,
                      size: 50,
                      maxLines: 2,
                      maxLength: 10,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      labelText: 'Flat, house, block number etc.',
                    ),
                    boxH10(),
                    // CustomTextFormField(
                    //   controller: controller.streetAddressController,
                    //   size: 65,
                    //   maxLines: 2,
                    //   labelText: 'Street address',
                    //   isRequired: true,
                    //   validator: (value) {
                    //     if (value == null || value.trim().isEmpty) {
                    //       return 'Street address is required';
                    //     }
                    //     if (!RegExp(r'^[a-zA-Z0-9,.\s]+$').hasMatch(value)) {
                    //       final invalidChars = value.replaceAll(RegExp(r'[a-zA-Z0-9,.\s]'), '');
                    //       final uniqueInvalidChars = invalidChars.split('').toSet().join(', ');
                    //       return 'These characters are not allowed: $uniqueInvalidChars';
                    //     }
                    //     return null;
                    //   },
                    // ),
                    CustomTextFormField(
                      controller: controller.streetAddressController,
                      size: 65,
                      maxLines: 2,
                      labelText: 'Street address',
                      isRequired: true,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Street address is required';
                        }
                        return null;
                      },
                    ),

                    boxH10(),
                    const RequiredTextWidget(label: 'Location'),
                    boxH10(),
                    // CountryStateCityPicker(
                    //   country: controller.countryController,
                    //   state: controller.stateController,
                    //   city: controller.cityController,
                    //
                    //   dialogColor: Colors.grey.shade200,
                    //   textFieldDecoration: InputDecoration(
                    //     fillColor: AppColor.white,
                    //     filled: true,
                    //     suffixIcon: const Icon(Icons.expand_circle_down),
                    //     focusedBorder: OutlineInputBorder(
                    //       borderSide: BorderSide(color: controller.locationError.value ? AppColor.red : AppColor.black, width: 0.8),
                    //       borderRadius: BorderRadius.circular(10.0),
                    //     ),
                    //     border: OutlineInputBorder(
                    //       borderSide: BorderSide(color: controller.locationError.value ? AppColor.red : AppColor.grey, width: 0.8),
                    //       borderRadius: BorderRadius.circular(10.0),
                    //     ),
                    //   ),
                    // ),


                    CSCPicker(
                      layout: Layout.horizontal,
                      defaultCountry: CscCountry.India,
                      showStates: true,
                      showCities: true,
                      flagState: CountryFlag.DISABLE,

                      disableCountry: true,

                      /// These will be preselected
                      currentState: controller.stateController.text,
                      currentCity: controller.cityController.text,
                      currentCountry: "India",
                      countrySearchPlaceholder: "India",
                      stateSearchPlaceholder: controller.stateController.text,
                      citySearchPlaceholder: controller.cityController.text,

                      ///labels for dropdown
                      countryDropdownLabel: "India",
                      stateDropdownLabel:controller.stateController.text,
                      cityDropdownLabel:controller.cityController.text,

                      onCountryChanged: (value) {

                      },
                      onStateChanged: (value) {
                        controller.stateController.text = value ?? '';
                        controller.cityController.text = '';
                        controller.countryController.text="India";
                      },
                      onCityChanged: (value) {
                        controller.cityController.text = value ?? '';
                      },

                      dropdownDecoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: controller.locationError.value ? AppColor.red : AppColor.grey, width: 0.8),
                      ),
                      disabledDropdownDecoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: Colors.grey.shade400, width: 0.8),
                      ),
                    ),

                    Obx(() => controller.locationError.value
                        ? const Padding(
                      padding: EdgeInsets.only(top: 8.0, left: 12.0),
                      child: Text(
                        'Please select all location fields (State, City)',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    )
                        : const SizedBox.shrink()),
                    boxH10(),
                    CustomTextFormField(
                      controller: controller.localityController,
                      size: 50,
                      maxLines: 2,
                      labelText: 'District / Locality',
                      isRequired: true,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'District / Locality is required';
                        }
                        return null;
                      },
                    ),
                    boxH10(),
                    CustomTextFormField(
                      controller: controller.pinCodeController,
                      size: 50,
                      maxLines: 2,
                      isRequired: true,
                      maxLength: 10,
                      labelText: 'Pincode',
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Pincode is required';
                        }
                        return null;
                      },
                    ),
                    boxH20(),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: commonButton(
                        text: "Looks Good",
                        onPressed: () async {
                          // Reset location error state
                          controller.locationError.value = false;
                          // Validate form fields
                          bool isFormValid = controller.basicInfo.currentState?.validate() ?? false;
                          // Validate location fields
                          bool isLocationValid =
                              controller.stateController.text.isNotEmpty &&
                              controller.cityController.text.isNotEmpty;

                          if (isFormValid && isLocationValid) {
                            Navigator.pop(context);
                            setState(() {
                              controller.currentViewIndex.value++;
                            });
                          } else {
                            // Show inline error for location if not valid
                            if (!isLocationValid) {
                              controller.locationError.value = true;
                            }
                            // Show toast for form validation errors
                            if (!isFormValid) {
                              Fluttertoast.showToast(msg: 'Please fill all required fields.');
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (controller.currentViewIndex.value == 0) {
          Navigator.pop(context); // Exit screen
          return false; // Prevent default pop behavior
        } else {
          goToPreviousView(); // Go to the previous view
          return false; // Prevent default pop behavior
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              boxH30(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  progressLine(getProgress(0, 3), Colors.black),
                  progressLine(getProgress(3, 7), Colors.black),
                  progressLine(
                      getProgress(7, controller.views.length), Colors.black),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Obx(()=>
                  IndexedStack(
                    index: controller.currentViewIndex.value,
                    children: controller.views,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(right: 16.0, left: 16.0, bottom: 16.0),
                child: Column(
                  children: [
                    Divider(color: Colors.grey.withOpacity(0.3)),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: GestureDetector(
                            onTap: () {
                              if (controller.currentViewIndex.value == 0) {
                                Navigator.pop(context);
                              } else {
                                goToPreviousView();
                              }
                            },
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
                                padding: EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 15),
                                child: Text(
                                  "Back",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 13),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        controller.currentViewIndex.value == controller.views.length - 1
                            ?

                        Obx(() => controller.isUploading.value
                            ?  GestureDetector(
                          onTap: () {

                            Get.offAll(() => const MyProperties(isFrom: 'post',));
                          },
                          child: Container(
                            width: 80,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: AppColor.lightPurple,
                              border: Border.all(
                                color: Colors.black.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                "Close",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        )
                            : GestureDetector(
                          onTap: () {
                            if (validationAmanetity() == true) {
                              if (controller.selectedIndex.value == 0) {
                                controller.postProperty();
                              } else {
                                controller.postProject();
                              }
                            }
                          },
                          child: Container(
                            width: 80,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: AppColor.lightPurple,
                              border: Border.all(
                                color: Colors.black.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                "Create",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ))

                            : Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    if (controller.selectedIndex.value == 0) {

                                      print("onTapfreePostCount==>${freePostCount}");
                                      print("paidPostCount==>${paidPostCount}");

                                      // Property case
                                      if (freePostCount != 0 || paidPostCount != 0) {
                                        print("onTapfreePostCount11==>${freePostCount}");
                                        print("paidPostCount11==>${paidPostCount}");
                                        goToNextView("");


                                      } else {

                                        SubscriptionDialog.show(
                                          context: context,
                                          onPurchase: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (_) => const PlansAndSubscription(isfrom: 'property',)),
                                            ).then((_) async {
                                              print("onTapfreePostCount1ee==>${freePostCount}");
                                              print("paidPostCount1cc==>${paidPostCount}");
                                              await checkCount();
                                            });
                                          },


                                          type: 'property',
                                        );

                                      //  goToNextView("");
                                      }
                                    }
                                    else if (controller.selectedIndex.value == 1) {
                                      // Project case
                                      if (projectCount != 0) {
                                        goToNextView("");
                                      } else {
                                        SubscriptionDialog.show(
                                          context: context,
                                          onPurchase: () {
                                            // // Handle purchase flow
                                            // Navigator.push(context, MaterialPageRoute(
                                            //     builder: (_) => const PlansAndSubscription()
                                            // ));

                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (_) => const PlansAndSubscription(isfrom: 'project',)),
                                            ).then((_) async {
                                              await  checkCount();
                                            });
                                          },
                                          type: 'project',
                                        );
                                       // goToNextView("");
                                      }
                                    }
                                  },
                                  child: Container(
                                    width: 80,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: AppColor.lightPurple,
                                      border: Border.all(
                                        color: Colors.black.withOpacity(0.2),
                                        width: 1,
                                      ),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "Next",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
                                      ),
                                    ),
                                  ),
                                ),
                              )
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
  }

  Widget progressLine(double progress, Color color) {
    return SizedBox(
      width: 130,
      height: 5,
      child: LinearProgressIndicator(
        value: progress,
        backgroundColor: Colors.grey[300],
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}

class IntroView extends StatefulWidget {
  final String? isFrom;
  const IntroView({super.key, this.isFrom});
  @override
  _IntroViewState createState() => _IntroViewState();
}

class _IntroViewState extends State<IntroView> {
  final String _message = "Intro View";
  final PostPropertyController controller = Get.find();
  final profileController = Get.find<ProfileController>();
  void ClearFiled() {
    controller.views.clear();
    controller.propertyPriceController.clear();
    controller.isFeatured.value = false;
    controller.countryName.value = '';
    controller.countryController.clear();
    controller.categoryPriceselected.value = -1;
    controller.categorySelected.value = -1;
    controller.selectedProperty.value = 0;
    controller.propertyNameController.clear();
    controller.flatHouseNoController.clear();
    controller.streetAddressController.clear();
    controller.landmarkController.clear();
    controller.localityController.clear();
    controller.cityController.clear();
    controller.stateController.clear();
    controller.pinCodeController.clear();
    controller.addressController.clear();
    controller.coverImgs.value = null;
    controller.logoImgs.value = null;
    controller.pdfFile.value = null;
    controller.videoFile.value = null;
    controller.images1.clear();
    controller.selectedBhk.value = -1;
    controller.selectebathroom.value = -1;
    controller.selectedsqfit.value = '';
    controller.selectedarea.value = '';
    controller.statusController.clear();
    controller.develoeperController.clear();
    controller.buildUpAreaController.clear();
    controller.florController.clear();
    controller.totalFloorController.clear();
    controller.transactionController.clear();
    controller.aboutController.clear();
    controller.RoomsConroller.clear();
    controller.selectedamenities.clear();
    controller.furnishType.value = null;

    controller.LivingController.clear();
    controller.KitchenController.clear();
    controller.BedroomController.clear();
    controller.BalconyController.clear();

    controller.DiningController.clear();
    controller.ToiletsConroller.clear();
    controller.ServantConroller.clear();
    controller.ceilingLivingController.clear();
    controller.ceilingServantController.clear();
    controller.counterKitchenController.clear();
    controller.fittingKitchenController.clear();
    controller.fittingToiletController.clear();

    controller.internalDoorController.clear();
    controller.externalGlazingController.clear();
    controller.electricalController.clear();
    controller.backupController.clear();
    controller.securitySystemController.clear();
    controller.priceDetailsList.clear();
    controller.bathrrom.value = '';
    controller.bhkType.value = '';
    controller.selectedConstructionStatus.value = '';
    controller.totalProjectSizeController.clear();
    controller.UnitController.clear();
    controller.securityDepositController.clear();
    controller.Facing.value = '';
    controller.View.value = '';
    controller.LiftAvailability.value = '';
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Hello, ${profileController.name}",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
          boxH05(),
          const Text(
            "You can add your property using Houzza AI ",
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          boxH25(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Start a new listing",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: AppColor.boldColor,
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                  child: Center(
                    child: Text(
                      'FREE',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          boxH15(),
          Expanded(
            child: Obx(() {
              var filteredItems = profileController.userType.value.toLowerCase() == 'owner'
                  ? controller.items.where((item) => item['title'] == 'New Property').toList()
                  : controller.items;

              // Apply isFrom filtering
              if (widget.isFrom == 'myprojects') {
                filteredItems = filteredItems.asMap().entries
                    .where((entry) => entry.key != 0)
                    .map((entry) => entry.value)
                    .toList();
              }
              else if (widget.isFrom == 'myproperties') {
                filteredItems = filteredItems.asMap().entries
                    .where((entry) => entry.key != 1)
                    .map((entry) => entry.value)
                    .toList();
              }


              return ListView.builder(
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: GestureDetector(
                      onTap: () {
                        ClearFiled();
                        setState(() {
                          controller.countryName.value = '';
                          controller.countryController.clear();
                          if (widget.isFrom == 'myprojects'){
                            controller.selectedIndex.value = 1;
                          }else if(widget.isFrom == 'myproperties'){
                            controller.selectedIndex.value = 0;
                          }else {
                            controller.selectedIndex.value = (controller.selectedIndex.value == index) ? 0 : index;
                          }
                          if(controller.selectedIndex.value == 1)
                            {
                              controller.residentalpropertyTypes.assignAll([
                                'Apartment',
                                'Plot',
                                'Independent House',
                                'Villa',
                                'Builder Floor',
                                'Penthouse',
                                // 'PG'
                              ]);
                              controller.categorytype.value = 'Residential'; // default building type for project
                              print("type ==>>> ${controller.categorytype.value}");
                            }
                          controller.views.clear();
                        });

                        if (filteredItems[index]['title'] == 'New Property') {
                          setState(() {
                            controller.views.add(IntroView(isFrom: widget.isFrom));
                            controller.views.add(PlaceView());
                            controller.views.add(PropertyTypeView());
                            controller.views.add(BasicInfoView());
                            controller.views.add(const priceView());
                            controller.views.add(const add_propertyImage());
                            controller.views.add(const uploadProperyImage());
                            controller.views.add(const areaView());
                            controller.views.add(const moreDetailsProperty());
                            controller.views.add(const aboutProperty());
                            controller.views.add(const addAmenitiesView());
                          });
                        }
                        else {
                          setState(() {
                            controller.views.add(IntroView(isFrom: widget.isFrom));
                            // controller.views.add(PlaceView());
                            controller.views.add(PropertyTypeView());
                            controller.views.add(BasicInfoView());
                            controller.views.add(const projectPriceDetails());
                            controller.views.add(const add_propertyImage());
                            controller.views.add(const uploadProperyImage());
                            controller.views.add(const aboutProperty());
                            controller.views.add(const moreDetailsProperty());
                            controller.views.add(const floorPlanView());
                            controller.views.add(const celingView());
                            controller.views.add(const doorView());
                            controller.views.add(const addAmenitiesView());
                          });
                        }
                        print(controller.selectedIndex.value);
                        print(controller.currentViewIndex.value);

                        if (index < controller.views.length - 1) {
                          setState(() {
                            controller.currentViewIndex.value++;
                          });

                        }

                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white.withOpacity(0.7),
                          border: Border.all(
                            color: controller.selectedIndex.value == index ? Colors.black : Colors.grey,
                            width: 1,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Image.asset(
                                filteredItems[index]['image'],
                                height: 70,
                                width: 70,
                              ),
                              const SizedBox(width: 15),
                              Text(
                                filteredItems[index]['title'],
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                ),
                              ),
                              const Spacer(),
                              const Icon(Icons.arrow_forward),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

class PlaceView extends StatefulWidget {
  @override
  _PlaceViewState createState() => _PlaceViewState();
}

class _PlaceViewState extends State<PlaceView> {
  final String _message = "Place View";
  final PostPropertyController controller = Get.find();
  void updatePropertyFields(String propertyType) {
    List<String> bhkTypes = [
      "Studio",
      "1 RK",
      "1 BHK",
      "1.5 BHK",
      "2 BHK",
      "2.5 BHK",
      "3 BHK",
      "3.5 BHK",
      "4 BHK",
      "5 BHK",
      "6 BHK",
    ];
    List<String> additionalTypes = [
      "Pooja Room",
      "Servant Room",
      "Study Room",
      "Extra Room"
    ];
    List<String> balconyList = ["Connected", "Individual", "Room-attached"];
    List<String> ageOfProperty = ["0-1", "2-4", "5-7", "8-10", "10+"];
    List<String> coveredParkingList = ["1", "2", "3", "4", "5", "6", "6+"];
    List<String> unCoveredParkingList = [
      "N/A",
      "1",
      "2",
      "3",
      "4",
      "5",
      "6",
      "6+"
    ];
    List<String> possessionStatus = ["Ready To Move", "Under Construction"];
    Map<String,String> constructionStatus = {"Completed":"Ready To Move", "Ongoing":"Under Construction"};
    List<String> bathroomTypes = ["1", "2", "3", "4", "5", "6", "6+"];
    List<String> powerBackupList = ["No Back-up", "Available"];
    List<String> facingList = [
      "East",
      "West",
      "North",
      "South",
      "North East",
      "North West",
      "South East",
      "South West"
    ];
    List<String> viewList = [
      "Beach View",
      "Garden View",
      "Golf View",
      "Lake View",
      "Park View",
      "Road View",
      "Community View",
      "Pool View",
      "Creek View",
      "Sea View"
    ];
    List<String> liftAvailabilityList = ["Yes", "No"];
    List<String> flooringList = [
      "Marble",
      "Concrete",
      "Cemented",
      "Carpeted",
      "Wooden",
      "Others"
    ];
    List<String> seatsTypeList = [
      "Open Seat",
      "Private Cabin",
      "Conference Cabin"
    ];
    List<String> roomtypes = [
      'Private Room',
      'Twin Sharing',
      'Triple Sharing',
      'Quad Sharing',
    ];
    List<String> pgFoods = ['Breakfast', 'Lunch', 'Dinner'];
    List<String> notice = [
      '15',
      '30',
      '45',
      'Others',
    ];
    List<String> operatingScience = [
      '0-1',
      '2-4',
      '5-8',
      '9-12',
      '13+',
    ];
    List<String> pgRule = [
      'No Smoking',
      'No Guardians Stay',
      'No Drinking',
      'No Non-Veg',
      'Visiter Allow',
      'Party',
      'Loud music',
      'Opposite Gender',
    ];
    List<String> pgService = [
      'Wifi',
      'Laundary Service',
      'Wheelchair Friendly',
      'Pet Friendy',
      'Room Cleaning',
    ];

    controller.bhkTypes.assignAll(bhkTypes);
    controller.additionalType.assignAll(additionalTypes);
    controller.BalconyList.assignAll(balconyList);
    controller.AgeofProperty.assignAll(ageOfProperty);
    controller.CoveredParkingList.assignAll(coveredParkingList);
    controller.UnCoveredParkingList.assignAll(unCoveredParkingList);
    controller.PossessionStatus.assignAll(possessionStatus);
    controller.projectConstructionStatus.value = constructionStatus;
    controller.bathroomypes.assignAll(bathroomTypes);
    controller.PoweBackupList.assignAll(powerBackupList);
    controller.FacingList.assignAll(facingList);
    controller.ViewList.assignAll(viewList);
    controller.LiftAvailabilityList.assignAll(liftAvailabilityList);
    controller.FlooringList.assignAll(flooringList);
    controller.seatsTypeList.assignAll(seatsTypeList);
    controller.WaterSourceList.assignAll(
        ["Municipal Supply", "Borewell/ Underground", "Others"]);
    if (controller.selectedPropertyType.value == "PG") {
      controller.roomTypeList.assignAll(roomtypes);
      controller.foodAvailableList.assignAll(pgFoods);
      controller.NoticePeriodDaysList.assignAll(notice);
      controller.OperatingSinceYearsList.assignAll(operatingScience);
      controller.PG_HostelRulesList.assignAll(pgRule);
      controller.AvailablePGServicesList.assignAll(pgRule);
    }

    if (controller.categorytype.value == 'Residential') {
      if (controller.CategoryPriceType.value == "Sell") {
        controller.AgeofProperty.assignAll(ageOfProperty);
        controller.selectedPropertyType.value == "Plot"
            ? controller.bhkType.value = ''
            : null;
      }
    }
  }
  void ClearFiled() {

    controller.bhkType.value="";
    controller.bathrrom.value="";
    controller.selectedsqfit.value="";
    controller.selectedarea.value="";
    controller.selectedPossessionStatus.value="";
    controller.furnishType.value="";
    controller.AgeProperty.value="";
    controller.selectedPossessionStatus.value="";
    controller.CoveredParking.value="";
    controller.PoweBackup.value="";
    controller.Facing.value="";
    controller.View.value="";
    controller.Flooring.value="";
    controller.Pantry.value="";
    controller.PersonalWashroom.value="";
    controller.LiftAvailability.value="";
    controller.isParkingAvailable.value="";
    controller.selectedSeatsType.value="";
    controller.OfficeSpaceType.value="";
    controller.selectedSeatsType.value="";
    controller.selectedSuitedFor.value="";
    controller.selectedAdditionalRooms.clear();
    controller.selectedBalconyList.clear();
    controller.ceilingHeightController.clear();

    controller.UnitController.clear();
    controller.totalFloorController.clear();
    controller.florController.clear();
    controller.buildUpAreaController.clear();
    controller.numberofSeatsAvailableController.clear();

  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Which of these best describes your place?",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
          boxH15(),
          if (controller.selectedIndex.value == 0) ...[

           const  RequiredTextWidget(label: 'Category Type'),
            boxH10(),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.categoryPriceType.length,
                    itemBuilder: (context, index) {
                      bool isSelected =
                          controller.categoryPriceselected.value == index;
                      return GestureDetector(
                        onTap: () {

                          setState(() {
                            controller.categoryPriceselected.value = index;
                            controller.CategoryPriceType.value =
                                controller.categoryPriceType[index];
                            controller.showCategoryPriceError.value = false;
                            print(controller.CategoryPriceType.value);
                            print(controller.categoryPriceselected.value);





                          });
                        },
                        child: Container(
                          width: 160,
                          margin: const EdgeInsets.symmetric(horizontal: 6.0),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.white.withOpacity(0.7),
                            border: Border.all(
                              color: isSelected ? Colors.black : Colors.grey,
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              controller.categoryPriceType[index],
                              style: TextStyle(
                                color: isSelected ? Colors.black : Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Obx(() => controller.showCategoryPriceError.value
                    ? const Padding(
                        padding: EdgeInsets.all( 8.0),
                        child: Text(

                          "Please Select Category Type",

                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      )
                    : const SizedBox.shrink()),
              ],
            ),
          ],
          boxH30(),
          const  RequiredTextWidget(label: 'Building Type'),
          boxH10(),
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.categoryType.length,
                itemBuilder: (context, index) {
                  bool categoryIsSelected =
                      controller.categorySelected.value == index;
                  return GestureDetector(
                    onTap: () async {
                      setState(() {
                        ClearFiled();
                        controller.categorySelected.value = index;
                        controller.categorytype.value =
                            controller.categoryType[index];
                        controller.showCategorError.value = false;
                        print(controller.categoryType[index]);
                        print(controller.categorySelected);


                        controller.selectedPropertyType.value=controller.categorySelected.value==0?"Apartment":"Office Space";
                        controller. propertytype.value=controller.categorySelected.value==0?"Apartment":"Office Space";
                        print(controller.selectedPropertyType.value);
                        print(controller.propertytype.value);

                      });



                      updatePropertyFields(controller.selectedPropertyType.value);

                    },
                    child: Container(
                      width: 160,
                      margin: const EdgeInsets.symmetric(horizontal: 6.0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.white.withOpacity(0.7),
                        border: Border.all(
                          color:
                              categoryIsSelected ? Colors.black : Colors.grey,
                          width: 1,
                        ),
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
                                    ? Colors.black
                                    : Colors.grey,
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
            Obx(() => controller.showCategorError.value
                ? const Padding(
                    padding: EdgeInsets.all( 8.0),
                    child: Text(
                      "Please Select Building Type",
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  )
                : const SizedBox.shrink()),
        ],
      ),
    );
  }


}

class PropertyTypeView extends StatefulWidget {
  @override
  _PropertyTypeViewState createState() => _PropertyTypeViewState();
}

class _PropertyTypeViewState extends State<PropertyTypeView> {
  final PostPropertyController controller = Get.find();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  void ClearFiled() {

    controller.bhkType.value="";
    controller.bathrrom.value="";
    controller.selectedsqfit.value="";
    controller.selectedarea.value="";
    controller.selectedPossessionStatus.value="";
    controller.furnishType.value="";
    controller.AgeProperty.value="";
    controller.selectedPossessionStatus.value="";
    controller.CoveredParking.value="";
    controller.PoweBackup.value="";
    controller.Facing.value="";
    controller.View.value="";
    controller.Flooring.value="";
    controller.Pantry.value="";
    controller.PersonalWashroom.value="";
    controller.LiftAvailability.value="";
    controller.isParkingAvailable.value="";
    controller.selectedSeatsType.value="";
    controller.OfficeSpaceType.value="";
    controller.selectedSeatsType.value="";
    controller.selectedSuitedFor.value="";
    controller.selectedAdditionalRooms.clear();
    controller.selectedBalconyList.clear();
    controller.ceilingHeightController.clear();

    controller.UnitController.clear();
    controller.totalFloorController.clear();
    controller.florController.clear();
    controller.buildUpAreaController.clear();
    controller.numberofSeatsAvailableController.clear();

  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Text( controller.selectedIndex.value == 0 ? 
            "Property type" : "Project type",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
          boxH10(),
          Expanded(
              child: Obx(() => ListView.builder(
                    itemCount: controller.categorytype.value == 'Residential'
                        ? controller.residentalpropertyTypes.length
                        : controller.commercialPropertyType.length,
                    itemBuilder: (context, index) {
                      bool isSelectedProperty =
                          controller.selectedProperty.value == index;

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 7, horizontal: 9),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              ClearFiled();
                              controller.selectedProperty.value = index;

                              String selectedType = controller
                                          .categorytype.value ==
                                      'Residential'
                                  ? controller.residentalpropertyTypes[index]
                                  : controller.commercialPropertyType[index];
                              controller.selectedPropertyType.value =
                                  selectedType;
                              controller.propertytype.value = selectedType;
                              print(controller.selectedPropertyType.value);

                              print("selectedType==>$selectedType");
                              updatePropertyFields(selectedType);

                              // Special handling for "Plot" type
                              if (controller.selectedPropertyType.value ==
                                  "Plot") {
                                controller.bhkType.value = '';
                              }
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white.withOpacity(0.7),
                              border: Border.all(
                                color: isSelectedProperty
                                    ? Colors.black
                                    : Colors.grey,
                                width: 1,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/welcomePage/welcomeHouse.png',
                                    height: 70,
                                    width: 70,
                                  ),
                                  const SizedBox(width: 15),
                                  Text(
                                    controller.categorytype.value ==
                                            'Residential'
                                        ? controller
                                            .residentalpropertyTypes[index]
                                        : controller
                                            .commercialPropertyType[index],
                                    style: TextStyle(
                                      color: isSelectedProperty
                                          ? Colors.black
                                          : Colors.grey,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const Spacer(),
                                  const Icon(Icons.arrow_forward, size: 25),
                                  boxW10(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
              )),
          const SizedBox(
            height: 5,
          ),
          Obx(() => controller.showpropertyForError.value
              ?  Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(

                    controller.selectedIndex.value == 0 ?  "Please Select Property Type" : "Please Select Project Type",
                    style:const TextStyle(color: Colors.red, fontSize: 12),

                  ),
                )
              : const SizedBox.shrink()),
          const SizedBox(
            height: 50,
          )
        ],
      ),
    );
  }

  void updatePropertyFields(String propertyType) {
    List<String> bhkTypes = [
      "Studio",
      "1 RK",
      "1 BHK",
      "1.5 BHK",
      "2 BHK",
      "2.5 BHK",
      "3 BHK",
      "3.5 BHK",
      "4 BHK",
      "5 BHK",
      "6 BHK",
    ];
    List<String> additionalTypes = [
      "Pooja Room",
      "Servant Room",
      "Study Room",
      "Extra Room"
    ];
    List<String> balconyList = ["Connected", "Individual", "Room-attached"];
    List<String> ageOfProperty = ["0-1", "2-4", "5-7", "8-10", "10+"];
    List<String> coveredParkingList = ["1", "2", "3", "4", "5", "6", "6+"];
    List<String> unCoveredParkingList = [
      "N/A",
      "1",
      "2",
      "3",
      "4",
      "5",
      "6",
      "6+"
    ];
    List<String> possessionStatus = ["Ready To Move", "Under Construction"];
    Map<String,String> constructionStatus = {"Completed":"Ready To Move", "Ongoing":"Under Construction"};
    List<String> bathroomTypes = ["1", "2", "3", "4", "5", "6", "6+"];
    List<String> powerBackupList = ["No Back-up", "Available"];
    List<String> facingList = [
      "East",
      "West",
      "North",
      "South",
      "North East",
      "North West",
      "South East",
      "South West"
    ];
    List<String> viewList = [
      "Beach View",
      "Garden View",
      "Golf View",
      "Lake View",
      "Park View",
      "Road View",
      "Community View",
      "Pool View",
      "Creek View",
      "Sea View"
    ];
    List<String> liftAvailabilityList = ["Yes", "No"];
    List<String> flooringList = [
      "Marble",
      "Concrete",
      "Cemented",
      "Carpeted",
      "Wooden",
      "Others"
    ];
    List<String> seatsTypeList = [
      "Open Seat",
      "Private Cabin",
      "Conference Cabin"
    ];
    List<String> roomtypes = [
      'Private Room',
      'Twin Sharing',
      'Triple Sharing',
      'Quad Sharing',
    ];
    List<String> pgFoods = ['Breakfast', 'Lunch', 'Dinner'];
    List<String> notice = [
      '15',
      '30',
      '45',
      'Others',
    ];
    List<String> operatingScience = [
      '0-1',
      '2-4',
      '5-8',
      '9-12',
      '13+',
    ];
    List<String> pgRule = [
      'No Smoking',
      'No Guardians Stay',
      'No Drinking',
      'No Non-Veg',
      'Visiter Allow',
      'Party',
      'Loud music',
      'Opposite Gender',
    ];
    List<String> pgService = [
      'Wifi',
      'Laundary Service',
      'Wheelchair Friendly',
      'Pet Friendy',
      'Room Cleaning',
    ];

    controller.bhkTypes.assignAll(bhkTypes);
    controller.additionalType.assignAll(additionalTypes);
    controller.BalconyList.assignAll(balconyList);
    controller.AgeofProperty.assignAll(ageOfProperty);
    controller.CoveredParkingList.assignAll(coveredParkingList);
    controller.UnCoveredParkingList.assignAll(unCoveredParkingList);
    controller.PossessionStatus.assignAll(possessionStatus);
    controller.projectConstructionStatus.value = constructionStatus;
    controller.bathroomypes.assignAll(bathroomTypes);
    controller.PoweBackupList.assignAll(powerBackupList);
    controller.FacingList.assignAll(facingList);
    controller.ViewList.assignAll(viewList);
    controller.LiftAvailabilityList.assignAll(liftAvailabilityList);
    controller.FlooringList.assignAll(flooringList);
    controller.seatsTypeList.assignAll(seatsTypeList);
    controller.WaterSourceList.assignAll(
        ["Municipal Supply", "Borewell/ Underground", "Others"]);
    if (controller.selectedPropertyType.value == "PG") {
      controller.roomTypeList.assignAll(roomtypes);
      controller.foodAvailableList.assignAll(pgFoods);
      controller.NoticePeriodDaysList.assignAll(notice);
      controller.OperatingSinceYearsList.assignAll(operatingScience);
      controller.PG_HostelRulesList.assignAll(pgRule);
      controller.AvailablePGServicesList.assignAll(pgRule);
    }

    if (controller.categorytype.value == 'Residential') {
      if (controller.CategoryPriceType.value == "Sell") {
        controller.AgeofProperty.assignAll(ageOfProperty);
        controller.selectedPropertyType.value == "Plot"
            ? controller.bhkType.value = ''
            : null;
      }
    }
  }
}

class BasicInfoView extends StatefulWidget {
  @override
  _BasicInfoViewState createState() => _BasicInfoViewState();
}

class _BasicInfoViewState extends State<BasicInfoView> {
  final PostPropertyController propertyController = Get.find<PostPropertyController>();
  late Completer<GoogleMapController> _controller;
  GoogleMapController? _mapController; // Make nullable to handle disposal
  LatLng _selectedLocation = const LatLng(18.5642, 73.7769);

  @override
  void initState() {
    super.initState();
    _controller = Completer();
  }

  Future<void> _goToLocation(LatLng latLng) async {
    _selectedLocation = latLng;
    if (_mapController != null) {
      await _mapController!.animateCamera(CameraUpdate.newLatLngZoom(latLng, 15));
    }
    await propertyController.getAddressFromLatLng(latLng);
    print(latLng);
    setState(() {});
  }

  @override
  void dispose() {
    _mapController?.dispose(); // Dispose of the map controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Form(
        key: propertyController.basicInfo1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Use Obx to reactively update the title based on selectedIndex
            Obx(() => Text(
              propertyController.selectedIndex.value == 0
                  ? "Property basic info"
                  : "Project basic info",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            )),
            const SizedBox(height: 15),
            CustomTextFormField(
              controller: propertyController.propertyNameController,
              size: 50,
              maxLines: 2,
              maxLength: 250,
              focusNode: propertyController.propertyNameFocusNode,
              hintText: propertyController.selectedIndex.value == 0
                  ? 'Enter Property Name'
                  : 'Enter Project Name',
              labelText: propertyController.selectedIndex.value == 0
                  ? 'Property Name'
                  : 'Project Name',
              isRequired: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return propertyController.selectedIndex.value == 0
                      ? 'Please Enter Property Name'
                      : 'Please Enter Project Name';
                }
                if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                  return 'Please enter only alphabets';
                }
                return null;
              },
            ),
            const SizedBox(height: 15),
            const Text(
              "Where’s your place located?",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: Stack(
                children: [
                  GoogleMap(
                    onMapCreated: (GoogleMapController mapController) {
                      _mapController = mapController;
                      if (!_controller.isCompleted) {
                        _controller.complete(mapController);
                      }
                    },
                    onTap: (LatLng latLng) {
                      _goToLocation(latLng);
                    },
                    markers: {
                      Marker(
                        markerId: const MarkerId("selected-location"),
                        position: _selectedLocation,
                      ),
                    },
                    initialCameraPosition: CameraPosition(
                      target: _selectedLocation,
                      zoom: 13,
                    ),
                    myLocationEnabled: true,
                    zoomControlsEnabled: false,
                  ),
                  Positioned(
                    top: 20,
                    left: 15,
                    right: 15,
                    child: Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(10),
                      child: GooglePlaceAutoCompleteTextField(
                        textEditingController: propertyController.addressController,
                        focusNode: propertyController.addressFocusNode,
                        //googleAPIKey: 'AIzaSyDY-oB0QysTXFJu2cOMlZvpwANBR2XS84E',
                       // googleAPIKey: 'AIzaSyBvxPKGiyGXholpqjbnpElgrUNvcUQbZp8',
                       //  googleAPIKey:'AIzaSyBvxPKGiyGXholpqjbnpElgrUNvcUQbZp8',
                        googleAPIKey:'AIzaSyAt8bj4UACvakZfiSy-0c1o_ivfplm7jEU',
                        inputDecoration: InputDecoration(
                          hintText: "Enter your address",
                          prefixIcon: const Icon(Icons.search),
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
                        getPlaceDetailWithLatLng: (prediction) {
                          final lat = double.parse(prediction.lat!);
                          final lng = double.parse(prediction.lng!);
                          _goToLocation(LatLng(lat, lng));
                        },
                        itemClick: (prediction) {
                          propertyController.addressFocusNode.unfocus();
                          setState(() {
                            propertyController.addressController.text = prediction.description!;
                            propertyController.streetAddressController.text = prediction.description!;
                          });

                          print("prediction.description0->");
                          print(prediction.description);

                        },
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
}

class priceView extends StatefulWidget {
  const priceView({super.key});
  @override
  State<priceView> createState() => _priceViewState();
}
class _priceViewState extends State<priceView> {
  final PostPropertyController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Form(
        key:controller.priceFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(()=>
               Text(
                controller.categoryPriceselected.value == 0
                    ? "Property Price"
                  //  : "Property Rent",
                    : "Property Rent",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
            ),
            boxH15(),


            Obx(()=>
               CustomTextFormField(
                controller: controller.propertyPriceController,
                onChanged: (value) {
                  controller.propertyPrice.value = value;
                },
                keyboardType: TextInputType.number,
                size: 60,
                maxLines: 2,maxLength: 20,

                labelText:controller.categoryPriceselected.value == 0? 'Enter Amount':'Enter Rent Amount',
                isRequired: true,
                validator: (value) {
                if (value == null || value.isEmpty) {
                  return controller.categoryPriceselected.value == 0 ? 'Please Enter Amount' : 'Please Enter Rent Amount';
                }
                return null;
                },
              ),),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Obx(() {
                double priceAsDouble = double.tryParse(controller.propertyPrice.value) ?? 0.0;
                int roundedPrice = priceAsDouble.round();
                String priceInWords = controller.convertNumberToWords(roundedPrice);

                return Text(
                  priceInWords.isNotEmpty
                      ? priceInWords + "."
                      : "Enter your amount",
                  style: TextStyle(
                      color: controller.propertyPrice.value.isNotEmpty
                          ? Colors.green
                          : Colors.grey,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold),
                  maxLines: 3,
                );
              }),
            ),


            Obx(() {
              if (controller.categoryPriceselected.value == 1) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const SizedBox(height: 10),

                    CustomTextFormField(
                      controller: controller.securityDepositController,
                      labelText: 'Security Deposit',
                      size: 60,
                      maxLines: 2,maxLength: 20,
                      isRequired: true,
                      onChanged: (value) {
                        controller.deposite.value = value;
                      },
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Security Deposit';
                        }
                        return null;
                      },
                    ),

                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Obx(() {
                    //     int priceAsInt =
                    //         int.tryParse(controller.deposite.value) ?? 0;
                    //     String priceInWords = controller.convertNumberToWords(priceAsInt);
                    //
                    //     return Text(
                    //       priceInWords.isNotEmpty
                    //           ? priceInWords + "."
                    //           : "Enter your amount",
                    //       style: TextStyle(
                    //           color: controller.deposite.value != null
                    //               ? Colors.green
                    //               : Colors.grey,
                    //           fontSize: 14.0,
                    //           fontWeight: FontWeight.bold),
                    //       maxLines: 3,
                    //     );
                    //   }),
                    // ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Obx(() {
                        double priceAsDouble = double.tryParse(controller.deposite.value) ?? 0.0;
                        int roundedPrice = priceAsDouble.round();
                        String priceInWords = controller.convertNumberToWords(roundedPrice);

                        return Text(
                          priceInWords.isNotEmpty
                              ? priceInWords + "."
                              : "Enter your amount",
                          style: TextStyle(
                              color: controller.deposite.value.isNotEmpty
                                  ? Colors.green
                                  : Colors.grey,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold),
                          maxLines: 3,
                        );
                      }),
                    ),


                  ],
                );
              } else {
                return const SizedBox();
              }
            }),



            boxH15(),
            Container(
                width: Get.width,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: AppColor.bold1Color,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Image.asset("assets/NewThemChangesAssets/Vector.png"),
                      boxW15(),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Rs. 1,40,00,000 - Rs. 2,50,000",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                          Text(
                            "Suggested price for your area",
                            style: TextStyle(color: Colors.black54, fontSize: 15),
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class add_propertyImage extends StatefulWidget {
  const add_propertyImage({super.key});
  @override
  State<add_propertyImage> createState() => _add_propertyImageState();
}

class _add_propertyImageState extends State<add_propertyImage> {
  final PostPropertyController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            'assets/welcomePage/welcomeHouse.png',
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: GestureDetector(
              onTap: () {},
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
                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
                  child: Text(
                    "Step 1",
                    style: TextStyle(color: Colors.black, fontSize: 13),
                  ),
                ),
              ),
            ),
          ),
          boxH10(),
          const Text(
            "Upload your property Images",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
          const Text(
            "Share some basic info, such as property name, type and price",
            style: TextStyle(fontSize: 15, color: Colors.black54),
          ),
          boxH15(),
        ],
      ),
    );
  }
}

class uploadProperyImage extends StatefulWidget {
  const uploadProperyImage({super.key});

  @override
  State<uploadProperyImage> createState() => _UploadPropertyImageState();
}

class _UploadPropertyImageState extends State<uploadProperyImage> {
  final PostPropertyController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.sizeOf(context).height;
    var _width = MediaQuery.sizeOf(context).width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [


            const Text(
              "Upload images/video",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21),
            ),
            boxH20(),

            /// Cover Image Upload
            Obx(() => Padding(
              padding: const EdgeInsets.all(8.0),
              child: DottedBorder(
                color: Colors.grey,
                strokeWidth: 1,
                dashPattern: [6, 3],
                borderType: BorderType.RRect,
                radius: const Radius.circular(10),
                child: Container(
                  width: Get.width,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      // Stack for image + delete button
                      Stack(
                        alignment: Alignment.topRight,
                        children: [
                          // Image section
                          controller.coverImgs.value != null
                              ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              controller.coverImgs.value!,
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                          )
                              : Image.asset(
                            "assets/NewThemChangesAssets/upload_image.png",
                            height: 100,
                            width: 100,
                          ),

                          // Delete button (only shows when image exists)
                          if (controller.coverImgs.value != null)
                            GestureDetector(
                              onTap: () => controller.removeCoverImage(),
                              child: Container(
                                margin: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                padding:const EdgeInsets.all(4),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                        ],
                      ),
                      boxH15(),
                      const Text(
                        "Upload cover image",
                        style: TextStyle(fontSize: 18),
                      ),
                      boxH15(),
                      commonButton(
                        text: "+ Add Cover Photo",
                        onPressed: () => controller.updateCoverImage(),
                      ),
                    ],
                  ),
                ),
              ),
            )),
            Obx(() => controller.showimageError.value
                ? const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      "Upload cover image",
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  )
                : const SizedBox.shrink()),
            boxH20(),
            if(controller.selectedIndex.value == 1)...[
              Obx(() => Padding(
                padding: const EdgeInsets.all(8.0),
                child: DottedBorder(
                  color: Colors.grey,
                  strokeWidth: 1,
                  dashPattern: [6, 3],
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(10),
                  child: Container(
                    width: Get.width,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 15),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child:Column(
                      children: [
                        // Stack for image + delete button
                        Stack(
                          alignment: Alignment.topRight,
                          children: [
                            // Image section
                            controller.logoImgs.value != null
                                ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                controller.logoImgs.value!,
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                            )
                                : Image.asset(
                              "assets/NewThemChangesAssets/upload_image.png",
                              height: 100,
                              width: 100,
                            ),

                            // Delete button (only shows when image exists)
                            if (controller.logoImgs.value != null)
                              GestureDetector(
                                onTap: (){
                                  controller.logoImgs.value = null;
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  padding:const EdgeInsets.all(4),
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        boxH15(),
                        const Text("Upload Project Logo",
                            style: TextStyle(fontSize: 18)),
                        boxH15(),
                        commonButton(
                          text: "+ Add Project Logo",
                          onPressed: () => controller.updateLogoImg(),
                        ),
                      ],
                    ),

                    // Column(
                    //   children: [
                    //     controller.logoImgs.value != null
                    //         ? Image.file(
                    //       controller.logoImgs.value!,
                    //       height: 100,
                    //       width: 100,
                    //       fit: BoxFit.cover,
                    //     )
                    //         : Image.asset(
                    //         "assets/NewThemChangesAssets/upload_image.png"),
                    //     boxH15(),
                    //     const Text("Upload Project Logo",
                    //         style: TextStyle(fontSize: 18)),
                    //     boxH15(),
                    //     commonButton(
                    //       text: "+ Add Project Logo",
                    //       onPressed: () => controller.updateLogoImg(),
                    //     ),
                    //   ],
                    // ),
                  ),
                ),
              )),
              Obx(() => controller.showLogoError.value
                  ? const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  "logo is required",
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              )
                  : const SizedBox.shrink()),
              boxH20(),
            ],
            /// Additional Images Upload
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DottedBorder(
                color: Colors.grey,
                strokeWidth: 1,
                dashPattern: [6, 3],
                borderType: BorderType.RRect,
                radius: const Radius.circular(10),
                child: Container(
                  width: Get.width,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Image.asset(
                          "assets/NewThemChangesAssets/upload_image.png"),
                      boxH15(),
                      const Text("Upload additional images",
                          style: TextStyle(fontSize: 18)),
                      boxH15(),
                      SizedBox(
                        width: 200,
                        height: 50,
                        child: commonButton(
                          text: "+ Add Photos",
                          onPressed: () => controller.addImages(),
                        ),
                      ),
                      boxH15(),
                      const Text(
                        "Property listing with more than 5 images get 3x more views",
                        style: TextStyle(fontSize: 13, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Obx(() => controller.showadditionaimagesError.value
                ? const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      "You can only select up to 5 images.",
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  )
                : const SizedBox.shrink()),

            boxH20(),

            /// Display Uploaded Images
            Obx(() {
              if (controller.images1.isEmpty) return const SizedBox();

              return SizedBox(
                height: 100,
                width: _width,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.images1.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 20),
                          height: _height * .15,
                          width: _width * .35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: FileImage(controller.images1[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 20,
                          child: GestureDetector(
                            onTap: () => controller.images1.removeAt(index),
                            child: Container(
                              width: 38,
                              height: 35,
                              decoration: const BoxDecoration(
                                color: Colors.black45,
                              ),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              );
            }),

            const SizedBox(
              height: 10,
            ),

            Obx(() => DottedBorder(
                  color: Colors.grey,
                  strokeWidth: 1,
                  dashPattern: [6, 3],
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(10),
                  child: Container(
                    width: Get.width,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 15),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: controller.isCompressingVideo.value?
                    const Center(
                        child: Column(
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 10),
                            Text("Compressing video, please wait..."),
                          ],
                        )):
                    Column(
                      children: [
                        // Video preview section
                        if (controller.videoFile.value != null)
                          Obx(()=>
                             GestureDetector(
                              onTap: () => showVideoPreview(
                                  controller.videoFile.value!.path),

                              child:
                              Container(
                                height: 150,
                                width: Get.width * 0.4,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.grey.shade50,
                                ),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    VideoPlayerWidget(
                                      videoPath: controller.videoFile.value!.path,
                                      autoPlay: false,
                                    ),
                                    Icon(
                                      Icons.play_circle_fill,
                                      size: 50,
                                      color: Colors.white.withOpacity(0.8),
                                    ),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                          size: 25,
                                        ),
                                        onPressed: () {
                                          controller.videoFile.value = null;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        else
                          Column(
                            children: [
                              Image.asset(
                                "assets/images/png/ic_uploadVideo.png",
                                width: 150,
                                color: Colors.grey,
                              ),
                              const Text("Upload Video",
                                  style: TextStyle(fontSize: 18)),
                            ],
                          ),
                        controller.selectedVideoOption.value !=
                            'Upload Video'?
                        SizedBox():
                        const Text(
                          "⚠️ Video too large! Please select a video smaller than 30 MB.",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        boxH20(),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              width: Get.width * 0.36,
                              child: DropdownButtonFormField<String>(
                                value: controller.selectedVideoOption.value,
                                isExpanded: true,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                items: [
                                  'Upload Video',
                                  'YouTube Link',
                                  'Other Video Link',
                                ].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  controller.selectedVideoOption.value =
                                      newValue!;
                                },
                              ),
                            ),
                            controller.selectedVideoOption.value !=
                                    'Upload Video'
                                ? SizedBox(
                                    width: Get.width * 0.45,
                                    height: 50,
                                    child: Center(
                                      child: TextField(
                                        controller:
                                            controller.videoUrlController,
                                        decoration: InputDecoration(
                                          hintText: controller
                                                      .selectedVideoOption
                                                      .value ==
                                                  'YouTube Link'
                                              ? 'Enter YouTube URL'
                                              : 'Enter Video URL',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : SizedBox(
                                    width: Get.width * 0.38,
                                    height: 50,
                                    child: commonButton(
                                      text: "+ Add Video",
                                      onPressed: () =>
                                          controller.pickVideoFromGallery(),
                                    ),
                                  ),
                          ],
                        ),
                        boxH15(),
                      ],
                    ),
                  ),
                )),
boxH10(),
            controller.selectedIndex.value == 1 ? Obx(() => Padding(
              padding: const EdgeInsets.all(8.0),
              child: DottedBorder(
                color: Colors.grey,
                strokeWidth: 1,
                dashPattern: [6, 3],
                borderType: BorderType.RRect,
                radius: const Radius.circular(10),
                child: Container(
                  width: Get.width,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      controller.pdfFile.value != null
                          ? Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Column(
                            children: [
                              const Icon(Icons.picture_as_pdf, size: 50, color: Colors.red),
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0, right: 20.0),
                                child: Text(
                                  controller.pdfFileName.value,
                                  style: const TextStyle(fontSize: 12),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () {
                                controller.pdfFile.value = null;
                                controller.pdfFileName.value = '';
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.black54,
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(4),
                                child: const Icon(Icons.close, color: Colors.white, size: 16),
                              ),
                            ),
                          ),
                        ],
                      )
                          : Image.asset(
                        "assets/images/png/cloud-computing.png",
                        width: 130,
                        color: Colors.grey,
                      ),

                      boxH15(),
                      const Text("Upload Brochure PDF", style: TextStyle(fontSize: 18)),
                      boxH15(),

                      /// Add Brochure PDF Button
                      commonButton(
                        text: "+ Add Brochure PDF",
                        onPressed: () => controller.updatePdfFile(),
                      ),
                    ],
                  ),
                ),
              ),

            )) : const SizedBox.shrink(),


            const SizedBox(height: 15,),

            // Yes/No Checkboxes or Radio Buttons
            Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Virtual Tour",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  "This step allows users to indicate if a virtual tour is available for the property.",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 16),

                DropdownButtonFormField<bool>(
                  decoration: const InputDecoration(
                    labelText: "Is Virtual Tour Available?",
                    border: OutlineInputBorder(),
                  ),
                  value: controller.isVirtualTourAvailable.value,
                  items: const [
                    DropdownMenuItem(value: true, child: Text("Yes")),
                    DropdownMenuItem(value: false, child: Text("No")),
                  ],
                  onChanged: (value) {
                    controller.isVirtualTourAvailable.value = value!;
                    print("Selected: $value");
                  },
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }
}

class configurationView extends StatefulWidget {
  const configurationView({super.key});

  @override
  State<configurationView> createState() => _configurationViewState();
}

class _configurationViewState extends State<configurationView> {
  final PostPropertyController controller = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Configuration ",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
          boxH15(),
          const Text(
            "BHK",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
          ),
          boxH15(),
          SizedBox(
            height: 50,
            child: Obx(
              () => ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.bhkTypes.length,
                itemBuilder: (context, index) {
                  bool isSelectedProperty =
                      controller.selectedBhk.value == index;
                  return GestureDetector(
                    onTap: () async {
                      setState(() {
                        controller.selectedBhk.value = index;
                        controller.bhkType.value = controller.bhkTypes[index];
                        controller.showbhkError.value = false;
                        print(controller.bhkTypes[index]);
                      });
                    },
                    child: Container(
                      width: 160,
                      margin: const EdgeInsets.symmetric(horizontal: 6.0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.white.withOpacity(0.7),
                        border: Border.all(
                          color:
                              isSelectedProperty ? Colors.black : Colors.grey,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: Text(
                              controller.bhkTypes[index],
                              style: TextStyle(
                                color: isSelectedProperty
                                    ? Colors.black
                                    : Colors.grey,
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
          ),
          Obx(() => controller.showbhkError.value
              ? const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(
                    "Please select above.",
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                )
              : const SizedBox.shrink()),
          boxH15(),
          const Text(
            "Bathroom",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
          ),
          boxH15(),
          SizedBox(
            height: 50,
            child: Obx(
              () => ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.bathroomypes.length,
                itemBuilder: (context, index) {
                  bool isSelectedProperty =
                      controller.selectebathroom.value == index;
                  return GestureDetector(
                    onTap: () async {
                      setState(() {
                        controller.selectebathroom.value = index;
                        controller.bathrrom.value =
                            controller.bathroomypes[index];

                        controller.showbhatroomError.value = false;

                        print(controller.bathroomypes[index]);
                      });
                    },
                    child: Container(
                      width: 160,
                      margin: const EdgeInsets.symmetric(horizontal: 6.0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.white.withOpacity(0.7),
                        border: Border.all(
                          color:
                              isSelectedProperty ? Colors.black : Colors.grey,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: Text(
                              controller.bathroomypes[index],
                              style: TextStyle(
                                color: isSelectedProperty
                                    ? Colors.black
                                    : Colors.grey,
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
          ),
          Obx(() => controller.showbhatroomError.value
              ? const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(
                    "Please select above.",
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                )
              : const SizedBox.shrink()),
        ],
      ),
    );
  }
}

class areaView extends StatefulWidget {
  const areaView({super.key});

  @override
  State<areaView> createState() => _areaViewState();
}

class _areaViewState extends State<areaView> {
  final PostPropertyController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Form(
        key: controller.areaFormKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() =>  Text(
                controller.selectedPropertyType.value != "Plot" && controller.selectedPropertyType.value != "Land" && controller.selectedPropertyType.value != "Warehouse"
                    ? "Configuration & Area Details" : 'Area Details',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),),
              boxH15(),
              Obx(() => Visibility(
                visible: controller.categorySelected.value == 0 && controller.selectedPropertyType.value != "Plot"
                    && controller.selectedPropertyType.value != "PG",
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            width: Get.width,
                            decoration: BoxDecoration(
                              borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                              color: AppColor.white,
                              border: Border.all(
                                color: Colors.grey.shade300,
                                width: 2.0,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                const   RequiredTextWidget(label: 'BHK'),
                                  DropdownButton<String>(
                                    value: controller.bhkTypes
                                        .contains(controller.bhkType.value)
                                        ? controller.bhkType.value
                                        : null,
                                    hint: const Text("Select BHK"),
                                    onChanged: (String? newValue) {
                                      controller.bhkType.value = newValue!;
                                      controller.showbhkError.value = false;
                                      print(controller.showbhkError.value);
                                    },
                                    items: controller.bhkTypes
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                    underline: const SizedBox(),
                                    isExpanded: true,
                                    icon: const Icon(Icons.arrow_drop_down,
                                        color: Colors.grey),
                                  ),
                                ],
                              ),
                            )),
                        if (controller.showbhkError.value)
                          const Padding(
                            padding: EdgeInsets.only(top: 4, left: 8),
                            child: Text(
                              "Please select BHK Type",
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          )
                      ],
                    ),
                    boxH10(),
                  ],
                ),
              ),),
              Obx(() => Visibility(
                visible: controller.selectedPropertyType.value != "Plot" && controller.selectedPropertyType.value != "Land" && controller.selectedPropertyType.value != "Warehouse",
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            width: Get.width,
                            decoration: BoxDecoration(
                              borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                              color: AppColor.white,
                              border: Border.all(
                                color: Colors.grey.shade300,
                                width: 2.0,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                 const RequiredTextWidget(label: 'Bathroom'),
                                  DropdownButton<String>(
                                    value: controller.bathroomypes
                                        .contains(controller.bathrrom.value)
                                        ? controller.bathrrom.value
                                        : null,
                                    hint: const Text("Select bathroom"),
                                    onChanged: (String? newValue) {
                                      controller.bathrrom.value = newValue!;
                                      controller.showbhatroomError.value = false;


                                    },
                                    items: controller.bathroomypes
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                    underline: const SizedBox(),
                                    isExpanded: true,
                                    icon: const Icon(Icons.arrow_drop_down,
                                        color: Colors.grey),
                                  ),
                                ],
                              ),
                            )),
                        if (controller.showbhatroomError.value)
                          const Padding(
                            padding: EdgeInsets.only(top: 4, left: 8),
                            child: Text(
                              "Please select bathroom unit",
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          )
                      ],
                    ),
                    boxH10(),
                    const Divider(
                      color: Colors.grey,
                    ),
                    boxH10(),
                  ],
                ),
              ),),

              CustomTextFormField(
                controller: controller.buildUpAreaController,
                // onChanged: (value) {
                //   controller.propertyPrice.value = value;
                // },
                keyboardType: TextInputType.number,
                size: 50,
                maxLines: 2,maxLength: 10,
                labelText: 'Built-up Area (sq. ft.)',isRequired: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter built-up area';
                  }
                  return null;
                },
              ),

              boxH10(),
              Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: Get.width,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      color: AppColor.white,
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 2.0,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const RequiredTextWidget(label: 'Area In'),
                          DropdownButton<String>(
                            value: controller.selectedsqfit.value.isNotEmpty
                                ? controller.selectedsqfit.value
                                : null,
                            hint: const Text("Select Area In"),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                controller.selectedsqfit.value = newValue;
                                controller.showSqfitError.value = false;

                                print( "controller.selectedarea.value==>");
                                print( controller.selectedarea.value);



                                setState(() {});
                              }
                            },
                            items: controller.sqFitType
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            underline: const SizedBox(),
                            isExpanded: true,
                            icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (controller.showSqfitError.value)
                    const Padding(
                      padding: EdgeInsets.only(top: 4, left: 8),
                      child: Text(
                        "Please select area unit",
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                ],
              )),

              boxH10(),
              Obx(() => Visibility(
                visible: controller.selectedPropertyType.value != "Plot" && controller.selectedPropertyType.value != "Land"
                    && controller.selectedPropertyType.value != "Industrial Plot",

                child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            width: Get.width,
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              color: AppColor.white,
                              border: Border.all(
                                color: Colors.grey.shade300,
                                width: 2.0,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const   RequiredTextWidget(label: 'Area Type'),



                                  DropdownButton<String>(
                                    value: controller.selectedarea.value.isNotEmpty
                                        ? controller.selectedarea.value
                                        : null,
                                    hint: const Text("Select Area Type"),
                                    onChanged: (String? newValue) {
                                      if (newValue != null) {
                                        controller.selectedarea.value = newValue;
                                        controller.showAreaTypeError.value = false;

                                        print( "controller.selectedarea.value==>");
                                        print( controller.selectedarea.value);
                                        setState(() {});
                                      }
                                    },
                                    items: controller.areaType
                                        .map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    underline: const SizedBox(),
                                    isExpanded: true,
                                    icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
                                  ),

                                ],
                              ),
                            )),
                        if (controller.showAreaTypeError.value)
                          const Padding(
                            padding: EdgeInsets.only(top: 4, left: 8),
                            child: Text(
                              "Please select area type",
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          )
                      ],
                    ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}

class moreDetailsProperty extends StatefulWidget {
  const moreDetailsProperty({super.key});

  @override
  State<moreDetailsProperty> createState() => _moreDetailsPropertyState();
}

class _moreDetailsPropertyState extends State<moreDetailsProperty> {
  final PostPropertyController controller = Get.find();
  final ProfileController _profileController = Get.find();
   int paidFeaturedCount=0;
   int paidMarkasCount=0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkPlan();
  }
  Future<void> checkPlan()async{
    paidFeaturedCount =  await SPManager.instance.getFeatureCount(PAID_FEATURE) ?? 0;
    paidMarkasCount =  await SPManager.instance.getMarkDeveloperCount(PAID_MARKDEVELOPER) ?? 0;
    print(' post count paidFeaturedCount ===> ');
    print(paidFeaturedCount);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: SingleChildScrollView(
            child: Form(
              key: controller.moreDetailsFormKey,
              child:  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.selectedIndex.value == 0
                              ? "More Details"
                              : "Overview",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        ),

                        boxH05(),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Checkbox(
                                  value: controller.isFeatured.value,
                                  activeColor: AppColor.primaryThemeColor,
                                  onChanged: (value) {

                                    if(controller.selectedIndex.value == 0){
                                      if( paidFeaturedCount != 0){
                                        controller.isFeatured.value = value!;
                                      }

                                      else{
                                        SubscriptionDialog.show(
                                          context: context,
                                          onPurchase: () {
                                            // Handle purchase flow
                                            Navigator.push(context, MaterialPageRoute(
                                                builder: (_) => const PlansAndSubscription(isfrom: 'feature',)
                                            )).then((value) async {
                                              paidFeaturedCount =  await SPManager.instance.getFeatureCount(PAID_FEATURE) ?? 0;
                                              paidMarkasCount =  await SPManager.instance.getMarkDeveloperCount(PAID_MARKDEVELOPER) ?? 0;
                                              print(' post count paidFeaturedCount ===> ');
                                              print(paidFeaturedCount);
                                              await checkPlan();
                                            });
                                          },
                                          type: 'feature',
                                        );
                                      }
                                    }else{
                                      if( paidMarkasCount != 0){
                                        controller.isFeatured.value = value!;
                                      }

                                      else{
                                        SubscriptionDialog.show(
                                          context: context,
                                          onPurchase: () {
                                            // Handle purchase flow
                                            Navigator.push(context, MaterialPageRoute(
                                                builder: (_) => const PlansAndSubscription(isfrom: 'developer',)
                                            )).then((value) async {
                                              await checkPlan();
                                            });
                                          },
                                          type: 'developer',
                                        );
                                      }
                                    }

                                  },
                                ),
                                Expanded(
                                    child: controller.selectedIndex.value == 0
                                        ? const Text("Showcase Your Features Property ") : const Text("Showcase Your Project in the Top Projects")
                                ),
                              ],
                            ),
                            boxH08(),

                            if (controller.selectedPropertyType.value ==
                                "Office Space")
                              ...getOfficeSpaceWidgets(controller, context),
                            if (controller.selectedPropertyType.value == "Shop")
                              ...getShopWidgets(controller, context),
                            if (controller.selectedPropertyType.value == "Land")
                              ...getLandWidgets(controller, context),
                            if (controller.selectedPropertyType.value ==
                                "Office Space IT/SEZ")
                              ...getOfficeSpaceWidgets(controller,
                                  context), // same fields like office space
                            if (controller.selectedPropertyType.value ==
                                "Showroom")
                              ...getShowroomWidgets(controller, context),
                            if (controller.selectedPropertyType.value ==
                                "Industrial Plot")
                              ...getIndustrialPlotWidgets(controller, context),
                            if (controller.selectedPropertyType.value ==
                                "Co-Working Space")
                              ...getCoworkingSpaceWidgets(controller, context),
                            if (controller.selectedPropertyType.value ==
                                "Warehouse")
                              ...getWarehouseWidgets(controller, context),

                            /// Residential
                            if (controller.selectedPropertyType.value ==
                                "Apartment")
                              ...getApartmentWidgets(controller, context),
                            if (controller.selectedPropertyType.value == "Plot")
                              ...getPlotWidgets(controller, context),
                            if (controller.selectedPropertyType.value ==
                                "Independent House")
                              ...getIndependentHouseWidgets(
                                  controller, context),
                            if (controller.selectedPropertyType.value ==
                                "Villa")
                              ...getVillaWidgets(controller, context),
                            if (controller.selectedPropertyType.value ==
                                "Builder Floor")
                              ...getBuilderFloorWidgets(controller, context),
                            if (controller.selectedPropertyType.value ==
                                "Penthouse")
                              ...getPenthouseWidgets(controller, context),
                            if (controller.selectedPropertyType.value == "PG")
                              ...getPGWidgets(controller, context),
                          ],
                        ),
                      ],
                    ),
            ),
          ),
        ));
  }
}

class aboutProperty extends StatefulWidget {
  const aboutProperty({super.key});

  @override
  State<aboutProperty> createState() => _aboutPropertyState();
}

class _aboutPropertyState extends State<aboutProperty> {
  final PostPropertyController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: SingleChildScrollView(
        child: Form(
          key: controller.aboutFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                controller.selectedIndex.value == 0
                    ? "About Property"
                    : "About Project",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              boxH30(),

              CustomTextFormField(
                controller: controller.aboutController,
                keyboardType: TextInputType.text,
                size: 300,
                maxLines: 15,
                hintText: 'Type here',
                alignLabelWithHint: false,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please about property';
                  }
                  return null;
                },
              ),
              boxH15(),
            ],
          ),
        ),
      ),
    );
  }
}

class addAmenitiesView extends StatefulWidget {
  const addAmenitiesView({super.key});

  @override
  State<addAmenitiesView> createState() => _addAmenitiesViewState();
}

class _addAmenitiesViewState extends State<addAmenitiesView> {
  final PostPropertyController controller = Get.find();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.getAmenities();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Amenities",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
            boxH15(),
            Obx(
              () => ListView.builder(
                itemCount: controller.getAmenitiesList.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (ctx, index) {
                  String amenityId =
                      controller.getAmenitiesList[index]['_id'].toString();
                  bool isSelected = controller.isAdded(amenityId);

                  return InkWell(
                    onTap: () {
                      controller.toggleSelection(amenityId);
                      setState(() {});
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: isSelected ? Colors.black : Colors.grey,
                          width: isSelected ? 1 : 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Checkbox(
                            value: isSelected,
                            checkColor: Colors.white,
                            activeColor: Colors.black,
                            onChanged: (bool? newValue) {
                              controller.toggleSelection(amenityId);
                              setState(() {});
                            },
                          ),
                          Expanded(
                            child: Text(
                              controller.getAmenitiesList[index]
                                  ['amenity_name'],
                              style: const TextStyle(
                                  color: Colors.black87, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
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
}

class PriceDetail {
  String bhkType;
  String builtUpArea;
  String areaIn;
  String areaType;
  String price;
  List<File> images;

  PriceDetail({
    required this.bhkType,
    required this.builtUpArea,
    required this.areaIn,
    required this.areaType,
    required this.price,
    required this.images,
  });
}

class projectPriceDetails extends StatefulWidget {
  const projectPriceDetails({super.key});

  @override
  State<projectPriceDetails> createState() => _ProjectPriceDetailsState();
}

class _ProjectPriceDetailsState extends State<projectPriceDetails> {
  final PostPropertyController controller = Get.find();
  int? editingIndex;

  Future<void> pickImage() async {
    final pickedFiles = await controller.picker.pickMultiImage();
    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      setState(() {
        for (var pickedFile in pickedFiles) {
          controller.projectPropertyImage.add(File(pickedFile.path));
        }
      });
    }
  }

  bool validateFields() {
    bool isValid = controller.projectPriceAreaKey.currentState!.validate();

    if (controller.selectedPropertyType.value != "Plot" &&
        controller.bhkType.value.isEmpty) {
      controller.showbhkError.value = true;
      isValid = false;
    } else {
      controller.showbhkError.value = false;
    }

    if (controller.projectPropertyImage.isEmpty) {
      controller.showimageError.value = true;
      isValid = false;
    } else {
      controller.showimageError.value = false;
    }

    return isValid;
  }

  void clearForm() {
    controller.selectedBhk.value = -1;
    controller.bhkType.value = "";
    controller.buildUpAreaController.clear();
    controller.selectedsqfit.value = '';
    controller.selectedarea.value = '';
    controller.propertyPriceController.clear();
    controller.projectPropertyImage.clear();
    controller.images1.clear();
    controller.showimageError.value = false;
    controller.editMode.value = false;
  }

  void fillForm(PriceDetail detail) {
    if (controller.bhkTypes.contains(detail.bhkType)) {
      controller.selectedBhk.value =
          controller.bhkTypes.indexOf(detail.bhkType);
      controller.bhkType.value = detail.bhkType;
    } else {
      controller.selectedBhk.value = -1;
      controller.bhkType.value = '';
    }

    controller.buildUpAreaController.text = detail.builtUpArea;
    controller.selectedsqfit.value = detail.areaIn;
    controller.selectedarea.value = detail.areaType;
    controller.propertyPriceController.text = detail.price;
    controller.projectPropertyImage.assignAll(detail.images);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Form(
        key: controller.projectPriceAreaKey,
        child: SingleChildScrollView(
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Project price & area",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              const SizedBox(height: 15),

              /// BHK Dropdown

              Obx(() => Visibility(
                visible: controller.selectedPropertyType.value != "Plot",
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: Get.width,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade300, width: 2.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          //  const Text('BHK', style: TextStyle(color: Colors.black)),
                            const RequiredTextWidget(label: 'BHK'),
                            DropdownButtonFormField<String>(
                              value: controller.bhkTypes.contains(controller.bhkType.value)
                                  ? controller.bhkType.value
                                  : null,
                              hint: const Text("Select BHK"),
                              onChanged: (String? newValue) {
                                setState(() {
                                  controller.bhkType.value = newValue!;
                                  controller.showbhkError.value = false;
                                });
                              },
                              items: controller.bhkTypes.toSet().toList().map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                              validator: (value) {
                                if (controller.selectedPropertyType.value != "Plot" && (value == null || value.isEmpty)) {
                                  controller.showbhkError.value = true;
                                  return "Please select BHK Type";
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              )),

              /// Built-up Area
              const RequiredTextWidget(label: 'Built-up Area (sq. ft.)'),
              TextFormField(
                controller: controller.buildUpAreaController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
                onChanged: (value) {
                  // Update propertyPrice if needed, but avoid redundancy
                  // controller.propertyPrice.value = value; // Removed to avoid confusion with propertyPriceController
                },
                decoration: InputDecoration(
                  labelText: 'Built-up Area (sq. ft.)',
                  border: const OutlineInputBorder(),
                  filled: true,

                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black, width: 0.8),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey, width: 0.8),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter built-up area';
                  }
                  final trimmedValue = value.trim();
                  if (trimmedValue.length < 3) {
                    return 'Minimum 3 digits required';
                  }
                  if (!RegExp(r'^\d+$').hasMatch(trimmedValue)) {
                    return 'Only numeric characters allowed';
                  }
                  final intValue = int.tryParse(trimmedValue);
                  if (intValue == null || intValue < 100) {
                    return 'Built-up area must be at least 100 sq. ft.';
                  }
                  if (intValue > 999999) {
                    return 'Built-up area cannot exceed 999999 sq. ft.';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 10),

              /// Area In Dropdown
              Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: Get.width,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300, width: 2.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const RequiredTextWidget(label: 'Area In'),
                          //const Text('Area In', style: TextStyle(color: Colors.black)),
                          DropdownButtonFormField<String>(
                            isExpanded: true,
                            value: controller.sqFitType.contains(controller.selectedsqfit.value)
                                ? controller.selectedsqfit.value
                                : null,
                            hint: const Text("Select Area In"),
                            onChanged: (String? newValue) {
                              controller.selectedsqfit.value = newValue!;
                            },
                            items: controller.sqFitType.toSet().map((value) => DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            )).toList(),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please select Area In";
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              )),

              const SizedBox(height: 10),

              /// Area Type Dropdown
              Obx(() => Visibility(
                visible: controller.selectedPropertyType.value != "Plot",
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: Get.width,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade300, width: 2.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            const RequiredTextWidget(label: 'Area Type'),
                            DropdownButtonFormField<String>(
                              isExpanded: true,
                              value: controller.areaType.contains(controller.selectedarea.value)
                                  ? controller.selectedarea.value
                                  : null,
                              hint: const Text("Select Area Type"),
                              onChanged: (String? newValue) {
                                controller.selectedarea.value = newValue!;
                              },
                              items: controller.areaType.toSet().map((value) => DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              )).toList(),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please select Area Type";
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              )),

              const SizedBox(height: 10),


              const RequiredTextWidget(label: 'Enter Amount'),
              /// Price
              TextFormField(
                controller: controller.propertyPriceController,
                keyboardType: TextInputType.number,
                maxLength: 10, // Allow up to 10 digits for price (e.g., 10 Cr)
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                onChanged: (value) {
                  controller.propertyPrice.value = value;
                },
                decoration: InputDecoration(
                  labelText: 'Enter Amount',
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black, width: 0.8),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey, width: 0.8),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter Amount';
                  }
                  final trimmedValue = value.trim();
                  if (!RegExp(r'^\d+$').hasMatch(trimmedValue)) {
                    return 'Please enter a valid number';
                  }
                  final intValue = int.tryParse(trimmedValue);
                  if (intValue == null || intValue < 10000) {
                    return 'Price must be at least ₹10,000';
                  }
                  if (intValue > 1000000000) {
                    return 'Price cannot exceed ₹100 Cr';
                  }
                  return null;
                },
              ),


              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Obx(() {
                  int priceAsInt =
                      int.tryParse(controller.propertyPrice.value) ?? 0;
                  String priceInWords = controller.convertNumberToWords(priceAsInt);

                  return Text(
                    priceInWords.isNotEmpty
                        ? priceInWords + "."
                        : "Enter your amount",
                    style: TextStyle(
                        color: controller.propertyPrice.value != null
                            ? Colors.green
                            : Colors.grey,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold),
                    maxLines: 3,
                  );
                }),
              ),
              const SizedBox(height: 10),

              /// Upload Plan Image
              Obx(() {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    controller.projectPropertyImage.isNotEmpty
                        ? Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(8.0),
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            image: DecorationImage(
                              image: FileImage(controller.projectPropertyImage[0]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 8.0,
                          right: 8.0,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                controller.projectPropertyImage.clear();
                                controller.showimageError.value = false;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(4.0),
                              decoration: BoxDecoration(
                                color: Colors.black45,
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              child: const Icon(Icons.delete, color: Colors.white, size: 18.0),
                            ),
                          ),
                        ),
                      ],
                    )
                        : SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: commonButton(
                        buttonColor: Colors.black,
                        text: "+ Upload Plan Photo",
                        onPressed: () => pickImage(),
                      ),
                    ),
                    if (controller.showimageError.value)
                      const Padding(
                        padding: EdgeInsets.only(top: 5.0, left: 8.0),
                        child: Text(
                          'Please upload a plan image',
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                  ],
                );
              }),

              const SizedBox(height: 15),

              /// Add or Update Entry
              SizedBox(
                width: Get.width,
                child: OutlinedButton(
                  onPressed: () {
                    if (!validateFields()) return;

                    final detail = PriceDetail(
                      bhkType: controller.bhkType.value,
                      builtUpArea: controller.buildUpAreaController.text,
                      areaIn: controller.selectedsqfit.value,
                      areaType: controller.selectedarea.value,
                      price: controller.propertyPriceController.text,
                      images: List.from(controller.projectPropertyImage),
                    );

                    setState(() {
                      if (editingIndex != null) {
                        controller.priceDetailsList[editingIndex!] = detail;
                        editingIndex = null;
                      } else {
                        controller.priceDetailsList.add(detail);
                      }
                      clearForm();
                      calculateAveragePrice();
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Colors.purple, width: 0.8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                  ),
                  child: Text(
                    editingIndex != null ? 'Update Entry' : 'Add Project',
                    style: TextStyle(
                      color: Colors.purple.withOpacity(0.8),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// Display Added Projects
             controller.priceDetailsList.isNotEmpty
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Added Projects:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.priceDetailsList.length,
                    itemBuilder: (context, index) {
                      final item = controller.priceDetailsList[index];
                      final imageFile = item.images.isNotEmpty ? item.images[0] : null;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white.withOpacity(0.7),
                            border: Border.all(color: Colors.grey, width: 1),
                          ),
                          child: Row(
                            children: [
                              if (imageFile != null)
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                      image: FileImage(imageFile),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              else
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.image_not_supported),
                                ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      controller.selectedPropertyType.value != "Plot"?
                                      '${item.bhkType.isNotEmpty ? item.bhkType : "N/A"}  ${controller.formatIndianPrice(item.price)}':
                      ' ${controller.formatIndianPrice(item.price)}',
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      controller.selectedPropertyType.value != "Plot"?
                                      '${item.builtUpArea} ${item.areaIn}, ${item.areaType}': '${item.builtUpArea} ${item.areaIn}',
                                      style: TextStyle(color: Colors.grey[700]),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Column(
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          editingIndex = index;
                                          controller.editMode.value = true;
                                          fillForm(item);
                                        });
                                      },
                                      style: TextButton.styleFrom(
                                        side: const BorderSide(color: Colors.blue),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        padding: const EdgeInsets.symmetric(horizontal: 8),
                                      ),
                                      child: const Text(
                                        'Edit',
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          controller.priceDetailsList.removeAt(index);
                                          clearForm();
                                          editingIndex = null;
                                          calculateAveragePrice();
                                        });
                                      },
                                      style: TextButton.styleFrom(
                                        side: const BorderSide(color: Colors.red),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        padding: const EdgeInsets.symmetric(horizontal: 8),
                                      ),
                                      child: const Text(
                                        'Delete',
                                        style: TextStyle(color: Colors.red),
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
                ],
              )
                  : const SizedBox.shrink(),

              const SizedBox(height: 100),
            ],
          )
        ),
      ),
    );
  }
  void calculateAveragePrice() {
    if (controller.priceDetailsList.isEmpty) {
      controller.avgProjectPriceController.text = '0';
      return;
    }
    double total = 0.0;
    for (var item in controller.priceDetailsList) {
      final price = double.tryParse(item.price.replaceAll(',', '')) ?? 0.0;
      total += price;
    }
    final avg = total / controller.priceDetailsList.length;
    controller.avgProjectPriceController.text = avg.toStringAsFixed(0);
    print("controller.avgProjectPriceController.text=>${controller.avgProjectPriceController.text}");
  }

  Widget buildDropdown(
      String title,
      List<String> items,
      String? selectedValue,
      Function(String?) onChanged, {
        String? Function(String?)? validator,
        bool isRequired = false,
      }) {
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300, width: 2.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(title,
                    style: const TextStyle(color: Colors.grey, fontSize: 15)),
                if (isRequired) ...[
                  const SizedBox(width: 4),
                  const Text('*',
                      style: TextStyle(color: Colors.red, fontSize: 15)),
                ],
              ],
            ),
            SizedBox(
              height: 30,
              child: DropdownButtonFormField<String>(
                value: items.contains(selectedValue) && selectedValue != ''
                    ? selectedValue
                    : null,
                hint: Text("Select $title"),
                onChanged: onChanged,
                items: items.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
                validator: validator,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class floorPlanView extends StatefulWidget {
  const floorPlanView({super.key});

  @override
  State<floorPlanView> createState() => _floorPlanViewState();
}

class _floorPlanViewState extends State<floorPlanView> {
  final PostPropertyController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
        child: SingleChildScrollView(
            child: Form(
          key: controller.floorPlanFormKey,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Floor",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              boxH20(),
              buildRestrictedField(controller.LivingController, 'Living/Dining'),
              boxH08(),
              buildRestrictedField(controller.KitchenController, 'Kitchen / Toilets'),
              boxH08(),
              buildRestrictedField(controller.BedroomController, 'Bedroom'),
              boxH08(),
              buildRestrictedField(controller.BalconyController, 'Balcony'),
              boxH20(),
              const Text(
                "Walls",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              boxH20(),
              buildRestrictedField(controller.DiningController, 'Living/Dining (Wall)'),
              boxH08(),
              buildRestrictedField(controller.ToiletsConroller, 'Kitchen / Toilets (Wall)'),
              boxH08(),
              buildRestrictedField(controller.ServantConroller, 'Servant Room'),
              const SizedBox(height: 100),
            ],
          )

            )),
      ),
    );
  }




}

class celingView extends StatefulWidget {
  const celingView({super.key});

  @override
  State<celingView> createState() => _celingViewState();
}

class _celingViewState extends State<celingView> {
  final PostPropertyController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
            child: Form(
          key: controller.ceilingFormKey,
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Ceilings",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              boxH20(),
              buildRestrictedField(controller.ceilingLivingController, 'Living/Dining'),
              boxH08(),
              buildRestrictedField(controller.ceilingServantController, 'Servant Room'),
              boxH20(),
              const Text(
                "Counters",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              boxH20(),
              buildRestrictedField(controller.counterKitchenController, 'Kitchen / Toilets'),
              boxH20(),
              const Text(
                "Fittings / Fixtures",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              boxH20(),
              buildRestrictedField(controller.fittingKitchenController, 'Kitchen / Toilets'),
              boxH08(),
              buildRestrictedField(controller.fittingToiletController, 'Servant Room Toilet'),
              const SizedBox(height: 100),
            ],
          ),

            )),
      ),
    );
  }
}

class doorView extends StatefulWidget {
  const doorView({super.key});

  @override
  State<doorView> createState() => _doorViewState();
}

class _doorViewState extends State<doorView> {
  final PostPropertyController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
            child: Form(
              key: controller.doorWindowFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Door and Window",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                  boxH20(),

                  // 🚪 Internal Door
                  buildRestrictedField(controller.internalDoorController, 'Internal Door'),
                  boxH08(),

                  // 🪟 External Glazing
                  buildRestrictedField(controller.externalGlazingController, 'External Glazing'),
                  boxH20(),

                  const Text(
                    "Electrical",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                  boxH20(),

                  // ⚡ Electrical
                  buildRestrictedField(controller.electricalController, 'Electrical'),
                  boxH08(),

                  // 🔌 Backup
                  buildRestrictedField(controller.backupController, 'Backup'),
                  boxH20(),

                  const Text(
                    "Security System",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                  boxH20(),

                  // 🛡️ Security System
                  buildRestrictedField(controller.securitySystemController, 'Security System'),

                  const SizedBox(height: 100),
                ],
              ),
            )

        ),
      ),
    );
  }
}
Widget buildRestrictedField(TextEditingController controller, String label) {
  return TextFormField(
    controller: controller,
    keyboardType: TextInputType.text,
    maxLength: 20,
    maxLines: 3,
    inputFormatters: [
      // Allow only alphabets (a-z, A-Z) and spaces
      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
      LengthLimitingTextInputFormatter(20),
    ],
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: Colors.grey[500],
        fontSize: 14.0,
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.black, width: 0.8),
        borderRadius: BorderRadius.circular(10.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.grey, width: 0.8),
        borderRadius: BorderRadius.circular(10.0),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      counterText: '',
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
    ),
    buildCounter: (
        BuildContext context, {
          required int currentLength,
          required int? maxLength,
          required bool isFocused,
        }) {
      return Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: Text(
          '$currentLength/$maxLength',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      );
    },
    validator: (value) {
      if (value == null || value.trim().isEmpty) {
        return 'Please enter $label details';
      }
      return null;
    },
  );
}


class ProjectPriceDetail {
  String bhkType;
  String buildUpArea;
  String areaIn;
  String areaType;
  String amount;
  List<File> images;

  ProjectPriceDetail({
    required this.bhkType,
    required this.buildUpArea,
    required this.areaIn,
    required this.areaType,
    required this.amount,
    required this.images,
  });
}