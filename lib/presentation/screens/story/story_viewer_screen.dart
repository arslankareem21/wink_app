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
final List<StoryModel> stories;
  const ViewStoryScreen({super.key, 
  required this.stories});

  @override
  ConsumerState<ViewStoryScreen> createState() => _ViewStoryScreenState();
}

class _ViewStoryScreenState extends ConsumerState<ViewStoryScreen> {
 int _currentIndex=0;
  VideoPlayerController? _videoController;
  bool _isVideo = false;
  @override
  void initState() {
    super.initState();
    _loadStory();
  }

  // Current index wali story ko check karne aur video initialize karne ka method
  void _loadStory() {
    _videoController?.dispose();
    _videoController = null;

    final currentStory = widget.stories[_currentIndex];

    _isVideo = currentStory.mediaUrl.toLowerCase().contains('.mp4') || 
               currentStory.mediaUrl.toLowerCase().contains('.mov');

    if (_isVideo) {
      _videoController = VideoPlayerController.networkUrl(Uri.parse(currentStory.mediaUrl))
        ..initialize().then((_) {
          setState(() {}); 
          _videoController!.play();
        }).catchError((error) {
          print("Video play error: $error");
        });
    } else {
      setState(() {});
    }
  }

  // Tapping operation handles next story index increment
  void _handleTap() {
    if (_currentIndex < widget.stories.length - 1) {
      setState(() {
        _currentIndex++;
        _loadStory(); // Agli story setup karo
      });
    } else {
      Navigator.pop(context); // Saari stories khatam ho gayin toh wapas jao
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentStory = widget.stories[_currentIndex];
    final userAsync = ref.watch(userProvider(currentStory.userId));

    return userAsync.when(
      loading: () => const Scaffold(backgroundColor: Colors.black, body: Center(child: CircularProgressIndicator(color: Colors.white))),
      error: (error, stack) => Scaffold(backgroundColor: Colors.black, body: Center(child: Text('Error: $error', style: const TextStyle(color: Colors.white)))),
      data: (user) {
        if (user == null) return const Scaffold(backgroundColor: Colors.black, body: Center(child: Text('User not found', style: TextStyle(color: Colors.white))));

        return Scaffold(
          backgroundColor: Colors.black,
          body: GestureDetector(
            onTap: _handleTap,
            child: Stack(
              children: [
                Center(
                  child: _isVideo
                      ? (_videoController != null && _videoController!.value.isInitialized
                          ? AspectRatio(aspectRatio: _videoController!.value.aspectRatio, 
                          child: VideoPlayer(_videoController!))
                          : const CircularProgressIndicator(color: Colors.white))
                      : Image.network(
                          currentStory.mediaUrl,
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
                  child:Column(children: [
                    Row(
                        children: List.generate(widget.stories.length, (index) {
                          return Expanded(
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              height: 3,
                              color: index <= _currentIndex ? Colors.white : Colors.grey[700],
                            ),
                          );
                        }),
                      ),
                    const SizedBox(height: 10),
                      Row(
                        children: [
                          CircleAvatar(radius: 20.r, backgroundColor: Colors.grey[700], child: const Icon(Icons.person, color: Colors.white24)),
                          const SizedBox(width: 10),
                          Text(user.name ?? 'Profile', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                          const Spacer(),
                          IconButton(icon: const Icon(Icons.close, color: Colors.white, size: 28), onPressed: () => Navigator.pop(context)),
                        ],
                      ),
                  ],)
                  //  Row(
                  //   children: [
                  //     CircleAvatar(radius: 20.r, backgroundColor: Colors.grey[700], child: const Icon(Icons.person, color: Colors.white24)),
                  //     const SizedBox(width: 10),
                  //     Text(user.name ?? 'Profile', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                  //     const Spacer(),
                  //     IconButton(icon: const Icon(Icons.close, color: Colors.white, size: 28), onPressed: () => Navigator.pop(context)),
                  //   ],
                  // ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

