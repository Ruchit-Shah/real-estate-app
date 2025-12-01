import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../global/AppBar.dart';
import '../../../global/api_string.dart';
import '../../../global/app_string.dart';
import '../../all_products/controller/all_products_controller.dart';
import 'EnquiryScreen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final AllProductsController allProductsController =
      Get.put(AllProductsController());

  @override
  void initState() {
    super.initState();
    allProductsController.getProductsApi(isShowMore: false, pageNo: 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(titleName: 'Property List'),
      body: Obx(() {
        if (allProductsController.isMoreProductsLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (allProductsController.productsList.isEmpty) {
          return Center(child: Text('No products found'));
        }

        return ListView.builder(
          itemCount: allProductsController.productsList.length,
          itemBuilder: (context, index) {
            final product = allProductsController.productsList[index];
            return GestureDetector(
              onTap: () {
                // Get.to(EnquiryScreen(
                //     productId: product['_id'], userId: product['user_id']));
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EnquiryScreen(
                      productId: product['_id'],
                      userId: product['user_id'],
                    ),
                  ),
                );
                print('productId products '+product['_id']);
              },
              child: Card(
                margin: const EdgeInsets.all(10),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(width: 0.5, color: Colors.grey[300]!),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        child: product['product_image'].toString().isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl:
                                    "${APIString.products_image}${product['product_image'][0]["product_images"]}",
                                height: 125,
                                width: 125,
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                  Container(
                                    height: 125,
                                    width: 125,
                                    color: Colors.grey,),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              )
                            : Container(
                                color: Colors.grey.shade300,
                                height: 125,
                                width: 125,
                                child: const Icon(Icons.image, size: 30),
                              ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product['product_name'] ?? 'N/A',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '${AppString.rupeeSign} ${product['product_price']}',
                              style: const TextStyle(
                                color: Colors.blue,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              product['description'] ??
                                  'No description available',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Obx(() => allProductsController.isMoreProductsLoading.value == true
                          ? const Center(
                        child: CircularProgressIndicator(),
                      )
                          : const SizedBox()),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
