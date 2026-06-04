// presentation/components/settings/premium_banner.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wink_app/core/config/theme/app_colors.dart';
import 'package:wink_app/core/config/theme/app_text_style.dart';
import 'package:wink_app/core/config/theme/app_spacing.dart';
import 'package:wink_app/presentation/widgets/elevated_button.dart';

class PremiumBanner extends StatelessWidget {
  final VoidCallback? onTap;

  const PremiumBanner({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(width: 300.w,height:155.h,
        margin: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
        padding: EdgeInsets.all(AppSpacing.lg.w),
        decoration: BoxDecoration(
          color: AppColors.primaryYellow,
          borderRadius: BorderRadius.circular(27.r),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Star Icon
            AppSpacing.hlg,
        
            // Text Content
            // Expanded(
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
                  Text(
                    'Go Premium',
                    style: AppTextStyles.authHeadline.copyWith(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.secondary,
                    ),
                  ),
                  AppSpacing.vxs,
                  Text(
                    'Unlock ad-free experience and\nexclusive content creator tools.',
                    style: AppTextStyles.bodyRegular.copyWith(
                      fontSize: 12.sp,
                      color: AppColors.secondary.withOpacity(0.8),
                      height: 1.4,
                    ),
                  ),
                  AppSpacing.vxs,

                  AppButton(text: 'Learn More',textColor: AppColors.primary, isGhost: true,width:120.w,height:40.h)
                ],
              ),
            ),
    );
  }
}