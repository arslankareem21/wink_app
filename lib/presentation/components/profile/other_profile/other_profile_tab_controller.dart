
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wink_app/core/config/theme/app_colors.dart';
import 'package:wink_app/core/config/theme/app_text_style.dart';
import 'package:wink_app/presentation/components/profile/profileTabController/pofile_dafault_tab_controller.dart';
import 'package:wink_app/presentation/components/profile/profile_grid.dart';
import 'package:wink_app/service/reels/reels_service.dart';

class OtherUserProfileTabController extends ConsumerWidget {
final String targetUserId;
  const OtherUserProfileTabController({
    super.key, required this.targetUserId,
  });

  @override
  Widget build(BuildContext context,WidgetRef ref) {

    final otherUserReels = ref.watch(ReelService.otherUserReelsStreamProvider(targetUserId));
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          // Tab Bar
          TabBar(
            indicatorWeight: 2.h,
            labelColor: AppColors.primaryYellow,
            indicatorSize: TabBarIndicatorSize.tab,
            unselectedLabelColor: AppColors.greyText,
            labelStyle: AppTextStyles.sectionHeaderCaps.copyWith(
              fontSize: 10.sp,
            ),

            tabs: [
              //  TAB 1 POSTS
              Tab(icon: Icon(Icons.grid_view_rounded, size: 24.sp)),

              // TAB 2 SHORTS
              Tab(
                icon: Icon(
                  Icons.movie_creation_rounded, // Shorts icon
                  size: 24.sp,
                ),
                // label: 'SHORTS',
              ),

              //  TAB 3 SHORTS
              Tab(
                icon: Icon(
                  Icons.person, // Shorts icon
                  size: 24.sp,
                ),
                // label: 'SHORTS',
              ),
            ],
          ),

          //  Tab Content (The Views)
          Expanded(
            child: TabBarView(
              children: [
                
                PostsGrid(
                  imageUrls: [
                    ...List.generate(18,(i) => 'https://picsum.photos/300/300?random=${i + 1}',
                    ),
                  ],
                ),

              otherUserReels.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, stack) {
                    print("Error loading other user reels: $err");
                    return Center(child: Text("Error loading reels: $err"));
                  },
                  data: (reels) {
                    if (reels.isEmpty) {
                      return const Center(
                        child: Text(
                          "No Shorts Uploaded By This User",
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      );
                    }

                    return GridView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 5.h),
                      physics: const BouncingScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 3,
                        mainAxisSpacing: 3,
                        childAspectRatio: 9 / 16,
                      ),
                      itemCount: reels.length,
                      itemBuilder: (context, index) {
                        final currentReel = reels[index];
                        return GestureDetector(
                          onTap: () {
                            print("Clicked other user reel: ${currentReel.videoUrl}");
                            // 🚀 Full screen player implementation goes here
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[900],
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            clipBehavior: Clip.antiAlias,
                            // 🟢 Humara live lifecycle-aware video controller widget
                            child: ReelGridItem(reel: currentReel),
                          ),
                        );
                      },
                    );
                  },
                ),
                PostsGrid(
                  imageUrls: [
                    ...List.generate( 18,(i) => 'https://picsum.photos/300/300?random=${i + 1}',                   ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
