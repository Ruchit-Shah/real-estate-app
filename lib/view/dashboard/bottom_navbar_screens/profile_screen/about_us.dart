
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

import 'package:real_estate_app/common_widgets/height.dart';

import 'package:real_estate_app/global/constant.dart';

import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/profile_screen/profile_controller.dart';


class AboutUs extends StatefulWidget {
  final String isFrom;
  AboutUs({Key? key,required this.isFrom, }) : super(key: key);

  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  ProfileController profileController = Get.put(ProfileController());

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    if(widget.isFrom=='about_us'){
      await profileController.getAboutUs();
    }else if(widget.isFrom=='faq'){
      await profileController.getFaq();

    }else if(widget.isFrom=='policy'){
      await profileController.getPrivacyPolicy();

    }else if(widget.isFrom=='TandC'){
      await profileController.getTandC();
    }
    else if(widget.isFrom=='setting'){
      await profileController.getTandC();
    }
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {});
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey.shade50,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.arrow_back, size: 24),
            ),
            boxW15(),
            Text(
              widget.isFrom=='about_us'?
              'About Us':
              widget.isFrom=='faq'?
              'FAQ':
              widget.isFrom=='policy'?
              'Privacy Policy':
              widget.isFrom=='TandC'?
              'T&C':'',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black.withOpacity(0.7),
                fontFamily: 'Roboto',
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
         crossAxisAlignment: CrossAxisAlignment.center,
         children: [
           boxH05(),
           SingleChildScrollView(
             child: Column(
               mainAxisAlignment: MainAxisAlignment.start,
               children: [
                 Container(
                     margin:
                     const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 5),
                     child:
                     Html(
                         data:profileController.content ?? "No data available"
                     )
                 )
               ],
             ),
           )
         ],
        ),
      ),
    );
  }
}
