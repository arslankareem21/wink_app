import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wink_app/core/config/theme/app_spacing.dart';
import 'package:wink_app/core/config/theme/app_text_style.dart';
import 'package:wink_app/presentation/components/profile/pofile_dafault_tab_controller.dart';
import 'package:wink_app/presentation/components/profile/profile_header.dart';
import 'package:wink_app/presentation/components/profile/profile_status.dart';
import 'package:wink_app/presentation/screens/profile/other_user_profile_screen.dart'
    hide ProfileTabsView;
import 'package:wink_app/presentation/screens/setting/setting_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Screen', style: AppTextStyles.appBarTitle),
        leading: Padding(
          padding: AppSpacing.buttonPadding,
          child: IconButton(
            icon: Icon(
              Icons.arrow_back,
              size: 20.sp,
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const OtherProfileScreen(),
              ), // change this
            ),
          ),
        ),
        actions: [
          Padding(
            padding: AppSpacing.buttonPadding.copyWith(right: 0),
            child: IconButton(
              icon: Icon(
                Icons.settings,
                size: 20.sp,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()),
                );
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Center(
            child: ProfileHeader(name: "Alex", bio: 'Software Developer'),
          ),
          ProfileStats(
            postsCount: 11,
            followersCount: 120.toString(),
            followingCount: 100,
          ),
          Expanded(
            child:
                //ProfileTabsView(param0, isOtherProfile: isOtherProfile)
                ProfileTabsView(),
          ),
        ],
      ),
    );
  }
}
