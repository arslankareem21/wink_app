import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatelessWidget {
  const VideoPlayerWidget({
    super.key,
    required this.controller,
    required this.isLoading,
    required this.hasError,
  });

  final VideoPlayerController? controller;
  final bool isLoading;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    if (hasError) {
      return const ColoredBox(
        color: Colors.black,
        child: Center(
          child: Icon(
            Icons.error_outline,
            color: Colors.white54,
            size: 60,
          ),
        ),
      );
    }

    final videoController = controller;

    if (videoController == null) {
      return const ColoredBox(
        color: Colors.black,
        child: Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    try {
      if (!videoController.value.isInitialized) {
        return const ColoredBox(
          color: Colors.black,
          child: Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        );
      }

      return Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: videoController.value.size.width,
                height: videoController.value.size.height,
                child: VideoPlayer(videoController),
              ),
            ),
          ),

          // Point 5: Buffer indicator - only while buffering
          if (videoController.value.isBuffering)
            IgnorePointer(
              child: Container(
                color: Colors.black26,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              ),
            ),

          // Point 4: Show play icon when paused
          if (!videoController.value.isPlaying)
            Center(
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: const BoxDecoration(
                  color: Colors.black45,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 60,
                ),
              ),
            ),
        ],
      );
    } catch (_) {
      return const ColoredBox(
        color: Colors.black,
        child: Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }
  }
}