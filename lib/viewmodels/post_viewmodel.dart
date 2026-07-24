import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wink_app/models/post_models.dart';

class PostRepository {
  final FirebaseFirestore _firestore;
  PostRepository(this._firestore);

  CollectionReference get _postsRef => _firestore.collection('posts');

  Stream<List<PostModels>> watchFeedPosts() {
    return _postsRef
        .orderBy('createdAt', descending: true)
        .limit(20)
        .snapshots()
        .map(
          (snap) => snap.docs.map((doc) => PostModels.fromDoc(doc)).toList(),
        );
  }

  /// Atomic like toggle - safe for 100 users at once
  Future<void> toggleLike({
    required String postId,
    required String userId,
  }) async {
    final postRef = _postsRef.doc(postId);
    final likeRef = postRef.collection('likes').doc(userId);

    await _firestore.runTransaction((transaction) async {
      final likeDoc = await transaction.get(likeRef);
      final postDoc = await transaction.get(postRef);

      if (!postDoc.exists) throw Exception('Post not found');

      if (likeDoc.exists) {
        transaction.delete(likeRef);
        transaction.update(postRef, {'likesCount': FieldValue.increment(-1)});
      } else {
        transaction.set(likeRef, {'likedAt': FieldValue.serverTimestamp()});
        transaction.update(postRef, {'likesCount': FieldValue.increment(1)});
      }
    });
  }

  /// Atomic save toggle
  Future<void> toggleSave({
    required String postId,
    required String userId,
  }) async {
    final saveRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('saves')
        .doc(postId);

    await _firestore.runTransaction((transaction) async {
      final saveDoc = await transaction.get(saveRef);

      if (saveDoc.exists) {
        transaction.delete(saveRef);
      } else {
        transaction.set(saveRef, {'savedAt': FieldValue.serverTimestamp()});
      }
    });
  }

  Stream<bool> watchIsLiked(String postId, String userId) {
    return _postsRef
        .doc(postId)
        .collection('likes')
        .doc(userId)
        .snapshots()
        .map((doc) => doc.exists);
  }

  Stream<bool> watchIsSaved(String postId, String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('saves')
        .doc(postId)
        .snapshots()
        .map((doc) => doc.exists);
  }
}

final postRepositoryProvider = Provider<PostRepository>((ref) {
  return PostRepository(FirebaseFirestore.instance);
});
