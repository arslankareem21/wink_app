import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wink_app/core/config/theme/app_colors.dart';
import 'package:wink_app/core/config/theme/app_spacing.dart';
import 'package:wink_app/models/post_model.dart';
import 'package:wink_app/models/post_models.dart';
import 'package:wink_app/models/story_model.dart';
import 'package:wink_app/presentation/components/post/post_card.dart';

import 'package:wink_app/presentation/components/splash/splash_logo.dart';
import 'package:wink_app/presentation/provider/story/story_provider.dart';
import 'package:wink_app/presentation/provider/user_provider.dart'
    hide userProvider;
import 'package:wink_app/presentation/screens/story/story_viewer_screen.dart';
import 'package:wink_app/viewmodels/auth_viewmodel.dart';
import 'package:wink_app/viewmodels/post_viewmodel.dart';

// 1. Auth provider

// 2. Feed posts provider - auto disposes when screen unmounts
final feedPostsProvider = StreamProvider.autoDispose<List<PostModels>>((ref) {
  return ref.watch(postRepositoryProvider).watchFeedPosts();
});

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(feedPostsProvider);
    final currentUserID = ref.watch(currentUserProvider);
    final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
    final userAsync = ref.watch(userProvider(currentUserId));
    final activeStoriesAsync = ref.watch(activeStoriesStreamProvider);

    return userAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stack) =>
          Scaffold(body: Center(child: Text('Error loading profile: $error'))),
      data: (user) {
        if (user == null) {
          return const Scaffold(body: Center(child: Text('User not found')));
        }

        final String myUserId = user.userId;

        return activeStoriesAsync.when(
          loading: () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
          error: (err, stack) =>
              Scaffold(body: Center(child: Text('Story fetch error: $err'))),
          data: (storiesList) {
            // Meri aur baqi doston ki stories logic background layer par
            final myStories = storiesList
                .where((s) => s.userId == myUserId)
                .toList();
            final otherStories = storiesList
                .where((s) => s.userId != myUserId)
                .toList();

            final Map<String, List<StoryModel>> groupedOtherStories =
                groupStoriesByUser(
                  storiesList.where((s) => s.userId != myUserId).toList(),
                );

            // 3. Unique User IDs ki list nikal li taake utne hi gole (avatars) banein
            final otherUserIds = groupedOtherStories.keys.toList();
            return Scaffold(
              appBar: AppBar(
                elevation: 0,
                scrolledUnderElevation: 0.5,
                title: SizedBox(height: 40.h, child: const SplashLogo()),
                centerTitle: false,
                actions: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.favorite_border_rounded, size: 26.sp),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.send_outlined, size: 24.sp),
                  ),
                  SizedBox(width: 8.w),
                ],
              ),
              body: postsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => _ErrorView(
                  error: error.toString(),
                  onRetry: () => ref.invalidate(feedPostsProvider),
                ),
                data: (posts) {
                  if (posts.isEmpty) {
                    return const _EmptyFeed();
                  }
                  return RefreshIndicator(
                    onRefresh: () async => ref.refresh(feedPostsProvider),
                    child: Padding(
                      padding: AppSpacing.screenPadding,
                      child: ListView.separated(
                        padding: EdgeInsets.only(top: 8.h, bottom: 24.h),
                        itemCount: posts.length,
                        separatorBuilder: (_, __) =>
                            SizedBox(height: 0), // PostCard has margin
                        itemBuilder: (context, index) {
                          final post = posts[index];
                          return PostCard(
                            key: ValueKey(
                              post.postId,
                            ), // Important for state preservation
                            post: post,
                            currentUserId: currentUserId,
                            onComment: () =>
                                _openComments(context, post.postId),
                            onShare: () => _sharePost(context, post.postId),
                            onHashtagTap: (tag) => _searchHashtag(context, tag),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}

void _openComments(BuildContext context, String postId) {
  // Navigator.push(context, MaterialPageRoute(builder: (_) => CommentsScreen(postId: postId)));
}

void _sharePost(BuildContext context, String postId) {
  // Share.share('Check this post: https://wink.app/p/$postId');
}

void _searchHashtag(BuildContext context, String tag) {
  // Navigator.push(context, MaterialPageRoute(builder: (_) => HashtagScreen(tag: tag)));
}

class _EmptyFeed extends StatelessWidget {
  const _EmptyFeed();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.camera_alt_outlined, size: 64.sp, color: Colors.grey),
          SizedBox(height: 16.h),
          Text(
            'No Posts Yet',
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8.h),
          Text(
            'Follow people to see their posts',
            style: TextStyle(fontSize: 14.sp, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const _ErrorView({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64.sp, color: Colors.red),
          SizedBox(height: 16.h),
          Text('Something went wrong', style: TextStyle(fontSize: 16.sp)),
          SizedBox(height: 8.h),
          Text(
            error,
            style: TextStyle(fontSize: 12.sp, color: Colors.grey),
          ),
          SizedBox(height: 16.h),
          ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}

/////////////////
class FriendStoryAvatar extends ConsumerWidget {
  final String friendId;
  final List<StoryModel> friendStories;

  const FriendStoryAvatar({
    super.key,
    required this.friendId,
    required this.friendStories,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendUserAsync = ref.watch(userProvider(friendId));
    final displayStory = friendStories.first;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ViewStoryScreen(stories: friendStories),
            ),
          );
        },
        child: Column(
          children: [
            CircleAvatar(
              radius: 35.r,
              backgroundColor: AppColors.primaryYellow,
              child: CircleAvatar(
                radius: 32.r,
                backgroundColor: Colors.grey[900],
                backgroundImage: displayStory.mediaUrl.startsWith('http')
                    ? NetworkImage(displayStory.mediaUrl)
                    : const AssetImage('assets/placeholder.png')
                          as ImageProvider,
              ),
            ),
            AppSpacing.vxs,
            friendUserAsync.when(
              loading: () => SizedBox(
                width: 10.w,
                height: 10.h,
                child: const CircularProgressIndicator(strokeWidth: 2),
              ),
              error: (_, __) =>
                  Text('Friend', style: TextStyle(fontSize: 12.sp)),
              data: (friendUser) {
                return Text(
                  //friendUser?.userName ??
                  friendUser?.name ?? 'Friend',
                  style: TextStyle(fontSize: 12.sp),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

Map<String, List<StoryModel>> groupStoriesByUser(List<StoryModel> allStories) {
  Map<String, List<StoryModel>> grouped = {};
  for (var story in allStories) {
    if (!grouped.containsKey(story.userId)) {
      grouped[story.userId] = [];
    }
    grouped[story.userId]!.add(story);
  }
  return grouped;
}
