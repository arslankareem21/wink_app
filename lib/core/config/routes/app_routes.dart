import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wink_app/core/config/routes/route_names.dart';
import 'package:wink_app/presentation/screens/auth/login_screen.dart';
import 'package:wink_app/presentation/screens/auth/forget_password_screen.dart';
import 'package:wink_app/presentation/screens/auth/signup-screen.dart';
import 'package:wink_app/presentation/screens/home/bottom_nav_bar.dart';
import 'package:wink_app/presentation/screens/splash/splash_screen.dart';


class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.signup,
        name: 'signup',
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        name: 'forgotPassword',
        builder: (context, state) => const ForgetPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) => const BottomNavScreen(),
      ),
    ],
  );
}