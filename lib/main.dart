import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app.dart';    

void main() {
  runApp(const ProviderScope(child: MyAppRoot()));
}

class MyAppRoot extends StatelessWidget {
  const MyAppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // 👈 change if your Figma differs
      minTextAdapt: true,
      
      splitScreenMode: true,
      builder: (context, child) {
        return const App();
      },
    );
  }
}