// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:wink_app/core/config/routes/navigation_service.dart';
// import 'package:wink_app/core/config/routes/route_names.dart';
// import 'package:wink_app/core/config/theme/app_spacing.dart';
// import 'package:wink_app/core/config/theme/app_text_style.dart';
// import 'package:wink_app/presentation/components/profile/pofile_dafault_tab_controller.dart';
// import 'package:wink_app/presentation/components/profile/profile_header.dart';
// import 'package:wink_app/presentation/components/profile/profile_status.dart';
// import 'package:wink_app/presentation/screens/profile/other_user_profile_screen.dart';
// import 'package:wink_app/presentation/screens/setting/setting_screen.dart';
// import 'package:wink_app/presentation/widgets/circle_avatar.dart';
// import 'package:wink_app/viewmodels/auth_viewmodel.dart';
// import 'package:wink_app/viewmodels/image_picker_vm.dart';
// import 'package:wink_app/viewmodels/upload_vm.dart';

// class ProfileScreen extends ConsumerWidget {
//   const ProfileScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final pickedFile = ref.watch(imagePickerProvider);
//     final uploadState = ref.watch(uploadProvider);
//     final authState = ref.watch(authViewModelProvider);
//     final currentUserAsync = ref.watch(currentUserProvider);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Profile Screen', style: AppTextStyles.appBarTitle),
//         leading: Padding(
//           padding: AppSpacing.buttonPadding,
//           child: IconButton(
//             icon: Icon(Icons.arrow_back, size: 20.sp),
//             onPressed: () => Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => const OtherProfileScreen()),
//             ),
//           ),
//         ),
//         actions: [
//           Padding(
//             padding: AppSpacing.buttonPadding.copyWith(right: 0),
//             child: IconButton(
//               icon: Icon(Icons.settings, size: 20.sp),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => SettingsScreen()),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//       body: currentUserAsync.when(
//         loading: () => const Center(child: CircularProgressIndicator()),
//         error: (e, _) => Center(child: Text('Error: $e')),
//         data: (currentUser) {
//           if (currentUser == null) {
//             return const Center(child: Text('Please login'));
//           }

//           // Add timestamp to break cache
//           final networkImageUrl = currentUser.profileImageUrl != null
//               ? '${currentUser.profileImageUrl}?v=${currentUser.updatedAt.millisecondsSinceEpoch}'
//               : null;

//           return Column(
//             children: [
//               SizedBox(height: 16.h),
//               Center(
//                 child: ProfileHeader(
//                   name: currentUser.name,
//                   bio: currentUser.bio ?? '',
//                 ),
//               ),
//               SizedBox(height: 12.h),
//               ProfileStats(
//                 postsCount: currentUser.postsCount,
//                 followersCount: currentUser.followersCount.toString(),
//                 followingCount: currentUser.followingCount,
//               ),
//               SizedBox(height: 16.h),
//               Expanded(child: ProfileTabsView()),
              
//               Stack(
//                 alignment: Alignment.bottomRight,
//                 children: [
//                   AppProfileAvatar(
//                     key: ValueKey(pickedFile?.path ?? networkImageUrl),
//                     size: 50.sp,
//                     imageSource: pickedFile?.path ?? networkImageUrl,
//                     isNetwork: pickedFile == null,
                     
//                     onChangePhoto: () async {
//                       // Same logic for change photo button
//                       await ref.read(imagePickerProvider.notifier).pickFromGallery();
//                       final newFile = ref.read(imagePickerProvider);
                      
//                       if (newFile != null && context.mounted) {
//                         try {
//                           await ref.read(uploadProvider.notifier).uploadProfilePic(file: newFile);
//                           ref.read(imagePickerProvider.notifier).clear();
                          
//                           if (context.mounted) {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(content: Text('Profile photo updated')),
//                             );
//                           }
//                         } catch (e) {
//                           if (context.mounted) {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(content: Text('Upload failed: ${e.toString().replaceAll('Exception: ', '')}')),
//                             );
//                           }
//                         } finally {
//                           ref.read(uploadProvider.notifier).reset();
//                         }
//                       }
//                     },
                   
//                   ),
                  
//                   if (uploadState.isUploading)
//                     Positioned.fill(
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: Colors.black54,
//                           shape: BoxShape.circle,
//                         ),
//                         child: Center(
//                           child: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               SizedBox(
//                                 width: 30.sp,
//                                 height: 30.sp,
//                                 child: CircularProgressIndicator(
//                                   value: uploadState.progress > 0 ? uploadState.progress : null,
//                                   strokeWidth: 3,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                               if (uploadState.progress > 0) ...[
//                                 SizedBox(height: 4.h),
//                                 Text(
//                                   '${(uploadState.progress * 100).toInt()}%',
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 10.sp,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ],
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
              
//               Padding(
//                 padding: EdgeInsets.only(bottom: 20.h),
//                 child: IconButton(
//                   icon: authState.isLoading
//                       ? SizedBox(
//                           width: 24.sp,
//                           height: 24.sp,
//                           child: CircularProgressIndicator(strokeWidth: 2.sp),
//                         )
//                       : Icon(Icons.logout, size: 28.sp, color: Colors.red),
//                   onPressed: authState.isLoading
//                       ? null
//                       : () async {
//                           await ref.read(authViewModelProvider.notifier).signOut();
//                           if (context.mounted) {
//                             NavigationService.go(context, AppRoutes.login);
//                           }
//                         },
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }




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

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);
    final currentUserAsync = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Screen', style: AppTextStyles.appBarTitle),
        leading: Padding(
          padding: AppSpacing.buttonPadding,
          child: IconButton(
            icon: Icon(Icons.arrow_back, size: 20.sp),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const OtherProfileScreen()),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: AppSpacing.buttonPadding.copyWith(right: 0),
            child: IconButton(
              icon: Icon(Icons.settings, size: 20.sp),
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
      body: currentUserAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (currentUser) {
          if (currentUser == null) {
            return const Center(child: Text('Please login'));
          }

          // Fixed: Handle null updatedAt safely
          final networkImageUrl = currentUser.profileImageUrl != null && currentUser.profileImageUrl!.isNotEmpty
              ? '${currentUser.profileImageUrl}?v=${currentUser.updatedAt?.millisecondsSinceEpoch ?? DateTime.now().millisecondsSinceEpoch}'
              : null;

          return Column(
            children: [
              SizedBox(height: 16.h),
              AppProfileAvatar(
                key: ValueKey(networkImageUrl),
                size: 50.sp,
                imageSource: networkImageUrl,
                isNetwork: true,
              ),
              SizedBox(height: 12.h),
              Center(
                child: ProfileHeader(
                  name: currentUser.name,
                  bio: currentUser.bio ?? '',
                ),
              ),
              SizedBox(height: 12.h),
              ProfileStats(
                postsCount: currentUser.postsCount,
                followersCount: currentUser.followersCount.toString(),
                followingCount: currentUser.followingCount,
              ),
              SizedBox(height: 16.h),
              Expanded(child: ProfileTabsView()),
              Padding(
                padding: EdgeInsets.only(bottom: 20.h),
                child: IconButton(
                  icon: authState.isLoading
                      ? SizedBox(
                          width: 24.sp,
                          height: 24.sp,
                          child: CircularProgressIndicator(strokeWidth: 2.sp),
                        )
                      : Icon(Icons.logout, size: 28.sp, color: Colors.red),
                  onPressed: authState.isLoading
                      ? null
                      : () async {
                          await ref.read(authViewModelProvider.notifier).signOut();
                          if (context.mounted) {
                            NavigationService.go(context, AppRoutes.login);
                          }
                        },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
