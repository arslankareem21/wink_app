import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wink_app/core/config/routes/navigation_service.dart';
import 'package:wink_app/core/config/routes/route_names.dart';
import 'package:wink_app/core/config/theme/app_spacing.dart';
import 'package:wink_app/core/config/theme/app_text_style.dart';
import 'package:wink_app/presentation/components/profile/profileTabController/pofile_dafault_tab_controller.dart';
import 'package:wink_app/presentation/provider/get_profile_providers.dart';
import 'package:wink_app/viewmodels/auth_viewmodel.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(currentUserIdProvider);
    
    if (userId == null) {
      return const Scaffold(
        body: Center(child: Text('Not logged in')),
      );
    }

    final userAsync = ref.watch(userDataProvider(userId));

    return userAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        body: Center(child: Text('Error: $error')),
      ),
      data: (doc) {
        if (!doc.exists || doc.data() == null) {
          return const Scaffold(
            body: Center(child: Text('User not found')),
          );
        }

        final user = doc.data()! as Map<String, dynamic>;
        final username = user['username']?? user['userName']?? user['handle']?? '';
        final name = user['name']?? user['displayName']?? 'No Name';
        final postsCount = (user['postsCount'] as num?)?.toInt()?? 0;
        final followersCount = (user['followersCount'] as num?)?.toInt()?? 0;
        final followingCount = (user['followingCount'] as num?)?.toInt()?? 0;
        final profileImageUrl = user['profileImageUrl']?? user['photoUrl']?? '';
        final bio = user['bio']?? user['description']?? '';
        final category = user['category']?? '';
        final location = user['location']?? '';
        final website = user['website']?? '';

        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            title: Text(
              username.isEmpty? name : username,
              style: AppTextStyles.appBarTitle,
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.settings, size: 24.sp),
                onPressed: () {
                  NavigationService.push(context, AppRoutes.settings);
                 // _showSettingsBottomSheet(context, ref);
                },
              ),
            ],
          ),
          body: Column(
            children: [
              // Profile Header Section - Not using NestedScrollView
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppSpacing.vxl,
                    Row(
                      children: [
                        Container(
                          width: 90.w,
                          height: 90.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey[800]!, width: 2),
                          ),
                          child: ClipOval(
                            child: profileImageUrl.isNotEmpty
                               ? CachedNetworkImage(
                                    imageUrl: profileImageUrl,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(
                                      color: Colors.grey[800],
                                      child: Icon(Icons.person, size: 45.sp, color: Colors.grey),
                                    ),
                                    errorWidget: (context, url, error) => Container(
                                      color: Colors.grey[800],
                                      child: Icon(Icons.person, size: 45.sp, color: Colors.grey),
                                    ),
                                  )
                                : Container(
                                    color: Colors.grey[800],
                                    child: Icon(Icons.person, size: 45.sp, color: Colors.grey),
                                  ),
                          ),
                        ),
                        
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildStat('Posts', postsCount),
                              _buildStat('Followers', followersCount),
                              _buildStat('Following', followingCount),
                            ],
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.vsm,
                    if (name.isNotEmpty)
                      Text(name, style: AppTextStyles.appBarBrandName),
                    if (category.isNotEmpty)...[
                      SizedBox(height: 4.h),
                      Text(
                        category,
                        style: AppTextStyles.appBarTitle.copyWith(color: Colors.grey),
                      ),
                    ],
                    if (bio.isNotEmpty)...[
                      SizedBox(height: 8.h),
                      Text(bio, style: AppTextStyles.bodyRegular),
                    ],
                    if (location.isNotEmpty)...[
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 14.sp, color: Colors.grey),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: Text(
                              location,
                              style: AppTextStyles.bodyRegular,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (website.isNotEmpty)...[
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          Icon(Icons.link, size: 14.sp, color: Colors.grey),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: Text(
                              website,
                              style: AppTextStyles.textLink.copyWith(color: Colors.blue),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                    AppSpacing.vxl,
                    SizedBox(
                      width: double.infinity,
                      height: 40.h,
                      child: OutlinedButton(
                        onPressed: () {
                          NavigationService.push(context, AppRoutes.editProfile);
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.grey[700]!),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        child: Text(
                          'Edit Profile',
                          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    AppSpacing.vxl,
                  ],
                ),
              ),
              // Tabs - Takes remaining space
              Expanded(
                child: ProfileTabsView(userId: userId),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStat(String label, int count) {
    return Column(
      children: [
        Text(_formatCount(count), style: AppTextStyles.toggleLabel),
        SizedBox(height: 2.h),
        Text(label, style: AppTextStyles.toggleLabel),
      ],
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
    return count.toString();
  }

  void _pickProfileImage(BuildContext context, WidgetRef ref, String userId) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showSettingsBottomSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: () async {
                Navigator.pop(context);
                await ref.read(authViewModelProvider.notifier).signOut();
              },
            ),
          ],
        ),
      ),
    );
  }
}