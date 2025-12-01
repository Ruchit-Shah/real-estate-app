// Views are all the Widgets and Pages within the Flutter Application.
// These views may contain a “view controller” themselves,
// But that is still considered part of the view application tier.

// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/global/services/api_shorts_string.dart';

import '../../../common_widgets/height.dart';
import '../../../global/app_color.dart';
import '../../../global/theme/app_text_style.dart';
import '../../all_products/controller/look_book_setting_controller.dart';
import '../../product/view/prodct_view.dart';
import '../controller/look_book_controller.dart';


List items = [
  {
    "image":
        "https://i.pinimg.com/236x/ef/af/5d/efaf5d571a19295c5735fdd49c88241b.jpg",
    "name": "image 1",
    "price": "\$100"
  },
  {
    "image":
        "https://i.pinimg.com/236x/ad/ed/df/adeddf9547a994317fcec0fcf1ffbe9d.jpg",
    "name": "image 2",
    "price": "\$100"
  },
  {
    "image":
        "https://i.pinimg.com/236x/e5/f2/31/e5f23187e4dab14bc0759d58f73f21f2.jpg",
    "name": "image 3",
    "price": "\$120"
  },
  {
    "image":
        "https://i.pinimg.com/236x/1a/c9/83/1ac983c82295404fa862370376bfdc3f.jpg",
    "name": "image 4",
    "price": "\$80"
  },
  {
    "image":
        "https://i.pinimg.com/236x/50/96/6d/50966d39333866b29b919ddf47ec8c0f.jpg",
    "name": "image 4",
    "price": "\$10"
  },
];

class LookBookUi extends StatefulWidget {
  int? selectedProduct;
  String? productId;
  String? videoId;
  String? userId;

  LookBookUi(
      {super.key,
      this.selectedProduct,
      this.productId,
      this.userId,
      this.videoId,
      });

  @override
  State<LookBookUi> createState() => _LookBookUiState();
}

class _LookBookUiState extends State<LookBookUi> {
  final controller = Get.find<LookBookController>();
  final lookBookSettingController = Get.find<LookBookSettingController>();

