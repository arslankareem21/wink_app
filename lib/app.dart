import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wink_app/core/config/theme/app_theme.dart';
<<<<<<< HEAD
import 'package:wink_app/presentation/screens/auth/login_screen.dart';
import 'package:wink_app/presentation/screens/auth/signup-screen.dart';
import 'package:wink_app/presentation/screens/splash/splash_screen.dart';
=======
import 'package:wink_app/presentation/screens/auth/google_sign_in_screen.dart';
import 'package:wink_app/presentation/screens/auth/signup-screen.dart';
>>>>>>> 695c57d403544df1debce3b0f216e0e23b4738b1
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
<<<<<<< HEAD
      home: const SplashScreen(),
=======
      home: const
      
    //  GoogleSignInScreen()
      SignUpScreen()
     // ProfileScreen()
      // EditProfileScreen()
      //SettingsScreen()
     // SettingsScreen(),
>>>>>>> 695c57d403544df1debce3b0f216e0e23b4738b1
    );
  }
}