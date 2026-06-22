import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:wink_app/models/short_model.dart';

class ShortsCard extends StatefulWidget {
  final ShortModel short;
  final bool isActive;
  final bool shouldInit;

  const ShortsCard({
    super.key,
    required this.short,
    required this.isActive,
    required this.shouldInit,
  });

  @override
  State<ShortsCard> createState() => _ShortsCardState();
}

class _ShortsCardState extends State<ShortsCard> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    if (widget.shouldInit) _initController();
  }

  @override
  void didUpdateWidget(covariant ShortsCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Init when scrolling into range
    if (widget.shouldInit && _controller == null) {
      _initController();
    }

    // Dispose when scrolling far away - frees RAM
    if (!widget.shouldInit && _controller!= null) {
      _controller?.dispose();
      _controller = null;
      _isInitialized = false;
    }

    // Play/pause logic
    if (widget.isActive) {
      _controller?.play();
    } else {
      _controller?.pause();
    }
  }

  Future<void> _initController() async {
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.short.videoUrl));
    await _controller!.initialize();
    _controller!.setLooping(true);
    if (widget.isActive && mounted) _controller!.play();
    if (mounted) setState(() => _isInitialized = true);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Video - handles 1:1 and 9:16 automatically
        if (_isInitialized && _controller!= null)
          Container(
            color: Colors.black,
            child: Center(
              child: AspectRatio(
                aspectRatio: _controller!.value.aspectRatio,
                child: VideoPlayer(_controller!),
              ),
            ),
          )
        else
          const Center(child: CircularProgressIndicator(color: Colors.white)),

        // Gradient for caption readability
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 200,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.black.withValues(alpha: 0.6), Colors.transparent],
              ),
            ),
          ),
        ),

        // Caption
        Positioned(
          bottom: 100,
          left: 16,
          right: 80,
          child: Text(
            widget.short.caption,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              shadows: [Shadow(blurRadius: 4, color: Colors.black)],
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),

        // Right side buttons - likes, comments etc
        Positioned(
          bottom: 100,
          right: 16,
          child: Column(
            children: [
              IconButton(
                icon: const Icon(Icons.favorite, color: Colors.white, size: 32),
                onPressed: () {},
              ),
              Text(
                '${widget.short.likesCount}',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
              const SizedBox(height: 16),
              IconButton(
                icon: const Icon(Icons.comment, color: Colors.white, size: 32),
                onPressed: () {},
              ),
              Text(
                '${widget.short.commentsCount}',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}