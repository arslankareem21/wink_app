// import 'dart:async';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_riverpod/legacy.dart';
// import 'package:video_player/video_player.dart';
// import 'package:wink_app/service/reels/video_controller_manager.dart';
// import 'package:wink_app/service/reels/reels_service.dart';
// import 'package:wink_app/service/reels/controller-health-service.dart';
// import 'package:wink_app/service/reels/network-service.dart';

// import '../../models/short_model.dart';

// class ShortsState {
//   final List<ShortModel> shorts;
//   final int currentIndex;
//   final bool loading;
//   final String? error;

//   const ShortsState({
//     this.shorts = const [],
//     this.currentIndex = 0,
//     this.loading = true,
//     this.error,
//   });

//   ShortsState copyWith({
//     List<ShortModel>? shorts,
//     int? currentIndex,
//     bool? loading,
//     String? error,
//   }) {
//     return ShortsState(
//       shorts: shorts?? this.shorts,
//       currentIndex: currentIndex?? this.currentIndex,
//       loading: loading?? this.loading,
//       error: error,
//     );
//   }
// }

// class ShortsViewModel extends StateNotifier<ShortsState> {
//   ShortsViewModel(this._repo) : super(const ShortsState()) {
//     _initialize();
//   }

//   final ShortsRepository _repo;
//   final VideoControllerManager video = VideoControllerManager.instance;
//   StreamSubscription<List<ShortModel>>? _sub;
//   final Map<String, bool> _optimisticLikes = {}; // Local state for optimistic updates

//   String get currentUserId =>
//       FirebaseAuth.instance.currentUser?.uid?? "";

//   void _initialize() {
//     // Start health monitoring
//     ControllerHealthService.instance.start();
    
//     // Initialize network retry service
//     NetworkRetryService.instance.init();
    
//     _listen();
//   }


// void _listen() {
//   _sub?.cancel();
//   _sub = _repo.watchShortsFeed().listen((list) async {
//     final isFirstLoad = state.shorts.isEmpty;
//     final previousIndex = state.currentIndex;

//     // State Update
//     state = state.copyWith(shorts: list, loading: false);

//     if (list.isNotEmpty) {
//       // 1. Cache URLs
//       for (int i = 0; i < list.length; i++) {
//         ControllerHealthService.instance.cacheUrl(i, list[i].videoUrl);
//       }
      
//       // 2. Agar PEHLI BAAR load ho raha hai, tabhi index 0 set karo.
//       // Agar streaming ke waqt naya data aaye, toh current user ka index kharab mat hone do.
//       if (isFirstLoad) {
//         await video.onPageChanged(
//           newIndex: 0,
//           urls: list.map((e) => e.videoUrl).toList(),
//         );
//         state = state.copyWith(currentIndex: 0);
//       } else {
//         // Safe index check taake index out of bounds na ho
//         final targetIndex = previousIndex < list.length ? previousIndex : 0;
//         await video.onPageChanged(
//           newIndex: targetIndex,
//           urls: list.map((e) => e.videoUrl).toList(),
//         );
//       }
//     }
//   }, onError: (e) {
//     state = state.copyWith(
//       loading: false,
//       error: e.toString(),
//     );
//   });
// }
//   // void _listen() {
//   //   _sub?.cancel();
//   //   _sub = _repo.watchShortsFeed().listen((list) async {
//   //     state = state.copyWith(shorts: list, loading: false);

//   //     if (list.isNotEmpty) {
//   //       // Cache URLs in health service for recovery
//   //       for (int i = 0; i < list.length; i++) {
//   //         ControllerHealthService.instance.cacheUrl(i, list[i].videoUrl);
//   //       }
        
//   //       // Let manager handle autoplay + preload
//   //       await video.onPageChanged(
//   //         newIndex: 0,
//   //         urls: list.map((e) => e.videoUrl).toList(),
//   //       );
//   //       state = state.copyWith(currentIndex: 0);
//   //     }
//   //   }, onError: (e) {
//   //     state = state.copyWith(
//   //       loading: false,
//   //       error: e.toString(),
//   //     );
//   //   });
//   // }

//   Future<void> onPageChanged(int index) async {
//     if (index < 0 || index >= state.shorts.length) return;

//     state = state.copyWith(currentIndex: index);

//     // Cache current and nearby URLs
//     for (int i = index - 2; i <= index + 4; i++) {
//       if (i >= 0 && i < state.shorts.length) {
//         ControllerHealthService.instance.cacheUrl(i, state.shorts[i].videoUrl);
//       }
//     }

//     // Manager handles everything now
//     await video.onPageChanged(
//       newIndex: index,
//       urls: state.shorts.map((e) => e.videoUrl).toList(),
//     );

//     unawaited(_repo.incrementView(state.shorts[index].shortId));
//   }

//   // Removed _preload - manager handles it

//   VideoPlayerController? controller(int index)
//       => video.controller(index);

//   bool isLoading(int index)=>video.isLoading(index);
//   bool hasError(int index)=>video.hasError(index);
//   bool isBuffering(int index)=>video.isBuffering(index);

