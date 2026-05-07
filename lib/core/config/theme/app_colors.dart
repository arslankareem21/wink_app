import 'package:flutter/material.dart';

class AppColors {
  

  /// ==========================================================
  /// CORE BRAND COLORS
  /// ==========================================================

  /// Main Light Theme Background Color
  static const Color primary = Color(0xFFFCF3E1);

  /// Main Dark Theme Background Color
  static const Color secondary = Color(0xFF000000);

  /// Accent Color (Same in Light + Dark)
  static const Color primaryYellow = Color(0xFFF5C518);

  /// ==========================================================
  /// BASIC COLORS
  /// ==========================================================

  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  static const Color transparent = Colors.transparent;

  /// ==========================================================
  /// GREYSCALE
  /// ==========================================================

  static const Color grey = Color(0xFFE2DFDD);
  static const Color greyDark = Color(0xFFBDBDBD);
  static const Color greyText = Color(0xFF9E9E9E);

  /// ==========================================================
  /// TEXT COLORS - LIGHT THEME
  /// ==========================================================

  static const Color titleLight = secondary; // black
  static const Color headingLight = secondary;
  static const Color bodyLight = Color(0xFF5F5E5D);
  static const Color subtitleLight = Color(0xFF4E4633);
  static const Color hintLight = Color(0xFF8A8170);

  /// ==========================================================
  /// TEXT COLORS - DARK THEME
  /// ==========================================================

  static const Color titleDark = white;
  static const Color headingDark = white;
  static const Color bodyDark = Color(0xFFBDBDBD);
  static const Color subtitleDark = Color(0xFF9E9E9E);
  static const Color hintDark = Color(0xFF7A7A7A);

  /// ==========================================================
  /// CARD COLORS
  /// ==========================================================

  static const Color cardLight = white;
  static const Color cardDark = Color(0xFF1A1A1A);

  /// ==========================================================
  /// BORDER COLORS
  /// ==========================================================

  static const Color border = Color(0xFFD1C5AC);
  static const Color borderDark = Color(0xFF333333);

  /// ==========================================================
  /// TEXTFIELD COLORS
  /// ==========================================================

  /// Same fill color for both themes
  static const Color textFieldColor = Color(0xFFFCF3E1);

  static const Color textFieldTextLight = secondary;
  static const Color textFieldTextDark = secondary;

  /// ==========================================================
  /// BUTTON COLORS
  /// ==========================================================

  static const Color buttonBg = primaryYellow;

  static const Color buttonTextLight = secondary;
  static const Color buttonTextDark = white;

  static const Color outlinedButtonBorder = border;

  /// ==========================================================
  /// ICON COLORS
  /// ==========================================================

  static const Color iconLight = secondary;
  static const Color iconDark = white;

  static const Color iconSelectedLight = secondary;
  static const Color iconSelectedDark = white;

  static const Color iconAccent = primaryYellow;

  /// ==========================================================
  /// BOTTOM NAVIGATION BAR
  /// ==========================================================

  static const Color navBgLight = white;
  static const Color navBgDark = secondary;

  static const Color navSelectedBg = primaryYellow;

  static const Color navUnselectedLight = bodyLight;
  static const Color navUnselectedDark = bodyDark;

  static const Color navSelectedIconLight = secondary;
  static const Color navSelectedIconDark = white;

  /// ==========================================================
  /// APPBAR
  /// ==========================================================

  static const Color appBarLight = primary;
  static const Color appBarDark = secondary;

  static const Color appBarTextLight = secondary;
  static const Color appBarTextDark = white;

  /// ==========================================================
  /// CHIP COLORS
  /// ==========================================================

  static const Color chipBgLight = white;
  static const Color chipBgDark = cardDark;

  static const Color chipSelected = primaryYellow;

  static const Color chipTextLight = secondary;
  static const Color chipTextDark = white;

  /// ==========================================================
  /// TAB BAR
  /// ==========================================================

  static const Color tabIndicator = primaryYellow;

  static const Color tabLabelLight = secondary;
  static const Color tabLabelDark = white;

  static const Color tabUnselectedLight = bodyLight;
  static const Color tabUnselectedDark = bodyDark;

  /// ==========================================================
  /// DIALOG COLORS
  /// ==========================================================

  static const Color dialogBgLight = white;
  static const Color dialogBgDark = cardDark;

  static const Color dialogTitleLight = secondary;
  static const Color dialogTitleDark = white;

  static const Color dialogBodyLight = bodyLight;
  static const Color dialogBodyDark = bodyDark;

  /// ==========================================================
  /// SNACKBAR
  /// ==========================================================

  static const Color snackBarLight = secondary;
  static const Color snackBarDark = cardDark;

  static const Color snackBarText = white;

  /// ==========================================================
  /// STATUS COLORS
  /// ==========================================================

  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  /// ==========================================================
  /// SHADOW
  /// ==========================================================

  static Color shadowLight = Colors.black.withOpacity(0.06);
  static Color shadowDark = Colors.black.withOpacity(0.30);
}