import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wink_app/core/config/routes/navigation_service.dart';
import 'package:wink_app/core/config/routes/route_names.dart';
import 'package:wink_app/core/config/theme/app_colors.dart';
import 'package:wink_app/core/config/theme/app_text_style.dart';
import 'package:wink_app/core/config/theme/app_spacing.dart';

class ProfileStats extends StatelessWidget {
  final int postsCount;
  final String followersCount;
  final int followingCount;
  final VoidCallback? onEditProfile;

  const ProfileStats({
    super.key,
    required this.postsCount,
    required this.followersCount,
    required this.followingCount,
    this.onEditProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppSpacing.vxl,

        // Stats Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStatItem(postsCount.toString(), 'Posts'),
            InkWell(
              onTap: () {
                NavigationService.push(context, AppRoutes.followFollowing);
              },
              child: _buildStatItem(followersCount, 'Followers'),
            ),
            InkWell(
              onTap: (){
            NavigationService.push(context, AppRoutes.followFollowing);
              },
              child: _buildStatItem(followingCount.toString(), 'Following')),
          ],
        ),

        AppSpacing.vxl,
        // ProfileBio(
      ],
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.postEngagementCount.copyWith(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        AppSpacing.vxs,
        Text(
          label,
          style: AppTextStyles.storyLabel.copyWith(
            fontSize: 12.sp,
            color: AppColors.greyText,
          ),
        ),
      ],
    );
  }
}
