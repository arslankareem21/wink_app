import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wink_app/presentation/components/shorts/shorts_card.dart';
import 'package:wink_app/presentation/screens/create/shorts/shorts_pagination.dart';
import 'package:wink_app/viewmodels/mediaservice_provider.dart';

import 'package:wink_app/viewmodels/shorts_viewmodel.dart';

import 'package:wink_app/viewmodels/auth_viewmodel.dart';

class ShortsFeedScreen extends ConsumerStatefulWidget {
  const ShortsFeedScreen({super.key});
  @override
  ConsumerState<ShortsFeedScreen> createState() => _ShortsFeedScreenState();
}

class _ShortsFeedScreenState extends ConsumerState<ShortsFeedScreen> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    Future.microtask(() => ref.read(shortsPaginationProvider.notifier).fetchFirstBatch());
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _handleViewCount(String shortId) {
    final vm = ref.read(shortsViewModelProvider.notifier);
    if (vm.isViewCounted(shortId)) return;

    Future.delayed(const Duration(seconds: 5), () {
      if (!mounted) return;
      final shorts = ref.read(shortsPaginationProvider);
      if (_currentIndex >= shorts.length || shorts[_currentIndex].shortId!= shortId) return;

      vm.markViewCounted(shortId);
      final userId = ref.read(currentUserIdProvider);
      if (userId!= null) {
        ref.read(firestoreProvider).incrementShortView(shortId, userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final shorts = ref.watch(shortsPaginationProvider);
    final notifier = ref.read(shortsPaginationProvider.notifier);
    final vm = ref.watch(shortsViewModelProvider);
    final currentUserId = ref.watch(currentUserIdProvider);

    if (!notifier.hasLoadedOnce || (notifier.isRefreshing && shorts.isEmpty)) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    if (shorts.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: RefreshIndicator(
          color: Colors.white,
          backgroundColor: Colors.black,
          onRefresh: () => notifier.refresh(),
          child: Stack(
            children: [
              ListView(),
              const Center(
                child: Text(
                  'No shorts yet\nPull to refresh',
                  textAlign: TextAlign.center,
                  style: TextStyle( fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: RefreshIndicator(
        color: Colors.white,
        backgroundColor: Colors.black,
        onRefresh: () async {
          await notifier.refresh();
          if (_pageController.hasClients) {
            _pageController.jumpToPage(0);
          }
          setState(() => _currentIndex = 0);
        },
        child: PageView.builder(
          scrollDirection: Axis.vertical,
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
            if (index >= shorts.length - 3) {
              notifier.fetchMore();
            }
          },
          itemCount: shorts.length,
          itemBuilder: (context, index) {
            final short = shorts[index];
            final userAsync = ref.watch(userByIdProvider(short.userId));
            final isFollowingAsync = ref.watch(isFollowingProvider(short.userId));
            final isLikedAsync = ref.watch(isShortLikedProvider(short.shortId));

            final user = userAsync.asData?.value;
            final realFollowing = isFollowingAsync.asData?.value?? false;
            final realLiked = isLikedAsync.asData?.value?? false;

            // Get optimistic state from viewmodel
            final optimisticFollows = ref.read(shortsViewModelProvider.notifier).optimisticFollows;
            final optimisticLikes = ref.read(shortsViewModelProvider.notifier).optimisticLikes;

            final isFollowing = optimisticFollows[short.userId]?? realFollowing;
            final isLiked = optimisticLikes[short.shortId]?? realLiked;
            final shouldInit = (index - _currentIndex).abs() <= 1;
            final isOwnVideo = currentUserId == short.userId;

            return ShortsCard(
              key: ValueKey(short.shortId),
              short: short,
              user: user,
              isActive: index == _currentIndex,
              shouldInit: shouldInit,
              isLiked: isLiked,
              isFollowing: isFollowing,
              isOwnVideo: isOwnVideo, // Hide follow button
              onLike: () => ref.read(shortsViewModelProvider.notifier).toggleLike(short.shortId, isLiked),
              onFollow: () => ref.read(shortsViewModelProvider.notifier).toggleFollow(short.userId, isFollowing),
              onViewCount: () => _handleViewCount(short.shortId),
              onUserTap: (userId) {
                if (userId.isNotEmpty) {
                  context.push('/profile/$userId');
                }
              },
            );
          },
        ),
      ),
    );
  }
}