// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:wink_app/presentation/components/shorts/shorts_card.dart';
// import 'package:wink_app/presentation/provider/get_profile_providers.dart' hide isFollowingProvider;
// import 'package:wink_app/viewmodels/reels/reels_viewmodel.dart';
// import '../profile/other_user_profile_screen.dart';

// class ShortsPage extends ConsumerStatefulWidget {
//   const ShortsPage({super.key});

//   @override
//   ConsumerState<ShortsPage> createState() => _ShortsPageState();
// }

// class _ShortsPageState extends ConsumerState<ShortsPage>
//     with WidgetsBindingObserver {
//   late final PageController _pageController;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//     final index = ref.read(shortsViewModelProvider).currentIndex;
//     _pageController = PageController(initialPage: index, keepPage: true);
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     _pageController.dispose();
//     super.dispose();
//   }

//   // 6. Pause video when leaving Shorts via BottomNavigation
//   @override
//   void deactivate() {
//     ref.read(shortsViewModelProvider.notifier).pauseAll();
//     super.deactivate();
//   }

//   @override
//   void activate() {
//     super.activate();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       ref.read(shortsViewModelProvider.notifier).resumeCurrent();
//     });
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     final vm = ref.read(shortsViewModelProvider.notifier);
//     switch (state) {
//       case AppLifecycleState.resumed:
//         vm.resumeCurrent();
//         break;
//       case AppLifecycleState.paused:
//       case AppLifecycleState.inactive:
//       case AppLifecycleState.hidden:
//       case AppLifecycleState.detached:
//         vm.pauseAll();
//         break;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final state = ref.watch(shortsViewModelProvider);
//     final vm = ref.read(shortsViewModelProvider.notifier);
//     final currentUserId = FirebaseAuth.instance.currentUser?.uid?? "";

//     if (state.loading) {
//       return const Scaffold(
//         backgroundColor: Colors.black,
//         body: Center(child: CircularProgressIndicator(color: Colors.white)),
//       );
//     }

//     if (state.error!= null) {
//       return Scaffold(
//         backgroundColor: Colors.black,
//         body: Center(
//           child: Text(state.error!, style: const TextStyle(color: Colors.white)),
//         ),
//       );
//     }

//     if (state.shorts.isEmpty) {
//       return const Scaffold(
//         backgroundColor: Colors.black,
//         body: Center(
//           child: Text("No Shorts Found", style: TextStyle(color: Colors.white)),
//         ),
//       );
//     }

//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: SafeArea(
//         child: PageView.builder(
//           controller: _pageController,
//           scrollDirection: Axis.vertical,
//           // 12. Smooth scrolling like YouTube Shorts
//           allowImplicitScrolling: true,
//           pageSnapping: true,
//           physics: const PageScrollPhysics(),
//           itemCount: state.shorts.length,
//           onPageChanged: vm.onPageChanged,
//           itemBuilder: (context, index) {
//             final short = state.shorts[index];
//             final controller = vm.controller(index);
//             final isLoading = controller == null
//                ? true
//                 : !controller.value.isInitialized; // Only show loading if not initialized
//             final hasError = vm.hasError(index);
//             final user = ref.watch(userInfoProvider(short.userId));
//             final liked = ref.watch(isLikedProvider(short.shortId));
//             final following = ref.watch(isFollowingProvider(short.userId));

//             final username = user.value?['username']?? "user";
//             final profileUrl = user.value?['profileUrl']?? "";
//             // Use optimistic like state if available, otherwise use Firestore state
//             final isLiked = vm.isLikedOptimistic(short.shortId) || (liked.value?? false);
//             final isFollowing = following.value?? false;

//             return ShortsCard(
//               key: ValueKey(short.shortId),
//               short: short,
//               username: username,
//               profileUrl: profileUrl,
//               isLiked: isLiked,
//               isFollowing: isFollowing,
//               isCurrentUser: short.userId == currentUserId,
//               isLoading: isLoading,
//               hasError: hasError,
//               controller: controller,
//               onVideoTap: () => vm.toggleVideo(index),
//               onLike: () => vm.like(index),
//               onFollow: () => vm.follow(short.userId),
//               onComment: () {},
//               onShare: () {},
//               onUserTap: () {
//                 // 7. Pause while profile screen opens
//                 vm.pauseAll();
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => OtherProfileScreen(
//                       myId: currentUserId,
//                       profileId: short.userId,
//                       myData: {
//                         "username": username,
//                         "displayName": username,
//                         "profileImageUrl": profileUrl,
//                       },
//                     ),
//                   ),
//                 ).then((_) {
//                   vm.resumeCurrent();
//                 });
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

//ARSALAN WORK

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';
import 'package:wink_app/models/reels/reels_models.dart';
import 'package:wink_app/presentation/provider/user_provider.dart';
import 'package:wink_app/presentation/screens/profile/other_user_profile_screen.dart';
import 'package:wink_app/presentation/widgets/circle_avatar.dart';
import 'package:wink_app/viewmodels/image_picker_vm.dart';
import 'package:wink_app/viewmodels/reels/reels_viewmodel.dart';

class ReelPage extends ConsumerStatefulWidget {
  const ReelPage({super.key});

  @override
  ConsumerState<ReelPage> createState() => _ReelPageState();
}

class _ReelPageState extends ConsumerState<ReelPage> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    final savedIndex = ref.read(reelsViewModelProvider.notifier).focusedIndex;
    _pageController = PageController(initialPage: savedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reels = ref.watch(reelsViewModelProvider);
    final viewModel = ref.read(reelsViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.black,
      body: reels.isEmpty
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : PageView.builder(
              scrollDirection: Axis.vertical,
              controller: _pageController,
              itemCount: reels.length,
              onPageChanged: (index) {
                viewModel.onPageChanged(index);
              },
              itemBuilder: (context, index) {
                // Key lagana zaroori hai taake Flutter widget state ko sahi se map kare
                return ReelPlayerItem(
                  key: ValueKey('${reels[index].id}_$index'),
                  reel: reels[index],
                  index: index,
                );
              },
            ),
    );
  }
}

