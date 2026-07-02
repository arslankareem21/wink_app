// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:wink_app/core/config/theme/app_colors.dart';
// import 'package:wink_app/core/config/theme/app_text_style.dart';
// import 'package:wink_app/presentation/components/profile/profile_grid.dart';
// import 'package:wink_app/service/reels/reels_service.dart';
// class ProfileTabsView extends ConsumerStatefulWidget {
//   const ProfileTabsView({super.key});

//   @override
//   ConsumerState<ProfileTabsView> createState() => _ProfileTabsViewState();
// }

// class _ProfileTabsViewState extends ConsumerState<ProfileTabsView> {
//   @override
//   Widget build(BuildContext context) {
//     final myReelsAsync = ref.watch(ReelService.userReelsStreamProvider);
//     return DefaultTabController(
//       length: 2,
//       child: Column(
//         children: [
//           //  Tab Bar
//           TabBar(
//             indicatorWeight: 2.h,
//             labelColor: AppColors.primaryYellow,
//             indicatorSize: TabBarIndicatorSize.tab,
//             //unselectedLabelColor: AppColors.greyText,
//             labelStyle: AppTextStyles.sectionHeaderCaps.copyWith(
//               fontSize: 10.sp,
//             ),

//             tabs: [
//               //  TAB 1: POSTS
//               Tab(
//                 icon: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(Icons.grid_view_rounded, size: 24.sp),
//                     SizedBox(width: 3.w),
//                     Text('POSTS', style: TextStyle(fontSize: 14.sp)),
//                   ],
//                 ),
//               ),

//               //  TAB 2: SHORTS
//               //if(isOtherProfile)
//               Tab(
//                 icon: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(
//                       Icons.movie_creation_rounded, // Shorts icon
//                       size: 24.sp,
//                     ),
//                     SizedBox(width: 3.w),
//                     Text('SHORTS', style: TextStyle(fontSize: 14.sp)),
//                   ],
//                 ),
//                 // label: 'SHORTS',
//               ),

//               //tap3
//             ],
//           ),

//           Expanded(
//             child: TabBarView(
//               children: [
//                 PostsGrid(
//                   imageUrls: [
//                     ...List.generate(
//                       18,
//                       (i) => 'https://picsum.photos/300/300?random=${i + 1}',
//                     ),
//                   ],
//                 ),

//                 myReelsAsync.when(
//                   loading: () => const Center(child: CircularProgressIndicator()),
//                   error: (err, _) => Center(child: Text("Error: $err")),
//                   data: (myReels) {
//                     if (myReels.isEmpty) {
//                       return const Center(
//                         child: Text(
//                           "No Shorts Uploaded Yet", 
//                           style: TextStyle(color: Colors.grey, fontSize: 14),
//                         ),
//                       );
//                     }

//                     // Dynamic urls nikal rahe hain jo user ne upload ki hain
//                     // Agar model mein video thumbnail map 'profileUrl' hai to wo use karein, warna 'thumbnailUrl'
//                     final reelImages = myReels
//                         .map((reel) => reel.profileUrl.isNotEmpty 
//                             ? reel.profileUrl 
//                             : 'https://picsum.photos/300/300?random=default')
//                         .toList();

//                     return PostsGrid(
//                       imageUrls: reelImages, // ✅ Ab yahan automatic aapki uploaded reels aayengi
//                     );})

//                 // PostsGrid(
//                 //   imageUrls: [
//                 //     ...List.generate(
//                 //       18,
//                 //       (i) => 'https://picsum.photos/300/300?random=${i + 1}',
//                 //     ),
//                 //   ],
//                 // ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

 ///////////////////////////////////////////////////////////
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:wink_app/core/config/theme/app_colors.dart';
// import 'package:wink_app/core/config/theme/app_text_style.dart';
// import 'package:wink_app/presentation/components/profile/profile_grid.dart';
// import 'package:wink_app/service/reels/reels_service.dart';

// class ProfileTabsView extends ConsumerStatefulWidget {
//   const ProfileTabsView({super.key});

//   @override
//   ConsumerState<ProfileTabsView> createState() => _ProfileTabsViewState();
// }

