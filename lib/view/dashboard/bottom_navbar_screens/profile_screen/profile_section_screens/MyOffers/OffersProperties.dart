import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:real_estate_app/common_widgets/custom_textformfield.dart';
import 'package:real_estate_app/common_widgets/height.dart';
import 'package:real_estate_app/common_widgets/loading_dart.dart';
import 'package:real_estate_app/common_widgets/subscription_dialog.dart';
import 'package:real_estate_app/global/app_color.dart';
import 'package:real_estate_app/utils/common_snackbar.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/CustomBottomNavBar.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/profile_screen/profile_section_screens/Advertisement/Advertisements.dart';
import 'package:real_estate_app/view/property_screens/properties_controllers/post_property_controller.dart';
import 'package:real_estate_app/view/property_screens/recommended_properties_screen/properties_details_screen.dart';

import '../../../../../../global/api_string.dart';
import '../../../../../../utils/String_constant.dart';
import '../../../../../../utils/shared_preferences/shared_preferances.dart';
import '../../profile_controller.dart';
import '../MyProjects/MyProjects.dart';
import '../PlansAndSubscriptions/PlansAndSubscription.dart';


class OffersProperties extends StatefulWidget {
  final String? isfrom;
  final String? id;
  final dynamic property;

  const OffersProperties({
    super.key,
    this.isfrom,
    this.id,
    this.property,
  });

  @override
  State<OffersProperties> createState() => _OffersPropertiesState();
}

class _OffersPropertiesState extends State<OffersProperties> {
  final FocusNode _focusNode = FocusNode();
  final FocusNode _focusNode1 = FocusNode();
  TextEditingController searchController = TextEditingController();
  PostPropertyController controller = Get.put(PostPropertyController());
  ProfileController profileController = Get.put(ProfileController());
  final GlobalKey<FormState> FormKey = GlobalKey<FormState>();
  String  isOffer='';
  final scrollController = ScrollController();

  @override
  // void initState() {
  //   super.initState();
  //  searchController.clear();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //
  //     getData();
  //     controller.getOffer(page: '1');
  //     profileController.getMyListingProperties(page: '1');
  //   });
  //   searchController.addListener(() {
  //     filterOffers(searchController.text);
  //   });
  //   controller.scrollController.addListener(() {
  //     if (controller.scrollController.position.pixels >= controller.scrollController.position.maxScrollExtent - 100 &&
  //         !controller.isPaginationLoading.value &&
  //         controller.hasMore.value) {
  //       loadMoreData();
  //     }
  //   });
  //   profileController.scrollController.addListener(() {
  //     if (profileController.scrollController.position.pixels >= profileController.scrollController.position.maxScrollExtent - 100 &&
  //         !profileController.isPaginationLoading.value &&
  //         profileController.hasMore.value) {
  //       loadMorePropertyData();
  //     }
  //   });
  //
  //   if(widget.isfrom=="my_property"){
  //     _showOfferBottomSheet(context:context,
  //         isfrom: 'add', id: '', propertyId: widget.id, image: '', offerName: '', offerDescription: '', offerTime: '');
  //
  //   }
  //
  // }

