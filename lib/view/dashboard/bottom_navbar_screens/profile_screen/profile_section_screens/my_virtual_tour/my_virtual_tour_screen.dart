import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:real_estate_app/common_widgets/height.dart';
import 'package:real_estate_app/global/api_string.dart';
import 'package:real_estate_app/global/app_color.dart';
import 'package:real_estate_app/view/dashboard/VideoCall/video_call_screen.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/CustomBottomNavBar.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/profile_screen/profile_controller.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/profile_screen/profile_section_screens/my_virtual_tour/GetScheduleBottomSheet.dart';
import 'package:real_estate_app/view/property_screens/properties_controllers/post_property_controller.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../../common_widgets/loading_dart.dart';
import '../../../../../../utils/String_constant.dart';
import '../../../../../../utils/common_snackbar.dart';
import '../../../../../../utils/shared_preferences/shared_preferances.dart';
import '../../../../../property_screens/recommended_properties_screen/properties_details_screen.dart';
import '../../../../../subscription model/controller/SubscriptionController.dart';
import '../../../../../top_developer/top_developer_details.dart';
import '../../../../view/BottomNavbar.dart';
import '../PlansAndSubscriptions/PlansAndSubscription.dart';

class MyVirtualTourScreen extends StatefulWidget {
  const MyVirtualTourScreen({super.key});

  @override
  State<MyVirtualTourScreen> createState() => _MyVirtualTourScreenState();
}

