import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:real_estate_app/common_widgets/height.dart';
import 'package:real_estate_app/global/api_string.dart';
import 'package:real_estate_app/global/app_color.dart';
import 'package:real_estate_app/global/app_string.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/CustomBottomNavBar.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/profile_screen/profile_controller.dart';
import 'package:real_estate_app/view/filter_search/view/filter_search_screen.dart';
import 'package:real_estate_app/view/property_screens/filter/leads_filter.dart';
import 'package:real_estate_app/view/property_screens/properties_controllers/post_property_controller.dart';
import 'package:real_estate_app/view/top_developer/top_developer_details.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../filter_search/view/FilterSearchController.dart';
import '../../../../../property_screens/filter/filtter_screen.dart';
import '../../../../../property_screens/filter/project_filter_screen.dart';
import '../../../../../property_screens/recommended_properties_screen/properties_details_screen.dart';

class MyLeads extends StatefulWidget {
  const MyLeads({super.key});

  @override
  State<MyLeads> createState() => _MyLeadsState();
}

class _MyLeadsState extends State<MyLeads> with SingleTickerProviderStateMixin {
  final FocusNode _focusNode = FocusNode();
  TextEditingController _Controller = TextEditingController();
  TextEditingController _searchController = TextEditingController();
  final controller = Get.find<PostPropertyController>();
  late TabController _tabController;
  Timer? _searchDebounce;
  ProfileController profileController = Get.find();
  bool showProjectLeadsTab = false;
  final PostPropertyController _postPropertyController = Get.find();
  FilterSearchController _controller = Get.find();

