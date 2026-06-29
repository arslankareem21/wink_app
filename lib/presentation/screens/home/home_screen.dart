// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:wink_app/core/config/theme/app_colors.dart';
// import 'package:wink_app/models/post_model.dart';
// import 'package:wink_app/presentation/components/post/post_card.dart';
// import 'package:wink_app/presentation/provider/story/story_provider.dart';

// class HomeScreen extends ConsumerStatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   ConsumerState<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends ConsumerState<HomeScreen> {
//   final posts = [
//   PostModel(
//     userName: 'sarah.creative',
//     userImage:
//         'https://i.pravatar.cc/300?img=5',
//     location: 'Brooklyn, NY',
//     timeAgo: '2 hours ago',
//     postImage:
//         'https://images.unsplash.com/photo-1518770660439-4636190af475',
//     caption:
//         'Throwback to when tech felt like magic! ✨ #retro #gaming #vibes',
//     likes: 1200,
//     comments: 84,
//   ),
//   PostModel(
//     userName: 'sarah.creative',
//     userImage:
//         'https://i.pravatar.cc/300?img=5',
//     location: 'Brooklyn, NY',
//     timeAgo: '2 hours ago',
//     postImage:
//         'https://images.unsplash.com/photo-1518770660439-4636190af475',
//     caption:
//         'Throwback to when tech felt like magic! ✨ #retro #gaming #vibes',
//     likes: 1200,
//     comments: 84,
//   ),
//   PostModel(
//     userName: 'sarah.creative',
//     userImage:
//         'https://i.pravatar.cc/300?img=5',
//     location: 'Brooklyn, NY',
//     timeAgo: '2 hours ago',
//     postImage:
//         'https://images.unsplash.com/photo-1518770660439-4636190af475',
//     caption:
//         'Throwback to when tech felt like magic! ✨ #retro #gaming #vibes',
//     likes: 1200,
//     comments: 84,
//   ),
//   PostModel(
//     userName: 'sarah.creative',
//     userImage:
//         'https://i.pravatar.cc/300?img=5',
//     location: 'Brooklyn, NY',
//     timeAgo: '2 hours ago',
//     postImage:
//         'https://images.unsplash.com/photo-1518770660439-4636190af475',
//     caption:
//         'Throwback to when tech felt like magic! ✨ #retro #gaming #vibes',
//     likes: 1200,
//     comments: 84,
//   ),
// ];

//   @override
//   Widget build(BuildContext context) {
//     final currentStory = ref.watch(storyProvider); // Story ki state ko watch karein
//     return Scaffold(
//       appBar: AppBar(
//       ),
//       body: Stack(
//         children: [

//           SizedBox(
//           height: 100,
//           child: ListView(
//             scrollDirection: Axis.horizontal,
//             children: [
//               // Agar story maujood hai toh dikhayein, warna sirf Add Story ka button
//               if (currentStory != null)
//                 CircleAvatar(
//                   radius: 35,
//                   backgroundImage: MemoryImage(currentStory.bytes), // Edited image bytes
//                 ),
//             ],
//           ),),

//           Container(
//             height: 200.h,
//             width: 200.w,
//             color: AppColors.primaryYellow,
//           ),
//           SizedBox(height: 16.h),
//           Expanded(
//             child: ListView.builder(
//                   itemCount: posts.length,
//                   itemBuilder: (context, index) {
//                     return PostCard(
//                 post: posts[index],
//                     );
//                   },
//                 ),
//           )
//         ],
//       ),
//       );

//   }
// } //

////////////////////////////////////////////////////// MY HOME

// import 'dart:io';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:wink_app/core/config/routes/navigation_service.dart';
// import 'package:wink_app/core/config/routes/route_names.dart';
// import 'package:wink_app/core/config/theme/app_colors.dart';
// import 'package:wink_app/core/config/theme/app_spacing.dart';
// import 'package:wink_app/models/post_model.dart';
// import 'package:wink_app/presentation/components/post/post_card.dart';
// import 'package:wink_app/presentation/provider/story/story_provider.dart';
// import 'package:wink_app/presentation/provider/user_provider.dart';
// import 'package:wink_app/presentation/screens/story/story_viewer_screen.dart';
// import 'package:wink_app/viewmodels/image_picker_vm.dart';

