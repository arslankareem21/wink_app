// presentation/components/profile/posts_grid.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wink_app/core/config/theme/app_colors.dart';
import 'package:wink_app/core/config/theme/app_text_style.dart';
import 'package:wink_app/presentation/components/profile/profile_grid.dart';

class OtherUserProfileTabController extends StatelessWidget {
  // final List<String> imageUrls;
  // final Function(String)? onImageTap;

  const OtherUserProfileTabController({
    super.key,
    // required this.imageUrls,
    // this.onImageTap,
    //required bool isOtherProfile,
  });

  @override
  Widget build(BuildContext context) {
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
              // 🟡 TAB 1: POSTS
              Tab(icon: Icon(Icons.grid_view_rounded, size: 24.sp)),

              // 🟡 TAB 2: SHORTS
              Tab(
                icon: Icon(
                  Icons.movie_creation_rounded, // Shorts icon
                  size: 24.sp,
                ),
                // label: 'SHORTS',
              ),

              //  TAB 3: SHORTS
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

                PostsGrid(
                  imageUrls: [ ...List.generate(18,(i) => 'https://picsum.photos/300/300?random=${i + 1}',                  ),
                  ],
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

    //   GridView.builder(
    //     shrinkWrap: true,
    //     physics: const NeverScrollableScrollPhysics(),
    //     padding: EdgeInsets.all(2.w),
    //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //       crossAxisCount: 3,
    //       crossAxisSpacing: 2.w,
    //       mainAxisSpacing: 2.h,
    //     ),
    //     itemCount: imageUrls.length,
    //     itemBuilder: (context, index) {
    //       return GestureDetector(
    //         onTap: () => onImageTap?.call(imageUrls[index]),
    //         child: ClipRRect(
    //           borderRadius: BorderRadius.circular(4.r),
    //           child: Stack(
    //             fit: StackFit.expand,
    //             children: [
    //               Image.network(
    //                 imageUrls[index],
    //                 fit: BoxFit.cover,
    //                 loadingBuilder: (context, child, loadingProgress) {
    //                   if (loadingProgress == null) return child;
    //                   return Container(
    //                     color: AppColors.grey.withOpacity(0.1),
    //                     child: const Center(
    //                       child: CircularProgressIndicator(strokeWidth: 2),
    //                     ),
    //                   );
    //                 },
    //                 errorBuilder: (context, error, stackTrace) {
    //                   return Container(color: AppColors.grey);
    //                 },
    //               ),
    //             ],
    //           ),
    //         ),
    //       );
    //     },
    //   );
  }
}
