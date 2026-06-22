// presentation/components/settings/settings_header.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wink_app/core/config/theme/app_colors.dart';
import 'package:wink_app/core/config/theme/app_text_style.dart';
import 'package:wink_app/core/config/theme/app_spacing.dart';

class SettingsHeader extends StatelessWidget {
  final VoidCallback? onBack;
  final VoidCallback? onDone;

  const SettingsHeader({
    super.key,
    this.onBack,
    this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back Button
          GestureDetector(
            onTap: onBack,
            child: Container(
              width: 36.w,
              height: 36.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18.sp,
              ),
            ),
          ),

          // Title
          Text(
            'Settings',
            style: AppTextStyles.appBarTitle.copyWith(
              fontSize: 16.sp,
            ),
          ),

          // Done/Settings Icon
          GestureDetector(
            onTap: onDone,
            child: Container(
              width: 36.w,
              height: 36.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.settings_rounded,
                size: 20.sp,
                color: AppColors.primaryYellow,
              ),
            ),
          ),
        ],
      ),
    );
  }
}