class ReelPlayerItem extends ConsumerStatefulWidget {
  final ReelModel reel;
  final int index;

  const ReelPlayerItem({super.key, required this.reel, required this.index});

  @override
  ConsumerState<ReelPlayerItem> createState() => _ReelPlayerItemState();
}

class _ReelPlayerItemState extends ConsumerState<ReelPlayerItem>
    with SingleTickerProviderStateMixin {
  VideoPlayerController? _videoController;
  bool _initialized = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    _initializeController();
  }

  Future<void> _initializeController() async {
    final viewModel = ref.read(reelsViewModelProvider.notifier);
    final controller = await viewModel.getController(widget.index);

    if (!mounted) return;

    _videoController = controller;

    if (mounted) {
      setState(() {
        _initialized = _videoController?.value.isInitialized ?? false;
      });

      if (widget.index == viewModel.focusedIndex) {
        _videoController?.play();
        _animationController.repeat();
      } else {
        _videoController?.pause();
        _animationController.stop();
      }
    }
  }

  @override
  void dispose() {
    _videoController?.pause();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.read(reelsViewModelProvider.notifier);

    // 🎯 1. Listen to focused index changes properly
    ref.listen<int>(
      reelsViewModelProvider.notifier.select((vm) => vm.focusedIndex),
      (previous, next) {
        if (_initialized && _videoController != null) {
          if (widget.index == next) {
            // Agar yeh item ab focus mein aaya hai, toh play karein
            if (!_videoController!.value.isPlaying) {
              _videoController!.play();
              _animationController.repeat();
              setState(() {});
            }
          } else if (widget.index == previous) {
            // Agar yeh item focus se nikal gaya hai, toh pause karein
            if (_videoController!.value.isPlaying) {
              _videoController!.pause();
              _animationController.stop();
              setState(() {});
            }
          }
        }
      },
    );

    return Stack(
      fit: StackFit.expand,
      children: [
        GestureDetector(
          onTap: () async {
            if (_videoController != null && _initialized) {
              try {
                // 🎯 2. Manual toggle ab perfectly kaam karega bina build interference ke
                if (_videoController!.value.isPlaying) {
                  await _videoController!.pause();
                  _animationController.stop();
                } else {
                  await _videoController!.play();
                  _animationController.repeat();
                }
                if (mounted) setState(() {});
              } catch (e) {
                print("Error toggling video: $e");
              }
            }
          },
          child: Container(
            color: Colors.black,
            child: Center(
              child: _initialized && _videoController != null
                  ? AspectRatio(
                      aspectRatio: _videoController!.value.aspectRatio == 0.0
                          ? 9 / 16
                          : _videoController!.value.aspectRatio,
                      child: VideoPlayer(_videoController!),
                    )
                  : const CircularProgressIndicator(color: Colors.white),
            ),
          ),
        ),

        // Play/Pause Center Indicator Icon
        if (_videoController != null)
          ValueListenableBuilder(
            valueListenable: _videoController!,
            builder: (context, VideoPlayerValue value, child) {
              if (value.isInitialized && !value.isPlaying) {
                return Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      size: 60,
                      color: Colors.white70,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),

        Positioned.fill(
          child: IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                  begin: Alignment.center,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
        ),
        _buildOverlay(viewModel),
      ],
    );
  }

  // ... Baqi ke methods (_buildOverlay, _buildActionItem, etc.) same rahein ge
  //}

  Widget _buildOverlay(ReelsViewModel viewModel) {
    // 🎯 1. Fetch user using userID (falls back to username if userID is empty)
    final userIdToFetch = widget.reel.userID.isNotEmpty
        ? widget.reel.userID
        : widget.reel.username;

    final userAsync = ref.watch(userProvider(userIdToFetch));
    final pickedImageFile = ref.watch(imagePickerProvider);

    // 🎯 2. Extract Display Name properly with fallback hierarchy
    final displayName = userAsync.when(
      data: (user) {
        if (user?.name != null && user!.name.trim().isNotEmpty) {
          return user.name;
        }
        if (user?.displayName != null && user!.displayName.trim().isNotEmpty) {
          return user.displayName;
        }
        if (user?.username != null && user!.username.trim().isNotEmpty) {
          return user.username;
        }
        return widget.reel.username.isNotEmpty ? widget.reel.username : 'User';
      },
      loading: () =>
          widget.reel.username.isNotEmpty ? widget.reel.username : 'Loading...',
      error: (_, __) =>
          widget.reel.username.isNotEmpty ? widget.reel.username : 'User',
    );

    // 🎯 3. Extract Profile Image URL
    final profileImg =
        userAsync.value?.profileImageUrl ??
        (widget.reel.profileUrl.isNotEmpty ? widget.reel.profileUrl : null);

    return Positioned(
      bottom: 20,
      left: 16,
      right: 16,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    _videoController?.pause();
                    _animationController.stop();
                    userAsync.whenData((fetchedUser) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OtherProfileScreen(
                            myId: FirebaseAuth.instance.currentUser?.uid ?? '',
                            profileId: widget.reel.userID.isNotEmpty
                                ? widget.reel.userID
                                : (fetchedUser?.uid ?? ''),
                            myData: {
                              'username':
                                  fetchedUser?.username ?? widget.reel.username,
                              'displayName': fetchedUser?.name ?? displayName,
                              'profileImageUrl':
                                  fetchedUser?.profileImageUrl ??
                                  widget.reel.profileUrl,
                            },
                          ),
                        ),
                      );
                    });
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppProfileAvatar(
                        radius: 20.r,
                        imageFile: pickedImageFile,
                        profileImageUrl:
                            profileImg, // 👈 Avatar image link pass kar diya
                        onChangePhoto: () {},
                      ),
                      const SizedBox(width: 8),

                      // 🎯 4. Display Name with overflow handling
                      Flexible(
                        child: Text(
                          displayName,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),

                  
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Follow',
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  widget.reel.caption,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.music_note, color: Colors.white, size: 14),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        widget.reel.musicName,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildActionItem(
                icon: widget.reel.isLiked
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: widget.reel.isLiked ? Colors.red : Colors.white,
                label: _formatNumber(widget.reel.likes),
                onTap: () => viewModel.toggleLike(widget.index),
              ),
              const SizedBox(height: 20),
              _buildActionItem(
                icon: Icons.comment_rounded,
                label: _formatNumber(widget.reel.comments),
                onTap: () {},
              ),
              const SizedBox(height: 20),
              _buildActionItem(
                icon: Icons.share_rounded,
                label: _formatNumber(widget.reel.shares),
                onTap: () {},
              ),
              const SizedBox(height: 20),
              const Icon(Icons.more_vert, color: Colors.white),
              const SizedBox(height: 20),
              RotationTransition(
                turns: _animationController,
                child: Container(
                  width: 50,
                  height: 50,
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  child: const CircleAvatar(
                    backgroundImage: NetworkImage(
                      'https://ui-avatars.com/api/?name=Music',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //   Widget _buildOverlay(ReelsViewModel viewModel) {
  //     final userAsync = ref.watch(userProvider(widget.reel.username));
  //     final pickedImageFile = ref.watch(imagePickerProvider);
  //                       final displayName = userAsync.value?.name ??
  //                     userAsync.value?.displayName ??
  //                     widget.reel.username;
  //     return Positioned(
  //       bottom: 20,
  //       left: 16,
  //       right: 16,
  //       child: Row(
  //         crossAxisAlignment: CrossAxisAlignment.end,
  //         children: [
  //           Expanded(
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 GestureDetector(
  //                   onTap: () {
  //                     _videoController?.pause();
  //                     _animationController.stop();
  //                     userAsync.whenData((fetchedUser) {
  //                       Navigator.push(
  //                         context,
  //                         MaterialPageRoute(
  //                           builder: (context) => OtherProfileScreen(
  //                             myId: FirebaseAuth.instance.currentUser?.uid ?? '',
  //                             profileId: widget.reel.userID.isNotEmpty
  //                                 ? widget.reel.userID
  //                                 : (fetchedUser?.uid ?? ''),
  //                             myData: {
  //                               'username': fetchedUser?.username ?? widget.reel.username,
  //                               'displayName': fetchedUser?.name ?? 'No Name',
  //                               'profileImageUrl': fetchedUser?.profileImageUrl ?? widget.reel.profileUrl,
  //                             },
  //                           ),
  //                         ),
  //                       );
  //                     });
  //                   },
  //                   child: Row(
  //                     mainAxisSize: MainAxisSize.min,
  //                     children: [
  //                        AppProfileAvatar(
  //           radius: 20.r,
  //           imageFile: pickedImageFile,
  //         //profileImageUrl: profileImageUrl,
  //           onChangePhoto: () {},
  //           //textSize: 13.sp,
  //         ),

  //                       const SizedBox(width: 8),

  // Text(
  //   displayName,
  //   style: const TextStyle(
  //     color: Colors.white,
  //     fontWeight: FontWeight.bold,
  //     fontSize: 16,
  //   ),
  // ),
  //                       // Text(
  //                       //   widget.reel.username,
  //                       //   style: const TextStyle(
  //                       //     color: Colors.white,
  //                       //     fontWeight: FontWeight.bold,
  //                       //     fontSize: 16,
  //                       //   ),
  //                       // ),
  //                       const SizedBox(width: 6),
  //                       const Icon(
  //                         Icons.verified,
  //                         color: Colors.blueAccent,
  //                         size: 16,
  //                       ),
  //                       const SizedBox(width: 10),
  //                       Container(
  //                         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
  //                         decoration: BoxDecoration(
  //                           border: Border.all(color: Colors.white),
  //                           borderRadius: BorderRadius.circular(4),
  //                         ),
  //                         child: const Text(
  //                           'Follow',
  //                           style: TextStyle(color: Colors.white, fontSize: 10),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 const SizedBox(height: 12),
  //                 Text(
  //                   widget.reel.caption,
  //                   maxLines: 2,
  //                   overflow: TextOverflow.ellipsis,
  //                   style: const TextStyle(color: Colors.white, fontSize: 14),
  //                 ),
  //                 const SizedBox(height: 12),
  //                 Row(
  //                   children: [
  //                     const Icon(Icons.music_note, color: Colors.white, size: 14),
  //                     const SizedBox(width: 6),
  //                     Expanded(
  //                       child: Text(
  //                         widget.reel.musicName,
  //                         overflow: TextOverflow.ellipsis,
  //                         style: const TextStyle(color: Colors.white, fontSize: 13),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //           const SizedBox(width: 10),
  //           Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               _buildActionItem(
  //                 icon: widget.reel.isLiked ? Icons.favorite : Icons.favorite_border,
  //                 color: widget.reel.isLiked ? Colors.red : Colors.white,
  //                 label: _formatNumber(widget.reel.likes),
  //                 onTap: () => viewModel.toggleLike(widget.index),
  //               ),
  //               const SizedBox(height: 20),
  //               _buildActionItem(
  //                 icon: Icons.comment_rounded,
  //                 label: _formatNumber(widget.reel.comments),
  //                 onTap: () {},
  //               ),
  //               const SizedBox(height: 20),
  //               _buildActionItem(
  //                 icon: Icons.share_rounded,
  //                 label: _formatNumber(widget.reel.shares),
  //                 onTap: () {},
  //               ),
  //               const SizedBox(height: 20),
  //               const Icon(Icons.more_vert, color: Colors.white),
  //               const SizedBox(height: 20),
  //               RotationTransition(
  //                 turns: _animationController,
  //                 child: Container(
  //                   width: 50,
  //                   height: 50,
  //                   padding: const EdgeInsets.all(8),
  //                   decoration: const BoxDecoration(
  //                     color: Colors.black,
  //                     shape: BoxShape.circle,
  //                   ),
  //                   child: const CircleAvatar(
  //                     backgroundImage: NetworkImage(
  //                       'https://ui-avatars.com/api/?name=Music',
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ],
  //       ),
  //     );
  //   }

  Widget _buildActionItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color color = Colors.white,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000) return '${(number / 1000).toStringAsFixed(1)}k';
    return number.toString();
  }
}













//without indicator

// import 'package:cloudinary_url_gen/transformation/resize/common.dart'
//     hide AspectRatio;

// import 'package:firebase_auth/firebase_auth.dart';

// import 'package:flutter/material.dart';

// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'package:flutter_screenutil/flutter_screenutil.dart';

// import 'package:video_player/video_player.dart';

// import 'package:wink_app/models/reels/reels_models.dart';

// import 'package:wink_app/presentation/provider/user_provider.dart';

// import 'package:wink_app/presentation/screens/profile/other_user_profile_screen.dart';

// import 'package:wink_app/viewmodels/reels/reels_viewmodel.dart';

// class ReelPage extends ConsumerStatefulWidget {
//   const ReelPage({super.key});

//   @override
//   ConsumerState<ReelPage> createState() => _ReelPageState();
// }

// class _ReelPageState extends ConsumerState<ReelPage> {
//   late PageController _pageController;

//   @override
//   void initState() {
//     super.initState();
//     final savedIndex = ref.read(reelsViewModelProvider.notifier).focusedIndex;

//     _pageController = PageController(initialPage: savedIndex);
//   }

//   @override
//   void dispose() {
//     _pageController.dispose();

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Watch state reactively via Riverpod

//     final reels = ref.watch(reelsViewModelProvider);

//     final viewModel = ref.read(reelsViewModelProvider.notifier);

//     return Scaffold(
//       backgroundColor: Colors.black,

//       body: reels.isEmpty
//           ? const Center(child: CircularProgressIndicator(color: Colors.white))
//           : PageView.builder(
//               scrollDirection: Axis.vertical,

//               controller: _pageController,

//               itemCount: reels.length,

//               onPageChanged: (index) {
//                 viewModel.onPageChanged(index);
//               },

//               itemBuilder: (context, index) {
//                 return ReelPlayerItem(reel: reels[index], index: index);
//               },
//             ),
//     );
//   }
// }

// class ReelPlayerItem extends ConsumerStatefulWidget {
//   final ReelModel reel;

//   final int index;

//   const ReelPlayerItem({super.key, required this.reel, required this.index});

//   @override
//   ConsumerState<ReelPlayerItem> createState() => _ReelPlayerItemState();
// }

// class _ReelPlayerItemState extends ConsumerState<ReelPlayerItem>
//     with SingleTickerProviderStateMixin {
//   VideoPlayerController? _videoController;

//   bool _initialized = false;

//   late AnimationController _animationController;

//   void _videoListener() {
//     if (mounted) {
//       setState(() {});
//     }
//   }

//   @override
//   void initState() {
//     super.initState();

//     _animationController = AnimationController(
//       vsync: this,

//       duration: const Duration(seconds: 5),
//     )..repeat();

//     _initializeController();
//   }

//   Future<void> _initializeController() async {
//     final viewModel = ref.read(reelsViewModelProvider.notifier);

//     _videoController = await viewModel.getController(widget.index);

//     if (!mounted) return;

//     _videoController?.addListener(_videoListener);

//     setState(() {
//       _initialized = true;
//     });


//     if (widget.index == viewModel.focusedIndex) {
//       _videoController?.play();
//     } else {
//       _videoController?.pause();
//     }
//   }

//   @override
//   void dispose() {

//     _videoController?.removeListener(_videoListener);


//     _videoController?.pause();


//     _animationController.dispose();

//     super.dispose();
//   }

//   // @override

//   // void dispose() {

//   //   _videoController?.removeListener(_videoListener);

//   //   _animationController.dispose();

//   //   super.dispose();

//   // }

//   @override
//   Widget build(BuildContext context) {
//     final viewModel = ref.read(reelsViewModelProvider.notifier);

//     ref.listen<
//       int
//     >(reelsViewModelProvider.notifier.select((vm) => vm.focusedIndex), (
//       previous,

//       next,
//     ) {
//       if (_videoController == null || !_initialized) return;

//       if (next == widget.index) {
//         _videoController!.play();

//         _animationController.repeat();
//       } else {

//         _videoController!.pause();

//         _animationController.stop();
//       }
//     });

//     return Stack(
//       fit: StackFit.expand,

//       children: [
//         GestureDetector(
//           onTap: () async {
//             if (_videoController != null && _initialized) {
//               try {
//                 if (_videoController!.value.isPlaying) {
//                   await _videoController!.pause();

//                   _animationController.stop();
//                 } else {
//                   await _videoController!.play();

//                   _animationController.repeat();
//                 }

//                 if (mounted) setState(() {});
//               } catch (e) {
//                 print("Error toggling video: $e");
//               }
//             }
//           },

//           child: Container(
//             color: Colors.black,

//             child: Center(
//               child: _initialized && _videoController != null
//                   ? AspectRatio(
//                       aspectRatio: _videoController!.value.aspectRatio == 0.0
//                           ? 9 / 16
//                           : _videoController!.value.aspectRatio,

//                       child: VideoPlayer(_videoController!),
//                     )
//                   : const CircularProgressIndicator(color: Colors.white),
//             ),
//           ),
//         ),

//         if (_initialized &&
//             _videoController != null &&
//             !_videoController!.value.isPlaying)
//           Center(
//             child: Container(
//               padding: const EdgeInsets.all(16),

//               decoration: BoxDecoration(
//                 color: Colors.black.withOpacity(0.3),

//                 shape: BoxShape.circle,
//               ),

//               child: IconButton(
//                 onPressed: () async {
//                   try {
//                     await _videoController!.play();

//                     _animationController.repeat();

//                     if (mounted) setState(() {});
//                   } catch (e) {
//                     print("Error playing video: $e");
//                   }
//                 },

//                 icon: const Icon(
//                   Icons.play_arrow,

//                   size: 60,

//                   color: Colors.white70,
//                 ),
//               ),
//             ),
//           ),

//         Positioned.fill(
//           child: IgnorePointer(
//             child: Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [Colors.transparent, Colors.black.withOpacity(0.8)],

//                   begin: Alignment.center,

//                   end: Alignment.bottomCenter,
//                 ),
//               ),
//             ),
//           ),
//         ),

//         _buildOverlay(viewModel),
//       ],
//     );
//   }

//   Widget _buildOverlay(ReelsViewModel viewModel) {
//     // 1. Background mein user profile data fetch karne ke liye sirf listen ya watch karein
//     final userAsync = ref.watch(userProvider(widget.reel.username));

//     return Positioned(
//       bottom: 20,
//       left: 16,
//       right: 16,
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.end,
//         children: [
//           Expanded(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 GestureDetector(
//                   onTap: () {
//                     _videoController?.pause();
//                     _animationController.stop();
//                     userAsync.whenData((fetchedUser) {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => OtherProfileScreen(
//                             myId: FirebaseAuth.instance.currentUser?.uid ?? '',
//                             profileId: widget.reel.userID.isNotEmpty
//                                 ? widget.reel.userID
//                                 : (fetchedUser?.uid ?? ''),
//                             myData: {
//                               'username':
//                                   fetchedUser?.username ?? widget.reel.username,
//                               'displayName': fetchedUser?.name ?? 'No Name',
//                               'profileImageUrl':
//                                   fetchedUser?.profileImageUrl ??
//                                   widget.reel.profileUrl,
//                             },
//                           ),
//                         ),
//                       );
//                     });
//                   },
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       CircleAvatar(
//                         radius: 16,
//                         backgroundImage: NetworkImage(widget.reel.profileUrl),
//                         backgroundColor: Colors.grey[800],
//                       ),
//                       const SizedBox(width: 10),
//                       Text(
//                         widget
//                             .reel
//                             .username, 
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//                       const SizedBox(width: 6),
//                       const Icon(
//                         Icons.verified,
//                         color: Colors.blueAccent,
//                         size: 16,
//                       ),
//                       const SizedBox(width: 10),
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 8,
//                           vertical: 2,
//                         ),
//                         decoration: BoxDecoration(
//                           border: Border.all(color: Colors.white),
//                           borderRadius: BorderRadius.circular(4),
//                         ),
//                         child: const Text(
//                           'Follow',
//                           style: TextStyle(color: Colors.white, fontSize: 10),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 Text(
//                   widget.reel.caption,
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                   style: const TextStyle(color: Colors.white, fontSize: 14),
//                 ),
//                 const SizedBox(height: 12),
//                 Row(
//                   children: [
//                     const Icon(Icons.music_note, color: Colors.white, size: 14),
//                     const SizedBox(width: 6),
//                     Expanded(
//                       child: Text(
//                         widget.reel.musicName,
//                         overflow: TextOverflow.ellipsis,
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 13,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(width: 10),

//           Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               _buildActionItem(
//                 icon: widget.reel.isLiked
//                     ? Icons.favorite
//                     : Icons.favorite_border,
//                 color: widget.reel.isLiked ? Colors.red : Colors.white,
//                 label: _formatNumber(widget.reel.likes),
//                 onTap: () => viewModel.toggleLike(widget.index),
//               ),
//               const SizedBox(height: 20),
//               _buildActionItem(
//                 icon: Icons.comment_rounded,
//                 label: _formatNumber(widget.reel.comments),
//                 onTap: () {},
//               ),
//               const SizedBox(height: 20),
//               _buildActionItem(
//                 icon: Icons.share_rounded,
//                 label: _formatNumber(widget.reel.shares),
//                 onTap: () {},
//               ),
//               const SizedBox(height: 20),
//               const Icon(Icons.more_vert, color: Colors.white),
//               const SizedBox(height: 20),
//               RotationTransition(
//                 turns: _animationController,
//                 child: Container(
//                   width: 50,
//                   height: 50,
//                   padding: const EdgeInsets.all(8),
//                   decoration: const BoxDecoration(
//                     color: Colors.black,
//                     shape: BoxShape.circle,
//                   ),
//                   child: const CircleAvatar(
//                     backgroundImage: NetworkImage(
//                       'https://ui-avatars.com/api/?name=Music',
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildActionItem({
//     required IconData icon,
//     required String label,
//     required VoidCallback onTap,
//     Color color = Colors.white,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Column(
//         children: [
//           Icon(icon, color: color, size: 32),
//           const SizedBox(height: 6),
//           Text(
//             label,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 13,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   String _formatNumber(int number) {
//     if (number >= 1000) return '${(number / 1000).toStringAsFixed(1)}k';
//     return number.toString();
//   }
// }





















//refresh indicator

//  }



// import 'package:cloudinary_url_gen/transformation/resize/common.dart'
//     hide AspectRatio;
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:video_player/video_player.dart';
// import 'package:wink_app/models/reels/reels_models.dart';
// import 'package:wink_app/presentation/provider/user_provider.dart';
// import 'package:wink_app/presentation/screens/profile/other_user_profile_screen.dart';
// import 'package:wink_app/viewmodels/reels/reels_viewmodel.dart';

// class ReelPage extends ConsumerStatefulWidget {
//   const ReelPage({super.key});

//   @override
//   ConsumerState<ReelPage> createState() => _ReelPageState();
// }

// class _ReelPageState extends ConsumerState<ReelPage> {
//   late PageController _pageController;


// Future<void> _handleRefresh() async {
//   try {
//     // Await lagana zaroori hai taake spinning loading bar foran gayab na ho
//     await ref.read(reelsViewModelProvider.notifier).refreshReels();
//     if (mounted) {
//       _pageController.jumpToPage(0);
//     }
//   } catch (e) {
//     print("UI Refresh error: $e");
//   }
// }


//   @override
//   void initState() {
//     super.initState();
//     // ReelsViewModel se saved index uthayein taake wapis aane par scroll reset na ho
//     //final reels = ref.watch(ReelsViewModel.);
//     final savedIndex = ref.read(reelsViewModelProvider.notifier).focusedIndex;
//     _pageController = PageController(initialPage: savedIndex);
//   }

//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Watch state reactively via Riverpod
//     final reels = ref.watch(reelsViewModelProvider);
//     final viewModel = ref.read(reelsViewModelProvider.notifier);

//     return Scaffold(
//       backgroundColor: Colors.black,
//       body:
//        RefreshIndicator(
//         color: Colors.white,
//         backgroundColor: Colors.grey[900],
//         onRefresh:_handleRefresh, // Triggers when pulled down
//         child: 
//         reels.isEmpty
//         ? const Center(
//               child: SingleChildScrollView(
//                 physics: AlwaysScrollableScrollPhysics(), // Empty state mein bhi pull chalega
//                 child: SizedBox(
//                   height: 500, // Dummy height taake center mein ghoome
//                   child: Center(child: CircularProgressIndicator(color: Colors.white)),
//                 ),
//               ),
//             )
//             // ? const Center(
//             //   child: CircularProgressIndicator(
//             //     color: Colors.white))
//             : PageView.builder(
//               physics: const AlwaysScrollableScrollPhysics(
//                 parent: BouncingScrollPhysics()
//               ),
//                 scrollDirection: Axis.vertical,
//                 controller: _pageController,
//                 itemCount: reels.length,
//                 onPageChanged: (index) {
//                   viewModel.onPageChanged(index);
//                 },
//                 itemBuilder: (context, index) {
//                   return ReelPlayerItem(reel: reels[index], index: index);
//                 },
//               ),
//   )
//     );
//   }
// }

// class ReelPlayerItem extends ConsumerStatefulWidget {
//   final ReelModel reel;
//   final int index;

//   const ReelPlayerItem({super.key, required this.reel, required this.index});

//   @override
//   ConsumerState<ReelPlayerItem> createState() => _ReelPlayerItemState();
// }

// class _ReelPlayerItemState extends ConsumerState<ReelPlayerItem>
//     with SingleTickerProviderStateMixin {
//   VideoPlayerController? _videoController;
//   bool _initialized = false;
//   late AnimationController _animationController;

// // void _videoListener() {
// //     // 🎯 CRITICAL FIX: Agar controller dispose ho chuka ho ya null ho toh listener run na karein
// //     if (!mounted || _videoController == null) return;
    
// //     try {
// //       // Sirf tabhi setState karein jab controller initialized aur active ho
// //       if (_videoController!.value.isInitialized) {
// //         setState(() {});
// //       }
// //     } catch (e) {
// //       print("⚠️ Safe guarded listener from disposed player: $e");
// //     }
// //   }

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 5),
//     )..repeat();
//     _initializeController();
//   }

//   // Future<void> _initializeController() async {
//   //   final viewModel = ref.read(reelsViewModelProvider.notifier);
//   //   _videoController = await viewModel.getController(widget.index);
//   //   if (!mounted) return;

//   //   _videoController?.addListener(_videoListener);

//   //   setState(() {
//   //     _initialized = true;
//   //   });

//   //   // Pehle index == 0 check ho raha tha, ab hum saved focusedIndex se match kar rahe hain
//   //   if (widget.index == viewModel.focusedIndex) {
//   //     _videoController?.play();
//   //   } else {
//   //     _videoController?.pause();
//   //   }
//   // }

//   Future<void> _initializeController() async {
//     final viewModel = ref.read(reelsViewModelProvider.notifier);
    
//     try {
//       final controller = await viewModel.getController(widget.index);
//       if (!mounted) return;

//       // 🎯 CRITICAL FIX: Kisi bhi purane instance ka listener pehle safety ke liye remove karein
//       _videoController?.removeListener(_videoListener);

//       _videoController = controller;
//       _videoController?.addListener(_videoListener);

//       if (mounted) {
//         setState(() {
//           _initialized = _videoController?.value.isInitialized ?? false;
//         });

//         if (widget.index == viewModel.focusedIndex) {
//           _videoController?.play();
//         } else {
//           _videoController?.pause();
//         }
//       }
//     } catch (e) {
//       print("❌ Error initializing controller in widget: $e");
//     }
//   }

//   @override
//   void dispose() {
//     // 1. Pehle video listener remove karein
//     //_videoController?.removeListener(_videoListener);

//     // 2. CRITICAL FIX: Agle page par jaane se pehle audio band karne ke liye pause karein
//     _videoController?.pause();

//     // 3. Animation controller clear karein
//     _animationController.dispose();
//     super.dispose();
//     // 🎯 CRITICAL FIX: Safe removal before nullifying
//   //   if (_videoController != null) {
//   //     _videoController!.removeListener(_videoListener);
//   //     try {
//   //       _videoController!.pause();
//   //     } catch (e) {
//   //       print("Player already stopped or disposed: $e");
//   //     }
//   //   }
//   //   _animationController.dispose();
//   //   super.dispose();
//   // }
//   }
//   // @override
//   // void dispose() {
//   //   _videoController?.removeListener(_videoListener);
//   //   _animationController.dispose();
//   //   super.dispose();
//   // }

//   @override
//   Widget build(BuildContext context) {
//     final viewModel = ref.read(reelsViewModelProvider.notifier);

//     ref.listen<
//       int
//     >(reelsViewModelProvider.notifier.select((vm) => vm.focusedIndex), (
//       previous,
//       next,
//     ) {
//       if (_videoController == null || !_initialized) return;

//       if (next == widget.index) {
//         // Agar user is wale page par aaya hai toh play karo aur disk ghamao
//         _videoController!.play();
//         _animationController.repeat();
//       } else {
//         // Agar user kisi aur page par chala gaya toh isay khamoshi se pause kar do
//         _videoController!.pause();
//         _animationController.stop();
//       }
//     });

//     return Stack(
//       fit: StackFit.expand,
//       children: [
//         GestureDetector(
//           onTap: () async {
//             if (_videoController != null && _initialized) {
//               try {
//                 if (_videoController!.value.isPlaying) {
//                   await _videoController!.pause();
//                   _animationController.stop();
//                 } else {
//                   await _videoController!.play();
//                   _animationController.repeat();
//                 }
//                 if (mounted) setState(() {});
//               } catch (e) {
//                 print("Error toggling video: $e");
//               }
//             }
//           },
//           child: Container(
//             color: Colors.black,
//             child: Center(
//               child: _initialized && _videoController != null
//                   ? AspectRatio(
//                       aspectRatio: _videoController!.value.aspectRatio == 0.0
//                           ? 9 / 16
//                           : _videoController!.value.aspectRatio,
//                       child: VideoPlayer(_videoController!),
//                     )
//                   : const CircularProgressIndicator(color: Colors.white),
//             ),
//           ),
//         ),

//         if (_initialized &&
//             _videoController != null &&
//             !_videoController!.value.isPlaying)
//           Center(
//             child: Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.black.withOpacity(0.3),
//                 shape: BoxShape.circle,
//               ),
//               child: IconButton(
//                 onPressed: () async {
//                   try {
//                     await _videoController!.play();
//                     _animationController.repeat();
//                     if (mounted) setState(() {});
//                   } catch (e) {
//                     print("Error playing video: $e");
//                   }
//                 },
//                 icon: const Icon(
//                   Icons.play_arrow,
//                   size: 60,
//                   color: Colors.white70,
//                 ),
//               ),
//             ),
//           ),

//         Positioned.fill(
//           child: IgnorePointer(
//             child: Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
//                   begin: Alignment.center,
//                   end: Alignment.bottomCenter,
//                 ),
//               ),
//             ),
//           ),
//         ),
//         _buildOverlay(viewModel),
//       ],
//     );
//   }

//   Widget _buildOverlay(ReelsViewModel viewModel) {
//   // 1. Background mein user profile data fetch karne ke liye sirf listen ya watch karein
//   final userAsync = ref.watch(userProvider(widget.reel.username));

//   return Positioned(
//     bottom: 20,
//     left: 16,
//     right: 16,
//     child: Row(
//       crossAxisAlignment: CrossAxisAlignment.end,
//       children: [
//         Expanded(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Username aur profile icon par click karne ke liye wrapper
//               GestureDetector(
//                 onTap: () {
//                   // Video pause karein pehle
//                   _videoController?.pause();
//                   _animationController.stop();

//                   // UserAsync ke data ke mutabiq navigation handle karein
//                   userAsync.whenData((fetchedUser) {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => OtherProfileScreen(
//                           myId: FirebaseAuth.instance.currentUser?.uid ?? '',
//                           profileId: widget.reel.userID.isNotEmpty 
//                               ? widget.reel.userID 
//                               : (fetchedUser?.uid ?? ''), 
//                           myData: {
//                             'username': fetchedUser?.username ?? widget.reel.username,
//                             'displayName': fetchedUser?.name ?? 'No Name',
//                             'profileImageUrl': fetchedUser?.profileImageUrl ?? widget.reel.profileUrl,
//                           },
//                         ),
//                       ),
//                     );
//                   });
//                 },
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     CircleAvatar(
//                       radius: 16,
//                       backgroundImage: NetworkImage(widget.reel.profileUrl),
//                       backgroundColor: Colors.grey[800],
//                     ),
//                     const SizedBox(width: 10),
//                     Text(
//                       widget.reel.username, // Hamesha dikhega chahe network slow ho
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                     const SizedBox(width: 6),
//                     const Icon(
//                       Icons.verified,
//                       color: Colors.blueAccent,
//                       size: 16,
//                     ),
//                     const SizedBox(width: 10),
//                     Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.white),
//                         borderRadius: BorderRadius.circular(4),
//                       ),
//                       child: const Text(
//                         'Follow',
//                         style: TextStyle(color: Colors.white, fontSize: 10),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 12),
//               Text(
//                 widget.reel.caption,
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//                 style: const TextStyle(color: Colors.white, fontSize: 14),
//               ),
//               const SizedBox(height: 12),
//               Row(
//                 children: [
//                   const Icon(Icons.music_note, color: Colors.white, size: 14),
//                   const SizedBox(width: 6),
//                   Expanded(
//                     child: Text(
//                       widget.reel.musicName,
//                       overflow: TextOverflow.ellipsis,
//                       style: const TextStyle(color: Colors.white, fontSize: 13),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(width: 10),
        
//         // Side Action Buttons - Ab yeh hamesha screen par show honge!
//         Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             _buildActionItem(
//               icon: widget.reel.isLiked ? Icons.favorite : Icons.favorite_border,
//               color: widget.reel.isLiked ? Colors.red : Colors.white,
//               label: _formatNumber(widget.reel.likes),
//               onTap: () => viewModel.toggleLike(widget.index),
//             ),
//             const SizedBox(height: 20),
//             _buildActionItem(
//               icon: Icons.comment_rounded,
//               label: _formatNumber(widget.reel.comments),
//               onTap: () {},
//             ),
//             const SizedBox(height: 20),
//             _buildActionItem(
//               icon: Icons.share_rounded,
//               label: _formatNumber(widget.reel.shares),
//               onTap: () {},
//             ),
//             const SizedBox(height: 20),
//             const Icon(Icons.more_vert, color: Colors.white),
//             const SizedBox(height: 20),
//             RotationTransition(
//               turns: _animationController,
//               child: Container(
//                 width: 50,
//                 height: 50,
//                 padding: const EdgeInsets.all(8),
//                 decoration: const BoxDecoration(
//                   color: Colors.black,
//                   shape: BoxShape.circle,
//                 ),
//                 child: const CircleAvatar(
//                   backgroundImage: NetworkImage('https://ui-avatars.com/api/?name=Music'),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     ),
//   );
// }

//   Widget _buildActionItem({
//     required IconData icon,
//     required String label,
//     required VoidCallback onTap,
//     Color color = Colors.white,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Column(
//         children: [
//           Icon(icon, color: color, size: 32),
//           const SizedBox(height: 6),
//           Text(
//             label,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 13,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   String _formatNumber(int number) {
//     if (number >= 1000) return '${(number / 1000).toStringAsFixed(1)}k';
//     return number.toString();
//   }
// }