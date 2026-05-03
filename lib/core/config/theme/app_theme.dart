import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  /// ==========================================================
  /// LIGHT THEME
  /// ==========================================================
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    scaffoldBackgroundColor: AppColors.primary,
    primaryColor: AppColors.primaryYellow,

    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryYellow,
      secondary: AppColors.primaryYellow,
      surface: AppColors.primary,
      error: AppColors.error,
      onPrimary: AppColors.secondary,
      onSecondary: AppColors.secondary,
      onSurface: AppColors.secondary,
      onError: AppColors.white,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.appBarLight,
      foregroundColor: AppColors.appBarTextLight,
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      iconTheme: IconThemeData(
        color: AppColors.iconLight,
      ),
    ),

    iconTheme: const IconThemeData(
      color: AppColors.iconLight,
    ),

    

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.buttonBg,
        foregroundColor: AppColors.buttonTextLight,
        elevation: 0,
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.buttonTextLight,
        side: const BorderSide(
          color: AppColors.outlinedButtonBorder,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.buttonTextLight,
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.textFieldColor,

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: AppColors.border,
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: AppColors.primaryYellow,
          width: 1.5,
        ),
      ),
    ),

    chipTheme: ChipThemeData(
      backgroundColor: AppColors.chipBgLight,
      selectedColor: AppColors.primaryYellow,
      disabledColor: AppColors.grey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
    ),

    tabBarTheme: const TabBarThemeData(
      labelColor: AppColors.tabLabelLight,
      unselectedLabelColor: AppColors.tabUnselectedLight,
      indicatorColor: AppColors.primaryYellow,
    ),

    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.dialogBgLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),

    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.snackBarLight,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.navBgLight,
      selectedItemColor: AppColors.navSelectedIconLight,
      unselectedItemColor: AppColors.navUnselectedLight,
      type: BottomNavigationBarType.fixed,
    ),
  );

  /// ==========================================================
  /// DARK THEME
  /// ==========================================================
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    scaffoldBackgroundColor: AppColors.secondary,
    primaryColor: AppColors.primaryYellow,

    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryYellow,
      secondary: AppColors.primaryYellow,
      surface: AppColors.secondary,
      error: AppColors.error,
      onPrimary: AppColors.white,
      onSecondary: AppColors.white,
      onSurface: AppColors.white,
      onError: AppColors.white,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.appBarDark,
      foregroundColor: AppColors.appBarTextDark,
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      iconTheme: IconThemeData(
        color: AppColors.iconDark,
      ),
    ),

    iconTheme: const IconThemeData(
      color: AppColors.iconDark,
    ),

    cardTheme: CardThemeData(
  color: AppColors.cardDark,
  elevation: 0,
  margin: EdgeInsets.zero,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
  ),
),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.buttonBg,
        foregroundColor: AppColors.buttonTextDark,
        elevation: 0,
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.white,
        side: const BorderSide(
          color: AppColors.borderDark,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.white,
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.textFieldColor,

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: AppColors.borderDark,
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: AppColors.primaryYellow,
          width: 1.5,
        ),
      ),
    ),

    chipTheme: ChipThemeData(
      backgroundColor: AppColors.chipBgDark,
      selectedColor: AppColors.primaryYellow,
      disabledColor: AppColors.greyDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
    ),

    tabBarTheme: const TabBarThemeData(
      labelColor: AppColors.tabLabelDark,
      unselectedLabelColor: AppColors.tabUnselectedDark,
      indicatorColor: AppColors.primaryYellow,
    ),

    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.dialogBgDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),

    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.snackBarDark,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.navBgDark,
      selectedItemColor: AppColors.navSelectedIconDark,
      unselectedItemColor: AppColors.navUnselectedDark,
      type: BottomNavigationBarType.fixed,
    ),
  );
}