import 'package:flutter/material.dart';
import 'package:real_estate_app/global/app_color.dart';
import 'package:real_estate_app/utils/size_config.dart';

/// search screen
const String no_items="no items found";
const String offers_for_you = "Offers for You";
const String top_rated_developers = "Top Rated Developers";
const String recommended_Properties = "Recommended Properties";
const String continue_last_searches = "Continue Last Searches";
const String see_all ="See all";
const String view_all ="View All";

/// profile screen
const String profile = "Profile";
const String edit_profile ="Edit Profile";
const String account_information = "Account Information";
const String save_search = "Save Search";
const String my_transactions = "My Transactions";
const String my_listing = "My Listing";
const String logout = "Logout";

/// Filters screen
const String filters = "Filters";
const String lookingTo = "I'm Looking to";
const String localities = "Localities";
const String rbhkType = "BHK Type";
const String rbudget = "Budget";
const String areaSqFt = "Area Sq.Ft";
const String amenities = "Amenities";
const String propertyType = "Property Type";
const String furnishingStatus = "Furnishing Status";
const String listedBy = "Listed By";
const String viewAllProperties = "View all Properties";

///post property constant
const String post_property  = "Post your property";
const String furnish_type = 'Furnish Type';


/// activity screen
const String activity = "Activity";

const appBarColor = Color(0xFFFFFFFF);
const appBarIconColor = Color(0xFF282727);
const kPrimaryColor = Color(0xFFFF7643);
const kPrimaryLightColor = Color(0xFFFFECDF);
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFFFA53E), Color(0xFFFF7643)],
);
const kSecondaryColor = Color(0xFF979797);
const kTextColor = Color(0xFF757575);

const kAnimationDuration = Duration(milliseconds: 200);
const Color black = Color(0xFF000000);
const Color white = Color(0xFFffffff);
final headingStyle = TextStyle(
  fontSize: getProportionateScreenWidth(20),
  fontWeight: FontWeight.bold,
  color: AppColor.black,
  height: 1.5,
);

const defaultDuration = Duration(milliseconds: 250);

// Form Error
final RegExp emailValidatorRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
final RegExp mobileValidatorRegExp =
RegExp(r"^[0-9]");
const String kEmailNullError = "Please Enter your email";
const String kNameError = "Please Enter your name";
const String kMobileError = "Please Enter your mobile";
const String kInvalidEmailError = "Please Enter Valid Email";
const String kPassNullError = "Please Enter your password";
const String kAddressNullError = "Please Enter your address";
const String kShortPassError = "Password is too short";
const String kMatchPassError = "Passwords don't match";
const String kNamelNullError = "Please Enter your name";
const String kPhoneNumberNullError = "Please Enter your phone number";
//const String app_under_maintenance_message = "The app is undergoing maintenance kindly get back to us at 7pm IST.We regret for the inconvenience.Let us know are you continue with is app?";

const String app_under_maintenance_message = "The app is undergoing maintenance.You may face few glitches.Kindly be patient, We regret for the inconvenience caused.";
const String home_component_show_in_msg = "Please selected atleast one place to show this component(Show in home/ any main category";

final otpInputDecoration =
InputDecoration(
  contentPadding:
  EdgeInsets.symmetric(vertical: 10),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(15),
    borderSide: const BorderSide(color: kTextColor),
  );
}