import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:real_estate_app/common_widgets/height.dart';
import 'package:real_estate_app/common_widgets/loading_dart.dart';
import 'package:real_estate_app/common_widgets/subscription_dialog.dart';
import 'package:real_estate_app/global/AppConfig.dart';
import 'package:real_estate_app/global/app_color.dart';
import 'package:real_estate_app/global/services/api_shorts_string.dart';
import 'package:real_estate_app/utils/String_constant.dart';
import 'package:real_estate_app/utils/common_snackbar.dart';
import 'package:real_estate_app/utils/shared_preferences/shared_preferances.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/CustomBottomNavBar.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/profile_screen/profile_controller.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/profile_screen/profile_screen.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/profile_screen/profile_section_screens/MyProjects/MyProjects.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/profile_screen/profile_section_screens/PlansAndSubscriptions/PlansAndSubscription.dart';
import 'package:real_estate_app/view/filter_search/view/FilterSearchController.dart';
import 'package:real_estate_app/view/filter_search/view/filter_search_screen.dart';
import 'package:real_estate_app/view/property_screens/filter/filtter_screen.dart';
import 'package:real_estate_app/view/property_screens/post_property_screen/NewChanges/edit_property_start_page.dart';
import 'package:real_estate_app/view/property_screens/post_property_screen/NewChanges/post_property_start_page.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:real_estate_app/view/property_screens/properties_controllers/post_property_controller.dart';
import 'package:real_estate_app/view/property_screens/recommended_properties_screen/properties_details_screen.dart';

import '../../../../../../global/api_string.dart';
import '../MyOffers/OffersProperties.dart';

class MyProperties extends StatefulWidget {
  final String? isFrom;
  const MyProperties({super.key,this.isFrom});

  @override
  State<MyProperties> createState() => _MyPropertiesState();
}

class _MyPropertiesState extends State<MyProperties> {
  final FocusNode _focusNode = FocusNode();

