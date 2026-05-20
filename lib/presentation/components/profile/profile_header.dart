import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wink_app/core/config/theme/app_colors.dart';
import 'package:wink_app/core/config/theme/app_text_style.dart';
import 'package:wink_app/core/config/theme/app_spacing.dart';
import 'package:wink_app/presentation/widgets/circle_avatar.dart';

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
      AppProfileAvatar(size: 100.r,isNetwork: true,imageSource: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRf3Ylx2q3aTJ5-OQ1LB5rGeL_szA8DDbEk4g&s'),
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