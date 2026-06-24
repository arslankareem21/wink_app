// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:wink_app/core/config/routes/navigation_service.dart';
// import 'package:wink_app/core/config/routes/route_names.dart';
// import 'package:wink_app/core/config/theme/app_spacing.dart';
// import 'package:wink_app/core/config/theme/app_text_style.dart';
// import 'package:wink_app/presentation/components/profile/pofile_dafault_tab_controller.dart';
// import 'package:wink_app/presentation/components/profile/profile_bio.dart';
// import 'package:wink_app/presentation/components/profile/profile_status.dart';
// import 'package:wink_app/presentation/provider/user_provider.dart';
// import 'package:wink_app/presentation/screens/profile/other_user_profile_screen.dart';
// import 'package:wink_app/presentation/widgets/circle_avatar.dart';
// import 'package:wink_app/presentation/widgets/elevated_button.dart';
// import 'package:wink_app/viewmodels/image_picker_vm.dart';

// class ProfileScreen extends ConsumerStatefulWidget {
//   //  final String? profileImageUrl;

//   const ProfileScreen({super.key});

//   @override
//   ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends ConsumerState<ProfileScreen> {
//   @override
//   Widget build(BuildContext context) {
//     final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
//     final userAsync = ref.watch(userProvider(currentUserId));
//     final pickedImageFile = ref.watch(imagePickerProvider);
//     final pickedFile = ref.watch(imagePickerProvider);

//     return userAsync.when(
//       loading: () =>
//           const Scaffold(body: Center(child: CircularProgressIndicator())),
//       error: (e, _) =>
//           Scaffold(body: Center(child: Text("Error loading profile: $e"))),
//       data: (user) {
//         if (user == null) {
//           return const Scaffold(
//             body: Center(child: Text("User data not found")),
//           );
//         }
//         final networkImageUrl =
//             user.profileImageUrl != null && user.profileImageUrl!.isNotEmpty
//             ? user.profileImageUrl
//             : null;