// class HomeScreen extends ConsumerStatefulWidget {
//     final String? profileId;

//   const HomeScreen({super.key,  this.profileId});

//   @override
//   ConsumerState<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends ConsumerState<HomeScreen> {
//   final posts = [
//     PostModel(
//       userName: 'sarah.creative',
//       userImage: 'https://i.pravatar.cc/300?img=5',
//       location: 'Brooklyn, NY',
//       timeAgo: '2 hours ago',
//       postImage: 'https://images.unsplash.com/photo-1518770660439-4636190af475',
//       caption:
//           'Throwback to when tech felt like magic! ✨ #retro #gaming #vibes',
//       likes: 1200,
//       comments: 84,
//     ),
//     PostModel(
//       userName: 'sarah.creative',
//       userImage: 'https://i.pravatar.cc/300?img=5',
//       location: 'Brooklyn, NY',
//       timeAgo: '2 hours ago',
//       postImage: 'https://images.unsplash.com/photo-1518770660439-4636190af475',
//       caption:
//           'Throwback to when tech felt like magic! ✨ #retro #gaming #vibes',
//       likes: 1200,
//       comments: 84,
//     ),
//   ];

//   @override
//   Widget build(BuildContext context) {
//         final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
//     final storiesList = ref.watch(storyProvider);
//     final userAsync = ref.watch((userProvider(currentUserId)));

//     // const String myUserId = user.id;
//     // // Meri apni stories ki list
//     // final myStories = storiesList.where((s) => s.userId == myUserId).toList();
//     // // Baqi doston ki stories ki list
//     // final otherStories = storiesList.where((s) => s.userId != myUserId)
//     //     .toList();

// return userAsync.when(
//       loading: () =>
//           const Scaffold(body: Center(child: CircularProgressIndicator())),
//       error: (error, stack) =>
//           Scaffold(body: Center(child: Text('Error loading profile: $error'))),
//       data: (user) {
//         if (user == null) {
//           return const Scaffold(body: Center(child: Text('User not found')));
//         }

// final String myUserId = user.uid;
//     // Meri apni stories ki list
//     final myStories = storiesList.where((s) => s.userId == myUserId).toList();
//     // Baqi doston ki stories ki list
//     final otherStories = storiesList.where((s) => s.userId != myUserId)
//         .toList();

//     return Scaffold(
//       appBar: AppBar(title: const Text("Wink")),
//       // Stack hata kar Column lagaya taake widgets aapas mein takrayen na (Overlap na hon)
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // 1. STORIES SECTION
//           SizedBox(
//             height: 120.h,
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               // List ki length + 1 (Pehla item 'Add Story' button hoga)
//               itemCount: 1 + otherStories.length,
//               itemBuilder: (context, index) {
//                 // PEHLA ITEM: Add Story Button
//                 if (index == 0) {
//                   final bool hasStory = myStories.isNotEmpty;
//                   return Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 8.w),
//                     child: GestureDetector(
//                       onTap: () async {
//                         if (hasStory) {
//                           NavigationService.push(
//                             context,
//                             AppRoutes.viewStoryScreen,
//                           );
//                         } else {
//                           NavigationService.push(
//                             context,
//                             AppRoutes.createStory,
//                           );
//                         }
//                         // TODO: Apne routes ke mutabiq next page par bhejein
//                       },
//                       child: Column(
//                         children: [
//                           SingleChildScrollView(
//                             child: Stack(
//                               children: [
//                                 CircleAvatar(
//                                   radius: 35.r,
//                                   backgroundColor: hasStory
//                                       ? AppColors.primaryYellow
//                                       : Colors.grey[800],
//                                   child: CircleAvatar(
//                                     radius: 32.r,
//                                     backgroundColor: Colors.grey[900],
//                                     // Agat story hai toh select ki hui media dikhao, warna khali plus/placeholder
//                                     backgroundImage: hasStory
//                                         ? (myStories.first.bytes != null
//                                                   ? MemoryImage(
//                                                       myStories.first.bytes!,
//                                                     )
//                                                   : myStories.first.mediaUrl
//                                                         .startsWith('http')
//                                                   ? NetworkImage(
//                                                       myStories.first.mediaUrl,
//                                                     )
//                                                   : null)
//                                               as ImageProvider?
//                                         : const AssetImage(
//                                             'assets/placeholder.png',
//                                           ),
//                                     child: !hasStory
//                                         ? const Icon(
//                                             Icons.add,
//                                             color: Colors.white,
//                                             size: 25,
//                                           )
//                                         : null, // Agar story lag gayi toh plus icon gayab ho jaye
//                                   ),
//                                 ),
//                                 Positioned(
//                                   bottom: 2, // Bilkul neeche
//                                   right: 2,
//                                   child: CircleAvatar(
//                                     radius: 11.r,
//                                     backgroundColor: Colors.blue,
//                                     child: const Icon(
//                                       Icons.add,
//                                       size: 12,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           AppSpacing.vxs,
//                           Text('My Story', style: TextStyle(fontSize: 13.sp)),
//                         ],
//                       ),
//                     ),
//                   );
//                 }

