import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:real_estate_app/common_widgets/height.dart';
import 'package:real_estate_app/common_widgets/loading_dart.dart';
import 'package:real_estate_app/global/app_color.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/CustomBottomNavBar.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/profile_screen/profile_controller.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/profile_screen/profile_screen.dart';
import 'package:real_estate_app/view/filter_search/view/FilterSearchController.dart';
import 'package:real_estate_app/view/property_screens/filter/project_filter_screen.dart';
import 'package:real_estate_app/view/property_screens/post_property_screen/NewChanges/edit_project_start_page.dart';
import 'package:real_estate_app/view/property_screens/post_property_screen/NewChanges/edit_property_start_page.dart';
import 'package:real_estate_app/view/property_screens/post_property_screen/NewChanges/post_property_start_page.dart';
import 'package:real_estate_app/view/property_screens/properties_controllers/post_property_controller.dart';
import 'package:real_estate_app/view/top_developer/top_developer_details.dart';

import '../../../../../../global/api_string.dart';
import '../../../../../../utils/common_snackbar.dart';
import '../../../../../filter_search/view/filter_search_screen.dart';
import '../../../../../property_screens/post_property_screen/NewChanges/post_project_start_page.dart';


class MyProjects extends StatefulWidget {
  final String? isFrom;
  const MyProjects({super.key,this.isFrom});


  @override
  State<MyProjects> createState() => _MyProjectsState();
}

