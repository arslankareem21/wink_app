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
    final postRef = _firestore.collection("posts").doc(post.postId);
    final userRef = _firestore.collection("users").doc(post.userId);

    batch.set(postRef, {
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
    });

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
    final shortRef = _firestore.collection("shorts").doc(short.shortId);
    final userRef = _firestore.collection("users").doc(short.userId);

    batch.set(shortRef, {
      "shortId": short.shortId,
      "userId": short.userId,
      "caption": short.caption,
      "videoUrl": short.videoUrl,
      "publicId": short.publicId,
      "likesCount": 0,
      "commentsCount": 0,
      "viewsCount": 0,
      "createdAt": FieldValue.serverTimestamp(),
    });

    batch.update(userRef, {
      "postsCount": FieldValue.increment(1),
      "updatedAt": FieldValue.serverTimestamp(),
    });

    await batch.commit();
  }

  // ---------------- STORIES ----------------
  Future<void> saveStory(StoryModel story) async {
    _checkAuth();
    await _firestore.collection("stories").doc(story.storyId).set({
      "storyId": story.storyId,
      "userId": story.userId,
      "mediaUrl": story.mediaUrl,
      "publicId": story.publicId,
      "mediaType": story.mediaType.value,
      "createdAt": FieldValue.serverTimestamp(),
      "expiresAt": Timestamp.fromDate(DateTime.now().toUtc().add(const Duration(hours: 24))),
    });
  }

  // ---------------- PROFILE ----------------
  Future<void> updateProfileImage({
    required String userId,
    required String url,
    required String publicId,
  }) async {
    _checkAuth();
    await _firestore.collection("users").doc(userId).update({
      "profileImageUrl": url,
      "profilePublicId": publicId, // optional field, doesn't break UserModel
      "updatedAt": FieldValue.serverTimestamp(),
    });
  }

  // ---------------- FOLLOW/UNFOLLOW ----------------
  Future<void> followUser(String currentUserId, String targetUserId) async {
    if (currentUserId == targetUserId) throw Exception('Cannot follow yourself');
    
    final currentUserRef = _firestore.collection("users").doc(currentUserId);
    final targetUserRef = _firestore.collection("users").doc(targetUserId);
    final followRef = currentUserRef.collection("following").doc(targetUserId);
    final followerRef = targetUserRef.collection("followers").doc(currentUserId);

    return _firestore.runTransaction((transaction) async {
      final followDoc = await transaction.get(followRef);
      if (followDoc.exists) throw Exception('Already following');

      transaction.set(followRef, {"userId": targetUserId, "followedAt": FieldValue.serverTimestamp()});
      transaction.set(followerRef, {"userId": currentUserId, "followedAt": FieldValue.serverTimestamp()});
      transaction.update(currentUserRef, {"followingCount": FieldValue.increment(1), "updatedAt": FieldValue.serverTimestamp()});
      transaction.update(targetUserRef, {"followersCount": FieldValue.increment(1), "updatedAt": FieldValue.serverTimestamp()});
    });
  }

  Future<void> unfollowUser(String currentUserId, String targetUserId) async {
    final currentUserRef = _firestore.collection("users").doc(currentUserId);
    final targetUserRef = _firestore.collection("users").doc(targetUserId);
    final followRef = currentUserRef.collection("following").doc(targetUserId);
    final followerRef = targetUserRef.collection("followers").doc(currentUserId);

    return _firestore.runTransaction((transaction) async {
      transaction.delete(followRef);
      transaction.delete(followerRef);
      transaction.update(currentUserRef, {"followingCount": FieldValue.increment(-1), "updatedAt": FieldValue.serverTimestamp()});
      transaction.update(targetUserRef, {"followersCount": FieldValue.increment(-1), "updatedAt": FieldValue.serverTimestamp()});
    });
  }

  // ---------------- LIKES ----------------
  Future<bool> isShortLiked(String shortId, String userId) async {
    final doc = await _firestore.collection('shorts').doc(shortId).collection('likes').doc(userId).get();
    return doc.exists;
  }

  Future<void> likeShort(String shortId, String userId) async {
    final shortRef = _firestore.collection('shorts').doc(shortId);
    final likeRef = shortRef.collection('likes').doc(userId);

    return _firestore.runTransaction((transaction) async {
      final likeDoc = await transaction.get(likeRef);
      if (likeDoc.exists) return;

      transaction.set(likeRef, {'likedAt': FieldValue.serverTimestamp()});
      transaction.update(shortRef, {'likesCount': FieldValue.increment(1)});
    });
  }

  Future<void> unlikeShort(String shortId, String userId) async {
    final shortRef = _firestore.collection('shorts').doc(shortId);
    final likeRef = shortRef.collection('likes').doc(userId);

    return _firestore.runTransaction((transaction) async {
      final likeDoc = await transaction.get(likeRef);
      if (!likeDoc.exists) return;

      transaction.delete(likeRef);
      transaction.update(shortRef, {'likesCount': FieldValue.increment(-1)});
    });
  }

  // ---------------- VIEWS ----------------
  Future<void> incrementShortView(String shortId, String userId) async {
    final shortRef = _firestore.collection('shorts').doc(shortId);
    final viewRef = shortRef.collection('views').doc(userId);

    return _firestore.runTransaction((transaction) async {
      final viewDoc = await transaction.get(viewRef);
      if (viewDoc.exists) return;

      transaction.set(viewRef, {'viewedAt': FieldValue.serverTimestamp()});
      transaction.update(shortRef, {'viewsCount': FieldValue.increment(1)});
    });
  }
}

final firestoreProvider = Provider<FirestoreService>((ref) => FirestoreService());