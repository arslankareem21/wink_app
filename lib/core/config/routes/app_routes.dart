import 'package:firebase_auth/firebase_auth.dart';
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
import 'package:wink_app/presentation/screens/profile/follow/following/follow/following.dart';
import 'package:wink_app/presentation/screens/profile/other_user_profile_screen.dart';
import 'package:wink_app/presentation/screens/profile/profile_screen.dart';
import 'package:wink_app/presentation/screens/reels/reels_page.dart';
import 'package:wink_app/presentation/screens/setting/setting_screen.dart';
import 'package:wink_app/presentation/screens/splash/splash_screen.dart';
import 'package:wink_app/presentation/screens/story/story_viewer_screen.dart';
import 'package:wink_app/presentation/screens/successfully_post/successfully_post.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    //.splash,
    routes: [
      GoRoute(
        path: AppRoutes.viewStoryScreen,
        name: 'view story',
        builder: (context, state) {
          // 1. Ek single story ki jagah ab List<StoryModel> cast karein
          final stories = state.extra as List<StoryModel>?;

          if (stories == null || stories.isEmpty) {
            return const Scaffold(
              backgroundColor: Colors.black,
              body: Center(
                child: Text(
                  'Story data missing!',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
          }

          // 2. Apni badli hui screen ko poori list pass kar dein
          return ViewStoryScreen(stories: stories);
        },
      ),
      GoRoute(
        path: AppRoutes.createStory,
        name: 'create story',
        builder: (context, state) => const CreateStory(),
      ),
      // GoRoute(
      //   path: AppRoutes.followFollowing,
      //   name: 'follow following',
      //   builder: (context, state) {
      //     // Extra data pass kar sakte hain agar kisi aur user ki list dekhni ho,
      //     // varna logged-in user ki ID extract hogi.
      //     final extraData = state.extra as Map<String, dynamic>?;
      //     final String targetUserId =
      //         extraData?['userId'] ??
      //         FirebaseAuth.instance.currentUser?.uid ??
      //         '';
      //     final int initialIndex = extraData?['initialIndex'] ?? 0;

      //     return FollowFollowingScreen(
      //       //   userId: targetUserId,
      //       initialIndex: initialIndex,
      //       targetUserId: "qlXZvqUf83OHBQcAiJEARv4BX4q1",
      //        userId: 'CgKwFq4T4YZZHUMreYI8A97lAKu1',
      //     );
      //   },
      // ),
      // GoRoute(
      //   path: AppRoutes.followFollowing,
      //   name: 'follow following',
      //   builder: (context, state) => const FollowFollowingScreen(userId: currentUserId,),
      // ),
      GoRoute(
        path: AppRoutes.Profile,
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),

      // GoRoute(
      //   path: AppRoutes.otherPtofile,
      //   name: 'other user profile',
      //   builder: (context, state) => const OtherProfileScreen(
      //     myId: 'CgKwFq4T4YZZHUMreYI8A97lAKu1',
      //     profileId: "4PluCY523IZzk0HmkjA36HLr30C3",
      //     myData: {},
      //   ),
      // ),
      GoRoute(
        path: AppRoutes.otherPtofile,
        name: 'other user profile',
        builder: (context, state) {
          final extraData = state.extra as Map<String, dynamic>?;
          final String targetProfileId = extraData?['profileId'] ?? '';
          final String currentUserId =
              FirebaseAuth.instance.currentUser?.uid ?? '';

          return OtherProfileScreen(
            myId: currentUserId,
            profileId: targetProfileId,

            //targetProfileId,
            myData: const {},
          );
        },
      ),

      // GoRoute(
      //   path: AppRoutes.otherPtofile,
      //   name: 'other user profile',
      //   builder: (context, state) {
      //     final extraData = state.extra as Map<String, dynamic>?;
      //     final String targetProfileId = extraData?['profileId'] ?? '';
      //     final String currentUserId =
      //         FirebaseAuth.instance.currentUser?.uid ?? '';

      //     return OtherProfileScreen(
      //       myId: currentUserId,
      //       profileId: "qlXZvqUf83OHBQcAiJEARv4BX4q1",
      //       myData: const {},
      //     );
      //   },
      // ),
      GoRoute(
        path: AppRoutes.editProfile,
        name: 'edit profile',
        builder: (context, state) => const EditProfileScreen(),
      ),

      GoRoute(
        path: AppRoutes.reels,
        name: 'reels',
        builder: (context, state) => const ReelPage(),
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
        path: AppRoutes.settings,
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
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
