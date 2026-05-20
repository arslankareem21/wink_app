import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wink_app/core/config/theme/app_colors.dart';
import 'package:wink_app/core/config/theme/app_spacing.dart';
import 'package:wink_app/core/config/theme/app_text_style.dart';
import 'package:wink_app/presentation/components/profile/pofile_dafault_tab_controller.dart';
import 'package:wink_app/presentation/components/profile/profile_header.dart';
import 'package:wink_app/presentation/components/profile/profile_status.dart';
import 'package:wink_app/presentation/screens/profile/other_user_profile_screen.dart' hide ProfileTabsView;
import 'package:wink_app/presentation/screens/setting/setting_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
     final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile Screen',
          style: AppTextStyles.appBarTitle),
        //   TextStyle(app
        //     fontWeight: FontWeight.bold,fontSize: 20.sp, color: isDark ? AppColors.white : AppColors.black,),
        // ),
        leading: Padding(
          padding: AppSpacing.buttonPadding,
          child: IconButton(
            icon: Icon(Icons.arrow_back, size: 20.sp, color: isDark ? AppColors.white : AppColors.black),
            onPressed:()=>Navigator.push(
                              context,
                             MaterialPageRoute(builder: (context) => const OtherProfileScreen())// change this
                            )
            //() => Navigator.pop(context),
          ),
        ),
        actions: [
          Padding(
            padding: AppSpacing.buttonPadding.copyWith(right: 0),
            child: IconButton(
              icon: Icon(Icons.settings, color: isDark ? AppColors.white : AppColors.black, size: 20.sp),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>
                SettingsScreen()));
              },
            ),
          )
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
          Expanded(child:
          //ProfileTabsView(param0, isOtherProfile: isOtherProfile)
           ProfileTabsView
                    (
                     // imageUrls: _postsImages,
                    // isOtherProfile: false,
                    ),)
         // ProfileTabsView(isOtherProfile: false,)),



           //Profile_default_tab()),
          //ProfileTabs(selectedIndex: 0 , onTabSelected: )
          // DefaultTabController(
          //   initialIndex: 1,
          //   length: 2,
          //   child: Column(
          //     children: [
          //       TabBar(
          //         isScrollable: true,
          //         indicatorPadding: EdgeInsets.symmetric(horizontal: 16.w),
          //         indicatorColor: AppColors.primaryYellow,
          //         tabs: [
          //           Tab(icon: Icon(Icons.grid_view_rounded)),
          //           Tab(icon: Icon(Icons.person_outline_rounded)),
          //         ],
          //       ),
          //       Expanded(
          //         child: TabBarView(
          //           children: [
          //             Center(child: Text('Posts ')),
          //             Center(child: Text('Shorts')),
          //           ],
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
