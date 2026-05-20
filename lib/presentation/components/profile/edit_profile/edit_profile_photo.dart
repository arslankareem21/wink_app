// presentation/components/profile/profile_photo_section.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wink_app/core/config/theme/app_colors.dart';
import 'package:wink_app/core/config/theme/app_text_style.dart';
import 'package:wink_app/core/config/theme/app_spacing.dart';
import 'package:wink_app/presentation/widgets/circle_avatar.dart';

class ProfilePhotoSection extends StatelessWidget {
  final String? profileImageUrl;
  final VoidCallback? onChangePhoto;

  const ProfilePhotoSection({
    super.key,
    this.profileImageUrl,
    this.onChangePhoto,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Profile Picture with Overlay
        Stack(
          children: [
            AppProfileAvatar(size: 100.r,),
          ],
        ),

        AppSpacing.vlg,

        // Change Photo Text
        GestureDetector(
          onTap: onChangePhoto,
          child: Text(
            'Change photo',
            style: AppTextStyles.textLink.copyWith(
              fontSize: 14.sp,
              color: AppColors.primaryYellow,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Icon(Icons.person, size: 50.sp, color: AppColors.primaryYellow);
  }
}
