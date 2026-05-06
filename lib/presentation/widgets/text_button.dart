import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wink_app/core/config/theme/app_text_style.dart';

class AppTextButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final AlignmentGeometry alignment;
  final TextAlign? textAlign;
  final ButtonStyle? style;
  final TextStyle? textStyle;

  const AppTextButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width,
    this.height,
    this.alignment = Alignment.center,
    this.textAlign,
    this.style,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Default style follows theme, only override what you pass
    final defaultButtonStyle = TextButton.styleFrom(
      padding: EdgeInsets.symmetric(
        horizontal: 12.w,
        vertical: 8.h,
      ),
      alignment: alignment,
      // foregroundColor: not set → uses Theme.textButtonTheme or colorScheme.primary
    );

    return SizedBox(
      width: width,
      height: height?.h,
      child: TextButton(
        onPressed: onPressed,
        style: defaultButtonStyle.merge(style), // merge = theme + your overrides
        child: Text(
          text,
          textAlign: textAlign,
          style: textStyle, // null → uses theme textTheme.labelLarge
        ),
      ),
    );
  }
}