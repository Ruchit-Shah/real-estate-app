import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/common_widgets/height.dart';
import 'package:real_estate_app/common_widgets/loading_dart.dart';
import 'package:real_estate_app/global/app_color.dart';
import 'package:real_estate_app/global/constant.dart';
import 'package:real_estate_app/view/filter_search/view/FilterSearchController.dart';
import '../../dashboard/bottom_navbar_screens/profile_screen/profile_controller.dart';
import '../../dashboard/bottom_navbar_screens/profile_screen/profile_section_screens/My Properties/MyProperties.dart';
import '../../property_screens/properties_controllers/post_property_controller.dart';

class FilterScreen extends StatefulWidget {
  final String search_key;
  final String isFrom;
  const FilterScreen({super.key,required this.search_key,required this.isFrom});

  @override
  State<FilterScreen> createState() => _FilterSearchScreenState();
}

class _FilterSearchScreenState extends State<FilterScreen> {

  FilterSearchController controller = Get.find();

  final ProfileController Proficontroller = Get.find();
  final PostPropertyController pController = Get.find();
  TextEditingController _Controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.searchController = TextEditingController();
      controller.isLoading.value = false;

      pController.profileController.total_count.value=0;
      pController.total_count.value=0;


      controller.isFetchingLocation.value = false;
      pController.bhkTypes.assignAll([
        "Studio", "1 RK", "1 BHK", "1.5 BHK", "2 BHK", "2.5 BHK",
        "3 BHK", "3.5 BHK", "4 BHK", "5 BHK", "6+ BHK",
      ]);
      pController.getAmenities();

    });

  }



  @override
  void dispose() {
    _Controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  bool isLoading = false;
  bool isFetchingLocation = false;

void filtterData() async{
  await pController.getMySearchProperty(
    searchKeyword: widget.search_key,
    city: '',
   locality: '',
    max_price:controller.budgetMax1.value!=""?"${controller.budgetMax.value.toString()}00000":
    controller.budgetMax1.value.toString(),
    min_price:controller.budgetMin1.value.toString() ,
  //  showFatured: widget.isFrom =='profile' || widget.isFrom=='my_leads' ? 'false': 'true',
    showFatured: widget.isFrom =='featured'  ? 'true': 'false',
      property_type:controller.selectedPropertyType.join('|') ,
    isFrom: widget.isFrom=="my_leads"?"profile":widget.isFrom,
    furnishtype: controller.selectedFurnishingStatusList.join('|'),
      bhktype: controller.selectedBHKTypeList.join('|'),

  );
  setState(() {
    controller.getMarkers(pController.getCommonPropertyList).then((loadedMarkers) {
      setState(() {
        _focusNode.unfocus();
        controller.markers = loadedMarkers;
      });
    });
  });
  controller.isClear.value=false;
}

  @override
  Widget build(BuildContext context)  {
    return Scaffold(
      bottomNavigationBar: continueButtons(context),
      appBar:AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            customIconButton(
              icon: Icons.arrow_back,
              onTap: () {

                controller.ClearData();
                controller.selectedFurnishingStatusList.clear();
                controller.isClear.value =true;

                // pController.profileController.myListingPrperties.clear();
                // pController.getCommonPropertyList.clear();
                // controller.budgetMin.value = 5;
                // controller.budgetMax.value = 10;
                controller.budgetMin.value = null;
                controller.budgetMax.value = null;

                controller.budgetMin1.value = "";
                controller.budgetMax1.value = "";


                if(widget.isFrom=="profile"){

                  Proficontroller.getMyListingProperties(page: '1');

                }else{

                  if( widget.search_key.isNotEmpty || widget.search_key!=""){
                    pController.getMySearchProperty(searchKeyword:widget.search_key,showFatured:  widget.isFrom =='featured'  ? 'true': 'false',page: '1');
                  }else{
                    if (widget.isFrom == "featured") {
                      pController.getFeaturedProperty(page: '1');
                    } else {
                      pController.getRecommendedProperty(page: '1');
                    }
                  }
                }


                setState(() {
                  controller.getMarkers(pController.getCommonPropertyList).then((loadedMarkers) {
                    setState(() {
                      _focusNode.unfocus();

                      controller.markers = loadedMarkers;
                    });
                  });
                });


                Navigator.pop(context);
              },
            ),
            const Text("Filter",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
            GestureDetector(
              onTap: () async {

                controller.ClearData();
                controller.selectedFurnishingStatusList.clear();
                controller.isClear.value =true;

                // pController.profileController.myListingPrperties.clear();
                // pController.getCommonPropertyList.clear();
                // controller.budgetMin.value = 5;
                // controller.budgetMax.value = 10;
                controller.budgetMin.value = null;
                controller.budgetMax.value = null;

                controller.budgetMin1.value = "";
                controller.budgetMax1.value = "";

                if(widget.isFrom=="profile"){

                  Proficontroller.getMyListingProperties(page: '1');

                }else{
                  if (widget.isFrom == "featured") {

                    pController.getFeaturedProperty(page: '1');
                  } else {

                    pController.getRecommendedProperty(page: '1');
                  }
                }

                // filtterData();
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
                  padding: EdgeInsets.all(8.0),
                  child: Text("Clear All",style: TextStyle(color: Colors.black,fontSize: 13),),

                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Obx(() {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  propertyType,
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.black.withOpacity(0.7),
                      fontWeight: FontWeight.normal),
                ),
                const SizedBox(height: 8.0),
                Wrap(
                  children: pController.filterpropertyTypes
                      .map((propertyType) =>
                      PropertyType(propertyType))
                      .toList(),
                ),
                const Divider(thickness: 1.0),


                Text(
                  "Select BHK",
                  style: TextStyle(
                      fontSize: 15,
                      color: AppColor.black.withOpacity(0.7),
                      fontWeight: FontWeight.normal),
                ),
                const SizedBox(height: 8.0),
                Wrap(
                  children:
                  pController.bhkTypes.map((bhk) => bhkOption(bhk)).toList(),
                ),
                const Divider(thickness: 1.0),


                Text(
                  rbudget,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: AppColor.black.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.grey.shade300, width: 1.0),
                        ),
                        child:DropdownButton<int>(
                          value: controller.budgetMin.value,
                          hint: const Text("Min Budget"),
                          items: controller.budgetOptions.map((option) {
                            final max = controller.budgetMax.value;
                            final isEnabled = max == null || option['value'] < max;
                            return DropdownMenuItem<int>(
                              value: option['value'],
                              enabled: isEnabled,
                              child: Text(
                                option['label'],
                                style: TextStyle(color: isEnabled ? Colors.black : Colors.grey),
                              ),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            if (newValue != null &&
                                (controller.budgetMax.value == null || newValue < controller.budgetMax.value!)) {
                              controller.budgetMin.value = newValue;
                              final selected = controller.budgetOptions.firstWhere((e) => e['value'] == newValue);
                              controller.budgetMin1.value = convertLabelToNumberString(selected['label']);
                              filtterData();
                            }
                          },
                          isExpanded: true,
                          underline: const SizedBox(),
                        ),



                        // DropdownButton<int>(
                        //   value: controller.budgetMin.value,
                        //   items: controller.budgetOptions.map((option) {
                        //     return DropdownMenuItem<int>(
                        //       value: option['value'],
                        //       child: Text(option['label']),
                        //     );
                        //   }).toList(),
                        //   onChanged: (newValue) {
                        //     if (newValue != null && newValue <= controller.budgetMax.value) {
                        //       controller.budgetMin.value = newValue;
                        //       final selectedOption = controller.budgetOptions.firstWhere((e) => e['value'] == newValue);
                        //       controller.budgetMin1.value = convertLabelToNumberString(selectedOption['label']);
                        //       filtterData();
                        //     }
                        //   },
                        //   hint: const Text("Min Budget"),
                        //   isExpanded: true,
                        //   style: const TextStyle(color: Colors.black, fontSize: 14),
                        //   underline: const SizedBox(),
                        // ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.grey.shade300, width: 1.0),
                        ),
                        child:DropdownButton<int>(
                          value: controller.budgetMax.value,
                          hint: const Text("Max Budget"),
                          items: controller.budgetOptions.map((option) {
                            final min = controller.budgetMin.value;
                            final isEnabled = min == null || option['value'] > min;
                            return DropdownMenuItem<int>(
                              value: option['value'],
                              enabled: isEnabled,
                              child: Text(
                                option['label'],
                                style: TextStyle(color: isEnabled ? Colors.black : Colors.grey),
                              ),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            if (newValue != null &&
                                (controller.budgetMin.value == null || newValue > controller.budgetMin.value!)) {
                              controller.budgetMax.value = newValue;
                              final selected = controller.budgetOptions.firstWhere((e) => e['value'] == newValue);
                              controller.budgetMax1.value = convertLabelToNumberString(selected['label']);
                              filtterData();
                            }
                          },
                          isExpanded: true,
                          underline: const SizedBox(),
                        ),

                      ),
                    ),
                  ],
                ),



                const Divider(thickness: 1.0),

                boxH05(),

                Text(

                  "Select Furnishing ",
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.black.withOpacity(0.7),
                      fontWeight: FontWeight.normal),
                ),

                boxH05(),

                Wrap(
                  spacing: 8,
                  children: pController.furnishTypes.map((furnishType) {
                    return ChoiceChip(
                      label: Text(furnishType),
                      labelStyle: TextStyle(
                        color: controller.selectedFurnishingStatusList.contains(furnishType)
                            ? AppColor.primaryThemeColor
                            : Colors.black.withOpacity(0.7),
                      ),
                      selected: controller.selectedFurnishingStatusList.contains(furnishType),
                      selectedColor:AppColor.primaryThemeColor.withOpacity(0.2),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            controller.selectedFurnishingStatusList.add(furnishType);
                            controller.ClearData();
                            filtterData();
                          } else {
                            controller.selectedFurnishingStatusList.remove(furnishType);
                            controller.ClearData();
                            filtterData();
                          }

                        });
                      },
                      showCheckmark: false,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), // Circular corners
                      ),
                      side: BorderSide(
                        color: controller.selectedFurnishingStatusList.contains(furnishType)
                            ? Colors.white
                            : Colors.grey.withOpacity(0.3),
                        width: 0.8,
                      ),
                    );
                  }).toList(),
                ),
                //    Divider()
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget continueButtons(BuildContext context) {
    return Container(
      decoration: BoxDecoration(

        border: Border.all(
          color:
          Colors.grey.shade300,
        ),
        borderRadius: BorderRadius.circular(0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // To space the buttons evenly
          children: [

            pController.isLoading.value ? const CircularProgressIndicator() :
            Text(
            controller.isClear.value==false?
              widget.isFrom == 'profile'  || widget.isFrom=='my_leads'?
              "${pController.profileController.total_count.toString()} Properties"
                  : "${pController.total_count.toString()} Properties":"0 Property",style: const TextStyle(
                color: AppColor.black,fontSize: 18,fontWeight: FontWeight.bold
            ),),

            // Search Button
            SizedBox(
                width: 150,
                height: 50,
                child:commonButton(
                  text: "Filter",
                  onPressed: () {
                    final filters = {
                      'property_type': controller.selectedPropertyType,
                      'bhk_type': controller.selectedBHKTypeList,
                     // 'price_range': {'min': controller.budgetMin1.value, 'max': controller.budgetMax1.value},
                      'price_range': {
                        'min': int.tryParse(controller.budgetMin1.value),
                        'max': int.tryParse(controller.budgetMax1.value),
                      },

                      'furnished_type':controller.selectedFurnishingStatusList
                    };
                    // Safely cast List<dynamic> to List<Map<String, dynamic>>
                    final propertyList = pController.getCommonPropertyList.value
                        .map((item) => item as Map<String, dynamic>)
                        .toList();

                   final result =  pController.filterProperties(propertyList, filters);

                    print("property count before filter : ${pController.getCommonPropertyList.length}");
                    print("selected filters : $filters");
                    print("property count after filter : ${result.length}");
                    print("result : $result");
                   if(widget.isFrom=="my_leads"){



                     Get.to(const MyProperties(isFrom:"my_leads" ,));
                   }else{
                     Get.back();
                   }

                  },
                )

            ),
          ],
        )),
      ),
    );
  }
  String convertLabelToNumberString(String label) {
    final cleanedLabel = label.replaceAll('₹', '').trim().toLowerCase();

    if (cleanedLabel.contains('lakh')) {
      final number = double.parse(cleanedLabel.split('lakh')[0].trim());
      return (number * 100000).toInt().toString();
    } else if (cleanedLabel.contains('crore')) {
      final number = double.parse(cleanedLabel.split('crore')[0].trim());
      return (number * 10000000).toInt().toString();
    } else {
      return '0'; // fallback if format not matched
    }
  }



  Widget bhkOption(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Obx(() => ChoiceChip(
        label: Text(text),
        labelStyle: TextStyle(
          color: controller.selectedBHKTypeList.contains(text)
              ? AppColor.primaryThemeColor
              : Colors.black.withOpacity(0.7),
        ),
        selected: controller.BHKType.value == text ||
            controller.selectedBHKTypeList.contains(text),
        onSelected: (isSelected) {
          if (isSelected) {
            if (text == controller.BHKType.value) {
              return;
            }
            controller.selectedBHKTypeList.add(text);
          } else {
            controller.selectedBHKTypeList.remove(text);
            if (controller.BHKType.value == text) {
              controller.BHKType.value = "";
            }
          }
          filtterData();
        },
        showCheckmark: false,
        side: BorderSide(
            color: controller.selectedBHKTypeList.contains(text)
                ? Colors.white
                : Colors.grey.withOpacity(0.3),
            width: 0.8),
        selectedColor: AppColor.primaryThemeColor.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // Circular corners
        ),

      )),
    );
  }

  Widget categoryType(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Obx(() => ChoiceChip(
        label: Text(text),
        selected: controller.selectedLocation.value == text ||
            controller.lookingFor.contains(text),
        onSelected: (isSelected) {
          if (isSelected) {
            if (text == controller.selectedLocation.value) {
              return;
            }
            controller.lookingFor.add(text);
          } else {
            controller.lookingFor.remove(text);
            if (controller.selectedLocation.value == text) {
              controller.selectedLocation.value = "";
            }
          }
        },
        labelStyle: TextStyle(
          color: controller.selectedLocation.value == text
              ? AppColor.blue
              : Colors.black.withOpacity(0.7),
        ),
        selectedColor: Colors.blue.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
              color: controller.selectedLocation.value == text
                  ? AppColor.blue
                  : Colors.grey.withOpacity(0.3),
              width: 0.8),
        ),
      )),
    );
  }

  Widget amenitiesType(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Obx(() => ChoiceChip(
        label: Text(text),
        labelStyle: TextStyle(
          color: controller.selectedLocation.value == text
              ? AppColor.blue
              : Colors.black.withOpacity(0.7),
        ),
        selected: controller.selectAmenities.contains(text),
        onSelected: (isSelected) {
          if (isSelected) {
            controller.selectAmenities.add(text);
          } else {
            controller.selectAmenities.remove(text);
          }
        },
        selectedColor: Colors.blue.withOpacity(0.3),
        side: BorderSide(
            color: controller.selectedLocation.value == text
                ? AppColor.blue
                : Colors.grey.withOpacity(0.3),
            width: 0.8),
      )),
    );
  }

  Widget PropertyType(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Obx(() => ChoiceChip(
        label: Text(text

        ),
        labelStyle: TextStyle(
          color:controller.selectedPropertyType.contains(text)
              ? AppColor.primaryThemeColor
              : Colors.black.withOpacity(0.7),
        ),
        selected: controller.selectedPropertyType.contains(text),
        onSelected: (isSelected) {
          if (isSelected) {
            controller.selectedPropertyType.add(text);

          } else {
            controller.selectedPropertyType.remove(text);
          }
          filtterData();
        },
        selectedColor: AppColor.primaryThemeColor.withOpacity(0.3),
        showCheckmark: false,

        side: BorderSide(
            color: controller.selectedPropertyType.contains(text)
                ? Colors.white
                : Colors.grey.withOpacity(0.3),
            width: 0.8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // Circular corners
        ),
      )

      ),
    );
  }

}
