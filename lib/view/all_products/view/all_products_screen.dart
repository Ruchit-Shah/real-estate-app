// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/common_widgets/height.dart';
import 'package:real_estate_app/global/app_color.dart';
import 'package:real_estate_app/view/all_products/view/product_deails_page.dart';

import '../../../global/app_string.dart';
import '../../../global/services/api_shorts_string.dart';
import '../../../global/theme/app_text_style.dart';
import '../controller/all_products_controller.dart';
import '../controller/look_book_setting_controller.dart';
import '../controller/related_products_controller.dart';
import 'add_product/select_category.dart';
import 'add_product/update_product.dart';

class AllProductsScreen extends StatefulWidget {
  bool? isUserProducts;
  String fromScreen;
  String videoId;
  String lookbookId;
  AllProductsScreen(
      {super.key,
      this.isUserProducts,
      this.fromScreen = '',
      this.videoId = '',
      this.lookbookId = ''});
  // AppString.regularProductFlow , AppString.addRelatedProduct , AppString.addProductToLookBook

  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  final allProductsController = Get.find<AllProductsController>();
  final ScrollController scrollController = ScrollController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    allProductsController.getProductsApi(
      isShowMore: false,
      pageNo: 1,
    );
    scrollController.addListener(() async {
      if (scrollController.position.maxScrollExtent ==
          scrollController.position.pixels) {
        if (allProductsController.currentProductsPage.value !=
            allProductsController.lastProductsPage.value) {
          allProductsController.getProductsApi(
              count: 10,
              pageNo: allProductsController.nextProductsPage.value,
              isShowMore: true);
        }
      }
    });
    print(APIShortsString.add_related_products);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            boxH05(),
            Row(
              children: [
                const BackButton(),
                boxW15(),
                Text(
                  "Property  ",
                  style: AppTextStyle.regular.copyWith(fontSize: 20),
                ),
                const Spacer(),
                widget.isUserProducts == true ||
                        widget.fromScreen == AppString.addProductToLookBook
                    // || widget.fromScreen == AppString.addRelatedProduct
                    ? const SizedBox()
                    : GestureDetector(
                        onTap: () {
                          Get.to(() => const SelectCategory());
                        },
                        child: const Icon(Icons.add_circle,
                            color: AppColor.black, size: 30)),
                boxW15(),
              ],
            ),
            Expanded(
              child: Obx(() {
                return allProductsController.productsList.isEmpty
                    ? const SizedBox()
                    : ListView.builder(
                        controller: scrollController,
                        // padding: const EdgeInsets.symmetric(horizontal: 15),
                        shrinkWrap: true,
                        itemCount: allProductsController.productsList.length,
                        itemBuilder: (BuildContext context, int index) {
                          var data = allProductsController.productsList[index];
                          print('---  data  ---\n\n $data \n\n');
                          return InkWell(
                            onTap: () {
                              if (widget.fromScreen == AppString.addRelatedProduct) {
                                Get.find<RelatedProductsController>()
                                    .addRelatedProductApi(
                                    productId: data['_id'],
                                    videoId: widget.videoId);
                              } else if (widget.fromScreen == AppString.regularProductFlow) {
                                Get.to(() => ProductDetailScreen(
                                      productDetails: data,
                                      index: index,
                                    ));
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                  color: AppColor.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 10.0,
                                    ),
                                  ],
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10))),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(5)),
                                            child: data['product_image']
                                                    .toString()
                                                    .isNotEmpty
                                                ? CachedNetworkImage(
                                                    imageUrl:
                                                        "${APIShortsString.products_image}${data['product_image'][0]["product_images"]}",
                                                    height: 125,
                                                    width: 125,
                                                    fit: BoxFit.cover)
                                                : Container(
                                                    color:
                                                        AppColor.grey.shade300,
                                                    height: 125,
                                                    width: 125,
                                                    child: const Icon(
                                                        Icons.image,
                                                        size: 30)),
                                          ),
                                          // Container(
                                          //   height: 15,
                                          //   width: 45,
                                          //   alignment: Alignment.center,
                                          //   decoration:
                                          //   const BoxDecoration(
                                          //       color: Colors
                                          //           .green,
                                          //       borderRadius: BorderRadius.only(topLeft: Radius.circular(5))
                                          //   ),
                                          //   child: const Text(
                                          //     "1.2% off",
                                          //     style: TextStyle(
                                          //         color: AppColor.white,
                                          //         fontSize: 11),
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                      boxW10(),
                                      SizedBox(
                                        width: Get.width * 0.52,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Text("Set of CupsSet of CupsSet of CupsSet of CupsSet of CupsSet of Cups",style: AppTextStyle.bold),
                                            Text("${data['product_name']}",
                                                style: AppTextStyle.bold),
                                            boxH10(),
                                            Text(
                                              '${AppString.rupeeSign} ${data['product_price']}',
                                              style: const TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            // Text.rich(
                                            //     TextSpan(
                                            //         text: 'MRP : ',
                                            //         style: const TextStyle(
                                            //             color: Colors.black,
                                            //             fontSize: 12),
                                            //         children: <InlineSpan>[
                                            //           TextSpan(
                                            //             text: '\$${data['product_name']}',
                                            //             style: TextStyle(
                                            //                 color: Colors.grey[600],
                                            //                 fontSize: 12,
                                            //                 decoration: TextDecoration.lineThrough),
                                            //           ),
                                            //           TextSpan(
                                            //             text: ' \$${data['product_name']}',
                                            //             style: const TextStyle(
                                            //                 color: Colors.blue,
                                            //                 fontSize: 18,
                                            //                 fontWeight: FontWeight.bold),
                                            //           )
                                            //         ]
                                            //     )
                                            // ),
                                            boxH10(),
                                            // Row(
                                            //   children: [
                                            //     RatingBar.builder(
                                            //       maxRating: 5,
                                            //       initialRating: 3,
                                            //       itemSize: 15,
                                            //       updateOnDrag: false,
                                            //       ignoreGestures: true,
                                            //       minRating: 1,
                                            //       direction: Axis.horizontal,
                                            //       allowHalfRating: true,
                                            //       glow: false,
                                            //       itemCount: 5,
                                            //       itemPadding: const EdgeInsets.symmetric(
                                            //           horizontal: 1),
                                            //       itemBuilder: (context, _) =>
                                            //           Icon(
                                            //             Icons.star,
                                            //             color: AppColor.amber.withOpacity(0.8),
                                            //           ),
                                            //       unratedColor: AppColor.amber.withOpacity(0.3),
                                            //       onRatingUpdate: (rating) {
                                            //         print(rating);
                                            //       },
                                            //     ),
                                            //     Text(" (3/5)", style: AppTextStyle.regular.copyWith(
                                            //         fontSize: 12),)
                                            //   ],
                                            // ),
                                            // boxH10(),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  widget.isUserProducts == true
                                      ? const SizedBox()
                                      : boxH10(),
                                  widget.fromScreen == 'add_related_products'
                                      ? Row(
                                          children: [
                                            Expanded(
                                              child: GestureDetector(
                                                onTap: () {
                                                  Get.find<RelatedProductsController>()
                                                      .addRelatedProductApi(
                                                          productId: data['_id'],
                                                          videoId: widget.videoId);
                                                },
                                                child: buttonBox(
                                                    btnColor: AppColor.grey
                                                        .withOpacity(0.7),
                                                    btnIcon: Icons.edit,
                                                    btnTitle:
                                                        "Add To Related Property"),
                                              ),
                                            ),
                                          ],
                                        )
                                      : widget.fromScreen == 'addProductToLookBook'
                                          ? Row(
                                              children: [
                                                Expanded(
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      print("widget.videoId   ${widget.videoId}");
                                                      Get.find<LookBookSettingController>()
                                                          .addProductLookBookApi(
                                                              productId: data['_id'],
                                                              videoId: widget.videoId,
                                                              lookbookId: widget
                                                                  .lookbookId);
                                                    },
                                                    child: buttonBox(
                                                        btnColor: AppColor.grey
                                                            .withOpacity(0.7),
                                                        btnIcon: Icons.edit,
                                                        btnTitle:
                                                            "Add Property To Look Book"),
                                                  ),
                                                ),
                                              ],
                                            )
                                          : widget.isUserProducts == true
                                              ? const SizedBox()
                                              : Row(
                                                  children: [
                                                    Expanded(
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          Get.to(() =>
                                                                  UpdateProductScreen(
                                                                    index:
                                                                        index,
                                                                  ))!
                                                              .whenComplete(() {
                                                            allProductsController
                                                                .clearFields();
                                                          });
                                                        },
                                                        child: buttonBox(
                                                            btnColor: AppColor
                                                                .black54
                                                                .withOpacity(
                                                                    0.7),
                                                            btnIcon: Icons.edit,
                                                            btnTitle: "Edit"),
                                                      ),
                                                    ),
                                                    boxW10(),
                                                    Expanded(
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          deleteProductDialog(
                                                              context,
                                                              productId:
                                                                  data['_id']);
                                                        },
                                                        child: buttonBox(
                                                            btnColor:Colors.brown,
                                                            btnIcon: Icons
                                                                .delete_forever,
                                                            btnTitle: "Delete"),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                ],
                              ),
                            ),
                          );
                        });
              }),
            ),
            Obx(() => allProductsController.isMoreProductsLoading.value == true
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : const SizedBox()),
          ],
        ),
      ),
    );
  }

  Container buttonBox(
      {required btnColor, required btnTitle, required btnIcon}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
          color: btnColor,
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              btnIcon,
              color: AppColor.white,
            ),
            Text(
              "  $btnTitle",
              style: AppTextStyle.regular
                  .copyWith(color: AppColor.white, fontSize: 16),
            )
          ],
        ),
      ),
    );
  }

  void deleteProductDialog(BuildContext context, {String? productId}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            backgroundColor: Colors.yellow[50],
            title: const Text(
              'Are you sure?',
              style: TextStyle(color: Colors.black87),
            ),
            content: Wrap(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    const Text(
                      'Do you want to delete your data',
                      style: TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: () {
                            if (productId != null && productId.isNotEmpty) {
                              allProductsController.deleteProductApi(
                                  productId: productId);
                            }
                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[200],
                            minimumSize: const Size(70, 30),
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(2.0)),
                            ),
                          ),
                          child: const Text("Yes",
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 13)),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[200],
                            minimumSize: const Size(70, 30),
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(2.0)),
                            ),
                          ),
                          child: const Text("No",
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 13)),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ));
      },
    );
  }
}
