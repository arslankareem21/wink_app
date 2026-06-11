import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:wink_app/models/short_model.dart';


class ShortsCard extends StatefulWidget {
  final ShortModel short;
  final bool isActive;

  const ShortsCard({
    super.key,
    required this.short,
    required this.isActive,
  });

  @override
  State<ShortsCard> createState() => _ShortsCardState();
}

class _ShortsCardState extends State<ShortsCard> {
  late VideoPlayerController controller;

  @override
  void initState() {
    super.initState();

    controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.short.videoUrl),
    )..initialize().then((_) {
        if (widget.isActive) {
          controller.play();
        }
        setState(() {});
      });

    controller.setLooping(true);
  }

  @override
  void didUpdateWidget(covariant ShortsCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isActive) {
      controller.play();
    } else {
      controller.pause();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        controller.value.isInitialized
            ? FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: controller.value.size.width,
                  height: controller.value.size.height,
                  child: VideoPlayer(controller),
                ),
              )
            : const Center(child: CircularProgressIndicator()),

        // bottom caption
        Positioned(
          bottom: 50,
          left: 10,
          right: 10,
          child: Text(
            widget.short.caption,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}