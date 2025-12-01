import 'package:get/get.dart';
import 'package:real_estate_app/view/activity/ActivityScreen.dart';
import 'package:real_estate_app/view/auth/login_screen/forgot_screen.dart';
import 'package:real_estate_app/view/auth/login_screen/login_screen.dart';
import 'package:real_estate_app/view/auth/register_screen/register_screen.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/profile_screen/edit_profile/edit_profile_details_screen.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/profile_screen/profile_screen.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/profile_screen/profile_section_screens/About/AboutScreen.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/profile_screen/profile_section_screens/Listing/listing_screen.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/profile_screen/profile_section_screens/change_password.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/profile_screen/profile_section_screens/faq_screen/FAQsScreen.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/profile_screen/profile_section_screens/my_transactions/my_transactions_screen.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/profile_screen/profile_section_screens/save_search/save_search_screen.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/save_screen/save_screen.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/search_screen/search_screen.dart';
import 'package:real_estate_app/view/dashboard/view/BottomNavbar.dart';
import 'package:real_estate_app/view/filter_search/view/filter_search_screen.dart';
import 'package:real_estate_app/view/property_screens/post_property_screen/post_property_screen.dart';
import 'package:real_estate_app/view/property_screens/properties_list_screen/properties_list_screen.dart';
import 'package:real_estate_app/view/property_screens/property_details_screen/property_details_screenTest.dart';
import 'package:real_estate_app/view/property_screens/property_search_location/property_search_location_screen.dart';
import 'package:real_estate_app/view/property_screens/recommended_properties_screen/properties_details_screen.dart';
import 'package:real_estate_app/view/property_screens/recommended_properties_screen/properties_list_screen.dart';
import 'package:real_estate_app/view/splash_screen/splash_screen.dart';

import '../view/Store/binding/store_page_binding.dart';
import '../view/Store/view/store_screen.dart';
import '../view/add_reel/binding/create_reel_binding.dart';
import '../view/add_reel/view/create_reel.dart';
import '../view/all_products/binding/all_products_binding.dart';
import '../view/all_products/binding/product_detail_binding.dart';
import '../view/all_products/view/all_products_screen.dart';
import '../view/all_products/view/product_deails_page.dart';
import '../view/look_book/binding/look_book_binding.dart';
import '../view/look_book/view/look_book_view.dart';
import '../view/product/binding/product_binding.dart';
import '../view/product/view/prodct_view.dart';
import '../view/products_category/binding/category_binding.dart';
import '../view/products_category/view/category_screen.dart';
import '../view/search_screen/binding/search_screen_binding.dart';
import '../view/search_screen/binding/trending_video_binding.dart';
import '../view/search_screen/view/property_search.dart';
import '../view/search_screen/view/trending_videos.dart';
import '../view/shorts/binding/follow_binding.dart';
import '../view/shorts/binding/home_binding.dart';
import '../view/shorts/binding/my_profile_binding.dart';
import '../view/shorts/binding/profile_videos_binding.dart';
import '../view/shorts/binding/user_profile_binding.dart';
import '../view/shorts/bottom_bar/binding/bottom_bar_binding.dart';
import '../view/shorts/bottom_bar/view/bottom_nav_bar.dart';
import '../view/shorts/view/followers_list.dart';
import '../view/shorts/view/following_list.dart';
import '../view/shorts/view/home_view.dart';
import '../view/shorts/view/my_profile_screen.dart';
import '../view/shorts/view/profile_videos.dart';
import '../view/shorts/view/user_profile.dart';




class AppPages {
  AppPages._();

  static const initial = Routes.splash;

