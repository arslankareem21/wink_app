import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wink_app/core/config/theme/app_spacing.dart';
import 'package:wink_app/core/config/theme/app_text_style.dart';
import 'package:wink_app/presentation/components/profile/other_profile/other_profile_bio.dart';
import 'package:wink_app/presentation/components/profile/other_profile/other_profile_header.dart';
import 'package:wink_app/presentation/components/profile/profileTabController/pofile_dafault_tab_controller.dart';
import 'package:wink_app/presentation/provider/get_profile_providers.dart';
import 'package:wink_app/presentation/screens/profile/profile_screen.dart';
import 'package:wink_app/presentation/widgets/elevated_button.dart';
import 'package:wink_app/service/firestore_service.dart';

class OtherProfileScreen extends ConsumerWidget {
  final String myId;
  final String profileId;
  final Map<String, dynamic> myData;

  const OtherProfileScreen({
    super.key,
    required this.myId,
    required this.profileId,
    required this.myData,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userDataProvider(profileId));
    final isSelf = myId == profileId;

    return userAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stack) =>
          Scaffold(body: Center(child: Text('Error loading profile: $error'))),
      data: (doc) {
        if (!doc.exists || doc.data() == null) {
          return const Scaffold(body: Center(child: Text('User not found')));
        }

        final user = doc.data()! as Map<String, dynamic>;
        final username =
            user['username'] ?? user['userName'] ?? user['handle'] ?? '';
        final name = user['name'] ?? user['displayName'] ?? 'No Name';
        final postsCount = (user['postsCount'] as num?)?.toInt() ?? 0;
        final followersCount = (user['followersCount'] as num?)?.toInt() ?? 0;
        final followingCount = (user['followingCount'] as num?)?.toInt() ?? 0;
        final profileImageUrl =
            user['profileImageUrl'] ?? user['photoUrl'] ?? '';

        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            title: Text(name, style: AppTextStyles.appBarTitle),
            actions: [
              if (isSelf)
                IconButton(
                  icon: Icon(Icons.settings_outlined, size: 24.sp),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileScreen(),
                      ),
                    );
                  },
                ),
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppSpacing.vxl,
                    OtherUserProfileHeader(
                      username: username,
                      name: name,
                      postsCount: postsCount,
                      followersCount: followersCount,
                      followingCount: followingCount,
                      profileImageUrl: profileImageUrl,
                      userId: profileId,
                      //  profileId: profileId,
                    ),
                    AppSpacing.vxs,
                    OtherUserProfileBio(
                      category: user['category'] ?? '',
                      description: user['bio'] ?? user['description'] ?? '',
                      location: user['location'] ?? '',
                      collaborationEmail:
                          user['collaborationEmail'] ?? user['email'] ?? '',
                      website: user['website'] ?? '',
                    ),
                    AppSpacing.vxl,
                    if (!isSelf) _buildFollowButtons(ref, myId, profileId),
                    AppSpacing.vxl,
                  ],
                ),
              ),
              Expanded(
                child: ProfileTabsView(
                  userId: profileId,
                ), // ✅ corrected tabs view
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFollowButtons(WidgetRef ref, String myId, String profileId) {
    return Row(
      children: [
        Expanded(
          child: Consumer(
            builder: (context, ref, _) {
              final params = (currentUserId: myId, targetUserId: profileId);
              final followAsync = ref.watch(isFollowingMergedProvider(params));
              final isFollowing = followAsync.value ?? false;
              final isLoading =
                  followAsync.isLoading && followAsync.value == null;

              return AppButton(
                text: isLoading
                    ? "..."
                    : isFollowing
                    ? "Following"
                    : "Follow",
                isGhost: !isFollowing,
                onPressed: isLoading
                    ? null
                    : () async {
                        final firestore = ref.read(firestoreServiceProvider);
                        final optimisticNotifier = ref.read(
                          followOptimisticProvider(params).notifier,
                        );
                        final currentState = isFollowing;

                        optimisticNotifier.state = !currentState;

                        try {
                          if (currentState) {
                            await firestore.unfollowUser(myId, profileId);
                          } else {
                            await firestore.followUser(myId, profileId);
                          }
                          optimisticNotifier.state = null;
                        } catch (e) {
                          optimisticNotifier.state = currentState;
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Failed: $e')),
                            );
                          }
                          await Future.delayed(
                            const Duration(milliseconds: 300),
                          );
                          optimisticNotifier.state = null;
                        }
                      },
              );
            },
          ),
        ),
        AppSpacing.hlg,
        Expanded(
          child: AppButton(text: "Message", isGhost: true, onPressed: () {}),
        ),
      ],
    );
  }
}
