import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/Routes/app_pages.dart';
import 'package:real_estate_app/common_widgets/common_text_style.dart';
import 'package:real_estate_app/common_widgets/custom_container.dart';
import 'package:real_estate_app/common_widgets/height.dart';
import 'package:real_estate_app/global/AppBar.dart';
import 'package:real_estate_app/global/app_color.dart';
import 'package:intl/intl.dart';
import 'package:real_estate_app/global/constant.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({Key? key}) : super(key: key);

  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  final List<String> propertyTypes = [
    'Searches',
    'Seen',
    'Contacted',
  ];
  int _selectedPropertyIndex = 0;

  List<RecentSearch> recentSearches = [
    RecentSearch(
      title: '3 BHK in Magarpatta',
      location: 'Pune',
      bhk: 3,
      rating: 4.8,
      date: DateTime.now(),
      // imageUrl: '',
    ),
    RecentSearch(
      title: 'Luxury Villa near Alibaug Beach',
      location: 'Alibaug',
      bhk: 2,
      rating: 4.2,
      date: DateTime.now().subtract(const Duration(days: 1)),
      // imageUrl: '',
    ),
    RecentSearch(
      title: '2 BHK Apartment in Koramangala',
      location: 'Bangalore',
      bhk: 2,
      rating: 4.8,
      date: DateTime.now().subtract(const Duration(days: 2)),
      // imageUrl: '',
    ),
    RecentSearch(
      title: 'Luxury Newt near Goa Beach',
      location: 'Goa',
      bhk: 3,
      rating: 4.6,

      date: DateTime.now().subtract(const Duration(days: 2)),
      // imageUrl: '',
    ),
    RecentSearch(
      title: 'Gold bunglow in Wankhede',
      location: 'Mumbai',
      bhk: 4,
      rating: 4.8,
      date: DateTime.now().subtract(const Duration(days: 3)),
      // imageUrl: '',
    ),
    RecentSearch(
      title: 'Big Villa near lonvala',
      location: 'Maharashtra',
      bhk: 2,
      rating: 4.2,

      date: DateTime.now().subtract(const Duration(days: 4)),
      // imageUrl: '',
    ),
  ];

  final List<Property> _seenProperties = [
    Property(
      imagePath: 'assets/recommended_img/imgbed1.png',
      rent: '17,500',
      deposit: '2',
      flatType: '2BHK',
      area: '1500 sq.ft',
      furnished: 'Yes',
      security: '24/7',
      childrenPlayArea: 'Available',
    ),
    Property(
      imagePath: 'assets/recommended_img/imgbed2.jpeg',
      rent: '18,500',
      deposit: '3',
      flatType: '3BHK',
      area: '2500 sq.ft',
      furnished: 'Yes',
      security: '24/7',
      childrenPlayArea: 'Available',
    ),
    Property(
      imagePath: 'assets/recommended_img/imgbed3.jpeg',
      rent: '15,500',
      deposit: '1',
      flatType: '2BHK',
      area: '1800 sq.ft',
      furnished: 'Yes',
      security: '24/7',
      childrenPlayArea: 'Available',
    ),
    Property(
      imagePath: 'assets/recommended_img/imgbed5.jpeg',
      rent: '20,500',
      deposit: '3',
      flatType: '3BHK',
      area: '3000 sq.ft',
      furnished: 'Yes',
      security: '24/7',
      childrenPlayArea: 'Available',
    ),
    Property(
      imagePath: 'assets/recommended_img/imgbed6.jpeg',
      rent: '29,500',
      deposit: '4',
      flatType: '3BHK',
      area: '3500 sq.ft',
      furnished: 'Yes',
      security: '24/7',
      childrenPlayArea: 'Available',
    ),
  ];

  final List<Property> _contactProperties = [

    Property(
      imagePath: 'assets/recommended_img/imgbed5.jpeg',
      rent: '20,500',
      deposit: '3',
      flatType: '3BHK',
      area: '3000 sq.ft',
      furnished: 'Yes',
      security: '24/7',
      childrenPlayArea: 'Available',
    ),
    Property(
      imagePath: 'assets/recommended_img/imgbed2.jpeg',
      rent: '18,500',
      deposit: '3',
      flatType: '3BHK',
      area: '2500 sq.ft',
      furnished: 'Yes',
      security: '24/7',
      childrenPlayArea: 'Available',
    ),
    Property(
      imagePath: 'assets/recommended_img/imgbed6.jpeg',
      rent: '29,500',
      deposit: '4',
      flatType: '3BHK',
      area: '3500 sq.ft',
      furnished: 'Yes',
      security: '24/7',
      childrenPlayArea: 'Available',
    ),
    Property(
      imagePath: 'assets/recommended_img/imgbed1.png',
      rent: '17,500',
      deposit: '2',
      flatType: '2BHK',
      area: '1500 sq.ft',
      furnished: 'Yes',
      security: '24/7',
      childrenPlayArea: 'Available',
    ),
    Property(
      imagePath: 'assets/recommended_img/imgbed3.jpeg',
      rent: '15,500',
      deposit: '1',
      flatType: '2BHK',
      area: '1800 sq.ft',
      furnished: 'Yes',
      security: '24/7',
      childrenPlayArea: 'Available',
    ),
  ];


  String _formatDate(DateTime? date) {
    if (date == null) {
      return 'No Date Available';
    }
    final formatter = DateFormat('MMMM d, yyyy');
    return formatter.format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.grey.withOpacity(0.1),
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        elevation: 0,
        // leading: IconButton(
        //   onPressed: () {
        //     Navigator.of(context).pop();
        //   },
        //   icon: Icon(Icons.arrow_back, color: Colors.black.withOpacity(0.7)),
        // ),
        title: Text(
          'Activity',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black.withOpacity(0.7),
            fontFamily: 'Roboto',
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:  8.0, vertical: 8.0),
            child: Text('ALL latest Activities',style: AppTextStyle.commonTextStyle,),
          ),
          boxH05(),
          Padding(
            padding: const EdgeInsets.only(right: 5.0, left: 5.0,),
            child: SizedBox(
              height: 65,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: propertyTypes.length,
                itemBuilder: (context, index) {
                  bool isSelected = _selectedPropertyIndex == index;
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedPropertyIndex = index;
                        });
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        width: 100,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              isSelected
                                  ? AppColor.blue.shade50
                                  : AppColor.grey.withOpacity(0.1),
                              isSelected
                                  ? AppColor.blue.shade50
                                  : AppColor.grey.withOpacity(0.1),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.all(12.0),
                        child: Center(
                          child: Text(
                            propertyTypes[index],
                            style: TextStyle(
                              color:
                                  isSelected ? AppColor.blue : AppColor.black87,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Roboto',
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: _selectedPropertyIndex == 0
                ? ListView.builder(
                    itemCount: recentSearches.length,
                    itemBuilder: (context, index) {
                      final recentSearch = recentSearches[index];
                      return Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, top: 10.0, bottom: 10.0),
                        child: GestureDetector(
                           onTap: (){
                             Get.toNamed(Routes.propertiesDetail);
                           },
                          child: Card(
                            color: Colors.white,
                            shape: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                    color: Colors.black.withOpacity(0.1))),
                            elevation: 0.1,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 60,
                                    child: Text(
                                      // 'May, 15 2024',
                                      _formatDate(recentSearch.date),
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10.0),
                                  // Search Details
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          recentSearch.title,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(height: 4.0),
                                        Row(
                                          children: [
                                            const Icon(Icons.location_on,
                                                size: 16, color: Colors.grey),
                                            const SizedBox(width: 5.0),
                                            Text(
                                              recentSearch.location ??
                                                  'No Location Available',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4.0),
                                        Row(
                                          children: [
                                            Text(
                                              recentSearch.bhk != null
                                                  ? recentSearch.bhk.toString()
                                                  : 'NA',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                              ),
                                            ),
                                            const Text(
                                              ' BHK',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Spacer(),
                                            Row(
                                              children: [
                                                const Icon(Icons.star,
                                                    size: 16,
                                                    color: Colors.amber),
                                                const SizedBox(width: 5.0),
                                                Text(
                                                  recentSearch.rating
                                                          ?.toString() ??
                                                      'No Rating',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4.0),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : _selectedPropertyIndex == 1
                    ? ListView.builder(
                        itemCount: _seenProperties.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {},
                            child: Card(
                              elevation: 0.3,
                              margin: EdgeInsets.all(5),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side:
                                      BorderSide(color: Colors.grey.shade200)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(15.0),
                                            topRight: Radius.circular(15.0),
                                          ),
                                          child: CarouselSlider(
                                            options: CarouselOptions(
                                              aspectRatio: 16 / 9,
                                              enlargeCenterPage: true,
                                              scrollDirection: Axis.horizontal,
                                              autoPlay: true,
                                            ),
                                            items: _seenProperties.map((property) {
                                              return Builder(
                                                builder:
                                                    (BuildContext context) {
                                                  return ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(5)),
                                                    child: Image.asset(
                                                      property.imagePath,
                                                      fit: BoxFit.cover,
                                                      width: double.infinity,
                                                      height: 200.0,
                                                    ),
                                                  );
                                                },
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                      // Favorite button with subtle animation and semi-transparent background
                                      Positioned(
                                        top: 15.0,
                                        right: 15.0,
                                        child: AnimatedSwitcher(
                                          duration: Duration(milliseconds: 300),
                                          transitionBuilder:
                                              (child, animation) =>
                                                  ScaleTransition(
                                                      scale: animation,
                                                      child: child),
                                          child: Material(
                                            color: Colors.grey.withOpacity(0.2),
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  _seenProperties[index]
                                                          .isFavorite =
                                                      !_seenProperties[index]
                                                          .isFavorite;
                                                });
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Icon(
                                                  Icons.favorite_border,
                                                  color: _seenProperties[index]
                                                          .isFavorite
                                                      ? Colors.red
                                                      : Colors.black
                                                          .withOpacity(0.4),
                                                  size: 30.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        16.0, 12.0, 16.0, 16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '₹ ${_seenProperties[index].rent}',
                                              style: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            const SizedBox(width: 5.0),
                                            Text(
                                              '/ Month',
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                            const Spacer(),
                                            Text(
                                              '(+ Deposit ₹ ${_seenProperties[index].deposit}/ Month)',
                                              style: TextStyle(
                                                fontSize: 12.0,
                                                color: Colors.grey[700],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8.0),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  'Flat Type:',
                                                  style: TextStyle(
                                                    fontSize: 14.0,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                Text(
                                                  ' ${_seenProperties[index].flatType}',
                                                  style: TextStyle(
                                                    fontSize: 14.0,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(width: 10.0),
                                                Text(
                                                  'Area:',
                                                  style: TextStyle(
                                                    fontSize: 14.0,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                Text(
                                                  ' ${_seenProperties[index].area}',
                                                  style: TextStyle(
                                                    fontSize: 14.0,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(width: 10.0),
                                            Row(
                                              children: [
                                                Text(
                                                  'Furnished:',
                                                  style: TextStyle(
                                                    fontSize: 14.0,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                Text(
                                                  ' ${_seenProperties[index].furnished}',
                                                  style: TextStyle(
                                                    fontSize: 14.0,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                const SizedBox(width: 10.0),
                                                Text(
                                                  'Security:',
                                                  style: TextStyle(
                                                    fontSize: 14.0,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                Text(
                                                  ' ${_seenProperties[index].security}',
                                                  style: TextStyle(
                                                    fontSize: 14.0,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10.0),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () {},
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.blue,
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 20,
                                                  vertical: 10,
                                                ),
                                                textStyle: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              child: Text(
                                                'View Phone',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {},
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.blue,
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 20,
                                                  vertical: 10,
                                                ),
                                                textStyle: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              child: Text(
                                                'Contact',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        })
                    : _selectedPropertyIndex == 2
                        ? ListView.builder(
                            itemCount: _contactProperties.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {},
                                child: Card(
                                  elevation: 0.3,
                                  margin: EdgeInsets.all(5),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: BorderSide(
                                          color: Colors.grey.shade200)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Stack(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(15.0),
                                                topRight: Radius.circular(15.0),
                                              ),
                                              child: CarouselSlider(
                                                options: CarouselOptions(
                                                  aspectRatio: 16 / 9,
                                                  enlargeCenterPage: true,
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  autoPlay: true,
                                                ),
                                                items:
                                                _contactProperties.map((property) {
                                                  return Builder(
                                                    builder:
                                                        (BuildContext context) {
                                                      return ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5)),
                                                        child: Image.asset(
                                                          property.imagePath,
                                                          fit: BoxFit.cover,
                                                          width:
                                                              double.infinity,
                                                          height: 200.0,
                                                        ),
                                                      );
                                                    },
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                          ),
                                          // Favorite button with subtle animation and semi-transparent background
                                          Positioned(
                                            top: 15.0,
                                            right: 15.0,
                                            child: AnimatedSwitcher(
                                              duration:
                                                  Duration(milliseconds: 300),
                                              transitionBuilder:
                                                  (child, animation) =>
                                                      ScaleTransition(
                                                          scale: animation,
                                                          child: child),
                                              child: Material(
                                                color: Colors.grey
                                                    .withOpacity(0.2),
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                                child: InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      _contactProperties[index]
                                                              .isFavorite =
                                                          !_contactProperties[index]
                                                              .isFavorite;
                                                    });
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Icon(
                                                      Icons.favorite_border,
                                                      color: _contactProperties[index]
                                                              .isFavorite
                                                          ? Colors.red
                                                          : Colors.black
                                                              .withOpacity(0.4),
                                                      size: 30.0,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            16.0, 12.0, 16.0, 16.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '₹ ${_contactProperties[index].rent}',
                                                  style: TextStyle(
                                                    fontSize: 18.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                const SizedBox(width: 5.0),
                                                Text(
                                                  '/ Month',
                                                  style: TextStyle(
                                                    fontSize: 14.0,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                                const Spacer(),
                                                Text(
                                                  '(+ Deposit ₹ ${_contactProperties[index].deposit}/ Month)',
                                                  style: TextStyle(
                                                    fontSize: 12.0,
                                                    color: Colors.grey[700],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 8.0),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      'Flat Type:',
                                                      style: TextStyle(
                                                        fontSize: 14.0,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    Text(
                                                      ' ${_contactProperties[index].flatType}',
                                                      style: TextStyle(
                                                        fontSize: 14.0,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10.0),
                                                    Text(
                                                      'Area:',
                                                      style: TextStyle(
                                                        fontSize: 14.0,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    Text(
                                                      ' ${_contactProperties[index].area}',
                                                      style: TextStyle(
                                                        fontSize: 14.0,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(width: 10.0),
                                                Row(
                                                  children: [
                                                    Text(
                                                      'Furnished:',
                                                      style: TextStyle(
                                                        fontSize: 14.0,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    Text(
                                                      ' ${_contactProperties[index].furnished}',
                                                      style: TextStyle(
                                                        fontSize: 14.0,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10.0),
                                                    Text(
                                                      'Security:',
                                                      style: TextStyle(
                                                        fontSize: 14.0,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    Text(
                                                      ' ${_contactProperties[index].security}',
                                                      style: TextStyle(
                                                        fontSize: 14.0,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 10.0),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                ElevatedButton(
                                                  onPressed: () {},
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.blue,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 10,
                                                    ),
                                                    textStyle: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  child: Text(
                                                    'View Phone',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {},
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.blue,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 10,
                                                    ),
                                                    textStyle: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  child: Text(
                                                    'Contact',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            })
                        : Center(
                            child: Text(
                                'Select "Recent Searches" to view saved searches'),
                          ),
          ),
        ],
      ),
    );
  }
}

class RecentSearch {
  final String title;
  final String location;
  final int? bhk;
  final double? rating;
  final String? phoneNumber;
  // final String? imageUrl;
  final DateTime date;

  RecentSearch({
    required this.title,
    required this.location,
    this.bhk,
    this.rating,
    required this.date,
    this.phoneNumber,
    // required this.imageUrl,
  });
}

class Property {
  final String imagePath;
  final String rent;
  final String deposit;
  final String flatType;
  final String area;
  final String furnished;
  final String security;
  final String childrenPlayArea;
  late final bool isFavorite;
  Property({
    required this.imagePath,
    required this.rent,
    required this.deposit,
    required this.flatType,
    required this.area,
    required this.furnished,
    required this.security,
    required this.childrenPlayArea,
    bool isFavorite = false,
  }) : isFavorite = isFavorite;
}
