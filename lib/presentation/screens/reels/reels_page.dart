import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wink_app/presentation/components/shorts/shorts_card.dart';
import 'package:wink_app/presentation/provider/get_profile_providers.dart' hide isFollowingProvider;
import 'package:wink_app/viewmodels/reels/reels_viewmodel.dart';
import '../profile/other_user_profile_screen.dart';

class ShortsPage extends ConsumerStatefulWidget {
  const ShortsPage({super.key});

  @override
  ConsumerState<ShortsPage> createState() => _ShortsPageState();
}

class _ShortsPageState extends ConsumerState<ShortsPage>
    with WidgetsBindingObserver {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    final index = ref.read(shortsViewModelProvider).currentIndex;
    _pageController = PageController(initialPage: index, keepPage: true);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pageController.dispose();
    super.dispose();
  }

  // 6. Pause video when leaving Shorts via BottomNavigation
  @override
  void deactivate() {
    ref.read(shortsViewModelProvider.notifier).pauseAll();
    super.deactivate();
  }

  @override
  void activate() {
    super.activate();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(shortsViewModelProvider.notifier).resumeCurrent();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final vm = ref.read(shortsViewModelProvider.notifier);
    switch (state) {
      case AppLifecycleState.resumed:
        vm.resumeCurrent();
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
      case AppLifecycleState.detached:
        vm.pauseAll();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(shortsViewModelProvider);
    final vm = ref.read(shortsViewModelProvider.notifier);
    final currentUserId = FirebaseAuth.instance.currentUser?.uid?? "";

    if (state.loading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    if (state.error!= null) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(state.error!, style: const TextStyle(color: Colors.white)),
        ),
      );
    }

    if (state.shorts.isEmpty) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text("No Shorts Found", style: TextStyle(color: Colors.white)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: PageView.builder(
          controller: _pageController,
          scrollDirection: Axis.vertical,
          // 12. Smooth scrolling like YouTube Shorts
          allowImplicitScrolling: true,
          pageSnapping: true,
          physics: const PageScrollPhysics(),
          itemCount: state.shorts.length,
          onPageChanged: vm.onPageChanged,
          itemBuilder: (context, index) {
            final short = state.shorts[index];
            final controller = vm.controller(index);
            final isLoading = controller == null
               ? true
                : !controller.value.isInitialized; // Only show loading if not initialized
            final hasError = vm.hasError(index);
            final user = ref.watch(userInfoProvider(short.userId));
            final liked = ref.watch(isLikedProvider(short.shortId));
            final following = ref.watch(isFollowingProvider(short.userId));

            final username = user.value?['username']?? "user";
            final profileUrl = user.value?['profileUrl']?? "";
            // Use optimistic like state if available, otherwise use Firestore state
            final isLiked = vm.isLikedOptimistic(short.shortId) || (liked.value?? false);
            final isFollowing = following.value?? false;

            return ShortsCard(
              key: ValueKey(short.shortId),
              short: short,
              username: username,
              profileUrl: profileUrl,
              isLiked: isLiked,
              isFollowing: isFollowing,
              isCurrentUser: short.userId == currentUserId,
              isLoading: isLoading,
              hasError: hasError,
              controller: controller,
              onVideoTap: () => vm.toggleVideo(index),
              onLike: () => vm.like(index),
              onFollow: () => vm.follow(short.userId),
              onComment: () {},
              onShare: () {},
              onUserTap: () {
                // 7. Pause while profile screen opens
                vm.pauseAll();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => OtherProfileScreen(
                      myId: currentUserId,
                      profileId: short.userId,
                      myData: {
                        "username": username,
                        "displayName": username,
                        "profileImageUrl": profileUrl,
                      },
                    ),
                  ),
                ).then((_) {
                  vm.resumeCurrent();
                });
              },
            );
          },
        ),
      ),
    );
  }
}