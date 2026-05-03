import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeViewModel extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    // default theme
    return ThemeMode.light;
  }

  /// Toggle between light and dark
  void toggleTheme() {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }

  /// Set explicitly
  void setLight() => state = ThemeMode.light;

  void setDark() => state = ThemeMode.dark;

  void setSystem() => state = ThemeMode.system;
}

final themeProvider =
    NotifierProvider<ThemeViewModel, ThemeMode>(ThemeViewModel.new);