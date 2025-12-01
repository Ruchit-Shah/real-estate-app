// import 'dart:typed_data';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: MyHomePage(),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   File? thumbnailFile;
//   Uint8List thumbnailData = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _createThumbnailFile();
//   }
//
//   Future<void> _createThumbnailFile() async {
//     try {
//
//       thumbnailFile = await createFileFromUint8List(thumbnailData);
//       setState(() {}); // Refresh the UI after the file is created
//     } catch (e) {
//       print('Error creating thumbnail file: $e');
//     }
//   }
//
//   Future<File> createFileFromUint8List(Uint8List uint8List) async {
//
//     Directory tempDir = await getTemporaryDirectory();
//     String tempPath = tempDir.path;
//     File tempFile = File('$tempPath/thumbnail${DateTime.now().microsecondsSinceEpoch}.jpg');
//     await tempFile.writeAsBytes(uint8List);
//     return tempFile;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Thumbnail Example'),
//       ),
//       body: Center(
//         child: thumbnailFile != null
//             ? Image.file(thumbnailFile!)
//             : CircularProgressIndicator(),
//       ),
//     );
//   }
// }
