// Simplifies Bindings generation from a single callback.

import 'package:get/get.dart';

import '../controller/product_details_controller.dart';

class ProductDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductDetailController>(
          () => ProductDetailController(),
    );
  }
}
