import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wink_app/core/config/routes/navigation_service.dart';
import 'package:wink_app/core/config/routes/route_names.dart';

import 'package:wink_app/core/config/theme/app_spacing.dart';
import 'package:wink_app/core/handler/auth_handler.dart';
import 'package:wink_app/presentation/components/splash/splash_loading_indicator.dart';
import 'package:wink_app/presentation/components/splash/splash_logo.dart';

import '../../../service/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // AuthHandler.instance.init

    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await AuthHandler.ref.init();
    //  print("Islogin : ");
    //  bool islogin =await AuthHandler.ref.isLoggedIn();
    if (await AuthHandler.ref.isLoggedIn) {
      if (!mounted) return;
      NavigationService.go(context, AppRoutes.home);
      // home screen
    } else {
      // login screen
      if (!mounted) return;
      NavigationService.go(context, AppRoutes.login);
    }

    //     if (!mounted) return;

    //     final user =  FirebaseAuth.instance.currentUser;

    //     await Future.delayed(const Duration(seconds: 2)); // splash delay

    //     if (user == null) {
    //       print("Islogin : ");
    //       NavigationService.go(context, AppRoutes.login);
    //       return;
    //     }

    //     // Check if Google user needs password setup
    //     final needsSetup = await AuthRepository().needsPasswordSetup();
    //     if (needsSetup) {
    //       await AuthRepository().signOut();
    //       if (!mounted) return;
    //       NavigationService.go(context, AppRoutes.login);
    //       return;
    //     }
    // if (!mounted) return;
    //     NavigationService.go(context, AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: SizedBox(height: 100.h, child: const SplashLogo()),
                ),
              ),
              const SplashLoadingIndicator(),
              AppSpacing.vxl,
            ],
          ),
        ),
      ),
    );
  }
}
