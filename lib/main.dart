<<<<<<< HEAD
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
=======

import 'package:firebase_core/firebase_core.dart';
>>>>>>> 695c57d403544df1debce3b0f216e0e23b4738b1
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wink_app/firebase_options.dart';

import 'app.dart';    

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
<<<<<<< HEAD
 
=======
>>>>>>> 695c57d403544df1debce3b0f216e0e23b4738b1
  runApp(const ProviderScope(child: MyAppRoot()));
}
// ap  kuch  nhi karo 
class MyAppRoot extends StatelessWidget {
  const MyAppRoot({super.key});

  @override
  Widget build(BuildContext context) { 
    return ScreenUtilInit(
      designSize: const Size(390, 884),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return const App();
      },
    );
  }
}