import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wink_app/core/config/routes/route_names.dart';
import 'package:wink_app/models/story_model.dart';
import 'package:wink_app/presentation/screens/auth/login_screen.dart';
import 'package:wink_app/presentation/screens/auth/forget_password_screen.dart';
import 'package:wink_app/presentation/screens/auth/signup-screen.dart';
import 'package:wink_app/presentation/screens/create/story/create_story.dart';
import 'package:wink_app/presentation/screens/home/bottom_nav_bar.dart';
import 'package:wink_app/presentation/screens/profile/edit_profile.dart';
import 'package:wink_app/presentation/screens/profile/profile_screen.dart';
import 'package:wink_app/presentation/screens/reels/reels_page.dart';
import 'package:wink_app/presentation/screens/setting/setting_screen.dart';
import 'package:wink_app/presentation/screens/splash/splash_screen.dart';
import 'package:wink_app/presentation/screens/story/story_viewer_screen.dart';
import 'package:wink_app/presentation/screens/successfully_post/successfully_post.dart';


class AppRouter {
  
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
  //     GoRoute(
  // path: AppRoutes.viewStoryScreen,
  // name: 'view story',
  // builder: (context, state) {
  //   // state.extra se story model safely nikal rahe hain
  //   final story = state.extra as StoryModel?;  
    
  //   if (story == null) {
  //     return const Scaffold(
  //       backgroundColor: Colors.black,
  //       body: Center(
  //         child: Text(
  //           'Story data missing from router!', 
  //           style: TextStyle(color: Colors.white),
  //         ),
  //       ),
  //     );
  //   }  
  //   return ViewStoryScreen(story: story);
  // },
//),
       GoRoute(
        path: AppRoutes.viewStoryScreen,
        name: 'view story',
        builder: (context, state){
        //  ViewStoryScreen(story: story)
      final story = state.extra as StoryModel?;  
      if (story == null) {
      // Yahan aap koi Error screen dikha sakte hain ya default widget
      return const Scaffold(
        body: Center(child: Text('Story data missing!')),
      );
    }  
      return  ViewStoryScreen(story: story);
        }
      ),
       GoRoute(
        path: AppRoutes.createStory,
        name: 'create story',
        builder: (context, state) => const 
         CreateStory(),
      ),
       GoRoute(
        path: AppRoutes.Profile,
        name: ' profile',
        builder: (context, state) => const 
        ProfileScreen(),
      ),
       GoRoute(
        path: AppRoutes.editProfile,
        name: 'edit profile',
        builder: (context, state) => const 
        EditProfileScreen(),
      ),
       GoRoute(
        path: AppRoutes.Settings,
        name: 'Settings',
        builder: (context, state) => const 
        SettingsScreen(),
      ),

      GoRoute(
        path: AppRoutes.reels,
        name: 'reels',
        builder: (context, state) => const 
        ReelPage(),
      ),
        GoRoute(
        path: AppRoutes.successfullyPost,
        name: 'successfullyPost',
        builder: (context, state) => const SuccessfullyPost(),
      ),
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