// class _ProfileTabsViewState extends ConsumerState<ProfileTabsView> {
//   @override
//   Widget build(BuildContext context) {
//     // ✅ Service ke static provider se data watch kiya
//     final myReelsAsync = ref.watch(ReelService.userReelsStreamProvider);

//     return DefaultTabController(
//       length: 2,
//       child: Column(
//         children: [
//           // --- Tab Bar ---
//           TabBar(
//             indicatorWeight: 2.h,
//             labelColor: AppColors.primaryYellow,
//             indicatorSize: TabBarIndicatorSize.tab,
//             labelStyle: AppTextStyles.sectionHeaderCaps.copyWith(
//               fontSize: 10.sp,
//             ),
//             tabs: [
//               Tab(
//                 icon: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(Icons.grid_view_rounded, size: 24.sp),
//                     SizedBox(width: 3.w),
//                     Text('POSTS', style: TextStyle(fontSize: 14.sp)),
//                   ],
//                 ),
//               ),
//               Tab(
//                 icon: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(Icons.movie_creation_rounded, size: 24.sp),
//                     SizedBox(width: 3.w),
//                     Text('SHORTS', style: TextStyle(fontSize: 14.sp)),
//                   ],
//                 ),
//               ),
//             ],
//           ),

//           // --- Tab View Content ---
//           Expanded(
//             child: TabBarView(
//               children: [
//                 // TAB 1: POSTS GRID (Dummy Images)
//                 SafeArea(
//                   top: false,
//                   bottom: false,
//                   child: Builder(
//                     builder: (BuildContext context) {
//                       return CustomScrollView(
//                         key: const PageStorageKey<String>('posts'),
//                         slivers: <Widget>[
//                           SliverOverlapInjector(
//                             handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
//                           ),
//                           SliverToBoxAdapter(
//                             child: PostsGrid(
//                               imageUrls: List.generate(
//                                 18,
//                                 (i) => 'https://picsum.photos/300/300?random=${i + 1}',
//                               ),
//                             ),
//                           ),
//                         ],
//                       );
//                     },
//                   ),
//                 ),

//                 // TAB 2: SHORTS DYNAMIC GRID (Real Time Stream)
//                 SafeArea(
//                   top: false,
//                   bottom: false,
//                   child: Builder(
//                     builder: (BuildContext context) {
//                       return CustomScrollView(
//                         key: const PageStorageKey<String>('shorts'),
//                         slivers: <Widget>[
//                           SliverOverlapInjector(
//                             handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
//                           ),
//                           SliverFillRemaining(
//                             hasScrollBody: true,
//                             child: myReelsAsync.when(
//                               loading: () => const Center(child: CircularProgressIndicator()),
//                               error: (err, _) => Center(child: Text("Error: $err")),
//                               data: (myReels) {
//                                 if (myReels.isEmpty) {
//                                   return const Center(
//                                     child: Text(
//                                       "No Shorts Uploaded Yet",
//                                       style: TextStyle(color: Colors.grey, fontSize: 14),
//                                     ),
//                                   );
//                                 }

//                                 final reelImages = myReels
//                                     .map((reel) => reel.profileUrl.isNotEmpty
//                                         ? reel.profileUrl
//                                         : 'https://picsum.photos/300/300?random=default')
//                                     .toList();

//                                 // ✅ Grid Builder se wrap kiya taake click karne par Reel Open ho sake
//                                 return GridView.builder(
//                                   padding: EdgeInsets.zero,
//                                   physics: const NeverScrollableScrollPhysics(), // Nested view constraint fix
//                                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                                     crossAxisCount: 3,
//                                     crossAxisSpacing: 2,
//                                     mainAxisSpacing: 2,
//                                     childAspectRatio: 9 / 16, // Reels aspect ratio standard 9:16
//                                   ),
//                                   itemCount: reelImages.length,
//                                   itemBuilder: (context, index) {
//                                     final currentReel = myReels[index];
//                                     return GestureDetector(
//                                       onTap: () {
//                                         // 🚀 TODO: Yahan apni Reels Video Player Screen ko navigate karein
//                                         print("Clicked Reel URL: ${currentReel.videoUrl}");
                                        
