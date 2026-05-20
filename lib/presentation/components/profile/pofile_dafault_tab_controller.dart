import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wink_app/core/config/theme/app_colors.dart';
import 'package:wink_app/core/config/theme/app_text_style.dart';
import 'package:wink_app/presentation/components/profile/profile_grid.dart';

class ProfileTabsView extends StatefulWidget {
  const ProfileTabsView({super.key});

  @override
  State<ProfileTabsView> createState() => _ProfileTabsViewState();
}

class _ProfileTabsViewState extends State<ProfileTabsView> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          //  Tab Bar
          TabBar(
            // Style the active tab indicator
            // indicatorColor: AppColors.primaryYellow,
            indicatorWeight: 2.h,
            // indicatorSize: 20.w,

            // Style the text labels
            labelColor: AppColors.primaryYellow,
            indicatorSize: TabBarIndicatorSize.tab,
            //unselectedLabelColor: AppColors.greyText,
            labelStyle: AppTextStyles.sectionHeaderCaps.copyWith(
              fontSize: 10.sp,
            ),

            tabs: [
              //  TAB 1: POSTS
              Tab(
                icon: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.grid_view_rounded, size: 24.sp),
                    SizedBox(width: 3.w),
                    Text('POSTS', style: TextStyle(fontSize: 14.sp)),
                  ],
                ),
              ),

              //  TAB 2: SHORTS
              //if(isOtherProfile)
              Tab(
                icon: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.movie_creation_rounded, // Shorts icon
                      size: 24.sp,
                    ),
                    SizedBox(width: 3.w),
                    Text('SHORTS', style: TextStyle(fontSize: 14.sp)),
                  ],
                ),
                // label: 'SHORTS',
              ),

              ///tap3
            ],
          ),

          //  Tab Content (The Views)
          Expanded(
            child: TabBarView(
              children: [
                PostsGrid(
                  imageUrls: [
                    ...List.generate(18,(i) => 'https://picsum.photos/300/300?random=${i + 1}',),
                  ],
                ),

                PostsGrid(
                  imageUrls: [
                    ...List.generate(18, (i) => 'https://picsum.photos/300/300?random=${i + 1}',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🟡 Helper Widget for Grid
  // Widget _buildGrid({required bool isVideo}) {
  //   // Sample Data
  //   final List<String> images = List.generate(
  //     9,
  //     (index) => 'https://picsum.photos/300/300?random=${index + 1}',
  //   );

  //   return GridView.builder(
  //     padding: EdgeInsets.all(2.w),
  //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //       crossAxisCount: 3,
  //       crossAxisSpacing: 2.w,
  //       mainAxisSpacing: 2.h,
  //     ),
  //     itemCount: images.length,
  //     itemBuilder: (context, index) {
  //       return Stack(
  //         fit: StackFit.expand,
  //         children: [
  //           // Image
  //           ClipRRect(
  //             borderRadius: BorderRadius.circular(4.r),
  //             child: Image.network(
  //               images[index],
  //               fit: BoxFit.cover,
  //               loadingBuilder: (context, child, loadingProgress) {
  //                 if (loadingProgress == null) return child;
  //                 return Container(
  //                   color: AppColors.grey.withOpacity(0.1),
  //                   child: const Center(
  //                     child: CircularProgressIndicator(strokeWidth: 2),
  //                   ),
  //                 );
  //               },
  //             ),
  //           ),

  //         ],
  //       );
  //     },
  //   );
  // }
}
