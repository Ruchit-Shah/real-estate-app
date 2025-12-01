// Simplifies Bindings generation from a single callback.

import 'package:get/get.dart';
import '../controller/all_products_controller.dart';

class AllProductsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AllProductsController>(
      () => AllProductsController(),
    );
  }
}
