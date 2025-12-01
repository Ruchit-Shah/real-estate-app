import 'package:flutter/material.dart';

class DeveloperInfoCard extends StatelessWidget {
  final String developerName;
  final String developerGroup;
  final int establishmentYear;
  final String location;
  final String priceRange;

  DeveloperInfoCard({
    required this.developerName,
    required this.developerGroup,
    required this.establishmentYear,
    required this.location,
    required this.priceRange,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.group, color: Colors.blue),
                SizedBox(width: 10),
                Text(
                  '$developerGroup',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.blue),
                SizedBox(width: 10),
                Text(
                  '$establishmentYear',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.blue),
                SizedBox(width: 10),
                Text(
                  '$location',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.monetization_on, color: Colors.blue),
                SizedBox(width: 10),
                Text(
                  '$priceRange',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
