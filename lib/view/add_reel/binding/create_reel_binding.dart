// Simplifies Bindings generation from a single callback.

import 'package:get/get.dart';
import '../controller/create_reel_controller.dart';

class CreateReelBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateReelController>(
      () => CreateReelController(),
    );
  }
}
