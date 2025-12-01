// Simplifies Bindings generation from a single callback.

// import 'package:frontbit_boiler_plate/src/view/splash/controller/story_controller.dart';
import 'package:get/get.dart';

import '../controller/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
  }
}
