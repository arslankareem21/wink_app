import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wink_app/core/config/theme/app_colors.dart';
import 'package:wink_app/core/config/theme/app_text_style.dart';
import 'package:wink_app/core/config/theme/app_spacing.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String bio;
  final String? profileImageUrl;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.bio,
    this.profileImageUrl,
  });

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
      
        AppSpacing.vlg,

        // Name
        Text(
          name,
          style: AppTextStyles.authHeadline.copyWith(
            fontSize: 18.sp,
          ),
        ),

        AppSpacing.vxs,

        // Bio
        Text(
          bio,
          style: AppTextStyles.bodyRegular.copyWith(
            fontSize: 12.sp,
            color: AppColors.greyText,
          ),
        ),
      ],
    );
  }

 
}