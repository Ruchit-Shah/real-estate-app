import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/common_widgets/height.dart';
import 'package:real_estate_app/global/AppBar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../property_screens/properties_controllers/post_property_controller.dart';

class propertyEnquiry extends StatefulWidget {
  final  data;
  const propertyEnquiry({super.key,required this.data});

  @override
  State<propertyEnquiry> createState() => _propertyEnquiryState();
}

class _propertyEnquiryState extends State<propertyEnquiry> {
  PostPropertyController controller = Get.put(PostPropertyController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // controller.getPropertyEnquiry(prperty_id: widget.data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        titleName: "Enquiry",
        onTap: () {
          Navigator.pop(context);
        },
      ),
      body:
      Obx(
            () => controller.getProperyEnquiryList.isEmpty
            ? Center(
          child: Text(
            'No enquiry found',
            style: TextStyle(
              fontSize: 16,
              color: Colors.blueGrey,
            ),
          ),
        )
            : ListView.builder(
          itemCount: controller.getProperyEnquiryList.length,
          itemBuilder: (context, index) {
            final lead = controller.getProperyEnquiryList[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 0.1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(width: 0.2),
                ),
                color: Colors.grey.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.blueAccent.withOpacity(0.1),
                            child: Icon(Icons.person, color: Colors.blueAccent, size: 18),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            lead['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.blueGrey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 20, color: Colors.grey),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.green.withOpacity(0.1),
                            child: Icon(Icons.phone, color: Colors.green, size: 18),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            lead['contact_number'],
                            style: const TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.blueGrey,
                              fontSize: 14,
                            ),
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: () {
                              _makePhoneCall(lead['contact_number']);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 14),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Call",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      const Divider(height: 20, color: Colors.grey),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.green.withOpacity(0.1),
                            child: Icon(Icons.email, color: Colors.green, size: 18),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            lead['email'],
                            style: const TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.blueGrey,
                              fontSize: 14,
                            ),
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: () async {
                              final email = lead['email'];
                              final Uri emailLaunchUri = Uri(
                                scheme: 'mailto',
                                path: email,
                                query: encodeQueryParameters({
                                  'subject': 'Response to Your Inquiry',
                                  'body': 'Hello ${lead['name']},',
                                }),
                              );
                              if (await canLaunch(emailLaunchUri.toString())) {
                                await launch(emailLaunchUri.toString());
                              } else {
                                print('Could not launch $emailLaunchUri');
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 14),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Email",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 20, color: Colors.grey),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.green.withOpacity(0.1),
                            child: Icon(Icons.calendar_month_outlined, color: Colors.green, size: 18),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            lead['time_date']??"",
                            style: const TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.blueGrey,
                              fontSize: 14,
                            ),
                          ),

                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      )

