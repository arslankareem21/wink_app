import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';
import 'package:wink_app/models/media_type.dart';
import 'package:wink_app/models/story_model.dart';
import 'package:wink_app/presentation/provider/user_provider.dart';
import 'package:wink_app/presentation/widgets/textformfield.dart';

class ViewStoryScreen extends ConsumerStatefulWidget {
  final StoryModel story;
  const ViewStoryScreen({super.key, required this.story});

  @override
  ConsumerState<ViewStoryScreen> createState() => _ViewStoryScreenState();
}

class _ViewStoryScreenState extends ConsumerState<ViewStoryScreen> {
  VideoPlayerController? _videoController;
  bool _isVideo = false;
@override
void initState() {
  super.initState();

  // 1. Check karein ke URL video ka hai ya model se property aa rahi hai
  _isVideo = widget.story.mediaUrl.toLowerCase().contains('.mp4') || 
             widget.story.mediaUrl.toLowerCase().contains('.mov');

  // 2. Agar video hai toh controller setup karein
  if (_isVideo) {
    _videoController = VideoPlayerController.networkUrl(Uri.parse(widget.story.mediaUrl))
      ..initialize().then((_) {
        setState(() {}); // Initialize hone ke baad UI ko reload karein taake loader hatey
        _videoController!.play();
      }).catchError((error) {
        print("Video play error: $error");
      });
  }
}
  // @override
  // void initState() {
  //   super.initState();
  //   _isVideo = widget.story.mediaType == MediaType.video || widget.story.mediaUrl.contains('.mp4');
  //   if (_isVideo) {
  //     _initializeVideo();
  //   }
  // }

  // void _initializeVideo() {
  //   _videoController = VideoPlayerController.networkUrl(Uri.parse(widget.story.mediaUrl))
  //     ..initialize().then((_) {
  //       _videoController?.play();
  //       _videoController?.setLooping(true);
  //       setState(() {});
  //     }).catchError((error) {
  //       debugPrint("Video error: $error");
  //     });
  // }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userProvider(widget.story.userId));

    return userAsync.when(
      loading: () => const Scaffold(backgroundColor: Colors.black, body: Center(child: CircularProgressIndicator(color: Colors.white))),
      error: (error, stack) => Scaffold(backgroundColor: Colors.black, body: Center(child: Text('Error: $error', style: const TextStyle(color: Colors.white)))),
      data: (user) {
        if (user == null) return const Scaffold(backgroundColor: Colors.black, body: Center(child: Text('User not found', style: TextStyle(color: Colors.white))));

        return Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              Center(
                child: _isVideo
                    ? (_videoController != null && _videoController!.value.isInitialized
                        ? AspectRatio(aspectRatio: _videoController!.value.aspectRatio, 
                        child: VideoPlayer(_videoController!))
                        : const CircularProgressIndicator(color: Colors.white))
                    : Image.network(
                        widget.story.mediaUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        errorBuilder: (context, error, stackTrace) => 
                        const Icon(Icons.broken_image, color: Colors.white, size: 100),
                      ),
              ),
              Positioned(
                top: 50.h,
                left: 15.w,
                right: 15.w,
                child: Row(
                  children: [
                    CircleAvatar(radius: 20.r, backgroundColor: Colors.grey[700], child: const Icon(Icons.person, color: Colors.white24)),
                    const SizedBox(width: 10),
                    Text(user.name ?? 'Profile', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                    const Spacer(),
                    IconButton(icon: const Icon(Icons.close, color: Colors.white, size: 28), onPressed: () => Navigator.pop(context)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

