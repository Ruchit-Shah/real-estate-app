import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/common_widgets/custom_textformfield.dart';
import 'package:real_estate_app/common_widgets/height.dart';
import 'package:real_estate_app/global/AppBar.dart';
import 'package:real_estate_app/global/constant.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/profile_screen/profile_controller.dart';

class TimeSlotScreen extends StatefulWidget {
  const TimeSlotScreen({Key? key}) : super(key: key);

  @override
  State<TimeSlotScreen> createState() =>
      _TimeSlotScreenState();
}

class _TimeSlotScreenState extends State<TimeSlotScreen> {

  final TextEditingController _timeController = TextEditingController();
  List<String> timeSlots = [];
  ProfileController profileController = Get.put(ProfileController());

  void _pickTime() async {
    // Select start time
    TimeOfDay? startTime = await _showTimePicker("Select Start Time");

    if (startTime != null) {
      // Select end time
      TimeOfDay? endTime = await _showTimePicker("Select End Time");

      if (endTime != null && _validateTime(startTime, endTime)) {
        // Format the time slots
        String formattedTimeSlot =
            '${_formatTime(startTime)} - ${_formatTime(endTime)}';

        // Add to the list and call the API
        setState(() {
          timeSlots.add(formattedTimeSlot);
        });

        // Call API
        _addTimeToProfile(formattedTimeSlot);
      } else {
        // Show validation error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("End time must be after start time."),
          ),
        );
      }
    }
  }

  Future<TimeOfDay?> _showTimePicker(String title) async {
    return await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light(),
          child: child ?? SizedBox.shrink(),
        );
      },
    );
  }

  bool _validateTime(TimeOfDay startTime, TimeOfDay endTime) {
    final startMinutes = startTime.hour * 60 + startTime.minute;
    final endMinutes = endTime.hour * 60 + endTime.minute;

    return endMinutes > startMinutes;
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';

    return '$hour:$minute $period';
  }

  void _addTimeToProfile(String formattedTimeSlot) {
    // Simulate API call
    print("Adding Time Slot: $formattedTimeSlot");
    profileController.addTime(timeSlot: formattedTimeSlot);
  }

  void _deleteTimeSlot(int index) {
    setState(() {
      profileController.deleteTime(timeSlotId:profileController.timeSlots[index]['_id']);
    });
  }

  @override
  void initState() {
    super.initState();
    profileController.getTime();
  }

  @override
  void dispose() {
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        titleName: edit_profile,
        automaticallyImplyLeading: false,
        onTap: () {
          Navigator.pop(context);
        },
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              boxH10(),
              Text(
                'Add Time Slot',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black.withOpacity(0.7),
                    fontWeight: FontWeight.bold),
              ),
              boxH10(),
              TextField(
                controller: _timeController,
                readOnly: true,
                onTap: _pickTime,
                decoration: const InputDecoration(
                  labelText: 'Add Time',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.access_time),
                ),
              ),
              boxH20(),
              Flexible(
                child: Obx(()=>
                   ListView.builder(
                    itemCount: profileController.timeSlots.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 2,
                        margin: EdgeInsets.symmetric(vertical: 5),
                        child: ListTile(
                          title: Text(profileController.timeSlots[index]['timeslot']),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteTimeSlot(index),
                          ),
                        ),
                      );
                    },
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