      // Obx(
      //       () =>   ListView.builder(
      //         itemCount: controller.getProperyEnquiryList.length,
      //         itemBuilder: (context, index) {
      //           final lead = controller.getProperyEnquiryList[index];
      //           return Padding(
      //               padding: const EdgeInsets.all(8.0),
      //               child: Card(
      //                 elevation: 0.1,
      //                 shape: RoundedRectangleBorder(
      //                     borderRadius: BorderRadius.circular(12),
      //                     side:  BorderSide(width: 0.2)
      //                 ),
      //                 color: Colors.grey.shade50,
      //                 child: Padding(
      //                   padding: const EdgeInsets.all(20.0),
      //                   child: Column(
      //                     crossAxisAlignment: CrossAxisAlignment.start,
      //                     children: [
      //                       Row(
      //                         children: [
      //                           CircleAvatar(
      //                             radius: 12,
      //                             backgroundColor: Colors.blueAccent.withOpacity(0.1),
      //                             child: Icon(Icons.person, color: Colors.blueAccent, size: 18),
      //                           ),
      //                           const SizedBox(width: 12),
      //                           Text(
      //                           lead['name'],
      //                             style: const TextStyle(
      //                               fontWeight: FontWeight.normal,
      //                               color: Colors.blueGrey,
      //                               fontSize: 14,
      //                             ),
      //                           ),
      //                         ],
      //                       ),
      //                       const Divider(height: 20, color: Colors.grey),
      //                       // Phone with Icon
      //                       Row(
      //                         children: [
      //                           CircleAvatar(
      //                             radius: 12,
      //                             backgroundColor: Colors.green.withOpacity(0.1),
      //                             child: Icon(Icons.phone, color: Colors.green, size: 18),
      //                           ),
      //                           const SizedBox(width: 12),
      //                           Text(
      //                             lead['contact_number'],
      //                             style: const TextStyle(
      //                               fontWeight: FontWeight.normal,
      //                               color: Colors.blueGrey,
      //                               fontSize: 14,
      //                             ),
      //                           ),
      //                           GestureDetector(
      //                             onTap: () {
      //                               _makePhoneCall(lead['contact_number']);
      //                             },
      //                             child: Container(
      //                               padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 14),
      //                               decoration: BoxDecoration(
      //                                 color: Colors.green.withOpacity(0.8),
      //                                 borderRadius: BorderRadius.circular(12),
      //                               ),
      //                               child: const Row(
      //                                 mainAxisSize: MainAxisSize.min,
      //                                 children: [
      //                                   Text(
      //                                     "Call",
      //                                     style: TextStyle(
      //                                       color: Colors.white,
      //                                       fontWeight: FontWeight.bold,
      //                                       fontSize: 14,
      //                                     ),),
      //                                 ],
      //                               ),
      //                             ),
      //                           )
      //                         ],
      //                       ),
      //                       const Divider(height: 20, color: Colors.grey),
      //                       Row(
      //                         children: [
      //                           CircleAvatar(
      //                             radius: 12,
      //                             backgroundColor: Colors.green.withOpacity(0.1),
      //                             child: Icon(Icons.email, color: Colors.green, size: 18),
      //                           ),
      //                           const SizedBox(width: 12),
      //                           Text(
      //                             lead['email'],
      //                             style: const TextStyle(
      //                               fontWeight: FontWeight.normal,
      //                               color: Colors.blueGrey,
      //                               fontSize: 14,
      //                             ),
      //                           ),
      //                           GestureDetector(
      //                             onTap: () async {
      //                               final email = lead['email'];
      //                               final Uri emailLaunchUri = Uri(
      //                                 scheme: 'mailto',
      //                                 path: email,
      //                                 query: encodeQueryParameters({
      //                                   // 'subject': 'Revert Back to your Enquiry',
      //                                   // 'body': '${'Hello '+lead['name']},',
      //                                   'subject': 'Response to Your Inquiry',
      //                                   'body': '${'Hello '+lead['name']},',
      //
      //                                 }),
      //                               );
      //                               if (await canLaunch(emailLaunchUri.toString())) {
      //                                 await launch(emailLaunchUri.toString());
      //                               } else {
      //                                 print('Could not launch $emailLaunchUri');
      //                               }
      //                             },
      //                             child: Container(
      //                               padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 14),
      //                               decoration: BoxDecoration(
      //                                 color: Colors.green.withOpacity(0.8),
      //                                 borderRadius: BorderRadius.circular(12),
      //                               ),
      //                               child: const Row(
      //                                 mainAxisSize: MainAxisSize.min,
      //                                 children: [
      //                                   Text(
      //                                     "Email",
      //                                     style: TextStyle(
      //                                       color: Colors.white,
      //                                       fontWeight: FontWeight.bold,
      //                                       fontSize: 14,
      //                                     ),
      //                                   ),
      //                                 ],
      //                               ),
      //                             ),
      //                           ),
      //
      //
      //                         ],
      //                       ),
      //                       // BHK Interested with Icon
      //                       const Divider(height: 20, color: Colors.grey),
      //                       // Interested Date with Icon
      //                       // Row(
      //                       //   children: [
      //                       //     CircleAvatar(
      //                       //       radius: 12,
      //                       //       backgroundColor: Colors.redAccent.withOpacity(0.1),
      //                       //       child: Icon(Icons.calendar_today, color: Colors.redAccent, size: 18),
      //                       //     ),
      //                       //     const SizedBox(width: 12),
      //                       //     RichText(
      //                       //       text: TextSpan(
      //                       //         text: 'Date: ',
      //                       //         style: const TextStyle(
      //                       //           fontWeight: FontWeight.bold,
      //                       //           fontSize: 14,
      //                       //           color: Colors.black87,
      //                       //         ),
      //                       //         children: [
      //                       //           TextSpan(
      //                       //             text: lead['interestedDate'],
      //                       //             style: const TextStyle(
      //                       //               fontWeight: FontWeight.normal,
      //                       //               color: Colors.blueGrey,
      //                       //               fontSize: 14,
      //                       //             ),
      //                       //           ),
      //                       //         ],
      //                       //       ),
      //                       //     ),
      //                       //     Spacer(),
      //                       //     Row(
      //                       //       children: [
      //                       //         CircleAvatar(
      //                       //           radius: 12,
      //                       //           backgroundColor: Colors.redAccent.withOpacity(0.1),
      //                       //           child: Icon(Icons.watch_later_outlined, color: Colors.redAccent, size: 18),
      //                       //         ),
      //                       //         boxW05(),
      //                       //         Text(lead['time'],
      //                       //           style: TextStyle(
      //                       //             fontWeight: FontWeight.bold,
      //                       //             fontSize: 14,
      //                       //             color: Colors.black87,
      //                       //           ),
      //                       //         ),
      //                       //       ],
      //                       //     ),
      //                       //   ],
      //                       // ),
      //                     ],
      //                   ),
      //                 ),
      //               )
      //           );
      //         },
      //       ),
      // )

    );
  }
   _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }
  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

}
