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
    final globalPostRef = _firestore.collection("posts").doc(post.postId);
    final userPostRef = userRef.collection("posts").doc(post.postId);

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

    batch.set(globalPostRef, postData);
    batch.set(userPostRef, postData);
    batch.update(userRef, {
      "postsCount": FieldValue.increment(1),
      "updatedAt": FieldValue.serverTimestamp(),
    });
    await batch.commit();
  }

  // ---------------- SHORTS ----------------
  Future<void> saveShort(ShortModel short) async {
    _checkAuth();
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
      "thumbnailUrl": short.thumbnailUrl, // Save thumbnail
      "likesCount": 0,
      "commentsCount": 0,
      "viewsCount": 0,
      "createdAt": FieldValue.serverTimestamp(),
    };

    batch.set(globalShortRef, shortData);
    batch.set(userShortRef, shortData);
    batch.update(userRef, {
      "postsCount": FieldValue.increment(1),
      "updatedAt": FieldValue.serverTimestamp(),
    });
    await batch.commit();
  }

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
    if (currentUserId == targetUserId) return Stream.value(false); // Can't follow self
    return _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('following')
        .doc(targetUserId)
        .snapshots()
        .map((doc) => doc.exists);
  }

  Future<void> followUser(String currentUserId, String targetUserId) async {
    if (currentUserId == targetUserId) throw Exception('Cannot follow yourself');
    
    final currentUserRef = _firestore.collection("users").doc(currentUserId);
    final targetUserRef = _firestore.collection("users").doc(targetUserId);
    final followRef = currentUserRef.collection("following").doc(targetUserId);
    final followerRef = targetUserRef.collection("followers").doc(currentUserId);

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

      transaction.set(followRef, {
        "userId": targetUserId,
        "username": targetUserData['username']?? targetUserData['userName']?? '',
        "name": targetUserData['name']?? targetUserData['displayName']?? '',
        "profileImageUrl": targetUserData['profileImageUrl']?? targetUserData['photoUrl']?? '',
        "followedAt": FieldValue.serverTimestamp(),
      });

      transaction.set(followerRef, {
        "userId": currentUserId,
        "username": currentUserData['username']?? currentUserData['userName']?? '',
        "name": currentUserData['name']?? currentUserData['displayName']?? '',
        "profileImageUrl": currentUserData['profileImageUrl']?? currentUserData['photoUrl']?? '',
        "followedAt": FieldValue.serverTimestamp(),
      });

      transaction.update(currentUserRef, {
        "followingCount": FieldValue.increment(1),
        "updatedAt": FieldValue.serverTimestamp()
      });
      transaction.update(targetUserRef, {
        "followersCount": FieldValue.increment(1),
        "updatedAt": FieldValue.serverTimestamp()
      });
    });
  }

  Future<void> unfollowUser(String currentUserId, String targetUserId) async {
    if (currentUserId == targetUserId) return; // Can't unfollow self
    
    final currentUserRef = _firestore.collection("users").doc(currentUserId);
    final targetUserRef = _firestore.collection("users").doc(targetUserId);
    final followRef = currentUserRef.collection("following").doc(targetUserId);
    final followerRef = targetUserRef.collection("followers").doc(currentUserId);

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