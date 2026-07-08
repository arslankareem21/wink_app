import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:cached_network_image/cached_network_image.dart';

class VideoPlayerWidget extends StatelessWidget {
  const VideoPlayerWidget({
    super.key,
    required this.controller,
    required this.isLoading,
    required this.hasError,
    required this.thumbnailUrl,
  });

  final VideoPlayerController? controller;
  final bool isLoading;
  final bool hasError;
  final String thumbnailUrl;

  @override
  Widget build(BuildContext context) {
    if (hasError) {
      return const ColoredBox(
        color: Colors.black,
        child: Center(
          child: Icon(Icons.error_outline, color: Colors.white54, size: 60),
        ),
      );
    }

    Widget buildPlaceholder() {
      if (thumbnailUrl.isNotEmpty) {
        return CachedNetworkImage(
          imageUrl: thumbnailUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => const ColoredBox(color: Colors.black),
          errorWidget: (context, url, error) => const ColoredBox(color: Colors.black),
        );
      }
      return const ColoredBox(color: Colors.black);
    }

    final videoController = controller;

    if (videoController == null) {
      return buildPlaceholder();
    }

    return ValueListenableBuilder<VideoPlayerValue>(
      valueListenable: videoController,
      builder: (context, value, _) {
        if (!value.isInitialized) {
          return buildPlaceholder();
        }

        final videoSize = value.size;
        final videoWidth = videoSize.width > 0
            ? videoSize.width
            : MediaQuery.of(context).size.width;
        final videoHeight = videoSize.height > 0
            ? videoSize.height
            : MediaQuery.of(context).size.height;

        return Stack(
          fit: StackFit.expand,
          children: [
            Center(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: videoWidth,
                  height: videoHeight,
                  child: VideoPlayer(videoController),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
