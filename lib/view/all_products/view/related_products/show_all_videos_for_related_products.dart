
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/global/app_color.dart';
import 'package:real_estate_app/global/services/api_shorts_string.dart';
import '../../../../global/AppBar.dart';
import '../../../../global/app_string.dart';
import '../../../../global/theme/app_text_style.dart';
import '../../controller/related_products_controller.dart';
import 'add_related_products_for_video.dart';


class ShowAllVideosForRelatedProds extends StatefulWidget {
  const ShowAllVideosForRelatedProds({super.key});

  @override
  State<ShowAllVideosForRelatedProds> createState() => _ShowAllVideosForRelatedProdsState();
}

class _ShowAllVideosForRelatedProdsState extends State<ShowAllVideosForRelatedProds> {
  final   relatedProductsController = Get.find<RelatedProductsController>();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    relatedProductsController.videoForRelatedProducts();


    relatedProductsController.videoForRelatedProducts(
      isShowMoreCall: false,
      pageNumber: 1,
    );
    scrollController.addListener(() async {
      if (scrollController.position.maxScrollExtent ==
          scrollController.position.pixels) {
        if (relatedProductsController.currentPageList.value !=
            relatedProductsController.lastPage.value) {
          relatedProductsController.videoForRelatedProducts(
              count: 10,
              pageNumber: relatedProductsController.nextPage.value,
              isShowMoreCall: true
          );

        }
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: appBar(titleName: "Your Videos Related Products Section"),
      appBar: appBar(titleName: "Your Videos"),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              return relatedProductsController.myVideosDataList.isEmpty
                  ? const SizedBox()
                  : GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 2,
                      mainAxisExtent: 200,
                      crossAxisSpacing: 2),
                  controller: scrollController,
                  // padding: const EdgeInsets.symmetric(horizontal: 15),
                  // shrinkWrap: true,
                  itemCount: relatedProductsController.myVideosDataList.length,
                  itemBuilder: (BuildContext context, int index) {
                    var data = relatedProductsController.myVideosDataList[index];
                    return videoListLayout(
                      data,
                      index,
                    );
                  });
            }),
          ),
          Obx(() => relatedProductsController.isApiCallProcessing.value == true
              ? const Center(
            child: CircularProgressIndicator(),
          )
              : const SizedBox()),
        ],
      ),
    );
  }

  Widget videoListLayout(
      var videoData,
      int index) {
    return InkWell(
      onTap: () {
        print("videoData    ${videoData}");
        Get.to(()=>AllRelatedProductForVideo(videoData: videoData["video"],isFromScreen: AppString.fromStore,));
      },
      child: Container(
        //padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(color: AppColor.white),
        child: Stack(
          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CachedNetworkImage(
              imageUrl: "${APIShortsString.thumbnailBaseUrl}${videoData["video"]["thumbnail"]}",
              fit: BoxFit.fill,
              height: 200,
              errorWidget: (context, url, error) {
                return const Icon(Icons.video_library_outlined);
              },),
            Container(
              margin: const EdgeInsets.only(top: 150),
              height: 50,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(color: Colors.white30),
              child: Text("${videoData["video"]["video_caption"]}",
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyle.caption,),
            ),
          ],
        ),
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