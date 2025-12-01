import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:real_estate_app/common_widgets/height.dart';
import 'package:real_estate_app/common_widgets/loading_dart.dart';
import 'package:real_estate_app/global/api_string.dart';
import 'package:real_estate_app/global/app_color.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/CustomBottomNavBar.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/profile_screen/profile_controller.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/search_screen/searchController.dart';
import 'package:real_estate_app/view/top_developer/top_developer_details.dart';

import '../../common_widgets/custom_textformfield.dart';
import '../../utils/String_constant.dart';
import '../../utils/shared_preferences/shared_preferances.dart';
import '../dashboard/bottom_navbar_screens/profile_screen/profile_section_screens/PlansAndSubscriptions/PlansAndSubscription.dart';
import '../splash_screen/splash_screen.dart';
import '../subscription model/controller/SubscriptionController.dart';
import 'properties_controllers/post_property_controller.dart';
import 'recommended_properties_screen/properties_details_screen.dart';

class ProjectAgentProfile extends StatefulWidget {
  final agent_id;
  const ProjectAgentProfile({super.key, this.agent_id});

  @override
  State<ProjectAgentProfile> createState() => _agent_profileState();
}

class _agent_profileState extends State<ProjectAgentProfile>with TickerProviderStateMixin {
  late TabController _tabController;
  final PostPropertyController controller = Get.put(PostPropertyController());
  final searchApiController = Get.find<searchController>();
  final ProfileController profileController = Get.find();
  final planController = Get.find<SubscriptionController>();
  late int freeViewCount;
  late int paidViewCount;
  void checkPlan()async{
    freeViewCount =  await SPManager.instance.getFreeViewCount(FREE_VIEW) ?? 0;
    paidViewCount =  await SPManager.instance.getPaidViewCount(PAID_VIEW) ?? 0;
    print('view count ===> ');
    print(freeViewCount);
    print(paidViewCount);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      profileController.getProjectAgentProfile(agentId:widget.agent_id);
      checkPlan();
      // profileController.getProjectAgentProfile(widget.agent_id);
    });
    profileController.scrollController.addListener(() {
      if (profileController.scrollController.position.pixels >=
          profileController.scrollController.position.maxScrollExtent - 100 &&
          !profileController.isPaginationLoading.value &&
          profileController.hasMore.value) {
        loadMoreData();
      }
    });
  }
  void loadMoreData() {
    if (profileController.hasMore.value && !profileController.isPaginationLoading.value) {
      profileController.isPaginationLoading.value = true;

      final nextPage = (profileController.currentPage.value + 1).toString();
      profileController.getProjectAgentProfile(agentId: widget.agent_id,page: nextPage);
    }
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColor.bgColor,
      appBar:AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            customIconButton(
              icon: Icons.arrow_back,
              onTap: () {
                Navigator.pop(context);

              },
            ),
            const Text("Agent Property",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),),
            const Text("",),

          ],
        ),
      ),
      body: Stack(
          children: [
            SingleChildScrollView(
              child: Obx(() => Column(
                children: [
                  profileController.projectAgentDetailsList.isNotEmpty
                      ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: profileController.projectAgentDetailsList[0]['profile_image'] != null
                              ? NetworkImage(profileController.projectAgentDetailsList[0]['profile_image']!)
                              : AssetImage("assets/man.png") as ImageProvider,
                          child: profileController.projectAgentDetailsList[0]['profile_image'] == null
                              ? Image.asset("assets/man.png", height: 75, width: 75)
                              : null,
                        ),
                        boxW05(),
                        Column(
                          children: [
                            Text(
                              profileController.projectAgentDetailsList[0]['full_name'] ?? '',
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              profileController.projectAgentDetailsList[0]['user_type'] ?? '',
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                      : const Center(child: CircularProgressIndicator()),
                  boxH20(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              "assets/image_rent/house.png",
                              height: 30,
                              width: 30,
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  profileController.projectAgentDetailsList?.isNotEmpty ?? false
                                      ? profileController.projectAgentDetailsList![0]['experience']?.toString() ?? 'N/A'
                                      : 'N/A',
                                  style: const TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.black87,
                                  ),
                                ),
                                const Text(
                                  'Experience',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Image.asset(
                              "assets/image_rent/house.png",
                              height: 30,
                              width: 30,
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  profileController.totalPropertyCount.value ?? '0',
                                  style: const TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.black87,
                                  ),
                                ),
                                const Text(
                                  'Properties',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(width: 15),
                      ],
                    ),
                  ),
                  boxH25(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/NewThemChangesAssets/user.png",
                          height: 30,
                          width: 30,
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profileController.projectAgentDetailsList?.isNotEmpty ?? false
                                  ? profileController.projectAgentDetailsList![0]['proprietorship']?.toString() ?? 'N/A'
                                  : 'N/A',
                              style: const TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                                color: AppColor.black87,
                              ),
                            ),
                            const Text(
                              'Firm Ownership',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  boxH20(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: SizedBox(
                        width: 370,
                        height: 50,
                        child:commonButton(
                          text: "Contact Agent",
                          onPressed: () {
                            _showContactDetailsBottomSheet(context, profileController.projectAgentDetailsList[0]['full_name'] ?? '', profileController.projectAgentDetailsList[0]['mobile_number'] ?? '');
                          },
                        )

                    ),
                  ),
                  boxH10(),
                  profileController.projectAgentList.isNotEmpty && profileController.projectAgentList != 0
                      ?   SizedBox(
                    height: Get.height,
                        child: Expanded(
                                            child: Obx(() {
                        if (profileController.projectAgentList.isEmpty && profileController.isLoading.value) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        return RefreshIndicator(
                            onRefresh: () async {
                              profileController.getProjectAgentProfile(agentId: widget.agent_id);
                            },
                            child:LazyLoadScrollView(
                              onEndOfPage: () {
                                if (profileController.hasMore.value && !profileController.isPaginationLoading.value) {
                                  loadMoreData(); // Your existing method
                                }else{
                                  print("LazyLoadScrollView==>");
                                  print(profileController.hasMore.value);
                                  print(profileController.isPaginationLoading.value);
                                }
                              },
                              isLoading: profileController.isPaginationLoading.value,
                              child: Obx(()=>
                                  ListView.builder(
                                    physics: const AlwaysScrollableScrollPhysics(),
                                    controller: profileController.scrollController,
                                    itemCount: profileController.projectAgentList.length + (profileController.isPaginationLoading.value ? 1 : 0),
                                    itemBuilder: (context, index) {
                                      if (index == profileController.projectAgentList.length) {
                                        return const Padding(
                                          padding: EdgeInsets.all(16.0),
                                          child: Center(child: CircularProgressIndicator()),
                                        );
                                      }
                                      return _buildProjectCard(context, profileController.projectAgentList[index]);
                                    },
                                  ),
                              ),
                            )

                        );
                                            }),
                                          ),
                      ): Center(
                    child: Column(
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
                    ),
                  ),
                  boxH50(),
                ],
              )),
            ),
            const Positioned(
              bottom: 0,
              left: 5,
              right: 5,
              child: CustomBottomNavBar(),
            ),
          ]),

    );
  }
  _showContactDetailsBottomSheet(BuildContext context, String? name, String? phoneNo) {
    bool hasContactPlan = freeViewCount >0;
    if(paidViewCount > 0){
      setState(() {
        hasContactPlan = true; // if user has paid count
      });
    }
  print('has plan : ${hasContactPlan}');
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
                      padding: EdgeInsets.only(left: 5.0),
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
                    Spacer(),
                    const Text(
                      "Contact Details",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Spacer(),
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
                    Get.to(const PlansAndSubscription(isfrom: 'contact',));
                  },)
                ],
              ],
            ),
          ),
        );
      },
    ).then((value)async {
      if(freeViewCount > 0) {
        await planController.add_count(isfrom: 'free_contact', count: -1);
        await SPManager.instance.setFreeViewCount(FREE_VIEW, freeViewCount - 1);
      }
      else if(paidViewCount > 0 ){
        await planController.add_count(isfrom: 'paid_contact', count: -1);
        await SPManager.instance.setFreeViewCount(PAID_VIEW, freeViewCount - 1);
      }
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

  Widget _buildProjectCard(BuildContext context, Map<String, dynamic> project) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: () {
        Get.to(TopDevelopersDetails(
          projectID: project['_id'].toString(),
        ));
      },
      child: Container(
        height: height * 0.68,
        width: width,
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: AppColor.grey.shade50,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: AppColor.grey.shade50),
        ),
        child: Stack(
          children: [
            // Main Image
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.asset(
                'assets/image_rent/langAsiaCity.png',
                height: height * 0.4,
                width: width * 0.9,
                fit: BoxFit.cover,
              ),
            ),

            // Overlay Content
            Positioned(
              bottom: 0,

              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top dark section with developer name
                      Container(
                        height: height * 0.2,
                        width: width * 0.9,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                          ),
                        ),
                        child: Stack(
                          children: [
                            // Blurred background image
                            if (project['cover_image'] != null && project['cover_image'].isNotEmpty)
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15),
                                ),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Image.network(
                                      project['cover_image'],
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          color: Colors.black.withOpacity(0.7),
                                        );
                                      },
                                    ),
                                    BackdropFilter(
                                      filter: ImageFilter.blur(sigmaX: 50.0, sigmaY: 50.0),
                                      child: Container(
                                        color: Colors.black.withOpacity(0.5),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            else
                              Container(
                                color: Colors.black.withOpacity(0.7),
                              ),

                            // Text content
                            Center(
                              child: Text(
                                project['project_name'],
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Bottom white section with details
                      Container(
                        height: height * 0.18,
                        width: width * 0.9,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                          border: Border.all(
                            width: 0.2,
                            color: Colors.grey,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 10,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              project['address'],
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            boxH20(),
                            Text(
                              project['average_project_price']?.toString().isNotEmpty == true
                                  ? controller.formatIndianPrice(project['average_project_price'] ?? 0)
                                  : '₹ N/A',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Circular logo image - Centered version
                  Positioned(
                    top: -(height * 0.058),
                    left: 0,
                    right: 0,
                    child: Center(
                      child: ClipOval(
                        child: SizedBox(
                          width: height * 0.12,
                          height: height * 0.12,
                          child: project['cover_image'] != null
                              ? CachedNetworkImage(
                            imageUrl: project['cover_image'],
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) => Image.asset(
                              'assets/image_rent/langAsiaCity.png',
                              fit: BoxFit.cover,
                            ),
                          )
                              : Image.asset(
                            'assets/image_rent/langAsiaCity.png',
                            fit: BoxFit.cover,
                          ),
                        ),
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
  void addEnquiry(context, String developer_id) async {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    showModalBottomSheet<void>(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return GetBuilder<PostPropertyController>(
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
                                "Add Enquiry",
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
                      CustomTextFormField(
                        controller: controller.addressController,
                        labelText: 'Enter Message',
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter message';
                          }
                          return null;
                        },
                      ),
                      boxH10(),
                      GestureDetector(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            // developer_id, name, user_id, email, contact_number,message
                            controller
                                .addDeveloperEnquiry(
                                message:
                                controller.addressController.value.text,
                                developer_id: developer_id)
                                .then((value) {
                              controller.addressController.clear();
                              Navigator.of(context).pop();
                            });
                          } else {
                            Fluttertoast.showToast(
                              msg: 'Please fill all required fields',
                            );
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: AppColor.blueGrey,
                          ),
                          child: const Text(
                            'Send Enquiry',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      boxH20(),
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
}
