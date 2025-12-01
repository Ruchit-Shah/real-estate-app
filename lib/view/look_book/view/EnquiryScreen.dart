import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../global/AppBar.dart';
import 'FullMessageScreen.dart';
import 'enquiry_controller.dart';

class EnquiryScreen extends StatefulWidget {
  final String productId;
  final String userId;
   EnquiryScreen({Key? key,required this.productId,required this.userId}) : super(key: key);

  @override
  _EnquiryScreenState createState() => _EnquiryScreenState();
}

class _EnquiryScreenState extends State<EnquiryScreen> {
  final EnquiryController enquiryController = Get.put(EnquiryController());

  @override
  void initState() {
    super.initState();
    enquiryController.fetchEnquiries(widget.productId,widget.userId);
    print('productid: '+widget.productId);
    print('user id'+widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(titleName: 'Enquiries'),
      body: Obx(() {
        if (enquiryController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        if (enquiryController.enquiries.isEmpty) {
          return Center(child: Text('No enquiries found'));
        }
        return ListView.builder(
          itemCount: enquiryController.enquiries.length,
          itemBuilder: (context, index) {
            final enquiry = enquiryController.enquiries[index];
            return Card(
              margin: EdgeInsets.all(12),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide(width: 1, color: Colors.grey[300]!),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Customer Name: ${enquiry['customer_name'] ?? 'N/A'}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Contact: ${enquiry['customer_contact'] ?? 'N/A'}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                          SizedBox(height: 8),
                          enquiry['message'].length > 100
                              ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Message: ${enquiry['message'].substring(0, 100)}...',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 4),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FullMessageScreen(
                                        message: enquiry['message'],
                                      ),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Read More',
                                  style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          )
                              : Text(
                            'Message: ${enquiry['message'] ?? 'N/A'}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Date: ${enquiry['register_date'] ?? 'N/A'}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 12),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FullMessageScreen(
                              message: enquiry['message'],
                            ),
                          ),
                        );
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.visibility,
                            color: Colors.blueAccent,
                            size: 24,
                          ),
                          SizedBox(height: 4),
                          Text(
                            'View',
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );

          },
        );
      }),
    );
  }
}


