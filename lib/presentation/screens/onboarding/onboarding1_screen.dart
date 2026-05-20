import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wink_app/core/config/theme/app_spacing.dart';
import 'package:wink_app/core/config/theme/app_text_style.dart';
import 'package:wink_app/presentation/components/onboarding/onboarding_indicator.dart';
import 'package:wink_app/presentation/widgets/elevated_button.dart';
import 'package:wink_app/presentation/widgets/toogle_theme_button.dart';

class Onboarding1Screen extends StatelessWidget {
  final VoidCallback onNext;
  const Onboarding1Screen({super.key, required this.onNext});

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
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
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
                          SizedBox(height: 26.h),
                          Image.asset(
                            alignment: Alignment.bottomCenter,
                            "assets/image/onboarding1_record.png",
                            height: 340,
                            width: 342,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      textAlign: TextAlign.center,
                      "Share your moments",
                      style: AppTextStyles.authHeadline,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      textAlign: TextAlign.center,
                      "Connect with friends and share your best \n moments through short videos and photos.",
                      style: AppTextStyles.bodyRegular.copyWith(
                        fontSize: 14.sp,
                      ),
                    ),
                    AppSpacing.hlg,
                    OnboardingDots(currentIndex: 0),
                    SizedBox(height: 50.h),
                    AppButton(
                      text: 'Next',
                      onPressed: onNext, // FIXED: use callback
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}