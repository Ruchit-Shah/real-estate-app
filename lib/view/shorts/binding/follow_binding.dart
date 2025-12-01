// Simplifies Bindings generation from a single callback.

import 'package:get/get.dart';
import '../controller/follow_controller.dart';

class FollowingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FollowController>(
          () => FollowController(),
    );
  }
}

class FollowersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FollowController>(
          () => FollowController(),
    );
  }
}
