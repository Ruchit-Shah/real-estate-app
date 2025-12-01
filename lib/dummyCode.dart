import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:real_estate_app/global/api_string.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/search_screen/searchController.dart';
import 'package:real_estate_app/view/dashboard/controller/BotController.dart';
import 'package:real_estate_app/view/property_screens/recommended_properties_screen/properties_details_screen.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:get/get.dart' as getx;
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../../../global/TTS_Service.dart';
import '../../../utils/TTS_NativeService.dart';
import '../../../utils/text_style.dart';

import 'view/auth/login_screen/login_screen.dart';
import 'view/dashboard/imageRecognization/keyword_pattern.dart';
import 'view/splash_screen/splash_screen.dart';

class Onboarding_Screen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<Onboarding_Screen> {

  final TranslationAndTTS ttsServiceTrans = TranslationAndTTS();
  String detected_language='en',_lastWords='',propertyPurpose='';
  String image_search_keys='';
  final TextEditingController _controller = TextEditingController();
  final List<dynamic> _messages = [];
  final TtsService ttsService = TtsService();
  final stt.SpeechToText _speechToText = stt.SpeechToText();
  String command='',area='',city='';
  bool _speechEnabled=false;
  bool isListning= false;
  final Map<String, dynamic> staticResponses = {};
  final BotController _AIchatbotController = getx.Get.put(BotController());
  final searchController search_controller = Get.put(searchController());
  List<File> selectedImages = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initialize(context);
    _initSpeech();
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    _controller.clear();
    await _speechToText.listen(
        onResult: _onSpeechResult, listenFor: const Duration(seconds: 10));
    if (mounted){
      setState(() {
        _speechToText.isListening;
      });
      Future.delayed(const Duration(seconds: 10), () {
        _stopListening();
      });
    }
  }

  void _stopListening() async {
    await _speechToText.stop();
    if(mounted){
      setState(() {
        _speechToText.isNotListening;
      });
    }
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    String recognizedWords = result.recognizedWords;
    setState(() {
      _controller.text = recognizedWords;
      command=recognizedWords;
    });
    if (result.finalResult) {
      //_sendMessage(command);
      _detectLanguage(command);
      _stopListening();
    }
  }

  Future<void> _detectLanguage(String text) async {
    final translatedText = await translateText(text, "en");
    print('Detected Language = '+detected_language);
    _sendMessage(translatedText);
  }

  Future<String> translateText(String text, String targetLanguage) async {
    const String apiKey = "AIzaSyDY-oB0QysTXFJu2cOMlZvpwANBR2XS84E"; // Replace with your API key
    const String baseUrl = "https://translation.googleapis.com/language/translate/v2";
    final Uri url = Uri.parse("$baseUrl?key=$apiKey");
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'q': text,
          'target': targetLanguage,
        }),
      );

      // Debugging: Log status code

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        //print("Translated Text: ${data['data']['translations'][0]['translatedText']}");
        return data['data']['translations'][0]['translatedText'];

      } else {
        // Debugging: Log error
        print("Error: ${response.body}");
        throw Exception("Failed to translate text");
      }
    } catch (e) {
      print("Exception: $e");
      throw Exception("Failed to connect to the translation API");
    }
  }

  Future<void> _initialize(BuildContext context) async {

    _sendBotMessage('Hi , Welcome to Houzza AI .');

    Future.delayed(const Duration(seconds: 5), ()
    {
      _sendBotMessage('Please enter which type of property you want?');
    });
  }

  void _sendBotMessage(String message) {
    if (mounted) {
      setState(() {
        _messages.add("Bot: $message");
        if(message!='') {
          ttsServiceTrans.speak(message,detected_language);
        }
      });
    }
  }

  void _addBotMessage(dynamic message) {
    setState(() {
      _messages.add(message);
    });
  }

  Future<void> _sendMessage(String message) async {
    print( 'message-->${ message}');
    setState(() {
      _messages.add("You: $message");
    });

    String? response = staticResponses[message.toLowerCase()];

    if (response != null) {
      _sendBotMessage(response);
    } else {
      if (message.toLowerCase().contains('?') ||message.toLowerCase().contains('help')) {
        _sendBotMessage("Welcome to the Houzza AI \n I am here to help you out");
        Future.delayed(const Duration(seconds: 6), () {
          _sendBotMessage("You can give voice commands.");
        });

        Future.delayed(const Duration(seconds: 15), () {
          _startListening();
        });

      }
      else if(searchkey_words.any((keyword) => message.toLowerCase().contains(keyword))){
        //extractLocations(message);
        _AIchatbotController.search_ai(search_query: _controller.text,keywords: '',search_area:'',city: city);
        Future.delayed(const Duration(seconds: 2), () {
          if(_AIchatbotController.getSearchResults.isNotEmpty) {
            _sendBotMessage("Ok, On the basis of your requirements we will suggest you some properties.");
            _addBotMessage(searchResult());
          }else{
            _sendBotMessage('No properties available.');
            if(city.isEmpty){
              _sendBotMessage('Do you want to search in another area ,if yes enter another area ?');
            }
          }
        });
      }
      else if(area_words.any((keyword) => message.toLowerCase().contains(keyword))){
        _sendBotMessage("Ok, Please enter area in which you are searching property.");
      }else{
        area=message;
        _sendBotMessage("Ok, please describe which type of property you want.You can type, give voice command or upload image for reference");
      }
    }
    _controller.text='';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Colors.deepPurple.shade50,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.amber.shade200),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child:SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 50),
                TextAnimator(
                  'Houzza AI',
                  atRestEffect: WidgetRestingEffects.pulse(effectStrength: 0.5),
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  incomingEffect: WidgetTransitionEffects.incomingSlideInFromTop(
                      blur: const Offset(0, 20), scale: 2),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 10),

                Container(
                  height: 650,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          reverse: true,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0,bottom: 15,left: 8.0,right: 8.0),
                            child: Column(
                              children: _messages.map((message) {
                                if (message is String) {
                                  final bool isUserMessage = message.startsWith("You:");
                                  return Column(
                                    crossAxisAlignment: isUserMessage
                                        ? CrossAxisAlignment.end
                                        : CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: isUserMessage
                                            ? MainAxisAlignment.end
                                            : MainAxisAlignment.start,
                                        children: [
                                          if (!isUserMessage)
                                            Padding(
                                              padding: const EdgeInsets.only(left: 6.0),
                                              child: Image.asset(
                                                'assets/app_logo.png',
                                                height: 40,
                                                width: 40,
                                              ),
                                            ),
                                          Container(

                                            width: isUserMessage ? 160.0 : 160.0,
                                            padding: const EdgeInsets.all(6.0),
                                            margin: const EdgeInsets.all(4.0),
                                            decoration: BoxDecoration(

                                              color: isUserMessage
                                                  ? Colors.green.withOpacity(0.2)
                                                  : Colors.purple.withOpacity(0.2),
                                              border: Border.all(
                                                color: isUserMessage
                                                    ? Colors.green[800]!
                                                    : Colors.purple[800]!,
                                              ),
                                              // borderRadius: BorderRadius.circular(8.0),
                                              borderRadius:isUserMessage?
                                              const BorderRadius.only(
                                                topLeft: Radius.circular(10.0),
                                                topRight: Radius.circular(10.0),
                                                bottomLeft: Radius.circular(10.0),
                                                bottomRight: Radius.circular(10.0),
                                              ):
                                              const BorderRadius.only(
                                                topLeft: Radius.circular(10.0),
                                                topRight: Radius.circular(10.0),
                                                bottomLeft: Radius.circular(10.0),
                                                bottomRight: Radius.circular(10.0),
                                              ),
                                            ),//stop
                                            child:
                                            isUserMessage
                                                ? Text(
                                              message.substring(message.indexOf(":") + 2),
                                            )
                                                : TyperAnimatedTextKit(
                                              speed: const Duration(milliseconds: 60),
                                              isRepeatingAnimation: false,
                                              text: [
                                                message.substring(message.indexOf(":") + 2)
                                              ],
                                              textStyle: const TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          if (isUserMessage)
                                            Padding(
                                              padding: const EdgeInsets.only(left: 8.0),
                                              child: Image.asset(
                                                'assets/man.png',
                                                height: 40,
                                                width: 40,
                                              ),
                                            ),
                                        ],
                                      ),
                                      const SizedBox(height: 4.0),
                                    ],
                                  );
                                } else if (message is Widget) {
                                  return message;
                                } else {
                                  return Container();
                                }
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                      _speechToText.isListening || isListning?
                      const Expanded(child:
                      Column(children: [
                        // SizedBox(
                        //   height:65,
                        //   child: Image.asset('assets/aibot3.GIF'),),
                        RippleAnimation(
                          child: Icon(Icons.mic_none_sharp,size: 45,),
                          color: Colors.deepOrange,
                          delay: Duration(milliseconds: 500),
                          repeat: true,
                          minRadius: 25,
                          maxRadius: 40,
                          ripplesCount: 6,
                          duration: Duration(milliseconds: 6 * 300),
                        ),
                        Text('listening...')
                      ],
                      )
                      ):Container(),

                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          //height: 43,
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            border: Border.all(
                              color: Colors.black,
                              width: 1.0,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _controller,
                                  decoration: InputDecoration(
                                    counterText: '',
                                    hintText: _speechToText.isListening
                                        ? _lastWords
                                        : _speechEnabled
                                        ? 'Tap the microphone to start speaking...'
                                        : 'Speech not available',
                                    hintStyle: const TextStyle(fontSize: 14),
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.transparent),
                                    ),
                                    enabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.transparent),
                                    ),
                                  ),
                                  onChanged: (text) {
                                    setState(() {
                                      if(text.length == 70){
                                        _sendBotMessage('you had reached maximum input character \n limit.Please summarize it.');
                                      }
                                    });
                                  },
                                  maxLines: 1,
                                  minLines: 1,
                                  maxLength: 70,
                                  onSubmitted: (String value) {
                                    String message = _controller.text.trim();
                                    if (message.isNotEmpty) {
                                      if(_speechToText.isListening ||  isListning){
                                        isListning=false;
                                        _stopListening();
                                        ttsService.stop();
                                      }
                                      _sendMessage(message);
                                      _controller.clear();
                                    }

                                  },
                                ),
                              ),
                              IconButton(
                                icon: const SizedBox(
                                  height: 45,
                                  width: 45,
                                  child: Icon(Icons.send),
                                ),
                                onPressed: () {
                                  String message = _controller.text.trim();

                                  if(_speechToText.isListening ||  isListning){
                                    isListning=false;
                                    _stopListening();
                                    ttsService.stop();
                                  }
                                  if (message.isNotEmpty) {
                                    _sendMessage(message);
                                    _controller.clear();
                                  }
                                },
                              ),
                              IconButton(
                                icon: const SizedBox(
                                  height: 45,
                                  width: 45,
                                  child: Icon(Icons.image),
                                ),
                                onPressed: () {
                                  if(area=='')
                                    _sendBotMessage('Please enter area in which you are searching property .');
                                  else
                                    pickImage();
                                },
                              ),
                              IconButton(
                                visualDensity: const VisualDensity(horizontal: -2.0, vertical: -2.0),
                                padding: EdgeInsets.zero,
                                onPressed: (){
                                  print("isListening "+isListning.toString());
                                  if(_speechToText.isListening || isListning){
                                    isListning=false;
                                    _stopListening();
                                    ttsService.stop();
                                  }else{
                                    ttsService.stop();
                                    _startListening();
                                  }
                                },
                                icon: AvatarGlow(
                                  glowColor: _speechToText.isListening ?const Color(0xFFFC0015): Colors.white,
                                  glowRadiusFactor: _speechToText.isListening ? 0.5 : 0.6,
                                  duration: const Duration(milliseconds: 2000),
                                  repeat: true,
                                  curve: Curves.easeOutQuad,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      _speechToText.isListening? Icons.mic : Icons.mic_off,
                                      color: _speechToText.isListening  ? const Color(0xFFD72F41) : Colors.deepPurpleAccent,
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
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> pickImage() async {
    image_search_keys='';
    final picker = ImagePicker();
    final List<XFile>? images = await picker.pickMultiImage();

    if (images != null) {
      // Validate number of selected images
      if (images.length > 3) {
        // Show an error message if more than 3 images are selected
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You can upload a maximum of 3 images.')),
        );
        return;
      }
      // Proceed if the number of selected images is exactly 3
      setState(() {
        selectedImages = images.map((image) => File(image.path)).toList();
        for (File image in selectedImages) {
          analyzeImage(image); // Your custom function to process images
        }

        // Perform delayed actions
        Future.delayed(const Duration(seconds: 3), () {
          if (selectedImages.isNotEmpty) {
            _AIchatbotController.search_ai(search_query: '', keywords: image_search_keys,search_area:area,city:city);
            Future.delayed(const Duration(seconds: 2), ()
            {
              if (_AIchatbotController.getSearchResults.isNotEmpty) {
                _sendBotMessage(
                  "Ok, On the basis of your provided image we will suggest you some properties.",
                );
                //_addBotMessage(image_search_keys);
                _addBotMessage(searchResult());
              } else {
                _sendBotMessage('No properties available.');
              }
            });
          }
        });
      });
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
      // for (var label in labels) {
      //   print('Feature: ${label['description']} - Confidence: ${label['score']}');
      //   image_search_keys=image_search_keys+"|"+label['description'];
      //   print(image_search_keys);
      // }
      int maxKeywords = 6;
      List<dynamic> topLabels = labels.take(maxKeywords).toList(); // Get top 6 or fewer if less

      for (var label in topLabels) {
        print('Feature: ${label['description']} - Confidence: ${label['score']}');
        image_search_keys += "|${label['description']}";
      }
      print(image_search_keys);
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
      print(data);
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
    return Container(
      height: 295, // Adjust to fit your content
      width: double.infinity,
      padding: const EdgeInsets.all(5.0),
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
        //color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child:Obx(()=>ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _AIchatbotController.getSearchResults.length, // +1 for the "View More" option
        itemBuilder: (context, index) {
          if (index == _AIchatbotController.getSearchResults.length) {
            return Center(
              child: TextButton(
                onPressed: () {
                  // Handle "View More" action
                  print("View More tapped");
                },
                child: const Text(
                  'View More',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            );
          }

          final property = _AIchatbotController.getSearchResults[index];
          return GestureDetector(
            onTap: () {
              print('tap');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PropertyDetailsScreen(
                      id:  _AIchatbotController.getSearchResults[index]['_id']),
                ),
              );
            },
            child: Container(
              width: 250, // Set a fixed width for each card
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Card(
                elevation: 0.3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(15.0),
                          ),
                          child: Image.network(
                            property['cover_image'],
                            fit: BoxFit.cover,
                            height: 130,
                            width: double.infinity,
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: GestureDetector(
                            onTap: () {
                              // Handle favorite toggle
                              if(isLogin==true){
                                if (_AIchatbotController.getSearchResults[index] != null && !_AIchatbotController.getSearchResults[index]['is_favorite']) {
                                  search_controller.addFavorite(property_id: _AIchatbotController.getSearchResults[index]['_id']).then((_) {
                                    _AIchatbotController.getSearchResults[index]['is_favorite'] = true;
                                    _AIchatbotController.getSearchResults.refresh();
                                    //setState(() {});
                                  });
                                } else {
                                  search_controller.removeFavorite(
                                    property_id:_AIchatbotController.getSearchResults[index]['_id'],
                                    favorite_id:_AIchatbotController.getSearchResults[index]['favorite_id'],
                                  ).then((_) {
                                    _AIchatbotController.getSearchResults[index]['is_favorite'] = false;
                                    _AIchatbotController.getSearchResults.refresh();
                                  });
                                }
                              }else{
                                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                              }
                              // setState(() {
                              //   property['is_favorite'] = !property['is_favorite'];
                              // });
                            },
                            child: Obx(()=>
                                Icon(
                                  _AIchatbotController.getSearchResults[index]['is_favorite']
                                      ? Icons.favorite : Icons.favorite_border,
                                  color: _AIchatbotController.getSearchResults[index]['is_favorite'] ? Colors.red :
                                  Colors.grey,
                                ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5),
                          Text(
                            'Price: ₹ ${property['property_price']}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Type: ${property['property_type']} | Area: ${property['area_sq']} sq. ft.',
                            style: const TextStyle(fontSize: 14),
                          ),
                          // const SizedBox(height: 5),
                          // Text(
                          //   'Furnished: ${property['furnished_type']} |Security: ${property['security']}',
                          //   style: const TextStyle(fontSize: 14),
                          // ),
                          Text(
                            'Address: ${property['address']}',
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      )),
    );
  }


}




