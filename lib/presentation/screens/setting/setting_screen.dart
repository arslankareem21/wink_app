// presentation/screens/settings/settings_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wink_app/core/config/theme/app_colors.dart';
import 'package:wink_app/core/config/theme/app_spacing.dart';
import 'package:wink_app/core/config/theme/app_text_style.dart';
import 'package:wink_app/presentation/components/setting/premium_banner.dart';
import 'package:wink_app/presentation/components/setting/setting_list_item.dart';

import 'package:wink_app/presentation/screens/auth/forget_password_screen.dart';
import 'package:wink_app/presentation/screens/auth/login_screen.dart';
import 'package:wink_app/presentation/screens/auth/signup-screen.dart';
import 'package:wink_app/presentation/screens/home/home_screen.dart';
import 'package:wink_app/presentation/screens/profile/profile_screen.dart';
import 'package:wink_app/presentation/widgets/circle_avatar.dart';
import 'package:wink_app/presentation/widgets/elevated_button.dart';
import 'package:wink_app/presentation/widgets/toogle_theme_button.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Profile Data
    const String name = '  Allex Rivera';
    const String username = '@alex_creative_vibe';
    const String profileImage = 'https://picsum.photos/200/200?random=1';

    return Scaffold(
      // Custom Header
      appBar: AppBar(
        title: Text(
          'Settings',
          style: AppTextStyles.appBarTitle,
          //   TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
          // ),
        ),
        leading: Padding(
          padding: AppSpacing.buttonPadding,
          child: IconButton(
            icon: Icon(Icons.arrow_back, size: 20.sp),
            onPressed: () => Navigator.pop(context),
            //() => Navigator.pop(context),
          ),
        ),
        actions: [
          Padding(
            padding: AppSpacing.buttonPadding.copyWith(right: 0),
            child: ThemeToggleButton(),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppSpacing.vlg,

            // Profile Section
            AppProfileAvatar(size: 150.r, borderColor: AppColors.primaryYellow),

            AppSpacing.vxxl,
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("PERSONAL SETTINGS", style: AppTextStyles.bodyRegular),
                  AppSpacing.vxs,
                  Container(
                    height: 215.h,
                    width: 300.w,
                    decoration: BoxDecoration(
                      color: AppColors.appBarTextDark,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        AppSpacing.vsm,
                        SettingsRow(
                          Icons.person_outlined,
                          'Account',
                          AppColors.primaryYellow,
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ),
                            );
                          },
                        ),
                        Divider(color: AppColors.border),
                        SettingsRow(
                          Icons.lock_outlined,
                          'Privacy',
                          AppColors.info,
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignUpScreen(),
                              ),
                            );
                          },
                        ),
                        Divider(color: AppColors.border),

                        SettingsRow(
                          Icons.notifications_outlined,
                          'Notifications',
                          Colors.orange,
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ForgetPasswordScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  AppSpacing.vxxl,

                  Text("SUPPORT", style: AppTextStyles.bodyRegular),
                  Container(
                    height: 140.h,
                    width: 300.w,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SettingsRow(
                          Icons.help_center_outlined,
                          'Help Center',
                          Colors.green,
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeScreen(),
                              ),
                            );
                          },
                        ),
                        Divider(color: AppColors.border),
                        SettingsRow(
                          Icons.info_outline,
                          'About',
                          Colors.purple,
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfileScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            AppSpacing.vxxl,

            ///Premium Banner
            PremiumBanner(
              onTap: () {
                // Navigate to premium subscription
              },
            ),

            AppSpacing.vxxl,

            AppButton(
              text: 'Logout',
              textColor: AppColors.error,
              width: 240.w,
              onPressed: () {
                // Handle logout
              },
              icon: Icon(Icons.logout, color: AppColors.error, size: 18.sp),
              isGhost: true,
            ),
            AppSpacing.vxxl,
          ],
        ),
      ),
    );
  }
}