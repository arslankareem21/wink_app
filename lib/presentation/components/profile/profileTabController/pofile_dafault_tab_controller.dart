import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wink_app/core/config/theme/app_colors.dart';
import 'package:wink_app/core/config/theme/app_text_style.dart';
import 'package:wink_app/presentation/components/profile/post_grid.dart';
import 'package:wink_app/presentation/components/profile/shorts_grid.dart';
import 'package:wink_app/presentation/provider/get_profile_providers.dart';


class ProfileTabsView extends ConsumerWidget {
  final String userId;

  const ProfileTabsView({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(userPostsProvider(userId));
    final shortsAsync = ref.watch(userShortsProvider(userId));

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: TabBar(
              indicatorWeight: 2.h,
              labelColor: AppColors.primaryYellow,
              unselectedLabelColor: Colors.grey,
              indicatorSize: TabBarIndicatorSize.tab,
              labelStyle: AppTextStyles.sectionHeaderCaps.copyWith(fontSize: 10.sp),
              unselectedLabelStyle: AppTextStyles.sectionHeaderCaps.copyWith(fontSize: 10.sp),
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.grid_view_rounded, size: 20.sp),
                      SizedBox(width: 6.w),
                      Text('POSTS', style: TextStyle(fontSize: 13.sp)),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.movie_creation_rounded, size: 20.sp),
                      SizedBox(width: 6.w),
                      Text('SHORTS', style: TextStyle(fontSize: 13.sp)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                // POSTS TAB
                postsAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Center(
                    child: Text("Error loading posts",
                        style: TextStyle(color: Colors.grey, fontSize: 14.sp)),
                  ),
                  data: (posts) => CustomScrollView(
                    key: const PageStorageKey<String>('posts_tab'),
                    slivers: [
                      PostsGrid(posts: posts), // ✅ sliver widget
                    ],
                  ),
                ),
                // SHORTS TAB
                shortsAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Center(
                    child: Text("Error loading shorts",
                        style: TextStyle(color: Colors.grey, fontSize: 14.sp)),
                  ),
                  data: (shorts) => CustomScrollView(
                    key: const PageStorageKey<String>('shorts_tab'),
                    slivers: [
                      ShortsGrid(shorts: shorts), // ✅ sliver widget
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
