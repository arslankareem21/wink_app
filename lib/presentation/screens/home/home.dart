import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wink_app/presentation/provider/navbar_provider.dart';
import 'package:wink_app/presentation/screens/create/create_bottom_sheet.dart';
import 'package:wink_app/presentation/screens/home/home_screen.dart';
import 'package:wink_app/presentation/screens/notification/notification_screen.dart';
import 'package:wink_app/presentation/screens/profile/profile_screen.dart';
import 'package:wink_app/presentation/screens/shorts/short_feed_screen.dart';
import 'package:wink_app/presentation/widgets/bottom_nav_item.dart';
import 'package:wink_app/presentation/widgets/toogle_theme_button.dart';

import '../../../../core/config/theme/app_colors.dart';


class BottomNavScreen extends ConsumerWidget {
  const BottomNavScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavIndexProvider);

    final screens = [
      const HomeScreen(),
      const ShortsScreen(),
      const SizedBox(),
      const NotificationScreen(),
      const ProfileScreen(),
    ];

    return SafeArea(
      bottom: true,
      child: Scaffold(
        
        body: screens[currentIndex],
      
        bottomNavigationBar: Container(
          margin: EdgeInsets.only(
            left: 20.w,
            right: 20.w,
            bottom: 16.h,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 10.w,
            vertical: 10.h,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
            borderRadius: BorderRadius.circular(24.r),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.shadowDark
                    : AppColors.shadowLight,
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const BottomNavItem(
                icon: Icons.home_rounded,
                label: 'Home',
                index: 0,
              ),
      
              const BottomNavItem(
                icon: Icons.play_circle_fill_rounded,
                label: 'Shorts',
                index: 1,
              ),
      
              /// CREATE BUTTON
              Transform.translate(
                offset: Offset(0, -22.h),
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Theme.of(context).cardColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(28.r),
                        ),
                      ),
                      builder: (_) => const CreateBottomSheet(),
                    );
                  },
                  child: Container(
                    height: 62.h,
                    width: 62.w,
                    decoration: BoxDecoration(
                      color: AppColors.primaryYellow,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryYellow.withOpacity(.35),
                          blurRadius: 20,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.add,
                      size: 34.sp,
                      color: AppColors.secondary,
                    ),
                  ),
                ),
              ),
      
              const BottomNavItem(
                icon: Icons.favorite_rounded,
                label: 'Activity',
                index: 3,
              ),
      
              const BottomNavItem(
                icon: Icons.person_rounded,
                label: 'Profile',
                index: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