class _MyProjectsState extends State<MyProjects> {
  final FocusNode _focusNode = FocusNode();
  TextEditingController _Controller = TextEditingController();
  final ProfileController controller = Get.find();
  final PostPropertyController _postPropertyController = Get.find();
  FilterSearchController _controller = Get.find();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.searchController.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getMyListingProjects(page: '1');
      getClear();
    });
    controller.scrollController.addListener(() {
      if (controller.scrollController.position.pixels >=
          controller.scrollController.position.maxScrollExtent - 100 &&
          !controller.isPaginationLoading.value &&
          controller.hasMore.value) {
        loadMoreData();
      }
    });
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   controller.getMyListingProjects();
    // });
  }

  getClear(){
    _controller.ClearData();
    print("object");
    setState(() {
      _controller.selectedFurnishingStatusList.clear();
      // pController.profileController.myListingProject.clear();
      // pController.getCommonProjectsList.clear();


      setState(() {
        _controller.isClear.value=false;
      });
      _controller.budgetMin.value = null;
      _controller.budgetMax.value = null;
      _controller.budgetMin1.value = "";
      _controller.budgetMax1.value = "";
    });
    // await pController.getMySearchProject(
    //   searchKeyword: widget.search_key,
    //   city: '',
    //   locality: '',
    //   max_price:"${controller.budgetMax1.value.toString()}00000" ,
    //   min_price:controller.budgetMin1.value.toString() ,
    //   project_type:controller.selectedPropertyType.join('|') ,isFrom: widget.isFrom,
    //   furnishtype:  controller.selectedFurnishingStatusList.join('|'),
    //   bhktype: controller.selectedBHKTypeList.join('|'),
    //
    // );
  }
  void loadMoreData() {
    if (controller.hasMore.value && !controller.isPaginationLoading.value) {
      controller.isPaginationLoading.value = true;

      final nextPage = (controller.currentPage.value + 1).toString();

      if (controller.searchController.text.trim().isNotEmpty) {
        controller.getMySearchProjects(controller.searchController.text.trim(), nextPage);
      } else {
        controller.getMyListingProjects(page: nextPage);
      }
    }
  }
  void onSearchChanged(String value) {
    controller.currentPage.value = 1;
    controller.hasMore.value = true;
    if (value.trim().isEmpty) {
      controller.getMyListingProjects(page: '1');
    } else {
      controller.getMySearchProjects(value.trim(), '1');
    }
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.isFrom == 'post') {
          Get.to(() => ProfileScreen());
          return false;
        } else {
          Get.back();
          return false;
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "My Projects",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          scrolledUnderElevation: 0,
          backgroundColor: Colors.white,
          elevation: 0.4,
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
                // onTap: () {
                //   if (widget.isFrom == 'post') {
                //     Get.to(() => ProfileScreen());
                //   } else {
                //     Get.back();
                //   }
                // },
                onTap: () {
                  if (widget.isFrom == 'post') {
                    Get.off(() => ProfileScreen());
                  } else {
                    Get.back();
                  }
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
                    width: 0.1,
                  ),
                ),
                child: InkWell(
                  onTap: () {
                    Get.to(() => projectFilterScreen(
                      search_key: controller.searchController.text,
                      isFrom: 'profile',
                    ));
                  },
                  borderRadius: BorderRadius.circular(50),
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Image.asset(
                      "assets/image_rent/filter.png",
                      height: 10,
                      width: 12,
                    ),
                  ),
                ),

              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                height: 50,
                child: TextField(
                  focusNode: _focusNode,
                  controller: controller.searchController,
                  onSubmitted: onSearchChanged,
                  decoration: InputDecoration(
                    hintText: "Search by city, property, or area...",
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.normal,
                    ),
                    prefixIcon: const Icon(Icons.search, size: 25),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.cancel, size: 18),
                      onPressed: () {
                        controller.searchController.clear();
                        onSearchChanged('');
                      },
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey, width: 0.8),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey, width: 0.8),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 12.0,
                      horizontal: 16.0,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Obx(() {
                if (controller.myListingProject.isEmpty && controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                } else if (controller.myListingProject.isEmpty) {
                  return const Center(
                    child: Text(
                      "No Data Available",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    await controller.getMyListingProperties(page: '1');
                  },
                  child: LazyLoadScrollView(
                    onEndOfPage: () {
                      if (controller.hasMore.value && !controller.isPaginationLoading.value) {
                        loadMoreData();
                      } else {
                        print("LazyLoadScrollView: hasMore=${controller.hasMore.value}, isPaginationLoading=${controller.isPaginationLoading.value}");
                      }
                    },
                    isLoading: controller.isPaginationLoading.value,
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: controller.scrollController,
                      itemCount: controller.myListingProject.length +
                          (controller.isPaginationLoading.value ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == controller.myListingProject.length) {
                          return const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                          child: projectCard(controller.myListingProject[index], index),
                        );
                      },
                    ),
                  ),
                );
              }),
            ),
          ],
        ),


        bottomNavigationBar:     Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: SizedBox(
            width: double.infinity,
            child:  ElevatedButton(
              onPressed: () {
                Get.to(() => const project_start_page(isFrom: "myprojects"));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF52C672),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                "Post New Project",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ),
      ),
    );
  }
  String formatDate(String dateString) {
    DateTime date = parseDate(dateString);
    return DateFormat('d MMMM y').format(date);
  }
  Widget projectCard(var property,int index){
    return Container(
      width:Get.width,
      height: Get.height * 0.48,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: AppColor.white,
          border: Border.all(color: Colors.grey.shade300,width: 1.5)
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top section (Published tag and date)
            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    "Published",
                    style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                 Text(
                   formatDate(property['launch_date']??""),
                  //'23  april 2025',
                  style: const TextStyle(
                      color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 5),

            // Image and property details
            GestureDetector(
              onTap: () {
                Get.to(TopDevelopersDetails(
                  projectID: property['_id'].toString(),
                ));
              },
              child: Row(
                children: [
                  // Property Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: property['cover_image'] != null
                        ? CachedNetworkImage(
                      imageUrl: property['cover_image'].startsWith('http://13.127.244.70:4444/') ?? false
                          ? property['cover_image']
                          : 'http://13.127.244.70:4444/${property['cover_image'] ?? ''}',
                      width: 80,
                      height: 70,
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
                    )
                        : Image.asset(
                      'assets/image_rent/langAsiaCity.png',
                      width: 80,
                      height: 70,
                      fit: BoxFit.cover,
                    ),
                  ),
                  boxW15(),

                  // Property details
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        // FOR RENT badge
                        const SizedBox(height: 6),
                        Text(
                          property['project_name'],
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),

                      Text(
                        property['congfigurations'].toString(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      Text(
                        property['address_area'] ?? property['address'],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                        Text(
                          property['project_type'],
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 14,overflow: TextOverflow.ellipsis),
                        ),
                      boxH15(),
                      Text(
                        _postPropertyController.formatPriceRange(property['average_project_price']),
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
            ),
            boxH15(),
            // Views and Leads
            Container(
              padding:
              const EdgeInsets.symmetric(vertical: 8,horizontal: 10),
              decoration: BoxDecoration(
                  color:  Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: Colors.grey.shade400)),
              child:  Row(
                mainAxisAlignment:
                MainAxisAlignment.start,
                children: [
                  boxW10(),
                  Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      const Text("Views",
                          style:
                          TextStyle(color: Colors.grey)),
                      const SizedBox(height: 5),
                      // Text(property['view_count'].toString() ?? '0.0',
                      //     style: const TextStyle(
                      //         fontWeight: FontWeight.bold)),
                      Text(
                        int.tryParse(property['view_count']?.toString() ?? '')?.toString() ?? '0',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  boxW50(),
                   Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      const Text("Leads",
                          style:
                          TextStyle(color: Colors.grey)),
                      boxH05(),
                      // Text(property['leads_count'].toString() ?? '0.0',
                      //     style: const TextStyle(
                      //         fontWeight: FontWeight.bold)),
                      Text(
                        int.tryParse(property['leads_count']?.toString() ?? '')?.toString() ?? '0',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],

                  ),
                  const Spacer()
                ],
              ),
            ),
            boxH25(),
            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: OutlinedButton(
                      onPressed: () {
                        Get.to(  edit_project_start_page(isfrom: 'project',data: property, index: index,));
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: AppColor.primaryThemeColor, width: 0.8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Edit Project",
                        style: TextStyle(
                          color: AppColor.primaryThemeColor,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      showCommonBottomSheet(
                        context: context,
                        title: "Delete Project",
                        message: "Are you sure you want to delete this project?",
                        onYesPressed: () {
                          controller.deleteMyProject(id: property['_id']);
                        },
                        onNoPressed: () {

                        },
                      );
                    },
                    icon: Image.asset(
                      "assets/image_rent/delete.png",
                      height: 30,
                      width: 30,
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
  DateTime parseDate(String? dateString) {
    if (dateString == null || dateString.trim().isEmpty) {
      return DateTime.now(); // Return current date if null or empty
    }

    try {
      return DateFormat('dd/MM/yyyy').parse(dateString);
    } catch (e) {
      try {
        return DateTime.parse(dateString); // Try ISO format
      } catch (e) {
        return DateTime.now(); // Return current date if all parsing fails
      }
    }
  }


}




