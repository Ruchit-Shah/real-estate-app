import 'package:flutter/material.dart';

class TopRatedDeveloperWidget extends StatelessWidget {
  final List<DeveloperProperty> developerProperties;

  const TopRatedDeveloperWidget({
    Key? key,
    required this.developerProperties,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 350,
            width: MediaQuery.of(context).size.width  * 1,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: developerProperties.length,
              itemBuilder: (context, index) {
                final property = developerProperties[index];
                return DeveloperPropertyCard(property: property);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DeveloperPropertyCard extends StatelessWidget {
  final DeveloperProperty property;

  const DeveloperPropertyCard({Key? key, required this.property}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      width: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            child: Container(
              height:200,
              width: MediaQuery.of(context).size.width * 1,
              child: Image.asset(
                property.image,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  property.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  property.location,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '₹ ${property.price}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DeveloperProperty {
  final String name;
  final String location;
  final String image;
  final int price;

  DeveloperProperty({
    required this.name,
    required this.location,
    required this.image,
    required this.price,
  });
}
