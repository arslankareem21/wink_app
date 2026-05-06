import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wink_app/core/config/theme/app_colors.dart';
import 'package:wink_app/core/config/theme/app_spacing.dart';
import 'package:wink_app/presentation/components/onboarding/onboarding_wrapper.dart';
import 'package:wink_app/presentation/components/splash/splash_loading_indicator.dart';
import 'package:wink_app/presentation/components/splash/splash_logo.dart';
import 'package:wink_app/presentation/screens/onboarding/onboarding1_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    /// ✅ run once AFTER first frame (no build loop)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigate();
    });
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const OnboardingWrapper(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: SafeArea(
        
        child: Padding(
          padding: AppSpacing.screenPadding,
          
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: SizedBox(
                    height: 100.h,
                    child: SplashLogo()),
                ),
              ),
          
              const SplashLoadingIndicator(),
          
              AppSpacing.vxl,
            ],
          ),
        ),
      ),
    );
  }
}