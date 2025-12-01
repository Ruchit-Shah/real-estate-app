import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/Routes/app_pages.dart';
import 'package:real_estate_app/common_widgets/dialog_util.dart';
import 'package:real_estate_app/global/app_color.dart';
import 'package:url_launcher/url_launcher.dart';

class PropertiesListScreenDummy extends StatefulWidget {
  const PropertiesListScreenDummy({Key? key}) : super(key: key);

  @override
  State<PropertiesListScreenDummy> createState() => _PropertiesListScreenDummyState();
}

class _PropertiesListScreenDummyState extends State<PropertiesListScreenDummy> {
  TextEditingController searchController = TextEditingController();

  bool _isFavorited = false;

  void _toggleFavorite() {
    setState(() {
      _isFavorited = !_isFavorited;
    });
  }

  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    var _height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.grey.withOpacity(0.1),
        scrolledUnderElevation: 0,

        //backgroundColor: Colors.black.withOpacity(0.7),
        // backgroundColor: Colors.blueAccent.withOpacity(0.5),
        // backgroundColor: Colors.amber.withOpacity(0.3),

        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black.withOpacity(0.6)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: TextFormField(
          controller: searchController,
          onTap: () {},
          style: TextStyle(color: Colors.black),
          cursorColor: AppColor.grey,
          decoration: InputDecoration(
            hintText: 'Search City, Locality...',
            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              // Border color when not active
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.grey),
            ),
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                onPressed: () {},
                icon: Icon(Icons.search, color: Colors.grey), // Icon color
              ),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              DialogUtil.showLoadingDialogWithDelay(milliseconds: 600);
              Get.back();
              Get.toNamed(Routes.filterSearch);
            },
            icon: Row(
              children: [
                Icon(
                  Icons.filter_alt_outlined,
                  color: Colors.black.withOpacity(0.6),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              DialogUtil.showLoadingDialogWithDelay(milliseconds: 600);
              Get.back();
              Get.toNamed(Routes.saved);
            },
            icon: Icon(
              Icons.favorite_border,
              color: Colors.black.withOpacity(0.6),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: ListView.builder(
                itemCount: _properties.length,
                itemBuilder: (context, index) {
                  final property = _properties[index];
                  return GestureDetector(
                    onTap: () {
                      DialogUtil.showLoadingDialogWithDelay(milliseconds: 600);
                      Get.back();
                      Get.toNamed(Routes.propertiesDetail);
                      // onTap: () {
                      //   Get.toNamed(Routes.propertiesDetail, arguments: property);
                      // },
                    },
                    child: Card(
                      elevation: 0.3,
                      margin: EdgeInsets.all(5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Colors.grey.shade200)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(15.0),
                                    topRight: Radius.circular(15.0),
                                  ),
                                  child: CarouselSlider(
                                    options: CarouselOptions(
                                      aspectRatio: 17 / 8,
                                      enlargeCenterPage: true,
                                      scrollDirection: Axis.horizontal,
                                      autoPlay: true,
                                    ),
                                    items: _properties.map((property) {
                                      return Builder(
                                        builder: (BuildContext context) {
                                          return ClipRRect(
                                            borderRadius: BorderRadius.all(Radius.circular(5)),
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
                                child: Material(
                                  color: Colors.white.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(12.0),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        property.isFavorite = !property.isFavorite;
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: AnimatedContainer(
                                        duration: Duration(milliseconds: 300),
                                        child: Icon(
                                          property.isFavorite ? Icons.favorite : Icons.favorite_border_outlined,
                                          color: property.isFavorite ? Colors.red.withOpacity(0.7) : Colors.blue.withOpacity(0.7),
                                          size: 25.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '₹ ${_properties[index].rent}',
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
                                      '(+ Deposit ₹ ${_properties[index].deposit}/ Month)',
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          'Flat Type:',
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          ' ${_properties[index].flatType}',
                                          style: const TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 10.0),
                                        const Text(
                                          'Area:',
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          ' ${_properties[index].area}',
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
                                          ' ${_properties[index].furnished}',
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
                                          ' ${_properties[index].security}',
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
                                      onPressed: () {
                                        _showOwnerDetailsBottomSheet('Alexe Halesw', '123-456-7890');
                                      },
                                      style: ElevatedButton.styleFrom(
                                        //primary: Colors.blue,
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
                                      onPressed: () {
                                        _makePhoneCall('+91123-456-7890');
                                      },
                                      style: ElevatedButton.styleFrom(
                                        //primary: Colors.blue,
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
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showOwnerDetailsBottomSheet(String ownerName, String phoneNumber) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Owner Details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 16),
              ListTile(
                leading: Icon(Icons.person),
                title: Text(
                  'Owner Name:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(ownerName),
              ),
              SizedBox(height: 8),
              ListTile(
                leading: Icon(Icons.phone),
                title: Text(
                  'Phone Number:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(phoneNumber),
              ),
              SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the bottom sheet
                  },
                  style: ElevatedButton.styleFrom(
                    //primary: Colors.blue,
                  ),
                  child: Text('Close',style: TextStyle(color: Colors.white),),
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }
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
  bool isFavorite;
  Property({
    required this.imagePath,
    required this.rent,
    required this.deposit,
    required this.flatType,
    required this.area,
    required this.furnished,
    required this.security,
    required this.childrenPlayArea,
    this.isFavorite = false,
  });
}


final List<Property> _properties = [
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
  Property(
    imagePath: 'assets/recommended_img/imgbed7.jpeg',
    rent: '20,500',
    deposit: '3',
    flatType: '3BHK',
    area: '3000 sq.ft',
    furnished: 'Yes',
    security: '24/7',
    childrenPlayArea: 'Available',
  ),
];
