// presentation/components/settings/settings_profile_section.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wink_app/core/config/theme/app_colors.dart';
import 'package:wink_app/core/config/theme/app_text_style.dart';
import 'package:wink_app/core/config/theme/app_spacing.dart';

class SettingsProfileSection extends StatelessWidget {
  final String name;
  final String username;
  final String? profileImageUrl;
  final VoidCallback? onTap;

  const SettingsProfileSection({
    super.key,
    required this.name,
    required this.username,
    this.profileImageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
  

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
        child: Column(
          children: [
            // Profile Picture
            Container(
              width: 56.w,
              height: 56.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primaryYellow,
                  width: 2.w,
                ),
               
              ),
              child: profileImageUrl != null
                  ? ClipOval(
                      child: Image.network(
                        profileImageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
                      ),
                    )
                  : _buildPlaceholder(),
            ),

            AppSpacing.hlg,

            // Name and Username
            // Expanded(
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
                  Text(
                    name,
                    style: AppTextStyles.authHeadline.copyWith(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  AppSpacing.vxs,
                  Text(
                    username,
                    style: AppTextStyles.bodyRegular.copyWith(
                      fontSize: 13.sp,
                      color: AppColors.greyText,
                    ),
                  ),
            //     ],
            //   ),
            // ),

           
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Icon(
      Icons.person,
      size: 28.sp,
      color: AppColors.primaryYellow,
    );
  }
}