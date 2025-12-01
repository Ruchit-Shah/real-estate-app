import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:real_estate_app/common_widgets/height.dart';
import 'package:real_estate_app/common_widgets/loading_dart.dart';
import 'package:real_estate_app/global/app_color.dart';
import 'package:real_estate_app/view/property_screens/agent_profile.dart';
import 'package:real_estate_app/view/property_screens/properties_controllers/post_property_controller.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class GetScheduleBottomSheet extends StatefulWidget {
  String? name;
  String? userType;
  String? propertyID;
  String? propertyOwnerID;
  String? tour_type;
  String? image;
   GetScheduleBottomSheet({super.key,this.name,this.userType,this.propertyID,this.propertyOwnerID,this.tour_type,this.image});

  @override
  State<GetScheduleBottomSheet> createState() => _GetScheduleBottomSheetState();
}

class _GetScheduleBottomSheetState extends State<GetScheduleBottomSheet> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = const TimeOfDay(hour: 9, minute: 30);
  final propertyController = Get.find<PostPropertyController>();
  final Uuid uuid = Uuid();
  late String channelID;
@override
  void initState() {
    super.initState();
    channelID = uuid.v4();
  }

  // void _pickTime(BuildContext context) async {
  //   TimeOfDay? pickedTime = await showTimePicker(
  //     context: context,
  //     initialTime: _selectedTime,
  //
  //   );
  //   if (pickedTime != null && pickedTime != _selectedTime) {
  //     setState(() {
  //       _selectedTime = pickedTime;
  //       print('picked time : $_selectedTime');
  //     });
  //   }
  // }
  void _pickTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (BuildContext context, Widget? child) {
        // Force 12-hour format with AM/PM toggle
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );

    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
        print('Picked time: $_selectedTime');
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.9,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Column(
          mainAxisSize: MainAxisSize.max, // Ensure Column takes full height
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Push last widget to bottom
          children: [
            // Top content (Header, Calendar, Time Picker)
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Header
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Get.back();
                          },
                          borderRadius: BorderRadius.circular(50),
                          child: const Padding(
                            padding: EdgeInsets.all(6),
                            child: Icon(
                              Icons.arrow_back_outlined,
                              size: 18,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const Expanded(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Get Schedule",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                    boxH10(),

                    /// Select Date Title
                    const Text("Select Date",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),

                    /// Calendar Widget
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: TableCalendar(
                        firstDay: DateTime.utc(2020, 1, 1),
                        lastDay: DateTime.utc(2030, 12, 31),
                        focusedDay: _selectedDate,
                        selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
                        onDaySelected: (selectedDay, focusedDay) {
                          if (selectedDay.isAfter(DateTime.now().subtract(const Duration(days: 1)))) {
                            setState(() {
                              _selectedDate = selectedDay;
                              print('selected date :$_selectedDate');
                            });
                          }
                        },
                        calendarFormat: CalendarFormat.month,
                        headerStyle: const HeaderStyle(
                          formatButtonVisible: false,
                          titleCentered: true,
                        ),
                        availableGestures: AvailableGestures.all,
                        enabledDayPredicate: (day) {
                          // Disable past days
                          return day.isAfter(DateTime.now().subtract(const Duration(days: 1)));
                        },
                        calendarStyle: CalendarStyle(
                          selectedDecoration: const BoxDecoration(
                            color: AppColor.primaryThemeColor,
                            shape: BoxShape.circle,
                          ),
                          todayDecoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            shape: BoxShape.circle,
                          ),
                          disabledTextStyle: TextStyle(color: Colors.grey.shade400),
                        ),
                      ),
                    ),
                    boxH20(),

                    /// Select Time Title
                    const Text("Select Time",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),

                    boxH10(),

                    /// Time Picker
                    GestureDetector(
                      onTap: () => _pickTime(context),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _selectedTime.format(context),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// Bottom Row (Agent + Button) - Sticks to Bottom
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /// Left Side: Avatar + Name + Agent Label
                  // Row(
                  //   children: [
                  //     CircleAvatar(
                  //       backgroundColor: Colors.purple.shade50,
                  //       radius:24,
                  //       child: Padding(
                  //         padding: const EdgeInsets.all(8.0),
                  //         child: Image.asset('assets/image_rent/profileImg.png'),
                  //       ),
                  //     ),
                  //     boxW08(),
                  //     //  Column(
                  //     //   crossAxisAlignment: CrossAxisAlignment.start,
                  //     //   children: [
                  //     //     Text(
                  //     //      widget.name ??  'unknown',
                  //     //       style: const TextStyle(
                  //     //         fontWeight: FontWeight.bold,
                  //     //         fontSize: 16.0,
                  //     //         color: Colors.black,
                  //     //       ),
                  //     //     ),
                  //     //     Text(
                  //     //       widget.userType ??  "N/A",
                  //     //       style: const TextStyle(
                  //     //         fontSize: 14.0,
                  //     //       ),
                  //     //     ),
                  //     //   ],
                  //     // ),
                  //     Column(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         Text(
                  //           widget.name ??  'unknown',
                  //           style: const TextStyle(
                  //             fontWeight: FontWeight.bold,
                  //             fontSize: 16.0,
                  //             color: Colors.black,
                  //           ),
                  //           maxLines: 2, // Allow 2 lines
                  //           overflow: TextOverflow.ellipsis,
                  //         ),
                  //         Text(
                  //           widget.userType ??  "N/A",
                  //           style: const TextStyle(
                  //             fontSize: 14.0,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ],
                  // ),
                  Expanded(
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            // Get.to(agent_profile(
                            //   agent_name:  widget.name ?? "",
                            //   agent_id:widget.propertyID ?? "",
                            // ));
                          },

                          child: CircleAvatar(
                            radius: 24,
                            backgroundImage: (  widget.image != null &&
                                widget.image!.isNotEmpty &&
                                widget.image  != null &&
                                widget.image .toString().isNotEmpty)
                                ? CachedNetworkImageProvider(
                              widget.image.toString(),
                            )
                                : null,
                            backgroundColor: AppColor.grey.withOpacity(0.1),
                            child: ( widget.image  == null ||
                                widget.image !.isEmpty ||
                                widget.image ! == null ||
                                widget.image .toString().isEmpty)
                                ? ClipOval(
                              child: Image.asset(
                                'assets/image_rent/profile.png',
                                width: 30,
                                height: 30,
                                fit: BoxFit.cover,
                              ),
                            )
                                : null,
                          ),
                        ),
                        boxW08(),
                        /// Wrap text here using Expanded or Flexible
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.name ??  'unknown',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                  color: Colors.black,
                                ),
                                maxLines: 2, // Allow 2 lines
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                widget.userType ??  "N/A",
                                style: const TextStyle(
                                  fontSize: 14.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  /// Right Side: Custom Button
                  commonButton(
                    width: 150,
                    height: 60,
                    buttonColor: AppColor.lightPurple,
                    text: 'Get Schedule',
                    textStyle: const TextStyle(fontSize: 14, color: Colors.white),
                    // onPressed: () {
                    //   final formattedTime = _selectedTime.format(context); // e.g., "9:30 AM"
                    //   final parts = formattedTime.split(' '); // ['9:30', 'AM']
                    //   final timeOnly = parts[0]; // "9:30"
                    //   final timeUnit = parts.length > 1 ? parts[1] : ''; // "AM" or "PM"
                    //   print(timeOnly);
                    //   print(timeUnit);
                    //   print(DateFormat('yyyy/MM/dd').format(_selectedDate));
                    //
                    //   propertyController.add_virtual_tour(
                    //       property_owner_id: widget.propertyOwnerID,
                    //       schedule_date: DateFormat('yyyy-MM-dd').format(_selectedDate),
                    //       timeslot: timeOnly,
                    //       channel_name: channelID,
                    //       tour_type: widget.tour_type,
                    //       time_unit: timeUnit,
                    //       property_id: widget.propertyID);
                    // },
                      onPressed: () {
                        final formattedTime = _selectedTime.format(context); // "9:30 AM" or "21:30"
                        final is24HourFormat = MediaQuery.of(context).alwaysUse24HourFormat;

                        String timeOnly = formattedTime;
                        String timeUnit = '';

                        if (!is24HourFormat) {
                          final parts = formattedTime.split(' ');
                          timeOnly = parts[0];
                          timeUnit = parts.length > 1 ? parts[1] : '';
                        } else {
                          // Convert 24-hour time to 12-hour manually
                          final hour = _selectedTime.hour;
                          final minute = _selectedTime.minute.toString().padLeft(2, '0');
                          final hour12 = hour % 12 == 0 ? 12 : hour % 12;
                          timeOnly = '$hour12:$minute';
                          timeUnit = hour >= 12 ? 'PM' : 'AM';
                        }

                        print(timeOnly);
                        print(timeUnit);
                        print(DateFormat('yyyy/MM/dd').format(_selectedDate));

                        propertyController.add_virtual_tour(
                          property_owner_id: widget.propertyOwnerID,
                          schedule_date: DateFormat('yyyy-MM-dd').format(_selectedDate),
                          timeslot: timeOnly,
                          channel_name: channelID,
                          tour_type: widget.tour_type,
                          time_unit: timeUnit,
                          property_id: widget.propertyID,
                        );
                      }

                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}

