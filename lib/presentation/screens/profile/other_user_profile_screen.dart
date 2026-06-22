import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wink_app/core/config/theme/app_spacing.dart';
import 'package:wink_app/core/config/theme/app_text_style.dart';
import 'package:wink_app/presentation/components/profile/other_profile/other_profile_bio.dart';
import 'package:wink_app/presentation/components/profile/other_profile/other_profile_header.dart';
import 'package:wink_app/presentation/components/profile/other_profile/other_profile_tab_controller.dart';
import 'package:wink_app/presentation/provider/follow_provider.dart';
import 'package:wink_app/presentation/provider/user_provider.dart';
import 'package:wink_app/presentation/screens/profile/profile_screen.dart';
import 'package:wink_app/presentation/widgets/elevated_button.dart';

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
    // 1. Saamne wale user ka data
    final userAsync = ref.watch(userProvider(profileId));

    // 2. Aapka apna data
    final myUserAsync = ref.watch(userProvider(myId));

    // 3. Watch Follow State
    final follow = ref.watch(
      followProvider(FollowParams(myId, profileId, myData)),
    );

    return userAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stack) =>
          Scaffold(body: Center(child: Text('Error loading profile: $error'))),
      data: (user) {
        if (user == null) {
          return const Scaffold(body: Center(child: Text('User not found')));
        }

        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            title: Text(
              user.name ?? 'Profile',
              style: AppTextStyles.appBarTitle,
            ),
            actions: [
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
          body: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppSpacing.vxl,

                        // Profile Header (Stats)
                        myUserAsync.when(
                          loading: () =>
                              const Center(child: CircularProgressIndicator()),
                          error: (_, __) => const Text('Error loading stats'),
                          data: (myUser) {
                            return OtherUserProfileHeader(
                              username: user.username ?? 'no_username',
                              name: user.name ?? 'No Name',
                              postsCount: user.postsCount ?? 0,
                              followersCount: user.followersCount ?? 0,
                              followingCount: user.followingCount ?? 0,
                            );
                          },
                        ),

                        AppSpacing.vxs,

                        // Profile Bio
                        // OtherUserProfileBio(
                        //    name: user.name ?? 'No Name',
                        //   category: user.category?? 'lifestyle & fashion',
                        //   description:user.description?? 'creating daily aesthetics',
                        //   location:user.location?? 'Los Angeles / NYC',
                        //   collaborationEmail:user.collaborationEmail?? 'hello@wink.co',
                        //   website:user.website ?? 'hhssjhwsw' '',
                        // ),
                        OtherUserProfileBio(
                          name: user.name.isNotEmpty ? user.name : "Alex",
                          //name: user.name ?? 'No Name',
                          category: user.category.isNotEmpty
                              ? user.category
                              : 'Alex',
                          description: user.bio.isNotEmpty ? user.bio : "Alex",
                          //user.description?? 'creating daily aesthetics',
                          location: user.location.isNotEmpty
                              ? user.location
                              : 'Los Angeles / NYC',
                          collaborationEmail: user.collaborationEmail.isNotEmpty
                              ? user.collaborationEmail
                              : 'hello@wink.co',
                          website: user.website.isNotEmpty
                              ? user.website
                              : 'hhssjhwsw',
                        ),

                        AppSpacing.vxl,

                        // Follow / Message Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppButton(
                              text: follow ? "Following" : "Follow",
                              width: 160.w,
                              isGhost: true,
                              onPressed: () {
                                ref
                                    .read(
                                      followProvider(
                                        FollowParams(myId, profileId, myData),
                                      ).notifier,
                                    )
                                    .toggle();
                              },
                            ),
                            AppSpacing.hlg,
                            AppButton(
                              text: "Message",
                              width: 160.w,
                              isGhost: true,
                              onPressed: () {},
                            ),
                          ],
                        ),

                        AppSpacing.vxl, 
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: const OtherUserProfileTabController(),
          ),
        );
      },
    );
  }
}
