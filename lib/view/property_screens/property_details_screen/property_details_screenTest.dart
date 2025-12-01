import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:real_estate_app/common_widgets/height.dart';
import 'package:url_launcher/url_launcher.dart';

class PropertyDetailsScreenTest extends StatefulWidget {
  const PropertyDetailsScreenTest({
    super.key,
  });

  @override
  State<PropertyDetailsScreenTest> createState() => _PropertyDetailsScreenTestState();
}

class _PropertyDetailsScreenTestState extends State<PropertyDetailsScreenTest> {
  final PageController _controller = PageController(initialPage: 0);
  double latitude = 18.5630093, longitude = 73.7835006;

  GoogleMapController? mapController;
  LatLng initialCameraPosition = LatLng(18.563720, -73.783400); //balewadi fhata

  List<Amenity> amenitiesList = [
    Amenity(icon: Icons.pool, title: 'Pool'),
    Amenity(icon: Icons.fitness_center, title: 'Gym'),
    Amenity(icon: Icons.spa, title: 'Spa'),
    Amenity(icon: Icons.emoji_transportation, title: 'Transport'),
    Amenity(icon: Icons.wifi, title: 'Wifi'),
    Amenity(icon: Icons.elevator_outlined, title: 'Elevator')
  ];

  bool _showFullText = false;

  final PageController _pageController = PageController();
  int _currentIndex = 0;
  final List<String> imgList = [
    'assets/recommended_img/imgbed1.png',
    'assets/recommended_img/imgbed2.jpeg',
    'assets/recommended_img/imgbed3.jpeg',
    'assets/recommended_img/imgbed5.jpeg',
    'assets/recommended_img/imgbed6.jpeg',
    'assets/recommended_img/imgbed7.jpeg',
  ];

  void _toggleShowFullText() {
    setState(() {
      _showFullText = !_showFullText;
    });
  }

  bool _isFavorited = false;

