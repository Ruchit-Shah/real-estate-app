//Holds the state of the application and provides an API to access/filter/manipulate that data.
// Its concern is data encapsulation and management.
// It contains logic to structure, validate or compare different pieces of data that we call Domain Logic.
// Model File : A perfect tool to make Models easily.
// https://app.quicktype.io/

import 'package:get/get.dart';

import '../../controller/my_profile_controller.dart';

class ShortsBottomBarController extends GetxController {
  MyProfileController? myProfileController;
  @override
  void onInit() {
    super.onInit();
    Get.lazyPut(() => MyProfileController());
    myProfileController = Get.find<MyProfileController>();
  }
  RxInt currentPage = 0.obs;
  RxInt selectedBottomIndex = 0.obs;
}