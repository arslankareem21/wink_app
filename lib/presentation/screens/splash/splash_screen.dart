import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wink_app/core/config/theme/app_colors.dart';
import 'package:wink_app/core/config/theme/app_spacing.dart';
import 'package:wink_app/core/config/theme/app_text_style.dart';
import 'package:wink_app/presentation/widgets/toogle_theme_button.dart';


class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _scaleAnimation = Tween<double>(
      begin: .92,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _controller.forward();

    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    /// Navigate here
    /// context.go('/home');
    /// Navigator.pushReplacement(...)
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            children: [
              const Spacer(flex: 4),
              ThemeToggleButton(),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                            
                  SizedBox(width: 8.w),
                            
                  Text(
                    "Wink",
                    style:
                        AppTextStyles.h1(context).copyWith(
                      fontSize: 34.sp,
                      //color: AppColors.warning,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                    ),
                  ),
                  Text(
                    "Wink",
                    style:
                        AppTextStyles.h1(context).copyWith(
                      fontSize: 34.sp,
                      color: AppColors.primaryYellow,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  Text(
                    "Wink",
                    style:
                        AppTextStyles.h1(context).copyWith(
                      fontSize: 34.sp,
                      color: AppColors.warning,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),

              const Spacer(flex: 3),

              /// ===========================
              /// LOADING
              /// ===========================
              Column(
                children: [
                  SizedBox(
                    width: 36.w,
                    child: LinearProgressIndicator(
                      minHeight: 3.h,
                      backgroundColor:
                          AppColors.primaryYellow
                              .withOpacity(.20),
                      valueColor:
                          const AlwaysStoppedAnimation(
                        AppColors.primaryYellow,
                      ),
                    ),
                  ),

                  SizedBox(height: 10.h),

                  Text(
                    "LOADING",
                    style: AppTextStyles.caption(context)
                        .copyWith(
                      fontSize: 10.sp,
                      letterSpacing: 2.5,
                      fontWeight: FontWeight.w600,
                      
                    ),
                  ),
                ],
              ),

              const Spacer(flex: 4),
            ],
          ),
        ),
      ),
    );
  }
}