  @override
  void initState() {
    super.initState();

    var productId = widget.productId;
    if (kDebugMode) {
      print('productId: $productId');
    }

    lookBookSettingController.getLookBookApi(
        userId: widget.userId,
        videoId: widget.videoId,
        productId: widget.productId,
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.transparent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
                width: Get.width * 0.9,
                // height: Get.height*0.58,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: const BoxDecoration(
                    color: AppColor.white,
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: Get.width * 0.65,
                          child: const Text(
                            ''
                            'Ideas for this item',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              // color: AppColor.white,
                              color: AppColor.black,
                            ),
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              Get.back();
                            },
                            icon: const Icon(
                              Icons.close,
                              // color: AppColor.white,
                              color: AppColor.black,
                            ))
                      ],
                    ),
                    // const SizedBox(height: 5),
                    SizedBox(
                        height: 445,
                        child: Obx(() {
                          return lookBookSettingController.lookbookList.isEmpty
                              ? const Text('No Data Found')
                              : ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: lookBookSettingController
                                      .lookbookList.length,
                                  itemBuilder: (context, index) {
                                    var data = lookBookSettingController.lookbookList[index];
                                    var productData = lookBookSettingController.lookbookList[index]["productLookbook"];
                                    lookBookSettingController.user_contact.value=data['user_contact']??'';
                                    return SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(4),
                                            child: Text(
                                                "${data["lookbook_name"]}",
                                                style: AppTextStyle.bold),
                                          ),
                                          Center(
                                            child: Container(
                                                height: 410,
                                                width: 280,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.grey,
                                                      width: 1.5),
                                                ),
                                                padding: const EdgeInsets.all(5),
                                                margin: const EdgeInsets.all(5),
                                                child: SingleChildScrollView(
                                                  scrollDirection: Axis.vertical,
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      Expanded(
                                                        flex: 2,
                                                        child: Column(
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () {
                                                                if (productData == null ||
                                                                    productData.isEmpty ||
                                                                    (productData.length <= 0)) {
                                                                } else {
                                                                  controller
                                                                      .profileController!
                                                                      .selectedIndex
                                                                      .value = 0;
                                                                  // Get.toNamed(Routes.PRODUCT_SCREEN);
                                                                  Get.dialog(
                                                                      ProductScreen(
                                                                        selectedProduct:
                                                                            0,
                                                                        productData:
                                                                            productData,
                                                                        selectedLookBook:
                                                                            index,
                                                                        user_contact: lookBookSettingController.user_contact.value,
                                                                      ),
                                                                      barrierDismissible:
                                                                          true,
                                                                      useSafeArea:
                                                                          true);
                                                                }
                                                              },
                                                              child: Container(
                                                                height: 150,
                                                                margin:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left: 4,
                                                                        right: 4,
                                                                        top: 1,
                                                                        bottom:
                                                                            1),
                                                                color:
                                                                    Colors.white,
                                                                child: productData ==
                                                                            null ||
                                                                        productData
                                                                            .isEmpty ||
                                                                        (productData.length >=
                                                                                1) ==
                                                                            false
                                                                    ? const Center(
                                                                        child: Text(
                                                                            "No Data"))
                                                                    : Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment
                                                                                .start,
                                                                        children: [
                                                                          Expanded(
                                                                            flex:
                                                                                5,
                                                                            child:
                                                                                SizedBox(
                                                                              width:
                                                                                  Get.width,
                                                                              child:
                                                                                  Container(
                                                                                width: Get.width,
                                                                                height: Get.height,
                                                                                decoration: BoxDecoration(
                                                                                  color: Colors.grey[100],
                                                                                  // image: DecorationImage(
                                                                                  //     image: NetworkImage("${APIShortsString.products_image}${productData[0]["product_data"]["product_image"][0]['product_images']}"),
                                                                                  //     fit: BoxFit.fill)
                                                                                ),
                                                                                child: CachedNetworkImage(
                                                                                  fit: BoxFit.fill,
                                                                                  imageUrl: APIShortsString.products_image + productData[0]["product_data"]["product_image"][0]['product_images'],
                                                                                  placeholder: (context, url) => Container(
                                                                                      decoration: BoxDecoration(
                                                                                    color: Colors.grey[400],
                                                                                  )),
                                                                                  // progressIndicatorBuilder: (context, url, downloadProgress) => CircularProgressIndicator(value: downloadProgress.progress),
                                                                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Expanded(
                                                                              flex:
                                                                                  3,
                                                                              child: Container(
                                                                                  padding: const EdgeInsets.all(5),
                                                                                  child: Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: <Widget>[
                                                                                      Container(
                                                                                        margin: const EdgeInsets.only(right: 20),
                                                                                        child: Text(
                                                                                          productData[0]["product_data"]['product_name'],
                                                                                          maxLines: 1,
                                                                                          overflow: TextOverflow.ellipsis,
                                                                                          style: const TextStyle(fontSize: 12, color: Colors.black87),
                                                                                        ),
                                                                                      ),
                                                                                      boxH05(),
                                                                                      Text(
                                                                                        "${APIShortsString.rupeeSign} ${productData[0]["product_data"]['product_price']}",
                                                                                        style: const TextStyle(color: Colors.blue, fontSize: 14, fontWeight: FontWeight.bold),
                                                                                      ),
                                                                                    ],
                                                                                  ))),
                                                                        ],
                                                                      ),
                                                              ),
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {
                                                                if (productData ==
                                                                        null ||
                                                                    productData
                                                                        .isEmpty ||
                                                                    (productData.length >=
                                                                            1) ==
                                                                        false) {
                                                                } else {
                                                                  controller
                                                                      .profileController!
                                                                      .selectedIndex
                                                                      .value = 1;
                                                                  Get.dialog(
                                                                      ProductScreen(
                                                                          selectedProduct: 1, productData: productData,
                                                                          selectedLookBook: index, user_contact: lookBookSettingController.user_contact.value), barrierDismissible: true, useSafeArea: true);
                                                                }
                                                              },
                                                              child: Container(
                                                                height: 132,
                                                                margin:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left: 4,
                                                                        right: 4,
                                                                        top: 1,
                                                                        bottom:
                                                                            1),
                                                                color:
                                                                    Colors.white,
                                                                // child:  productData == null ||productData.isEmpty || productData.length <= 2
                                                                child: productData ==
                                                                            null ||
                                                                        productData
                                                                            .isEmpty ||
                                                                        (productData.length >=
                                                                                2) ==
                                                                            false
                                                                    ? const Center(
                                                                        child: Text(
                                                                            "No Data"))
                                                                    : Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment
                                                                                .start,
                                                                        children: [
                                                                          Expanded(
                                                                            flex:
                                                                                5,
                                                                            child:
                                                                                SizedBox(
                                                                              width:
                                                                                  Get.width,
                                                                              child:
                                                                                  Container(
                                                                                width: Get.width,
                                                                                height: Get.height,
                                                                                decoration: BoxDecoration(
                                                                                  color: Colors.grey[100],
                                                                                ),
                                                                                child: CachedNetworkImage(
                                                                                  fit: BoxFit.fill,
                                                                                  imageUrl: APIShortsString.products_image + productData[1]["product_data"]["product_image"][0]['product_images'],
                                                                                  placeholder: (context, url) => Container(
                                                                                      decoration: BoxDecoration(
                                                                                    color: Colors.grey[400],
                                                                                  )),
                                                                                  // progressIndicatorBuilder: (context, url, downloadProgress) => CircularProgressIndicator(value: downloadProgress.progress),
                                                                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Expanded(
                                                                              flex:
                                                                                  3,
                                                                              child: Container(
                                                                                  padding: const EdgeInsets.all(5),
                                                                                  child: Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: <Widget>[
                                                                                      Container(
                                                                                        margin: const EdgeInsets.only(right: 20),
                                                                                        child: Text(
                                                                                          "${productData[1]["product_data"]['product_name']}",
                                                                                          maxLines: 1,
                                                                                          overflow: TextOverflow.ellipsis,
                                                                                          style: const TextStyle(fontSize: 12, color: Colors.black87),
                                                                                        ),
                                                                                      ),
                                                                                      boxH05(),
                                                                                      Text(
                                                                                        "${APIShortsString.rupeeSign} ${productData[1]["product_data"]['product_price']}",
                                                                                        style: const TextStyle(color: Colors.blue, fontSize: 14, fontWeight: FontWeight.bold),
                                                                                      ),
                                                                                    ],
                                                                                  ))),
                                                                        ],
                                                                      ),
                                                              ),
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {
                                                                if (productData ==
                                                                        null ||
                                                                    productData
                                                                        .isEmpty ||
                                                                    (productData.length >=
                                                                            4) ==
                                                                        false) {
                                                                } else {
                                                                  controller
                                                                      .profileController!
                                                                      .selectedIndex
                                                                      .value = 3;
                                                                  Get.dialog(
                                                                      ProductScreen(
                                                                          selectedProduct:
                                                                              3,
                                                                          productData:
                                                                              productData,
                                                                          selectedLookBook:
                                                                              index,user_contact: lookBookSettingController.user_contact.value),
                                                                      barrierDismissible:
                                                                          true,
                                                                      useSafeArea:
                                                                          true);
                                                                }
                                                              },
                                                              child: Container(
                                                                height: 132,
                                                                margin:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left: 4,
                                                                        right: 4,
                                                                        top: 1,
                                                                        bottom:
                                                                            1),
                                                                color:
                                                                    Colors.white,
                                                                // child:  productData == null ||productData.isEmpty || productData.length <= 4
                                                                child: productData ==
                                                                            null ||
                                                                        productData
                                                                            .isEmpty ||
                                                                        (productData.length >=
                                                                                4) ==
                                                                            false
                                                                    ? const Center(
                                                                        child: Text(
                                                                            "No Data"))
                                                                    : Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment
                                                                                .start,
                                                                        children: [
                                                                          Expanded(
                                                                            flex:
                                                                                5,
                                                                            child:
                                                                                SizedBox(
                                                                              width:
                                                                                  Get.width,
                                                                              child:
                                                                                  Container(
                                                                                width: Get.width,
                                                                                height: Get.height,
                                                                                decoration: BoxDecoration(
                                                                                  color: Colors.grey[100],
                                                                                  // image: DecorationImage(
                                                                                  //   image: NetworkImage("${APIShortsString.products_image}${productData[3]["product_data"]["product_image"][0]['product_images']}"),
                                                                                  // ),
                                                                                ),
                                                                                child: CachedNetworkImage(
                                                                                  fit: BoxFit.fill,
                                                                                  imageUrl: APIShortsString.products_image + productData[3]["product_data"]["product_image"][0]['product_images'],
                                                                                  placeholder: (context, url) => Container(
                                                                                      decoration: BoxDecoration(
                                                                                    color: Colors.grey[400],
                                                                                  )),
                                                                                  // progressIndicatorBuilder: (context, url, downloadProgress) => CircularProgressIndicator(value: downloadProgress.progress),
                                                                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Expanded(
                                                                              flex:
                                                                                  3,
                                                                              child: Container(
                                                                                  padding: const EdgeInsets.all(5),
                                                                                  child: Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: <Widget>[
                                                                                      Container(
                                                                                        margin: const EdgeInsets.only(right: 20),
                                                                                        child: Text(
                                                                                          "${productData[3]["product_data"]['product_name']}",
                                                                                          maxLines: 1,
                                                                                          overflow: TextOverflow.ellipsis,
                                                                                          style: const TextStyle(fontSize: 12, color: Colors.black87),
                                                                                        ),
                                                                                      ),
                                                                                      boxH05(),
                                                                                      Text(
                                                                                        "${APIShortsString.rupeeSign} ${productData[3]["product_data"]['product_price']}",
                                                                                        style: const TextStyle(color: Colors.blue, fontSize: 14, fontWeight: FontWeight.bold),
                                                                                      ),
                                                                                    ],
                                                                                  ))),
                                                                        ],
                                                                      ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 3,
                                                        child: Column(
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () {
                                                                if (productData ==
                                                                        null ||
                                                                    productData
                                                                        .isEmpty ||
                                                                    (productData.length >=
                                                                            3) ==
                                                                        false) {
                                                                } else {
                                                                  controller
                                                                      .profileController!
                                                                      .selectedIndex
                                                                      .value = 2;
                                                                  Get.dialog(
                                                                      ProductScreen(
                                                                          selectedProduct:
                                                                              2,
                                                                          productData:
                                                                              productData,
                                                                          selectedLookBook:
                                                                              index, user_contact: lookBookSettingController.user_contact.value),
                                                                      barrierDismissible:
                                                                          true,
                                                                      useSafeArea:
                                                                          true);
                                                                }
                                                              },
                                                              child: Container(
                                                                height: /*Get.width * 0.642*/
                                                                    265,
                                                                margin:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left: 4,
                                                                        right: 4,
                                                                        top: 1,
                                                                        bottom:
                                                                            1),
                                                                color:
                                                                    Colors.white,
                                                                child: productData ==
                                                                            null ||
                                                                        productData
                                                                            .isEmpty ||
                                                                        (productData.length >=
                                                                                3) ==
                                                                            false
                                                                    ? const Center(
                                                                        child: Text(
                                                                            'No Data'))
                                                                    : Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment
                                                                                .start,
                                                                        children: [
                                                                          Expanded(
                                                                            flex:
                                                                                9,
                                                                            child:
                                                                                SizedBox(
                                                                              width:
                                                                                  Get.width,
                                                                              child:
                                                                                  Container(
                                                                                width: Get.width,
                                                                                height: Get.height,
                                                                                decoration: BoxDecoration(
                                                                                  color: Colors.grey[100],
                                                                                  // image: DecorationImage(
                                                                                  //   image: NetworkImage("${APIShortsString.products_image}${productData[2]["product_data"]["product_image"][0]['product_images']}"),
                                                                                  // ),
                                                                                ),
                                                                                child: CachedNetworkImage(
                                                                                  fit: BoxFit.fill,
                                                                                  imageUrl: APIShortsString.products_image + productData[2]["product_data"]["product_image"][0]['product_images'],
                                                                                  placeholder: (context, url) => Container(
                                                                                      decoration: BoxDecoration(
                                                                                    color: Colors.grey[400],
                                                                                  )),
                                                                                  // progressIndicatorBuilder: (context, url, downloadProgress) => CircularProgressIndicator(value: downloadProgress.progress),
                                                                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Expanded(
                                                                              flex:
                                                                                  2,
                                                                              child: Container(
                                                                                  padding: const EdgeInsets.all(5),
                                                                                  child: Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: <Widget>[
                                                                                      Container(
                                                                                        margin: const EdgeInsets.only(right: 20),
                                                                                        child: Text(
                                                                                          "${productData[2]["product_data"]['product_name']}",
                                                                                          maxLines: 1,
                                                                                          overflow: TextOverflow.ellipsis,
                                                                                          style: const TextStyle(fontSize: 12, color: Colors.black87),
                                                                                        ),
                                                                                      ),
                                                                                      boxH05(),
                                                                                      Text(
                                                                                        "${APIShortsString.rupeeSign} ${productData[2]["product_data"]['product_price']}",
                                                                                        style: const TextStyle(color: Colors.blue, fontSize: 14, fontWeight: FontWeight.bold),
                                                                                      ),
                                                                                    ],
                                                                                  ))),
                                                                        ],
                                                                      ),
                                                              ),
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {
                                                                if (productData ==
                                                                        null ||
                                                                    productData
                                                                        .isEmpty ||
                                                                    (productData.length >=
                                                                            5) ==
                                                                        false) {
                                                                } else {
                                                                  controller
                                                                      .profileController!
                                                                      .selectedIndex
                                                                      .value = 4;
                                                                  Get.dialog(
                                                                      ProductScreen(
                                                                          selectedProduct:
                                                                              4,
                                                                          productData:
                                                                              productData,
                                                                          selectedLookBook:
                                                                              index,user_contact: lookBookSettingController.user_contact.value,),
                                                                      barrierDismissible:
                                                                          true,
                                                                      useSafeArea:
                                                                          true);
                                                                }
                                                              },
                                                              child: Container(
                                                                height: 130,
                                                                margin:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left: 4,
                                                                        right: 4,
                                                                        top: 1,
                                                                        bottom:
                                                                            1),
                                                                color:
                                                                    Colors.white,
                                                                child: productData ==
                                                                            null ||
                                                                        productData
                                                                            .isEmpty ||
                                                                        (productData.length >=
                                                                                5) ==
                                                                            false
                                                                    ? const Center(
                                                                        child: Text(
                                                                            "No Data"))
                                                                    // child:
                                                                    : Column(
                                                                        children: [
                                                                          Expanded(
                                                                            flex:
                                                                                5,
                                                                            child:
                                                                                SizedBox(
                                                                              width:
                                                                                  Get.width,
                                                                              child:
                                                                                  Container(
                                                                                width: Get.width,
                                                                                height: Get.height,
                                                                                decoration: BoxDecoration(
                                                                                  color: Colors.grey[100],
                                                                                  // image: DecorationImage(
                                                                                  //   image: NetworkImage("${APIShortsString.products_image}${productData[4]["product_data"]["product_image"][0]['product_images']}"),
                                                                                  // ),
                                                                                ),
                                                                                child: CachedNetworkImage(
                                                                                  fit: BoxFit.fill,
                                                                                  imageUrl: APIShortsString.products_image + productData[4]["product_data"]["product_image"][0]['product_images'],
                                                                                  placeholder: (context, url) => Container(
                                                                                      decoration: BoxDecoration(
                                                                                    color: Colors.grey[400],
                                                                                  )),
                                                                                  // progressIndicatorBuilder: (context, url, downloadProgress) => CircularProgressIndicator(value: downloadProgress.progress),
                                                                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                              padding:
                                                                                  const EdgeInsets.all(4),
                                                                              child: Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: <Widget>[
                                                                                  Container(
                                                                                    margin: const EdgeInsets.only(right: 20),
                                                                                    child: Text(
                                                                                      "${productData[4]["product_data"]['product_name']}",
                                                                                      maxLines: 1,
                                                                                      overflow: TextOverflow.ellipsis,
                                                                                      style: const TextStyle(fontSize: 12, color: Colors.black87),
                                                                                    ),
                                                                                  ),
                                                                                  boxH05(),
                                                                                  Text(
                                                                                    "${APIShortsString.rupeeSign} ${productData[4]["product_data"]['product_price']}",
                                                                                    style: const TextStyle(color: Colors.blue, fontSize: 14, fontWeight: FontWeight.bold),
                                                                                  ),
                                                                                ],
                                                                              )),
                                                                        ],
                                                                      ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )),
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                        }))
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
