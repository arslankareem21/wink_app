import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:wink_app/models/reels/reels_models.dart';
import 'package:wink_app/service/reels/reels_service.dart';

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


