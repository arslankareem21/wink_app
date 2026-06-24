

// 🎬 Custom Lifecycle-Aware Video Widget Grid View Items ke liye
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:wink_app/models/reels/reels_models.dart';

class ReelGridItem extends StatefulWidget {
  final ReelModel reel;
  const ReelGridItem({super.key, required this.reel});

  @override
  State<ReelGridItem> createState() => _ReelGridItemState();
}

class _ReelGridItemState extends State<ReelGridItem> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // Video URL se native network controller init kiya
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.reel.videoUrl))
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            _isInitialized = true;
          });
          _controller.setLooping(true);
          _controller.setVolume(0.0); // Keep muted inside grid list
          _controller.play();
        }
      }).catchError((error) {
        print("Video rendering error inside grid element: $error");
      });
  }

  @override
  void dispose() {
    _controller.dispose(); // Avoid memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Center(
        child: CircularProgressIndicator(strokeWidth: 1.5),
      );
    }

    return FittedBox(
      fit: BoxFit.cover,
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        width: _controller.value.size.width,
        height: _controller.value.size.height,
        child: VideoPlayer(_controller),
      ),
    );
  }
}