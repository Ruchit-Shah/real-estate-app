import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/global/api_string.dart';
import 'package:real_estate_app/global/app_color.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/search_screen/offer_details_screen.dart';

class offer_card extends StatefulWidget {
  final Map<String, dynamic> offer_data;
  final int index;
  const offer_card({super.key, required this.offer_data, required this.index});

  @override
  State<offer_card> createState() => _offer_cardState();
}

class _offer_cardState extends State<offer_card> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Get.to(OfferDetailsScreen(property: widget.offer_data));
        },
        child: Container(
          width: 300,
          height: Get.height,
          margin:
          const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            borderRadius:
            BorderRadius.circular(10),
            border: Border.all(
                color: AppColor.grey
                    .withOpacity(0.1)),
            color: AppColor.grey.shade50,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              ClipRRect(
                borderRadius:
                const BorderRadius.only(
                  topLeft:
                  Radius.circular(10),
                  topRight:
                  Radius.circular(10),
                ),
                child:  widget.offer_data
                ['offer_img'] !=
                    null
                    ? CachedNetworkImage(
                  imageUrl: APIString
                      .imageBaseUrl +
                      widget.offer_data
                      ['offer_img'],
                  fit: BoxFit.cover,
                  width: 300,
                  height: 200,
                  placeholder:
                      (context, url) =>
                      Container(
                        decoration:
                        BoxDecoration(
                          borderRadius:
                          const BorderRadius
                              .only(
                            topLeft: Radius
                                .circular(
                                10),
                            bottomLeft: Radius
                                .circular(
                                10),
                          ),
                          color: Colors
                              .grey[300],
                        ),
                      ),
                  errorWidget: (context,
                      url, error) =>
                  const Icon(
                      Icons.error),
                )
                    : Container(
                  width: 300,
                  height: 200,
                  color:
                  Colors.grey[400],
                  child: const Center(
                    child: Icon(Icons
                        .image_rounded),
                  ),
                ),
              ),

              Expanded(
                flex: 4,
                child: Container(
                  padding:
                  const EdgeInsets.all(8.0),
                  decoration:
                  const BoxDecoration(
                    borderRadius:
                    BorderRadius.only(
                      topRight:
                      Radius.circular(10),
                      bottomRight:
                      Radius.circular(10),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                    mainAxisAlignment:
                    MainAxisAlignment.start,
                    children: [
                      Text(
                        widget.offer_data
                        ['offer_name'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight:
                          FontWeight.bold,
                          color: Colors.black,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow
                            .ellipsis,
                      ),
                      const SizedBox(height: 5),

                      ///dont delte this one description
                      Text(
                        widget.offer_data[
                        'offer_description'],
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow
                            .ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
