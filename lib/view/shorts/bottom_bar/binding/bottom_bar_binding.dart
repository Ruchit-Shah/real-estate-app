// Simplifies Bindings generation from a single callback.

// import 'package:frontbit_boiler_plate/src/view/splash/controller/story_controller.dart';
import 'package:get/get.dart';
import '../../../dashboard/deshboard_controllers/bottom_bar_controller.dart';

class BottomBarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BottomBarController>(
      () => BottomBarController(),
    );
  }
}
