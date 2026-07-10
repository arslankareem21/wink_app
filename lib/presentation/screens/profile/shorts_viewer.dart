import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wink_app/models/auth/user_model.dart';
import 'package:wink_app/models/short_model.dart';

import 'package:video_player/video_player.dart';
import 'package:wink_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wink_app/presentation/components/shorts/shorts_card.dart';
import 'package:wink_app/viewmodels/reels/reels_viewmodel.dart';


final userProvider = FutureProvider.family<UserModel, String>((
  ref,
  userId,
) async {
  final doc = await FirebaseFirestore.instance
     .collection('users')
     .doc(userId)
     .get();
  return UserModel.fromDoc(doc);
});


class ShortsViewer extends ConsumerStatefulWidget {
  final List<ShortModel> shorts;
  final int initialIndex;
  final String currentUserId;


  const ShortsViewer({
    super.key,
    required this.shorts,
    required this.initialIndex,
    required this.currentUserId,
  });


  @override
  ConsumerState<ShortsViewer> createState() => _ShortsViewerState();
}


class _ShortsViewerState extends ConsumerState<ShortsViewer> {
  late PageController _pageController;
  int _currentIndex = 0;
  final Map<int, VideoPlayerController> _controllers = {};


  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
    _initializeController(widget.initialIndex);
  }


  Future<void> _initializeController(int index) async {
    if (_controllers.containsKey(index)) return;


    final short = widget.shorts[index];
    final controller = VideoPlayerController.networkUrl(Uri.parse(short.videoUrl));
    _controllers[index] = controller;


    await controller.initialize();
    if (index == _currentIndex && mounted) {
      controller.play();
      controller.setLooping(true);
      setState(() {});
    }
  }


  void _onPageChanged(int index) {
    _controllers[_currentIndex]?.pause();
    setState(() => _currentIndex = index);
    _initializeController(index);
    if (_controllers[index]?.value.isInitialized == true) {
      _controllers[index]?.play();
    }
  }


  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    _pageController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final vm = ref.read(shortsViewModelProvider.notifier);
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: PageView.builder(
          controller: _pageController,
          scrollDirection: Axis.vertical,
          onPageChanged: _onPageChanged,
          itemCount: widget.shorts.length,
          itemBuilder: (context, index) {
            final short = widget.shorts[index];
            final controller = _controllers[index];
            final userAsync = ref.watch(userProvider(short.userId));
        
        
            return userAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => const Center(child: Text('Error loading user')),
              data: (user) => ShortsCard(
                short: short,
                username: user.username,
                profileUrl: user.profileImageUrl.toString(),
                isLiked: true, // wire your providers
                isFollowing: false,
                isFollowingLoading: false,
                isCurrentUser: short.userId == widget.currentUserId,
                isLoading: controller == null ||!controller.value.isInitialized,
                hasError: controller?.value.hasError?? false,
                likesCount: short.likesCount,
                controller: controller,
                onVideoTap: () {
                  if (controller?.value.isPlaying == true) {
                    controller?.pause();
                  } else {
                    controller?.play();
                  }
                },
                onLike: () => vm.toggleLike(short.shortId),// wire your logic
                onFollow: () {},
                onComment: () {},
                onShare: () {},
                onUserTap: () => Navigator.pop(context),
              ),
            );
          },
        ),
      ),
    );
  }
}