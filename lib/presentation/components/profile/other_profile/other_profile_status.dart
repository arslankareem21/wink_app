// presentation/components/profile/profile_stats.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wink_app/core/config/theme/app_colors.dart';
import 'package:wink_app/core/config/theme/app_text_style.dart';
import 'package:wink_app/core/config/theme/app_spacing.dart';

class OtherUserProfileStats extends StatelessWidget {
  final int postsCount;
  final String followersCount;
  final int followingCount;

  const OtherUserProfileStats({
    super.key,
    required this.postsCount,
    required this.followersCount,
    required this.followingCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
      child: Row(
        children: [
          SizedBox(width: 10.w,),
          _buildStatItem(context,
            postsCount.toString(),
            'POSTS',
          ),

          
          SizedBox(width: 30.w,),
          _buildStatItem(context,
            followersCount,
            'FOLLOWERS',
          ),SizedBox(width: 30.w,),
          _buildStatItem(context,
            followingCount.toString(),
            'FOLLOWING',
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String value, String label) {
 
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.postEngagementCount.copyWith(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,

          ),
        ),
        AppSpacing.vxs,
        Text(
          label,
          style: AppTextStyles.sectionHeaderCaps.copyWith(
            fontSize: 10.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.greyText,
          ),
        ),
      ],
    );
  }
}