import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wink_app/core/config/theme/app_theme.dart';
import 'package:wink_app/presentation/screens/auth/login_screen.dart';
import 'package:wink_app/presentation/screens/auth/signup-screen.dart';
import 'package:wink_app/presentation/screens/splash/splash_screen.dart';
import 'package:wink_app/viewmodels/theme_viewmodel.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: const LoginScreen(),
    );
  }
}