//         return Scaffold(
//           appBar: AppBar(
//             title: Text('Profile Screen', style: AppTextStyles.appBarTitle),
//             leading: Padding(
//               padding: const EdgeInsets.all(8),
//               child: IconButton(
//                 icon: Icon(Icons.arrow_back, size: 20.sp),
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => OtherProfileScreen(
//                         myId: 'OfV3LuFxJPO5990Tl1knEzIBj3h1',
//                         profileId: 'Xx4u9rf5CvebaF0j1b0zcFUWbYF3',
//                         myData: {
//                           'username': user.username ?? 'no_username',
//                           'displayName':
//                               user.name ??
//                               'No Name', // Make sure this key matches what FollowService expects!
//                           'profileImageUrl': user.profileImageUrl ?? '',
//                         },
//                         //myData: currentU,
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//             actions: [
//               Padding(
//                 padding: const EdgeInsets.all(8),
//                 child: IconButton(
//                   icon: Icon(Icons.settings, size: 20.sp),
//                   onPressed: () {
//                     NavigationService.push(context, AppRoutes.Settings);
//                   },
//                 ),
//               ),
//             ],
//           ),
//           body: NestedScrollView(
//             headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
//               return [
//                 SliverToBoxAdapter(
//                   child: Column(
//                     children: [
//                       AppProfileAvatar(
//                         //   key: ValueKey(pickedFile?.path?? networkImageUrl),
//                         size: 80.sp,
//                         imageSource: pickedFile?.path ?? networkImageUrl,
//                         isNetwork: true,
//                         textSize: 12,
//                         radius: 40,
//                         imageFile: pickedFile != null
//                             ? File(pickedFile!.path)
//                             : null,
//                       ),
//                       Center(
//                         child:
//                             // ProfileHeader(
//                             // name:
//                             Text(
//                               user.name.isNotEmpty ? user.name : "Alex",
//                               style: TextStyle(
//                                 fontSize: 15.sp,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                         //  name: user.displayName.isNotEmpty ? user.displayName : "Alex",
//                         //user.bio.isNotEmpty ? user.bio : 'Software Developer',
//                         //  ),
//                       ),
//                       ProfileStats(
//                         postsCount: user.postsCount,
//                         followersCount: user.followersCount.toString(),
//                         followingCount: user.followingCount,
//                       ),
//                       AppSpacing.vxs,

//                       ProfileBio(
//                         name: user.name.isNotEmpty ? user.name : "Alex",
//                         //name: user.name ?? 'No Name',
//                         category: user.category.isNotEmpty
//                             ? user.category
//                             : 'Alex',
//                         description: user.bio.isNotEmpty ? user.bio : "Alex",
//                         //user.description?? 'creating daily aesthetics',
//                         location: user.location.isNotEmpty
//                             ? user.location
//                             : 'Los Angeles / NYC',
//                         collaborationEmail: user.collaborationEmail.isNotEmpty
//                             ? user.collaborationEmail
//                             : 'hello@wink.co',
//                         website: user.website.isNotEmpty
//                             ? user.website
//                             : 'hhssjhwsw',
//                         username: user.username.isNotEmpty
//                             ? user.username
//                             : 'no username',
//                       ),

//                       AppSpacing.vxl,

//                       Padding(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: AppSpacing.lg,
//                         ),
//                         child: AppButton(
//                           isGhost: true,
//                           text: 'Edit Profile',
//                           onPressed: () {
//                             NavigationService.push(
//                               context,
//                               AppRoutes.editProfile,
//                             );
//                           },
//                         ),
//                       ),
//                       AppSpacing.vxl,
//                     ],
//                   ),
//                 ),
//               ];
//             },
//             body: const ProfileTabsView(),
//           ),
//         );
//       },
//     );
//   }
// }




import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wink_app/core/config/routes/navigation_service.dart';
import 'package:wink_app/core/config/routes/route_names.dart';
import 'package:wink_app/core/config/theme/app_spacing.dart';
import 'package:wink_app/core/config/theme/app_text_style.dart';
import 'package:wink_app/presentation/components/profile/profileTabController/pofile_dafault_tab_controller.dart';
import 'package:wink_app/presentation/components/profile/profile_bio.dart';
import 'package:wink_app/presentation/components/profile/profile_status.dart';
import 'package:wink_app/presentation/provider/user_provider.dart';
import 'package:wink_app/presentation/screens/profile/other_user_profile_screen.dart';
import 'package:wink_app/presentation/widgets/circle_avatar.dart';
import 'package:wink_app/presentation/widgets/elevated_button.dart';
import 'package:wink_app/viewmodels/image_picker_vm.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
    final userAsync = ref.watch(userProvider(currentUserId));
    final pickedFile = ref.watch(imagePickerProvider);

    return userAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text("Error loading profile: $e"))),
      data: (user) {
        if (user == null) {
          return const Scaffold(body: Center(child: Text("User data not found")));
        }
        
        final networkImageUrl = user.profileImageUrl != null && user.profileImageUrl!.isNotEmpty
            ? user.profileImageUrl
            : null;

        return Scaffold(
          appBar: AppBar(
            title: Text('Profile Screen', style: AppTextStyles.appBarTitle),
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: IconButton(
                icon: Icon(Icons.arrow_back, size: 20.sp),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OtherProfileScreen(
                        myId: 'OfV3LuFxJPO5990Tl1knEzIBj3h1',
                        profileId: 'Xx4u9rf5CvebaF0j1b0zcFUWbYF3',
                        myData: {
                          'username': user.username ?? 'no_username',
                          'displayName': user.name ?? 'No Name',
                          'profileImageUrl': user.profileImageUrl ?? '',
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: IconButton(
                  icon: Icon(Icons.settings, size: 20.sp),
                  onPressed: () {
                    NavigationService.push(context, AppRoutes.Settings);
                  },
                ),
              ),
            ],
          ),
          body: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverOverlapAbsorber(
                  handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      children: [
                        AppProfileAvatar(
                          size: 80.sp,
                          imageSource: pickedFile?.path ?? networkImageUrl ?? 'https://ui-avatars.com/api/?name=${user.name}&background=random',
                          //imageSource: pickedFile?.path ?? networkImageUrl,
                          isNetwork: true,
                       
                          radius: 40,
                          imageFile: pickedFile != null ? File(pickedFile.path) : null,
                        ),
                        Center(
                          child: Text(
                            user.name.isNotEmpty ? user.name : "Alex",
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                            ), 
                          ),
                        ),
                        ProfileStats(
                          postsCount: user.postsCount,
                          followersCount: user.followersCount.toString(),
                          followingCount: user.followingCount,
                        ),
              
                        AppSpacing.vxs,
                        ProfileBio(
                          name: user.name.isNotEmpty ? user.name : "Alex",
                          category: user.category.isNotEmpty ? user.category : 'Alex',
                          description: user.bio.isNotEmpty ? user.bio : "Alex",
                          location: user.location.isNotEmpty ? user.location : 'Los Angeles / NYC',
                          collaborationEmail: user.collaborationEmail.isNotEmpty ? user.collaborationEmail : 'hello@wink.co',
                          website: user.website.isNotEmpty ? user.website : 'hhssjhwsw',
                          username: user.username.isNotEmpty ? user.username : 'no username',
                        ),
                        AppSpacing.vxl,
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                          child: AppButton(
                            isGhost: true,
                            text: 'Edit Profile',
                            onPressed: () {
                              NavigationService.push(context, AppRoutes.editProfile);
                            },
                          ),
                        ),
                        AppSpacing.vxl,
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: const ProfileTabsView(
              //currentUserId: curr,
              ),
          ),
        );
      },
    );
  }
}