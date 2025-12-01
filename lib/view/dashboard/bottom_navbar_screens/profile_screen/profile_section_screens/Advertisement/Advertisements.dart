import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:real_estate_app/common_widgets/custom_textformfield.dart';
import 'package:real_estate_app/common_widgets/height.dart';
import 'package:real_estate_app/common_widgets/loading_dart.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/CustomBottomNavBar.dart';


class Advertisements extends StatefulWidget {
  const Advertisements({super.key});

  @override
  State<Advertisements> createState() => _AdvertisementsState();
}

class _AdvertisementsState extends State<Advertisements> {
  final FocusNode _focusNode = FocusNode();
  TextEditingController _Controller = TextEditingController();
  PropertyController propertyController = Get.put(PropertyController());

  final List<Property> properties = [
    Property(
      status: "Published",
      date: "08 May, 2023",
      imagePath: "assets/image_rent/propertyDeveloper.png",
      type: "FOR RENT",
      title: "Home in Metric Way",
      address: "1421 San Pedro St, Los Angeles",
      bhk: "1bhk, 2bhk, 3bhk",
      views: 1024,
      leads: 12,
    ),

    Property(
      status: "Rejected",
      date: "12 June, 2023",
      imagePath: "assets/image_rent/propertyDeveloper.png",
      type: "FOR RENT",
      title: "Villa in Beverly Hills",
      address: "123 Sunset Blvd, Los Angeles",
      bhk: "2bhk, 3bhk",
      views: 500,
      leads: 8,
    ),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Advertisements", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),),
          backgroundColor: Colors.white,
          scrolledUnderElevation: 0,
          elevation: 0,
          leadingWidth: 40,
          leading: Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.black, // Border color
                  width: 0.1, // Border width
                ),
              ),
              child: InkWell(
                onTap: () {
                  Get.back();
                },
                borderRadius: BorderRadius.circular(
                    50),
                child: const Padding(
                  padding: EdgeInsets.all(6), // Adjust padding for better spacing
                  child: Icon(
                    Icons.arrow_back_outlined,
                    size: 18,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ),

        body:  Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      height: 50,
                      child: TextField(
                        focusNode: _focusNode,
                        controller: _Controller,
                        decoration: InputDecoration(
                          hintText: "Search",
                          hintStyle: const TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.normal),
                          prefixIcon: const Icon(Icons.search, size: 25),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.cancel, size: 18),
                            onPressed: () {
                              _Controller.clear();
                            },
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                            const BorderSide(color: Colors.grey, width: 0.8),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                            const BorderSide(color: Colors.grey, width: 0.8),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 16.0),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: properties.length,
                      itemBuilder: (context, index) {
                        final property = properties[index];
                        return SizedBox(
                          width: Get.width,
                          height: Get.height * 0.4,
                          child: Card(
                            elevation: 0.4,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Top section (Status tag and date)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: property.status == "Published"
                                              ? Colors.green[100]
                                              : property.status == "Rejected"
                                              ? Colors.red[100]
                                              : Colors.orange[100],
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          property.status,
                                          style: TextStyle(
                                              color: property.status == "Published"
                                                  ? Colors.green
                                                  : property.status == "Rejected"
                                                  ? Colors.red
                                                  : Colors.orange,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Text(
                                        property.date,
                                        style: const TextStyle(
                                            color: Colors.grey, fontSize: 14),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),

                                  // Image and property details
                                  Row(
                                    children: [
                                      // Property Image
                                      Stack(
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(8),
                                              child: Image.asset(
                                                property.imagePath,
                                                width: 80,
                                                height: 70,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            Positioned(
                                              left: 0,
                                              top: 0,
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 6, vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFF6969EB),
                                                  borderRadius: BorderRadius.circular(6),
                                                ),
                                                child: Text(
                                                  property.type,
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ]),
                                      const SizedBox(width: 10),

                                      // Property details
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 6),
                                            Text(
                                              property.title,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              property.address,
                                              style: const TextStyle(
                                                  color: Colors.grey, fontSize: 14),
                                            ),
                                            Text(
                                              property.bhk,
                                              style: const TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),

                                  // Views and Leads
                                  Container(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                            color: Colors.black.withOpacity(0.1),
                                            width: 0.8)),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text("Views",
                                                style: TextStyle(color: Colors.grey)),
                                            const SizedBox(height: 4),
                                            Text("${property.views}",
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold)),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text("Leads",
                                                style: TextStyle(color: Colors.grey)),
                                            const SizedBox(height: 4),
                                            Text("${property.leads}",
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),

                                  // Action Buttons
                                  Row(
                                    children: [
                                      // Edit Button
                                      ElevatedButton(
                                        onPressed: () {

                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                              side: const BorderSide(
                                                  color: Color(0xFF813BEA),
                                                  width: 0.8)),
                                        ),
                                        child: const Text(
                                          "Edit",
                                          style: TextStyle(
                                              color: Color(0xFF813BEA),
                                              fontSize: 15),
                                        ),
                                      ),
                                      const Spacer(),

                                      // Conditional buttons based on status
                                      if (property.status == "Published")
                                        ElevatedButton(
                                          onPressed: () {
                                            //_showStopReasonDialog(context, property);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8),
                                                side: const BorderSide(
                                                    color: Color(0xFFEA4335),
                                                    width: 0.8)),
                                          ),
                                          child: const Text(
                                            "Stop",
                                            style: TextStyle(
                                                color: Color(0xFFEA4335),
                                                fontSize: 15),
                                          ),
                                        ),
                                      if (property.status != "Published")
                                        ElevatedButton(
                                          onPressed: () {
                                            // _showReasonDialog(context, property);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8),
                                                side: BorderSide(
                                                    color: property.status == "Rejected"
                                                        ? Colors.black.withOpacity(0.7)
                                                        : Colors.black,
                                                    width: 0.8)),
                                          ),
                                          child: Text(
                                            "View Reason",
                                            style: TextStyle(
                                                color: property.status == "Rejected"
                                                    ? Colors.black.withOpacity(0.6)
                                                    : Colors.black,
                                                fontSize: 15),
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  boxH50(),
                  boxH50(),
                  boxH20(),
                ],
              ),

              Positioned(
                bottom: 100,
                right: 20,
                left: 20,
                child: SizedBox(
                  width: Get.width,
                  height: Get.width * 0.15,
                  child: ElevatedButton(
                    onPressed: () {
                      _showOfferBottomSheet(
                          context:context,
                          onCreateOffer: () {  });

                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF52C672),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    child: const Text("Create New Ads",
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),
              ),
              const Positioned(
                bottom: 0,
                left: 5,
                right: 5,
                child: CustomBottomNavBar(),
              ),
            ]));
  }

  void _showOfferBottomSheet({
    required BuildContext context,
    Color buttonColor = const Color(0xFF813BEA),
    required VoidCallback onCreateOffer,
  }) {
    final PropertyController controller = Get.find<PropertyController>();
    final RxInt currentStep = 0.obs; // Track current step

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return Obx(() => SizedBox(
          height: MediaQuery.of(context).size.height * 0.94,
          child: Padding(
            padding: EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              bottom: MediaQuery.of(context).viewInsets.bottom,
              top: 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Header Section
                Row(
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(50),
                      child: const Padding(
                        padding: EdgeInsets.all(6),
                        child: Icon(Icons.arrow_back_outlined, size: 18, color: Colors.black),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      currentStep.value == 0 ? "Select Property" : "Advertisements",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    const Spacer(),
                  ],
                ),

                boxH10(),

                // **Step 1: Property Selection**
                if (currentStep.value == 0) ...[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      height: 50,
                      child: TextField(
                        focusNode: _focusNode,
                        controller: _Controller,
                        decoration: InputDecoration(
                          hintText: "Search",
                          prefixIcon: const Icon(Icons.search, size: 25),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.cancel, size: 18),
                            onPressed: () =>   _Controller.clear(),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Obx(() => SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.66,
                    child: ListView.builder(
                      itemCount: controller.properties.length,
                      itemBuilder: (context, index) {
                        final property = controller.properties[index];

                        return Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0.5,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Checkbox(
                                  value: property.isSelected,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                    side: const BorderSide(color: Colors.purple, width: 0.4),
                                  ),
                                  onChanged: (value) => controller.toggleSelection(index),
                                ),
                                const SizedBox(width: 8),
                                Stack(children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      property.imageUrl,
                                      width: 80,
                                      height: 70,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    left: 0,
                                    top: 0,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF6969EB),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        property.type,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ]),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(property.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                      Text(property.address, style: const TextStyle(color: Colors.grey, fontSize: 14)),
                                      Text(property.price, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )),
                ],

                // **Step 2: Offer Details**
                if (currentStep.value == 1) ...[
                  Expanded(
                    child: SingleChildScrollView(
                      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                      scrollDirection: Axis.vertical,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Obx(() => Column(
                            children: controller.properties
                                .where((p) => p.isSelected)
                                .map((property) => ListTile(
                              leading: Stack(children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    property.imageUrl,
                                    width: 80,
                                    height: 70,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  left: 0,
                                  top: 0,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF6969EB),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      property.type,
                                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ]),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(property.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                  Text(property.address, style: const TextStyle(fontSize: 12)),
                                  Text.rich(
                                    TextSpan(
                                      text: property.price,
                                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
                                      children: const [
                                        TextSpan(
                                          text: " /month",
                                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ))
                                .toList(),
                          )),
                          boxH30(),

                          // **Upload Images**
                          Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset("assets/image_rent/gallery-export.png", width: 100, height: 60),
                                boxH10(),
                                const Text("Upload Large Image", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                boxH10(),
                                commonButton(
                                  width: 150,
                                  height: 50,
                                  buttonColor: buttonColor,
                                  text: "+ Add Photos",
                                  textStyle: const TextStyle(fontSize: 14, color: Colors.white),
                                  onPressed: () {},
                                ),


                                boxH20(),
                                Image.asset("assets/image_rent/gallery-export.png", width: 100, height: 60),
                                boxH10(),
                                const Text("Upload Mobile Images", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                boxH10(),
                                commonButton(
                                  width: 150,
                                  height: 50,
                                  buttonColor: buttonColor,
                                  text: "+ Add Photos",
                                  textStyle: const TextStyle(fontSize: 14, color: Colors.white),
                                  onPressed: () {},
                                ),
                                boxH10(),
                                CustomTextFormField(

                                  labelText: "Advertisement Time",
                                  maxLines: 3,
                                  controller: controller.advertisementController,
                                ),
                              ],
                            ),
                          ),
                          boxH10(),

                        ],
                      ),
                    ),
                  ),
                ],
                if(currentStep.value == 1)
                  boxH50(),
                // **Footer with Button**
                // const Spacer(),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${controller.properties.where((p) => p.isSelected).length} Property Selected",
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: commonButton(
                          width: 150,
                          height: 50,
                          buttonColor: buttonColor,
                          text: currentStep.value == 0 ? "Next" : "Create Ads",
                          textStyle: const TextStyle(fontSize: 14, color: Colors.white),
                          onPressed: () {
                            if (currentStep.value == 0) {
                              currentStep.value = 1;
                            } else {
                              onCreateOffer.call();
                              Navigator.pop(context);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
      },
    );
  }



}

// Add these methods to your class
void _showStopReasonDialog(BuildContext context, Property property) {
  final reasonController = TextEditingController();
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Stop Property"),
      content: TextField(
        controller: reasonController,
        decoration: const InputDecoration(
          hintText: "Enter reason for stopping...",
          border: OutlineInputBorder(),
        ),
        maxLines: 3,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            // Update the property with stop reason
            property.stopReason = reasonController.text;
            // You would typically update the status here as well
            Navigator.pop(context);
          },
          child: const Text("Submit"),
        ),
      ],
    ),
  );
}

void _showReasonDialog(BuildContext context, Property property) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("${property.status} Reason"),
      content: Text(
        property.stopReason ?? property.viewReason ?? "No reason provided",
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("OK"),
        ),
      ],
    ),
  );
}

