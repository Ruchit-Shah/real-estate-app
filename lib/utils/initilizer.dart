import 'package:get/get.dart';
import 'package:real_estate_app/view/dashboard/controller/BotController.dart';
import 'package:real_estate_app/view/property_screens/properties_controllers/post_property_controller.dart';

import '../view/add_reel/controller/create_reel_controller.dart';
import '../view/all_products/controller/all_products_controller.dart';
import '../view/all_products/controller/look_book_setting_controller.dart';
import '../view/all_products/controller/related_products_controller.dart';
import '../view/auth/auth_controllers/registration_controller.dart';
import '../view/dashboard/bottom_navbar_screens/profile_screen/profile_controller.dart';
import '../view/filter_search/view/FilterSearchController.dart';
import '../view/dashboard/bottom_navbar_screens/search_screen/searchController.dart';
import '../view/look_book/controller/look_book_controller.dart';
import '../view/notifications/notification_controller.dart';
import '../view/post_video/post_video_controller.dart';
import '../view/product/controller/product_controller.dart';
import '../view/products_category/controller/category_controller.dart';
import '../view/search_screen/controller/search_screen_controller.dart';
import '../view/search_screen/controller/trending_video_controller.dart';
import '../view/shorts/bottom_bar/controller/shorts_bottom_bar_controller.dart';
import '../view/shorts/controller/follow_controller.dart';
import '../view/shorts/controller/home_controller.dart';
import '../view/shorts/controller/my_profile_controller.dart';
import '../view/shorts/controller/user_profile_controller.dart';
import '../view/subscription model/controller/SubscriptionController.dart';
import '../view/top_developer/top_developer_controller.dart';


getXPutInitializer(){


  Get.put(SubscriptionController());
  Get.put(ProfileController());
  Get.put(searchController());
  Get.put(PostPropertyController());
  Get.put(RegistrationController());

  Get.put(top_developer_controller());
  Get.put(FilterSearchController());
  Get.put(notificationController());
  Get.put(BotController());
  Get.put(HomeController());
  Get.put(MyProfileController());
  Get.put(TrendingVideoController());
  Get.put(UserProfileController());
  Get.put(LookBookController());
  Get.put(ProductController());
  Get.put(AllProductsController());
  Get.put(CategoryController());
  Get.put(RelatedProductsController());
  Get.put(LookBookSettingController());
  Get.put(FollowController());
  Get.put(CreateReelController());
  Get.put(SearchScreenController());
  Get.put(AddStoryController());
  Get.put(ShortsBottomBarController());
}
