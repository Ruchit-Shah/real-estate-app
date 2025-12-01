
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/global/widgets/common_textfield.dart';

import '../../../common_widgets/height.dart';
import '../../../global/AppBar.dart';
import '../../../global/app_color.dart';
import '../../../global/theme/app_text_style.dart';
import '../../../utils/common_snackbar.dart';
import '../controller/category_controller.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final categoryController = Get.find<CategoryController>();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    categoryController.getCategoryApi(count: 10, pageNo: 1, isShowMore: false);
    scrollController.addListener(()  {
      if (scrollController.position.maxScrollExtent == scrollController.position.pixels) {
        print("called twice =========  maxScrollExtent ${scrollController.position.maxScrollExtent}");
        print("called twice =========  position${scrollController.position.pixels}");

        if (categoryController.currentCategoryPage.value != categoryController.lastCategoryPage.value) {
          print("called twice =========");
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
      appBar: appBar(titleName: "Categories", actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: IconButton(
              onPressed: () {
                categoryCrud();
              },
              icon: const Icon(
                Icons.add_circle,
                color: AppColor.black,
                size: 30,
              )),
        )
      ]),
      body: Column(
        children: [
          boxH10(),
          Expanded(
            child: Obx(() {
              return categoryController.categories.isEmpty
                  ? const SizedBox()
                  : ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                shrinkWrap: true,
                itemCount: categoryController.categories.length,
                itemBuilder: (context, index) {
                  var data = categoryController.categories[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    decoration: BoxDecoration(
                        color: AppColor.grey.shade300,
                        borderRadius:
                        const BorderRadius.all(Radius.circular(20))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "${data["category_name"]}",
                            textAlign: TextAlign.start,
                            style:
                            AppTextStyle.bold.copyWith(fontSize: 16),
                          ),
                        ),
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                                onPressed: () {
                                  categoryCrud(
                                      isEdit: true,
                                      categoryId: "${data["_id"]}",
                                      categoryName:
                                      "${data["category_name"]}");
                                },
                                icon: const Icon(
                                  Icons.edit,
                                  color: AppColor.blue,
                                )),
                            IconButton(
                                onPressed: () {
                                  categoryCrud(
                                      isDelete: true,
                                      categoryId: "${data["_id"]}",
                                      categoryName:
                                      "${data["category_name"]}");
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: AppColor.red,
                                )),
                          ],
                        )
                      ],
                    ),
                  );
                },
              );
            }),
          ),
          Obx(() => categoryController.isMoreDataLoading.value == true ?const Center(child: CircularProgressIndicator(),):const SizedBox()),
        ],
      ),
    );
  }

  Future<dynamic> categoryCrud(
      {bool isEdit = false,
        bool isDelete = false,
        String? categoryId,
        String? categoryName}) {
    if (isEdit == true) {
      categoryController.categoryNameController.text = categoryName!;
    }
    return Get.dialog(
      Material(
        color: AppColor.transparent,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Container(
            height: 190,
            width: Get.width * 0.92,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: AppColor.grey.shade300,
                borderRadius: const BorderRadius.all(Radius.circular(15))),
            child: isDelete == false
                ? Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                    isEdit == false
                        ? "Add Category"
                        : "Update Category Name",
                    style: AppTextStyle.bold.copyWith(fontSize: 20)),
                boxH15(),
                CommonTextField(
                  controller: categoryController.categoryNameController,
                  hintText: "Category Name",
                ),
                boxH20(),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: SizedBox(),),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          if (categoryController.categoryNameController
                              .text.removeAllWhitespace.isNotEmpty) {
                            isEdit == false
                                ? categoryController.addCategoryApi(
                                categoryName: categoryController
                                    .categoryNameController.text)
                                : categoryController.updateCategoryApi(
                              categoryId: categoryId,
                              categoryName: categoryController
                                  .categoryNameController.text,
                            );
                            Get.back();
                          } else {
                            showSnackbar(message: "Enter Category Name");
                          }
                        },
                        child: Container(
                          height: 30,
                          decoration: BoxDecoration(
                              color: AppColor.blue.shade200,
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(5))),
                          child: Center(
                              child: Text(
                                isEdit == false ? "Add" : "Update",
                                style: AppTextStyle.semiBold
                                    .copyWith(color: Colors.white),
                              )),
                        ),
                      ),
                    ),
                    boxW15(),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Get.back();
                          categoryController.categoryNameController
                              .clear();
                        },
                        child: Container(
                          height: 30,
                          decoration: BoxDecoration(
                              color: AppColor.red,
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(5))),
                          child: Center(
                              child: Text(
                                "Cancel",
                                style: AppTextStyle.semiBold
                                    .copyWith(color: Colors.white),
                              )),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            )
                : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Delete Category",
                    style: AppTextStyle.bold.copyWith(fontSize: 20)),
                boxH15(),
                Text.rich(TextSpan(
                    text: 'Are you sure you want to delete ',
                    style: AppTextStyle.regular
                        .copyWith(color: AppColor.black),
                    children: <InlineSpan>[
                      TextSpan(
                        text: '$categoryName',
                        style: AppTextStyle.bold
                            .copyWith(color: AppColor.black),
                      ),
                      TextSpan(
                        text: ' ?',
                        style: AppTextStyle.regular
                            .copyWith(color: AppColor.black),
                      ),
                    ])),

                boxH20(),
                Row(
                  children: [
                    Expanded(child: SizedBox(),flex: 2,),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          if (categoryId != null &&
                              categoryId.isNotEmpty) {
                            categoryController.deleteCategoryApi(
                                categoryId: categoryId);
                            Get.back();
                          } else {
                            showSnackbar(message: "Error");
                          }
                        },
                        child: Container(
                          height: 30,
                          decoration: BoxDecoration(
                              color: AppColor.blue.shade200,
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(5))),
                          child: Center(
                              child: Text(
                                "Yes",
                                style: AppTextStyle.semiBold
                                    .copyWith(color: Colors.white),
                              )),
                        ),
                      ),
                    ),
                    boxW15(),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          height: 30,
                          decoration: BoxDecoration(
                              color: AppColor.red,
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(5))),
                          child: Center(
                              child: Text(
                                "Cancel",
                                style: AppTextStyle.semiBold
                                    .copyWith(color: Colors.white),
                              )),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  menuTabs({String? title, void Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: Get.width * 0.45,
        height: Get.width * 0.45,
        decoration: BoxDecoration(
            color: AppColor.yellow.withOpacity(0.2),
            borderRadius: const BorderRadius.all(Radius.circular(15))),
        child: Center(
            child: Text(
              title!,
              style: AppTextStyle.bold.copyWith(fontSize: 18),
            )),
      ),
    );
  }
}