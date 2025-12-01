// Simplifies Bindings generation from a single callback.

import 'package:get/get.dart';
import '../controller/store_page_controller.dart';

class StorePageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StorePageController>(
      () => StorePageController(),
    );
  }
}