  @override
  void initState() {
    super.initState();

    searchController.clear();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ✅ Call your initial data fetching
      getData();
      controller.getOffer(page: '1');
      profileController.getMyListingProperties(page: '1');





      // ✅ Open the bottom sheet AFTER first frame is rendered
      if (widget.isfrom == "my_property") {
        _showOfferBottomSheet(
          context: context,
          isfrom: 'add',
          id: '',
          propertyId:widget.id!,
          image: '',
          offerName: '',
          offerDescription: '',
          offerTime: '',
          proprty: widget.property!,
        );
      }
    });

    searchController.addListener(() {
      filterOffers(searchController.text);
    });

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 100 &&
          !controller.isPaginationLoading.value &&
          controller.hasMore.value) {
        loadMoreData();
      }
    });

    profileController.scrollController.addListener(() {
      if (profileController.scrollController.position.pixels >=
          profileController.scrollController.position.maxScrollExtent - 100 &&
          !profileController.isPaginationLoading.value &&
          profileController.hasMore.value) {
        loadMorePropertyData();
      }
    });
  }


  void filterOffers(String query) {
    if (query.isEmpty) {
      controller.filteredOfferList.assignAll(controller.getOfferList);
    } else {
      final lowerQuery = query.toLowerCase();
      controller.filteredOfferList.assignAll(
        controller.getOfferList.where((offer) {
          final propertyName = offer['property_data']?['property_name']?.toString().toLowerCase() ?? '';
          final offerName = offer['offer_name']?.toString().toLowerCase() ?? '';
          return propertyName.contains(lowerQuery) || offerName.contains(lowerQuery);
        }).toList(),
      );
    }
  }


  void loadMoreData() {
    if (controller.hasMore.value && !controller.isPaginationLoading.value) {
      controller.isPaginationLoading.value = true;

      final nextPage = (controller.currentPage.value + 1).toString();

      if (searchController.text.trim().isNotEmpty) {

      } else {
        controller.getOffer(page: nextPage);
      }
    }
  }
  getData() async {
    String  Offer= (await SPManager.instance.getOffers(Offers))??"no";
    int? offerCount= (await SPManager.instance.getOfferCount(PAID_OFFER))??0;
    int? offerPlanCount= (await SPManager.instance.getPlanOfferCount(PLAN_OFFER))??0;
    print('getData()==>');
    print(Offer);
    print(offerCount);
    print(offerPlanCount);


    if(Offer=='no'){
      setState(() {
        isOffer ='no';
      });
    }else{
      if(offerCount > 0){
        setState(() {
          isOffer ='yes';
        });
      }else {
        setState(() {
          isOffer ='no_limit';
        });
      }
    }
    ///



  }
  void loadMorePropertyData() {
    if (profileController.hasMore.value && !profileController.isPaginationLoading.value) {
      profileController.isPaginationLoading.value = true;

      final nextPage = (profileController.currentPage.value + 1).toString();

      if (profileController.searchController.text.trim().isNotEmpty) {
        profileController.getMySearchProperties(searchKeyword:profileController.searchController.text.trim(), page: nextPage);
      } else {
        profileController.getMyListingProperties(page: nextPage);
      }
    }
  }
  void onSearchChanged(String value) {
    profileController.currentPage.value = 1;
    profileController.hasMore.value = true;
    if (value.trim().isEmpty) {
      profileController.getMyListingProperties(page: '1');
    } else {
      profileController.getMySearchProperties(searchKeyword:value.trim(), page: '1');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Offer / Promote", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),),
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
                color: Colors.black, // Border color
                width: 0.1, // Border width
              ),
            ),
            child: InkWell(
              onTap: () {
                Get.back();
              },
              borderRadius: BorderRadius.circular(
                  50),
              child: const Padding(
                padding: EdgeInsets.all(6), // Adjust padding for better spacing
                child: Icon(
                  Icons.arrow_back_outlined,
                  size: 18,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ),

      body:
      // isOffer=='no'?
      // Center(
      //   child: Padding(
      //     padding: const EdgeInsets.all(24.0),
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         const Icon(
      //           Icons.local_offer_outlined,
      //           size: 80,
      //           color: AppColor.primaryThemeColor,
      //         ),
      //         const SizedBox(height: 20),
      //         const Text(
      //           'You have no purchase plan',
      //           style: TextStyle(
      //             fontSize: 20,
      //             fontWeight: FontWeight.bold,
      //             color: Colors.black87,
      //           ),
      //           textAlign: TextAlign.center,
      //         ),
      //         const SizedBox(height: 10),
      //         const Text(
      //           'Please post an offer to get started.',
      //           style: TextStyle(
      //             fontSize: 16,
      //             color: Colors.grey,
      //           ),
      //           textAlign: TextAlign.center,
      //         ),
      //         const SizedBox(height: 30),
      //         commonButton(
      //           width: 150,
      //           height: 50,
      //           buttonColor: AppColor.primaryThemeColor,
      //           text: "Purchase",
      //           textStyle: const TextStyle(
      //               fontSize: 14,
      //               color: Colors.white
      //           ),
      //           onPressed: () async {
      //             await Get.to(const PlansAndSubscription());
      //            await getData();
      //           },
      //
      //         ),
      //       ],
      //     ),
      //   ),
      // ):

      Stack(
          children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                height: 50,
                child: TextField(
                  focusNode: _focusNode,
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: "Search",
                    hintStyle: const TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.normal),
                    prefixIcon: const Icon(Icons.search, size: 25),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.cancel, size: 18),
                      onPressed: () {
                        searchController.clear();
                        filterOffers('');
                        FocusScope.of(context).unfocus();
                      },

                    ),
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
                ),
              ),
            ),
            Expanded(
              child:Obx(() {
                if (controller.filteredOfferList.isEmpty && controller.isLoading.value) {
                  return  Center(child:  GFLoader(
                      size: 40,
                      loaderColorOne:   Colors.purple,
                      loaderColorTwo:Colors.red,
                      loaderColorThree:  Colors.yellow.shade700,
                      type: GFLoaderType.circle),);
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    controller.getOffer(page: '1');
                  },
                  child: controller.filteredOfferList.isEmpty
                      ? const Center(
                    child: Text(
                      'No offers found.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                      : LazyLoadScrollView(
                    onEndOfPage: () {
                      if (controller.hasMore.value && !controller.isPaginationLoading.value) {
                        loadMoreData();
                      } else {
                        print("LazyLoadScrollView==>");
                        print(controller.hasMore.value);
                        print(controller.isPaginationLoading.value);
                      }
                    },
                    isLoading: controller.isPaginationLoading.value,
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: scrollController,
                      itemCount: controller.filteredOfferList.length +
                          (controller.isPaginationLoading.value ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == controller.filteredOfferList.length) {
                          return const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        final property = controller.filteredOfferList[index];

                        return  SizedBox(
                          width: Get.width,
                          height: Get.height * 0.50,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white, // Background color
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color:property['status']=="Disapproved"? Colors.red.shade400:Colors.grey.shade50,
                                  width: 1.0,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Top section (Status tag and date)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(

                                          color:property['status']=="Pending"? Colors.orange[100]:
                                          property['status']=="Approved"?Colors.green[100]:Colors.red[100],

                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          property['status']=="Approved"?
                                          "Published":
                                          property['status']=="Pending"?"Pending":"Rejected",
                                          style: TextStyle(
                                              color:property['status']=="Pending"? Colors.orange:
                                              property['status']=="Approved"?Colors.green:Colors.red,
                                              //Colors.green,

                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Text(
                                        DateFormat('dd MMM, yyyy').format(DateTime.parse(property['created_at'])),
                                        style: const TextStyle(color: Colors.grey, fontSize: 14),
                                      ),

                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    property['offer_name']??"",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  GestureDetector(
                                    onTap: (){
                                      Get.to(PropertyDetailsScreen(
                                        id: property['property_data']?['_id'],
                                      ));
                                    },
                                    child: Row(
                                      children: [

                                        Stack(
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(8),
                                                child: controller.filteredOfferList[index]['offer_img'] != null
                                                    ? CachedNetworkImage(
                                                  width: 80,
                                                  height: 70,
                                                  fit: BoxFit.cover,
                                                //  imageUrl: APIString.imageBaseUrl + controller.filteredOfferList[index]['offer_img'],
                                                  imageUrl: APIString.imageBaseUrl + property['property_data']['cover_image'],
                                                  placeholder: (context, url) => Container(
                                                    width: 80,
                                                    height: 70,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                  ),
                                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                                )
                                                    : Container(
                                                  color: Colors.grey[400],
                                                  width: 80,
                                                  height: 70,
                                                  child: const Center(
                                                    child: Icon(Icons.image_rounded),
                                                  ),
                                                ),

                                              ),
                                              property['property_data']!=null?
                                              Positioned(
                                                left: 0,
                                                top: 0,
                                                child: Container(
                                                  padding: const EdgeInsets.symmetric(
                                                      horizontal: 6, vertical: 4),
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xFF6969EB),
                                                    borderRadius: BorderRadius.circular(6),
                                                  ),
                                                  child: Text(
                                                    property['property_data']?['property_category_type']?.toString().toUpperCase() ?? 'N/A',
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              ):const SizedBox(),
                                            ]),
                                        const SizedBox(width: 10),

                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(height: 6),
                                              Text(
                                                property['property_data']?['property_name'] ?? 'NA',
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              // Text(
                                              //   //  property['property_data']['address'],
                                              //   // property['property_data']!=null?
                                              //   // property['property_data']['property_category_type']=="Buy"?
                                              //   property['property_data']['property_price'].toString(),
                                              //
                                              //   overflow: TextOverflow.ellipsis,
                                              //   maxLines: 2,
                                              //   style: const TextStyle(
                                              //       color: Colors.grey, fontSize: 14),
                                              // ),
                                              Text(
                                                //  property['property_data']['address'],
                                                property['property_data']?['address'] ?? 'NA',
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: const TextStyle(
                                                    color: Colors.grey, fontSize: 14),
                                              ),

                                              Row(
                                                children: [
                                                  Text(
                                                    property['property_data']!=null?
                                                    property['property_data']['property_type']=="Plot"?
                                                    property['property_data']['area'].toString()+" "+ property['property_data']['area_in']:
                                                    property['property_data']['bhk_type']:"N/A",

                                                    // property.bhk,
                                                    style: const TextStyle(
                                                        fontSize: 17,
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                  const SizedBox(width: 10,),
                                                  //Text(
                                                  //   property['property_data'] != null && property['property_data']['property_price'] != null
                                                  //       ? formatIndianCurrency(property['property_data']['property_price'])
                                                  //       : "N/A",
                                                  //   style: const TextStyle(
                                                  //     fontSize: 17,
                                                  //     fontWeight: FontWeight.bold,
                                                  //   ),
                                                  // ),

                                                  property['property_data']['property_category_type']=="Rent"?
                                                  Text(
                                                    '${controller.formatIndianPrice(property['property_data']['property_price'].toString())} / ${controller.formatIndianPrice(property['property_data']['rent'].toString())} Month',
                                                    style: const TextStyle(
                                                      fontSize: 17,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  )
                                                      :
                                                  Text(
                                                    //   _postPropertyController.formatIndianPrice(property['rent']),
                                                    controller.formatIndianPrice(property['property_data']['property_price'].toString()),
                                                    style: const TextStyle(
                                                        fontSize: 17,
                                                        fontWeight: FontWeight.bold),
                                                  ),

                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20),

                                  // Views and Leads
                                  Container(
                                    padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                            color: AppColor.greyBorderColor,
                                            width: 0.8)),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text("Views",
                                                style: TextStyle(color: Colors.grey)),
                                            const SizedBox(height: 4),
                                            Text(
                                              property['property_data']?['view_count']?.toString() ?? '0.0',
                                              style: const TextStyle(fontWeight: FontWeight.bold),
                                            )

                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text("Leads",
                                                style: TextStyle(color: Colors.grey)),
                                            const SizedBox(height: 4),
                                            Text(  property['property_data']?['leads_count']?.toString() ?? '0.0',

                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  // Action Buttons
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Edit Button
                                      ElevatedButton(
                                        onPressed: () {

                                          _showOfferBottomSheet(context:context, isfrom:
                                          'edit',id:property['_id'], propertyId: property['property_data']['_id'], image: property['offer_img'],
                                            offerDescription: property['offer_description'], offerName: property['offer_name'], offerTime:property['offer_time']??"", proprty: null,
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                              side: const BorderSide(
                                                  color: Color(0xFF813BEA),
                                                  width: 0.8)),
                                        ),
                                        child: const Text(
                                          "Edit",
                                          style: TextStyle(
                                              color: Color(0xFF813BEA),
                                              fontSize: 15),
                                        ),
                                      ),




                                   //   const Spacer(),

                                      // Conditional buttons based on status
                                      // if (property['status'] == "Approved")
                                      //    ElevatedButton(
                                      //      onPressed: () {
                                      //        //_showStopReasonDialog(context, property);
                                      //      },
                                      //      style: ElevatedButton.styleFrom(
                                      //        backgroundColor: Colors.white,
                                      //        shape: RoundedRectangleBorder(
                                      //            borderRadius: BorderRadius.circular(8),
                                      //            side: const BorderSide(
                                      //                color: Color(0xFFEA4335),
                                      //                width: 0.8)),
                                      //      ),
                                      //      child: const Text(
                                      //        "Stop",
                                      //        style: TextStyle(
                                      //            color: Color(0xFFEA4335),
                                      //            fontSize: 15),
                                      //      ),
                                      //    ),

                                      if (property['status'] == "Disapproved")
                                        ElevatedButton(
                                          onPressed: () {
                                            _showReasonDialog(context, property['reason']??"" );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8),
                                                side: BorderSide(
                                                    color: property['status'] == "Disapproved"
                                                        ? Colors.black.withOpacity(0.7)
                                                        : Colors.black,
                                                    width: 0.8)),
                                          ),
                                          child: Text(
                                            "View Reason",
                                            style: TextStyle(
                                                color: property['status'] == "Rejected"
                                                    ? Colors.black.withOpacity(0.6)
                                                    : Colors.black,
                                                fontSize: 15),
                                          ),
                                        ),
                                      const SizedBox(width: 5,),
                                      IconButton(
                                          onPressed: () {
                                            showCommonBottomSheet(
                                              context: context,
                                              title: "Delete Offer",
                                              message: "Are you sure you want to delete this offer?",
                                              onYesPressed: () {
                                                controller.deleteOffer(id:   property['_id']);

                                              },
                                              onNoPressed: () {

                                              },
                                            );
                                          },
                                          icon: Image.asset(
                                            "assets/image_rent/delete.png",
                                            height: 25,
                                            width: 25,
                                          )),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              }),

            ),

            boxH20(),
          ],
        ),


      ]),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child:
        // isOffer=='no'?
        //     SizedBox():
        //
        // isOffer=='no_limit'?
        // const Text(
        //   "You have exceeded the limit for posting offer under your current plan. "
        //       "To continue using this feature, please consider upgrading or "
        //       "updating your plan.",
        //   style: TextStyle(
        //     color: Colors.red,
        //     fontSize: 14,
        //   ),
        // ):
        SizedBox(
          width: Get.width,
          height: Get.width * 0.15,
          child: ElevatedButton(
            onPressed: () {
              controller.coverImgs.value = null;
              if(isOffer=='no' || isOffer=='no_limit'){
                SubscriptionDialog.show(
                  context: context,
                  onPurchase: () {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (_) => const PlansAndSubscription(isfrom: 'offer',)
                    )).then((value) async =>{
                      await   getData(),
                    });
                  },
                  type: 'offer',
                );
              }else{
                _showOfferBottomSheet(context:context,
                    isfrom: 'add', id: '', propertyId: '', image: '', offerName: '', offerDescription: '', offerTime: '', proprty: null);

              }




            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF52C672),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
            child: const Text("Create New Offer",
                style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
        ),
      ),
    );
  }
  String formatIndianCurrency(num amount) {
    if (amount >= 10000000) {
      return '₹${(amount / 10000000).toStringAsFixed(2)} Cr';
    } else if (amount >= 100000) {
      return '₹${(amount / 100000).toStringAsFixed(2)} Lakh';
    } else if (amount >= 1000) {
      return '₹${(amount / 1000).toStringAsFixed(2)} K';
    } else {
      return '₹$amount';
    }
  }

  void _showOfferBottomSheet({
    required BuildContext context,
    required String isfrom,
    required String id,
    required String propertyId,
    required String image,
    required String offerName,
    required String offerDescription,
    required String offerTime,
    required var proprty,

    Color buttonColor = const Color(0xFF813BEA),

  }) {
    final RxInt currentStep = 0.obs;

    if(isfrom=="edit"){
      profileController.myselectedListing.clear();
      final index1 = profileController.myListingPrperties.indexWhere(
            (item) => item['_id'] == propertyId,
      );
      if (index1 != -1) {
        profileController.selectedIndex.value = index1;

        profileController.myselectedListing.add(profileController.myListingPrperties[index1]);
      }
      controller.offerNameController.text=offerName;
    controller.offerDescriptionController.text=offerDescription;
    controller.offerDurationController.text=offerTime;

    }else if(isfrom=="add" && propertyId!="" ){

      currentStep.value=1;
    //  profileController.myselectedListing.clear();




      controller.offerNameController.clear();
    controller.offerDescriptionController.clear();
    controller.offerDurationController.clear();
    }else{
      controller.offerNameController.clear();
      controller.offerDescriptionController.clear();
      controller.offerDurationController.clear();
    }


    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return Obx(() => WillPopScope(
          onWillPop: () async {
            if (currentStep.value > 0) {
              currentStep.value--;
              return false;
            } else {
              return true;
            }
          },
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.94,
            child: Padding(
              padding: EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                bottom: MediaQuery.of(context).viewInsets.bottom,
                top: 20,
              ),
              child: SingleChildScrollView(
                child: Column(

                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Header Section
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            if(currentStep.value == 0){
                              Navigator.pop(context);

                            }else{
                              setState(() {
                                currentStep.value--;
                              });
                            }
                           },
                          borderRadius: BorderRadius.circular(50),
                          child: const Padding(
                            padding: EdgeInsets.all(6),
                            child: Icon(Icons.arrow_back_outlined, size: 18, color: Colors.black),
                          ),
                        ),
                        const Spacer(),
                        Text(

                          currentStep.value == 0 ? "Select Property" : "Offer Details",
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        const Spacer(),
                      ],
                    ),

                    boxH10(),

                    // **Step 1: Property Selection**
                    if (currentStep.value == 0) ...[
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SizedBox(
                          height: 50,
                          child: TextField(
                            focusNode: _focusNode1,
                            controller: profileController.searchController,
                            onSubmitted: (value) {
                              onSearchChanged(value);

                            },

                            decoration: InputDecoration(
                              hintText: "Search",
                              hintStyle: const TextStyle(
                                  color: Colors.grey, fontWeight: FontWeight.normal),
                              prefixIcon: const Icon(Icons.search, size: 25),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.cancel, size: 18),
                                onPressed: () {
                                  profileController.searchController.clear();
                                  onSearchChanged('');
                                },
                              ),
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
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.66,
                        child:  Obx(() {
                          if (profileController.myListingPrperties.isEmpty && controller.isLoading.value) {
                            return const Center(child: CircularProgressIndicator());
                          }

                          return RefreshIndicator(
                              onRefresh: () async {
                                profileController.getMyListingProperties(page: '1');
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
                                child: ListView.builder(
                                  physics: const AlwaysScrollableScrollPhysics(),
                                  controller: profileController.scrollController,
                                  itemCount: profileController.myListingPrperties.length + (profileController.isPaginationLoading.value ? 1 : 0),
                                  itemBuilder: (context, index) {


                                    if (index == profileController.myListingPrperties.length) {
                                      return const Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: Center(child: CircularProgressIndicator()),
                                      );
                                    }
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                                      child:   Card(
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      elevation: 0.5,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Obx(()=>
                                               Checkbox(
                                                value: profileController.selectedIndex.value == index,
                                                onChanged: (value) {
                                                  if (value == true) {
                                                    profileController.selectedIndex.value = index;

                                                    // Clear previous selection and add new item
                                                    profileController.myselectedListing.clear();
                                                    profileController.myselectedListing.add(profileController.myListingPrperties[index]);
                                                  } else {
                                                    profileController.selectedIndex.value = -1;
                                                    profileController.myselectedListing.clear();
                                                  }
                                                },
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(4),
                                                  side: const BorderSide(color: Colors.purple, width: 0.4),
                                                ),
                                              ),),

                                            const SizedBox(width: 8),
                                            Stack(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius: BorderRadius.circular(8),
                                                    child: Image.network(
                                                      profileController.searchController.text.isNotEmpty?
                                                      APIString.imageBaseUrl+ profileController.myListingPrperties[index]['cover_image']: profileController.myListingPrperties[index]['cover_image'],
                                                      width: 80,
                                                      height: 70,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  Positioned(
                                                    left: 0,
                                                    top: 0,
                                                    child: Container(
                                                      padding: const EdgeInsets.symmetric(
                                                          horizontal: 6, vertical: 4),
                                                      decoration: BoxDecoration(
                                                        color:profileController.myListingPrperties[index]['property_category_type'].toString() =="Rent"?
                                                        AppColor.primaryThemeColor:AppColor.green,
                                                        borderRadius:
                                                        BorderRadius.circular(6),
                                                      ),
                                                      child:  Text(
                                                        "FOR ${profileController.myListingPrperties[index]['property_category_type'].toString().toUpperCase()}",
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 10,
                                                            fontWeight: FontWeight.bold),
                                                      ),
                                                    ),
                                                  ),
                                                ]),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(profileController.myListingPrperties[index]['property_name'] ?? '', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                                  Text(profileController.myListingPrperties[index]['address']?? '',overflow: TextOverflow.ellipsis,maxLines: 2, style: const TextStyle(color: Colors.grey, fontSize: 14)),
                                                  // Text(profileController.myListingPrperties[index]['property_price']
                                                  // .toString()?? '', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),

                                                  profileController.myListingPrperties[index]['property_category_type']=="Rent"?
                                                  Text(
                                                    ' ${controller.formatIndianPrice(profileController.myListingPrperties[index]['rent'].toString())}/ Month',
                                                    style: const TextStyle(
                                                      fontSize: 17,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  )
                                                      :
                                                  Text(
                                                    controller.formatIndianPrice(profileController.myListingPrperties[index]['property_price'].toString()),
                                                    style: const TextStyle(
                                                        fontSize: 17,
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                    );
                                  },
                                ),
                              )

                          );
                        }),

                      )
                    ],


                    if (currentStep.value == 1) ...[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          isfrom=="add" && propertyId!=""?
                          Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                              child:   Card(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                elevation: 0.5,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [

                                      Stack(
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(8),
                                              child: Image.network(
                                                proprty['cover_image'],
                                                width: 80,
                                                height: 70,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            Positioned(
                                              left: 0,
                                              top: 0,
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 6, vertical: 4),
                                                decoration: BoxDecoration(
                                                  color:proprty['property_category_type'].toString() =="Rent"?
                                                  AppColor.primaryThemeColor:AppColor.green,
                                                  borderRadius:
                                                  BorderRadius.circular(6),
                                                ),
                                                child:  Text(
                                                  "FOR ${proprty['property_category_type'].toString().toUpperCase()}",
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ]),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(proprty['property_name'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                            Text(proprty['address'],overflow: TextOverflow.ellipsis,maxLines: 2, style: const TextStyle(color: Colors.grey, fontSize: 14)),
                                            // Text(proprty['property_price'].toString(), style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                                            proprty['property_category_type']=="Rent"?
                                            Text(
                                              ' ${controller.formatIndianPrice(proprty['rent'].toString())}/ Month',
                                              style: const TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                                :
                                            Text(
                                              controller.formatIndianPrice(proprty['property_price'].toString()),
                                              style: const TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                          ):

                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: profileController.myselectedListing.length,
                            itemBuilder: (context, index) {


                              return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                                  child:   Card(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    elevation: 0.5,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [

                                          Stack(
                                              children: [
                                                ClipRRect(
                                                  borderRadius: BorderRadius.circular(8),
                                                  child: Image.network(
                                                    profileController.myselectedListing[index]['cover_image'],
                                                    width: 80,
                                                    height: 70,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                Positioned(
                                                  left: 0,
                                                  top: 0,
                                                  child: Container(
                                                    padding: const EdgeInsets.symmetric(
                                                        horizontal: 6, vertical: 4),
                                                    decoration: BoxDecoration(
                                                      color:profileController.myselectedListing[index]['property_category_type'].toString() =="Rent"?
                                                      AppColor.primaryThemeColor:AppColor.green,
                                                      borderRadius:
                                                      BorderRadius.circular(6),
                                                    ),
                                                    child:  Text(
                                                      "FOR ${profileController.myselectedListing[index]['property_category_type'].toString().toUpperCase()}",
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 10,
                                                          fontWeight: FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                              ]),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(profileController.myselectedListing[index]['property_name'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                                Text(profileController.myselectedListing[index]['address'],overflow: TextOverflow.ellipsis,maxLines: 2, style: const TextStyle(color: Colors.grey, fontSize: 14)),

                                                profileController.myselectedListing[index]['property_category_type']=="Rent"?
                                                Text(
                                                  ' ${controller.formatIndianPrice(profileController.myselectedListing[index]['rent'].toString())}/ Month',
                                                  style: const TextStyle(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )
                                                    :
                                                Text(
                                                  controller.formatIndianPrice(profileController.myselectedListing[index]['property_price'].toString()),
                                                  style: const TextStyle(
                                                      fontSize: 17,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                                // Text(profileController.myselectedListing[index]['property_price'].toString(), style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                              );
                            },
                          ),
                          boxH30(),

                          // **Upload Images**
                          Center(
                            child: Form(
                              key: FormKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [

                                  boxH10(),
                                  image.isNotEmpty || image!=''?
                                  CachedNetworkImage(
                                    width: 100, height: 60,
                                    fit: BoxFit.cover,
                                    imageUrl: APIString.imageBaseUrl + image,
                                    placeholder: (context, url) => Container(
                                      width: 100, height: 60,

                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                  ):
                                  controller.coverImgs.value != null
                                      ?
                                  Stack(
                                    children: [
                                      Image.file(
                                        controller.coverImgs.value!,
                                        width: 100,
                                        height: 60,
                                        fit: BoxFit.cover,
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: GestureDetector(
                                          onTap: () {
                                            controller.coverImgs.value = null;
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.black.withOpacity(0.6),
                                              shape: BoxShape.circle,
                                            ),
                                            padding: const EdgeInsets.all(4),
                                            child: const Icon(
                                              Icons.close,
                                              size: 16,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )

                                      : Image.asset(
                                    "assets/NewThemChangesAssets/upload_image.png", width: 100, height: 60,),
                                  boxH10(),
                               //   replace tesxt "Upload Image " with "Upload Offer Image"
                                  commonButton(
                                    width: 200,
                                    height: 40,
                                    buttonColor: buttonColor,
                                    text: "+ Upload Offer Image",
                                    textStyle: const TextStyle(fontSize: 14, color: Colors.white),
                                    onPressed: (){
                                      controller.coverImgs.value = null;
                                      controller.updateCoverImage();
                                    }
                                  //  => controller.updateCoverImage(),
                                  ),
                                  boxH20(),

                                  // **Offer Name**
                                  CustomTextFormField(
                                    size: 50,
                                    maxLines: 2,
                                    controller: controller.offerNameController,

                                    labelText: "Offer Name",
                                    validator: (value) {
                                      if (value == null || value.trim().isEmpty) {
                                        return 'Please enter Offer Name';
                                      }
                                      return null;
                                    },
                                  ),

                                  boxH10(),

                                  // **Offer Duration**
                                  // CustomTextFormField(
                                  //   size: 50,
                                  //   maxLines: 3,
                                  //   controller: controller.offerDurationController,
                                  //   labelText: "Offer Duration",
                                  //   validator: (value) {
                                  //     if (value == null || value.trim().isEmpty) {
                                  //       return 'Please enter Offer Duration';
                                  //     }
                                  //     return null;
                                  //   },
                                  // ),
                                  //
                                  // boxH10(),
                                  // **Offer Description**
                                  CustomTextFormField(
                                    size: 50,
                                    maxLines: 3,
                                    labelText: "Offer Description",

                                    controller: controller.offerDescriptionController,
                                    validator: (value) {
                                      if (value == null || value.trim().isEmpty) {
                                        return 'Please enter Offer Description';
                                      }
                                      return null;
                                    },
                                  ),

                                  boxH10(),
                                ],
                              ),
                            ),
                          ),



                        ],
                      ),
                    ],

                    if(currentStep.value == 1)
                     // boxH50(),
                    // **Footer with Button**
                   // const Spacer(),
                    const Divider(),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Text(
                          //   "${controller.properties.where((p) => p.isSelected).length} Property Selected",
                          //   style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                          // ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                               // if (currentStep.value != 0)
                                  Text(
                                    isfrom=="add" && propertyId!=""? "1 Property Selected":
                                    "${profileController.myselectedListing.length} Property Selected",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                const Spacer(),

                                Obx(()=>
                                   commonButton(
                                    width:150,
                                    height: 50,
                                    buttonColor: buttonColor,
                                    text: currentStep.value == 0 ? "Next" : isfrom=="edit"? "Update Offer":"Create Offer",
                                    textStyle: const TextStyle(fontSize: 14, color: Colors.white),
                                    // onPressed: () async {
                                    //   if (currentStep.value == 0) {
                                    //     currentStep.value = 1;
                                    //   } else {
                                    //
                                    //
                                    //
                                    //     if (FormKey.currentState!.validate() && controller.coverImgs.value!=null) {
                                    //       Navigator.pop(context);
                                    //
                                    //       if(isfrom=="edit"){
                                    //         controller.UpdateOffer(
                                    //             name: controller.offerNameController.value.text,
                                    //             image: controller.coverImgs.value,
                                    //             property_id: profileController.myselectedListing.isNotEmpty?profileController.myselectedListing[0]['_id']:'',
                                    //             time: "NA",
                                    //             des: controller.offerDescriptionController.value.text, id:id
                                    //         ).then((value) {
                                    //           Navigator.pop(context);
                                    //           controller.getOffer(page: '1');
                                    //         });
                                    //       }else{
                                    //         await  controller.addOffer(
                                    //             name: controller.offerNameController.value.text,
                                    //             image: controller.coverImgs.value,
                                    //             property_id: profileController.myselectedListing.isNotEmpty?profileController.myselectedListing[0]['_id']:'',
                                    //             time: "NA",
                                    //             des: controller.offerDescriptionController.value.text
                                    //         );
                                    //         showCommonBottomSheet(
                                    //           context: context,
                                    //           title: "Offer Not Approved",
                                    //           message: "When they say there as no place like home, the adage rings true. Your home is a sanctuary whose walls are privy to every joyful moment. "
                                    //               "It is the hearth of your family and a distinct expression of your stature.",
                                    //
                                    //           messageTextStyle: const TextStyle(fontSize: 14, color: Colors.grey),
                                    //           onYesPressed: () {
                                    //             controller.getOffer(page: '1');
                                    //           },
                                    //           onNoPressed: () {
                                    //             controller.getOffer(page: '1');
                                    //           },
                                    //         );
                                    //
                                    //
                                    //       }
                                    //
                                    //
                                    //
                                    //     } else {
                                    //       Fluttertoast.showToast(
                                    //         msg: 'Please fill all required fields',
                                    //       );
                                    //     }
                                    //
                                    //   }
                                    // },
                                      onPressed: () async {
                                        // if (currentStep.value == 0) {
                                        //   currentStep.value = 1;
                                        // }
                                        if (currentStep.value == 0) {
                                          String? propertyId = profileController.myselectedListing.isNotEmpty
                                              ? profileController.myselectedListing[0]['_id']
                                              : '';

                                          // Check if the property ID is not empty
                                          if (propertyId!.isNotEmpty) {
                                            await controller.checkOffer(id: propertyId); // Check if the offer has been applied

                                            if (controller.offerApplied) {
                                              // If the offer is already applied, show a toast message
                                              Fluttertoast.showToast(msg: 'You have already created an offer on this property');
                                            } else {
                                              // If the offer is not applied, move to the next step
                                              currentStep.value = 1; // Move to the next step
                                            }
                                          }
                                        }

                                        else {
                                       //   if (FormKey.currentState!.validate() && controller.coverImgs.value != null) {
                                          if (FormKey.currentState!.validate()) {
                                          //  Navigator.pop(context); // closes the bottom sheet
                                          // if (context.mounted) {
                                          //  // Navigator.pop(context);
                                          // }

                                            if (isfrom == "edit") {
                                              if (context.mounted) {
                                                Navigator.pop(context);
                                              }

                                              await controller.UpdateOffer(
                                                name: controller.offerNameController.value.text,
                                                image: controller.coverImgs.value,
                                                property_id: profileController.myselectedListing.isNotEmpty
                                                    ? profileController.myselectedListing[0]['_id']
                                                    : '',
                                                time: "NA",
                                                des: controller.offerDescriptionController.value.text,
                                                id: id,
                                              );
                                              controller.getOffer(page: '1');
                                            }
                                            else {
                                              if( controller.coverImgs.value!=null){
                                                await controller.addOffer(
                                                  name: controller.offerNameController.value.text,
                                                  image: controller.coverImgs.value,
                                                  property_id:isfrom=="add" && propertyId!=""? widget.property['_id']:
                                                  profileController.myselectedListing.isNotEmpty
                                                      ? profileController.myselectedListing[0]['_id']
                                                      : '',
                                                  time: "NA",
                                                  des: controller.offerDescriptionController.value.text,
                                                );

                                                print("context.mounted");
                                                print(context.mounted);
                                                if (context.mounted && controller.isFailedTo.value!=true) {
                                                  await showCommonSinleButtonBottomSheet(
                                                    context: context,
                                                    title: "Offer Submitted",
                                                    message:
                                                    "Your offer has been posted successfully and sent for admin approval. "
                                                        "It will not be visible to others until it is approved by the admin team.",
                                                    messageTextStyle: const TextStyle(fontSize: 14, color: Colors.grey),
                                                    onYesPressed: () {
                                                      //controller.getOffer(page: '1');
                                                      getData();
                                                    },
                                                    // onNoPressed: () {
                                                    //   controller.getOffer(page: '1');
                                                    //    getData();
                                                    // },
                                                  );
                                                }

                                                await getData();

                                              }
                                              else{
                                                Fluttertoast.showToast(
                                                  msg: 'Please fill all required fields',
                                                );
                                              }

                                            }
                                          } else {

                                          }
                                        }
                                      }

                                  ),
                                ),
                              ],
                            )
                            // commonButton(
                            //   width: 150,
                            //   height: 50,
                            //   buttonColor: buttonColor,
                            //   text: currentStep.value == 0 ? "Next" : "Create Offer",
                            //   textStyle: const TextStyle(fontSize: 14, color: Colors.white),
                            //   onPressed: () async {
                            //     if (currentStep.value == 0) {
                            //       currentStep.value = 1;
                            //     } else {
                            //
                            //
                            //
                            //       if (FormKey.currentState!.validate() && controller.coverImgs.value!=null) {
                            //         Navigator.pop(context);
                            //
                            //         if(isfrom=="edit"){
                            //           controller.UpdateOffer(
                            //               name: controller.offerNameController.value.text,
                            //               image: controller.coverImgs.value,
                            //               property_id: profileController.myselectedListing.isNotEmpty?profileController.myselectedListing[0]['_id']:'',
                            //               time: controller.offerDurationController.text,
                            //               des: controller.offerDescriptionController.value.text, id:id
                            //           ).then((value) {
                            //             Navigator.pop(context);
                            //             controller.getOffer(page: '1');
                            //           });
                            //         }else{
                            //         await  controller.addOffer(
                            //               name: controller.offerNameController.value.text,
                            //               image: controller.coverImgs.value,
                            //               property_id: profileController.myselectedListing.isNotEmpty?profileController.myselectedListing[0]['_id']:'',
                            //               time: controller.offerDurationController.text,
                            //               des: controller.offerDescriptionController.value.text
                            //           ).then((value) {
                            //           showCommonBottomSheet(
                            //             context: context,
                            //             title: "Offer Not Approved",
                            //             message: "When they say there as no place like home, the adage rings true. Your home is a sanctuary whose walls are privy to every joyful moment. "
                            //                 "It is the hearth of your family and a distinct expression of your stature.",
                            //
                            //             messageTextStyle: const TextStyle(fontSize: 14, color: Colors.grey),
                            //             onYesPressed: () {
                            //               controller.getOffer(page: '1');
                            //             },
                            //             onNoPressed: () {
                            //               controller.getOffer(page: '1');
                            //             },
                            //           );
                            //         });
                            //
                            //
                            //         }
                            //
                            //
                            //
                            //       } else {
                            //         Fluttertoast.showToast(
                            //           msg: 'Please fill all required fields',
                            //         );
                            //       }
                            //
                            //     }
                            //   },
                            // ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
      },
    );
  }



}

// Add these methods to your class
 void _showStopReasonDialog(BuildContext context, Property property) {
  final reasonController = TextEditingController();
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Stop Property"),
      content: TextField(
        controller: reasonController,
        decoration: const InputDecoration(
          hintText: "Enter reason for stopping...",
          border: OutlineInputBorder(),
        ),
        maxLines: 3,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            // Update the property with stop reason
            property.stopReason = reasonController.text;
            // You would typically update the status here as well
            Navigator.pop(context);
          },
          child: const Text("Submit"),
        ),
      ],
    ),
  );
}

Future<bool> _showReasonDialog(BuildContext context,String reason) async {
  return await showModalBottomSheet<bool>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColor.grey[50],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Wrap(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 50,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Back button aligned to the start (left)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
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
                    ),

                    // Exit text centered
                    const Text(
                      'Offer Not Approved',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColor.black87,
                      ),
                    ),
                  ],
                ),
              ),

              boxH20(),
              Text(
                reason.toString(),
                style: TextStyle(
                  fontSize: 14,
                  color: AppColor.black.withOpacity(0.7),
                ),
                textAlign: TextAlign.justify,
              ),

              boxH30(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.lightPurple,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "OK",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              boxH05(),
            ],
          ),
        ],
      ),
    ),
  ) ??
      false;
}