class Property {
  final String status;
  final String date;
  final String imagePath;
  final String type;
  final String title;
  final String address;
  final String bhk;
  final int views;
  final int leads;
  String? stopReason;
  String? viewReason;

  Property({
    required this.status,
    required this.date,
    required this.imagePath,
    required this.type,
    required this.title,
    required this.address,
    required this.bhk,
    required this.views,
    required this.leads,
    this.stopReason,
    this.viewReason,
  });
}


class OfferProperty {
  String imageUrl;
  String title;
  String address;
  String type;
  String price;
  bool isSelected;

  OfferProperty({
    required this.imageUrl,
    required this.title,
    required this.type,
    required this.address,
    required this.price,
    this.isSelected = false,
  });
}

class PropertyController extends GetxController {
  TextEditingController offerNameController = TextEditingController();
  TextEditingController offerDurationController = TextEditingController();
  TextEditingController offerDescriptionController = TextEditingController();
  TextEditingController advertisementController = TextEditingController();


  var properties = <OfferProperty>[
    OfferProperty(
      imageUrl: 'assets/image_rent/propertyDeveloper.png',
      title: 'Home in Metric Way',
      address: '1421 San Pedro St, Los Angeles',
      type: "FOR RENT",
      price: '\$2500',
    ),
    OfferProperty(
      imageUrl: 'assets/image_rent/propertyDeveloper.png',
      title: 'Luxury Villa',
      address: 'Beverly Hills, California',
      type: "FOR RENT",
      price: '\$5000',
    ),
    OfferProperty(
      imageUrl: 'assets/image_rent/propertyDeveloper.png',
      title: 'Apartment in New York',
      type: "FOR RENT",
      address: '5th Avenue, New York',
      price: '\$3200',
    ),
  ].obs;

  void toggleSelection(int index) {
    properties[index].isSelected = !properties[index].isSelected;
    update(); // Notify UI for state change
  }

  List<OfferProperty> getSelectedProperties() {
    return properties.where((p) => p.isSelected).toList();
  }
}
