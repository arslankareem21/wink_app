import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wink_app/presentation/provider/navbar_provider.dart';

import '../../../../core/config/theme/app_colors.dart';


class BottomNavItem extends ConsumerWidget {
  final IconData icon;
  final String label;
  final int index;

  const BottomNavItem({
    super.key,
    required this.icon,
    required this.label,
    required this.index,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavIndexProvider);

    final isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () {
        ref.read(bottomNavIndexProvider.notifier).state = index;
      },
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            height: isSelected ? 42.h : 38.h,
            width: isSelected ? 42.w : 38.w,
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primaryYellow
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(
              icon,
              size: isSelected ? 24.sp : 22.sp,
              color: isSelected
                  ? Theme.of(context)
                      .bottomNavigationBarTheme
                      .selectedIconTheme
                      ?.color
                  : Theme.of(context)
                      .bottomNavigationBarTheme
                      .unselectedIconTheme
                      ?.color,
            ),
          ),

          SizedBox(height: 4.h),

          Text(
            label,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
              
            ),
          ),
        ],
      ),
    );
  }
}