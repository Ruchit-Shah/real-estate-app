import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:real_estate_app/common_widgets/height.dart';
import 'package:real_estate_app/common_widgets/loading_dart.dart';
import 'package:real_estate_app/global/api_constant.dart';
import 'package:real_estate_app/global/constant.dart';
import 'package:real_estate_app/utils/app_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class FAQsScreen extends StatefulWidget {
  const FAQsScreen({super.key});

  @override
  State<FAQsScreen> createState() => _FAQsScreenState();
}

class _FAQsScreenState extends State<FAQsScreen> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  bool isApiCallProcessing=false,isServerError=false;

  String user_id='';
  String user_type='';
  String admin_auto_id='';

  String _selectedType = 'General Inquiry';

  final List<String> _inquiryTypes = [
    'General Inquiry',
    'Feedback',
    'Other'
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //GetProfileData();
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          backgroundColor: appBarColor,
          title: Text("FAQs",
              style: TextStyle(
                  color: appBarIconColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          leading: IconButton(
            onPressed: Navigator.of(context).pop,
            icon: Icon(Icons.arrow_back, color: appBarIconColor),
          ),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Customer Name", style: TextStyle(fontSize: 16, color: Colors.black)),
                        SizedBox(height: 10,),
                        Container(
                          height: 45,
                          child: Container(
                            height: MediaQuery.of(context).size.height,
                            child:
                            TextFormField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.fromLTRB(10, 15, 0, 0),
                                disabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black, width: 1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              keyboardType: TextInputType.text,
                              enabled: false,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  boxH15(),

                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Customer Contact", style: TextStyle(fontSize: 16, color: Colors.black)),
                        SizedBox(height: 10,),
                        Container(
                          height: 45,
                          child: Container(
                            height: MediaQuery.of(context).size.height,
                            child: TextFormField(
                              controller: _contactController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.fromLTRB(10, 15, 0, 0),
                                disabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black, width: 1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              enabled: false,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  boxH15(),
                  Text("Customer type", style: TextStyle(fontSize: 16, color: Colors.black)),
                  boxH10(),
                  Container(
                    height: 60,
                    child: DropdownButtonFormField<String>(
                      value: _selectedType,
                      borderRadius: BorderRadius.circular(10),
                      decoration: InputDecoration(
                        labelText: 'Type',labelStyle: TextStyle(color: Colors.black),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),borderSide: BorderSide(color: Colors.grey)),
                        border: OutlineInputBorder(),
                      ),
                      items: _inquiryTypes.map((String type) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedType = newValue!;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select an inquiry type';
                        }
                        return null;
                      },
                    ),
                  ),
                  boxH15(),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Message", style: TextStyle(fontSize: 16, color: Colors.black)),
                        boxH10(),
                        Container(
                          height: 110,
                          child: Container(
                            height: MediaQuery.of(context).size.height,
                            child:
                            TextFormField(
                              controller: _messageController,
                              validator: (name) {
                                if (isNameValid(name!)) return null;
                                else
                                  return 'Please enter message';
                              },
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: EdgeInsets.fromLTRB(10, 15, 0, 0),
                                  hintText: 'Please enter message',
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey, width: 1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black, width: 1),
                                    borderRadius: BorderRadius.circular(10),
                                  )
                              ),
                              maxLines: 5,
                              keyboardType: TextInputType.text,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 30.0),
                  GestureDetector(
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        // await sendCustomerData(
                        //   _nameController.text,
                        //   _contactController.text,
                        //   _selectedType,
                        //   _messageController.text,
                        // );
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(left: 20, right: 20),
                      padding: EdgeInsets.only(left: 20, right: 20),
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blue,
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 10),
                            blurRadius: 50,
                            color: Color(0xffEEEEEE),
                          ),
                        ],
                      ),
                      child: Text(
                        "Submit",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ));
  }

  bool isNameValid(String name) {
    if(name.isEmpty){
      return false;
    }
    return true;
  }



}