class _MyVirtualTourScreenState extends State<MyVirtualTourScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String selectedFilter = "All";
final ProfileController controller = Get.find();
  final PostPropertyController propertyController = Get.find();
  final List<String> filters = ["All", "Pending", "Accepted", "Rejected","Expired"];

  int _currentTabIndex = 0; // Explicitly track current tab index
  ScrollController _sentScrollController = ScrollController(); // For Sent Invitations
  ScrollController _receivedScrollController = ScrollController(); //
  Future<void> callPhoneNumber(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }


  Color getColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return AppColor.pandingColor;
      case 'accepted':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'expired':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }


  String isContact = "";
  int count = 0;
   int freeViewCount=0;
  final planController = Get.find<SubscriptionController>();
   int paidViewCount=0;
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
  void _updateFilter(String filter) {
    setState(() {
      selectedFilter = filter;
    });
    controller.currentPage.value = 1; // Reset pagination
    controller.hasMore.value = true; // Reset hasMore
    controller.virtual_tours_List.clear(); // Clear current data
    controller.my_virtual_tours_List.clear(); // Clear current data
    _loadInitialData(); // Reload data with new filter
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _loadInitialData1();

    _tabController.addListener(_handleTabChange);

    // Add listener for Sent Invitations tab
    _sentScrollController.addListener(() {
      if (_sentScrollController.position.pixels >=
          _sentScrollController.position.maxScrollExtent - 100 &&
          !controller.isPaginationLoading.value &&
          controller.hasMore.value &&
          _currentTabIndex == 0) {
        print('Scroll triggered pagination for Sent Invitations (tab 0)');
        Future.delayed(const Duration(milliseconds: 200), () {
          _loadMoreData();
        });
      }
    });

    // Add listener for Received Invitations tab
    _receivedScrollController.addListener(() {
      if (_receivedScrollController.position.pixels >=
          _receivedScrollController.position.maxScrollExtent - 100 &&
          !controller.isPaginationLoading.value &&
          controller.hasMore.value &&
          _currentTabIndex == 1) {
        print('Scroll triggered pagination for Received Invitations (tab 1)');
        Future.delayed(const Duration(milliseconds: 200), () {
          _loadMoreData();
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _sentScrollController.dispose();
    _receivedScrollController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      print('Tab changing to index: ${_tabController.index}');
      _currentTabIndex = _tabController.index; // Update explicit index
      controller.currentPage.value = 1; // Reset page on tab change
      controller.hasMore.value = true; // Reset hasMore
      controller.virtual_tours_List.clear(); // Clear current data
      controller.my_virtual_tours_List.clear(); // Clear current data
      _loadInitialData();
    }
  }

  void _loadInitialData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('Loading initial data for tab: $_currentTabIndex, Controller index: ${_tabController.index}');
      if (_currentTabIndex == 0) {
        controller.get_tour_List(
          page: '1',
          status: selectedFilter,
        );
      } else {
        controller.get_mySchedules_List(
          page: '1',
          status: selectedFilter,
        );
      }
    });
  }
  void _loadInitialData1() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('Loading initial data for tab: $_currentTabIndex, Controller index: ${_tabController.index}');
      getData();
        controller.get_tour_List(
          page: '1',
          status: selectedFilter,
        );

        controller.get_mySchedules_List(
          page: '1',
          status: selectedFilter,
        );

    });
  }

  void _loadMoreData() {
    if (controller.hasMore.value && !controller.isPaginationLoading.value) {
      controller.isPaginationLoading.value = true;
      final nextPage = (controller.currentPage.value + 1).toString();

      print('Pagination triggered - Current tab index: $_currentTabIndex, Controller index: ${_tabController.index}');
      print('Next page: $nextPage, Status: $selectedFilter');

      if (_currentTabIndex == 0) {
        print('Calling get_tour_List for tab 0');
        controller.get_tour_List(
          page: nextPage,
          status: selectedFilter,
        );
      } else {
        print('Calling get_mySchedules_List for tab 1');
        controller.get_mySchedules_List(
          page: nextPage,
          status: selectedFilter,
        );
      }
    } else {
      print('Pagination not triggered - hasMore: ${controller.hasMore.value}, isPaginationLoading: ${controller.isPaginationLoading.value}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Virtual Appointment",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        scrolledUnderElevation: 0,
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
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColor.lightBlue,
          labelColor: AppColor.lightPurple,
          unselectedLabelColor: Colors.black,
          indicatorSize: TabBarIndicatorSize.tab,
          // onTap: (index) {
          //   print('Tab index tapped: $index');
          //   _currentTabIndex = index; // Update explicit index
          //   if (_tabController.index != index) {
          //     _tabController.index = index; // Trigger tab change
          //   } else {
          //     controller.currentPage.value = 1;
          //     controller.hasMore.value = true;
          //     if (index == 0) {
          //       controller.virtual_tours_List.clear();
          //     } else {
          //       controller.my_virtual_tours_List.clear();
          //     }
          //     _loadInitialData();
          //   }
          // },
          // onTap: (index) {
          //   print('Tab index tapped: $index');
          //   _currentTabIndex = index;
          //
          //   controller.currentPage.value = 1;
          //   controller.hasMore.value = true;
          //
          //   if (index == 0) {
          //     controller.virtual_tours_List.clear();
          //   } else {
          //     controller.my_virtual_tours_List.clear();
          //   }
          //
          //   _loadInitialData();
          // },

          tabs: [
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Sent Invitations", style: TextStyle(fontSize: 12)),
                  const SizedBox(width: 6),
                  Obx(() => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColor.boldColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      controller.sent_total_count.toString(),
                      style: const TextStyle(color: Colors.black, fontSize: 12),
                    ),
                  )),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Received Invitations", style: TextStyle(fontSize: 12)),
                  const SizedBox(width: 6),
                  Obx(() => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColor.boldColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      controller.recived_total_count.toString(),
                      style: const TextStyle(color: Colors.black, fontSize: 12),
                    ),
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: filters.map((filter) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: GestureDetector(
                      onTap: () => _updateFilter(filter),
                      child: Chip(
                        label: Text(
                          filter,
                          style: const TextStyle(fontSize: 13),
                        ),
                        backgroundColor: selectedFilter == filter
                            ? AppColor.yellowButton
                            : Colors.transparent,
                        labelStyle: TextStyle(
                          color: selectedFilter == filter
                              ? Colors.black
                              : AppColor.textLightBlueGrey,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: const BorderSide(color: Colors.transparent),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

          ),
          const SizedBox(height: 10),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                Builder(
                  builder: (context) {
                    print('Rendering TabBarView for Sent Invitations (index 0)');
                    return Obx(()=>
                        buildInvitationList(controller.virtual_tours_List));
                  },
                ),
                Builder(
                  builder: (context) {
                    print('Rendering TabBarView for Received Invitations (index 1)');
                    return Obx(()=> buildInvitationList2(controller.my_virtual_tours_List));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }

  Widget buildInvitationList(List<dynamic> invitations) {

    bool hasContactPlan =false;
    if(isContact == "yes"){
      print("object1");
      if(paidViewCount >= 0){
        print("object2");

          hasContactPlan = true;

      } else{
        print("object3");

          hasContactPlan = false;

      }
    }else{
      print("object4");
      print("freeViewCount=>${freeViewCount}");
      if(freeViewCount > 0){
        print("object5");

          hasContactPlan = true;

      } else{
        print("object6");

          hasContactPlan = false;

      }
    }


    return invitations.isEmpty
        ? const Center(child: Text('No Virtual Appointments Available'))
        : ListView.builder(
      controller: _sentScrollController, // Use separate controller
        padding: const EdgeInsets.symmetric(horizontal: 10),
      itemCount: invitations.length,
      itemBuilder: (context, index) {
        if (index >= invitations.length) return const SizedBox();

        var item = invitations[index];
        var owner = item['property_owner_details'] ?? {};

        final propertyDetails = item['tour_type'] == 'Project'
            ? (item['project_details'] ?? {})
            : (item['property_details'] ?? {});


        final isProject = item['tour_type'] == 'Project';
        final tourTypeLabel = isProject ? 'PROJECT' : 'PROPERTY';
        final borderColor = isProject ? Colors.blue : Colors.orange;

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: AppColor.white,
              border: Border.all(color: getColor(item['status']) ?? Colors.grey),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // CircleAvatar(
                    //   backgroundColor: Colors.purple.shade50,
                    //   radius: 24,
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(8.0),
                    //     child: Image.asset('assets/image_rent/profileImg.png'),
                    //   ),
                    // ),

                    CircleAvatar(
                      radius: 24,
                      backgroundImage: (owner.containsKey('profile_image') &&
                          owner['profile_image'] != null &&
                          owner['profile_image'].toString().isNotEmpty)
                          ? CachedNetworkImageProvider(
                        // controller.getCommonPropertyList[index]['profile_image'],
                        APIString.imageMediaBaseUrl+owner['profile_image'],
                      )
                          : null,
                      backgroundColor: AppColor.grey.withOpacity(0.1),
                      child: (owner.containsKey('profile_image') &&
                          owner['profile_image'] != null &&
                          owner['profile_image'].toString().isNotEmpty)
                          ? null
                          : ClipOval(
                        child: Image.asset(
                          'assets/image_rent/profile.png',
                          width: 30,
                          height: 30,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(owner["full_name"] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text(owner["user_type"] ?? '', style: TextStyle(color: Colors.grey[600])),
                      ],
                    ),
                    const Spacer(),

                    IconButton(
                      onPressed: () {

                        // if (hasContactPlan==false) ...[
                        // boxH10(),
                        // commonButton(text: 'Purchase Contact Plan', onPressed: () {
                        // Get.to(const PlansAndSubscription())?.then((value) async {
                        // if (value != null) {
                        // await getData();
                        // }
                        // });
                        //
                        // },),
                        // boxH10(),
                        //
                        // ],
                        if (hasContactPlan==false){
                          print("hasContactPlan-->")  ;
                          print(freeViewCount)  ;
                          print(paidViewCount)  ;


                          _showContactDetailsBottomSheet(context);

                        }

                        else{

                          callPhoneNumber(owner["mobile_number"] ?? '').then((value)async {

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

                      },
                      icon: SizedBox(
                        width: 40,
                        height: 40,
                        child: Image.asset('assets/images/png/ic_mobile.png'),
                      ),
                    ),
                  ],
                ),
                boxH10(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Date
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            propertyController.formatDayThreeMonthYear(item["schedule_date"] ?? ''),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                          boxH08(),
                          const Text('Date'),
                        ],
                      ),
                    ),

                    // Time
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${item["timeslot"] ?? ''} ${item["time_unit"] ?? ''}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                          boxH08(),
                          const Text('Time'),
                        ],
                      ),
                    ),

                    // Status
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: getColor(item["status"]).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              item["status"] ?? '',
                              style: TextStyle(
                                color: getColor(item["status"] ?? ''),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          boxH08(),
                          Text(
                            propertyController.formatDayThreeMonthYear(item["updated_at"] ?? ''),
                            style: const TextStyle(color: AppColor.grey),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                boxH10(),
                const Divider(),
                isProject==true?
                GestureDetector(
                  onTap: (){
                    Get.to(TopDevelopersDetails(
                      projectID: propertyDetails['_id'].toString(),
                    ));
                  },
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: propertyDetails.isNotEmpty && propertyDetails['cover_image'] != null
                                ? Image.network(
                              "http://13.127.244.70:4444" + propertyDetails['cover_image'],
                              width: 80,
                              height: 70,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Image.asset(
                                "assets/image_rent/propertyDeveloper.png",
                                width: 80,
                                height: 70,
                                fit: BoxFit.cover,
                              ),
                            )
                                : Image.asset(
                              "assets/image_rent/propertyDeveloper.png",
                              width: 80,
                              height: 70,
                              fit: BoxFit.cover,
                            ),
                          ),

                        ],
                      ),
                      boxW15(),
                      Expanded(
                        child: propertyDetails.isNotEmpty
                            ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 6),
                            Text(
                              propertyDetails['project_name'] ??'',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            // Text(
                            //   propertyDetails['address_area'] ?? '',
                            //   style: const TextStyle(color: Colors.grey, fontSize: 14),
                            // ),
                            Text(
                              propertyDetails['address_area'] ?? propertyDetails['address'],
                              style: const TextStyle(
                                fontSize: 14,

                                color: Colors.grey,
                                overflow: TextOverflow.ellipsis,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              propertyController.formatPriceRange(
                                propertyDetails['average_project_price']?.toString() ??
                                    '',
                              ),
                              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                            : const Text("No property data"),
                      ),
                    ],
                  ),
                ):  GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PropertyDetailsScreen(
                            id: propertyDetails['_id']),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: propertyDetails.isNotEmpty && propertyDetails['cover_image'] != null
                                ? Image.network(
                             "http://13.127.244.70:4444" + propertyDetails['cover_image'],
                              width: 80,
                              height: 70,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Image.asset(
                                "assets/image_rent/propertyDeveloper.png",
                                width: 80,
                                height: 70,
                                fit: BoxFit.cover,
                              ),
                            )
                                : Image.asset(
                              "assets/image_rent/propertyDeveloper.png",
                              width: 80,
                              height: 70,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            left: 0,
                            top: 0,
                            child:(propertyDetails['property_category_type']?.toString() ?? '').isNotEmpty
                                ? Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                              decoration:  BoxDecoration(
                                // color: Color(0xFF52C672),
                                color:propertyDetails['property_category_type'].toString() =="Rent"?
                                AppColor.primaryThemeColor:AppColor.green,
                                borderRadius: const BorderRadius.only(topRight: Radius.circular(10)),
                              ),
                              child: Text(
                                "FOR ${propertyDetails['property_category_type']?.toString().toUpperCase() ?? ''}",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            )
                                : const SizedBox.shrink(),
                          ),
                        ],
                      ),
                      boxW15(),
                      Expanded(
                        child: propertyDetails.isNotEmpty
                            ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 6),
                            Text(
                              propertyDetails['property_name'] ?? '',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              propertyDetails['address_area'] ?? propertyDetails['address'],
                              maxLines: 1,
                              // maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                            propertyDetails['property_category_type']=="Rent"?
                            Text(
                              ' ${propertyController.formatIndianPrice(propertyDetails['rent'].toString())}/ Month',
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                                :
                            Text(
                              propertyController.formatIndianPrice( propertyDetails['property_price'].toString()),
                              style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                            : const Text("No property data"),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                // if (item["status"] == "Accepted" &&
                //     isAppointmentTimeNow(
                //       item["schedule_date"] ?? '',
                //       item["timeslot"] ?? '',
                //       item["time_unit"] ?? '',
                //     ))
                //   Center(
                //     child: SizedBox(
                //       width: Get.width,
                //       height: Get.width * 0.11,
                //       child: ElevatedButton(
                //         onPressed: () {
                //           Navigator.push(
                //             context,
                //             MaterialPageRoute(
                //               builder: (context) => videoCallScreen(
                //                 channel_name: item['channel_name'] ?? '',
                //                 agora_token: item['agora_token'] ?? '',
                //                 tour_id: item['_id'] ?? '',
                //                 type: 'enquiry',
                //               ),
                //             ),
                //           ).then((value) => _loadInitialData());
                //         },
                //         style: ElevatedButton.styleFrom(
                //           backgroundColor: AppColor.lightPurple,
                //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                //         ),
                //         child: const Text("Start Virtual Tour", style: TextStyle(color: AppColor.white)),
                //       ),
                //     ),
                //   ),
                if (item["status"] == "Accepted")
                  Center(
                    child: SizedBox(
                      width: Get.width,
                      height: Get.width * 0.11,
                      child: ElevatedButton(
                        onPressed: () {


                          if(  isAppointmentTimeNow(
                            item["schedule_date"] ?? '',
                            item["timeslot"] ?? '',
                            item["time_unit"] ?? '',
                          )){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => videoCallScreen(
                                  channel_name: item['channel_name'] ?? '',
                                  agora_token: item['agora_token'] ?? '',
                                  tour_id: item['_id'] ?? '',
                                  type: 'enquiry',
                                ),
                              ),
                            ).then((value) => _loadInitialData());
                          }else{
                            showCommonSinleButtonBottomSheet(

                              context: context,
                              title: "",
                              message: "Your scheduled appointment is on ${item["schedule_date"] ?? ''} at ${item["timeslot"] ?? ''} ${item["time_unit"] ?? ''}. Please visit again.",

                              onYesPressed: () {

                              },
                              onNoPressed: () {

                              },
                            );
                          }

                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.lightPurple,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text("Start Virtual Tour", style: TextStyle(color: AppColor.white)),
                      ),
                    ),
                  ),
                // if (item["status"] == "Rejected")
                //   Center(
                //     child: SizedBox(
                //       width: Get.width,
                //       height: Get.width * 0.11,
                //       child: ElevatedButton(
                //         onPressed: () {},
                //         style: ElevatedButton.styleFrom(
                //           backgroundColor: AppColor.white,
                //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                //           side: BorderSide(color: AppColor.lightPurple),
                //         ),
                //         child: const Text("Reschedule Appointment", style: TextStyle(color: AppColor.lightPurple)),
                //       ),
                //     ),
                //   ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildInvitationList2(List<dynamic> invitations) {
    return invitations.isEmpty
        ? const Center(child: Text('No Virtual Appointments Available'))
        : ListView.builder(
      controller: _receivedScrollController,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      itemCount: invitations.length,
      itemBuilder: (context, index) {
        if (index >= invitations.length) return const SizedBox();

        var item = invitations[index];

        var userDetails = item['user_details'] ?? {};

        // Create a map to store property details based on tour_type
        final propertyDetails = item['tour_type'] == 'Project'
            ? (item['project_details'] ?? {})
            : (item['property_details'] ?? {});

        // Determine tour type label and styling
        final isProject = item['tour_type'] == 'Project';
        final tourTypeLabel = isProject ? 'PROJECT' : 'PROPERTY';
        final borderColor = isProject ? Colors.blue : Colors.orange;

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: AppColor.white,
              border: Border.all(color: getColor(item['status'] ?? '') ?? Colors.grey),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundImage: (userDetails.containsKey('profile_image') &&
                          userDetails['profile_image'] != null &&
                          userDetails['profile_image'].toString().isNotEmpty)
                          ? CachedNetworkImageProvider(
                        // controller.getCommonPropertyList[index]['profile_image'],
                        APIString.imageMediaBaseUrl+userDetails['profile_image'],
                      )
                          : null,
                      backgroundColor: AppColor.grey.withOpacity(0.1),
                      child: (userDetails.containsKey('profile_image') &&
                          userDetails['profile_image'] != null &&
                          userDetails['profile_image'].toString().isNotEmpty)
                          ? null
                          : ClipOval(
                        child: Image.asset(
                          'assets/image_rent/profile.png',
                          width: 30,
                          height: 30,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(userDetails["full_name"] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text(userDetails["user_type"] ?? '', style: TextStyle(color: Colors.grey[600])),
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        callPhoneNumber(userDetails["mobile_number"] ?? '');
                      },
                      icon: SizedBox(
                        width: 40,
                        height: 40,
                        child: Image.asset('assets/images/png/ic_mobile.png'),
                      ),
                    ),
                  ],
                ),
                boxH10(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(propertyController.formatDayThreeMonthYear(item["schedule_date"] ?? ''),
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        boxH08(),
                        const Text('Date'),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${item["timeslot"] ?? ''} ${item["time_unit"] ?? ''}",
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        boxH08(),
                        const Text('Time'),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: getColor(item["status"]).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            item["status"] ?? '',
                            style: TextStyle(
                              color: getColor(item["status"] ?? ''),
                            ),
                          ),
                        ),
                        boxH08(),
                        Text(propertyController.formatDayThreeMonthYear(item["updated_at"] ?? ''),
                            style: const TextStyle(color: AppColor.grey)),
                      ],
                    ),
                  ],
                ),
                boxH10(),
                const Divider(),
                isProject==true?
                GestureDetector(
                  onTap: (){
                    Get.to(TopDevelopersDetails(
                      projectID: propertyDetails['_id'].toString(),
                    ));
                  },
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: propertyDetails.isNotEmpty && propertyDetails['cover_image'] != null
                                ? Image.network(
                              "http://13.127.244.70:4444" + propertyDetails['cover_image'],
                              width: 80,
                              height: 70,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Image.asset(
                                "assets/image_rent/propertyDeveloper.png",
                                width: 80,
                                height: 70,
                                fit: BoxFit.cover,
                              ),
                            )
                                : Image.asset(
                              "assets/image_rent/propertyDeveloper.png",
                              width: 80,
                              height: 70,
                              fit: BoxFit.cover,
                            ),
                          ),

                        ],
                      ),
                      boxW15(),
                      Expanded(
                        child: propertyDetails.isNotEmpty
                            ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 6),
                            Text(
                              propertyDetails['project_name'] ??'',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            // Text(
                            //   propertyDetails['address_area'] ?? '',
                            //   style: const TextStyle(color: Colors.grey, fontSize: 14),
                            // ),
                            Text(
                              propertyDetails['address_area'] ?? propertyDetails['address'],
                              style: const TextStyle(
                                fontSize: 14,

                                color: Colors.grey,
                                overflow: TextOverflow.ellipsis,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              propertyController.formatPriceRange(
                                propertyDetails['average_project_price']?.toString() ??
                                    '',
                              ),
                              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                            : const Text("No property data"),
                      ),
                    ],
                  ),
                ):  GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PropertyDetailsScreen(
                            id: propertyDetails['_id']),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: propertyDetails.isNotEmpty && propertyDetails['cover_image'] != null
                                ? Image.network(
                              "http://13.127.244.70:4444" + propertyDetails['cover_image'],
                              width: 80,
                              height: 70,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Image.asset(
                                "assets/image_rent/propertyDeveloper.png",
                                width: 80,
                                height: 70,
                                fit: BoxFit.cover,
                              ),
                            )
                                : Image.asset(
                              "assets/image_rent/propertyDeveloper.png",
                              width: 80,
                              height: 70,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            left: 0,
                            top: 0,
                            child:(propertyDetails['property_category_type']?.toString() ?? '').isNotEmpty
                                ? Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                              decoration:  BoxDecoration(
                                // color: Color(0xFF52C672),
                                color:propertyDetails['property_category_type'].toString() =="Rent"?
                                AppColor.primaryThemeColor:AppColor.green,
                                borderRadius: const BorderRadius.only(topRight: Radius.circular(10)),
                              ),
                              child: Text(
                                "FOR ${propertyDetails['property_category_type']?.toString().toUpperCase() ?? ''}",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            )
                                : const SizedBox.shrink(),
                          ),
                        ],
                      ),
                      boxW15(),
                      Expanded(
                        child: propertyDetails.isNotEmpty
                            ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 6),
                            Text(
                              propertyDetails['property_name'] ?? '',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              propertyDetails['address_area'] ?? propertyDetails['address'],
                              maxLines: 1,
                              // maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                            propertyDetails['property_category_type']=="Rent"?
                            Text(
                              ' ${propertyController.formatIndianPrice(propertyDetails['rent'].toString())}/ Month',
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                                :
                            Text(
                              propertyController.formatIndianPrice( propertyDetails['property_price'].toString()),
                              style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                            : const Text("No property data"),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                if (item["status"] == "Pending")
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: Get.width * 0.11,
                          child: ElevatedButton(
                            onPressed: () {
                              controller.update_tour_Status(
                                tour_id: item['_id'] ?? '',
                                Status: 'Accepted',
                                from: item['tour_type'] ?? '',
                              );
                              _loadInitialData();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.green.withOpacity(0.7),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: const Text("Accept", style: TextStyle(color: AppColor.white)),
                          ),
                        ),
                        // GestureDetector(
                        //   onTap: () {
                        //     controller.update_tour_Status(
                        //       tour_id: item['_id'] ?? '',
                        //       Status: 'Rejected',
                        //       from: item['tour_type'] ?? '',
                        //     );
                        //     _loadInitialData();
                        //   },
                        //   child: Container(
                        //     height: Get.width * 0.11,
                        //     alignment: Alignment.center,
                        //     child: const Text("Reject", style: TextStyle(color: AppColor.red)),
                        //   ),
                        // ),
                        GestureDetector(
                          onTap: () {
                            showCommonBottomSheet(
                              context: context,
                              title: "Reject Virtual Tour",
                              message: "Are you sure you want to reject the request?",
                              onYesPressed: () {
                                controller.update_tour_Status(
                                  tour_id: item['_id'] ?? '',
                                  Status: 'Rejected',
                                  from: item['tour_type'] ?? '',
                                );
                                // Navigator.of(context).pop(); // Close the bottom sheet
                                _loadInitialData();
                              },
                              onNoPressed: () {
                                // Navigator.of(context).pop(); // Just close the bottom sheet
                              },
                            );
                          },
                          child: Container(
                            height: Get.width * 0.11,
                            alignment: Alignment.center,
                            child: const Text("Reject", style: TextStyle(color: AppColor.red)),
                          ),
                        ),

                      ],
                    ),
                  ),
                if (item["status"] == "Accepted")
                  Center(
                    child: SizedBox(
                      width: Get.width,
                      height: Get.width * 0.11,
                      child: ElevatedButton(
                        onPressed: () {


                          if(  isAppointmentTimeNow(
                            item["schedule_date"] ?? '',
                            item["timeslot"] ?? '',
                            item["time_unit"] ?? '',
                          )){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => videoCallScreen(
                                  channel_name: item['channel_name'] ?? '',
                                  agora_token: item['agora_token'] ?? '',
                                  tour_id: item['_id'] ?? '',
                                  type: 'enquiry',
                                ),
                              ),
                            ).then((value) => _loadInitialData());
                          }else{
                            showCommonSinleButtonBottomSheet(

                              context: context,
                              title: "",
                              message: "Your scheduled appointment is on ${item["schedule_date"] ?? ''} at ${item["timeslot"] ?? ''} ${item["time_unit"] ?? ''}. Please visit again.",

                                onYesPressed: () {

                              },
                              onNoPressed: () {

                              },
                            );
                          }

                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.lightPurple,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text("Start Virtual Tour", style: TextStyle(color: AppColor.white)),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
  String formatDayMonthYear(String dateStr) {
    if (dateStr.isEmpty) return '';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd MMM yyyy').format(date); // e.g., 07 Oct 2025
    } catch (e) {
      return '';
    }
  }
  // bool isAppointmentTimeNow(String scheduleDate, String timeslot, String timeUnit) {
  //   try {
  //     // Parse schedule date
  //     final dateFormat = DateFormat('yyyy-MM-dd'); // Adjust format based on your API
  //     final appointmentDate = dateFormat.parse(scheduleDate);
  //     final now = DateTime.now();
  //
  //     // Check if date is today
  //     if (!(appointmentDate.year == now.year &&
  //         appointmentDate.month == now.month &&
  //         appointmentDate.day == now.day)) {
  //       return false;
  //     }
  //
  //     // Parse timeslot and timeUnit (assuming format like "10:00 AM" or similar)
  //     final timeFormat = DateFormat('h:mm a');
  //     final appointmentTimeStr = '$timeslot $timeUnit';
  //     final appointmentTime = timeFormat.parse(appointmentTimeStr);
  //
  //     // Create DateTime objects for comparison
  //     final appointmentDateTime = DateTime(
  //         now.year, now.month, now.day,
  //         appointmentTime.hour, appointmentTime.minute
  //     );
  //
  //     // Calculate 30 minutes after the scheduled time
  //     final thirtyMinutesAfter = appointmentDateTime.add(const Duration(minutes: 30));
  //
  //     // Check if current time is AFTER scheduled time but BEFORE 30 minutes after
  //     return now.isAfter(appointmentDateTime) && now.isBefore(thirtyMinutesAfter);
  //   } catch (e) {
  //     print('Error parsing time: $e');
  //     return false;
  //   }
  // }

  bool isAppointmentTimeNow(String date, String time, String timeUnit) {
    if (date.isEmpty || time.isEmpty || timeUnit.isEmpty) {
      print('Missing input: date=$date, time=$time, timeUnit=$timeUnit');
      return false;
    }

    try {
      // Parse date
      final scheduledDate = DateTime.parse(date); // Format: yyyy-MM-dd

      // Parse time
      final timeParts = time.split(':');
      if (timeParts.length != 2) {
        print('Invalid time format: $time');
        return false;
      }

      int hour = int.parse(timeParts[0]);
      int minute = int.parse(timeParts[1]);

      // Convert to 24-hour format
      if (timeUnit.toUpperCase() == 'PM' && hour != 12) {
        hour += 12;
      } else if (timeUnit.toUpperCase() == 'AM' && hour == 12) {
        hour = 0;
      }

      // Combine into one DateTime object
      final scheduledDateTime = DateTime(
        scheduledDate.year,
        scheduledDate.month,
        scheduledDate.day,
        hour,
        minute,
      );

      final now = DateTime.now();

      // Debug prints
      print('Now: ${now.toLocal()}');
      print('Scheduled: ${scheduledDateTime.toLocal()}');
      print('Scheduled +15min: ${scheduledDateTime.add(const Duration(minutes: 30)).toLocal()}');

      final isValidTime = now.isAfter(scheduledDateTime.subtract(const Duration(seconds: 1))) &&
          now.isBefore(scheduledDateTime.add(const Duration(minutes: 20)));

      print('isAppointmentTimeNow: $isValidTime');

      return isValidTime;
    } catch (e) {
      print('Error parsing date/time: $e');
      return false;
    }
  }
  _showContactDetailsBottomSheet(BuildContext context) {
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
                      "Upgrade Required",
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
                const Text(
                  "You've reached your contact view limit. Subscribe to unlock contact details and access premium features.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
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

}