  static final routes = [
    GetPage(name: Routes.splash, page: () => const SplashScreen()),
    GetPage(name: Routes.login, page:() => LoginScreen()),
    GetPage(name: Routes.register, page:() => RegisterScreen()),
   // GetPage(name: Routes.forgotPassword, page:() => ForgotScreen()),
    GetPage(name: Routes.changePassword, page:() => ChangePassword()),

    GetPage(name: Routes.search, page: () => const SearchScreen()),
    GetPage(name: Routes.saved, page: () => const SaveScreen(isFrom: '', isfrom: '',)),
    GetPage(name: Routes.activity, page: () => const ActivityScreen()),
    GetPage(name: Routes.profile, page: () =>  ProfileScreen()),

    GetPage(name: Routes.bottomNavbar, page: ()=> const BottomNavbar()),
    GetPage(name: Routes.postProperty, page: ()=> const PostPropertyScreen()),
    GetPage(name: Routes.topRatedDeveloperDetailed, page: ()=> const PostPropertyScreen()),
    GetPage(name: Routes.propertySearch, page: ()=> const PropertySearchLocationScreen(data: '',latitude: 0.0,longitude: 0.0,)),

    GetPage(name: Routes.editProfile, page: ()=> const EditProfileDetailsScreen()),

    GetPage(name: Routes.saveSearch, page: ()=> const SaveSearchScreen()),
    GetPage(name: Routes.myTransaction, page: ()=> const MyTransactionScreen()),
    GetPage(name: Routes.listing, page: ()=> const ListingScreen()),

    GetPage(name: Routes.about, page: ()=> const AboutScreen()),
    GetPage(name: Routes.faq, page: ()=> const FAQsScreen()),

    GetPage(
      name: _Paths.BOTTOM_BAR,
      page: () => BottomScreen(),
      binding: BottomBarBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: _Paths.HOME_SCREEN,
      page: () => const HomeView(),
      binding: HomeBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: _Paths.TRENDING_VIDEO,
      page: () => const TrendingVideos(),
      binding: TrendingVideoBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: _Paths.SEARCH_SCREEN,
      page: () => const SearchScreen(),
      binding: SearchScreenBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: _Paths.P_SEARCH_SCREEN,
      page: () => const PropertySearchScreen(),
      binding: SearchScreenBinding(),
      transition: Transition.cupertino,
    ),

    GetPage(
      name: _Paths.LOOKBOOK_SCREEN,
      page: () => LookBookUi(),
      binding: LookBookViewBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: _Paths.STORE_PAGE,
      page: () => const StorePage(),
      binding: StorePageBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: _Paths.PRODUCT_SCREEN,
      page: () => ProductScreen(),
      binding: ProductBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: _Paths.PROFILE_SCREEN,
      page: () => const MyProfileScreen(),
      binding: MyProfileBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: _Paths.USER_PROFILE_SCREEN,
      page: () => UserProfileScreen(),
      binding: UserProfileBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: _Paths.PROFILE_VIDEOS_SCREEN,
      page: () => const ProfileVideos(),
      binding: ProfileVideosBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: _Paths.ALL_PRODUCTS_SCREEN,
      page: () => AllProductsScreen(),
      binding: AllProductsBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: _Paths.PRODUCT_DETAIL_SCREEN,
      page: () => ProductDetailScreen(),
      binding: ProductDetailBinding(),
      transition: Transition.cupertino,
    ),

    GetPage(
      name: _Paths.FOLLOWERS_SCREEN,
      page: () => const FollowersScreen(),
      binding: FollowersBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: _Paths.FOLLOWINGS_SCREEN,
      page: () => const FollowingsScreen(),
      binding: FollowingsBinding(),
      transition: Transition.cupertino,
    ),

    GetPage(
      name: _Paths.CREATE_REEL,
      page: () => const CreateReel(),
      binding: CreateReelBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: _Paths.CATEGORY_SCREEN,
      page: () => const CategoryPage(),
      binding: CategoryPageBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: _Paths.STORE_PAGE,
      page: () => const StorePage(),
      binding: StorePageBinding(),
      transition: Transition.cupertino,
    ),

  ];
}




/// Route Class

abstract class Routes {
  Routes._();

  static const splash = _Paths.splash;
  static const login = _Paths.login;
  static const register  = _Paths.register;
 // static const forgotPassword = _Paths.forgotPassword;
  static const changePassword = _Paths.changePassword;
  static const search = _Paths.search;
  static const saved = _Paths.saved;
  static const activity = _Paths.activity;
  static const profile = _Paths.profile;

  static const bottomNavbar =_Paths.bottomNavbar;
  static const postProperty = _Paths.postProperty;
  static const propertySearch = _Paths.propertySearch;
  static const propertiesList = _Paths.propertiesList;
  static const propertiesDetail = _Paths.propertiesDetail;
  static const propertiesRecommendedList =  _Paths.propertiesRecommendedList;
  static const topRatedDeveloperDetailed =  _Paths.topRatedDeveloperDetailed;
  static const propertiesRecommendedDetail = _Paths.propertiesRecommendedDetail;
  static const editProfile = _Paths.editProfile;

