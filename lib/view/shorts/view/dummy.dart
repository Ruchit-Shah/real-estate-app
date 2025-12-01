import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class VideoPlayerItem123 extends StatefulWidget {


  VideoPlayerItem123({Key? key}) : super(key: key);

  @override
  _VideoPlayerItem123State createState() => _VideoPlayerItem123State();
}

class _VideoPlayerItem123State extends State<VideoPlayerItem123> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    final filePath = await _getLocalFilePath();
    final fileExists = await File(filePath).exists();

    if (fileExists) {
      // If file exists, load from local storage
      _controller = VideoPlayerController.file(File(filePath));
    } else {
      // If file does not exist, download and save it
      _controller = VideoPlayerController.file(File(filePath));
    }

    try {
      await _controller.initialize();
      setState(() {
        _isInitialized = true;
        _isLoading = false;
      });
    } catch (e) {
      print('Error initializing video: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<String> _getLocalFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/cached_video.mp4';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _isLoading
          ? const CircularProgressIndicator(color: Colors.purple)
          : _isInitialized
          ? AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: VideoPlayer(_controller),
      )
          : const Text('Error loading video'),
    );
  }
}


