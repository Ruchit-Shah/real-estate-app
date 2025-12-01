import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common_widgets/height.dart';
import '../../../../global/AppBar.dart';
import '../../../../global/app_color.dart';
import '../../../../global/theme/app_text_style.dart';
import '../../../../utils/common_snackbar.dart';
import '../../../products_category/controller/category_controller.dart';
import '../../controller/all_products_controller.dart';
import 'add_product.dart';

class SelectCategory extends StatefulWidget {
  const SelectCategory({super.key});

  @override
  State<SelectCategory> createState() => _SelectCategoryState();
}

class _SelectCategoryState extends State<SelectCategory> {
  final categoryController = Get.find<CategoryController>();
  final allProductsController = Get.find<AllProductsController>();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    allProductsController.selectedCategoryId.value = "";
    allProductsController.selectedCategory.value = 0;
    categoryController.getCategoryApi(count: 10, pageNo: 1, isShowMore: false).whenComplete(() {
      if (categoryController.categories.isNotEmpty) {
        allProductsController.selectedCategoryId.value = categoryController.categories[0]["_id"];
        allProductsController.selectedCategory.value = 0;
      }
    });
    scrollController.addListener(() async {
      if (scrollController.position.maxScrollExtent == scrollController.position.pixels) {
        if (categoryController.currentCategoryPage.value != categoryController.lastCategoryPage.value) {
          categoryController.getCategoryApi(
              count: 10,
              pageNo: categoryController.nextCategoryPage.value,
              isShowMore: true);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(titleName: "Select Categories", actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: IconButton(
              onPressed: () {
                if (allProductsController.selectedCategoryId.value.isNotEmpty &&
                    allProductsController.selectedCategoryId.value.toString() == categoryController.categories[allProductsController.selectedCategory.value]["_id"].toString()) {
                  Get.to(() => AddProductScreen(categoryId: allProductsController.selectedCategoryId.value));
                } else {
                  showSnackbar(message: "Please select category again");
                }
              },
              icon: Text(
                "Next",
                style: AppTextStyle.semiBold.copyWith(color: AppColor.black),
              )),
        )
      ]),
      body: Column(
        children: [
          boxH10(),
          Expanded(
            child: Obx(() {
              return categoryController.categories.isEmpty || allProductsController.selectedCategory.value.isNegative
                  ? const SizedBox()
                  : ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      shrinkWrap: true,
                      itemCount: categoryController.categories.length,
                      itemBuilder: (context, index) {
                        var data = categoryController.categories[index];
                        return InkWell(
                          splashColor: AppColor.transparent,
                          hoverColor: AppColor.transparent,
                          onTap: () {
                            allProductsController.selectedCategory.value = index;
                            allProductsController.selectedCategoryId.value = "${data["_id"]}";
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 15),
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 15),
                            decoration: BoxDecoration(
                                color: allProductsController
                                            .selectedCategory.value ==
                                        index
                                    ? AppColor.blue.shade200
                                    : AppColor.grey.shade300,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(20))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    "${data["category_name"]}",
                                    textAlign: TextAlign.start,
                                    style: AppTextStyle.bold
                                        .copyWith(fontSize: 16),
                                  ),
                                ),
                                Icon(
                                  allProductsController
                                              .selectedCategory.value ==
                                          index
                                      ? Icons.check_circle_outlined
                                      : Icons.circle_outlined,
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
            }),
          ),
          Obx(() => categoryController.isMoreDataLoading.value == true
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : const SizedBox()),
        ],
      ),
    );
  }
}