//                                         /* Example Navigation:
//                                         Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                             builder: (context) => ReelPlayerScreen(reels: myReels, initialIndex: index),
//                                           ),
//                                         );
//                                         */
//                                       },
//                                       child: Image.network(
//                                         reelImages[index],
//                                         fit: BoxFit.cover,
//                                         errorBuilder: (context, error, stackTrace) {
//                                           return Container(
//                                             color: Colors.grey[900],
//                                             child: const Icon(Icons.movie_creation_rounded, color: Colors.white24),
//                                           );
//                                         },
//                                       ),
//                                     );
//                                   },
//                                 );
//                               },
//                             ),
//                           ),
//                         ],
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:wink_app/core/config/theme/app_colors.dart';
// import 'package:wink_app/core/config/theme/app_text_style.dart';
// import 'package:wink_app/presentation/components/profile/profile_grid.dart';
// import 'package:wink_app/service/reels/reels_service.dart';

// class ProfileTabsView extends ConsumerStatefulWidget {
//   const ProfileTabsView({super.key});

//   @override
//   ConsumerState<ProfileTabsView> createState() => _ProfileTabsViewState();
// }

// class _ProfileTabsViewState extends ConsumerState<ProfileTabsView> {
//   @override
//   Widget build(BuildContext context) {
//     // ✅ Service ke static provider se data watch kiya
//     final myReelsAsync = ref.watch(ReelService.userReelsStreamProvider);

//     return DefaultTabController(
//       length: 2,
//       child: Column(
//         children: [
//           // --- Tab Bar ---
//           TabBar(
//             indicatorWeight: 2.h,
//             labelColor: AppColors.primaryYellow,
//             indicatorSize: TabBarIndicatorSize.tab,
//             labelStyle: AppTextStyles.sectionHeaderCaps.copyWith(
//               fontSize: 10.sp,
//             ),
//             tabs: [
//               Tab(
//                 icon: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(Icons.grid_view_rounded, size: 24.sp),
//                     SizedBox(width: 3.w),
//                     Text('POSTS', style: TextStyle(fontSize: 14.sp)),
//                   ],
//                 ),
//               ),
//               Tab(
//                 icon: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(Icons.movie_creation_rounded, size: 24.sp),
//                     SizedBox(width: 3.w),
//                     Text('SHORTS', style: TextStyle(fontSize: 14.sp)),
//                   ],
//                 ),
//               ),
//             ],
//           ),

//           // --- Tab View Content ---
//           Expanded(
//             child: TabBarView(
//               children: [
//                 // TAB 1: POSTS GRID (Dummy Images)
//                 SafeArea(
//                   top: false,
//                   bottom: false,
//                   child: Builder(
//                     builder: (BuildContext context) {
//                       return CustomScrollView(
//                         key: const PageStorageKey<String>('posts'),
//                         slivers: <Widget>[
//                           SliverOverlapInjector(
//                             handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
//                           ),
//                           SliverToBoxAdapter(
//                             child: PostsGrid(
//                               imageUrls: List.generate(
//                                 18,
//                                 (i) => 'https://picsum.photos/300/300?random=${i + 1}',
//                               ),
//                             ),
//                           ),
//                         ],
//                       );
//                     },
//                   ),
//                 ),

//                 // TAB 2: SHORTS DYNAMIC GRID (Real Time Stream)
//                 SafeArea(
//                   top: false,
//                   bottom: false,
//                   child: Builder(
//                     builder: (BuildContext context) {
//                       return CustomScrollView(
//                         key: const PageStorageKey<String>('shorts'),
//                         slivers: <Widget>[
//                           SliverOverlapInjector(
//                             handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
//                           ),
//                           // ✅ SliverFillRemaining ko constraint se fix kiya taake empty loaders scroll freeze na karein
//                           SliverFillRemaining(
//                             hasScrollBody: true,
//                             child: myReelsAsync.when(
//                               loading: () => const Center(child: CircularProgressIndicator()),
//                               error: (err, stack) {
//                                 print("Reels loading error: $err \n $stack");
//                                 return Center(child: Text("Error: $err"));
//                               },
//                               data: (myReels) {
//                                 if (myReels.isEmpty) {
//                                   return const Center(
//                                     child: Text(
//                                       "No Shorts Uploaded Yet",
//                                       style: TextStyle(color: Colors.grey, fontSize: 14),
//                                     ),
//                                   );
//                                 }

