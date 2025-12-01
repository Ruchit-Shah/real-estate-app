//Holds the state of the application and provides an API to access/filter/manipulate that data.
// Its concern is data encapsulation and management.
// It contains logic to structure, validate or compare different pieces of data that we call Domain Logic.
// Model File : A perfect tool to make Models easily.
// https://app.quicktype.io/

import 'package:get/get.dart';

class ProductController extends GetxController {

  RxInt selectedIndex= 0.obs;

  void setSelectedIndex(int index) {
    selectedIndex.value = index;
    update();
  }

}
