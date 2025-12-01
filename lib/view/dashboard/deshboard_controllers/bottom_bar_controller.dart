
import 'package:get/get.dart';

class BottomBarController extends GetxController {

  @override
  void onInit() {
    super.onInit();
  }
  RxInt currentPage = 0.obs;

  RxInt selectedBottomIndex = 0.obs;
  RxString fromPage = 'Home'.obs;
}