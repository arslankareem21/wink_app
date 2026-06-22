import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    final controller = VideoPlayerController.networkUrl(
      Uri.parse(state[index].videoUrl),
    );

    playableVideoControllers[index] = controller;

    try {
      await controller.initialize();
      await controller.setLooping(true);
    } catch (e) {
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

  void _playVideoAt(int index) {
    getController(index).then((controller) {
      controller.play();
    });
  }

  void _pauseVideoAt(int index) {
    playableVideoControllers[index]?.pause();
  }


// Future<void> toggleLike(int index) async {
//   final targetReel = state[index];
//   final bool originalIsLiked = targetReel.isLiked;
//   final int originalLikesCount = targetReel.likes;

//   final bool newIsLiked = !originalIsLiked;
//   final int newLikesCount = newIsLiked ? originalLikesCount + 1 : originalLikesCount - 1;

//   // 1. UI Fast update (Optimistic Update)
//   state = [
//     for (int i = 0; i < state.length; i++)
//       if (i == index) state[i].copyWith(isLiked: newIsLiked, likes: newLikesCount) else state[i]
//   ];

//   try {
//     // Current logged-in user ki id nikalen (Iske liye firebase_auth imported hona chahiye)
//     final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous_user';
    
//     // Aapke shorts/reels ki collection ka naam agar 'shorts' hai toh yahan 'shorts' likhein, agar 'reels' hai toh 'reels'
//     // Hum videoUrl ko safe document name banane ke liye sanitize kar rahe hain (special characters hata kar)
//     final String safeDocId = targetReel.videoUrl.replaceAll(RegExp(r'[^\w\s]+'), '_');

//     final reelDocRef = _firestore.collection('shorts').doc(safeDocId);
//     final likeDocRef = reelDocRef.collection('likes').doc(currentUserId);

//     final batch = _firestore.batch();

//     if (newIsLiked) {
//       // Agar user ne LIKE kiya hai:
//       // Main document mein total likes count barhaein aur isLiked true karein
//       batch.set(reelDocRef, {
//         'videoUrl': targetReel.videoUrl,
//         'likes': newLikesCount,
//         'isLiked': true,
//       }, SetOptions(merge: true));

//       // 'likes' sub-collection ke andar user ki ID ka document bana kar details save karein
//       batch.set(likeDocRef, {
//         'userId': currentUserId,
//         'timestamp': FieldValue.serverTimestamp(),
//         'liked': true,
//       });
//       print("🎯 Adding Like to Firebase Sub-collection...");
//     } else {
//       // Agar user ne UNLIKE kiya hai:
//       // Main document mein likes count kam karein
//       batch.set(reelDocRef, {
//         'likes': newLikesCount,
//         'isLiked': false,
//       }, SetOptions(merge: true));

//       // Sub-collection se us user ka nishaan (document) delete kar dein
//       batch.delete(likeDocRef);
//       print("🎯 Removing Like from Firebase Sub-collection...");
//     }

//     // Dono kaam ek sath execute karein
//     await batch.commit();
//     print("✅ Firebase mein likes ka document aur data successfully save ho gaya!");

//   } catch (e) {
//     print("❌ Firebase Sub-collection Like Failed: $e");
//     // Rollback state if failed
//     state = [
//       for (int i = 0; i < state.length; i++)
//         if (i == index) state[i].copyWith(isLiked: originalIsLiked, likes: originalLikesCount) else state[i]
//     ];
//   }
// }
//g}

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

















//   void toggleLike(int index) async{

// final targetReel = state[index];
//     final bool originalIsLiked = targetReel.isLiked;
//     final int originalLikesCount = targetReel.likes;

//     // 1. Calculate new values locally
//     final bool newIsLiked = !originalIsLiked;
//     final int newLikesCount = newIsLiked ? originalLikesCount + 1 : originalLikesCount - 1;

//     // 2. UI ko foran update karein (Optimistic Update) taake user ko lag na mehsoos ho
//     state = [
//       for (int i = 0; i < state.length; i++)
//         if (i == index)
//           state[i].copyWith(isLiked: newIsLiked, likes: newLikesCount)
//         else
//           state[i]
//     ];

//     try {
//       // 3. Firebase Firestore mein backend update bhejein
//       // Note: `targetReel.id` aapke ReelModel mein document ID honi chahiye.
//     //   await _firestore.collection('reels').doc(targetReel.id).update({
//     //     'isLiked': newIsLiked,
//     //     'likes': newLikesCount, 
//     //     // Agar aap transactional handling chahte hain toh FieldValue.increment use kar sakte hain
//     //   });
//     // } catch (e) {
//     //   print("Firebase update failed, reverting state: $e");
      
//     //   // 4. Agar network issue ya koi error aaye toh UI state ko wapis rollback kar dein
//     //   if (state.length > index && state[index].id == targetReel.id) {
//     //     state = [
//     //       for (int i = 0; i < state.length; i++)
//     //         if (i == index)
//     //           state[i].copyWith(isLiked: originalIsLiked, likes: originalLikesCount)
//     //         else
//     //           state[i]
//     //     ];
//     //   }
//     // }

//     // 3. FIX: id dhoondne ke liye hum videoUrl ka use karenge jo model mein lazmi hai
//     final querySnapshot = await _firestore
//         .collection('reels')
//         .where('videoUrl', isEqualTo: targetReel.videoUrl)
//         .get();

//     if (querySnapshot.docs.isNotEmpty) {
//       // Matching document milte hi uski auto-generated ID par update bhej dein
//       final docId = querySnapshot.docs.first.id;
      
//       await _firestore.collection('reels').doc(docId).update({
//         'isLiked': newIsLiked,
//         'likes': newLikesCount, 
//       });
//     } else {
//       print("❌ Firestore mein is videoUrl ki koi reel nahi mili.");
//     }
//   } catch (e) {
//     print("Firebase update failed, reverting state: $e");
    
//     // 4. Agar network issue aaye toh state rollback (wapis purani halat par)
//     if (state.length > index) {
//       state = [
//         for (int i = 0; i < state.length; i++)
//           if (i == index)
//             state[i].copyWith(isLiked: originalIsLiked, likes: originalLikesCount)
//           else
//             state[i]
//       ];
//     }
//   }
//   }










































// //1
// void toggleLike(int index) async {
//   final targetReel = state[index];
//   final bool originalIsLiked = targetReel.isLiked;
//   final int originalLikesCount = targetReel.likes;

//   final bool newIsLiked = !originalIsLiked;
//   final int newLikesCount = newIsLiked ? originalLikesCount + 1 : originalLikesCount - 1;

//   // 1. UI ko instant update karein (Yeh try block se bahar hai, isliye button lazmi chalega!)
//   state = [
//     for (int i = 0; i < state.length; i++)
//       if (i == index)
//         state[i].copyWith(isLiked: newIsLiked, likes: newLikesCount)
//       else
//         state[i]
//   ];

//   // 2. Firebase ka kaam alag se safe background mein hoga
//   try {
//     String? docId;

//     // Model se ID nikalne ki koshish (safe way)
//     try {
//       final reelMap = (targetReel as dynamic).toMap();
//       docId = reelMap['id'] ?? reelMap['uid'] ?? reelMap['reelId'];
//     } catch (_) {
//       // Agar toMap() nahi mila toh crash nahi hoga, code aage chalega
//     }

//     if (docId != null && docId.isNotEmpty) {
//       await _firestore.collection('reels').doc(docId).update({
//         'isLiked': newIsLiked,
//         'likes': newLikesCount,
//       });
//       print("🎯 Firebase Update Success! ID: $docId");
//     } else {
//       // Agar direct ID nahi mili, toh URL match karke document dhoondein
//       print("🔍 Searching Firebase for videoUrl...");
      
//       var querySnapshot = await _firestore
//           .collection('reels')
//           .where('videoUrl', isEqualTo: targetReel.videoUrl)
//           .get();

//       if (querySnapshot.docs.isEmpty) {
//         querySnapshot = await _firestore
//             .collection('reels')
//             .where('video_url', isEqualTo: targetReel.videoUrl)
//             .get();
//       }

//       if (querySnapshot.docs.isNotEmpty) {
//         final foundDocId = querySnapshot.docs.first.id;
//         await _firestore.collection('reels').doc(foundDocId).update({
//           'isLiked': newIsLiked,
//           'likes': newLikesCount,
//         });
//         print("🎯 Firebase Update Success via URL! ID: $foundDocId");
//       } else {
//         print("❌ ERROR: Firebase mein is URL ki koi reel nahi mili: ${targetReel.videoUrl}");
//       }
//     }

//   } catch (e) {
//     print("❌ Firebase Update Failed: $e");
    
//     // Agar sach mein Firebase fail ho jaye, toh chupke se UI wapis purani halat par le aayein
//     if (state.length > index) {
//       state = [
//         for (int i = 0; i < state.length; i++)
//           if (i == index)
//             state[i].copyWith(isLiked: originalIsLiked, likes: originalLikesCount)
//           else
//             state[i]
//       ];
//     }
//   }
// }















    // state = [
    //   for (int i = 0; i < state.length; i++)
    //     if (i == index)
    //       state[i].copyWith(isLiked: !state[i].isLiked)
    //     else
    //       state[i]
    // ];
  }


// Global Provider for View layer consumption
final reelsViewModelProvider = NotifierProvider<ReelsViewModel, List<ReelModel>>(() {
  return ReelsViewModel();
});


