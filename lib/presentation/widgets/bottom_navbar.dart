import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'package:wink_app/core/config/theme/app_colors.dart';

class CustomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabChange;

  const CustomNavBar({super.key, required this.selectedIndex, required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = AppColors.primaryYellow;
    final inactiveColor = isDark ? AppColors.navUnselectedDark : AppColors.navUnselectedLight;
    final bgColor = isDark ? AppColors.navBgDark : AppColors.navBgLight;

    return Container(
      margin: const EdgeInsets.all(10),
      height: 70,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          // GNav Bar (Home, Shorts, Notify, Profile)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: GNav(
              rippleColor: Colors.transparent,
              hoverColor: Colors.transparent,
              gap: 8,
              activeColor: activeColor,
              iconSize: 24,
              tabBackgroundColor: isDark ? AppColors.cardDark : AppColors.primary,
              padding: const EdgeInsets.all(12),
              tabs: [
                GButton(icon: Icons.home, text: 'Home', iconColor: inactiveColor),
                GButton(icon: Icons.play_circle_outline, text: 'Shorts', iconColor: inactiveColor),
                // Spacer for Create (we use FAB)
                GButton(icon: Icons.add, text: 'Create', iconColor: inactiveColor), // Invisible tab for spacing
                GButton(icon: Icons.notifications_none, text: 'Notify', iconColor: inactiveColor),
                GButton(icon: Icons.person_outline, text: 'Profile', iconColor: inactiveColor),
              ],
              // Logic to skip index 2 (Create) in the bar
              selectedIndex: selectedIndex == 2 ? 0 : selectedIndex > 2 ? selectedIndex - 1 : selectedIndex,
              onTabChange: (index) {
                if (index >= 2) index++; // Adjust index because we skipped Create
                onTabChange(index);
              },
            ),
          ),
          // RAISED CREATE BUTTON (Floating)
          Positioned(
            top: -15, // Hangs above
            child: Material(
              color: activeColor,
              elevation: 12,
              shape: const CircleBorder(),
              child: InkWell(
                onTap: () => onTabChange(2), // Trigger Create logic
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  width: 60, height: 60,
                  decoration: BoxDecoration(
                    color: activeColor, shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
                  ),
                  child: Icon(Icons.add, color: isDark ? Colors.black : Colors.white, size: 32),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}