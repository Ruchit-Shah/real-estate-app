// ignore_for_file: library_private_types_in_public_api, must_be_immutable

import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:real_estate_app/global/services/api_shorts_string.dart';

import '../../../common_widgets/height.dart';
import '../../../global/app_color.dart';
import '../../../global/app_string.dart';
import '../../../global/theme/app_text_style.dart';
import '../controller/all_products_controller.dart';

class ProductDetailScreen extends StatefulWidget {
  Map<String, dynamic>? productDetails;

  int? index;

  ProductDetailScreen({super.key, this.productDetails, this.index});

  @override
  _ProductDetailScreen createState() => _ProductDetailScreen();
}

class _ProductDetailScreen extends State<ProductDetailScreen> {


  _ProductDetailScreen();

  final allProductsController = Get.find<AllProductsController>();

  @override
  void initState() {
    super.initState();

    print("productDetails   ${widget.productDetails}");
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          bottomSheet: Container(
            height: 50,
            alignment: Alignment.center,
            color: Colors.green,
            child: const Text(
              'Buy Now',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          body: Obx(() {
            return allProductsController.productsList.isEmpty?const Center(child: CircularProgressIndicator()): Stack(
              children: [
                Container(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    width: Get.width,
                    height: Get.height,
                    margin: const EdgeInsets.only(bottom: 50),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[

                          boxH50(),
                          productImageUi(),
                          productNameUi(allProductsController.productsList[widget.index!]),
                          //soldByUi(),
                          productPriceUi(allProductsController.productsList[widget.index!]),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   crossAxisAlignment: CrossAxisAlignment.center,
                          //   children: <Widget>[
                          //     Expanded(flex: 1, child: moqUi()),
                          //     Expanded(
                          //         flex: 1,
                          //         child: totalRatingUi())
                          //   ],
                          // ),

                          // Divider(
                          //   height: 20,
                          //   thickness: 7,
                          //   color: Colors.grey[200],
                          // ),
                          // addColors(),
                          // addSize(),
                          // Divider(
                          //   height: 20,
                          //   thickness: 7,
                          //   color: Colors.grey[200],
                          // ),
                          // SingleChildScrollView(
                          //   scrollDirection: Axis.horizontal,
                          //   child: Padding(
                          //     padding: const EdgeInsets.all(10.0),
                          //     child: Row(
                          //       children: [
                          //         Container(
                          //           decoration: BoxDecoration(
                          //               border: Border.all(color: Colors.grey),
                          //               borderRadius: const BorderRadius.all(
                          //                   Radius.circular(20))),
                          //           child: const Padding(
                          //             padding: EdgeInsets.all(5.0),
                          //             child: Wrap(
                          //               crossAxisAlignment:
                          //               WrapCrossAlignment.center,
                          //               children: [
                          //                 Icon(Icons.repeat),
                          //                 SizedBox(
                          //                   width: 5,
                          //                 ),
                          //                 Text('0 Repeat Order',
                          //                     style:
                          //                     TextStyle(fontSize: 14)),
                          //               ],
                          //             ),
                          //           ),
                          //         ),
                          //         const SizedBox(width: 15),
                          //         Container(
                          //           decoration: BoxDecoration(
                          //               border: Border.all(color: Colors.grey),
                          //               borderRadius: const BorderRadius.all(
                          //                 Radius.circular(20),
                          //               )),
                          //           child: const Padding(
                          //             padding: EdgeInsets.all(5.0),
                          //             child: Wrap(
                          //               crossAxisAlignment:
                          //               WrapCrossAlignment.center,
                          //               children: [
                          //                 Icon(Icons.emoji_events),
                          //                 SizedBox(
                          //                   width: 5,
                          //                 ),
                          //                 Text('Best Selling Product',
                          //                     style: TextStyle(fontSize: 14)),
                          //               ],
                          //             ),
                          //           ),
                          //         ),
                          //         const SizedBox(width: 15),
                          //         Container(
                          //           decoration: BoxDecoration(
                          //               border: Border.all(color: Colors.grey),
                          //               borderRadius: const BorderRadius.all(
                          //                   Radius.circular(20))),
                          //           child: const Padding(
                          //             padding: EdgeInsets.all(5.0),
                          //             child: Wrap(
                          //               crossAxisAlignment:
                          //               WrapCrossAlignment.center,
                          //               children: [
                          //                 Icon(Icons.favorite),
                          //                 SizedBox(
                          //                   width: 5,
                          //                 ),
                          //                 Text('2 Likes',
                          //                     style:
                          //                     TextStyle(fontSize: 14)),
                          //               ],
                          //             ),
                          //           ),
                          //         ),
                          //         const SizedBox(width: 15),
                          //         Container(
                          //           decoration: BoxDecoration(
                          //               border: Border.all(color: Colors.grey),
                          //               borderRadius: const BorderRadius.all(
                          //                   Radius.circular(20))),
                          //           child: const Padding(
                          //             padding: EdgeInsets.all(5.0),
                          //             child: Wrap(
                          //               crossAxisAlignment:
                          //               WrapCrossAlignment.center,
                          //               children: [
                          //                 Icon(Icons.repeat),
                          //                 SizedBox(
                          //                   width: 5,
                          //                 ),
                          //                 Text('12% Return',
                          //                     style:
                          //                     TextStyle(fontSize: 14)),
                          //               ],
                          //             ),
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10, left: 10),
                            child: Divider(color: Colors.grey.shade200),
                          ),
                          // deliveryUi(),

                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, top: 5),
                                child: Wrap(
                                  crossAxisAlignment:
                                  WrapCrossAlignment.center,
                                  children: <Widget>[
                                    const Icon(Icons.card_giftcard),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                        // 'Expected Delivery: 5 days',
                                        'Expected Delivery: ${allProductsController.productsList[widget.index!]["time"]} ${allProductsController.productsList[widget.index!]["time_unit"]}',
                                        style:
                                        const TextStyle(fontSize: 14)),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    // Icon(Icons.info),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Divider(
                            color: Colors.grey,
                          ),
                          productDescriptionUi(allProductsController.productsList[widget.index!]),
                          // productColour(),
                          // productPackofUi(),
                          // productMaterialUi(),
                          // productThicknessUi(),
                          // productFirmnessUi(),
                          // productTrialPeriodUi(),
                          // productDimensionUi(),
                          specificationUi(allProductsController.productsList[widget.index!]),
                          Divider(
                            height: 20,
                            thickness: 7,
                            color: Colors.grey[200],
                          ),
                          returnPolicyUi(allProductsController.productsList[widget.index!]),
                          // Return_Policy_Screen(),
                          Divider(
                            height: 20,
                            thickness: 7,
                            color: Colors.grey[200],
                          ),
                          // ratingReviewUi(),
                        ],
                      ),
                    )),
                Container(
                  width: Get.width,
                  color: AppColor.white,
                  padding: const EdgeInsets.only(top: 5),
                  child: Row(
                    children: [
                      const BackButton(),
                      boxW15(),
                      Text("Property  ",
                        style: AppTextStyle.regular.copyWith(fontSize: 20),),
                      const Spacer(),
                      IconButton(
                        visualDensity:
                        const VisualDensity(horizontal: -2.0, vertical: -2.0),
                        padding: EdgeInsets.zero,
                        onPressed: () {},
                        icon: const Icon(Icons.share, color: Colors.black87),
                      ), boxW10(),
                      IconButton(
                          icon: const Icon(
                              Icons.shopping_cart, color: Colors.black),
                          onPressed: () {}),
                      boxW15(),
                    ],
                  ),
                )
              ],
            );
          })),
    );
  }

  Column deliveryUi() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10),
          child: Row(
            children: [
              const Expanded(
                  flex: 6,
                  child: Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Text(
                        "Deliver To: 395006",
                        style: (TextStyle(fontSize: 14, color: Colors.green)),
                      ))),
              Expanded(
                flex: 3,
                child: GestureDetector(
                  child: SizedBox(
                    height: 35,
                    width: 100,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.grey,
                          textStyle: const TextStyle(fontSize: 20)),
                      onPressed: () {},
                      child: const Center(
                        child: Text(
                          'Change',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }

  productImageUi() {
    return GestureDetector(
      onTap: () {},
      child: SizedBox(
        height: 300,
        child: ImageSlideshow(
          width: MediaQuery
              .of(context)
              .size
              .width,
          height: 450,
          initialPage: 0,
          indicatorColor: Colors.blue,
          indicatorBackgroundColor: Colors.grey,
          onPageChanged: (value) {},
          autoPlayInterval: null,
          isLoop: true,
          children: imagesliderItems(),
        ),
      ),
    );
  }

  List<Widget> imagesliderItems() {
    List<Widget> items = [];

    for (int index = 0;
    index < allProductsController.productsList[widget.index!]['product_image'].length;
    // index < 3;
    index++) {
      items.add(SizedBox(
        width: MediaQuery
            .of(context)
            .size
            .width,
        height: 450,
        child: CachedNetworkImage(
          fit: BoxFit.contain,
          imageUrl: "${APIShortsString.products_image}${allProductsController.productsList[widget.index!]['product_image'][index]["product_images"]}",
          placeholder: (context, url) =>
              Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                  )),
          errorWidget: (context, url, error) =>
          const Icon(Icons.image_rounded),
        ),
      ));
    }

    return items;
  }

  productNameUi(data) {
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width,
      margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
              flex: 8,
              child: Container(
                margin: const EdgeInsets.only(top: 10),
                child: Text(
                  data['product_name'] == null ?"":  "${data['product_name']}",
                  // "Product 1",
                  style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              )),
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.topRight,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: const Icon(Icons.favorite_outline_rounded),
            ),
          )
        ],
      ),
    );
  }

  productPriceUi(data) {
    return Container(
        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 8),
        child: Column(
          children: <Widget>[
            Row(
              children: [
                Text(
                  data['product_price'] == null ?"":  "${AppString.rupeeSign} ${data['product_price']}",
                  style: const TextStyle(
                      color: Colors.black45,
                      fontSize: 15,
                      /*decoration: TextDecoration.lineThrough*/),
                ),
                // const SizedBox(
                //   width: 10,
                // ),
                // const Text(
                //   "\$08",
                //   style: TextStyle(
                //       color: Colors.blue,
                //       fontSize: 18,
                //       fontWeight: FontWeight.bold),
                // ),
                // const SizedBox(
                //   width: 10,
                // ),
                // const Text(
                //   "including 0.5% Taxes",
                //   style: TextStyle(
                //       color: Colors.grey,
                //       fontSize: 15,
                //       fontWeight: FontWeight.bold),
                // ),
              ],
            ),
            // const Row(
            //   children: [
            //     Text(
            //       '5% OFF',
            //       style: TextStyle(
            //           color: Colors.redAccent,
            //           fontSize: 13,
            //           fontWeight: FontWeight.bold),
            //     )
            //   ],
            // )
          ],
        ));
  }

  moqUi() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: const Text(
        'MOQ: 1',
        style: TextStyle(
          color: Colors.black54,
          fontSize: 15,
        ),
      ),
    );
  }

  totalRatingUi() {
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width,
      alignment: Alignment.bottomRight,
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Container(
        width: 70,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "7",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 10,
              ),
            ),
            Icon(
              Icons.star,
              color: Colors.orangeAccent,
              size: 10,
            ),
            Text(
              '| 10',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  addColors() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text("Colors",
              style: TextStyle(fontSize: 15, color: Colors.black)),
          const SizedBox(
            height: 5,
          ),
          // Container(
          //     width: MediaQuery.of(context).size.width,
          //     alignment: Alignment.centerLeft,
          //     height: 110,
          //     child: ListView(
          //       scrollDirection: Axis.horizontal,
          //       children: [],
          //     )),
          Divider(
            thickness: 1,
            color: Colors.grey[200],
          ),
        ],
      ),
    );
  }

  addSize() {
    return Container(
      margin: const EdgeInsets.only(
        left: 10,
        right: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              const Text("Select Size",
                  style: TextStyle(fontSize: 15, color: Colors.black)),
              Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      // onTap: () => {showSizeChart()},
                      child: const Text(
                        'Size Chart',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                    ),
                  ))
            ],
          ),
          const SizedBox(height: 5),
          Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              padding: const EdgeInsets.only(left: 6, right: 6),
              alignment: Alignment.centerLeft,
              height: 90,
              child: ListView(
                scrollDirection: Axis.horizontal,
                // children: getSizeList(),
              )),
          Divider(color: Colors.grey.shade300),
        ],
      ),
    );
  }


  returnPolicyUi(data) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Return/Exchange',
            style: TextStyle(
                fontSize: 16,
                //fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
           data["isReturn"].toString().toLowerCase() != "yes"? "Return not available":   'Easy return within ${data["return_time"]} days',
            style: const TextStyle(fontSize: 15, color: Colors.black),
          ),
          Text(
            data["isExchange"].toString().toLowerCase() != "yes"? "Exchange not available":
            'Easy return within ${data["exchange_time"]} days',
            style: const TextStyle(fontSize: 15, color: Colors.black),
          ),


        ],
      ),
    );
  }

  specificationUi(data) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Row(
            children: <Widget>[
              Text("Property Specification",
                  style: TextStyle(fontSize: 15, color: Colors.black)),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            data["highlights"],

              // "  Specifications...",
            style: const TextStyle(
            color: Colors.black54,
            fontSize: 16,
          ),),
          // Container(
          //   margin: const EdgeInsets.all(10),
          //   child: Table(
          //     columnWidths: const {
          //       0: FlexColumnWidth(2),
          //       1: FlexColumnWidth(4),
          //     },
          //     border: TableBorder.all(
          //         color: Colors.grey.shade200,
          //         style: BorderStyle.solid,
          //         width: 1),
          //     defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          //     // children: showSpecificationData(),
          //   ),
          // ),
        ],
      ),
    );
  }

  showSpecificationData() {
    List<TableRow> specificationList = [];

    for (int index = 0;
    index < 3;
    index++) {
      specificationList.add(
        TableRow(children: [
          Column(children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                    "Quality",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 14.0)),
              ),
            )
          ]),
          Column(children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                    "A1 Quality , Best Material",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 14.0)),
              ),
            )
          ]),
        ]),
      );
    }
    return specificationList;
  }

  ratingReviewUi() {
    return Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Customer Reviews',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
                margin: const EdgeInsets.all(5),
                alignment: Alignment.center,
                height: 120,
                // color: Colors.grey[100],
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height,
                      width: 90,
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("4.3",
                                  style: TextStyle(
                                      fontSize: 25, color: Colors.black)),
                              Icon(
                                Icons.star,
                                color: Colors.pinkAccent,
                                size: 27,
                              ),
                            ],
                          ),
                          Text('102 Verified Buyers',
                              style: TextStyle(
                                  fontSize: 12,
                                  //fontWeight: FontWeight.bold,
                                  color: Colors.black54))
                        ],
                      ),
                    ),
                    const VerticalDivider(),
                    Expanded(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.only(left: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text('Finishing',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black)),
                                  Expanded(
                                      flex: 1,
                                      child: Container(
                                        alignment: Alignment.centerRight,
                                        width:
                                        MediaQuery
                                            .of(context)
                                            .size
                                            .width,
                                        child: SizedBox(
                                          child: RatingBar.builder(
                                            itemSize: 15,
                                            ignoreGestures: true,
                                            initialRating: 3.5,
                                            minRating: 1,
                                            direction: Axis.horizontal,
                                            allowHalfRating: true,
                                            itemCount: 5,
                                            itemPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 2.5),
                                            itemBuilder: (context, _) =>
                                            const Icon(
                                              Icons.star,
                                              color: Colors.blueAccent,
                                            ),
                                            onRatingUpdate: (rating) {},
                                          ),
                                        ),
                                      ))
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text('Quality',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black)),
                                  Expanded(
                                      flex: 1,
                                      child: Container(
                                        alignment: Alignment.centerRight,
                                        width:
                                        MediaQuery
                                            .of(context)
                                            .size
                                            .width,
                                        child: SizedBox(
                                          child: RatingBar.builder(
                                            itemSize: 15,
                                            ignoreGestures: true,
                                            initialRating: 2.5,
                                            minRating: 1,
                                            direction: Axis.horizontal,
                                            allowHalfRating: true,
                                            itemCount: 5,
                                            itemPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 2.5),
                                            itemBuilder: (context, _) =>
                                            const Icon(
                                              Icons.star,
                                              color: Colors.blueAccent,
                                            ),
                                            onRatingUpdate: (rating) {},
                                          ),
                                        ),
                                      ))
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text('Size & Fit',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black)),
                                  Expanded(
                                      flex: 1,
                                      child: Container(
                                        alignment: Alignment.centerRight,
                                        width:
                                        MediaQuery
                                            .of(context)
                                            .size
                                            .width,
                                        child: SizedBox(
                                          child: RatingBar.builder(
                                            itemSize: 15,
                                            ignoreGestures: true,
                                            initialRating: 4,
                                            minRating: 1,
                                            direction: Axis.horizontal,
                                            allowHalfRating: true,
                                            itemCount: 5,
                                            itemPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 2.5),
                                            itemBuilder: (context, _) =>
                                            const Icon(
                                              Icons.star,
                                              color: Colors.blueAccent,
                                            ),
                                            onRatingUpdate: (rating) {},
                                          ),
                                        ),
                                      ))
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text('Price',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black)),
                                  Expanded(
                                      flex: 1,
                                      child: Container(
                                        alignment: Alignment.centerRight,
                                        width:
                                        MediaQuery
                                            .of(context)
                                            .size
                                            .width,
                                        child: SizedBox(
                                          child: RatingBar.builder(
                                            itemSize: 15,
                                            ignoreGestures: true,
                                            initialRating: 3,
                                            minRating: 1,
                                            direction: Axis.horizontal,
                                            allowHalfRating: true,
                                            itemCount: 5,
                                            itemPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 2.5),
                                            itemBuilder: (context, _) =>
                                            const Icon(
                                              Icons.star,
                                              color: Colors.blueAccent,
                                            ),
                                            onRatingUpdate: (rating) {},
                                          ),
                                        ),
                                      ))
                                ],
                              ),
                            ],
                          ),
                        ))
                  ],
                )),
            const Divider(),

            const Text(
              'Reviews',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
            ratingUi(),
            // RatingAndReviewList.isNotEmpty&& RatingAndReviewList[1]!=null?
            // RatingUi(RatingAndReviewList[1]):
            // Container(),
            GestureDetector(

              child: Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.grey[100],
                      border: Border.all(color: Colors.black54, width: 1),
                      borderRadius: BorderRadius.circular(5)),
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  child: const Text('View All Reviews',
                      style: TextStyle(
                          fontSize: 12,
                          //fontWeight: FontWeight.bold,
                          color: Colors.black54))),
            )
          ],
        ));
  }

  productDescriptionUi(data) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text("Description",
              style: TextStyle(fontSize: 15, color: Colors.black)),
          const SizedBox(
            height: 5,
          ),
          Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
            margin: const EdgeInsets.all(10),
            child:  Text(
              data["description"],
              // "Description.....",
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 16,
              ),
            ),
          ),
          Divider(
            thickness: 1,
            color: Colors.grey[200],
          ),
        ],
      ),
    );
  }

  ratingUi() {
    return GestureDetector(
        child: Container(
            margin: const EdgeInsets.all(10),

            width: MediaQuery
                .of(context)
                .size
                .width,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.orangeAccent),
                      borderRadius: BorderRadius.circular(2)),
                  child: const Row(
                    children: [
                      Text("5"),
                      Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 15,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Good Property",
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.left,
                        //textScaleFactor: 1,
                        //softWrap: true,
                      ),
                      Container(
                          margin: const EdgeInsets.all(10),
                          height: 90,
                          width: 90,
                          child: CachedNetworkImage(
                            fit: BoxFit.fill,
                            imageUrl: "https://i.pinimg.com/236x/d4/08/7c/d4087c3f4234b67a870e95cc7026f326.jpg",
                            placeholder: (context, url) =>
                                Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.black12,
                                    )),
                            errorWidget: (context, url, error) =>
                            const Icon(
                              Icons.error,
                              color: Colors.black26,
                            ),
                          )),
                      const SizedBox(
                        height: 25,
                        //margin: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "ABC",
                              style: TextStyle(
                                  color: Colors.black87, fontSize: 12),
                            ),
                            VerticalDivider(
                              color: Colors.black87,
                              thickness: 1,
                              width: 10,
                              indent: 4,
                              endIndent: 0,
                            ),
                            Text(
                              "12-OCT-2023",
                              style: TextStyle(
                                  color: Colors.black87, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        thickness: 1,
                        color: Colors.black54,
                      )
                    ],
                  ),
                )
              ],
            )));
  }
}