//                 // BAQI ITEMS: Active Stories
//                 final story = storiesList[index - 1];

//                 return Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 8.w),
//                   child: GestureDetector(
//                     // 🔥 CLICK LOGIC: Jab user avatar par click karega
//                     onTap: () {
//                       // Hum next screen par navigate karenge aur is user ki specific 'story' ka data bhejenge
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => ViewStoryScreen(story: story),
//                         ),
//                       );
//                     },
//                     child: Column(
//                       children: [
//                         CircleAvatar(
//                           radius: 35.r,
//                           backgroundColor:
//                               AppColors.primaryYellow, // Yellow Ring Effect
//                           child: CircleAvatar(
//                             radius: 32.r,
//                             backgroundColor: Colors.grey[900],
//                             backgroundImage: (() {
//                               if (story.mediaUrl.startsWith('http://') ||
//                                   story.mediaUrl.startsWith('https://')) {
//                                 return NetworkImage(story.mediaUrl);
//                               }
//                               // Agar aapne model mein bytes add kar liye hain, toh yahan MemoryImage return karlein
//                               // Warna placeholder tab tak jab tak backend par url nahi banta
//                               return const AssetImage('assets/placeholder.png')
//                                   as ImageProvider;
//                             })(),
//                           ),
//                         ),

//                         Text( user.name ?? 'Profile',)

//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),

//           SizedBox(height: 18.h),

//           // 2. YELLOW BANNER
//           // Container(
//           //   height: 100.h,
//           //   width: double.infinity,
//           //   color: AppColors.primaryYellow,
//           //   child: const Center(child: Text("Yellow Banner")),
//           // ),
//           // SizedBox(height: 10.h),

//           // 3. POSTS LIST
//           Expanded(
//             child: ListView.builder(
//               itemCount: posts.length,
//               itemBuilder: (context, index) {
//                 return PostCard(post: posts[index]);
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//     }
// );
//   }
// }

import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wink_app/core/config/routes/navigation_service.dart';
import 'package:wink_app/core/config/routes/route_names.dart';
import 'package:wink_app/core/config/theme/app_colors.dart';
import 'package:wink_app/core/config/theme/app_spacing.dart';
import 'package:wink_app/models/post_model.dart';
import 'package:wink_app/models/story_model.dart';
import 'package:wink_app/presentation/components/post/post_card.dart';
import 'package:wink_app/presentation/provider/story/story_provider.dart';
import 'package:wink_app/presentation/provider/user_provider.dart';
import 'package:wink_app/presentation/screens/story/story_viewer_screen.dart';
import 'package:wink_app/viewmodels/image_picker_vm.dart';

class HomeScreen extends ConsumerWidget {
  final String? profileId;

  HomeScreen({super.key, this.profileId});

