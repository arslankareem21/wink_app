import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wink_app/models/media_type.dart';
import 'package:wink_app/models/post_models.dart';
import 'package:wink_app/models/short_model.dart';
import 'package:wink_app/models/story_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Generate ID in global collection so both docs use same ID
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

    // 1. Global /posts - all users mixed
    batch.set(globalPostRef, postData);
    // 2. User folder /users/{uid}/posts 
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
      "likesCount": 0,
      "commentsCount": 0,
      "viewsCount": 0,
      "createdAt": FieldValue.serverTimestamp(),
    };

    // 1. Global /shorts - all users mixed
    batch.set(globalShortRef, shortData);
    // 2. User folder /users/{uid}/shorts
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
    final userStoryRef = _firestore
        .collection("users")
        .doc(story.userId)
        .collection("stories")
        .doc(story.storyId);

    final storyData = {
      "storyId": story.storyId,
      "userId": story.userId,
      "mediaUrl": story.mediaUrl,
      "publicId": story.publicId,
      "mediaType": story.mediaType.value,
      "createdAt": FieldValue.serverTimestamp(),
      "expiresAt": Timestamp.fromDate(DateTime.now().toUtc().add(const Duration(hours: 24))),
    };

    // 1. Global /stories - all users mixed
    batch.set(globalStoryRef, storyData);
    // 2. User folder /users/{uid}/stories
    batch.set(userStoryRef, storyData);

    await batch.commit();
  }

  // ---------------- POST LIKES - Update both global + user ----------------
  Future<void> togglePostLike({required String postId, required String userId}) async {
    _checkAuth();
    final globalPostRef = _firestore.collection('posts').doc(postId);
    
    final postSnap = await globalPostRef.get();
    if (!postSnap.exists) throw Exception('Post not found');
    final ownerId = postSnap.data()!['userId'] as String;
    final userPostRef = _firestore.collection('users').doc(ownerId).collection('posts').doc(postId);
    
    final likeRef = globalPostRef.collection('likes').doc(userId);

    await _firestore.runTransaction((transaction) async {
      final likeDoc = await transaction.get(likeRef);
      if (likeDoc.exists) {
        transaction.delete(likeRef);
        transaction.update(globalPostRef, {'likesCount': FieldValue.increment(-1)});
        transaction.update(userPostRef, {'likesCount': FieldValue.increment(-1)});
      } else {
        transaction.set(likeRef, {'likedAt': FieldValue.serverTimestamp()});
        transaction.update(globalPostRef, {'likesCount': FieldValue.increment(1)});
        transaction.update(userPostRef, {'likesCount': FieldValue.increment(1)});
      }
    });
  }

  Future<void> togglePostSave({required String postId, required String ownerId, required String userId}) async {
    _checkAuth();
    final saveRef = _firestore.collection('users').doc(userId).collection('saves').doc(postId);
    await _firestore.runTransaction((transaction) async {
      final saveDoc = await transaction.get(saveRef);
      if (saveDoc.exists) {
        transaction.delete(saveRef);
      } else {
        transaction.set(saveRef, {
          'savedAt': FieldValue.serverTimestamp(),
          'ownerId': ownerId,
        });
      }
    });
  }

  Stream<bool> watchPostIsLiked(String postId, String userId) {
    return _firestore
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(userId)
        .snapshots()
        .map((doc) => doc.exists);
  }

  Stream<bool> watchPostIsSaved(String postId, String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('saves')
        .doc(postId)
        .snapshots()
        .map((doc) => doc.exists);
  }

  // ---------------- SHORT LIKES/VIEWS - Update both ----------------
  Future<bool> isShortLiked(String shortId, String userId) async {
    final doc = await _firestore
        .collection('shorts')
        .doc(shortId)
        .collection('likes')
        .doc(userId)
        .get();
    return doc.exists;
  }

  Future<void> likeShort(String shortId, String userId) async {
    final globalShortRef = _firestore.collection('shorts').doc(shortId);
    final shortSnap = await globalShortRef.get();
    if (!shortSnap.exists) return;
    final ownerId = shortSnap.data()!['userId'] as String;
    final userShortRef = _firestore.collection('users').doc(ownerId).collection('shorts').doc(shortId);
    final likeRef = globalShortRef.collection('likes').doc(userId);

    return _firestore.runTransaction((transaction) async {
      final likeDoc = await transaction.get(likeRef);
      if (likeDoc.exists) return;

      transaction.set(likeRef, {'likedAt': FieldValue.serverTimestamp()});
      transaction.update(globalShortRef, {'likesCount': FieldValue.increment(1)});
      transaction.update(userShortRef, {'likesCount': FieldValue.increment(1)});
    });
  }

  Future<void> unlikeShort(String shortId, String userId) async {
    final globalShortRef = _firestore.collection('shorts').doc(shortId);
    final shortSnap = await globalShortRef.get();
    if (!shortSnap.exists) return;
    final ownerId = shortSnap.data()!['userId'] as String;
    final userShortRef = _firestore.collection('users').doc(ownerId).collection('shorts').doc(shortId);
    final likeRef = globalShortRef.collection('likes').doc(userId);

    return _firestore.runTransaction((transaction) async {
      final likeDoc = await transaction.get(likeRef);
      if (!likeDoc.exists) return;

      transaction.delete(likeRef);
      transaction.update(globalShortRef, {'likesCount': FieldValue.increment(-1)});
      transaction.update(userShortRef, {'likesCount': FieldValue.increment(-1)});
    });
  }

  Future<void> incrementShortView(String shortId, String userId) async {
    final globalShortRef = _firestore.collection('shorts').doc(shortId);
    final shortSnap = await globalShortRef.get();
    if (!shortSnap.exists) return;
    final ownerId = shortSnap.data()!['userId'] as String;
    final userShortRef = _firestore.collection('users').doc(ownerId).collection('shorts').doc(shortId);
    final viewRef = globalShortRef.collection('views').doc(userId);

    return _firestore.runTransaction((transaction) async {
      final viewDoc = await transaction.get(viewRef);
      if (viewDoc.exists) return;

      transaction.set(viewRef, {'viewedAt': FieldValue.serverTimestamp()});
      transaction.update(globalShortRef, {'viewsCount': FieldValue.increment(1)});
      transaction.update(userShortRef, {'viewsCount': FieldValue.increment(1)});
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
      "profilePublicId": publicId,
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
}

final firestoreServiceProvider = Provider<FirestoreService>((ref) => FirestoreService());