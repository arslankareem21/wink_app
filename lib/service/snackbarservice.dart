import 'package:flutter/material.dart';

enum SnackType { success, error, info }

class SnackbarService {
  static final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static void show(
    String message, {
    SnackType type = SnackType.info,
  }) {
    final color = switch (type) {
      SnackType.success => Colors.green,
      SnackType.error => Colors.red,
      SnackType.info => Colors.blue,
    };

    messengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  static void success(String message) =>
      show(message, type: SnackType.success);

  static void error(String message) =>
      show(message, type: SnackType.error);

  static void info(String message) =>
      show(message, type: SnackType.info);
}