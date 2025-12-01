import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/common_widgets/height.dart';
import 'package:real_estate_app/global/AppBar.dart';
import 'package:real_estate_app/global/app_color.dart';
import 'package:real_estate_app/global/constant.dart';
import 'package:real_estate_app/view/auth/login_screen/login_screen.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/CustomBottomNavBar.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/profile_screen/profile_section_screens/Listing/projectListingScreen.dart';
import 'package:real_estate_app/view/property_screens/property_details_screen/property_details_screenTest.dart';
import '../../../../../../utils/String_constant.dart';
import '../../../../../../utils/shared_preferences/shared_preferances.dart';
import '../../../../../splash_screen/splash_screen.dart';
import '../../../../../subscription model/Subscription_Screen.dart';
import 'myListingProperty.dart';
import 'offerListing.dart';

class ListingScreen extends StatefulWidget {
  const ListingScreen({Key? key}) : super(key: key);

  @override
  State<ListingScreen> createState() => _ListingScreenState();
}

class _ListingScreenState extends State<ListingScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String isOffer = "";
  String isUpcoming = "";
  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 3,
        vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();

    });
    // _tabController = TabController(
    //     length:   isOffer=='yes' && isUpcoming=='yes'?
    //     3:isOffer=='yes' || isUpcoming=='yes'?2:1,
    //     vsync: this);
  }

  getData() async {
    String  Offer= (await SPManager.instance.getOffers(Offers))??"no";
    int? offerCount= (await SPManager.instance.getOfferCount(PAID_OFFER))??0;
    int? offerPlanCount= (await SPManager.instance.getPlanOfferCount(PLAN_OFFER))??0;
    String  Project= (await SPManager.instance.getUpcomingProjects(UpcomingProjects))??"no";

    int? projectCount= (await SPManager.instance.getProjectCount(PAID_PROJECT))??0;

    int? projectPlanCount= (await SPManager.instance.getPlanProjectCount(PLAN_PROJECT))??0;
    // print('isPost==>');
    // print(Offer);
    // print(Project);
    // print(offerCount);
    // print(projectCount);
    // print(offerPlanCount);
    // print(projectPlanCount);

    if(Offer=='no'){
      setState(() {
        isOffer ='no';
      });
    }else{
      if(offerCount < offerPlanCount){
        setState(() {
          isOffer ='yes';
        });
      }else {
        setState(() {
         // isOffer ='no_limit';
          isOffer ='yes';
        });
      }
    }
    ///
    if(Project=='no'){
      setState(() {
        isUpcoming ='no';
      });
    }else{
      if(projectCount < projectPlanCount){
        setState(() {
          isUpcoming ='yes';
        });
      }else {
        setState(() {
       //   isUpcoming ='no_limit';
          isUpcoming ='yes';
        });
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 25,
        automaticallyImplyLeading: false,
      ),
      body: isLogin == true ?
      Column(
        children: [
          TabBar(
            controller: _tabController,
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(width: 3.0, color: Colors.blue.shade900),
              insets: EdgeInsets.symmetric(horizontal: 0.0),
            ),
            indicatorColor: Colors.blue.shade900,
            labelColor: Colors.blue.shade900,
            unselectedLabelColor: Colors.grey,labelStyle: TextStyle(fontSize: 15),
            tabs:  const [
              Tab(text: 'Property'),
              Tab(text: 'Offer'),
              Tab(text: 'Upcoming\nproject'),
            ],
          ),
          Expanded(
            child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _tabController,
              children:  [
                const MyListingProperty(),
                isOffer=='yes'?
                const offerListing():UpgradeWidget(isOffer: isOffer,isfrom: 'offer',),
                isUpcoming=='yes'?
                const ProjectListing()
                    :UpgradeWidget(isOffer: isUpcoming,isfrom: 'project',),
                // offerListing(),
                // ProjectListing(),
              ],
            ),
          ),
        ],
      ):
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Centering the children
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Image.asset(
                  'assets/permission.png',
                  height: 100,
                  width: 100,
                ),
              ),
              const Text("Login to view your listing"),
              SizedBox(height: 10),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Get.off(LoginScreen());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    textStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    elevation: 10, // Shadow elevation
                  ),
                  child: Text('Login'),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}

class UpgradeWidget extends StatelessWidget {
  final String isfrom;
  final String isOffer;

  UpgradeWidget({required this.isfrom,required this.isOffer});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: Get.width,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: Colors.blueGrey.shade50,
          border: Border.all(color: Colors.blueGrey),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.blueGrey,
                ),
                child: const Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                    'MOST POPULAR',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              isfrom=='project'?
              const Text(
                'Post Upcoming Project',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ): const Text(
                'Post Offer',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              isfrom=='project'&& isOffer == 'no_limit'
                  ? const Text(
                "You have exceeded the limit for posting upcoming projects under your current plan. "
                    "To continue using this feature, please consider upgrading or "
                    "updating your plan.",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                ),
              )
                  : isfrom=='project'&& isOffer == 'no'?
              const Text(
                'To post your upcoming project, please upgrade your plan. Plan purchase is required to proceed with project postings.',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ):SizedBox(),
              isfrom=='offer'&& isOffer == 'no_limit'
                  ? const Text(
                "You have exceeded the limit for posting offer under your current plan. "
                    "To continue using this feature, please consider upgrading or "
                    "updating your plan.",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                ),
              )
                  : isfrom=='offer'&& isOffer == 'no'?
              const Text(
                'To post your offers, please upgrade your plan. Plan purchase is required to proceed with offer postings.',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ):SizedBox(),
              const SizedBox(height: 10),
              InkWell(
                onTap: () {
                  Get.to(SubscriptionScreen());
                },
                child: const Text(
                  'Upgrade Plans',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.blueGrey,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
