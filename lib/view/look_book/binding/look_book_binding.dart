// Simplifies Bindings generation from a single callback.

import 'package:get/get.dart';

import '../controller/look_book_controller.dart';

class LookBookViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LookBookController>(
      () => LookBookController(),
    );
  }
}
