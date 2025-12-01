import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:real_estate_app/common_widgets/height.dart';
import 'package:real_estate_app/global/TTS_Service.dart';
import 'package:real_estate_app/global/api_string.dart';
import 'package:real_estate_app/global/app_color.dart';
import 'package:real_estate_app/utils/TTS_NativeService.dart';
import 'package:real_estate_app/utils/text_style.dart';
import 'package:real_estate_app/view/auth/login_screen/login_screen.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/search_screen/searchController.dart';
import 'package:real_estate_app/view/dashboard/controller/BotController.dart';
import 'package:real_estate_app/view/dashboard/deshboard_controllers/bottom_bar_controller.dart';
import 'package:real_estate_app/view/dashboard/imageRecognization/keyword_pattern.dart';
import 'package:real_estate_app/view/property_screens/properties_controllers/post_property_controller.dart';
import 'package:real_estate_app/view/property_screens/recommended_properties_screen/properties_details_screen.dart';
import 'package:real_estate_app/view/splash_screen/splash_screen.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:url_launcher/url_launcher.dart';

import '../../../property_screens/recommended_properties_screen/propertyCard.dart';


class BotProvider extends ChangeNotifier {
  final BottomBarController bottomBarController = Get.find();
  final PostPropertyController controller = Get.find();
  final TranslationAndTTS ttsServiceTrans = TranslationAndTTS();
  final TtsService ttsService = TtsService();
  final stt.SpeechToText _speechToText = stt.SpeechToText();
  final BotController _AIchatbotController = Get.find();
  final searchController search_controller = Get.find();
  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  String detectedLanguage = 'en';
  String lastWords = '';
  String propertyPurpose = '';
  String imageSearchKeys = '';
  String command = '';
  String area = '';
  String city = '';
  bool speechEnabled = false;
  bool isListening = false;
  bool openTextField = false;
  List<File> selectedImages = [];
  int currentIndex = 0;
  final List<dynamic> _messages = [];
  final Map<String, dynamic> staticResponses = {};

  List<dynamic> get messages => _messages;
  TextEditingController get txtController => textController;
  bool get isSpeechListening => _speechToText.isListening || isListening;

  BotProvider() {
    _initSpeech();
  }

  void _initSpeech() async {
    speechEnabled = await _speechToText.initialize();
    notifyListeners();
  }

  void startListening() async {
    textController.clear();
    await _speechToText.listen(
      onResult: _onSpeechResult,
      listenFor: const Duration(seconds: 10),
    );
    isListening = true;
    notifyListeners();
    Future.delayed(const Duration(seconds: 10), stopListening);
  }

  void stopListening() async {
    await _speechToText.stop();
    isListening = false;
    notifyListeners();
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    String recognizedWords = result.recognizedWords;
    textController.text = recognizedWords;
    command = recognizedWords;
    if (result.finalResult) {
      _detectLanguage(command);
      stopListening();
    }
    notifyListeners();
  }

  Future<void> _detectLanguage(String text) async {
    final translatedText = await translateText(text, "en");
    print('Detected Language = $detectedLanguage');
    sendMessage(translatedText);
  }

  Future<String> translateText(String text, String targetLanguage) async {
    const String apiKey = "AIzaSyDY-oB0QysTXFJu2cOMlZvpwANBR2XS84E";
    const String baseUrl = "https://translation.googleapis.com/language/translate/v2";
    final Uri url = Uri.parse("$baseUrl?key=$apiKey");
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'q': text,
          'target': targetLanguage,
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data']['translations'][0]['translatedText'];
      } else {
        print("Error: ${response.body}");
        throw Exception("Failed to translate text");
      }
    } catch (e) {
      print("Exception: $e");
      throw Exception("Failed to connect to the translation API");
    }
  }

