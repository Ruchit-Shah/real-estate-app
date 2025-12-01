import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/common_widgets/height.dart';
import 'package:real_estate_app/global/AppBar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../property_screens/properties_controllers/post_property_controller.dart';



class developerEnquiry extends StatefulWidget {
  final  data;
  const developerEnquiry({super.key,required this.data});

  @override
  State<developerEnquiry> createState() => _developerEnquiryState();
}

class _developerEnquiryState extends State<developerEnquiry> {
  PostPropertyController controller = Get.put(PostPropertyController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.getDeveloperEnquiry(developer_id: widget.data);

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
        body: Obx(
              () => controller.getDeveloperEnquiryList.isEmpty
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
            itemCount: controller.getDeveloperEnquiryList.length,
            itemBuilder: (context, index) {
              final lead = controller.getDeveloperEnquiryList[index];
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
                              child: Icon(Icons.message, color: Colors.green, size: 18),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              lead['message']??"",
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
