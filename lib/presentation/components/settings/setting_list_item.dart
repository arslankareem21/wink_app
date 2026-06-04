
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wink_app/core/config/theme/app_colors.dart';
import 'package:wink_app/core/config/theme/app_spacing.dart';
import 'package:wink_app/core/config/theme/app_text_style.dart';

class SettingsRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? iconColor;
  final VoidCallback? onTap;

  const SettingsRow(this.icon, this.text, this.iconColor, this.onTap, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: AppSpacing.sm),
      child: Row(
        
        children: [
          // Icon Container
          Container(
            width: 36.w,
            height: 36.h,
            decoration: BoxDecoration(
             // color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(18.r),
            ),
            child: Icon(icon, color: iconColor,),
          ),

          AppSpacing.hxl,
                Text(
                  text,
                  
                  style: AppTextStyles.bodyRegular.copyWith(
                    color: AppColors.black,
                  ),
                ),
            Spacer(),
            IconButton(
              icon: Icon(Icons.chevron_right_rounded, size: 22.sp,
              color: AppColors.dialogBgDark,
               ),
              onPressed: onTap,
            ),
        ],
      ),
     
    );
  }
}