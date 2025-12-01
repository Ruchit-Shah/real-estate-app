

class APIString {
  APIString._();

  static const String Index ="10";
  static const String baseUrl ="http://13.127.244.70:4444/cust_api/";

  static const String imageBaseUrl ="http://13.127.244.70:4444/";
  static const String imageMediaBaseUrl ="http://13.127.244.70:4444/media/";

  static const String GoogleVisionApi="AIzaSyB4fbvybji-qsuUFRDXNjkpvNgVkb8BQu8";


  static const String agora_token = "1cdbce7343934585a6708b001e064f5b";

  //Shorts Base url
  static const String shorts_baseUrl = "http://crm.houzza.in/HouzzaShorts/api/";
  static const String profileImageBaseUrl = "http://crm.houzza.in/HouzzaShorts/images/profile/";
  static const String videoBaseUrl = "http://crm.houzza.in/HouzzaShorts/images/videos/";
  static const String thumbnailBaseUrl = "http://crm.houzza.in/HouzzaShorts/images/video_thumbnail/";
  static const String color_image = "http://crm.houzza.in/HouzzaShorts/images/color_image/";
  static const String products_image = "http://crm.houzza.in/HouzzaShorts/images/products_image/";
  static const String storyBaseUrl = "http://crm.houzza.in/HouzzaShorts/story/media/";

  // User-related Endpoints
  static const String registerUser = "register_user";
  static const String generateOtp = "generate-otp";
  static const String generateOtpLogin = "generate-login-otp";
  static const String verifyOtp = "verify-otp";
  static const String userLogin = "user_login";
  static const String changePassword = "change_password";
  static const String forgotPassword = "forgot_password";
  static const String give_us_feedback = "give_us_feedback";
  static const String getProfile = "get_profile";
  static const String editProfile = "edit_profile";
  static const String delete_user = "delete_user";

  ///seller panel
  static const String get_leads_data = "get_leads_data";
  static const String get_views_data = "get_views_data";
  static const String get_tours_data = "get_tours_data";


// Property-related Endpoints
  static const String searchLocation = "search_location";
  static const String getPropertiesByCategoryType = "get-properties-by-category_type";
  static const String addRecentSearchProperties = "add_recent_search_properties";
  static const String getRecentSearchProperties = "get_recent_search_properties";
  static const String getSaveSearch = "get_save_search";
  static const String addSaveSearchProperty = "add_save_search_property";
  static const String getRecommendedProperties = "get_recommended_properties";

// Property Management Endpoints
  static const String postProperty = "post_property";
  static const String add_project_property = "add_project_property";
  static const String add_project_images = "add_project_images";
  static const String editProperty = "edit_property";
  static const String get_descriptions_property = "get_descriptions";
  static const String addPropertyImages = "add_property_images";
  static const String removePropertyImage = "remove_property_image";
  static const String remove_project_image = "remove_project_image";
  static const String get_property_images = "get_property_images";
  static const String get_project_images = "get_project_images";
  static const String addPropertyAmenities = "add_property_amenities";
  static const String removePropertyAmenity = "remove_property_amenity";
  static const String get_amenities= "get_amenities";

  static const String get_property_list= "get_property_list";
  static const String get_recommended_properties= "get_recommended_properties";
  static const String get_property_details= "get_property_details";
  static const String get_notifications= "get_notifications";

  static const String post_project= "post_project";
  static const String edit_project= "edit_project";
  static const String get_project_list= "get_project_list";
  static const String all_project_list= "all_project_list";
  static const String delete_project= "delete_project";
  static const String get_project_details= "get_project_details";
  static const String change_property_status= "change_property_status";



  static const String get_citywise_property_count= "get_citywise_property_count";
  static const String get_user_property_count= "get_user_property_count";


  static const String add_developer= "add_developer";
  static const String get_developer= "get_developer";
  static const String get_developer_details= "get_developer_details";
  static const String getlistingproperties= "get-listing-properties";
  static const String delete_listing_property= "delete_listing_property";

  static const String add_to_favorite= "add_to_favorite";
  static const String remove_from_favorite= "remove_from_favorite";
  static const String get_favorite_properties= "get_favorite_properties";

  static const String add_favorite_project= "add_favorite_project";
  static const String remove_favorite_project= "remove_favorite_project";
  static const String get_favorite_projects= "get_favorite_projects";

  static const String get_contact= "get_contact";
  static const String add_contact= "add_contact";

  static const String filter_property= "filter_property";
  static const String my_properties_search_filter= "my_properties_search_filter";
  static const String my_project_search_filter= "my_project_search_filter";

  static const String get_offer= "get_offer";
  static const String check_offer_property= "check_offer_property";
  static const String add_offer= "add_offer";
  static const String update_offer= "update_offer";
  static const String delete_offer= "delete_offer";
  static const String get_upcoming_project= "get_upcoming_project";
  static const String upcoming_project= "upcoming_project";
  static const String delete_upcoming_project= "delete_upcoming_project";
  static const String get_featured_property= "get_featured_property";

  static const String add_view_property= "add_view_property";
  static const String get_view_property= "get_view_property";
  static const String add_view_project= "add_view_project";
  static const String get_view_project= "get_view_project";

  static const String get_faqs= "get-faqs";
  static const String get_privacy_policy= "get-privacy-policy";
  static const String get_term_conditions= "get-term-conditions";
  static const String get_about_us= "get-about-us";
  static const String get_offered_property= "get_offered_property";
  static const String add_property_enquiry= "add_property_enquiry";
  static const String add_project_enquiry= "add_project_enquiry";
  static const String get_property_enquiry= "get_property_enquiry";
  static const String get_project_enquiry= "get_project_enquiry";
  static const String add_developer_enquiry= "add_developer_enquiry";
  static const String get_developer_enquiry= "get_developer_enquiry";
  static const String get_subscription_plans= "get_subscription_plans";
  static const String purchase_plan= "purchase_plan";
  static const String Plan_purchased_History= "Plan_purchased_History";
  static const String update_plan_status= "update_plan_status";
  static const String get_setting= "get_setting";
  static const String add_count= "add_count";
  static const String agent_property_list = "agent_property_list";
  static const String agent_project_list = "agent_project_list";


  //search_ai
  static const String search_properties = "search_properties";
  static const String add_virtual_tour_schedule = "add_virtual_tour_schedule";
  static const String get_virtual_tour_schedule = "get_virtual_tour_schedule";
  static const String update_tour_status = "update_tour_status";

  static const String add_timeslot = "add_timeslot";
  static const String get_timeslot = "get_timeslot";
  static const String delete_timeslot = "delete_timeslot";
  static const String my_properties_search = "my_properties_search";
  static const String my_projects_search = "my_project_search";
  static const String get_project_property = "get_project_property";
  static const String remove_project_property = "remove_project_property";
  static const String delete_save_search = "delete_save_search";
  static const String get_home_data = "get_home_data";

}
