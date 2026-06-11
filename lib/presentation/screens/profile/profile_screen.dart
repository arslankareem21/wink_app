

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wink_app/core/config/routes/navigation_service.dart';
import 'package:wink_app/core/config/routes/route_names.dart';
import 'package:wink_app/core/config/theme/app_spacing.dart';
import 'package:wink_app/core/config/theme/app_text_style.dart';
import 'package:wink_app/presentation/components/profile/pofile_dafault_tab_controller.dart';
import 'package:wink_app/presentation/components/profile/profile_header.dart';
import 'package:wink_app/presentation/components/profile/profile_status.dart';
import 'package:wink_app/presentation/screens/profile/other_user_profile_screen.dart';
import 'package:wink_app/presentation/screens/setting/setting_screen.dart';
import 'package:wink_app/presentation/widgets/circle_avatar.dart';

import 'package:wink_app/viewmodels/auth_viewmodel.dart';
import 'package:wink_app/viewmodels/image_picker_vm.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pickedFile = ref.watch(imagePickerProvider);
    final authState = ref.watch(authViewModelProvider);

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
          Center(
            child: AppProfileAvatar(
              size: 400,
              imageSource: pickedFile,
              isNetwork: pickedFile == null,
              onTap: () {
                ref.read(imagePickerProvider.notifier).pickFromGallery();
              },
            ),
          ),
          IconButton(
            icon: authState.isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.logout, size: 30),
            onPressed: authState.isLoading
                ? null
                : () async {
                    await ref.read(authViewModelProvider.notifier).signOut();
                    if (context.mounted) {
                      NavigationService.go(context, AppRoutes.login);
                    }
                  },
          ),
        ],
      ),
    );
  }
}

