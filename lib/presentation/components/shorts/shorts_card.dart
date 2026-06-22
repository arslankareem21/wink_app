import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:wink_app/models/auth/user_model.dart';
import 'package:wink_app/models/short_model.dart';
import 'package:wink_app/models/user_model.dart';

class ShortsCard extends StatefulWidget {
  final ShortModel short;
  final UserModel? user;
  final bool isActive;
  final bool shouldInit;
  final bool isLiked;
  final bool isFollowing;
  final bool isOwnVideo;
  final VoidCallback onLike;
  final VoidCallback onFollow;
  final VoidCallback onViewCount;
  final Function(String userId) onUserTap;

  const ShortsCard({
    super.key,
    required this.short,
    required this.user,
    required this.isActive,
    required this.shouldInit,
    required this.isLiked,
    required this.isFollowing,
    required this.isOwnVideo,
    required this.onLike,
    required this.onFollow,
    required this.onViewCount,
    required this.onUserTap,
  });

  @override
  State<ShortsCard> createState() => _ShortsCardState();
}

class _ShortsCardState extends State<ShortsCard> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _hasError = false;
  bool _isInitializing = false;
  bool _isPausedByTap = false;

  @override
  void initState() {
    super.initState();
    if (widget.shouldInit) _initController();
  }

  @override
  void didUpdateWidget(covariant ShortsCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.shouldInit && _controller == null &&!_hasError &&!_isInitializing) {
      _initController();
    } else if (!widget.shouldInit && _controller!= null) {
      _disposeController();
    }

    if (_controller!= null && _isInitialized) {
      if (widget.isActive &&!_isPausedByTap) {
        _controller!.play();
        _controller!.setVolume(1.0);
        widget.onViewCount(); // Counts view once
      } else {
        _controller!.pause();
        _controller!.setVolume(0.0);
      }
    }
  }

  Future<void> _initController() async {
    if (_isInitializing) return;
    _isInitializing = true;

    try {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.short.videoUrl),
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: false),
      );

      await _controller!.initialize();
      _controller!.setLooping(true); // Loop video continuously
      _controller!.setVolume(0.0);

      if (widget.isActive && mounted) {
        _controller!.play();
        _controller!.setVolume(1.0);
        widget.onViewCount();
      }

      if (mounted) setState(() => _isInitialized = true);
    } catch (e) {
      if (mounted) setState(() => _hasError = true);
    } finally {
      _isInitializing = false;
    }
  }

  void _disposeController() {
    _controller?.pause();
    _controller?.dispose();
    _controller = null;
    _isInitialized = false;
  }

  @override
  void dispose() {
    _disposeController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Video Player
        if (_hasError)
          Container(
            color: Colors.black,
            child: const Center(
              child: Icon(Icons.error_outline, color: Colors.white38, size: 60),
            ),
          )
        else if (_isInitialized && _controller!= null)
          GestureDetector(
            onTap: () {
              setState(() => _isPausedByTap =!_isPausedByTap);
              _isPausedByTap? _controller!.pause() : _controller!.play();
            },
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller!.value.size.width,
                height: _controller!.value.size.height,
                child: VideoPlayer(_controller!),
              ),
            ),
          )
        else
          Container(
            color: Colors.black,
            child: const Center(
              child: SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              ),
            ),
          ),

        // Pause Icon Overlay
        if (_isPausedByTap)
          Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.play_arrow, color: Colors.white, size: 50),
            ),
          ),

        // Gradient
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 300,
          child: IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                ),
              ),
            ),
          ),
        ),

        // User Info + Caption
        Positioned(
          bottom: 80,
          left: 16,
          right: 80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Username + Follow
              Row(
                children: [
                  GestureDetector(
                    onTap: () => widget.onUserTap(widget.user?.userId?? ''),
                    child: Row(
                      children: [
                        CircleAvatar(          
                          radius: 16,
                          backgroundImage: widget.user?.profileImageUrl!= null
                            ? NetworkImage(widget.user!.profileImageUrl!)
                              : null,
                          child: widget.user?.profileImageUrl == null
                            ? Text(
                                  widget.user?.username[0].toUpperCase()?? 'U',
                                  style: const TextStyle(fontSize: 14),
                                )
                              : null,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '@${widget.user?.username?? 'user'}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Hide follow button on own video
                  if (!widget.isOwnVideo)...[
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: widget.onFollow,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          widget.isFollowing? 'Following' : 'Follow',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              if (widget.short.caption.isNotEmpty)...[
                const SizedBox(height: 8),
                Text(
                  widget.short.caption,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    shadows: [Shadow(blurRadius: 4, color: Colors.black)],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),

        // Right Actions
        Positioned(
          bottom: 80,
          right: 16,
          child: Column(
            children: [
              _ActionButton(
                icon: widget.isLiked? Icons.favorite : Icons.favorite_border,
                color: widget.isLiked? Colors.red : Colors.white,
                count: widget.short.likesCount,
                onTap: widget.onLike,
              ),
              const SizedBox(height: 20),
              _ActionButton(
                icon: Icons.comment,
                color: Colors.white,
                count: widget.short.commentsCount,
                onTap: () {},
              ),
              const SizedBox(height: 20),
              _ActionButton(
                icon: Icons.visibility,
                color: Colors.white,
                count: widget.short.viewsCount,
                onTap: null,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final int count;
  final VoidCallback? onTap;

  const _ActionButton({
    required this.icon,
    required this.color,
    required this.count,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon, color: color, size: 32),
          onPressed: onTap,
        ),
        Text(
          _formatCount(count),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  String _formatCount(int count) {
    if (count < 1000) return count.toString();
    if (count < 1000000) return '${(count / 1000).toStringAsFixed(1)}K';
    return '${(count / 1000000).toStringAsFixed(1)}M';
  }
}