import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/common_widgets/height.dart';
import 'package:real_estate_app/common_widgets/loading_dart.dart';
import 'package:real_estate_app/global/api_string.dart';
import 'package:real_estate_app/global/app_color.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/CustomBottomNavBar.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/profile_screen/profile_controller.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/profile_screen/profile_section_screens/PlansAndSubscriptions/PlansAndSubscription.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/search_screen/searchController.dart';
import 'package:real_estate_app/view/property_screens/recommended_properties_screen/propertyCard.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common_widgets/custom_textformfield.dart';
import '../../utils/String_constant.dart';
import '../../utils/shared_preferences/shared_preferances.dart';
import '../../utils/shared_preferences/shared_preferances.dart';
import '../splash_screen/splash_screen.dart';
import '../subscription model/controller/SubscriptionController.dart';
import 'properties_controllers/post_property_controller.dart';
import 'recommended_properties_screen/properties_details_screen.dart';

class agent_profile extends StatefulWidget {
  final agent_name;
  final agent_id;
  const agent_profile({super.key, this.agent_name, this.agent_id});

  @override
  State<agent_profile> createState() => _agent_profileState();
}

class _agent_profileState extends State<agent_profile>with TickerProviderStateMixin {
  late TabController _tabController;
  final PostPropertyController controller = Get.put(PostPropertyController());
  final searchApiController = Get.find<searchController>();
  final ProfileController profileController = Get.find();
  final planController = Get.find<SubscriptionController>();
  int _currentIndex = 0;
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
      profileController.getPropertyAgentProfile(agentId: widget.agent_id);
      checkPlan();
      // profileController.getProjectAgentProfile(widget.agent_id);
    });
    print('profile data : ${profileController.propertyAgentList}');

  }

  void getData(int value){
    if(value ==0) {
      profileController.getPropertyAgentProfile(
          agentId: widget.agent_id,category_type : 'Buy');
    }
    else if(value ==1){
      profileController.getPropertyAgentProfile(
          agentId: widget.agent_id,category_type: 'Rent');
    }
    else{
      profileController.getPropertyAgentProfile(
          agentId: widget.agent_id,building_type: 'Commercial');
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
      body: SingleChildScrollView(
        child: Obx(() => Column(
          children: [
            profileController.propertyAgentDetails.isNotEmpty
                ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: profileController.propertyAgentDetails[0]['profile_image'] != null
                        ? NetworkImage(profileController.propertyAgentDetails[0]['profile_image']!)
                        : AssetImage("assets/man.png") as ImageProvider,
                    child: profileController.propertyAgentDetails[0]['profile_image'] == null
                        ? Image.asset("assets/man.png", height: 75, width: 75)
                        : null,
                  ),
                  boxW05(),
                  Column(
                    children: [
                      Text(
                        profileController.propertyAgentDetails[0]['full_name'] ?? '',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        profileController.propertyAgentDetails[0]['user_type'] ?? '',
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
                            profileController.propertyAgentDetails?.isNotEmpty ?? false
                                ? profileController.propertyAgentDetails![0]['experience']?.toString() ?? 'N/A'
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
                        profileController.propertyAgentDetails?.isNotEmpty ?? false
                            ? profileController.propertyAgentDetails![0]['proprietorship']?.toString() ?? 'N/A'
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
                      _showContactDetailsBottomSheet(context, profileController.propertyAgentDetails[0]['full_name'] ?? '', profileController.propertyAgentDetails[0]['mobile_number'] ?? '');
                    },
                  )

              ),
            ),

            boxH10(),

            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TabBar(
                  controller: _tabController,
                  onTap: (value) {
                    getData(value);
                  },
                  tabs: [
                    Tab(
                      child: SizedBox(
                        // width: 80,
                        child: Row(
                          children: [
                            const Text('Buy'),
                            boxW15(),
                            Container(
                              width: 25,
                              height: 25,
                              decoration: const BoxDecoration(
                                color: AppColor.boldColor,
                                shape: BoxShape.circle,
                              ),
                              child:  Center(
                                child: Text(
                                  profileController.buyCount.value ,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Tab(
                      child: SizedBox(
                        //  width: 80,
                        child: Row(
                          children: [
                            const Text('Rent'),
                            boxW15(),
                            Container(
                              width: 25,
                              height: 25,
                              decoration: const BoxDecoration(
                                color: AppColor.boldColor,
                                shape: BoxShape.circle,
                              ),
                              child:  Center(
                                child: Text(
                                  profileController.rentCount.value,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Tab(
                      child: SizedBox(
                        width: 180,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              const Text('Commercial'),
                              boxW05(),
                              Container(
                                width: 25,
                                height: 25,
                                decoration: const BoxDecoration(
                                  color: AppColor.boldColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    profileController.commercialCount.value,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  height: 500,
                  child: TabBarView(
                    controller: _tabController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildPropertyListView(),
                      _buildPropertyListView(), // Reuse the same widget for different tabs
                      _buildPropertyListView(),
                    ],
                  ),
                ),

              ],
            ),
          ],
        )),
      ),
      bottomNavigationBar: CustomBottomNavBar(),

    );
  }
  // Helper method to build the property list view
  Widget _buildPropertyListView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: profileController.propertyAgentList.isNotEmpty
          ? Obx(() => ListView.builder(
        itemCount: profileController.propertyAgentList.length,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final property = profileController.propertyAgentList[index];
          return _buildPropertyCard(property, context);
        },
      ))
          : Center(
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
    );
  }

  // Helper method to build individual property card
  Widget _buildPropertyCard(Map<String, dynamic> property, BuildContext context) {
    return GestureDetector(
      onTap: () {
        final propertyId = property['_id']?.toString();
        if (propertyId != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PropertyDetailsScreen(id: propertyId),
            ),
          );
        }
      },
      child: Container(
        width: Get.width * 0.9,
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade100),
          color: AppColor.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageSlider(property),
            _buildPropertyDetails(property),
          ],
        ),
      ),
    );
  }

  // Helper method to build image slider
  Widget _buildImageSlider(Map<String, dynamic> property) {
    final images = property['property_images'] as List? ?? [];
    final coverImage = property['cover_image']?.toString();

    return Stack(
      children: [
        Center(
          child: CarouselSlider.builder(
            options: CarouselOptions(
              height: 250,
              autoPlay: true,
              enlargeCenterPage: true,
              viewportFraction: 1,
              aspectRatio: 16 / 9,
              enableInfiniteScroll: true,
              autoPlayInterval: const Duration(seconds: 3),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              scrollDirection: Axis.horizontal,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
            itemCount: images.isNotEmpty ? images.length : 1,
            itemBuilder: (context, carouselIndex, realIndex) {
                // Safety check
                if (images.isEmpty && coverImage == null) {
                  return _buildPlaceholderImage();
                }

                String? imgUrl;

                if (images.isNotEmpty) {
                  imgUrl = images[carouselIndex]['image'] as String?;
                } else if (coverImage != null) {
                  imgUrl = coverImage;
                }

                if (imgUrl == null || imgUrl.isEmpty) {
                  return _buildPlaceholderImage();
                }

                return ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: CachedNetworkImage(
                    imageUrl: imgUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[300],
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => _buildPlaceholderImage(),
                  ),
                );
              },

          ),
        ),

        // Dotted Indicator
        if (images.isNotEmpty)
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                images.length,
                    (indicatorIndex) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: _currentIndex == indicatorIndex ? 10 : 8,
                  height: _currentIndex == indicatorIndex ? 10 : 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == indicatorIndex
                        ? Colors.white
                        : Colors.white.withOpacity(0.5),
                  ),
                ),
              ),
            ),
          ),

        // "10 Days on Houzza" Banner
        Positioned(
          top: 10,
          left: 10,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(15),
            ),
            child:  Text(
              "${property['days_since_created'] ?? 0} Days on Houzza",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),

        // Virtual Tour Button
        Positioned(
          top: 10,
          right: 50,
          child: GestureDetector(
            onTap: () {
              if (isLogin == true) {
                // Navigate to virtual tour
              } else {
                // LoginView(context);
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Image.asset("assets/image_rent/VirtualTour.png", width: 20, height: 20),
                  const SizedBox(width: 5),
                  const Text(
                    "Virtual Tour",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Favorite Icon
        Positioned(
          top: 10,
          right: 10,
          child: GestureDetector(
            onTap: () {
              if (isLogin == true) {
                if(property['is_favorite'].toString()=="false") {
                  searchApiController
                      .addFavorite(
                      property_id: property['_id'])
                      .then((_) {
                    property['is_favorite'] =true;
                  });
                }
                else{
                  searchApiController
                      .removeFavorite(
                      property_id: property['_id'],favorite_id:property['favorite_id'])
                      .then((_) {
                    property['is_favorite'] = false;
                  });
                }
                setState(() {
                  /// update ui
                  controller.getFeaturedProperty();
                });

              } else {
                //LoginView(context);
              }
            },
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child:  Icon(

                Icons.favorite,
                color: property['is_favorite'].toString()=="false"? Colors.white:Colors.red,
                size: 22,
              ),
            ),
          ),
        ),

        Positioned(
          bottom: 0,
          left: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: const BoxDecoration(
              color: Color(0xFF52C672),
              borderRadius: BorderRadius.only(topRight: Radius.circular(10)),
            ),
            child:  Text(
              "FOR ${property['property_category_type'].toUpperCase()}",
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
        ),
      ],
    );
  }

  _showContactDetailsBottomSheet(BuildContext context, String? name, String? phoneNo) {
    bool hasContactPlan = freeViewCount >0;
    if(paidViewCount > 0){
      setState(() {
        hasContactPlan = true; // if user has paid count
      });
    }
    print(name);
    print(phoneNo);
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
  // Helper method for placeholder image
  Widget _buildPlaceholderImage() {
    return Container(
      color: Colors.grey[400],
      child: const Center(
        child: Icon(Icons.image_rounded, color: Colors.white),
      ),
    );
  }

  // Helper method to build property details
  Widget _buildPropertyDetails(Map<String, dynamic> property) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Property Name and Share Button
          Row(
            children: [
              Expanded(
                child: Text(
                  property['property_name']?.toString() ?? 'No Name',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColor.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              GestureDetector(
                onTap: () async {

                  shareProperty(property['_id']!.toString());


                },
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Image.asset(
                      "assets/image_rent/share.png",
                      height: 18,
                      width: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Price & BHK Type
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDetailRow(
                "assets/image_rent/money.png",
                '${controller.formatIndianPrice(property['property_price'].toString() ?? '') ?? 'N/A'}',
              ),
              _buildDetailRow(
                "assets/image_rent/house.png",
                property['bhk_type']?.toString() ?? 'N/A',
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Area & Furnishing Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDetailRow(
                "assets/image_rent/format-square.png",
                '${property['area']?.toString() ?? 'N/A'} ${property['area_in']?.toString() ?? 'N/A'}',
              ),
              _buildDetailRow(
                "assets/image_rent/squareft.png",
                property['furnished_type']?.toString() ?? 'N/A',
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Address & City Name
          Text(
            '${property['address']?.toString() ?? ''},\n${property['city_name']?.toString() ?? ''}'.trim(),
            style: TextStyle(
              fontSize: 14,
              color: AppColor.black.withOpacity(0.6),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 16),

          // Owner Information
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColor.grey.withOpacity(0.1),
                child: ClipOval(
                  child: Image.asset(
                    'assets/image_rent/profile.png',
                    width: 30,
                    height: 30,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property['owner_name']?.toString() ?? "Priya Gurnani",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const Text(
                    "Owner",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper method to build detail row
  Widget _buildDetailRow(String iconPath, String text) {
    return Row(
      children: [
        Image.asset(
          iconPath,
          height: 24,
          width: 24,
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColor.black87,
          ),
        ),
      ],
    );
  }
}
