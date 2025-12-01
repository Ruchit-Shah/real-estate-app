
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;


class GoogleMapSearchPlacesApi extends StatefulWidget {
  const GoogleMapSearchPlacesApi({Key? key}) : super(key: key);

  @override
  _GoogleMapSearchPlacesApiState createState() => _GoogleMapSearchPlacesApiState();
}

class _GoogleMapSearchPlacesApiState extends State<GoogleMapSearchPlacesApi> {
  TextEditingController _controller = TextEditingController();
  var uuid = const Uuid();
  String _sessionToken = '1234567890';
  List<dynamic> _placeList = [];
  int? _selectedIndex;


  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      _onChanged();
    });
  }

  _onChanged() {
    if (_sessionToken == null) {
      setState(() {
        _sessionToken = uuid.v4();
      });
    }
    getSuggestion(_controller.text);
  }

  void getSuggestion(String input) async {
    const String PLACES_API_KEY = "AIzaSyAt8bj4UACvakZfiSy-0c1o_ivfplm7jEU";
    try {
      String baseURL = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
      String request = '$baseURL?input=$input&key=$PLACES_API_KEY&sessiontoken=$_sessionToken';
      var response = await http.get(Uri.parse(request));
      if (response.statusCode == 200) {
        setState(() {
          _placeList = json.decode(response.body)['predictions'];
        });
      } else {
        throw Exception('Failed to load predictions');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Search location', style: TextStyle(fontSize: 17)),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Search your location here",
                prefixIcon: const Icon(Icons.location_on),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.cancel),
                  onPressed: () {
                    _controller.clear();
                  },
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 0.8),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 0.8),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _placeList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () async {
                    setState(() {
                      _selectedIndex = index;
                    });

                    // Perform asynchronous operations
                    List<Location> loc = await locationFromAddress(_placeList[index]['description']);
                    double lat = loc.last.latitude;
                    double lng = loc.last.longitude;

                    List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
                    String city = placemarks.isNotEmpty ? placemarks[0].locality ?? '' : '';

                    print("city===>");
                    print(city);

                    Future.delayed(Duration.zero, () {
                      if (mounted) {
                        Navigator.pop(context, {
                          'latitude': lat.toStringAsFixed(2),
                          'longitude': lng.toStringAsFixed(2),
                          'add': _placeList[index]['description'],
                          'city': city,
                        });
                      }
                    });
                  },
                  child: ListTile(
                    title: Text(_placeList[index]["description"]),
                    tileColor: _selectedIndex == index ? Colors.blue.withOpacity(0.3) : Colors.white,
                    textColor: _selectedIndex == index ? Colors.blue : Colors.black,
                  ),
                );

              },
            ),
          ),


    ],
      ),
    );
  }
}
