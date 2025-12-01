// Simplifies Bindings generation from a single callback.

import 'package:get/get.dart';
import '../controller/my_profile_controller.dart';

class MyProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyProfileController>(
      () => MyProfileController(),
    );
  }
}
