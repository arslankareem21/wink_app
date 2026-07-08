import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wink_app/presentation/components/shorts/shorts_card.dart';
import 'package:wink_app/viewmodels/reels/reels_viewmodel.dart';
import 'package:wink_app/presentation/provider/get_profile_providers.dart';
import 'package:wink_app/service/firestore_service.dart';
import '../profile/other_user_profile_screen.dart';

class ShortsPage extends ConsumerStatefulWidget {
  const ShortsPage({super.key});

  @override
  ConsumerState<ShortsPage> createState() => _ShortsPageState();
}

class _ShortsPageState extends ConsumerState<ShortsPage>
    with WidgetsBindingObserver {
  late final PageController _pageController;
  late final ShortsViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _viewModel = ref.read(shortsViewModelProvider.notifier);
    final index = ref.read(shortsViewModelProvider).currentIndex;
    _pageController = PageController(initialPage: index, keepPage: true);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pageController.dispose();
    unawaited(_viewModel.pauseAll().catchError((_) {}));
    super.dispose();
  }

  // 6. Pause video when leaving Shor ts via BottomNavigation
  @override
  void deactivate() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      unawaited(_viewModel.pauseAll().catchError((_) {}));
    });
    super.deactivate();
  }
  

  @override
  void activate() {
    super.activate();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      unawaited(_viewModel.resumeCurrent().catchError((_) {}));
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        unawaited(_viewModel.resumeCurrent().catchError((_) {}));
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
      case AppLifecycleState.detached:
        unawaited(_viewModel.pauseAll().catchError((_) {}));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(shortsViewModelProvider);
    final vm = ref.read(shortsViewModelProvider.notifier);
    final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? "";

    if (state.loading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    if (state.error != null) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            state.error!,
            style: const TextStyle(color: Colors.white),
          ),
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
        child: RefreshIndicator(
          color: Colors.white,
          backgroundColor: Colors.black,
          onRefresh: () => vm.refreshFeed(),
          child: PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            // 12. Smooth scrolling like YouTube Shorts
            allowImplicitScrolling: true,
            pageSnapping: true,
            physics: const PageScrollPhysics(),
            itemCount: state.shorts.length,
            onPageChanged: (index) => vm.onPageChanged(index),
            itemBuilder: (context, index) {
              final short = state.shorts[index];
              final controller = vm.controller(index);
              final isLoading = controller == null
                  ? true
                  : !controller
                        .value
                        .isInitialized; // Only show loading if not initialized
              final hasError = vm.hasError(index);
              final user = ref.watch(userInfoProvider(short.userId));
              final liked = ref.watch(isLikedProvider(short.shortId));
              final followParams = (currentUserId: currentUserId, targetUserId: short.userId);
              final followAsync = ref.watch(isFollowingMergedProvider(followParams));
              final isFollowing = followAsync.value ?? false;
              final isFollowingLoading = followAsync.isLoading && followAsync.value == null;

              final username = user.value?['username'] ?? "user";
              final profileUrl = user.value?['profileUrl'] ?? "";
              final isLiked = liked.value ?? false;
              final displayLikes = short.likesCount < 0 ? 0 : short.likesCount;

              return ShortsCard(
                key: ValueKey(short.shortId),
                short: short,
                username: username,
                profileUrl: profileUrl,
                isLiked: isLiked,
                isFollowing: isFollowing,
                isFollowingLoading: isFollowingLoading,
                isCurrentUser: short.userId == currentUserId,
                isLoading: isLoading,
                hasError: hasError,
                likesCount: displayLikes,
                controller: controller,
                onVideoTap: () => vm.toggleVideo(index),
                onLike: () => vm.toggleLike(short.shortId),
                onFollow: () async {
                  final firestore = ref.read(firestoreServiceProvider);
                  final optimisticNotifier = ref.read(followOptimisticProvider(followParams).notifier);
                  final currentState = isFollowing;

                  optimisticNotifier.state = !currentState;

                  try {
                    if (currentState) {
                      await firestore.unfollowUser(currentUserId, short.userId);
                    } else {
                      await firestore.followUser(currentUserId, short.userId);
                    }
                    optimisticNotifier.state = null;
                  } catch (e) {
                    optimisticNotifier.state = currentState;
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed: $e')),
                      );
                    }
                    await Future.delayed(const Duration(milliseconds: 300));
                    optimisticNotifier.state = null;
                  }
                },
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
      ),
    );
  }
}
