import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../auth/login_screen/login_screen.dart';
import '../../splash_screen/splash_screen.dart';
import '../bottom_navbar_screens/profile_screen/profile_controller.dart';
import 'My_Property_Schedules.dart';
import 'My_Schedules.dart';

class VirtualToursPage extends StatefulWidget {

  @override
  State<VirtualToursPage> createState() => _VirtualToursPageState();
}

class _VirtualToursPageState extends State<VirtualToursPage> with SingleTickerProviderStateMixin{

  ProfileController profileController = Get.put(ProfileController());
  late TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(
        length: 2,
        vsync: this);

  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Virtual Tours")),
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
              Tab(text: 'My Tour'),
              Tab(text: 'Scheduled Tour'),
            ],
          ),
          Expanded(
            child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _tabController,
              children:  [
                 My_Virtual_Schedules(),
                 My_Property_Virtual_Schedules(),
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
                    foregroundColor: Colors.white, backgroundColor: Colors.blueGrey,
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
    );
  }
}

