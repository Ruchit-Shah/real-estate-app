import 'package:video_player/video_player.dart';

class VideoItem {
  final String videoUrl;
  final String? thumbnail;
  VideoPlayerController? controller;

  VideoItem({required this.videoUrl,this.thumbnail});
}