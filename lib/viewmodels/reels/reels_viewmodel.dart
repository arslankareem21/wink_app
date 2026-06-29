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

//Jab user pehli dafa Reels wali screen par aata hai, toh yeh function automatically sabse pehle
// chalta hai.

//ref.onDispose: Yeh kehta hai ke jab user reels screen chor kar kisi dusri screen par jaye,
// toh saare chalte hue videos ko memory se mita do (dispose), taake mobile hang na ho.

//_loadInitialReels(): Reels mangwane ka kaam shuru karta hai.



  Future<void> _loadInitialReels() async {
    final fetchedReels = await ref.read(videoServiceProvider).fetchReels();
    state = fetchedReels;
    _preloadVideos(0, 10); // Initial batch pre-load
  }

//ReelService ko aawaaz deta hai ke "Bhai Firestore se reels lekar aao."

//state = fetchedReels: Jaise hi reels aati hain, yeh use state mein daal deta hai, jisse UI screen
// par reels nazar aane lagti hain.

//_preloadVideos(0, 10): Pehle 10 videos ko background mein pehle se load karna shuru kar deta hai.



  void _preloadVideos(int startIndex, int count) {
    for (int j = startIndex; j < startIndex + count && j < state.length; j++) {
      getController(j);
    }
  }

//Yeh loop chalata hai aur agle aane wale videos ke controllers ko pehle se call kar leta hai taake 
//jab user scroll kare, toh video bina ghumay (buffering ke) foran chal jaye.


  Future<VideoPlayerController> getController(int index) {
    if (_initializationFutures.containsKey(index)) {
      return _initializationFutures[index]!;
    }
    final videoPlayerFuture = _initializeController(index);

    _initializationFutures[index] = videoPlayerFuture;
    return videoPlayerFuture;
  }


//Jab bhi kisi video ko chalana ya preload karna ho, yeh function check karta hai: "Kya yeh video pehle
// se load ho raha hai?"

//Agar ho raha hai, toh wahi purana loading wala process return kar deta hai. Agar bilkul naya video hai,
// toh use _initializeController ke paas bhejta hai.


  Future<VideoPlayerController> _initializeController(int index) async {
  final videoUrlStr = state[index].videoUrl;
  // 1. Check agar URL khali hai toh initialize hi na karein
  if (videoUrlStr.isEmpty) {
    print("❌ Error: Index $index par video URL khali (empty) mila.");
    throw Exception("Empty video URL");
  }

  print("Initializing video for index $index: $videoUrlStr");

  final controller = VideoPlayerController.networkUrl(
    Uri.parse(videoUrlStr),
  );

  playableVideoControllers[index] = controller;

  try {
    await controller.initialize();
    await controller.setLooping(true);
  } catch (e) {
    print("ExoPlayer Exception at index $index: $e");
    playableVideoControllers.remove(index);
    _initializationFutures.remove(index);
    rethrow;
  }
  return controller;
}


//Yeh internet ke link (videoUrl) ko uthata hai aur asli VideoPlayerController banata hai.
//controller.initialize() internet se video ka kacha data load karta hai aur setLooping(true) video ko baar-baar loop mein chalata hai.


  void onPageChanged(int index) {
    // Current index ko memory mein update karein taake screen badalne par yaad rahe
    focusedIndex = index;
    _playVideoAt(index); // Naya video chalao

    if (index > 0) {_pauseVideoAt(index - 1); }
    if (index < state.length - 1) { _pauseVideoAt(index + 1);}

    // 4th video par agle 5 buffer honge
    if ((index + 2) % 5 == 0) {
      int nextBatchStart = index + 2;
      _preloadVideos(nextBatchStart, 5);
    }
  }

//Jab user upar ya niche scroll karta hai, toh yeh function batata hai ke ab kya karna hai:

//Jis page par user aaya hai, use _playVideoAt(index) se play karta hai.

//Pichle (index - 1) aur agle (index + 1) video ko pause rakhta hai taake aawaazein mix na hon.

//Smart Logic: Jab user scroll karte karte har 5th video ke qareeb pohonchta hai, toh yeh background mein chupke
// se agle 5 videos mazeed preload kar leta hai.



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

//Jab user profile ya home par scroll up karke refresh karta hai, toh yeh purane saare video players ko cleanly delete 
//karta hai, data network se dobara mangwata hai aur pehle video se dobara kahani shuru karta hai.


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

//Yeh dono intehai seedhe functions hain. Ek ka kaam controller dhoond kar video ko .play() 
//bolna hai, aur dusre ka kaam controller pakad kar .pause() bolna hai.


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
    print("Step 1: Firebase mein chal raha document dhoond rahe hain... URL: ${targetReel.videoUrl}");

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
      print("Step 2: Document mil gaya! Asli ID hai: $existingDocId");

      // Reference: shorts -> [Usi puraane document ki ID]
      final reelDocRef = _firestore.collection('shorts').doc(existingDocId);
      // Reference: shorts -> [Usi puraane document ki ID] -> likes (Sub-Collection) -> [User_ID]
      final likeCollectionDocRef = reelDocRef.collection('likes').doc(currentUserId);
      final batch = _firestore.batch();
      if (newIsLiked) {
        // Main document ke andar total likes ka counter update karein
        batch.update(reelDocRef, {'likes': newLikesCount,});
        // 'likes' ki collection ke andar user ka naya document banayein
        batch.set(likeCollectionDocRef, {'userId': currentUserId,'timestamp': FieldValue.serverTimestamp(),'liked': true, });
        print("Step 3: Puraane document ke andar 'likes' collection mein data chala gaya.");
      } else {
        // Unlike karne par counter kam karein
        batch.update(reelDocRef, {'likes': newLikesCount,});
        // Sub-collection se us user ka document udaa (delete) dein
        batch.delete(likeCollectionDocRef);
        print("Step 3: 'likes' collection se data remove ho gaya.");
      }

      // Batch execute karein
      await batch.commit();
      print("Success! Har naye/purane document ke andar alag se 'likes' collection ban rahi hai.");

    } else {
      print("Error: Firebase mein is short video ka koi document hi nahi mila. Pehle video sahi se upload karein.");
    }
  } catch (e) {
    print("Error saving like to existing document collection: $e");
    // Fail hone par UI wapis normal karein
    state = [
      for (int i = 0; i < state.length; i++)
        if (i == index) state[i].copyWith(isLiked: originalIsLiked, likes: originalLikesCount) else state[i]
    ];
  }
}

//background mein yeh Firestore se video dhoondta hai, uski sub-collection likes ke andar aapki user ID ka ek naya document set kar 
//deta hai (agar like kiya ho) ya delete kar deta hai (agar unlike kiya ho), aur main counter ko update kar deta hai.

//Catch Block: Agar internet fail ho jaye, toh yeh catch block mein ja kar screen par se like hata kar wapas purana count show kar deta hai.


}
// Global Provider for View layer consumption
final reelsViewModelProvider = NotifierProvider<ReelsViewModel, List<ReelModel>>(() {
  return ReelsViewModel();
});


