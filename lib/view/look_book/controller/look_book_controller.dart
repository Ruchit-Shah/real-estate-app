//Holds the state of the application and provides an API to access/filter/manipulate that data.
// Its concern is data encapsulation and management.
// It contains logic to structure, validate or compare different pieces of data that we call Domain Logic.
// Model File : A perfect tool to make Models easily.
// https://app.quicktype.io/

import 'package:get/get.dart';

import '../../product/controller/product_controller.dart';

class LookBookController extends GetxController {

  ProductController? profileController;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    Get.lazyPut(() => ProductController());
    profileController = Get.find<ProductController>();
  }
}
