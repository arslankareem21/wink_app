import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wink_app/models/media_type.dart';
import 'package:wink_app/models/post_models.dart';
import 'package:wink_app/models/short_model.dart';
import 'package:wink_app/models/story_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String generateId(String collection) => _firestore.collection(collection).doc().id;

  void _checkAuth() {
    if (FirebaseAuth.instance.currentUser == null) throw Exception('Not logged in');
  }

  // ---------------- POSTS ----------------
  Future<void> savePost(PostModels post) async {

    _checkAuth();
    final batch = _firestore.batch();
    final userRef = _firestore.collection("users").doc(post.userId);
    //1. Pehli Dafa: globalPostRef (Main Feed ke liye)
    final globalPostRef = _firestore.collection("posts").doc(post.postId);
   //2. Dusri Dafa: userPostRef (User Profile Grid ke liye)
    final userPostRef = userRef.collection("posts").doc(post.postId);


   //Firestore direct Dart objects (PostModels) nahi samajhta, woh sirf Map (Key-Value pairs)
   // samajhta hai. Isliye hum saari information ek postData Map mein tayar kar rahe hain:
    final postData = {
      "postId": post.postId,
      "userId": post.userId,
      "caption": post.caption,
      "hashtags": post.hashtags,
      "media": post.media.map((m) => {
        "url": m.url,
        "publicId": m.publicId,
        "type": "image"
      }).toList(),
      "likesCount": 0,
      "commentsCount": 0,
      "createdAt": FieldValue.serverTimestamp(),
    };

  //Kaam: Main Feed wale address par yeh poora postData Map save kar do.
    batch.set(globalPostRef, postData);
   //Kaam: User ki profile sub-collection wale address par bhi same postData Map ki copy save kar do.
    batch.set(userPostRef, postData);
   //Kaam: Main User Profile document mein 2 chote updates karo:
    batch.update(userRef, {
      "postsCount": FieldValue.increment(1),
      "updatedAt": FieldValue.serverTimestamp(),
    });
    //Yeh ek single network request mein teeno kaam (Global Post + User Post + Count Increment) ek sath commit kar deta hai.
    await batch.commit();
  }

  // // ---------------- SHORTS ----------------
