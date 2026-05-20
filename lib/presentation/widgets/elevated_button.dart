import 'package:flutter/material.dart';
import 'package:wink_app/core/config/theme/app_colors.dart';
import 'package:wink_app/core/config/theme/app_spacing.dart';
import 'package:wink_app/core/config/theme/app_text_style.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor; // new
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final bool isOutlined;
  final bool isGhost; // new - transparent bg with border
  final bool isLoading;
  final double loaderSize;
  final Widget? icon;
  final double? height;
  final double iconSpacing;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.borderRadius,
    this.padding,
    this.width,
    this.isOutlined = false,
    this.isGhost = false, // new
    this.isLoading = false,
    this.loaderSize = 20,
    this.icon,
    this.height,
    this.iconSpacing = AppSpacing.sm,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final double radius = borderRadius ?? 30;
    final EdgeInsetsGeometry effectivePadding = padding ?? AppSpacing.buttonPadding;

    // Ghost style: transparent bg, theme-based border/text
    Color? effectiveBg = backgroundColor;
    Color? effectiveFg = textColor;
    BorderSide? side;

    if (isGhost) {
      effectiveBg = backgroundColor ?? Colors.transparent;
      effectiveFg = textColor ?? (isDark ? AppColors.white : AppColors.black);
      side = BorderSide(
        color: borderColor ?? (isDark ? AppColors.white : AppColors.black),
        width: 1.5,
      );
    } else if (isOutlined) {
      side = BorderSide(
        color: borderColor ?? AppColors.outlinedButtonBorder,
      );
    }

    final buttonStyle = isOutlined || isGhost
        ? OutlinedButton.styleFrom(
            backgroundColor: effectiveBg,
            foregroundColor: effectiveFg,
            disabledForegroundColor: effectiveFg?.withOpacity(0.5),
            disabledBackgroundColor: effectiveBg?.withOpacity(0.5),
            padding: effectivePadding,
            side: side,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
            ),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ).merge(theme.outlinedButtonTheme.style)
        : ElevatedButton.styleFrom(
            backgroundColor: effectiveBg,
            foregroundColor: effectiveFg,
            disabledBackgroundColor: effectiveBg?.withOpacity(0.6),
            disabledForegroundColor: effectiveFg?.withOpacity(0.6),
            padding: effectivePadding,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
              side: side ?? BorderSide.none, // for ghost on elevated
            ),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ).merge(theme.elevatedButtonTheme.style);

    Widget buttonChild;
    
    if (isLoading) {
      buttonChild = SizedBox(
        height: loaderSize,
        width: loaderSize,
        child: const CircularProgressIndicator(strokeWidth: 2.5),
      );
    } else {
      final textWidget = Text(
        text,
        style: AppTextStyles.buttonPrimary,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
      
      buttonChild = icon != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon!,
                SizedBox(width: iconSpacing),
                Flexible(child: textWidget),
              ],
            )
          : textWidget;
    }

    final button = isOutlined
        ? OutlinedButton(
            onPressed: isLoading ? null : onPressed,
            style: buttonStyle, 
            child: Center(child: buttonChild),
          )
        : ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: buttonStyle, 
            child: Center(child: buttonChild),
          );

    return SizedBox(
      width: width,
      height: height,
      child: button,
    );
  }
}