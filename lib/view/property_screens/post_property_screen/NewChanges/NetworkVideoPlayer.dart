import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class NetworkVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final bool autoPlay;
  final bool showControls;

  const NetworkVideoPlayer({
    required this.videoUrl,
    this.autoPlay = false,
    this.showControls = false,
    super.key,
  });

  @override
  State<NetworkVideoPlayer> createState() => _NetworkVideoPlayerState();
}

class _NetworkVideoPlayerState extends State<NetworkVideoPlayer> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() {
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
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
      }).catchError((error) {
        if (mounted) {
          setState(() {
            _isInitialized = false;
          });
        }
      });
  }

  @override
  void didUpdateWidget(NetworkVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoUrl != widget.videoUrl) {
      _controller.dispose();
      _isInitialized = false;
      _isPlaying = false;
      _initializeVideo();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Container(
        color: Colors.black12,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return GestureDetector(
      onTap: () {
        if (!widget.showControls) {
          showVideoPreviewDialog(widget.videoUrl);
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
            const Icon(
              Icons.play_circle_fill,
              size: 50,
              color: Colors.white70,
            ),
          if (widget.showControls) ...[
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
                  backgroundColor: Colors.white30,
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              child: IconButton(
                icon: Icon(
                  _isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                  size: 30,
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

void showVideoPreviewDialog(String videoUrl) {
  Get.dialog(
    Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        height: Get.height * 0.5,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Expanded(
              child: NetworkVideoPlayer(
                videoUrl: videoUrl,
                autoPlay: true,
                showControls: true,
              ),
            ),
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    ),
  );
}