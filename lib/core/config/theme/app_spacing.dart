import 'package:flutter/widgets.dart';

class AppSpacing {


  /// BASE UNIT = 4
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;

  /// PADDING PRESETS
  static const EdgeInsets screenPadding =
      EdgeInsets.symmetric(horizontal: lg);

  static const EdgeInsets cardPadding =
      EdgeInsets.all(lg);

  static const EdgeInsets buttonPadding =
      EdgeInsets.symmetric(vertical: md);

  /// GAP HELPERS
  static const SizedBox vxs = SizedBox(height: xs);
  static const SizedBox vsm = SizedBox(height: sm);
  static const SizedBox vmd = SizedBox(height: md);
  static const SizedBox vlg = SizedBox(height: lg);
  static const SizedBox vxl = SizedBox(height: xl);
  static const SizedBox vxxl = SizedBox(height: xxl);

  static const SizedBox hxs = SizedBox(width: xs);
  static const SizedBox hsm = SizedBox(width: sm);
  static const SizedBox hmd = SizedBox(width: md);
  static const SizedBox hlg = SizedBox(width: lg);
}