// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:wink_app/models/reels/reels_models.dart';

// import 'package:wink_app/models/short_model.dart'; // Tumhara ReelModel

// class ReelService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;



// // final userReelsStreamProvider = StreamProvider.autoDispose<List<ReelModel>>((ref) {
// //   final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
  
// //   return FirebaseFirestore.instance
// //       .collection('reels') // Aapka collection name jo bhi ho
// //       .where('userId', isEqualTo: currentUserId) // Sirf aapki uploaded reels filter hongi
// //       .snapshots()
// //       .map((snapshot) => snapshot.docs
// //           .map((doc) => ReelModel.fromMap(doc.data()))
// //           .toList());
// // });

// final userReelsStreamProvider = StreamProvider.autoDispose<List<ReelModel>>((ref) {
//   final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
  
//   return FirebaseFirestore.instance
//       .collection('shorts') // ✅ Kyunki fetchReels mein aap 'shorts' collection use kar rahe hain
//       .where('userId', isEqualTo: currentUserId) // Sirf current user ki videos filters hongi
//       .snapshots()
//       .map((snapshot) => snapshot.docs.map((doc) {
//             // ✅ Map karne ke liye ShortModel use karein jese niche kiya hai
//             ShortModel short = ShortModel.fromDoc(doc);

//             // Phir usey ReelModel mein convert karke return karein
//             return ReelModel(
//               videoUrl: short.videoUrl,
//               username: 'User_${short.userId.length > 5 ? short.userId.substring(0, 5) : short.userId}',
//               caption: short.caption,
//               musicName: 'Original Audio',
//               likes: short.likesCount,
//               comments: short.commentsCount,
//               shares: short.viewsCount, 
//               profileUrl: 'https://ui-avatars.com/api/?name=${short.userId}', 
//               isLiked: false, 
//             );
//           }).toList());
// });



//   Future<List<ReelModel>> fetchReels() async {
//     try {
//       // 1. Firebase se naye videos pehle mangwaye (createdAt ke mutabiq)
//       QuerySnapshot snapshot = await _firestore
//           .collection('shorts')
//           .get();

//       // 2. Map ShortModel data into your existing ReelModel
//       return snapshot.docs.map((doc) {
//         // Document Snapshot ko ShortModel mein convert kiya
//         ShortModel short = ShortModel.fromDoc(doc);

//         // UI ki safety ke liye placeholder ya modified variables laga diye
//         return ReelModel(
//           videoUrl: short.videoUrl,
//           username:'User_${short.userId.length > 5 ? short.userId.substring(0, 10) : short.userId}',
//           caption: short.caption,
//           musicName:'Original Audio',
//           likes: short.likesCount,
//           comments: short.commentsCount,
//           shares: short.viewsCount, // Shares ki jagah views map kar diye ya jo aap sahi samjho
//           profileUrl:'https://ui-avatars.com/api/?name=${short.userId}', // dynamic profile picture placeholder
//           isLiked: false, // Initial state for like button
//         );
//       }).toList();
//     } catch (e) {
//       print("Firebase fetchReels mein error aaya: $e");
//       return []; // Agar koi error aaye to khali list return hogi app crash nahi hoga
//     }
//   }

// }



// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:wink_app/models/reels/reels_models.dart';
// import 'package:wink_app/models/short_model.dart'; 

// class ReelService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   // ✅ static lagane se yeh class ke andar hi rahega aur doosri screens par call ho sakega
//   static final userReelsStreamProvider = StreamProvider.autoDispose<List<ReelModel>>((ref) {
//     final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
    
//     return FirebaseFirestore.instance
//         .collection('shorts') // 'shorts' collection se data ayega
//         .where('userId', isEqualTo: currentUserId) // Sirf aapki uploaded reels filter hongi
//         .snapshots()
//         .map((snapshot) => snapshot.docs.map((doc) {
//               // Document Snapshot ko ShortModel mein convert kiya
//               ShortModel short = ShortModel.fromDoc(doc);

