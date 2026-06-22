import 'package:flutter/material.dart';

class AppSnackBar {
  static final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static void show( String message, {bool isError = false, SnackBarAction? action}) {
    messengerKey.currentState?.removeCurrentSnackBar();
    messengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red.shade600 : Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        action: action,
        duration: Duration(seconds: action != null ? 6 : 3),
      ),
    );
  }
}