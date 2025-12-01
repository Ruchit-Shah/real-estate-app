import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/global/app_color.dart';

import '../dashboard/bottom_navbar_screens/CustomBottomNavBar.dart';
import 'notification_controller.dart';

class NotificationList extends StatefulWidget {
  const NotificationList({super.key});

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  final notificationController Controller = Get.put(notificationController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Controller.getNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          backgroundColor: AppColor.white,
          automaticallyImplyLeading: false,
          leading: Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 8.0, bottom: 8.0, right: 8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.black.withOpacity(0.2),width: 0.3)
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon:  Icon(
                  Icons.arrow_back_outlined,
                    color: Colors.black.withOpacity(0.7)
                ),
              ),
            ),
          ),centerTitle: true,
          title: const Text(
            'Notification',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        body:  Stack(children: [
          Obx(
                () => Controller.getNotificationList.isEmpty
                ? const Center(
              child: Text(
                'No notification found',
                style: TextStyle(fontSize: 16, color: Colors.blueGrey),
              ),
            )
                : ListView.builder(
              padding: EdgeInsets.only(left: 12, right: 12, bottom: 64,top: 6),
              itemCount: Controller.getNotificationList.length,
              itemBuilder: (context, index) {
                final notification = Controller.getNotificationList[index];

                return Container(
                  margin: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 0.1,
                        spreadRadius: 0.1,
                        offset: Offset(0, 0.3),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(12),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        'assets/Houzza.png', // Change to actual image path
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      notification['notification_title'] ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:  TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black.withOpacity(0.8), // Theme color
                      ),
                    ),  subtitle: const Text(
                    '20 Mar, 2025',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                    // subtitle: Text(
                    //   notification['message'] ?? '',
                    //   maxLines: 2,
                    //   overflow: TextOverflow.ellipsis,
                    //   style: TextStyle(fontSize: 14, color: Colors.black87),
                    // ),
                    trailing: const Icon(
                      Icons.arrow_forward_outlined,
                      color: Colors.black,
                      size: 18,
                    ),
                    onTap: () {
                      // Handle navigation
                    },
                  ),
                );
              },
            ),
          ),

          const Positioned(
            bottom: 0,
            left: 5,
            right: 5,
            child: CustomBottomNavBar(),
          ),
        ],)
    );
  }
}