  final posts = [
    PostModel(
      userName: 'sarah.creative',
      userImage: 'https://i.pravatar.cc/300?img=5',
      location: 'Brooklyn, NY',
      timeAgo: '2 hours ago',
      postImage: 'https://images.unsplash.com/photo-1518770660439-4636190af475',
      caption:
          'Throwback to when tech felt like magic! ✨ #retro #gaming #vibes',
      likes: 1200,
      comments: 84,
    ),
    PostModel(
      userName: 'sarah.creative',
      userImage: 'https://i.pravatar.cc/300?img=5',
      location: 'Brooklyn, NY',
      timeAgo: '2 hours ago',
      postImage: 'https://images.unsplash.com/photo-1518770660439-4636190af475',
      caption:
          'Throwback to when tech felt like magic! ✨ #retro #gaming #vibes',
      likes: 1200,
      comments: 84,
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
    final userAsync = ref.watch(userProvider(currentUserId));
    final activeStoriesAsync = ref.watch(activeStoriesStreamProvider);

    return userAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stack) =>
          Scaffold(body: Center(child: Text('Error loading profile: $error'))),
      data: (user) {
        if (user == null) {
          return const Scaffold(body: Center(child: Text('User not found')));
        }

        final String myUserId = user.uid;

        return activeStoriesAsync.when(
          loading: () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
          error: (err, stack) =>
              Scaffold(body: Center(child: Text('Story fetch error: $err'))),
          data: (storiesList) {
            // Meri aur baqi doston ki stories logic background layer par
            final myStories = storiesList
                .where((s) => s.userId == myUserId)
                .toList();
            final otherStories = storiesList
                .where((s) => s.userId != myUserId)
                .toList();

            final Map<String, List<StoryModel>> groupedOtherStories =
                groupStoriesByUser(
                  storiesList.where((s) => s.userId != myUserId).toList(),
                );

            // 3. Unique User IDs ki list nikal li taake utne hi gole (avatars) banein
            final otherUserIds = groupedOtherStories.keys.toList();

            return Scaffold(
              appBar: AppBar(title: const Text("Wink")),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. STORIES SECTION (Exact Purana Layout Structure)
                  SizedBox(
                    height: 120.h,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 1 + otherUserIds.length,
                      //otherStories.length,
                      itemBuilder: (context, index) {
                        // PEHLA ITEM: Add Story Button (Aapki original dynamic code UI)
                        if (index == 0) {
                          final bool hasStory = myStories.isNotEmpty;
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            child: GestureDetector(
                              onTap: () async {
                                if (hasStory) {
                                  // Fix click background logic attached to original route redirection
                             Navigator.push( context,MaterialPageRoute(builder: (context) =>ViewStoryScreen(stories: myStories),
                                    ),
                                  );
                                } else {
                                  NavigationService.push(context,AppRoutes.createStory);
                                }
                              },
                              child: Column(
                                children: [
                                  SingleChildScrollView(
                                    child: Stack(
                                      children: [
                                        CircleAvatar(
                                          radius: 35.r,
                                          backgroundColor: hasStory
                                              ? AppColors.primaryYellow
                                              : Colors.grey[800],
                                          child: CircleAvatar(
                                            radius: 32.r,
                                           backgroundColor: Colors.grey[900],
                                           backgroundImage: hasStory
                                                          ? (myStories.first.bytes != null
                                                          ? MemoryImage(myStories.first.bytes!,)
                                                          : myStories.first.mediaUrl.startsWith('http')
                                                          ? NetworkImage(myStories.first.mediaUrl,)
                                                          : null)
                                                  as ImageProvider?
                                                : const AssetImage('assets/placeholder.png',),
                                                  child: !hasStory
                                                ? const Icon(Icons.add,color: Colors.white,size: 25)
                                                : null,
                                          ),
                                        ),
                                        Positioned(
                                          bottom:2, // Purana perfect offset layout
                                          right: 2,
                                          child: GestureDetector(
                                            onTap: () {
                                              NavigationService.push(context,AppRoutes.createStory,);
                                            },
                                            child: CircleAvatar(
                                              radius: 11.r,
                                              backgroundColor: Colors.blue,
                                              child: const Icon(Icons.add,size: 12,color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  AppSpacing.vxs,
                                  Text(
                                    'My Story', style: TextStyle(fontSize: 13.sp),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        // BAQI ITEMS: Active Stories (Exact Purani UI hierarchy)
                        final friendId = otherUserIds[index - 1];

                        final friendStories = groupedOtherStories[friendId]!;
                        final displayStory = friendStories
                            .first; // Gole par display karne ke liye pehli story
                        return FriendStoryAvatar(
                          friendId: friendId, friendStories: friendStories,
                        );
                        //           Padding(
                        //             padding: EdgeInsets.symmetric(horizontal: 8.w),
                        //             child: GestureDetector(
                        //               onTap: () {
                        //                 Navigator.push(
                        //                   context,
                        //                   MaterialPageRoute(
                        //                     builder: (context) =>
                        //                      ViewStoryScreen(stories: friendStories)
                        //                   ),
                        //                 );
                        //               },
                        //               child: Column(
                        //                 children: [
                        //                   CircleAvatar(
                        //                     radius: 35.r,
                        //                     backgroundColor: AppColors.primaryYellow,
                        //                     child: CircleAvatar(
                        //                       radius: 32.r,
                        //                       backgroundColor: Colors.grey[900],
                        //                       backgroundImage:
                        //                       displayStory.mediaUrl.startsWith('http')
                        //                           ? NetworkImage(displayStory.mediaUrl)
                        //                           : const AssetImage('assets/placeholder.png') as ImageProvider,
                        //                       // (() {
                        //                       //   if (story.mediaUrl.startsWith('http://') ||
                        //                       //       story.mediaUrl.startsWith('https://')) {
                        //                       //     return NetworkImage(story.mediaUrl);
                        //                       //   }
                        //                       //   return const AssetImage('assets/placeholder.png') as ImageProvider;
                        //                       // })

                        //                     ),
                        //                   ),
                        //                   AppSpacing.vxs,
                        //                   friendUserAsync.when(
                        // loading: () => SizedBox(width: 10.w, height: 10.h, child: const CircularProgressIndicator(strokeWidth: 2)),
                        // error: (_, __) => Text('Friend', style: TextStyle(fontSize: 12.sp)),
                        // data: (friendUser) {
                        //   // Agar aapke user model me field name kuch aur hai (like username), toh usey friendUser.username karlein
                        //   return Text(
                        //     friendUser?.userName ?? friendUser?.name ?? 'Friend',
                        //     style: TextStyle(fontSize: 12.sp),
                        //     maxLines: 1,
                        //     overflow: TextOverflow.ellipsis,
                        //   );
                        //               })              // Text(
                        //                   //   friendUser?.userName ?? friendUser?.name ?? 'Friend',
                        //                   //   //displayStory.userName ?? 'Friend',
                        //                   //   //user.name ?? 'Profile',
                        //                   // ),
                        //                 ],
                        //               ),
                        //             ),
                        //           );
                      },
                    ),
                  ),

                  SizedBox(height: 18.h),

                  // 3. POSTS LIST
                  Expanded(
                    child: ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        return PostCard(post: posts[index]);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class FriendStoryAvatar extends ConsumerWidget {
  final String friendId;
  final List<StoryModel> friendStories;

  const FriendStoryAvatar({
    super.key,
    required this.friendId,
    required this.friendStories,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendUserAsync = ref.watch(userProvider(friendId));
    final displayStory = friendStories.first;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ViewStoryScreen(stories: friendStories),
            ),
          );
        },
        child: Column(
          children: [
            CircleAvatar(
              radius: 35.r,
              backgroundColor: AppColors.primaryYellow,
              child: CircleAvatar(
                radius: 32.r,
                backgroundColor: Colors.grey[900],
                backgroundImage: displayStory.mediaUrl.startsWith('http')
                    ? NetworkImage(displayStory.mediaUrl)
                    : const AssetImage('assets/placeholder.png')
                          as ImageProvider,
              ),
            ),
            AppSpacing.vxs,
            friendUserAsync.when(
              loading: () => SizedBox(
                width: 10.w,
                height: 10.h,
                child: const CircularProgressIndicator(strokeWidth: 2),
              ),
              error: (_, __) =>
                  Text('Friend', style: TextStyle(fontSize: 12.sp)),
              data: (friendUser) {
                return Text(
                  //friendUser?.userName ??
                  friendUser?.name ?? 'Friend',
                  style: TextStyle(fontSize: 12.sp),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

Map<String, List<StoryModel>> groupStoriesByUser(List<StoryModel> allStories) {
  Map<String, List<StoryModel>> grouped = {};
  for (var story in allStories) {
    if (!grouped.containsKey(story.userId)) {
      grouped[story.userId] = [];
    }
    grouped[story.userId]!.add(story);
  }
  return grouped;
}
