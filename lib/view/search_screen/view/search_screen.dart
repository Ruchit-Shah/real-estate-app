// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common_widgets/height.dart';
import '../../../global/widgets/common_textfield.dart';
import '../../../global/widgets/user_list_tile.dart';
import '../../shorts/controller/my_profile_controller.dart';
import '../../shorts/view/user_profile.dart';
import '../controller/search_screen_controller.dart';

class SearchScreen extends GetWidget<SearchScreenController> {
  const SearchScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              boxH05(),
              CommonTextField(
                hintText: "Search account, name...",
                onTap: () {
                  // Get.to(()=>SignupScreen());
                },
                onChange: controller.onSearchTextChanged,
              ),
              boxH10(),
              Expanded(
                  child: Obx(() =>
                  controller.searchResponse.isEmpty || controller.searchDataList.isEmpty
                      ? const Center(child: Text('No Search Results Found'))
                      : SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          // height: MediaQuery.of(context).size.height * 0.75,
                          child: Scrollbar(
                            controller: controller.scrollController,
                            thickness: 10,
                            thumbVisibility: true,
                            trackVisibility: true,
                            child: ListView.builder(
                              controller: controller.scrollController,
                              shrinkWrap: true,
                              itemCount: controller.searchDataList.length,
                              itemBuilder: (context, i) {
                                var data = controller.searchDataList[i];
                                //print('data: userid $data');
                                var isCurrentUserId = Get.find<MyProfileController>().userId.value;
                                print('isCurrentUserId $isCurrentUserId');
                                  return userListTile(
                                  data: data,
                                  onTap: () {
                                  if(data != null) {
                                    Get.to(()=>UserProfileScreen(userData: data));
                                  }
                                  },
                               );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        controller.currentPage.toString() == controller.lastPage.toString()
                            ? const SizedBox()
                            : controller.isApiCallProcessing.value == true
                            ? const Text("Please wait while loading")
                            : InkWell(
                            onTap: () {
                              controller.searchDataApi(
                                  isShowMoreCall: true,
                                  keyword: controller.searchController.value.text,
                                  pageNumber: controller.nextPage.value);
                            },
                            child: const Text("Show More")),
                        const SizedBox(height: 40)
                      ],
                    ),
                  ))
              ),
            ],
          ),
        ),
      ),
    );
  }

}
