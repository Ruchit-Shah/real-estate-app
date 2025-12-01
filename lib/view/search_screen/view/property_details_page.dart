import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../global/app_color.dart';
import '../../../global/services/api_shorts_string.dart';
import '../../look_book/view/add_enquiry.dart';

class property_details extends StatefulWidget {
  final data ;
  const property_details({super.key,required this.data});

  @override
  State<property_details> createState() => _property_detailsState();
}

class _property_detailsState extends State<property_details> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade200,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.black45,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [


          IconButton(
            icon: Icon(Icons.call),
            color: Colors.black45,
            onPressed: () {
              _makePhoneCall();

            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: Get.width,
                height: Get.width * 0.6,
                child:productImageUi()
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(

                width: Get.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),

                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 10,),
                      Text(
                        widget.data['product_name'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10,),

                      Divider(),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0), child: Container(

              decoration: BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                      //color: Colors.orange.shade50,
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(

                            widget.data['highlights'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColor.black54,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            widget.data['description'],
                            style: TextStyle(
                                fontSize: 14,
                                color: AppColor.black54,
                                fontWeight: FontWeight.w400
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    Divider(),
                    const SizedBox(height: 5),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                      //color: Colors.blue.shade50,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 20,

                          ),

                          SizedBox(width: 10),
                          Text(
                            widget.data['city']??"",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColor.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ),

          ],
        ),
      ),
      bottomNavigationBar:
      Container(
        padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
        color: Colors.black,
        child: Row(

          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
        "₹ "+widget.data['product_price'],
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 15),
            ElevatedButton(
              onPressed: () {


               Get.to(() => AddEnquiry(productId: widget.data['_id'], otherUserId:widget.data['user_id']));
              },
              child: const Text('ADD ENQUIRY',style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
              ),),
            ),

          ],
        ),
      ),



    );
  }

  productImageUi() {
    if (widget.data['product_image'].isNotEmpty &&
        widget.data['product_image'].isNotEmpty) {
      return SizedBox(
        height: 450,
        child: ImageSlideshow(
          /// Width of the [ImageSlideshow].
          width: MediaQuery.of(context).size.width,

          /// Height of the [ImageSlideshow].
          height: 450,

          /// The page to show when first creating the [ImageSlideshow].
          initialPage: 0,

          /// The color to paint the indicator.
          indicatorColor: Colors.blue,

          /// The color to paint behind th indicator.
          indicatorBackgroundColor: Colors.grey,

          /// Called whenever the page in the center of the viewport changes.
          onPageChanged: (value) {},

          /// Auto scroll interval.
          /// Do not auto scroll with null or 0.
          autoPlayInterval: null,

          /// Loops back to first slide.
          isLoop: true,

          /// The widgets to display in the [ImageSlideshow].
          /// Add the sample image file into the images folder
          children: imagesliderItems(),
        ),
      );
    } else {
      return Container(
        height: 400,
        color: Colors.grey[300],
      );
    }
  }
  List<Widget> imagesliderItems() {
    List<Widget> items = [];

    for (int index = 0;
    index < widget.data['product_image'].length;
    index++) {
      items.add(SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 450,
        child: widget.data['product_image'].isNotEmpty
            ? CachedNetworkImage(
          fit: BoxFit.contain,
          imageUrl:
          APIShortsString.products_image +
              widget.data['product_image'][index]['product_images'],
          placeholder: (context, url) => Container(
              decoration: BoxDecoration(
                color: Colors.grey[400],
              )),
          errorWidget: (context, url, error) =>
          const Icon(Icons.image_rounded),
        )
            : Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.grey[200],
            )),
      ));
    }

    return items;
  }
  Future<void> _makePhoneCall() async {

    var mobileNumber= widget.data['customer_contact']['mobile_number'].toString();
    print('mobileNUmber: $mobileNumber');
    print('other user Mobile Number:$mobileNumber');
    String url = 'tel:' + mobileNumber.replaceAll(' ', '');

    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } on PlatformException catch (e) {
      print("Failed to make phone call: ${e.message}");
    } catch (e) {
      print("Failed to make phone call: $e");
    }
  }
}