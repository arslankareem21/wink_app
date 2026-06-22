import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wink_app/models/reels/reels_models.dart';
import 'package:wink_app/models/short_model.dart'; // Tumhara ReelModel

class ReelService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


// Future<void> updateLikeInFirestore(String reelId, String userId, bool isLiked) async {
//   DocumentReference docRef = FirebaseFirestore.instance.collection('reels').doc(reelId);

//   if (isLiked) {
//     // Agar pehle se liked tha, toh ab unlike karna hai (remove userId)
//     await docRef.update({
//       'likes': FieldValue.arrayRemove([userId]),
//     });
//   } else {
//     // Agar liked nahi tha, toh ab like karna hai (add userId)
//     await docRef.update({
//       'likes': FieldValue.arrayUnion([userId]),
//     });
//   }
// }



  // Future<void> updateReelLikeInFirebase({
  //   required String reelId,
  //   required bool isLiked,
  //   required int likesCount,
  //   required String videoUrl,
  // }) async {
  //   try {
  //     // 1. Pehle Direct ID se update karne ki koshish karein
  //     if (reelId.isNotEmpty) {
  //       await _firestore.collection('reels').doc(reelId).update({
  //         'isLiked': isLiked,
  //         'likes': likesCount,
  //       });
  //       print("🎯 Firebase Saved Successfully! ID: $reelId");
  //       return; // Kaam ho gaya, yahan se baahir nikal jao
  //     }

  //     // 2. Agar ID khali thi, toh Firestore mein Video URL dhoondein
  //     print("🔍 ID khali thi, videoUrl se dhoond rahe hain...");
  //     var querySnapshot = await _firestore
  //         .collection('reels')
  //         .where('videoUrl', isEqualTo: videoUrl)
  //         .get();

  //     // Agar 'videoUrl' se nahi mila, toh check karein 'video_url' name toh nahi database mein?
  //     if (querySnapshot.docs.isEmpty) {
  //       querySnapshot = await _firestore
  //           .collection('reels')
  //           .where('video_url', isEqualTo: videoUrl)
  //           .get();
  //     }

  //     // Agar document mil gaya toh update karo
  //     if (querySnapshot.docs.isNotEmpty) {
  //       final foundDocId = querySnapshot.docs.first.id;
  //       await _firestore.collection('reels').doc(foundDocId).update({
  //         'isLiked': isLiked,
  //         'likes': likesCount,
  //       });
  //       print("🎯 Firebase Saved via URL Success! ID: $foundDocId");
  //     } else {
  //       print("❌ ERROR: Database mein is URL ka koi document nahi mila: $videoUrl");
  //       throw Exception("Document not found in Firebase");
  //     }
  //   } catch (e) {
  //     print("❌ Service Layer Error: $e");
  //     rethrow; // Error aage pass karein taaki ViewModel ko pata chale
  //   }
  // }





  Future<List<ReelModel>> fetchReels() async {
    try {
      // 1. Firebase se naye videos pehle mangwaye (createdAt ke mutabiq)
      QuerySnapshot snapshot = await _firestore
          .collection('shorts')
          .get();

      // 2. Map ShortModel data into your existing ReelModel
      return snapshot.docs.map((doc) {
        // Document Snapshot ko ShortModel mein convert kiya
        ShortModel short = ShortModel.fromDoc(doc);

        // UI ki safety ke liye placeholder ya modified variables laga diye
        return ReelModel(
          videoUrl: short.videoUrl,
          username:'User_${short.userId.length > 5 ? short.userId.substring(0, 10) : short.userId}',
          caption: short.caption,
          musicName:'Original Audio',
          likes: short.likesCount,
          comments: short.commentsCount,
          shares: short.viewsCount, // Shares ki jagah views map kar diye ya jo aap sahi samjho
          profileUrl:'https://ui-avatars.com/api/?name=${short.userId}', // dynamic profile picture placeholder
          isLiked: false, // Initial state for like button
        );
      }).toList();
    } catch (e) {
      print("Firebase fetchReels mein error aaya: $e");
      return []; // Agar koi error aaye to khali list return hogi app crash nahi hoga
    }
  }

}