  void _toggleFavorite() {
    setState(() {
      _isFavorited = !_isFavorited;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width * 1;
    final _height = MediaQuery.of(context).size.height * 1;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              color: Colors.white.withOpacity(0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      /// Full-width image slider imp code don't delete it
                      // ClipRRect(
                      //   borderRadius: BorderRadius.only(
                      //     topLeft: Radius.circular(10.0),
                      //     topRight: Radius.circular(10.0),
                      //   ),
                      //   child: SizedBox(
                      //     height: 250.0,
                      //     width: double.infinity,
                      //     child: PageView(
                      //       controller:
                      //           _controller,
                      //       children: [
                      //         Image.asset(
                      //           'assets/recommended_img/imgbed1.png',
                      //           fit: BoxFit.cover,
                      //         ),
                      //         Image.asset(
                      //           'assets/recommended_img/imgbed2.jpeg',
                      //           fit: BoxFit.cover,
                      //         ),
                      //         Image.asset(
                      //           'assets/recommended_img/imgbed3.jpeg',
                      //           fit: BoxFit.cover,
                      //         ),
                      //         Image.asset(
                      //           'assets/recommended_img/imgbed5.jpeg',
                      //           fit: BoxFit.cover,
                      //         ),
                      //         Image.asset(
                      //           'assets/recommended_img/imgbed6.jpeg',
                      //           fit: BoxFit.cover,
                      //         ),
                      //         Image.asset(
                      //           'assets/recommended_img/imgbed7.jpeg',
                      //           fit: BoxFit.cover,
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),

                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                        ),
                        child: SizedBox(
                          height: 250.0,
                          width: double.infinity,
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: imgList.length,
                            onPageChanged: (index) {
                              setState(() {
                                _currentIndex = index;
                              });
                            },
                            itemBuilder: (context, index) {
                              return Image.asset(
                                imgList[index],
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                        ),
                      ),
                      Positioned(
                        top: 30.0,
                        left: 0.0,
                        right: 0.0,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Back button
                              Material(
                                color: Colors.white.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(12.0),
                                child: InkWell(
                                  onTap: () => Navigator.pop(context),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Icon(
                                      Icons.arrow_back_ios_outlined,
                                      color: Colors.blue.withOpacity(0.5),
                                      size: 25.0,
                                    ),
                                  ),
                                ),
                              ),

                              Spacer(),
                              // Favorite button
                              Material(
                                color: Colors.white.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(12.0),
                                child: InkWell(
                                  onTap: _toggleFavorite,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: AnimatedContainer(
                                      duration: Duration(milliseconds: 300),
                                      child: Icon(
                                        _isFavorited
                                            ? Icons.favorite
                                            : Icons.favorite_border_outlined,
                                        color: _isFavorited
                                            ? Colors.red.withOpacity(0.7)
                                            : Colors.blue.withOpacity(0.7),
                                        size: 25.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  boxH05(),
                  // ListView for smaller images
                  Container(
                    height: 60.0,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: imgList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            _pageController.animateToPage(
                              index,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                            setState(() {
                              _currentIndex = index;
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: _currentIndex == index
                                    ? Colors.blue
                                    : Colors.transparent,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5.0),
                              child: Image.asset(
                                imgList[index],
                                fit: BoxFit.cover,
                                width: 80.0,
                                height: 80.0,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Innovation Classic Duo",
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              color: Colors.grey,
                              size: 21.0,
                            ),
                            Text(
                              'Ganesh Nagar, Baner, Pune',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        boxH10(),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Price Details",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  '₹23,000 /Month (₹ 46.0 k Deposit)',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black),
                                ),
                              ],
                            ),
                          ],
                        ),
                        boxH20(),

                        /// Amenities
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                'Amenities',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                                width: _width,
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: Colors.grey.withOpacity(0.2)),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                color: Colors.green
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Icon(
                                                Icons.wifi,
                                                size: 24,
                                                color: Colors.black
                                                    .withOpacity(0.6),
                                              ),
                                            ),
                                            boxW10(),
                                            Text(
                                              'Wifi',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black
                                                    .withOpacity(0.8),
                                              ),
                                            ),
                                          ],
                                        ),
                                        boxH20(),
                                        Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                color: Colors.green
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Icon(
                                                Icons.elevator_outlined,
                                                size: 24,
                                                color: Colors.black
                                                    .withOpacity(0.6),
                                              ),
                                            ),
                                            boxW10(),
                                            Text(
                                              'Elevator',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black
                                                    .withOpacity(0.8),
                                              ),
                                            ),
                                          ],
                                        ),
                                        boxH20(),
                                        Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                color: Colors.green
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Icon(
                                                Icons.tv, // Icon for TV
                                                size: 24,
                                                color: Colors.black
                                                    .withOpacity(0.6),
                                              ),
                                            ),
                                            boxW10(),
                                            Text(
                                              'TV',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black
                                                    .withOpacity(0.8),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    boxW10(),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                color: Colors.green
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Icon(
                                                Icons.emoji_transportation,
                                                size: 24,
                                                color: Colors.black
                                                    .withOpacity(0.6),
                                              ),
                                            ),
                                            boxW10(),
                                            Text(
                                              'Transport',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black
                                                    .withOpacity(0.8),
                                              ),
                                            ),
                                          ],
                                        ),
                                        boxH20(),
                                        Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                color: Colors.green
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Icon(
                                                Icons.pool,
                                                size: 24,
                                                color: Colors.black
                                                    .withOpacity(0.6),
                                              ),
                                            ),
                                            boxW10(),
                                            Text(
                                              'Pool',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black
                                                    .withOpacity(0.8),
                                              ),
                                            ),
                                          ],
                                        ),
                                        boxH20(),
                                        Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                color: Colors.green
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Icon(
                                                Icons
                                                    .ac_unit, // Icon for Air Conditioner
                                                size: 24,
                                                color: Colors.black
                                                    .withOpacity(0.6),
                                              ),
                                            ),
                                            boxW10(),
                                            Text(
                                              'Air Conditioned',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black
                                                    .withOpacity(0.8),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                )

                                ///using a wrap
                                // Wrap(
                                //   spacing: 30,
                                //   runSpacing: 10,
                                //   children: [
                                //     for (Amenity amenity in amenitiesList) amenityCard(amenity),
                                //   ],
                                // ),
                                /// using gridview builder
                                // GridView.builder(
                                //   shrinkWrap: true,
                                //   physics: NeverScrollableScrollPhysics(),
                                //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                //     crossAxisCount: 3,
                                //     mainAxisSpacing: 0,
                                //     crossAxisSpacing: 0,
                                //   ),
                                //   itemCount: amenitiesList.length,
                                //   itemBuilder: (context, index) {
                                //     return amenityCard(amenitiesList[index]);
                                //   },
                                // ),
                                ),
                          ],
                        ),
                        boxH10(),

                        /// about this property commented
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'About this property',
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                            boxH10(),
                            Text(
                                'Address : NR. Dhr International school, Ganesh Nagar, Baner, Pune'),
                            boxH10(),
                            Text(
                              _showFullText
                                  ? 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, '
                                      'sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,'
                                      ' quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.'
                                      ' Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.'
                                      ' Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'
                                  : 'Lorem ipsum dolor sit amet, consectetur adipiscing elit...',
                              maxLines: _showFullText ? null : 2,
                            ),
                            if (!_showFullText)
                              TextButton(
                                onPressed: _toggleShowFullText,
                                child: Text(
                                  'Read more',
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                          ],
                        ),
                        boxH20(),

                        /// Nearby Facilities
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Nearby Facilities',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            boxH15(),
                            const FacilityCard(
                              icon: Icons.school,
                              title: 'Schools',
                              details:
                                  'XYZ International School, ABC High School',
                            ),
                            boxH15(),
                            const FacilityCard(
                              icon: Icons.local_hospital,
                              title: 'Hospitals',
                              details: 'City Hospital, ABC Clinic',
                            ),
                            boxH15(),
                            const FacilityCard(
                              icon: Icons.shopping_cart,
                              title: 'Supermarkets',
                              details: 'XYZ Supermarket, ABC Store',
                            ),
                          ],
                        ),
                        boxH20(),

                        /// Location
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {},
                              child: const Text(
                                'Location',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            boxH10(),
                            Container(
                              height: 180,
                              child: GoogleMap(
                                initialCameraPosition: CameraPosition(
                                  target: LatLng(latitude, longitude),
                                  zoom: 10,
                                ),
                                onMapCreated: (GoogleMapController controller) {
                                  mapController = controller;
                                },
                                markers: {
                                  Marker(
                                    markerId: MarkerId('property_location'),
                                    position: initialCameraPosition,
                                    infoWindow:
                                        InfoWindow(title: 'Property Location'),
                                  ),
                                },
                              ),
                            ),
                          ],
                        ),
                        boxH10(),
                        GestureDetector(
                          onTap: () {
                            _makePhoneCall('7741913454');
                          },
                          child: Container(
                            width: _width,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.blueAccent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.call, color: Colors.white),
                                SizedBox(width: 8),
                                Text(
                                  'Call Now for Location Info',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        boxH50(),
                        boxH50(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            right: 5,
            left: 5,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.withOpacity(0.4))),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 5.0, right: 5),
                              child: CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.blue.withOpacity(0.5),
                                child: IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.person_outline,
                                      size: 20, color: Colors.black),
                                ),
                              ),
                            ),
                            boxW05(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Varun Wale',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  'Owner',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        // Contact row
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
                                onTap: () {
                                  _makePhoneCall('+91123-456-7890');
                                },
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.asset(
                                      'assets/phone .png',
                                      width: 40,
                                      height: 35,
                                    ),
                                  ),
                                  elevation: 0.3,
                                  color: Colors.white.withOpacity(0.8),
                                ),
                              ),
                              boxW20(),
                              Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        'assets/chatbotNew.png',
                                        width: 40,
                                        height: 35,
                                      ),
                                    ],
                                  ),
                                ),
                                elevation: 0.3,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget amenityCard(Amenity amenity) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              amenity.icon,
              size: 24,
              color: Colors.black.withOpacity(0.6),
            ),
          ),
          SizedBox(width: 8),
          Text(
            amenity.title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}

class Amenity {
  final IconData icon;
  final String title;

  Amenity({required this.icon, required this.title});
}

class FacilityCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String details;

  const FacilityCard({
    required this.icon,
    required this.title,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.blue.withOpacity(0.1),
            child: Icon(icon, size: 25, color: Colors.blue),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  details,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
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

Future<void> _makePhoneCall(String phoneNumber) async {
  final Uri launchUri = Uri(
    scheme: 'tel',
    path: phoneNumber,
  );
  await launchUrl(launchUri);
}
