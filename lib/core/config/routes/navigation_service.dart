import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationService {
  NavigationService._();

  /// Open new page
  static Future<T?> push<T>(
    BuildContext context,
    String route,
  ) {
    return context.push<T>(route);
  }

  /// Replace current page
  static void replace(
    BuildContext context,
    String route,
  ) {
    context.replace(route);
  }

  /// Clear stack and go
  static void go(
    BuildContext context,
    String route,
  ) {
    context.go(route);
  }

  /// Back
  static void pop<T>(
    BuildContext context, [
    T? result,
  ]) {
    if (context.canPop()) {
      context.pop(result);
    }
  }

  /// Can Pop
  static bool canPop(
    BuildContext context,
  ) {
    return context.canPop();
  }
}