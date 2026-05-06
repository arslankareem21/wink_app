import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wink_app/core/config/theme/app_spacing.dart';
import 'package:wink_app/core/config/theme/app_text_style.dart';
import 'package:wink_app/presentation/components/onboarding/onboarding_indicator.dart';
import 'package:wink_app/presentation/widgets/elevated_button.dart';
import 'package:wink_app/presentation/widgets/toogle_theme_button.dart';

class Onboarding2Screen extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  const Onboarding2Screen({super.key, required this.onNext, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: ThemeToggleButton(),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          height: 342,
                          width: 342,
                          "assets/image/onboarding1_bg.png",
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            width: 342,
                            height: 342,
                            color: Colors.grey[300], // Placeholder color),
                          ), // adjust radius
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16), // adjust radius
                          child: Image.asset(
                            'assets/image/onboarding2_boy.png',
                            width: 300,
                            height: 300,
                            fit: BoxFit.cover, // keeps it nicely cropped
                          ),
                        ),
                      ],
                    ),
                  ),
                  AppSpacing.vxl,
                  Text(
                    textAlign: TextAlign.center,
                    "Create Shorts",
                    style: AppTextStyles.authHeadline,
                  ),
                  Text(
                    textAlign: TextAlign.center,
                    "Express yourself through short-form \n video content and fun filters.",
                    style: AppTextStyles.bodyRegular.copyWith(
                      fontSize: 14.sp,
                    ),
                  ),
                  AppSpacing.hlg,
                  OnboardingDots(currentIndex: 1),
                  SizedBox(height: 50.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      AppButton(
                        width: 132.w,
                        isGhost: true,
                        text: 'Back',
                        onPressed: onBack, // FIXED: use callback
                      ),
                      AppButton(
                        width: 193.w,
                        text: 'Next',
                        onPressed: onNext, // FIXED: use callback
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}