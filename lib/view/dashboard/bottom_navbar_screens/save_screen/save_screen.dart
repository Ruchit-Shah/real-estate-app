import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:real_estate_app/Routes/app_pages.dart';
import 'package:real_estate_app/common_widgets/custom_container.dart';
import 'package:real_estate_app/common_widgets/dialog_util.dart';
import 'package:real_estate_app/common_widgets/height.dart';
import 'package:real_estate_app/global/app_color.dart';
import 'package:real_estate_app/utils/common_snackbar.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/CustomBottomNavBar.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/profile_screen/profile_screen.dart';
import 'package:real_estate_app/view/dashboard/deshboard_controllers/bottom_bar_controller.dart';
import 'package:real_estate_app/view/filter_search/view/FilterSearchController.dart';

import 'package:url_launcher/url_launcher.dart';

import '../../../../common_widgets/loading_dart.dart';
import '../../../../utils/CommonEnquirySheet.dart';
import '../../../../utils/String_constant.dart';
import '../../../../utils/shared_preferences/shared_preferances.dart';
import '../../../../utils/text_style.dart';
import '../../../auth/login_screen/login_screen.dart';
import '../../../filter_search/view/filterListScreen.dart';
import '../../../property_screens/properties_controllers/post_property_controller.dart';
import '../../../property_screens/recommended_properties_screen/properties_details_screen.dart';
import '../../../property_screens/recommended_properties_screen/propertyCard.dart';
import '../../../splash_screen/splash_screen.dart';
import '../../view/BottomNavbar.dart';
import '../profile_screen/profile_controller.dart';
import '../search_screen/searchController.dart';

class SaveScreen extends StatefulWidget {
  final String isFrom;
  final String isfrom;

  const SaveScreen({super.key, required this.isFrom, required this.isfrom});

  @override
  _SaveScreenState createState() => _SaveScreenState();
}

class _SaveScreenState extends State<SaveScreen>  {
  String selectedOption = 'Property Search';
  String searchBy = 'Normal';
  bool isopen= true;
  final FilterSearchController filterController =
  Get.find();
  ProfileController profileController = Get.put(ProfileController());
  final BottomBarController bottomBarController = Get.find();
  final PostPropertyController controller = Get.put(PostPropertyController());
  String isContact = "";
  int count=0;

  @override
  void initState() {
    super.initState();
    getData();
    controller.scrollController.addListener(() {
      if (controller.scrollController.position.pixels >=
          controller.scrollController.position.maxScrollExtent - 100 &&
          !controller.isPaginationLoading.value &&
          controller.hasMore.value) {
        loadMoreData();
      }
    });
  }

