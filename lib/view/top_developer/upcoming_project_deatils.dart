import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:real_estate_app/common_widgets/height.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../global/api_string.dart';
import '../../../utils/String_constant.dart';
import '../../../utils/shared_preferences/shared_preferances.dart';
import '../../../utils/text_style.dart';



class upcoming_project_deatils extends StatefulWidget {
  final data;
  final isFrom;

  upcoming_project_deatils({super.key, required this.data,required this.isFrom});

  @override
  State<upcoming_project_deatils> createState() => _upcoming_project_deatilsState();
}

class _upcoming_project_deatilsState extends State<upcoming_project_deatils> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('widget.id==>');



  }


  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width * 1;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              color: Colors.white.withOpacity(0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        child: SizedBox(
                            height: 250.0,
                            width: double.infinity,
                            child:(widget.data['project_image'] != null
                                ? CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl:APIString.imageBaseUrl+widget.data['project_image'],
                              placeholder: (context, url) => Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                            )
                                : Container(
                              color: Colors.grey[400],
                              child: const Center(
                                child: Icon(Icons.image_rounded),
                              ),
                            ))

                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 18.0),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Material(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12.0),
                            child: InkWell(
                              onTap: () => Navigator.pop(context),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Icon(
                                  Icons.arrow_back_ios_outlined,
                                  color:  Colors.white,
                                  size: 25.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(
                          widget.data['project_name'] != null?
                          widget.data['project_name'] ?? "":"",
                          style: const TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                    boxH08(),
                    Text(
                      widget.data['description'] != null?
                      widget.data['description'] ?? "":"",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                      ),),


                        boxH30(),

                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }


}