//                                 return GridView.builder(
//                                   padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 5.h),
//                                   // ✅ Grid constraints ko badal kar shrinkWrap bypass kiya taake memory crash na ho
//                                   physics: const BouncingScrollPhysics(), 
//                                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                                     crossAxisCount: 3,
//                                     crossAxisSpacing: 3,
//                                     mainAxisSpacing: 3,
//                                     childAspectRatio: 9 / 16, 
//                                   ),
//                                   itemCount: myReels.length,
//                                   itemBuilder: (context, index) {
//   final currentReel = myReels[index];
  
//   String displayImage = '';

//   if (currentReel.profileUrl.isNotEmpty) {
//     if (currentReel.profileUrl.contains('.mp4')) {
//       // 🔄 Agar URL mein .mp4 hai, toh use .jpg thumbnail mein badal dein (Cloudinary Support)
//       displayImage = currentReel.profileUrl.replaceAll('.mp4', '.jpg');
//     } else {
//       displayImage = currentReel.profileUrl;
//     }
//   } else {
//     displayImage = 'https://picsum.photos/300/500?random=$index';
//   }

//   return GestureDetector(
//     onTap: () {
//       print("Clicked Reel Video URL: ${currentReel.videoUrl}");
//     },
//     child: Container(
//       decoration: BoxDecoration(
//         color: Colors.grey[900],
//         borderRadius: BorderRadius.circular(4.r),
//       ),
//       clipBehavior: Clip.antiAlias,
//       child: Image.network(
//         displayImage,
//         fit: BoxFit.cover,
//         loadingBuilder: (context, child, loadingProgress) {
//           if (loadingProgress == null) return child;
//           return const Center(child: CircularProgressIndicator(strokeWidth: 1));
//         },
//         errorBuilder: (context, error, stackTrace) {
//           // ⚠️ Agar extension change karne par bhi load na ho, toh static icon ya default placeholder dikhein
//           return const Center(
//             child: Icon(Icons.play_circle_fill_rounded, color: Colors.white54, size: 32),
//           );
//         },
//       ),
//     ),
//   );
// }
//                                   // itemBuilder: (context, index) {
//                                   //   final currentReel = myReels[index];
                                    
//                                   //   // ✅ FIX: Agar profileUrl ya thumbnailUrl khali hai, toh unique index generate karega crash se bachne ke liye
//                                   //   final displayImage = currentReel.profileUrl.isNotEmpty 
//                                   //       ? currentReel.profileUrl 
//                                   //       : 'https://picsum.photos/300/500?random=$index';

//                                   //   return GestureDetector(
//                                   //     onTap: () {
//                                   //       print("Clicked Reel Video URL: ${currentReel.videoUrl}");
//                                   //       // 🚀 TODO: Yahan index pass karke player screen par push karein
//                                   //     },
//                                   //     child: Container(
//                                   //       decoration: BoxDecoration(
//                                   //         color: Colors.grey[900],
//                                   //         borderRadius: BorderRadius.circular(4.r),
//                                   //       ),
//                                   //       clipBehavior: Clip.antiAlias,
//                                   //       child: Image.network(
//                                   //         displayImage,
//                                   //         fit: BoxFit.cover,
//                                   //         loadingBuilder: (context, child, loadingProgress) {
//                                   //           if (loadingProgress == null) return child;
//                                   //           return const Center(child: CircularProgressIndicator(strokeWidth: 1));
//                                   //         },
//                                   //         errorBuilder: (context, error, stackTrace) {
//                                   //           return const Center(
//                                   //             child: Icon(Icons.movie_creation_rounded, color: Colors.white24),
//                                   //           );
//                                   //         },
//                                   //       ),
//                                   //     ),
//                                   //   );
//                                   // },
//                                 );
//                               },
//                             ),
//                           ),
//                         ],
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart'; 
import 'package:wink_app/core/config/theme/app_colors.dart';
import 'package:wink_app/core/config/theme/app_text_style.dart';
import 'package:wink_app/presentation/components/profile/profile_grid.dart';
import 'package:wink_app/service/reels/reels_service.dart';
import 'package:wink_app/models/reels/reels_models.dart';

class ProfileTabsView extends ConsumerStatefulWidget {
  const ProfileTabsView({super.key,
   });