  void getData(){
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      await  filterController.getSaveSearch(page: '1', search_by: searchBy);
    });
  }

  void loadMoreData() {
    if (controller.hasMore.value && !controller.isPaginationLoading.value) {
      controller.isPaginationLoading.value = true;

      final nextPage = (controller.currentPage.value + 1).toString();

      filterController.getSaveSearch(page: nextPage);
    }
  }
  getPlanData() async {
    isContact= (await SPManager.instance.getContactDetails(ContactDetails))??"no";
    count=  (await SPManager.instance.getFreeViewCount(FREE_VIEW))??0;

    print('isContact==>');
    print(isContact);
    print(count);

    setState(() {});
  }

  void _showLoadingDialog() {
    showHomLoading(Get.context!, 'Processing...');
    Future.delayed(const Duration(seconds: 1), () {
      if (Get.context != null && Navigator.canPop(Get.context!)) {
        Navigator.of(Get.context!).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Save Searches", style: TextStyle(
          fontSize: 17, fontWeight: FontWeight.bold
        ),),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 46,
        leading:
        Padding(
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
                if (widget.isFrom == 'profile') {
                  Get.back();
                } else {
                  setState(() {
                    // controller.isBuyerSelected.value = true;
                    bottomBarController.selectedBottomIndex.value = 0; // <- Set to SearchScreen
                  });
                  // Get.offAll(() => const BottomNavbar());
                  if(widget.isfrom=="bottom"){
                    Navigator.pop(context);
                  }
                }
              },

              borderRadius: BorderRadius.circular(
                  50),
              child: const Padding(
                padding: EdgeInsets.all(6),
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
          if (widget.isFrom == 'searchScreen')

            GestureDetector(
              onTap: () {
                Get.to(ProfileScreen());
              },
              child: CircleAvatar(
                radius: 18,
                backgroundColor:
                AppColor.white.withOpacity(0.8),
                child: profileController.profileImage.isNotEmpty
                    ? CircleAvatar(
                  radius: 18,
                  backgroundImage: CachedNetworkImageProvider(
                    profileController.profileImage.value,
                  ),
                ):
                ClipOval(
                  child: Image.asset(

                    'assets/image_rent/profile.png',
                    width: 18,
                    height: 18,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            )
          else
            const SizedBox(),
        ],

      ),
      backgroundColor: AppColor.white,
      body:
      isLogin == true ? Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: Get.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    buttonUI(context, 'Property Search'),
                    boxW20(),
                    buttonUI(context, 'AI Search'),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: getContent(selectedOption),
            ),
          ),

        ],
      ):  Padding(
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
              const Text("Login to view your activity"),
              SizedBox(height: 10),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Get.off(LoginScreen());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primaryThemeColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    textStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    elevation: 10, // Shadow elevation
                  ),
                  child: Text('Login'),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }

  Widget getContent(String option) {
    switch (option) {
      case 'Property Search':
        return propertySearch();
      case 'AI Search':
        return aiSearch();
      default:
        return const Center(child: Text('Select an option', style: TextStyle(color: Color(0xFF333333))));
    }
  }

  Widget buttonUI(BuildContext context, String text) {
    return ElevatedButton(
      onPressed: () async {
        _showLoadingDialog();
        setState(() {
          selectedOption = text;
          print("selectedOptionobject");
          print(selectedOption);
          selectedOption == 'Property Search' ?
            searchBy = 'Normal':  searchBy = 'AI';
          getData();
        });

      },
      style: ElevatedButton.styleFrom(
        backgroundColor: selectedOption == text
            ? Color(0xFFF5CC3D)
            : Colors.white,
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: selectedOption == text ? Colors.black : Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }


  Widget propertySearch() {
    return
      Obx(() {
        if (filterController.getSaveList.isEmpty
            && controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (filterController.getSaveList.isEmpty) {
          return Column(
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
          );
        }
        return RefreshIndicator(
            onRefresh: () async {
              filterController.getSaveSearch(page: '1');
            },
            child:LazyLoadScrollView(
              onEndOfPage: () {
                if (controller.hasMore.value && !controller.isPaginationLoading.value) {
                  loadMoreData(); // Your existing method
                }else{
                  print("LazyLoadScrollView==>");
                  print(controller.hasMore.value);
                  print(controller.isPaginationLoading.value);
                }
              },
              isLoading: controller.isPaginationLoading.value,
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                controller: controller.scrollController,
                itemCount: filterController.getSaveList.length + (controller.isPaginationLoading.value ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == filterController.getSaveList.length) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  return GestureDetector(
                    onTap: () {
                      Get.to(() =>  FilterListScreen(
                        isFrom: 'searchScreen',
                        property_category_type: '',
                        category_price_type: '',
                        bhk_type: '',
                        min_price: '',
                        max_area: '',
                        min_area: '',
                        property_listed_by: '',
                        max_price: '',
                        furnish_status: '',
                        property_type: '',
                        amenties: '',
                        city_name: filterController.getSaveList[index]['property_name'],
                        // city_name:  'Pune',
                      ));
                    },
                    child: Card(
                      elevation: 0.8,
                      color: Colors.white,
                      margin: const EdgeInsets.all(8), // Consistent margin
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // Rounded corners
                        side: BorderSide(color: Colors.grey.shade50, width: 0.1), // Subtle border
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16), // Inner padding
                        child: Row(
                          children: [
                            // Left Column: Text Content
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Location Text
                                  Text(
                                    filterController.getSaveList[index]['property_category_type']==""?
                                    "Buy in ${filterController.getSaveList[index]['property_name']}":
                                    " ${filterController.getSaveList[index]['property_category_type']}, ${filterController.getSaveList[index]['property_name']}",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey.shade800, // Darker text for better readability
                                    ),
                                  ),
                                  const SizedBox(height: 4), // Spacing between texts
                                  // Date Text
                                  filterController.getSaveList[index]['building_type']!=""?
                                  Text(
                                    "${filterController.getSaveList[index]['building_type']}",
                                    maxLines: 2,
                                    style: TextStyle(
                                      fontSize: 14,
                                      overflow: TextOverflow.ellipsis,

                                      color: Colors.grey.shade600, // Subtle color for secondary text
                                    ),
                                  ):SizedBox(),
                                  Text(
                                    "Saved On ${DateFormat('dd MMM, yyyy').format(DateTime.parse(filterController.getSaveList[index]['saved_on']))}",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),

                                ],
                              ),
                            ),

                            // Spacer to push icons to the right
                            const SizedBox(width: 16),

                            // Share Icon
                            IconButton(
                              onPressed: () async {

                                shareProperty(filterController.getSaveList[index]['property_id']);
                              },
                              icon: Image.asset(
                                "assets/image_rent/share.png",
                                width: 20,
                                height: 20,
                                color: Colors.grey.shade700, // Consistent icon color
                              ),
                            ),

                            // Delete Icon
                            IconButton(
                              onPressed: () {
                                showCommonBottomSheet(
                                  context: context,
                                  title: "Delete Save Search",
                                  message: "Are you sure you want to delete this save search?",
                                  onYesPressed: () {
                                    filterController.deleteSaveSearch(id: filterController.getSaveList[index]['_id']).then((value) => getData());
                                  },
                                  onNoPressed: () {

                                  },
                                );
                              },
                              icon: Image.asset(
                                "assets/image_rent/delete.png",
                                width: 22,
                                height: 22,
                                color: Colors.red.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            )

        );
      });
  }

  Widget aiSearch() {
    return
      Obx(() {
        if (filterController.getSaveList.isEmpty&& controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (filterController.getSaveList.isEmpty) {
          return Column(
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
          );
        }
        return RefreshIndicator(
            onRefresh: () async {
              filterController.getSaveSearch(page: '1');
            },
            child:LazyLoadScrollView(
              onEndOfPage: () {
                if (controller.hasMore.value && !controller.isPaginationLoading.value) {
                  loadMoreData(); // Your existing method
                }else{
                  print("LazyLoadScrollView==>");
                  print(controller.hasMore.value);
                  print(controller.isPaginationLoading.value);
                }
              },
              isLoading: controller.isPaginationLoading.value,
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                controller: controller.scrollController,
                itemCount: filterController.getSaveList.length + (controller.isPaginationLoading.value ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == filterController.getSaveList.length) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  return GestureDetector(
                    onTap: () {
                      Get.to(() =>  FilterListScreen(
                        isFrom: 'searchScreen',
                        property_category_type: '',
                        category_price_type: '',
                        bhk_type: '',
                        min_price: '',
                        max_area: '',
                        min_area: '',
                        property_listed_by: '',
                        max_price: '',
                        furnish_status: '',
                        property_type: '',
                        amenties: '',
                        city_name: filterController.getSaveList[index]['property_name'],
                        // city_name:  'Pune',
                      ));
                    },
                    child: Card(
                      elevation: 0.8,
                      color: Colors.white,
                      margin: const EdgeInsets.all(8), // Consistent margin
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // Rounded corners
                        side: BorderSide(color: Colors.grey.shade50, width: 0.1), // Subtle border
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16), // Inner padding
                        child: Row(
                          children: [
                            // Left Column: Text Content
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Location Text
                                  Text(
                                    filterController.getSaveList[index]['property_category_type']==""?
                                    "Buy in ${filterController.getSaveList[index]['property_name']}":
                                    " ${filterController.getSaveList[index]['property_category_type']}, ${filterController.getSaveList[index]['property_name']}",                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey.shade800, // Darker text for better readability
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  filterController.getSaveList[index]['building_type']!=""?
                                  Text(
                                    "${filterController.getSaveList[index]['building_type']}",
                                    maxLines: 2,
                                    style: TextStyle(
                                      fontSize: 14,
                                      overflow: TextOverflow.ellipsis,

                                      color: Colors.grey.shade600, // Subtle color for secondary text
                                    ),
                                  ):SizedBox(),// Spacing between texts
                                  // Date Text
                                  Text(
                                    "Saved On ${DateFormat('dd MMM, yyyy').format(DateTime.parse(filterController.getSaveList[index]['saved_on']))}",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600, // Subtle color for secondary text
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Spacer to push icons to the right
                            const SizedBox(width: 16),

                            // Share Icon
                            IconButton(
                              onPressed: () async {

                                shareProperty(filterController.getSaveList[index]['property_id']);

                              },
                              icon: Image.asset(
                                "assets/image_rent/share.png",
                                width: 20,
                                height: 20,
                                color: Colors.grey.shade700, // Consistent icon color
                              ),
                            ),

                            // Delete Icon
                            IconButton(
                              onPressed: () {
                                showCommonBottomSheet(
                                  context: context,
                                  title: "Delete Save Search",
                                  message: "Are you sure you want to delete this save search?",
                                  onYesPressed: () {
                                    filterController.deleteSaveSearch(id: filterController.getSaveList[index]['_id']).then((value) => getData());
                                  },
                                  onNoPressed: () {

                                  },
                                );
                              },
                              icon: Image.asset(
                                "assets/image_rent/delete.png",
                                width: 22,
                                height: 22,
                                color: Colors.red.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            )

        );
      });
  }




  void viewPhone(context,String name, String contact_number, String email_id,String owner_type) async {
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
                                  backgroundColor: Colors.green.withOpacity(0.1),
                                  child: Icon(Icons.phone, color: Colors.blue.shade900, size: 18),
                                ),
                                const SizedBox(width: 12),
                                Expanded( // Add Expanded here
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
                                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade900,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Center(
                                        child: const Text(
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
                                  backgroundColor: Colors.green.withOpacity(0.1),
                                  child: Icon(Icons.email, color: Colors.blue.shade900, size: 18),
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
                                          'body': '${'Hello '+name},',

                                        }),
                                      );
                                      if (await canLaunch(emailLaunchUri.toString())) {
                                        await launch(emailLaunchUri.toString());
                                      } else {
                                        print('Could not launch $emailLaunchUri');
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 14),
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

  _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }



}
