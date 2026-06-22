
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wink_app/core/config/theme/app_colors.dart';
import 'package:wink_app/core/config/theme/app_text_style.dart';
import 'package:wink_app/presentation/components/profile/profile_grid.dart';

class OtherUserProfileTabController extends StatelessWidget {

  const OtherUserProfileTabController({
    super.key,
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
  }
}
