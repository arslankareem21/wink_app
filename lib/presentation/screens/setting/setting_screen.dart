import 'dart:io'; 
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wink_app/core/config/routes/navigation_service.dart';
import 'package:wink_app/core/config/routes/route_names.dart';
import 'package:wink_app/core/config/theme/app_colors.dart';
import 'package:wink_app/core/config/theme/app_spacing.dart';
import 'package:wink_app/core/config/theme/app_text_style.dart';
import 'package:wink_app/presentation/components/settings/setting_list_item.dart';
import 'package:wink_app/presentation/components/settings/premium_banner.dart';
import 'package:wink_app/presentation/screens/auth/forget_password_screen.dart';
import 'package:wink_app/presentation/screens/auth/login_screen.dart';
import 'package:wink_app/presentation/screens/auth/setup_dailog.dart';
import 'package:wink_app/presentation/screens/auth/signup-screen.dart';
import 'package:wink_app/presentation/screens/home/home_screen.dart';
import 'package:wink_app/presentation/screens/setting/account/account.dart';
import 'package:wink_app/presentation/widgets/circle_avatar.dart';
import 'package:wink_app/presentation/widgets/elevated_button.dart';
import 'package:wink_app/presentation/widgets/toogle_theme_button.dart';
import 'package:wink_app/viewmodels/auth_viewmodel.dart';
import 'package:wink_app/viewmodels/image_picker_vm.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  void _showImageSourceOptions(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Pick from Gallery'),
              onTap: () {
                ref.read(imagePickerProvider.notifier).pickFromGallery();
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Capture with Camera'),
              onTap: () {
                ref.read(imagePickerProvider.notifier).captureWithCamera();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const String name = '  Allex Rivera';
    const String username = '@alex_creative_vibe';
    const String defaultProfileImage = 'https://picsum.photos/200/200?random=1';
      TextEditingController google_pass_controller = TextEditingController();
    final authState = ref.watch(authViewModelProvider);
    
    final pickedImageFile = ref.watch(imagePickerProvider);
    
    return Scaffold(
      // Custom Header
      appBar: AppBar(
        title: Text(
          'Settings',
          style: AppTextStyles.appBarTitle,
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: IconButton(
            icon: Icon(Icons.arrow_back, size: 20.sp),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        actions: [
          const Padding(
            padding: EdgeInsets.all(8),
            child: ThemeToggleButton(),
          ),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppSpacing.vlg,
        
              GestureDetector(
                onTap: () => _showImageSourceOptions(context, ref),
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 18.r,
                      backgroundColor: AppColors.primaryYellow,
                      child: Icon(Icons.camera_alt_outlined, size: 16.sp, color: Colors.black),
                    ),
                  ],
                ),
              ),
        
              AppSpacing.vxxl,
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("PERSONAL SETTINGS", style: AppTextStyles.bodyRegular),
                    AppSpacing.vxs,
                    Container(
                      height: 219.h,
                      width: 300.w,
                      decoration: BoxDecoration(
                        color: AppColors.appBarTextDark,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            AppSpacing.vsm,
                            SettingsRow(
                              Icons.person_outlined,
                              'Account',
                              AppColors.primaryYellow,
                              () {
          
            
        
        
        showDialog(
                                  context: context,
                                  barrierDismissible: false, 
                                  builder: (context) => const SetupPasswordDialog(),
                                );
                             
                              },
                            ),
                            Divider(color: AppColors.border),
                            SettingsRow(
                              Icons.lock_outlined,
                              'Privacy',
                              AppColors.info,
                              () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SignUpScreen(),
                                  ),
                                );
                              },
                            ),
                            Divider(color: AppColors.border),
        
                            SettingsRow(
                              Icons.notifications_outlined,
                              'Notifications',
                              Colors.orange,
                              () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ForgetPasswordScreen(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    AppSpacing.vxxl,
        
                    Text("SUPPORT", style: AppTextStyles.bodyRegular),
                    Container(
                      height: 140.h,
                      width: 300.w,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SettingsRow(
                            Icons.help_center_outlined,
                            'Help Center',
                            Colors.green,
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>  HomeScreen(),
                                ),
                              );
                            },
                          ),
                          Divider(color: AppColors.border),
                          SettingsRow(
                            Icons.info_outline,
                            'About',
                            Colors.purple,
                            () {},
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
        
              AppSpacing.vxxl,
        
              ///Premium Banner
              PremiumBanner(
                onTap: () {
                },
              ),
        
              AppSpacing.vxxl,
        
              AppButton(
                text: 'Logout',
                textColor: AppColors.error,
                width: 240.w,
                onPressed:authState.isLoading
                 ? null
                  : () async {
                   await ref.read(authViewModelProvider.notifier).signOut();
                   if (context.mounted) {
                  NavigationService.go(context, AppRoutes.login);
                  }
                 },
                icon: Icon(Icons.logout, color: AppColors.error, size: 18.sp),
                isGhost: true,
              ),
              AppSpacing.vxxl,
        
        
              
            ],
          ),
        ),
      ),
    );
  }
}
