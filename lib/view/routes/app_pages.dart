// // App Pages
//
// import 'package:get/get.dart';
//
// import '../Store/binding/store_page_binding.dart';
// import '../Store/view/store_screen.dart';
// import '../add_reel/binding/create_reel_binding.dart';
// import '../add_reel/view/create_reel.dart';
// import '../all_products/binding/all_products_binding.dart';
// import '../all_products/binding/product_detail_binding.dart';
// import '../all_products/view/all_products_screen.dart';
// import '../all_products/view/product_deails_page.dart';
// import '../dashboard/bottom_navbar_screens/search_screen/search_screen.dart';
// import '../look_book/binding/look_book_binding.dart';
// import '../look_book/view/look_book_view.dart';
// import '../product/binding/product_binding.dart';
// import '../product/view/prodct_view.dart';
// import '../products_category/binding/category_binding.dart';
// import '../products_category/view/category_screen.dart';
// import '../search_screen/binding/search_screen_binding.dart';
// import '../search_screen/binding/trending_video_binding.dart';
// import '../search_screen/view/property_search.dart';
// import '../search_screen/view/trending_videos.dart';
// import '../shorts/binding/follow_binding.dart';
// import '../shorts/binding/home_binding.dart';
// import '../shorts/binding/my_profile_binding.dart';
// import '../shorts/binding/profile_videos_binding.dart';
// import '../shorts/binding/user_profile_binding.dart';
// import '../shorts/bottom_bar/binding/bottom_bar_binding.dart';
// import '../shorts/bottom_bar/view/bottom_nav_bar.dart';
// import '../shorts/view/followers_list.dart';
// import '../shorts/view/following_list.dart';
// import '../shorts/view/home_view.dart';
// import '../shorts/view/my_profile_screen.dart';
// import '../shorts/view/profile_videos.dart';
// import '../shorts/view/user_profile.dart';
// part 'app_routes.dart';
//
// class AppPages {
//   AppPages._();
//
//   // ignore: constant_identifier_names
//   static const INITIAL = Routes.SPLASH_SCREEN;
//
//   static final routes = [
//
//     GetPage(
//       name: _Paths.BOTTOM_BAR,
//       page: () => BottomScreen(),
//       binding: BottomBarBinding(),
//       transition: Transition.cupertino,
//     ),
//     GetPage(
//       name: _Paths.HOME_SCREEN,
//       page: () => const HomeView(),
//       binding: HomeBinding(),
//       transition: Transition.cupertino,
//     ),
//     GetPage(
//       name: _Paths.TRENDING_VIDEO,
//       page: () => const TrendingVideos(),
//       binding: TrendingVideoBinding(),
//       transition: Transition.cupertino,
//     ),
//     GetPage(
//       name: _Paths.SEARCH_SCREEN,
//       page: () => const SearchScreen(),
//       binding: SearchScreenBinding(),
//       transition: Transition.cupertino,
//     ),
//     GetPage(
//       name: _Paths.P_SEARCH_SCREEN,
//       page: () => const PropertySearchScreen(),
//       binding: SearchScreenBinding(),
//       transition: Transition.cupertino,
//     ),
//
//     GetPage(
//       name: _Paths.LOOKBOOK_SCREEN,
//       page: () => LookBookUi(),
//       binding: LookBookViewBinding(),
//       transition: Transition.cupertino,
//     ),
//     GetPage(
//       name: _Paths.STORE_PAGE,
//       page: () => const StorePage(),
//       binding: StorePageBinding(),
//       transition: Transition.cupertino,
//     ),
//     GetPage(
//       name: _Paths.PRODUCT_SCREEN,
//       page: () => ProductScreen(),
//       binding: ProductBinding(),
//       transition: Transition.cupertino,
//     ),
//     GetPage(
//       name: _Paths.PROFILE_SCREEN,
//       page: () => const MyProfileScreen(),
//       binding: MyProfileBinding(),
//       transition: Transition.cupertino,
//     ),
//     GetPage(
//       name: _Paths.USER_PROFILE_SCREEN,
//       page: () => UserProfileScreen(),
//       binding: UserProfileBinding(),
//       transition: Transition.cupertino,
//     ),
//     GetPage(
//       name: _Paths.PROFILE_VIDEOS_SCREEN,
//       page: () => const ProfileVideos(),
//       binding: ProfileVideosBinding(),
//       transition: Transition.cupertino,
//     ),
//     GetPage(
//       name: _Paths.ALL_PRODUCTS_SCREEN,
//       page: () => AllProductsScreen(),
//       binding: AllProductsBinding(),
//       transition: Transition.cupertino,
//     ),
//     GetPage(
//       name: _Paths.PRODUCT_DETAIL_SCREEN,
//       page: () => ProductDetailScreen(),
//       binding: ProductDetailBinding(),
//       transition: Transition.cupertino,
//     ),
//
//     GetPage(
//       name: _Paths.FOLLOWERS_SCREEN,
//       page: () => const FollowersScreen(),
//       binding: FollowersBinding(),
//       transition: Transition.cupertino,
//     ),
//     GetPage(
//       name: _Paths.FOLLOWINGS_SCREEN,
//       page: () => const FollowingsScreen(),
//       binding: FollowingsBinding(),
//       transition: Transition.cupertino,
//     ),
//
//     GetPage(
//       name: _Paths.CREATE_REEL,
//       page: () => const CreateReel(),
//       binding: CreateReelBinding(),
//       transition: Transition.cupertino,
//     ),
//       GetPage(
//       name: _Paths.CATEGORY_SCREEN,
//       page: () => const CategoryPage(),
//       binding: CategoryPageBinding(),
//       transition: Transition.cupertino,
//     ),
//     GetPage(
//       name: _Paths.STORE_PAGE,
//       page: () => const StorePage(),
//       binding: StorePageBinding(),
//       transition: Transition.cupertino,
//     ),
//   ];
// }
