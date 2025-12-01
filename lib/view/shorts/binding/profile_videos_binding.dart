// Simplifies Bindings generation from a single callback.

// import 'package:frontbit_boiler_plate/src/view/splash/controller/story_controller.dart';
import 'package:get/get.dart';

import '../controller/profile_videos_controller.dart';

class ProfileVideosBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileVideosController>(
          () => ProfileVideosController(),
    );
  }
}
