import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/global/app_color.dart';
import 'package:real_estate_app/global/services/api_shorts_string.dart';

import '../../../../common_widgets/height.dart';
import '../../../../global/AppBar.dart';
import '../../../../global/app_string.dart';
import '../../controller/look_book_setting_controller.dart';
import '../all_products_screen.dart';


class LookBookProductsList extends StatefulWidget {
  var lookbookData; // particular look book data
  String? lookbookId;
  LookBookProductsList({super.key,this.lookbookData,this.lookbookId});

  @override
  State<LookBookProductsList> createState() => _LookBookProductsListState();
}

class _LookBookProductsListState extends State<LookBookProductsList> {
  final lookBookSettingController = Get.find<LookBookSettingController>();

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    print("widget.videoId  _________>  ${widget.lookbookData}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(titleName: "Look Book Property List",
          actions: [
        IconButton(
          onPressed: () {

            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (BuildContext context) {
                return SizedBox(
                  height: Get.height*0.95,
                  child: AllProductsScreen(fromScreen: AppString.addProductToLookBook,lookbookId: widget.lookbookId!,videoId: widget.lookbookData["video_id"]),
                );
              },
            );
          },
          icon: const Icon(Icons.add_circle_outline, color: AppColor.black),
        )
      ]),
      body: Column(
        children: [
          // Text("widget.lookbookData   ${widget.lookbookData}"),
          Expanded(
            child: /*Obx(() {
              // return lookBookSettingController.lookbookList.isEmpty
              return*/ widget.lookbookData["productLookbook"].isEmpty
                  ? const SizedBox()
                  : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  shrinkWrap: true,
                  controller: scrollController,
                  // itemCount: lookBookSettingController.lookbookList.length,
                  itemCount: widget.lookbookData["productLookbook"].length,
                  itemBuilder: (BuildContext context, int index) {
                    var data = widget.lookbookData["productLookbook"][index];
                    log("data data  data   data  ==>   ${data}");
                    String deleteProductFromLookBookId = widget.lookbookData["productLookbook"][index]["_id"];
                    return productsLayout(data,deleteProductFromLookBookId,/* data["_id"], data["lookbook_name"],*/ index);
                  })
          ),
        ],
      ),
    );
  }

  Widget productsLayout(var data, String deleteProductFromLookBookId,/*String? lookbookId, String? lookbookName,*/ int index) {
    return InkWell(
      onTap: () {
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

                    Row(
                      children: [
                        CachedNetworkImage(imageUrl: "${APIShortsString.products_image}${data["product_data"]["product_image"][0]["product_images"]}",
                            errorWidget: (context, url, error) {
                          return const Icon(Icons.production_quantity_limits);
                        },height: 80,width: 80),
                        Text(
                          "  ${data["product_data"]["product_name"]}",
                          style: const TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              boxW10(),
              IconButton(
                  onPressed: () {
                    print(" deleteProductFromLookBookId   <><> ${deleteProductFromLookBookId}");
                    lookBookSettingController.deleteProductLookBookApi(
                        productId: widget.lookbookData["product_id"],
                        videoId: widget.lookbookData["video_id"],
                        product_lookbook_id:deleteProductFromLookBookId
                    );
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: AppColor.red,
                  ),
              ),

            ],
          )),
    );
  }

}
