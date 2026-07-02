import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wink_app/core/config/routes/navigation_service.dart';
import 'package:wink_app/core/config/routes/route_names.dart';
import 'package:wink_app/core/config/theme/app_spacing.dart';
import 'package:wink_app/core/config/theme/app_text_style.dart';
import 'package:wink_app/models/post_models.dart';
import 'package:wink_app/presentation/components/profile/profileTabController/pofile_dafault_tab_controller.dart';
import 'package:wink_app/presentation/components/profile/profile_header.dart';
import 'package:wink_app/presentation/components/profile/profile_status.dart';
import 'package:wink_app/presentation/screens/setting/setting_screen.dart';
import 'package:wink_app/presentation/widgets/circle_avatar.dart';
import 'package:wink_app/viewmodels/auth_viewmodel.dart';
import 'package:wink_app/viewmodels/image_picker_vm.dart';
import 'package:wink_app/viewmodels/post_viewmodel.dart';

final myFeedPostsProvider = StreamProvider.autoDispose<List<PostModels>>((ref) {
  final currentUserId = ref.watch(currentUserProvider).value?.userId;

  if (currentUserId == null) {
    return Stream.value([]);
  }

  // Map the incoming list from the stream to only include matching userIds
  return ref.watch(postRepositoryProvider).watchFeedPosts().map((posts) {
    return posts.where((post) => post.userId == currentUserId).toList();
  });
});

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pickedFile = ref.watch(imagePickerProvider);
    final authState = ref.watch(authViewModelProvider);

    final currentUserAsync = ref.watch(currentUserProvider);
    final currentUserId = ref.read(currentUserProvider).value?.userId ?? '';
    final currentUserData = ref.read(currentUserProvider).value?.toMap() ?? {};

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Screen', style: AppTextStyles.appBarTitle),
        leading: Padding(
          padding: AppSpacing.buttonPadding,
          child: IconButton(
            icon: Icon(Icons.arrow_back, size: 20.sp),
            onPressed: () {},
            //             onPressed: () => Navigator.push(
            //               context,
            //               MaterialPageRoute(
            //                 builder: (context) => OtherProfileScreen(
            //                   myId: 'OfV3LuFxJPO5990Tl1knEzIBj3h1',
            //                   profileId: 'Xx4u9rf5CvebaF0j1b0zcFUWbYF3',
            //                  myData: {
            //   'username': user.username ?? 'no_username',
            //   'displayName': user.name ?? 'No Name', // Make sure this key matches what FollowService expects!
            //   'profileImageUrl': user.profileImageUrl ?? '',
            // },
            //                    //myData: currentU,
            //                    ),
            //               ), // change this
            //             ),
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
        data: (user) {
          if (user == null) return const Center(child: Text('User not found'));

          final networkImageUrl =
              user.profileImageUrl != null && user.profileImageUrl!.isNotEmpty
              ? '${user.profileImageUrl}?v=${user.updatedAt.millisecondsSinceEpoch}'
              : null;

          return Column(
            children: [
              Center(
                child: ProfileHeader(name: "Alex", bio: 'Software Developer'),
              ),
              ProfileStats(
                // postsCount: 11.toString(),
                // followersCount: 120.toString(),
                // followingCount: 100,
                   postsCount: user.postsCount.toString(),
                          followersCount: user.followersCount.toString(),
                          followingCount: user.followingCount,
              ),
              Expanded(child: ProfileTabsView()),
              AppProfileAvatar(
                size: 100.sp,
                imageSource: pickedFile,
                isNetwork: pickedFile == null,
                radius: 40.sp,
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
                        await ref
                            .read(authViewModelProvider.notifier)
                            .signOut();
                        if (context.mounted) {
                          NavigationService.go(context, AppRoutes.login);
                        }
                      },
              ),
            ],
          );
        },
      ),

      //) ; }
    );
  }
}
