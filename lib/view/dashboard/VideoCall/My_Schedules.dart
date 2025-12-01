import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/view/dashboard/VideoCall/video_call_screen.dart';
import '../../../common_widgets/leave_dialog.dart';
import '../../../utils/String_constant.dart';
import '../../../utils/shared_preferences/shared_preferances.dart';
import '../bottom_navbar_screens/profile_screen/profile_controller.dart';

class My_Virtual_Schedules extends StatefulWidget {
  const My_Virtual_Schedules({super.key});

  @override
  State<My_Virtual_Schedules> createState() => _My_Virtual_SchedulesState();
}

class _My_Virtual_SchedulesState extends State<My_Virtual_Schedules> {
  ProfileController profileController = Get.put(ProfileController());
  String user_id='';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserID();
  }

  getUserID() async{
    String? userId = await SPManager.instance.getUserId(USER_ID);
    if(userId!=null){
      user_id=userId;
      // profileController.get_mySchedules_List(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(()=>
       ListView.builder(
        itemCount: profileController.virtual_tours_List.length,
        itemBuilder: (context, index) {
          final tour = profileController.virtual_tours_List[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 5,
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${tour['user_details']['full_name']}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Row(
                        children: [
                          tour['status'] != "Attended" || tour['status'] == "Cancelled"?
                          IconButton(
                            icon: Icon(Icons.videocam, color: Colors.blue, size: 28),
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => videoCallScreen(
                                  channel_name: tour['channel_name'],
                                  agora_token: tour['agora_token'],
                                  tour_id: tour['_id'],
                                  type: 'my_schedule',
                                ),
                              ),
                            ).whenComplete(() => profileController.get_tour_List(page: '1'),)
                          ):SizedBox(),
                          tour['status'] != "Attended" || tour['status'] == "Cancelled"?
                          IconButton(
                            icon: Icon(Icons.cancel, color: Colors.red, size: 28),
                            onPressed: () {
                              showCallLeaveDialog(
                                  context,
                                  'Are you sure you want to cancel this virtual tour?',
                                  'Yes',
                                  'No ', () {
                                profileController.update_tour_Status(tour_id: tour['_id'],Status:'Cancelled',from: 'my_schedule');
                                Navigator.pop(context);
                              });
                              // Cancel action
                            },
                          ):SizedBox(),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Property Name:",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
                  ),
                  Text(
                    "${tour['property_details']['property_name']}, ${tour['property_details']['address']}",
                    style: TextStyle(color: Colors.black87),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Date:",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
                  ),
                  Text(
                    "${tour['schedule_date']}",
                    style: TextStyle(color: Colors.black87),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Timeslot:",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
                  ),
                  Text(
                    "${tour['timeslot']}",
                    style: TextStyle(color: Colors.black87),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [const Text(
                    "Appointment Status:",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
                  ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: tour['status'] == "Attended" ? Colors.green[100] : Colors.red[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "${tour['status']}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: tour['status'] == "Attended" ? Colors.green : Colors.red,
                        ),
                      ),
                    ),]
                    ,)
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