//               // Phir usey ReelModel mein convert karke return kiya
//               return ReelModel(
//                 videoUrl: short.videoUrl,
//                 username: 'User_${short.userId.length > 5 ? short.userId.substring(0, 5) : short.userId}',
//                 caption: short.caption,
//                 musicName: 'Original Audio',
//                 likes: short.likesCount,
//                 comments: short.commentsCount,
//                 shares: short.viewsCount, 
//                 profileUrl: 'https://ui-avatars.com/api/?name=${short.userId}', 
//                 isLiked: false, 
//               );
//             }).toList());
//   });

//   // Aapka purana fetchReels function
//   Future<List<ReelModel>> fetchReels() async {
//     try {
//       QuerySnapshot snapshot = await _firestore.collection('shorts').get();

//       return snapshot.docs.map((doc) {
//         ShortModel short = ShortModel.fromDoc(doc);

//         return ReelModel(
//           videoUrl: short.videoUrl,
//           username: 'User_${short.userId.length > 5 ? short.userId.substring(0, 10) : short.userId}',
//           caption: short.caption,
//           musicName: 'Original Audio',
//           likes: short.likesCount,
//           comments: short.commentsCount,
//           shares: short.viewsCount, 
//           profileUrl: 'https://ui-avatars.com/api/?name=${short.userId}', 
//           isLiked: false, 
//         );
//       }).toList();
//     } catch (e) {
//       print("Firebase fetchReels mein error aaya: $e");
//       return []; 
//     }
//   }
// }

                                                                   //////////222222222222222222222

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:wink_app/models/reels/reels_models.dart';
// import 'package:wink_app/models/short_model.dart'; 

// class ReelService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   static final userReelsStreamProvider = StreamProvider<List<ReelModel>>((ref) {
//     final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
    
//     print("Fetching reels for user: $currentUserId"); // 👈 Debug log

//     return FirebaseFirestore.instance
//         .collection('shorts') 
//         .where('userId', isEqualTo: currentUserId) 
//         .snapshots()
//         .map((snapshot) {
//           print("Total documents found in Firestore: ${snapshot.docs.length}"); // 👈 Debug log

//           return snapshot.docs.map((doc) {
//             ShortModel short = ShortModel.fromDoc(doc);

//             // ⚡ NOTE: Agar ShortModel mein thumbnail ka link ho toh 'short.videoUrl' ya us field ko profileUrl ki jagah pass karein.
//             // Abhi ke liye hum unique random thumbnail urls bana rahe hain jo image load karein.
//             final thumbnail = (short.videoUrl.isNotEmpty) 
//                 ? 'https://picsum.photos/300/500?random=${short.shortId ?? doc.id}' 
//                 : 'https://ui-avatars.com/api/?name=${short.userId}';

//             return ReelModel(
//               videoUrl: short.videoUrl,
//               username: 'User_${short.userId.length > 5 ? short.userId.substring(0, 5) : short.userId}',
//               caption: short.caption,
//               musicName: 'Original Audio',
//               likes: short.likesCount,
//               comments: short.commentsCount,
//               shares: short.viewsCount, 
//               profileUrl: thumbnail, // 👈 Yahan flat text avatar ke bajaye visual string link diya
//               isLiked: false, 
//             );
//           }).toList();
//         });
//   });

//   // Purana fetchReels function
//   Future<List<ReelModel>> fetchReels() async {
//     try {
//       QuerySnapshot snapshot = await _firestore.collection('shorts').get();

//       return snapshot.docs.map((doc) {
//         ShortModel short = ShortModel.fromDoc(doc);

