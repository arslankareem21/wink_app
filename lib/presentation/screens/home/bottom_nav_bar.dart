import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wink_app/presentation/provider/navbar_provider.dart';
import 'package:wink_app/presentation/screens/create/create_bottom_sheet.dart';
import 'package:wink_app/presentation/screens/home/home_screen.dart';
import 'package:wink_app/presentation/screens/notification/notification_screen.dart';
import 'package:wink_app/presentation/screens/profile/profile_screen.dart';
import 'package:wink_app/presentation/screens/reels/reels_page.dart';
import '../../../../core/config/theme/app_colors.dart';

class BottomNavScreen extends ConsumerWidget {
  const BottomNavScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavIndexProvider);
    final navTheme = Theme.of(context).bottomNavigationBarTheme;

    final screens = [
      HomeScreen(),
      const ReelPage(),
      const NotificationScreen(),
      const ProfileScreen(),
    ];

    return SafeArea(
      top: false,
      child: Scaffold(
        body: screens[currentIndex],
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              backgroundColor: Theme.of(context).cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
              ),
              builder: (_) => const CreateBottomSheet(),
            );
          },
          backgroundColor: AppColors.primaryYellow,
          foregroundColor: AppColors.secondary,
          elevation: 8,
          shape: const CircleBorder(),
          child: const Icon(Icons.add_rounded, size: 30),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: Container(
          // margin: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 16.h),
          // padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: navTheme.backgroundColor,
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
          child: NavigationBar(
            height: 72.h,
            backgroundColor: Colors.transparent,
            elevation: 0,
            indicatorColor: AppColors.primaryYellow.withValues(alpha: 0.16),
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            selectedIndex: currentIndex,
            onDestinationSelected: (index) {
              ref.read(bottomNavIndexProvider.notifier).state = index;
            },
            destinations: [
              NavigationDestination(
                icon: Icon(
                  Icons.home_outlined,
                  color: navTheme.unselectedItemColor,
                ),
                selectedIcon: Icon(
                  Icons.home_rounded,
                  color: navTheme.selectedItemColor,
                ),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.play_circle_outline_rounded,
                  color: navTheme.unselectedItemColor,
                ),
                selectedIcon: Icon(
                  Icons.play_circle_fill_rounded,
                  color: navTheme.selectedItemColor,
                ),
                label: 'Shorts',
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.favorite_border_rounded,
                  color: navTheme.unselectedItemColor,
                ),
                selectedIcon: Icon(
                  Icons.favorite_rounded,
                  color: navTheme.selectedItemColor,
                ),
                label: 'Activity',
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.person_outline_rounded,
                  color: navTheme.unselectedItemColor,
                ),
                selectedIcon: Icon(
                  Icons.person_rounded,
                  color: navTheme.selectedItemColor,
                ),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
