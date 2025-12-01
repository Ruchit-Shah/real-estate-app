import 'package:flutter/material.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

class DateRangePickerScreen extends StatefulWidget {
  @override
  _DateRangePickerScreenState createState() => _DateRangePickerScreenState();
}

class _DateRangePickerScreenState extends State<DateRangePickerScreen> {
  DateTime? fromDate;
  DateTime? toDate;

  Future<void> _selectDateRange() async {
    List<DateTime>? picked = await showOmniDateTimeRangePicker(
      context: context,
      startInitialDate: DateTime.now(),
      startFirstDate: DateTime(2020),
      startLastDate: DateTime(2100),
      endInitialDate: DateTime.now().add(Duration(days: 1)),
      endFirstDate: DateTime(2020),
      endLastDate: DateTime(2100),
      is24HourMode: false,
      isShowSeconds: false,
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: true,
    );

    if (picked != null && picked.length == 2) {
      setState(() {
        fromDate = picked[0];
        toDate = picked[1];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String from = fromDate != null ? fromDate!.toLocal().toString().split('.')[0] : 'Select';
    String to = toDate != null ? toDate!.toLocal().toString().split('.')[0] : 'Select';

    return Scaffold(
      appBar: AppBar(
        title: Text('Omni Date Range Picker'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('From: $from'),
            Text('To: $to'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _selectDateRange,
              child: Text('Pick Date Range'),
            ),
          ],
        ),
      ),
    );
  }
}