  final ProfileController controller = Get.find();
  final PostPropertyController _postPropertyController = Get.find();
  FilterSearchController _filterSearchController = Get.find();
  String  isOffer='';
  @override
  void initState() {
    super.initState();

    controller.searchController.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getDataOffer("",'',null);
      if(widget.isFrom=="my_leads"){
        print("widget.isFrom--");
        print(widget.isFrom);
        filtterData();
      }else{
        controller.getMyListingProperties(page: '1');
        getClear();
      }

    });
    controller.scrollController.addListener(() {
      if (controller.scrollController.position.pixels >=
          controller.scrollController.position.maxScrollExtent - 100 &&
          !controller.isPaginationLoading.value &&
          controller.hasMore.value) {
        loadMoreData();
      }
    });
    setState(() {

    });
  }

  getClear()  {
    _filterSearchController.ClearData();
    _filterSearchController.selectedFurnishingStatusList.clear();
    _filterSearchController.isClear.value =true;

    // pController.profileController.myListingPrperties.clear();
    // pController.getCommonPropertyList.clear();
    // controller.budgetMin.value = 5;
    // controller.budgetMax.value = 10;
    _filterSearchController.budgetMin.value = null;
    _filterSearchController.budgetMax.value = null;

    _filterSearchController.budgetMin1.value = "";
    _filterSearchController.budgetMax1.value = "";

    // await pController.getMySearchProperty(
    //   searchKeyword: widget.search_key,
    //   city: '',
    //   locality: '',
    //   max_price:controller.budgetMax1.value!=""?"${controller.budgetMax.value.toString()}00000":
    //   controller.budgetMax1.value.toString(),
    //   min_price:controller.budgetMin1.value.toString() ,
    //   showFatured: widget.isFrom =='profile' || widget.isFrom=='my_leads' ? 'false': 'true',
    //   property_type:controller.selectedPropertyType.join('|') ,
    //   isFrom: widget.isFrom=="my_leads"?"profile":widget.isFrom,
    //   furnishtype: controller.selectedFurnishingStatusList.join('|'),
    //   bhktype: controller.selectedBHKTypeList.join('|'),
    //
    // );
  }
  //@override
  // void dispose() {
  //   controller.scrollController.dispose(); // if created in the widget
  //   super.dispose();
  // }
  getDataOffer(String? isfrom,String? id,var property) async {
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

        if(isfrom=="plan"){
           // Get.to( OffersProperties(isfrom: 'my_property', id: id,property: property,));
          if ( id!.isNotEmpty) {
            await _postPropertyController.checkOffer(id:  id);

            if (_postPropertyController.offerApplied) {

              Fluttertoast.showToast(msg: 'You have already created an offer on this property');
            } else {
              Get.to( OffersProperties(isfrom: 'my_property', id: id,property: property,));
            }
          }

        }

      }else {
        setState(() {
          isOffer ='no_limit';
        });
      }
    }
    ///



  }

  void filtterData() async{
    await _postPropertyController.getMySearchProperty(
      searchKeyword: "",
      city: '',
      locality: '',
      max_price:_filterSearchController.budgetMax1.value!=""?"${_filterSearchController.budgetMax1.value.toString()}":
      _filterSearchController.budgetMax1.value.toString(),
      min_price:_filterSearchController.budgetMin1.value.toString() ,
      showFatured:  'false',
      property_type:_filterSearchController.selectedPropertyType.join('|') ,
      isFrom: "profile",
      furnishtype: _filterSearchController.selectedFurnishingStatusList.join('|'),
      bhktype: _filterSearchController.selectedBHKTypeList.join('|'),


    );
  }

  void loadMoreData() {
    if (controller.hasMore.value && !controller.isPaginationLoading.value) {
      controller.isPaginationLoading.value = true;

      final nextPage = (controller.currentPage.value + 1).toString();

      if (controller.searchController.text.trim().isNotEmpty) {
        controller.getMySearchProperties(searchKeyword:controller.searchController.text.trim()
            ,city: '',
            locality: '',
            max_price:_filterSearchController.budgetMax1.value!=""?"${_filterSearchController.budgetMax.value.toString()}00000":
            _filterSearchController.budgetMax1.value.toString(),
            min_price:_filterSearchController.budgetMin1.value.toString(),
            showFatured: 'false',
            property_type:_filterSearchController.selectedPropertyType.join('|'));
      } else {
        controller.getMyListingProperties(page: nextPage);
      }
    }
  }
  void onSearchChanged(String value) {
    controller.currentPage.value = 1;
    controller.hasMore.value = true;
    if (value.trim().isEmpty) {
      controller.getMyListingProperties(page: '1');
    } else {
      controller.getMySearchProperties(searchKeyword: value.trim()
          ,city: '',
          locality: '',
          max_price:_filterSearchController.budgetMax1.value!=""?"${_filterSearchController.budgetMax1.value.toString()}":
          _filterSearchController.budgetMax1.value.toString(),
          min_price:_filterSearchController.budgetMin1.value.toString() ,
          showFatured: 'false',
          property_type:_filterSearchController.selectedPropertyType.join('|'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        if(widget.isFrom == 'post') {
          Get.to(() => ProfileScreen());
          return false;
        }else {
          Get.back();
          return false;
        }
      },
      child:

      Scaffold(
          backgroundColor: Colors.grey.shade100,
          appBar: AppBar(
            centerTitle: true,
            title: const Text("My Properties",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                )),
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
                  //   if(widget.isFrom == 'post') {
                  //     Get.to(() => ProfileScreen());
                  //   }else{
                  //
                  //   }
                  //   Get.back();
                  // },
                    onTap: () {
                      if (widget.isFrom == 'post') {
                        Get.off(() => ProfileScreen()); // Replace current screen
                      } else {
                        Get.back(); // Go back normally
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
                      width: 0.1, // Border width
                    ),
                  ),
                  child: InkWell(
                    onTap: () {
                      Get.to( FilterScreen(search_key: controller.searchController.text, isFrom: 'profile',));
                    },
                    borderRadius: BorderRadius.circular(50),
                    child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Image.asset(
                          "assets/image_rent/filter.png",
                          height: 10,
                          width: 12,
                        )),
                  ),
                ),
              )
            ],
          ),
          body:  Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      height: 50,
                      child: TextField(
                        focusNode: _focusNode,
                        controller: controller.searchController,
                        onSubmitted: (value) {
                          onSearchChanged(value);
                        },
                        decoration: InputDecoration(
                          hintText: "Type a city or property to explore",
                          hintStyle: const TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.normal),
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
                              vertical: 12.0, horizontal: 16.0),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Obx(() {
                      if (controller.myListingPrperties.isEmpty &&
                          controller.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (controller.myListingPrperties.isEmpty) {
                        return const Center(
                          child: Text(
                            "No Data Available",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        );
                      }

                      return RefreshIndicator(
                        onRefresh: () async {
                          controller.getMyListingProperties(page: '1');
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 60), // Prevent content under bottom bar
                          child: LazyLoadScrollView(
                            onEndOfPage: () {
                              if (controller.hasMore.value &&
                                  !controller.isPaginationLoading.value) {
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
                              controller: controller.scrollController,
                              itemCount: controller.myListingPrperties.length +
                                  (controller.isPaginationLoading.value ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index == controller.myListingPrperties.length) {
                                  return const Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Center(child: CircularProgressIndicator()),
                                  );
                                }
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 2),
                                  child: propertyCard(
                                      controller.myListingPrperties[index], index),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
              widget.isFrom!="my_leads"?
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.to(const start_page(isFrom: 'myproperties'));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF52C672),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        "Post New Property",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ):SizedBox()
            ],

          ),



      ),
    );
  }

  Widget propertyCard(var property,int index){
    return Container(
      width:Get.width,
      height: Get.height * 0.60,
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
                      horizontal: 10, vertical: 2),
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
                   formatDate(property['property_added_date']), //   format : 23  april 2025
                  style: const TextStyle(
                      color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Image and property details
            GestureDetector(
              onTap: () => Get.to(PropertyDetailsScreen(
                id: property['_id'],
              )),
              child: Row(
                children: [
                  // Property Image
                  Stack(
                      children: [
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
                        Positioned(
                          left: 0,
                          top: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 4),
                            decoration: BoxDecoration(
                              color:property['property_category_type'].toString() =="Rent"?
                              AppColor.primaryThemeColor:AppColor.green,
                              borderRadius:
                              BorderRadius.circular(6),
                            ),
                            child:  Text(

                              "FOR ${ property['property_category_type'] == "Buy"
                                  ? "SELL"
                                  : property['property_category_type'].toString().toUpperCase()}",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ]),
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
                          property['property_name'],
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        // Text(
                        //   Text(
                        //                             //'${controller.getCommonPropertyList[index]['address']}',
                        //                             widget.property_data['address_area'] ?? widget.property_data['address'],
                        //                             maxLines: 1,
                        //                             // maxLines: 3,
                        //                             overflow: TextOverflow.ellipsis,
                        //                             style: const TextStyle(
                        //                               fontFamily: "Muli",
                        //                             ),
                        //                           ),['address'],
                        //   style: const TextStyle(
                        //       color: Colors.grey, fontSize: 14,overflow: TextOverflow.ellipsis),
                        // ),
                        Text(
                          //'${controller.getCommonPropertyList[index]['address']}',
                          property['address_area'] ?? property['address'],
                          maxLines: 1,
                          // maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: "Muli",
                          ),
                        ),
                        Row(

                          children: [
                            Text(
                              property['property_type'],
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 14,overflow: TextOverflow.ellipsis),
                            ),
                            const SizedBox(width: 10,),

                          ],
                        ),
                        property['bhk_type']!=""?
                        Text(
                          property['bhk_type'],

                          style: const TextStyle(
                              color: Colors.grey, fontSize: 14,overflow: TextOverflow.ellipsis),
                        ):const SizedBox(), const SizedBox(width: 5,),

                        property['furnished_type']!=""?
                        Text(
                          property['furnished_type'],
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 14,overflow: TextOverflow.ellipsis),
                        ):const SizedBox(),
                        boxH05(),
                        property['property_category_type']=="Rent"?
                        Text(

                          '${_postPropertyController.formatIndianPrice(property['rent'].toString())}/Month',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                            :
                        Text(
                          _postPropertyController.formatIndianPrice(property['property_price'].toString()),
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
            boxH20(),
            // Views and Leads
            Container(
              padding:
              const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Views",
                          style:
                          TextStyle(color: Colors.grey)),
                      const SizedBox(height: 5),
                      Text(
                        int.tryParse(property['view_count']?.toString() ?? '')?.toString() ?? '0',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )

                    ],
                  ),
                 const SizedBox(width: 100,),
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
            boxH20(),
            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  height: 50,
                  child: OutlinedButton(
                    onPressed: () async {
                      var result = await Get.to(() => edit_property_start_page(
                        isfrom: 'property',
                        data: property,
                        index: index,
                      ));

                      // if (result != null && result['property_id'] != null && result['index'] != null) {
                      //   int updatedIndex = result['index'];
                      //   String updatedPropertyId = result['property_id'];
                      //   int pageNumber = (updatedIndex ~/ 4) + 1;
                      //   await controller.getMyListingProperties(page: pageNumber.toString());
                      //   var updatedProperty = controller.myListingPrperties.firstWhere(
                      //         (prop) => prop.id == updatedPropertyId,
                      //     orElse: () => null,
                      //   );
                      //   if (updatedProperty != null) {
                      //     controller.myListingPrperties[updatedIndex] = updatedProperty;
                      //    // controller.myListingPrperties.refresh();
                      //   }
                      //
                      // }
                    },

                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: AppColor.primaryThemeColor, width: 0.8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Edit Property",
                      style: TextStyle(
                        color: AppColor.primaryThemeColor,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {

                      if(  property['available_status']=="Available"){
                        showCommonBottomSheet(

                          context: context,
                          title: "Sold Property",
                          message: "Are you sure your property is Sold?",
                          onYesPressed: () {

                            controller.changePropertyStatus(id: property['_id'],available_status:'Sold' );

                            print("Project deleted");
                          },
                          onNoPressed: () {
                            // Handle cancel action
                            print("Deletion cancelled");
                          },
                        );
                      }else{
                        showCommonBottomSheet(

                          context: context,
                          title: "Available Property",
                          message: "Are you sure your property is available ?",
                          onYesPressed: () {
                            controller.changePropertyStatus(id: property['_id'],available_status:'Available' );
                            //  controller.changePropertyStatus(id: property['_id'],available_status:'Sold' );

                            print("Project deleted");
                          },
                          onNoPressed: () {
                            // Handle cancel action
                            print("Deletion cancelled");
                          },
                        );

                      }


                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      property['available_status']=="Available"?
                          Colors.green:
                      Colors.grey[300],
                      shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(8)),
                    ),
                    child:  Text(
                        property['available_status']=="Available"?
                        property['property_category_type'].toString() =="Rent"?
                            "Rented Out": "Sold Out":"Available",
                        style: TextStyle(
                            color:
                            property['available_status']=="Available"?
                            Colors.white:
                            Colors.black45,
                            fontSize: 15)),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      showCommonBottomSheet(
                        context: context,
                        title: "Delete Property",
                        message: "Are you sure you want to delete this property?",
                        onYesPressed: () {
                          controller.deleteMyListing(id: property['_id']);
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
            boxH30(),

            // Promote Button
            SizedBox(
              width: Get.width,
              child:
              commonButton(text: "Promote This Property",
                onPressed: () async {
                if( isOffer !='yes'){
                  SubscriptionDialog.show(
                    context: context,
                    onPurchase: () {
                      // Handle purchase flow
                      Navigator.push(context, MaterialPageRoute(
                          builder: (_) => const PlansAndSubscription(isfrom: 'offer',)
                      )).then((value) async =>{
                     await   getDataOffer("plan", property['_id'], property),
                      });
                    },
                    type: 'offer',
                  );
                }else{

                  if ( property['_id']!.isNotEmpty) {
                    await _postPropertyController.checkOffer(id:  property['_id']);

                    if (_postPropertyController.offerApplied) {

                      Fluttertoast.showToast(msg: 'You have already created an offer on this property');
                    } else {
                      Get.to( OffersProperties(isfrom: 'my_property', id:  property['_id'],property: property,));
                    }
                  }

                }



              },
                buttonColor: AppColor.primaryThemeColor,

              )
            ),
          ],
        ),
      ),
    );
  }
  DateTime parseDate(String dateString) {
    try {
      ///
      try {
        return DateFormat('dd/MM/yyyy').parse(dateString);
      } catch (e) {
        return DateTime.parse(dateString);
      }
    } catch (e) {
      throw FormatException("Invalid date format: $dateString");
    }
  }
  String formatDate(String dateString) {
    DateTime date = parseDate(dateString);
    return DateFormat('d MMMM y').format(date);
  }
}
