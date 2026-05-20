// presentation/components/profile/profile_stats.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wink_app/core/config/theme/app_colors.dart';
import 'package:wink_app/core/config/theme/app_text_style.dart';
import 'package:wink_app/core/config/theme/app_spacing.dart';
import 'package:wink_app/presentation/screens/profile/edit_profile.dart';
import 'package:wink_app/presentation/widgets/elevated_button.dart';

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
            _buildStatItem(
              postsCount.toString(),
              'Posts',
            ),
            _buildStatItem(
              followersCount,
              'Followers',
            ),
            _buildStatItem(
              followingCount.toString(),
              'Following',
            ),
          ],
        ),

        AppSpacing.vxl,

        // // Edit Profile Button

        Padding(
          padding: const 
          EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          //EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),  
          child: AppButton(
            isGhost: true,
            text: 'Edit Profile', onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfileScreen()));
          }),
        ),
        AppSpacing.vxl,
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
            fontWeight: FontWeight.w700,          ),
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