import 'package:flutter_tts/flutter_tts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class TranslationAndTTS {
  final FlutterTts flutterTts = FlutterTts();

  // Translation API
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

  // Future<Map<String, dynamic>> analyzeSentiment(String text, String targetLanguage) async {
  //   final url = 'https://language.googleapis.com/v1/documents:analyzeSentiment?key=$apiKey';
  //
  //   final response = await http.post(
  //     Uri.parse(url),
  //     headers: {
  //       'Content-Type': 'application/json',
  //     },
  //     body: json.encode({
  //       'document': {
  //         'type': 'PLAIN_TEXT',
  //         'content': text,
  //       },
  //       'encodingType': 'UTF8',
  //     }),
  //   );
  //   print(response.body.toString());
  //   if (response.statusCode == 200) {
  //     return json.decode(response.body);
  //   } else {
  //     throw Exception('Failed to analyze sentiment');
  //   }
  // }

  // TTS
  Future<void> speak(String text, String languageCode) async {
    if (text.isNotEmpty) {
      await flutterTts.setLanguage(languageCode);
      await flutterTts.setSpeechRate(0.5); // Optional: Adjust speech rate
      await flutterTts.setPitch(1.0); // Optional: Adjust pitch
      await flutterTts.speak(text);
    }
  }

  Future<void> stop() async {
    await flutterTts.stop();
  }

  // Translate and Speak
  Future<void> translateAndSpeak(String text, String targetLanguageCode) async {
    try {
      final translatedText = await translateText(text, targetLanguageCode);
      //print(translatedText);
      await speak(translatedText, targetLanguageCode);
    } catch (e) {
      print("Error: $e");
    }
  }
}
