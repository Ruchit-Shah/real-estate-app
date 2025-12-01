

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/global/services/api_shorts_string.dart';
import '../../../../common_widgets/height.dart';
import '../../../../global/app_color.dart';
import '../../../../global/theme/app_text_style.dart';
import '../../../shorts/bottom_bar/view/bottom_nav_bar.dart';
import '../../controller/related_products_controller.dart';
import '../all_products_screen.dart';
import '../look_book/look_book_home_list.dart';

class AllRelatedProductForVideo extends StatefulWidget {
  var videoData;
  String isFromScreen;
  AllRelatedProductForVideo(
      {super.key, this.videoData, this.isFromScreen = ''});

  @override
  State<AllRelatedProductForVideo> createState() =>
      _AllRelatedProductForVideoState();
}

class _AllRelatedProductForVideoState extends State<AllRelatedProductForVideo> {
  final relatedProductsController = Get.find<RelatedProductsController>();

  @override
  void initState() {
    super.initState();
    print("widget.videoData[_id]   ${widget.videoData["_id"]}");
    relatedProductsController.getRelatedProductApi(videoId: widget.videoData["_id"]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:  AppColor.white,
        automaticallyImplyLeading: false,
        leadingWidth: 45,
        title: const Text(
          "Current Related Property",
          style: TextStyle(
            color: AppColor.black,
          ),
        ),
        elevation: 0,
        actions:[
            IconButton(
            onPressed: () {
              Get.to(() => AllProductsScreen(
                fromScreen: APIShortsString.add_related_products,
                videoId: widget.videoData["_id"],
              ));
            },
            icon: const Icon(
              Icons.add_circle_outline,
              color: AppColor.black,
            ),
            tooltip: "Add Related Property to your video",
          )],

      ),

      body: WillPopScope(
        onWillPop: () async {
          Get.offAll(()=>  BottomScreen(fromEditReel: false,));
          return false;
        },
        child: Column(
          children: [
            Text(
              "Your Video",
              style: AppTextStyle.bold,
            ),
            boxH10(),
            CachedNetworkImage(
                imageUrl:
                "${APIShortsString.thumbnailBaseUrl}${widget.videoData["thumbnail"]}",
                errorWidget: (context, url, error) {
                  return const Icon(Icons.video_library_outlined);
                },
                height: 120,
                width: 100),
            Text("${widget.videoData["video_caption"]}"),
            boxH10(),
            Align(
                alignment: Alignment.centerLeft,
                child: Text("Property related to this video ", style: AppTextStyle.bold)),
            boxH10(),
            Expanded(
              child: Obx(() {
                return relatedProductsController.relatedProductsList.isEmpty
                    ? const Center(child: Text("Add Property Related To This Videos"))
                    : GridView.builder(
                    shrinkWrap: true,
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        mainAxisSpacing: 1,
                        childAspectRatio: 2.5,
                        crossAxisSpacing: 1),
                    itemCount: relatedProductsController.relatedProductsList.length,
                    itemBuilder: (BuildContext context, int index) {
                      var data = relatedProductsController.relatedProductsList[index];
                      print("data   ${data}");
                      return productLayout(
                        data,
                        index,
                      );
                    });
              }),
            ),
            // Obx(() => relatedProductsController.isApiCallProcessing.value == true
            //     ? const Center(
            //         child: CircularProgressIndicator(),
            //       )
            //     : const SizedBox()),
          ],
        ),
      ),
    );
  }

  Widget productLayout(var videoData, int index) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: AppColor.green.shade50,
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: Row(
        children: [
          Expanded(
              flex: 2,
              child:
              CachedNetworkImage(
                fit: BoxFit.fill,
                imageUrl:
                "${APIShortsString.products_image}${videoData["product_data"]["product_image"][0]["product_images"]}",
                errorWidget: (context, url, error) {
                  return const Icon(Icons.video_library_outlined);
                },
                height: 150,
              )),
          Expanded(
            flex: 3,
            child:
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                Padding(
                  padding: EdgeInsets.only(left: 5,bottom: 5),child:
                  Text("${videoData["product_data"]["product_name"]}",style:
                TextStyle(fontSize: 16,fontWeight: FontWeight.bold,),),),
                Padding(
                  padding: EdgeInsets.only(left: 5,bottom: 2),child:
                Text(' ${videoData["product_data"]['description']}', overflow:TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12,fontWeight: FontWeight.normal,),),),
                Padding(
                  padding: EdgeInsets.only(left: 10,bottom: 5),child:
                Text('${APIShortsString.rupeeSign} ${videoData["product_data"]['product_price']}',style:
                TextStyle(fontSize: 12,fontWeight: FontWeight.normal,color: Colors.blue),),),
                boxH05(),
                Padding(
                  padding: EdgeInsets.all(5),
                  child: Row(children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.brown.withOpacity(0.6),
                            textStyle: const TextStyle(fontSize: 20)),
                        onPressed: () {
                          print("videoData   <><>????  ${videoData}");
                          Get.to(() => LookBookHomeList(
                              userId: videoData["user_id"],
                              productIds: videoData["product_id"],
                              relatedId: videoData["_id"],
                              videoIds: videoData["video_id"]));
                        },
                        child: const Text("Look Book",style: TextStyle(fontSize: 12)),
                      ),
                    ),
                    boxW05(),
                    Expanded(child:
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange.withOpacity(0.6),
                          textStyle: const TextStyle(fontSize: 20)),
                      onPressed: () {
                        relatedProductsController.deleteRelatedProductApi(
                            relatedProductId: videoData["_id"],
                            videoId: widget.videoData["_id"]);
                      },
                      child: const Text("Remove",style: TextStyle(fontSize: 12)),
                    ),)
                  ],),
                )
              ],
            ),)
        ],
      ),
    );
    // return Container(
    //     width: Get.width,
    //     decoration: BoxDecoration(
    //       border: Border.all(
    //         color: Colors.grey.shade300,
    //         width: 1.0,
    //       ),
    //     ),
    //     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    //     margin: const EdgeInsets.only(bottom: 15),
    //     child: Row(
    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //       children: [
    //         Expanded(
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               Text(
    //                 material!,
    //                 style: const TextStyle(fontSize: 16, color: Colors.black),
    //               ),
    //
    //             ],
    //           ),
    //         ),
    //         boxW10(),
    //         Row(
    //           children: [
    //             IconButton(
    //                 onPressed: () {
    //                   // materialCrud(materialData: materialData, isEdit: true, isDelete: false);
    //                 },
    //                 icon: const Icon(
    //                   Icons.edit,
    //                   color: AppColor.grey,
    //                 )),
    //             IconButton(
    //                 onPressed: () {
    //                   // materialCrud(
    //                   //     materialData: materialData, isEdit: false, isDelete: true);
    //                 },
    //                 icon: const Icon(
    //                   Icons.delete,
    //                   color: AppColor.red,
    //                 )),
    //           ],
    //         )
    //       ],
    //     ));
  }
}