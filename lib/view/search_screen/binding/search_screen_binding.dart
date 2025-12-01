// Simplifies Bindings generation from a single callback.

import 'package:get/get.dart';
import '../controller/search_screen_controller.dart';

class SearchScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchScreenController>(
      () => SearchScreenController(),
    );
  }
}
