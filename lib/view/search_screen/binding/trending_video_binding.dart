// Simplifies Bindings generation from a single callback.

import 'package:get/get.dart';
import '../controller/trending_video_controller.dart';

class TrendingVideoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrendingVideoController>(
      () => TrendingVideoController(),
    );
  }
}
