import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:real_estate_app/common_widgets/height.dart';
import 'package:real_estate_app/global/app_color.dart';
import 'package:real_estate_app/view/auth/login_screen/login_screen.dart';
import 'package:real_estate_app/view/property_screens/properties_controllers/post_property_controller.dart';
import 'package:real_estate_app/view/top_developer/top_developer_details.dart';
import '../../dashboard/bottom_navbar_screens/profile_screen/profile_section_screens/my_virtual_tour/GetScheduleBottomSheet.dart';
import '../../dashboard/bottom_navbar_screens/search_screen/searchController.dart';
import '../../property_screens/recommended_properties_screen/properties_details_screen.dart';
import '../../splash_screen/splash_screen.dart';

class ProjectResultUi extends StatefulWidget {
  final RxList<dynamic> data;
  final VoidCallback loadMoreData; // Add loadMoreData callback
  final RxBool hasMore; // Add hasMore flag
  final RxBool isPaginationLoading; // Add isPaginationLoading flag

  const ProjectResultUi({
    super.key,
    required this.data,
    required this.loadMoreData,
    required this.hasMore,
    required this.isPaginationLoading,
  });

  @override
  State<ProjectResultUi> createState() => _ProjectResultUiState();
}

class _ProjectResultUiState extends State<ProjectResultUi> {
  final searchController search_controller = Get.put(searchController());
  final ScrollController _controllerOne = ScrollController();
  final PostPropertyController controller = Get.find();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      search_controller.getsessionData();
    });
  }

  @override
  void dispose() {
    _controllerOne.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 90.0),
      child: SizedBox(
        height: Get.height * 0.25,
        width: Get.width,
        child: RawScrollbar(
          thickness: 2,
          thumbColor: AppColor.lightPurple,
          trackColor: Colors.grey,
          trackRadius: const Radius.circular(10),
          controller: _controllerOne,
          thumbVisibility: true,
          child: LazyLoadScrollView(
            onEndOfPage: () {
              print("LazyLoadScrollView==> ProjectResultUi");
              if (widget.hasMore.value && !widget.isPaginationLoading.value) {
                widget.loadMoreData();
              } else {
                print("LazyLoadScrollView==> ProjectResultUi, hasMore=${widget.hasMore.value}, isPaginationLoading=${widget.isPaginationLoading.value}");
              }
            },
            isLoading: widget.isPaginationLoading.value,
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.only(left: 6, right: 6),
              child: Obx(() => GridView.count(
                childAspectRatio: 0.56,
                crossAxisCount: 1,
                crossAxisSpacing: 6,
                mainAxisSpacing: 6,
                physics: const ClampingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                controller: _controllerOne,
                children: List.generate(
                  widget.data.length + (widget.isPaginationLoading.value ? 1 : 0),
                      (index) {
                    if (index == widget.data.length) {
                      return const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    return InkWell(
                      onTap: () {
                        Get.to(TopDevelopersDetails(
                          projectID: widget.data[index]['_id'].toString(),
                        ));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColor.grey.withOpacity(0.1)),
                            color: AppColor.white,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Stack(
                                    children: [
                                      widget.data[index]['cover_image'] != null
                                          ? CachedNetworkImage(
                                        width: 120,
                                        height: 200,
                                        imageUrl: widget.data[index]['cover_image']!.toString().startsWith('http://13.127.244.70:4444/')
                                            ? widget.data[index]['cover_image'].toString()
                                            : 'http://13.127.244.70:4444/${widget.data[index]['cover_image']?.toString() ?? ''}',
                                        fit: BoxFit.cover,
                                        errorWidget: (context, url, error) => const Icon(Icons.error),
                                      )
                                          : Container(
                                        width: 120,
                                        height: 200,
                                        color: Colors.grey[400],
                                        child: const Center(
                                          child: Icon(Icons.image_rounded),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 8),
                                    Text(
                                      widget.data[index]['project_name'],
                                      style: const TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.data[index]['congfigurations'].toString(),
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black54,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          widget.data[index]['project_type'],
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
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
                                                "${widget.data[index]['city_name']}, ${widget.data[index]['state']}",
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
                                        const SizedBox(height: 5),
                                        Text(
                                          controller.formatPriceRange(widget.data[index]['average_project_price']),
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
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
                ),
              )),
            ),
          ),
        ),
      ),
    );
  }
}