  @override
  void initState() {
    super.initState();
    showProjectLeadsTab = profileController.userType.value.toLowerCase() != 'owner';

    // Initialize TabController with dynamic length
    _tabController = TabController(
      length: showProjectLeadsTab ? 2 : 1,
      vsync: this,
    );
    _searchController = TextEditingController();
    _searchController.addListener(() {
      setState(() {}); // <--- This is the key to show/hide clear icon
    });
    _loadInitialData();
    getClear();
    _tabController.addListener(_handleTabChange);

    controller.scrollController.addListener(() {
      if (controller.scrollController.position.pixels >=
          controller.scrollController.position.maxScrollExtent - 100 &&
          !controller.isPaginationLoading.value &&
          controller.hasMore.value) {
        _loadMoreData();
      }
    });

    // Add listener for search text changes
   // _searchController.addListener(_onSearchChanged);
  }
  getClear(){

    _controller.ClearData();
    _controller.selectedFurnishingStatusList.clear();
    _controller.isClear.value =true;

    // pController.profileController.myListingPrperties.clear();
    // pController.getCommonPropertyList.clear();
    _controller.budgetMin.value = null;
    _controller.budgetMax.value = null;

    _controller.budgetMin1.value = "";
    _controller.budgetMax1.value = "";


    // await pController.getPropertyEnquiry(
    //   searchKeyword: widget.search_key,
    //   city: '',
    //   locality: '',
    //   max_price:controller.budgetMax1.value!=""?"${controller.budgetMax.value.toString()}00000":
    //   controller.budgetMax1.value.toString(),
    //   min_price:controller.budgetMin1.value.toString() ,
    //   showFatured: widget.isFrom =='profile' || widget.isFrom=='my_leads' ? 'false': 'true',
    //   property_type:controller.selectedPropertyType.join('|') ,
    //
    //   furnishtype: controller.selectedFurnishingStatusList.join('|'),
    //   bhktype: controller.selectedBHKTypeList.join('|'),
    //
    // );
  }
  void _onSearchChanged() {
    if (_searchDebounce?.isActive ?? false) _searchDebounce?.cancel();

    _searchDebounce = Timer(const Duration(seconds: 3), () {
      if (_searchController.text.trim().isEmpty) {
        // If search is empty, reload initial data
        _loadInitialData();
      } else {
        // Perform search with current text
        _loadInitialData(search: _searchController.text.trim());
      }
    });
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      _loadInitialData();
    }
  }

  void _loadInitialData({String? search}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {


      if (_tabController.index == 0) {
        getClear();
        controller.getPropertyEnquiry(
          page: '1',
          searchKeyword: search ?? _searchController.text.trim(),
        );
      } else {
        getClear();
        controller.getProjectEnquiry(
          page: '1',
          searchKeyword: search ?? _searchController.text.trim(),
        );
      }
    });
  }

  String formatDate(String dateStr) {
    if (dateStr.isEmpty) {
      return '';
    }
    final dateTime = DateTime.parse(dateStr);
    final formatter = DateFormat('d MMMM yyyy');
    return formatter.format(dateTime);
  }

  void _loadMoreData() {
    if (controller.hasMore.value && !controller.isPaginationLoading.value) {
      controller.isPaginationLoading.value = true;
      final nextPage = (controller.currentPage.value + 1).toString();

      if (_searchController.text.trim().isNotEmpty) {
        if (_tabController.index == 0) {
          controller.getPropertyEnquiry(
            searchKeyword: _searchController.text.trim(),
            page: nextPage,
          );
        } else {
          controller.getProjectEnquiry(
            searchKeyword: _searchController.text.trim(),
            page: nextPage,
          );
        }
      } else {
        if (_tabController.index == 0) {
          controller.getPropertyEnquiry(page: nextPage);
        } else {
          controller.getProjectEnquiry(page: nextPage);
        }
      }
    }
  }

  Future<void> callPhoneNumber(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "My Leads",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        elevation: 0,
        leadingWidth: 40,
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.black,
                  width: 0.01,
                ),
              ),
              child: InkWell(
                onTap: () {
                  //
                  // Get.to(FilterSearchScreen(
                  //   isfrompage: '',
                  //   isfrom: '',
                  // ));

                  Get.to( LeadsFilterScreen(
                    search_key:_searchController.text.trim(),
                    isFrom:_tabController.index == 0? 'my_leads_property':'my_leads_project',
                  ));
                },
                borderRadius: BorderRadius.circular(50),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Image.asset(
                    "assets/image_rent/filter.png",
                    height: 10,
                    width: 12,
                    color: Colors.black.withOpacity(0.6),
                  ),
                ),
              ),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppColor.primaryThemeColor,
          indicatorSize: TabBarIndicatorSize.tab,

          tabs:  [
            const Tab(text: 'Property Leads'),
            if (showProjectLeadsTab) const Tab(text: 'Project Leads'),
          ],
        ),
      ),
      body: TabBarView(physics: const NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: [
          _buildTabContent(1),
          if (showProjectLeadsTab) _buildTabContent(2),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }

  Widget _buildTabContent(int tapIndex) {
    return     Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            height: 50,
            child: TextField(
              focusNode: _focusNode,
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search by name, property, etc.",
                hintStyle: const TextStyle(
                    color: Colors.grey, fontWeight: FontWeight.normal),
                prefixIcon: const Icon(Icons.search, size: 25),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear, size: 18),
                  onPressed: () {
                    _searchController.clear();
                    _loadInitialData();
                  },
                )
                    : null,
                focusedBorder: OutlineInputBorder(
                  borderSide:
                  const BorderSide(color: Colors.grey, width: 0.8),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                  const BorderSide(color: Colors.grey, width: 0.8),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 16.0),
              ),
              onSubmitted: (value) {
                _loadInitialData(search: value.trim());
              },
            ),
          ),
        ),
        Expanded(
          child: Obx(() {
            final leads = _tabController.index == 0
                ? controller.getProperyEnquiryList
                : controller.getProjectEnquiryList;

            if (leads.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_off,
                      size: 50,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _searchController.text.isEmpty
                          ? 'No leads found'
                          : 'No listing found',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    if (_searchController.text.isNotEmpty)
                      TextButton(
                        onPressed: () {
                          _searchController.clear();
                          _loadInitialData();
                        },
                        child: const Text('Clear search'),
                      ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                _loadInitialData();
              },
              child: LazyLoadScrollView(
                onEndOfPage: _loadMoreData,
                isLoading: controller.isPaginationLoading.value,
                child: ListView.builder(
                  itemCount:
                  leads.length + (controller.hasMore.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= leads.length) {
                      return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(),
                          ));
                    }
                    var lead = leads[index];
                    return _buildLeadItem(lead,tapIndex);
                  },
                ),
              ),
            );
          }),
        ),

      ],
    );
  }
  Widget _buildLeadItem(dynamic lead,int tapIndex) {
    return Container(
      width: Get.width,
      height: Get.height * 0.48,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black.withOpacity(0.3), width: 0.4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: SizedBox(
        width: Get.width,
        height: Get.height * 0.4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [


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


                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      lead['name'] ?? '',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      lead['user_type'] ?? '',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),

              ],
            ),
            const SizedBox(height: 10),
             Row(
              children: [
                Column(
                  children: [
                    Text(
                      formatDate(lead['time_date'] ?? ''),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    boxH05(),
                    const Text(
                      "Received On",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
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
            const Divider(),
            GestureDetector(
              onTap: () {
                final hasPropertyId = lead.containsKey('property_id') && lead['property_id'] != null;
                final hasProjectId = lead.containsKey('project_id') && lead['project_id'] != null;

                if (tapIndex == 1 && hasPropertyId) {
                  Get.to(() => PropertyDetailsScreen(
                    id: lead['property_id'].toString(),
                  ));
                } else if (tapIndex != 1 && hasProjectId) {
                  Get.to(() => TopDevelopersDetails(
                    projectID: lead['project_id'].toString(),
                  ));
                } else {

                  print("Missing required ID for navigation");
                }
              },

              child: Row(
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child:lead['enquiry_cover_image'] != null || lead['enquiry_cover_image'] != '' ?
                        CachedNetworkImage(
                          imageUrl: APIString.imageMediaBaseUrl+lead['enquiry_cover_image'],
                          width: 90,
                          height: 80,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            width: 80,
                            height: 70,
                            color: Colors.grey.shade300,
                            child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                          ),
                          errorWidget: (context, url, error) => Image.asset(
                            'assets/image_rent/langAsiaCity.png',
                            width: 80,
                            height: 70,
                            fit: BoxFit.cover,
                          ),
                        ):
                        Image.asset(
                          "assets/image_rent/langAsiaCity.png",
                          width: 90,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      lead['enquiry_property_category_type'] != null ?
                      // Positioned(
                      //   left: 0,
                      //   top: 0,
                      //   child: Container(
                      //     padding: const EdgeInsets.symmetric(
                      //         horizontal: 6, vertical: 4),
                      //     decoration: BoxDecoration(
                      //       color: const Color(0xFF6969EB),
                      //       borderRadius: BorderRadius.circular(6),
                      //     ),
                      //     child: Text(
                      //       "FOR ${lead['enquiry_property_category_type'].toString().toUpperCase()}",
                      //       style: const TextStyle(
                      //           color: Colors.white,
                      //           fontSize: 12,
                      //           fontWeight: FontWeight.bold),
                      //     ),
                      //   ),
                      // )
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

                          :

                      const SizedBox.shrink() ,
                    ],
                  ),
                  boxW20(),
                  // Property details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // FOR RENT badge
                        const SizedBox(height: 6),
                        Text(
                          tapIndex == 1
                              ? lead['enquiry_property_name'] ?? ''
                              : lead['project_name'] ?? '',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),

                        Text(
                          tapIndex == 1
                              ? (lead['property_details']?['address_area']?.toString().isNotEmpty == true
                              ? lead['property_details']!['address_area'].toString()
                              : lead['property_details']?['address']?.toString() ?? 'No Address')
                              : (lead['project_details']?['address_area']?.toString().isNotEmpty == true
                              ? lead['project_details']!['address_area'].toString()
                              : lead['project_details']?['address']?.toString() ?? 'No Address'),
                          style: const TextStyle(color: Colors.grey, fontSize: 14),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),


                        // Text(
                        //   lead['enquiry_address'],
                        //   style: const TextStyle(color: Colors.grey, fontSize: 14),
                        //   maxLines: 2,
                        //   overflow: TextOverflow.ellipsis,
                        // ),



                        boxH08(),
                        // Text(
                        //   tapIndex == 1 ? _postPropertyController.formatIndianPrice(lead['enquiry_property_price'] ?? '') :
                        //   _postPropertyController.formatIndianPrice(lead['enquiry_average_project_price'] ?? ''),
                        //   style: const TextStyle(
                        //       fontSize: 17, fontWeight: FontWeight.bold),
                        // ),

                        Text(
                          _getFormattedPrice(lead, tapIndex),
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Message",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              lead['message'],
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
  String getAddressArea(Map<String, dynamic>? details) {
    final area = details?['address_area']?.toString();
    final address = details?['address']?.toString();
    return (area?.isNotEmpty == true) ? area! : (address ?? 'No Address');
  }
  String _getFormattedPrice(Map<String, dynamic> lead, int tapIndex) {
    if (tapIndex == 1) {
      final propertyDetails = lead['property_details'];
      final category = propertyDetails?['property_category_type']?.toString();
      if (category == "Rent") {
        final rent = propertyDetails?['rent']?.toString();
        return '${_postPropertyController.formatIndianPrice(rent ?? '0')}/Month';
      } else {
        final price = propertyDetails?['property_price']?.toString();
        return _postPropertyController.formatIndianPrice(price ?? '0');
      }
    } else {
      final avgPrice = lead['project_details']?['average_project_price'];
      return _postPropertyController.formatPriceRange(avgPrice) ?? '';
    }
  }

}
