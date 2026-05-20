import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppSpacing {
  /// BASE UNIT = 4
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;

  /// PADDING PRESETS - use getters
  static EdgeInsets get screenPadding => EdgeInsets.symmetric(horizontal: lg.w);
  static EdgeInsets get cardPadding => EdgeInsets.symmetric(horizontal: xl.w, vertical: xl.w);
  static EdgeInsets get buttonPadding => EdgeInsets.symmetric(vertical: md.h);

  /// GAP HELPERS - use getters
  static SizedBox get vxs => SizedBox(height: xs.h);
  static SizedBox get vsm => SizedBox(height: sm.h);
  static SizedBox get vmd => SizedBox(height: md.h);
  static SizedBox get vlg => SizedBox(height: lg.h);
  static SizedBox get vxl => SizedBox(height: xl.h);
  static SizedBox get vxxl => SizedBox(height: xxl.h);
  static SizedBox get vxxxl => SizedBox(height: xxxl.h);


  static SizedBox get hxs => SizedBox(width: xs.w);
  static SizedBox get hsm => SizedBox(width: sm.w);
  static SizedBox get hmd => SizedBox(width: md.w);
  static SizedBox get hlg => SizedBox(width: lg.w);
  static SizedBox get hxl => SizedBox(width: xl.w);
  static SizedBox get hxxl => SizedBox(width: xxl.w);
  static SizedBox get hxxxl => SizedBox(width: xxxl.w);
}