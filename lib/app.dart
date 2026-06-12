import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wink_app/core/config/routes/app_routes.dart';
import 'package:wink_app/core/config/theme/app_theme.dart';
import 'package:wink_app/presentation/screens/auth/forget_password_screen.dart';
import 'package:wink_app/presentation/screens/splash/splash_screen.dart';
import 'package:wink_app/presentation/widgets/app_snackbar.dart';

import 'package:wink_app/viewmodels/theme_viewmodel.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      
      themeMode: themeMode,
      scaffoldMessengerKey: AppSnackBar.messengerKey,
      routerConfig: AppRouter.router,
      
    );
  }
}