//   Future<void> toggleVideo(int index)=>video.toggle(index);

//   Future<void> pauseAll()=>video.pauseAll();

//   Future<void> resumeCurrent()=>video.resume(state.currentIndex);

//   Future<void> like(int index) async {
//     if(currentUserId.isEmpty)return;
//     if(index < 0 || index >= state.shorts.length) return;
    
//     final shortId = state.shorts[index].shortId;
    
//     // Optimistic update - toggle local state immediately
//     _optimisticLikes[shortId] = !(_optimisticLikes[shortId] ?? false);
    
//     // Update UI immediately
//     state = state.copyWith();
    
//     // Then update Firebase in background
//     try {
//       await _repo.toggleLike(
//         shortId: shortId,
//         userId: currentUserId,
//       );
//     } catch (e) {
//       // Revert on failure
//       _optimisticLikes.remove(shortId);
//       state = state.copyWith();
//       debugPrint('Like failed: $e');
//     }
//   }
  
//   bool isLikedOptimistic(String shortId) {
//     return _optimisticLikes[shortId] ?? false;
//   }

//   Future<void> follow(String userId) async {
//     if(currentUserId.isEmpty)return;
//     if(userId==currentUserId)return;

//     await _repo.toggleFollow(
//       followerId: currentUserId,
//       followingId: userId,
//     );
//   }

//   @override
//   void dispose() {
//     _sub?.cancel();
//     ControllerHealthService.instance.stop();
//     NetworkRetryService.instance.dispose();
//     video.disposeAll();
//     super.dispose();
//   }
// }

// final shortsViewModelProvider =
// StateNotifierProvider<ShortsViewModel, ShortsState>((ref){
//   return ShortsViewModel(
//     ref.watch(shortsRepositoryProvider),
//   );
// });

// final userInfoProvider =
// StreamProvider.family<Map<String,String>,String>((ref,id){
//   return ref.watch(shortsRepositoryProvider)
//      .watchUserInfo(id);
// });

// final isLikedProvider =
// StreamProvider.family<bool,String>((ref,id){
//   final uid=FirebaseAuth.instance.currentUser?.uid?? "";
//   return ref.watch(shortsRepositoryProvider)
//      .watchIsLiked(id,uid);
// });

// final isFollowingProvider =
// StreamProvider.family<bool,String>((ref,id){
//   final uid=FirebaseAuth.instance.currentUser?.uid?? "";
//   return ref.watch(shortsRepositoryProvider)
//      .watchIsFollowing(uid,id);
// });


///ARSALAN WORK


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:wink_app/models/reels/reels_models.dart';
import 'package:wink_app/viewmodels/reels/reel_service.dart';

// Service Provider
final videoServiceProvider = Provider((ref) => ReelService());

// State holds the list of Reels
class ReelsViewModel extends Notifier<List<ReelModel>> {
  final Map<int, VideoPlayerController> playableVideoControllers = {};
  final Map<int, Future<VideoPlayerController>> _initializationFutures = {};
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // Is variable mein hum current chalne wali reel ka index hamesha save rakhenge
  int focusedIndex = 0;
late PageController _pageController;
  @override
  List<ReelModel> build() {
    ref.onDispose(() {
      for (var controller in playableVideoControllers.values) {
        controller.dispose();
      }
    });
    
    _loadInitialReels();
    return [];
  }

  Future<void> _loadInitialReels() async {
    final fetchedReels = await ref.read(videoServiceProvider).fetchReels();
    state = fetchedReels;
    _preloadVideos(0, 10); // Initial batch pre-load
  }

  void _preloadVideos(int startIndex, int count) {
    for (int j = startIndex; j < startIndex + count && j < state.length; j++) {
      getController(j);
    }
  }

  Future<VideoPlayerController> getController(int index) {
    if (_initializationFutures.containsKey(index)) {
      return _initializationFutures[index]!;
    }

    final videoPlayerFuture = _initializeController(index);
    _initializationFutures[index] = videoPlayerFuture;
    return videoPlayerFuture;
  }

  Future<VideoPlayerController> _initializeController(int index) async {
  final videoUrlStr = state[index].videoUrl;

  // 1. Check agar URL khali hai toh initialize hi na karein
  if (videoUrlStr.isEmpty) {
    print("❌ Error: Index $index par video URL khali (empty) mila.");
    throw Exception("Empty video URL");
  }

  print("🎥 Initializing video for index $index: $videoUrlStr");

  final controller = VideoPlayerController.networkUrl(
    Uri.parse(videoUrlStr),
  );

  playableVideoControllers[index] = controller;

  try {
    await controller.initialize();
    await controller.setLooping(true);
  } catch (e) {
    print("❌ ExoPlayer Exception at index $index: $e");
    playableVideoControllers.remove(index);
    _initializationFutures.remove(index);
    rethrow;
  }
  return controller;
}

