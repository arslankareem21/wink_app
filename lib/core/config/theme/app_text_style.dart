import 'package:flutter/material.dart';

class AppTextStyles {
  

  static const String fontFamily = 'Lexend';

  /// ================================
  /// DISPLAY (ONBOARDING / BIG TEXT)
  /// ================================
  static TextStyle display(BuildContext context) {
    return Theme.of(context).textTheme.displaySmall!.copyWith(
          fontFamily: fontFamily,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
          color: Theme.of(context).colorScheme.onSurface,
        );
  }

  /// ================================
  /// HEADINGS
  /// ================================
  static TextStyle h1(BuildContext context) {
    return Theme.of(context).textTheme.headlineLarge!.copyWith(
          fontFamily: fontFamily,
          fontWeight: FontWeight.w700,
          height: 1.2,
          color: Theme.of(context).colorScheme.onSurface,
        );
  }

  static TextStyle h2(BuildContext context) {
    return Theme.of(context).textTheme.headlineMedium!.copyWith(
          fontFamily: fontFamily,
          fontWeight: FontWeight.w600,
          height: 1.3,
          color: Theme.of(context).colorScheme.onSurface,
        );
  }

  static TextStyle h3(BuildContext context) {
    return Theme.of(context).textTheme.titleLarge!.copyWith(
          fontFamily: fontFamily,
          fontWeight: FontWeight.w600,
          height: 1.3,
          color: Theme.of(context).colorScheme.onSurface,
        );
  }

  /// ================================
  /// BODY
  /// ================================
  static TextStyle body(BuildContext context) {
    return Theme.of(context).textTheme.bodyLarge!.copyWith(
          fontFamily: fontFamily,
          height: 1.5,
          color: Theme.of(context).colorScheme.onSurface,
        );
  }

  static TextStyle bodySmall(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
          fontFamily: fontFamily,
          height: 1.4,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
        );
  }

  static TextStyle caption(BuildContext context) {
    return Theme.of(context).textTheme.bodySmall!.copyWith(
          fontFamily: fontFamily,
          height: 1.3,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
        );
  }

  /// ================================
  /// BUTTON
  /// ================================
  static TextStyle button(BuildContext context) {
    return Theme.of(context).textTheme.labelLarge!.copyWith(
          fontFamily: fontFamily,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
          color: Theme.of(context).colorScheme.onPrimary,
        );
  }

  /// ================================
  /// INPUT
  /// ================================
  static TextStyle input(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
          fontFamily: fontFamily,
          color: Theme.of(context).colorScheme.onSurface,
        );
  }

  static TextStyle hint(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
          fontFamily: fontFamily,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
        );
  }

  /// ================================
  /// SOCIAL (FEED UI)
  /// ================================
  static TextStyle username(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
          fontFamily: fontFamily,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onSurface,
        );
  }

  static TextStyle postCaption(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
          fontFamily: fontFamily,
          height: 1.4,
          color: Theme.of(context).colorScheme.onSurface,
        );
  }

  static TextStyle stats(BuildContext context) {
    return Theme.of(context).textTheme.labelMedium!.copyWith(
          fontFamily: fontFamily,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.onSurface,
        );
  }

  static TextStyle time(BuildContext context) {
    return Theme.of(context).textTheme.bodySmall!.copyWith(
          fontFamily: fontFamily,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
        );
  }
}