  static const saveSearch = _Paths.saveSearch;
  static const myTransaction = _Paths.myTransaction;
  static const listing = _Paths.listing;
  static const filterSearch = _Paths.filterSearch;
  static const about = _Paths.about;
  static const faq = _Paths.faq;

  static const BOTTOM_BAR = _Paths.BOTTOM_BAR;
  static const HOME_SCREEN = _Paths.HOME_SCREEN;
  static const SEARCH_SCREEN = _Paths.SEARCH_SCREEN;
  static const P_SEARCH_SCREEN = _Paths.P_SEARCH_SCREEN;
  static const TRENDING_VIDEO = _Paths.TRENDING_VIDEO;
  static const LOOKBOOK_SCREEN = _Paths.LOOKBOOK_SCREEN;
  static const STORE_PAGE = _Paths.STORE_PAGE;
  static const PRODUCT_SCREEN = _Paths.PRODUCT_SCREEN;
  static const PROFILE_SCREEN = _Paths.PROFILE_SCREEN;
  static const USER_PROFILE_SCREEN = _Paths.USER_PROFILE_SCREEN;
  static const PROFILE_VIDEOS_SCREEN = _Paths.PROFILE_VIDEOS_SCREEN;
  static const ALL_PRODUCTS_SCREEN = _Paths.ALL_PRODUCTS_SCREEN;
  static const PRODUCT_DETAIL_SCREEN = _Paths.PRODUCT_DETAIL_SCREEN;
  static const FOLLOWERS_SCREEN = _Paths.FOLLOWERS_SCREEN;
  static const FOLLOWINGS_SCREEN = _Paths.FOLLOWINGS_SCREEN;
  static const CREATE_REEL = _Paths.CREATE_REEL;
  static const CATEGORY_SCREEN = _Paths.CATEGORY_SCREEN;

  static const ENQUIRY_PAGE = _Paths.ENQUIRY_PAGE;
}

abstract class _Paths {
  _Paths._();

  static const splash = '/splash';
  static const login = '/login';
  static const register ='/register';
 // static const forgotPassword = 'forgotPassword';
  static const changePassword = '/changePassword';
  static const search = '/search';
  static const saved = '/saved';
  static const activity = '/activity';
  static const profile = '/profile';
  static const bottomNavbar = '/bottomNavbar';
  static const postProperty = '/postProperty';
  static const propertySearch = '/PropertySearchLocation';
  static const propertiesList ='/PropertiesList' ;
  static const propertiesDetail = '/PropertiesDetail';
  static const propertiesRecommendedList = '/PropertiesRecommendedList';
  static const topRatedDeveloperDetailed = '/topRatedDeveloperDetailed';
  static const propertiesRecommendedDetail = '/PropertiesRecommendedDetail';
  static const editProfile = '/editProfile';
  static const saveSearch  = '/saveSearch';
  static const myTransaction = '/myTransaction';
  static const listing = '/listing';
  static const about = "/about";
  static const faq = "/faq";
  static const filterSearch = '/filterSearch';
  static const HOME_SCREEN = '/home-screen';
  static const SEARCH_SCREEN = '/search-screen';
  static const P_SEARCH_SCREEN = '/Psearch-screen';
  static const TRENDING_VIDEO = '/trending-video';
  static const BOTTOM_BAR = '/bottom-bar';
  static const LOOKBOOK_SCREEN = '/lookbook-screen';
  static const STORE_PAGE = '/store-page';
  static const PRODUCT_SCREEN = '/product-screen';
  static const PROFILE_SCREEN = '/profile-screen';
  static const USER_PROFILE_SCREEN = '/user-profile-screen';
  static const PROFILE_VIDEOS_SCREEN = '/profile-videos-screen';
  static const ALL_PRODUCTS_SCREEN = '/all-products-screen';
  static const PRODUCT_DETAIL_SCREEN = '/products-detail-screen';
  static const FOLLOWERS_SCREEN = '/followers-screen';
  static const FOLLOWINGS_SCREEN = '/followings-screen';
  static const CREATE_REEL = '/create-reel';
  static const CATEGORY_SCREEN = '/category-screen';

// ENQUIRY SECTION
  static const ENQUIRY_PAGE ='/enquiry_screen';
}