  @override
  ConsumerState<ProfileTabsView> createState() => _ProfileTabsViewState();
}

class _ProfileTabsViewState extends ConsumerState<ProfileTabsView> {
  @override
  Widget build(BuildContext context) {
    final myReelsAsync = ref.watch(ReelService.userReelsStreamProvider);

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            indicatorWeight: 2.h,
            labelColor: AppColors.primaryYellow,
            indicatorSize: TabBarIndicatorSize.tab,
            labelStyle: AppTextStyles.sectionHeaderCaps.copyWith(
              fontSize: 10.sp,
            ),
            tabs: [
              Tab(
                icon: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.grid_view_rounded, size: 24.sp),
                    SizedBox(width: 3.w),
                    Text('POSTS', style: TextStyle(fontSize: 14.sp)),
                  ],
                ),
              ),
              Tab(
                icon: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.movie_creation_rounded, size: 24.sp),
                    SizedBox(width: 3.w),
                    Text('SHORTS', style: TextStyle(fontSize: 14.sp)),
                  ],
                ),
              ),
            ],
          ),

          // --- Tab View Content ---
          Expanded(
            child: TabBarView(
              children: [
                // TAB 1: POSTS 
                SafeArea(
                  top: false,
                  bottom: false,
                  child: Builder(
                    builder: (BuildContext context) {
                      return CustomScrollView(
                        key: const PageStorageKey<String>('posts'),
                        slivers: <Widget>[
                          SliverOverlapInjector(
                            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                          ),
                          SliverToBoxAdapter(
                            child: PostsGrid(
                              imageUrls: List.generate(
                                18,
                                (i) => 'https://picsum.photos/300/300?random=${i + 1}',
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),

                // TAB 2: SHORTS 
                SafeArea(
                  top: false,
                  bottom: false,
                  child: Builder(
                    builder: (BuildContext context) {
                      return CustomScrollView(
                        key: const PageStorageKey<String>('shorts'),
                        slivers: <Widget>[
                          SliverOverlapInjector(
                            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                          ),
                          SliverFillRemaining(
                            hasScrollBody: true,
                            child: myReelsAsync.when(
                              loading: () => const Center(child: CircularProgressIndicator()),
                              error: (err, stack) {
                                print("Reels loading error: $err \n $stack");
                                return Center(child: Text("Error: $err"));
                              },
                              data: (myReels) {
                                if (myReels.isEmpty) {
                                  return const Center(
                                    child: Text(
                                      "No Shorts Uploaded Yet",
                                      style: TextStyle(color: Colors.grey, fontSize: 14),
                                    ),
                                  );
                                }

                                return GridView.builder(
                                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 5.h),
                                  physics: const BouncingScrollPhysics(), 
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 3,
                                    mainAxisSpacing: 3,
                                    childAspectRatio: 9 / 16, 
                                  ),
                                  itemCount: myReels.length,
                                  itemBuilder: (context, index) {
                                    final currentReel = myReels[index];
                                    
                                    return GestureDetector(
                                      onTap: () {
                                        print("Clicked Reel Video URL: ${currentReel.videoUrl}");
                                        //  Push to full screen player
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey[900],
                                          borderRadius: BorderRadius.circular(4.r),
                                        ),
                                        clipBehavior: Clip.antiAlias,
                                        child: ReelGridItem(reel: currentReel),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),


                          
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ReelGridItem extends StatefulWidget {
  final ReelModel reel;
  const ReelGridItem({super.key, required this.reel});

  @override
  State<ReelGridItem> createState() => _ReelGridItemState();
}

class _ReelGridItemState extends State<ReelGridItem> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // Video URL se native network controller init kiya
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.reel.videoUrl))
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            _isInitialized = true;
          });
          _controller.setLooping(true);
          _controller.setVolume(0.0); // Keep muted inside grid list
          _controller.play();
        }
      }).catchError((error) {
        print("Video rendering error inside grid element: $error");
      });
  }

  @override
  void dispose() {
    _controller.dispose(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Center(
        child: CircularProgressIndicator(strokeWidth: 1.5),
      );
    }

    return FittedBox(
      fit: BoxFit.cover,
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        width: _controller.value.size.width,
        height: _controller.value.size.height,
        child: VideoPlayer(_controller),
      ),
    );
  }
}