//         return ReelModel(
//           videoUrl: short.videoUrl,
//           username: 'User_${short.userId.length > 5 ? short.userId.substring(0, 10) : short.userId}',
//           caption: short.caption,
//           musicName: 'Original Audio',
//           likes: short.likesCount,
//           comments: short.commentsCount,
//           shares: short.viewsCount, 
//           profileUrl: 'https://picsum.photos/300/500?random=${doc.id}', 
//           isLiked: false, 
//         );
//       }).toList();
//     } catch (e) {
//       print("Firebase fetchReels mein error aaya: $e");
//       return []; 
//     }
//   }
// }


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wink_app/models/reels/reels_models.dart';
import 'package:wink_app/models/short_model.dart'; 

class ReelService {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ✅ autoDispose hata diya taake data state cache mein save rahe aur tab badalne par destroy na ho
  //Yeh aapki apni profile par reels ko live (Stream) dikhane ke liye hai.
  // snapshots() ki wajah se jaise hi aap koi naye reel upload karengi, yeh khud hi
  // bina page refresh kiye screen par show kar degi.
  static final userReelsStreamProvider = StreamProvider<List<ReelModel>>((ref) {
  final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
  
    print("Fetching reels for user: $currentUserId"); // Debug log

    return FirebaseFirestore.instance
        .collection('shorts') 
        .where('userId', isEqualTo: currentUserId) 
        .snapshots()
        .map((snapshot) {
          print("Total documents found in Firestore: ${snapshot.docs.length}"); // Debug log

          return snapshot.docs.map((doc) {
            ShortModel short = ShortModel.fromDoc(doc);

            final thumbnail = (short.videoUrl.isNotEmpty) 
                ? 'https://picsum.photos/300/500?random=${short.shortId ?? doc.id}' 
                : 'https://ui-avatars.com/api/?name=${short.userId}';

            return ReelModel(
              videoUrl: short.videoUrl,
              username: 'User_${short.userId.length > 5 ? short.userId.substring(0, 5) : short.userId}',
              caption: short.caption,
              musicName: 'Original Audio',
              likes: short.likesCount,
              comments: short.commentsCount,
              shares: short.viewsCount, 
              profileUrl: thumbnail, 
              isLiked: false,
               userID: short.userId, 
            );
          }).toList();
        });
  });


//Yeh normal tarike se pure network se saari reels ko aik dafa khinch kar lata hai.
// Purana fetchReels function
  Future<List<ReelModel>> fetchReels() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('shorts').get();

      return snapshot.docs.map((doc) {
        ShortModel short = ShortModel.fromDoc(doc);

        return ReelModel(
          videoUrl: short.videoUrl,
          username: 'User_${short.userId.length > 5 ? short.userId.substring(0, 10) : short.userId}',
          caption: short.caption,
          musicName: 'Original Audio',
          likes: short.likesCount,
          comments: short.commentsCount,
          shares: short.viewsCount, 
          profileUrl: 'https://picsum.photos/300/500?random=${doc.id}', 
          isLiked: false, userID: short.userId, 
        );
      }).toList();
    } catch (e) {
      print("Firebase fetchReels mein error aaya: $e");
      return []; 
    }
  }

// Family provider taake hum kisi bhi user ki id pass karke uski reels stream kar sakein
 static final otherUserReelsStreamProvider = StreamProvider.family<List<ReelModel>, String>((ref, userId) {
  return FirebaseFirestore.instance
      .collection('shorts')
      .where('userId', isEqualTo: userId)
      .snapshots()
      .map((snapshot) {
        return snapshot.docs.map((doc) {
          ShortModel short = ShortModel.fromDoc(doc);
          return ReelModel(
            videoUrl: short.videoUrl,
            username: 'User_${short.userId.length > 5 ? short.userId.substring(0, 5) : short.userId}',
            caption: short.caption,
            musicName: 'Original Audio',
            likes: short.likesCount,
            comments: short.commentsCount,
            shares: short.viewsCount, 
            profileUrl: short.videoUrl, // Passing video url for ReelGridItem
            isLiked: false, userID: short.userId, 
          );
        }).toList();
      });
}
);

}