  void onPageChanged(int index) {
    // Current index ko memory mein update karein taake screen badalne par yaad rahe
    focusedIndex = index;

    _playVideoAt(index);

    if (index > 0) {
      _pauseVideoAt(index - 1);
    }

    if (index < state.length - 1) {
      _pauseVideoAt(index + 1);
    }

    // 4th video par agle 5 buffer honge
    if ((index + 2) % 5 == 0) {
      int nextBatchStart = index + 2;
      _preloadVideos(nextBatchStart, 5);
    }
  }

Future<void> refreshReels() async {
 try {
    print("🔄 Fetching fresh data from network...");
    
    // 1. Pehle network se naya data lekar variables mein save karein (State abhi change nahi hui)
    final fetchedReels = await ref.read(videoServiceProvider).fetchReels();
    
    // 2. Naya data aane ke BAAD purane video controllers ko cleanly dispose karein
    await disposeAllControllers();
    focusedIndex = 0;
    
    // 3. AB state badlein taake UI direct purani list se nayi list par switch ho (Beech mein .isEmpty na ho)
    state = fetchedReels;
    
    // 4. Naye videos preload karein
    _preloadVideos(0, 10);
    
    print("✅ Full sync done!");
  } catch (e) {
    print("❌ Error in refreshReels: $e");
    rethrow;
  }
}





  Future<void> disposeAllControllers() async {
    for (var controller in playableVideoControllers.values) {
      await controller.dispose();
    }
    playableVideoControllers.clear();
    _initializationFutures.clear();
  }

  void _playVideoAt(int index) {
    getController(index).then((controller) {
      controller.play();
    });
  }

  void _pauseVideoAt(int index) {
    playableVideoControllers[index]?.pause();
  }





Future<void> toggleLike(int index) async {
  final targetReel = state[index];
  final bool originalIsLiked = targetReel.isLiked;
  final int originalLikesCount = targetReel.likes;

  final bool newIsLiked = !originalIsLiked;
  final int newLikesCount = newIsLiked ? originalLikesCount + 1 : originalLikesCount - 1;

  // 1. UI ko instantly update karein (Optimistic Update)
  state = [
    for (int i = 0; i < state.length; i++)
      if (i == index) state[i].copyWith(isLiked: newIsLiked, likes: newLikesCount) else state[i]
  ];

  try {
    final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous_user';

    print("🔍 Step 1: Firebase mein chal raha document dhoond rahe hain... URL: ${targetReel.videoUrl}");

    // 2. Pehle query chala kar check karein ke is video ka document kis ID se save hai
    var querySnapshot = await _firestore
        .collection('shorts')
        .where('videoUrl', isEqualTo: targetReel.videoUrl)
        .get();

    // Backup check agar field ka naam database mein snake_case (video_url) ho
    if (querySnapshot.docs.isEmpty) {
      querySnapshot = await _firestore
          .collection('shorts')
          .where('video_url', isEqualTo: targetReel.videoUrl)
          .get();
    }

    if (querySnapshot.docs.isNotEmpty) {
      // Pehle se mojood document ki asli Firebase ID nikal li
      final String existingDocId = querySnapshot.docs.first.id;
      print("🎯 Step 2: Document mil gaya! Asli ID hai: $existingDocId");

      // Reference: shorts -> [Usi puraane document ki ID]
      final reelDocRef = _firestore.collection('shorts').doc(existingDocId);
      
      // Reference: shorts -> [Usi puraane document ki ID] -> likes (Sub-Collection) -> [User_ID]
      final likeCollectionDocRef = reelDocRef.collection('likes').doc(currentUserId);

      final batch = _firestore.batch();

      if (newIsLiked) {
        // Main document ke andar total likes ka counter update karein
        batch.update(reelDocRef, {
          'likes': newLikesCount,
        });

        // 'likes' ki collection ke andar user ka naya document banayein
        batch.set(likeCollectionDocRef, {
          'userId': currentUserId,
          'timestamp': FieldValue.serverTimestamp(),
          'liked': true,
        });
        print("🚀 Step 3: Puraane document ke andar 'likes' collection mein data chala gaya.");
      } else {
        // Unlike karne par counter kam karein
        batch.update(reelDocRef, {
          'likes': newLikesCount,
        });

        // Sub-collection se us user ka document udaa (delete) dein
        batch.delete(likeCollectionDocRef);
        print("🚀 Step 3: 'likes' collection se data remove ho gaya.");
      }

      // Batch execute karein
      await batch.commit();
      print("✅ Success! Har naye/purane document ke andar alag se 'likes' collection ban rahi hai.");

    } else {
      print("❌ Error: Firebase mein is short video ka koi document hi nahi mila. Pehle video sahi se upload karein.");
    }

  } catch (e) {
    print("❌ Error saving like to existing document collection: $e");
    
    // Fail hone par UI wapis normal karein
    state = [
      for (int i = 0; i < state.length; i++)
        if (i == index) state[i].copyWith(isLiked: originalIsLiked, likes: originalLikesCount) else state[i]
    ];
  }
}














  }


// Global Provider for View layer consumption
final reelsViewModelProvider = NotifierProvider<ReelsViewModel, List<ReelModel>>(() {
  return ReelsViewModel();
});