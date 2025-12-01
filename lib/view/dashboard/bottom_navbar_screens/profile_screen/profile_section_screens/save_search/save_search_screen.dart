import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/Routes/app_pages.dart';
import 'package:real_estate_app/common_widgets/custom_container.dart';
import 'package:real_estate_app/common_widgets/height.dart';
import 'package:real_estate_app/global/AppBar.dart';
import 'package:real_estate_app/global/app_color.dart';
import 'package:real_estate_app/global/constant.dart';
import 'package:real_estate_app/view/property_screens/property_search_location/property_search_location_screen.dart';

class SaveSearchScreen extends StatefulWidget {
  const SaveSearchScreen({super.key});

  @override
  State<SaveSearchScreen> createState() => _SaveSearchScreenState();
}

class _SaveSearchScreenState extends State<SaveSearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(titleName: save_search,
        onTap: () {
        Navigator.pop(context);
      },),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Your Haven\'t saved any search yet.'),
              boxH10(),
              CustomContainer(
                width: 150,
                height: 50,borderRadius: 10,
                color: Colors.blue.withOpacity(0.2),
                child: TextButton(
                  onPressed: () {
                    Get.to(Routes.propertySearch);
                  },
                  child: Center(child: Text('Start new Search',style: TextStyle(
                    color: Colors.blue
                  ),)),
                ),
              )
            ],
          )),
    );
  }
}
