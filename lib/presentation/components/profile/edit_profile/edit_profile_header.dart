
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wink_app/core/config/theme/app_colors.dart';
import 'package:wink_app/core/config/theme/app_text_style.dart';
import 'package:wink_app/core/config/theme/app_spacing.dart';

class EditProfileHeader extends StatelessWidget {
  final VoidCallback? onClose;
  final VoidCallback? onSave;

  const EditProfileHeader({
    super.key,
    this.onClose,
    this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Close Button (X)
          GestureDetector(
            onTap: onClose,
            child: Container(
              width: 36.w,
              height: 36.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark ? AppColors.cardDark : AppColors.cardLight,
              ),
              child: Icon(
                Icons.close_rounded,
                size: 20.sp,
                color: isDark ? AppColors.white : AppColors.black,
              ),
            ),
          ),

          // Title
          Text(
            'Edit Profile',
            style: AppTextStyles.appBarTitle.copyWith(
              fontSize: 16.sp,
              color: isDark ? AppColors.white : AppColors.black,
            ),
          ),

        ],
      ),
    );
  }
}