Future<void> saveShort(ShortModel short) async {
  try {
    _checkAuth();

    // Safety check for empty IDs
    if (short.userId.trim().isEmpty || short.shortId.trim().isEmpty) {
      throw Exception("UserId or ShortId cannot be empty!");
    }

    final batch = _firestore.batch();
    final userRef = _firestore.collection("users").doc(short.userId);
    final globalShortRef = _firestore.collection("shorts").doc(short.shortId);
    final userShortRef = userRef.collection("shorts").doc(short.shortId);

    final shortData = {
      "shortId": short.shortId,
      "userId": short.userId,
      "caption": short.caption,
      "videoUrl": short.videoUrl,
      "publicId": short.publicId,
      "thumbnailUrl": short.thumbnailUrl,
      "likesCount": 0,
      "commentsCount": 0,
      "viewsCount": 0,
      "createdAt": FieldValue.serverTimestamp(),
    };

    batch.set(globalShortRef, shortData);
    batch.set(userShortRef, shortData);
    
    // Safely update or create user doc if missing
    batch.set(
      userRef,
      {
        "postsCount": FieldValue.increment(1),
        "updatedAt": FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );

    await batch.commit();
    print("✅ Short saved successfully!");
  } catch (e) {
    print("❌ Error saving short to Firestore: $e");
    rethrow;
  }
}

  // Future<void> saveShort(ShortModel short) async {
  //   _checkAuth();
  //   final batch = _firestore.batch();
  //   final userRef = _firestore.collection("users").doc(short.userId);
  //   final globalShortRef = _firestore.collection("shorts").doc(short.shortId);
  //   final userShortRef = userRef.collection("shorts").doc(short.shortId);

  //   final shortData = {
  //     "shortId": short.shortId,
  //     "userId": short.userId,
  //     "caption": short.caption,
  //     "videoUrl": short.videoUrl,
  //     "publicId": short.publicId,
  //     "thumbnailUrl": short.thumbnailUrl, // Save thumbnail
  //     "likesCount": 0,
  //     "commentsCount": 0,
  //     "viewsCount": 0,
  //     "createdAt": FieldValue.serverTimestamp(),
  //   };

  //   batch.set(globalShortRef, shortData);
  //   batch.set(userShortRef, shortData);
  //   batch.update(userRef, {
  //     "postsCount": FieldValue.increment(1),
  //     "updatedAt": FieldValue.serverTimestamp(),
  //   });
  //   await batch.commit();
  // }

  // ---------------- STORIES ----------------
  Future<void> saveStory(StoryModel story) async {

    _checkAuth();
    final batch = _firestore.batch();
    final globalStoryRef = _firestore.collection("stories").doc(story.storyId);
    final userStoryRef = _firestore.collection("users").doc(story.userId).collection("stories").doc(story.storyId);

    final storyData = {
      "storyId": story.storyId,
      "userId": story.userId,
      "mediaUrl": story.mediaUrl,
      "publicId": story.publicId,
      "mediaType": story.mediaType.value,
      "createdAt": FieldValue.serverTimestamp(),
      "expiresAt": Timestamp.fromDate(DateTime.now().toUtc().add(const Duration(hours: 24))),
    };

    batch.set(globalStoryRef, storyData);
    batch.set(userStoryRef, storyData);
    await batch.commit();
  }

  // ---------------- USER DATA ----------------
  Stream<DocumentSnapshot> getUserStream(String userId) {
    return _firestore.collection('users').doc(userId).snapshots();
  }

  // Read from subcollection - this is correct since you write there
  Stream<List<PostModels>> getUserPosts(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((s) => s.docs.map((d) => PostModels.fromDoc(d)).toList());
  }

  Stream<List<ShortModel>> getUserShorts(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('shorts')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((s) => s.docs.map((d) => ShortModel.fromDoc(d)).toList());
  }

  // ---------------- FOLLOW/UNFOLLOW ----------------
  
  Stream<bool> isFollowing(String currentUserId, String targetUserId) {
//Insaan khud ko follow nahi kar sakta! Agar dono IDs same hain, toh yeh seedha false ka stream 
//return kar deta hai, aage database ko query hi nahi karta.
    if (currentUserId == targetUserId) return Stream.value(false); // Can't follow self

return _firestore
    .collection('users')             // 1. Database ke 'users' folder mein jaao
    .doc(currentUserId)              // 2. Aapki apni Profile ID wale document mein jaao
    .collection('following')         // 3. Aapki profile ke andar bani 'following' list (sub-collection) mein jaao
    .doc(targetUserId)               // 4. Dusre user ki ID wala document check karo
    .snapshots()                     // 5. Live connection banao (takay jab bhi follow/unfollow ho, pata chal jaye)
    .map((doc) => doc.exists);       // 6. Final Result: Agar document mila toh true, nahi mila toh false!
  
  }

  Future<void> followUser(String currentUserId, String targetUserId) async {

    if (currentUserId == targetUserId) throw Exception('Cannot follow yourself');
    
// currentUserRef: Aapka (Logged-in user ka) main profile document.
// targetUserRef: Jis bande ko follow kar rahe hain uska main profile document.
// followRef: Aapki profile ke andar following list ka address.
// followerRef: Target user ki profile ke andar followers list ka address.
    final currentUserRef = _firestore.collection("users").doc(currentUserId);
    final targetUserRef = _firestore.collection("users").doc(targetUserId);
    final followRef = currentUserRef.collection("following").doc(targetUserId);
    final followerRef = targetUserRef.collection("followers").doc(currentUserId);


// Already Following Check: Pehle check karta hai ke kya aapne pehle se isey follow toh nahi kiya hua? Agar document mil gaya, toh error throw kar dega.
// User Existence Check: Fir check karta hai ke kya dono users ka account exist karta bhi hai ya nahi.
    return _firestore.runTransaction((transaction) async {
      final followDoc = await transaction.get(followRef);
      if (followDoc.exists) throw Exception('Already following');

      final currentUserSnap = await transaction.get(currentUserRef);
      final targetUserSnap = await transaction.get(targetUserRef);
      
      if (!currentUserSnap.exists || !targetUserSnap.exists) {
        throw Exception('User not found');
      }

      final currentUserData = currentUserSnap.data() as Map<String, dynamic>;
      final targetUserData = targetUserSnap.data() as Map<String, dynamic>;

// 1. Aapki 'following' list mein target user ki snapshot details save ho rahi hain
      transaction.set(followRef, {
        "userId": targetUserId,
        "username": targetUserData['username']?? targetUserData['userName']?? '',
        "name": targetUserData['name']?? targetUserData['displayName']?? '',
        "profileImageUrl": targetUserData['profileImageUrl']?? targetUserData['photoUrl']?? '',
        "followedAt": FieldValue.serverTimestamp(),
      });

// 2. Target user ki 'followers' list mein aapki snapshot details save ho rahi hain
      transaction.set(followerRef, {
        "userId": currentUserId,
        "username": currentUserData['username']?? currentUserData['userName']?? '',
        "name": currentUserData['name']?? currentUserData['displayName']?? '',
        "profileImageUrl": currentUserData['profileImageUrl']?? currentUserData['photoUrl']?? '',
        "followedAt": FieldValue.serverTimestamp(),
      });

      //Aapka followingCount +1
      transaction.update(currentUserRef, {
        "followingCount": FieldValue.increment(1),
        "updatedAt": FieldValue.serverTimestamp()
      });

      // Target user ka followersCount +1
      transaction.update(targetUserRef, {
        "followersCount": FieldValue.increment(1),
        "updatedAt": FieldValue.serverTimestamp()
      });
    });
  }



  Future<void> unfollowUser(String currentUserId, String targetUserId) async {
    if (currentUserId == targetUserId) return; // Can't unfollow self
// currentUserRef: Aapka main document.
// targetUserRef: Target user ka main document.
// followRef: Aapki following list mein us user ka document.
// followerRef: Us user ki followers list mein aapka document.
    final currentUserRef = _firestore.collection("users").doc(currentUserId);
    final targetUserRef = _firestore.collection("users").doc(targetUserId);
    final followRef = currentUserRef.collection("following").doc(targetUserId);
    final followerRef = targetUserRef.collection("followers").doc(currentUserId);


//Existence Check: Transaction ke andar sabse pehle dekha ja raha hai ki "Kya aap is user ko sach mein follow kar rahi hain?"
//Agar followDoc.exists false hota hai (matlab aap pehle se follow nahi kar 
//rahi) ➔ Toh transaction wahin execution stop kar deta hai.
    return _firestore.runTransaction((transaction) async {
      final followDoc = await transaction.get(followRef);
      if (!followDoc.exists) return; // Not following anyway

      transaction.delete(followRef);
      transaction.delete(followerRef);
      transaction.update(currentUserRef, {
        "followingCount": FieldValue.increment(-1),
        "updatedAt": FieldValue.serverTimestamp()
      });
      transaction.update(targetUserRef, {
        "followersCount": FieldValue.increment(-1),
        "updatedAt": FieldValue.serverTimestamp()
      });
    });
  }

  Future<void> updateProfileImage({required String userId, required String url, required String publicId}) async {
    _checkAuth();
    await _firestore.collection("users").doc(userId).update({
      "profileImageUrl": url,
      "profilePublicId": publicId,
      "updatedAt": FieldValue.serverTimestamp(),
    });
  }
}

final firestoreServiceProvider = Provider<FirestoreService>((ref) => FirestoreService());