// In BotProvider.dart, add this method and update initialize method:

  void clearChat() {
    search_controller.selectedPropertyType.value = '';
    _messages.clear();
    textController.clear();
    command = '';
    area = '';
    city = '';
    imageSearchKeys = '';
    selectedImages.clear();
    notifyListeners();
  }

  void initialize(BuildContext context) async {
    clearChat();
    // sendBotMessage('Hi, Welcome to Houzza AI.');
    // Future.delayed(const Duration(seconds: 5), () {
    //   sendBotMessage('Please enter which type of property you want?');
    // });
  }
  void sendBotMessage(String message) {
    _messages.add("Bot: $message");
    if (message.isNotEmpty) {
      ttsServiceTrans.speak(message, detectedLanguage);
    }
    notifyListeners();
  }

  void addBotMessage(dynamic message) {
    _messages.add(message);
    notifyListeners();
  }

  Future<void> sendMessage(String message) async {
    print('message-->$message');
    _messages.add("You: $message");

    String? response = staticResponses[message.toLowerCase()];
    if (response != null) {
      sendBotMessage(response);
    } else {
      if (message.toLowerCase().contains('?') || message.toLowerCase().contains('help')) {
        sendBotMessage("Welcome to the Houzza AI \n I am here to help you out");
        Future.delayed(const Duration(seconds: 6), () {
          sendBotMessage("You can give voice commands.");
        });
        Future.delayed(const Duration(seconds: 15), startListening);
      } else if (searchkey_words.any((keyword) => message.toLowerCase().contains(keyword))) {
        _AIchatbotController.search_ai(
          search_query: textController.text,
          keywords: '',
          search_area: area,
          city: city,
        );
        Future.delayed(const Duration(seconds: 2), () {
          if (_AIchatbotController.getSearchResults.isNotEmpty) {
            sendBotMessage("Ok, On the basis of your requirements we will suggest you some properties.");
            addBotMessage(searchResult());
          } else {
            sendBotMessage('No properties available.');
            if (city.isEmpty) {
              sendBotMessage('Do you want to search in another area, if yes enter another area?');
            }
          }
        });
      } else if (area_words.any((keyword) => message.toLowerCase().contains(keyword))) {
        sendBotMessage("Ok, Please enter area in which you are searching property.");
      } else {
        area = message;
        sendBotMessage("Ok, please describe which type of property you want. You can type, give voice command, or upload an image for reference.");
      }
    }
    textController.text = '';
    notifyListeners();
  }

  Future<void> pickImage(BuildContext context) async {
    imageSearchKeys = '';
    final picker = ImagePicker();
    final List<XFile>? images = await picker.pickMultiImage();

    if (images != null) {
      if (images.length > 3) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You can upload a maximum of 3 images.')),
        );
        return;
      }
      selectedImages = images.map((image) => File(image.path)).toList();
      for (File image in selectedImages) {
        await analyzeImage(image);
      }
      Future.delayed(const Duration(seconds: 3), () {
        if (selectedImages.isNotEmpty) {
          _AIchatbotController.search_ai(
            search_query: '',
            keywords: imageSearchKeys,
            search_area: area,
            city: city,
          );
          Future.delayed(const Duration(seconds: 2), () {
            if (_AIchatbotController.getSearchResults.isNotEmpty) {
              sendBotMessage("Ok, On the basis of your provided image we will suggest you some properties.");
              addBotMessage(searchResult());
            } else {
              sendBotMessage('No properties available.');
            }
          });
        }
      });
      notifyListeners();
    }
  }

  Future<void> analyzeImage(File imageFile) async {
    final apiKey = APIString.GoogleVisionApi;
    final url = Uri.parse('https://vision.googleapis.com/v1/images:annotate?key=$apiKey');

    final bytes = imageFile.readAsBytesSync();
    final base64Image = base64Encode(bytes);

    final requestPayload = {
      "requests": [
        {
          "image": {"content": base64Image},
          "features": [{"type": "LABEL_DETECTION", "maxResults": 10}]
        }
      ]
    };

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(requestPayload),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final labels = data['responses'][0]['labelAnnotations'];
      int maxKeywords = 6;
      List<dynamic> topLabels = labels.take(maxKeywords).toList();
      for (var label in topLabels) {
        print('Feature: ${label['description']} - Confidence: ${label['score']}');
        imageSearchKeys += "|${label['description']}";
      }
      print(imageSearchKeys);
    } else {
      print('Error: ${response.body}');
    }
  }

  Future<void> extractLocations(String query) async {
    final String apiKey = 'AIzaSyDY-oB0QysTXFJu2cOMlZvpwANBR2XS84E';
    final Uri url = Uri.parse('https://language.googleapis.com/v1/documents:analyzeEntities?key=$apiKey');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'document': {
          'type': 'PLAIN_TEXT',
          'content': query,
        },
        'encodingType': 'UTF8',
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      for (var entity in data['entities']) {
        if (entity['type'] == 'LOCATION') {
          print("Location: ${entity['name']}");
        }
      }
    } else {
      print("Error: ${response.body}");
    }
  }

  Widget searchResult() {
    return Obx(() {
      if (_AIchatbotController.getSearchResults.isNotEmpty) {
        return Container(
          color: AppColor.bgColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Top Properties",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColor.black,
                  ),
                ),
                boxH15(),
                SizedBox(
                  height: Get.height * 0.65,
                  width: Get.width * 0.8,
                  child: RawScrollbar(
                    thickness: 2,
                    thumbColor: Colors.blue,
                    trackColor: Colors.grey,
                    trackRadius: const Radius.circular(10),
                    controller: scrollController,
                    thumbVisibility: true,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const ClampingScrollPhysics(),
                      controller: scrollController,
                      itemCount: _AIchatbotController.getSearchResults.length > 4
                          ? 4
                          : _AIchatbotController.getSearchResults.length,
                      itemBuilder: (context, index) {
                        if (index == _AIchatbotController.getSearchResults.length) {
                          return Center(
                            child: TextButton(
                              onPressed: () {
                                print("View More tapped");
                              },
                              child: const Text(
                                'View More',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          );
                        }
                        return GestureDetector(
                          onTap: () {
                            Get.to(PropertyDetailsScreen(
                              id: _AIchatbotController.getSearchResults[index]['_id'],
                            ));
                          },
                          child: Container(
                            width: Get.width * 0.9,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(20)),
                              border: Border.all(color: AppColor.grey.shade200, width: 2),
                              color: AppColor.white,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    Center(
                                      child: CarouselSlider.builder(
                                        options: CarouselOptions(
                                          height: 250,
                                          autoPlay: true,
                                          enlargeCenterPage: true,
                                          viewportFraction: 1,
                                          aspectRatio: 16 / 9,
                                          enableInfiniteScroll: true,
                                          autoPlayInterval: const Duration(seconds: 3),
                                          autoPlayAnimationDuration: const Duration(milliseconds: 800),
                                          scrollDirection: Axis.horizontal,
                                          onPageChanged: (index, reason) {
                                            currentIndex = index;
                                            notifyListeners();
                                          },
                                        ),
                                        itemCount: _AIchatbotController.getSearchResults[index]['property_images']?.isNotEmpty ?? false
                                            ? _AIchatbotController.getSearchResults[index]['property_images'].length
                                            : 1,
                                        itemBuilder: (context, imageIndex, realIndex) {
                                          final property = _AIchatbotController.getSearchResults.isNotEmpty && index < _AIchatbotController.getSearchResults.length
                                              ? _AIchatbotController.getSearchResults[index]
                                              : null;
                                          final images = property?['property_images'] ?? [];
                                          final coverImg = property?['cover_image'] as String? ?? '';

                                          // Show grey box if both images and cover image are empty
                                          if (images.isEmpty && coverImg.isEmpty) {
                                            return Container(
                                              decoration: BoxDecoration(
                                                color: Colors.grey[400],
                                                borderRadius: BorderRadius.circular(15),
                                              ),
                                              child: const Center(
                                                child: Icon(
                                                  Icons.image_not_supported_outlined,
                                                  color: Colors.white,
                                                  size: 50,
                                                ),
                                              ),
                                            );
                                          }

                                          // Show cover image if images list is empty
                                          if (images.isEmpty) {
                                            return ClipRRect(
                                              borderRadius: BorderRadius.circular(15),
                                              child: Stack(
                                                fit: StackFit.expand,
                                                children: [
                                                  CachedNetworkImage(
                                                    imageUrl: coverImg,
                                                    fit: BoxFit.cover,
                                                    width: double.infinity,
                                                    placeholder: (context, url) => Container(
                                                      color: Colors.grey[300],
                                                      child: const Center(child: CircularProgressIndicator()),
                                                    ),
                                                    errorWidget: (context, url, error) => Container(
                                                      color: Colors.grey[400],
                                                      child: const Center(
                                                        child: Icon(Icons.image_rounded, color: Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }

                                          // Show property images if available
                                          return ClipRRect(
                                            borderRadius: BorderRadius.circular(15),
                                            child: Stack(
                                              fit: StackFit.expand,
                                              children: [
                                                CachedNetworkImage(
                                                  imageUrl: images[imageIndex]['image'],
                                                  fit: BoxFit.cover,
                                                  width: double.infinity,
                                                  placeholder: (context, url) => Container(
                                                    color: Colors.grey[300],
                                                    child: const Center(child: CircularProgressIndicator()),
                                                  ),
                                                  errorWidget: (context, url, error) => Container(
                                                    color: Colors.grey[400],
                                                    child: const Center(
                                                      child: Icon(Icons.image_rounded, color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    Positioned(
                                      top: 10,
                                      left: 04,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.3),
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        child: Text(
                                          "${_AIchatbotController.getSearchResults[index]['days_since_created'] ?? 0} Days on Houzza",
                                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter,
                                            colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            GestureDetector(
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                                decoration: const BoxDecoration(
                                                  color: Color(0xFF52C672),
                                                  borderRadius: BorderRadius.only(topRight: Radius.circular(10)),
                                                ),
                                                child: Text(
                                                  "FOR ${_AIchatbotController.getSearchResults[index]['property_category_type'].toUpperCase()}",
                                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                              onTap: () {
                                                if (isLogin == true) {
                                                  // Go to details page
                                                } else {
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                                                }
                                              },
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: List.generate(
                                                _AIchatbotController.getSearchResults[index]['property_images']?.length ?? 1,
                                                    (dotIndex) => Container(
                                                  width: 8,
                                                  height: 8,
                                                  margin: const EdgeInsets.symmetric(horizontal: 3),
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: currentIndex == dotIndex ? Colors.white : Colors.white.withOpacity(0.5),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                                decoration: const BoxDecoration(
                                                  color: Color(0xfffeb204),
                                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10)),
                                                ),
                                                child: const Text(
                                                  "featured",
                                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                              onTap: () {
                                                if (isLogin == true) {
                                                  // Go to details page
                                                } else {
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 10,
                                      right: 50,
                                      child: GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(0.5),
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          child: Row(
                                            children: [
                                              Image.asset("assets/image_rent/VirtualTour.png", width: 20, height: 20),
                                              const SizedBox(width: 5),
                                              const Text(
                                                "Virtual Tour",
                                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 10,
                                      right: 10,
                                      child: GestureDetector(
                                        onTap: () {
                                          if (isLogin == true) {
                                            if (!_AIchatbotController.getSearchResults[index]['is_favorite']) {
                                              search_controller
                                                  .addFavorite(property_id: controller.getFeaturedPropery[index]['_id'])
                                                  .then((_) {
                                                _AIchatbotController.getSearchResults[index]['is_favorite'] = true;
                                              });
                                            } else {
                                              search_controller
                                                  .removeFavorite(
                                                  property_id: controller.getFeaturedPropery[index]['_id'],
                                                  favorite_id: controller.getFeaturedPropery[index]['favorite_id'])
                                                  .then((_) {
                                                controller.getFeaturedPropery[index]['is_favorite'] = false;
                                              });
                                            }
                                            controller.getFeaturedProperty();
                                            notifyListeners();
                                          } else {
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                                          }
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(0.5),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            _AIchatbotController.getSearchResults[index]['is_favorite']
                                                ? Icons.favorite
                                                : Icons.favorite_outline_outlined,
                                            color: _AIchatbotController.getSearchResults[index]['is_favorite']
                                                ? AppColor.red
                                                : Colors.white,
                                            size: 22,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: Get.height * 0.3,
                                  width: Get.width,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 16.0, left: 16.0, top: 8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                _AIchatbotController.getSearchResults[index]['property_name'],
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColor.black87,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            InkWell(

                                              onTap: () async {

                                                shareProperty(controller.getFeaturedPropery[index]['_id']);

                                              },
                                              child: Container(
                                                width: 34,
                                                height: 34,
                                                decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Center(
                                                  child: Image.asset(
                                                    "assets/image_rent/share.png",
                                                    height: 18,
                                                    width: 18,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Image.asset(
                                                  "assets/image_rent/money.png",
                                                  height: 24,
                                                  width: 24,
                                                ),
                                                const SizedBox(width: 6),
                                                Text(
                                                  controller.formatIndianPrice(
                                                      _AIchatbotController.getSearchResults[index]['property_price'].toString() ?? '0'),
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColor.black87,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Image.asset(
                                                  "assets/image_rent/house.png",
                                                  height: 24,
                                                  width: 24,
                                                ),
                                                const SizedBox(width: 6),
                                                Text(
                                                  _AIchatbotController.getSearchResults[index]['bhk_type'],
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColor.black87,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Image.asset(
                                                  "assets/image_rent/format-square.png",
                                                  height: 24,
                                                  width: 24,
                                                ),
                                                const SizedBox(width: 6),
                                                Text(
                                                  '${_AIchatbotController.getSearchResults[index]['area']?.toString() ?? ''} ${_AIchatbotController.getSearchResults[index]['area_in']?.toString() ?? ''}'.trim(),
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColor.black87,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Image.asset(
                                                  "assets/image_rent/squareft.png",
                                                  height: 24,
                                                  width: 24,
                                                ),
                                                const SizedBox(width: 6),
                                                Text(
                                                  _AIchatbotController.getSearchResults[index]['furnished_type'] ?? '',
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColor.black87,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        boxH15(),
                                        Text(
                                          '${_AIchatbotController.getSearchResults[index]['address']},\n${_AIchatbotController.getSearchResults[index]['city_name']}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: AppColor.black.withOpacity(0.6),
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        boxH15(),
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 24,
                                              backgroundColor: AppColor.grey.withOpacity(0.1),
                                              child: ClipOval(
                                                child: Image.asset(
                                                  'assets/image_rent/profile.png',
                                                  width: 30,
                                                  height: 30,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            boxW15(),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  _AIchatbotController.getSearchResults[index]['connect_to_name'] ?? 'unknown',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                Text(
                                                  _AIchatbotController.getSearchResults[index]['user_type'] ?? 'unknown',
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
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
          ),

        );
      } else {
        return const SizedBox();
      }
    });
  }

  void toggleTextField() {
    openTextField = !openTextField;
    notifyListeners();
  }

  void handleTextInput(String text) {
    if (text.length == 70) {
      sendBotMessage('You had reached maximum input character \n limit. Please summarize it.');
    }
    notifyListeners();
  }
}