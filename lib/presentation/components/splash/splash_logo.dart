import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wink_app/core/config/theme/app_colors.dart';
import 'package:wink_app/core/config/theme/app_text_style.dart';

class SplashLogo extends StatelessWidget {
  const SplashLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.contain, // important
      child: SizedBox(
          // base design width (adjust once)
        height: 100, // base design height
        child: Row(
          // keeps text + logo aligned
          children: [
            SvgPicture.asset(
              "assets/icon/logo.svg",
              width: 90,
              height: 90,
            ),
            const SizedBox(width: 5),
            Align(
              alignment: Alignment.bottomLeft, // aligns 
              child: Text(
                "Wink",
                style: AppTextStyles.onboardingHeadline.copyWith(
                  fontSize: 52, // fixed base size
                  fontWeight: FontWeight.w900,
                  color: AppColors.primaryYellow,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}