import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/global/widgets/common_textfield.dart';

import '../../../../common_widgets/height.dart';
import '../../../../global/AppBar.dart';
import '../../../../global/app_color.dart';
import '../../../../global/theme/app_text_style.dart';
import '../../../../utils/common_snackbar.dart';
import '../../controller/look_book_setting_controller.dart';
import 'look_products_list.dart';

class LookBookHomeList extends StatefulWidget {
  String? videoIds;
  String? productIds;
  String? userId;
  String? relatedId;
  LookBookHomeList({super.key, this.userId,this.productIds, this.relatedId, this.videoIds});

  @override
  State<LookBookHomeList> createState() => _LookBookHomeListState();
}

class _LookBookHomeListState extends State<LookBookHomeList> {
  final lookBookSettingController = Get.find<LookBookSettingController>();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if(widget.productIds != null) {
      print("widget.videoIds   ${widget.videoIds}");
      lookBookSettingController.getLookBookApi(
        userId: widget.userId,
      videoId: widget.videoIds,
      productId: widget.productIds,
      // isShowMore: false,
    );
    }else{
      showSnackbar(message: "Unknown Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(titleName: "Look Book List", actions: [
        IconButton(
          onPressed: () {
            lookbookCrud(isEdit: false, isDelete: false);
          },
          icon: const Icon(Icons.add_circle_outline, color: AppColor.black),
        )
      ]),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              return lookBookSettingController.lookbookList.isEmpty
                  ? const SizedBox()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      shrinkWrap: true,
                      controller: scrollController,
                      itemCount: lookBookSettingController.lookbookList.length,
                      itemBuilder: (BuildContext context, int index) {
                        var data = lookBookSettingController.lookbookList[index];
                        debugPrint("data[lookbook_name]   ${data["lookbook_name"]}");
                        log("data[lookbook_name] =-=-=-=-=>>>>  $data");
                        return lookbookLayout(data, data["_id"], data["lookbook_name"], index);
                      });
            }),
          ),
        ],
      ),
    );
  }

  Widget lookbookLayout(var lookbookData, String? lookbookId, String? lookbookName, int index) {
    return InkWell(
      onTap: () {
        Get.to(()=>LookBookProductsList(lookbookData:lookbookData,lookbookId:lookbookData["_id"],));
      },
      child: Container(
          width: Get.width,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.shade300,
              width: 1.0,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          margin: const EdgeInsets.only(bottom: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lookbookName!,
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ],
                ),
              ),
              boxW10(),
              Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            lookbookCrud(
                                lookbookData: lookbookData,
                                isEdit: true,
                                isDelete: false);
                          },
                          icon: const Icon(
                            Icons.edit,
                            color: AppColor.grey,
                          )),
                      IconButton(
                          onPressed: () {
                            lookbookCrud(
                                lookbookData: lookbookData,
                                isEdit: false,
                                isDelete: true);
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: AppColor.red,
                          )),
                    ],
                  ),
                ],
              )
            ],
          )),
    );
  }

  Future<dynamic> lookbookCrud({bool isEdit = false, bool isDelete = false, var lookbookData}) {
    if (isEdit == true) {
      lookBookSettingController.lookbookNameController.text = lookbookData["lookbook_name"];
    }
    return Get.dialog(
      Material(
        color: AppColor.transparent,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Container(
            height: isDelete == true ? 160 : 200,
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
                              ? "Add Look Book"
                              : "Update Look Book",
                          style: AppTextStyle.bold.copyWith(fontSize: 20)),
                      boxH15(),
                      CommonTextField(
                        controller:
                            lookBookSettingController.lookbookNameController,
                        hintText: "Enter Look Book name",
                      ),
                      boxH20(),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                if (lookBookSettingController
                                    .lookbookNameController
                                    .text
                                    .removeAllWhitespace
                                    .isNotEmpty) {
                                  isEdit == false
                                      ? lookBookSettingController
                                          .addLookBookApi(
                                          // videoId: lookBookSettingController.lookbookNameController.text,
                                          videoId: widget.videoIds,
                                          productId: widget.productIds,
                                          lookbookName: lookBookSettingController.lookbookNameController.text,
                                        )
                                      : lookBookSettingController
                                          .updateLookBookApi(
                                          videoId: widget.videoIds,
                                          productId: widget.productIds,
                                          lookbookName:
                                              lookBookSettingController
                                                  .lookbookNameController.text,
                                          lookbookId: lookbookData["_id"],
                                          relatedProductId: widget.relatedId,
                                        );
                                  Get.back();
                                } else {
                                  showSnackbar(message: "Enter Unit Name");
                                }
                              },
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                    color: AppColor.blue.shade200,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10))),
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
                                lookBookSettingController.lookbookNameController
                                    .clear();
                              },
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                    color: AppColor.red,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10))),
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
                      Text("Delete Unit",
                          style: AppTextStyle.bold.copyWith(fontSize: 20)),
                      boxH15(),
                      Text(
                        'Are you sure you want to delete ',
                        style: AppTextStyle.regular
                            .copyWith(color: AppColor.black),
                      ),
                      boxH20(),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                if (lookbookData["_id"] != null &&
                                    lookbookData["_id"].toString().isNotEmpty) {
                                  lookBookSettingController.deleteLookBookApi(
                                      lookbookId: lookbookData["_id"],
                                      productId: widget.productIds,
                                      videoId: widget.videoIds);
                                  Get.back();
                                } else {
                                  showSnackbar(message: "Error");
                                }
                              },
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                    color: AppColor.blue.shade200,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10))),
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
                                height: 40,
                                decoration: BoxDecoration(
                                    color: AppColor.red,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10))),
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
}
