import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/global/app_color.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoPath;
  final bool autoPlay;
  final bool showControls;

  const VideoPlayerWidget({
    required this.videoPath,
    this.autoPlay = false,
    this.showControls = false,
  });

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoPath)
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            _isInitialized = true;
            if (widget.autoPlay) {
              _controller.play();
              _isPlaying = true;
            }
          });
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Center(
        child: Container(
          color: Colors.black12,
          child: const Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        if (!widget.showControls) {
          showVideoPreview(widget.videoPath);
        }
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          ),
          if (!widget.showControls && !_isPlaying)
            const Icon(Icons.play_circle_fill, size: 50, color: Colors.white70),
          if (widget.showControls)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: VideoProgressIndicator(
                _controller,
                allowScrubbing: true,
                colors: const VideoProgressColors(
                  playedColor: Colors.red,
                  bufferedColor: Colors.grey,
                  backgroundColor: Colors.white,
                ),
              ),
            ),
          if (widget.showControls)
            Positioned(
              bottom: 10,
              child: IconButton(
                icon: Icon(
                  _isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    if (_isPlaying) {
                      _controller.pause();
                    } else {
                      _controller.play();
                    }
                    _isPlaying = !_isPlaying;
                  });
                },
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

void showVideoPreview(String videoPath) {
  Get.dialog(
    Dialog(
      child: Container(
        height: Get.height * 0.5,
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(10)
        ),
        child: Column(
          children: [
            Expanded(
              child: VideoPlayerWidget(
                videoPath: videoPath,
                autoPlay: true,
              ),
            ),
            TextButton(
              onPressed: () => Get.back(),
              child: Text('Close'),
            ),
          ],
        ),
      ),
    ),
  );
}