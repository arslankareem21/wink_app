import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wink_app/models/short_model.dart';

class ShortsRepository {
  final _db = FirebaseFirestore.instance;

  Stream<List<ShortModel>> watchShortsFeed() {
    return _db
        .collection('shorts')
        .orderBy('createdAt', descending: true)
        .limit(50)
        .snapshots()
        .map(
          (s) => s.docs.map((d) {
            final data = d.data();
            data['shortId'] = d.id; // Include document ID as shortId
            return ShortModel.fromMap(data);
          }).toList(),
        );
  }

  Future<List<ShortModel>> fetchShortsFeed() async {
    final snapshot = await _db
        .collection('shorts')
        .orderBy('createdAt', descending: true)
        .limit(50)
        .get();

    return snapshot.docs.map((d) {
      final data = d.data();
      data['shortId'] = d.id;
      return ShortModel.fromMap(data);
    }).toList();
  }

  Future<void> incrementView(String shortId) async {
    await _db.collection('shorts').doc(shortId).update({
      'viewsCount': FieldValue.increment(1),
    });
  }

  Future<void> toggleLike({
    required String shortId,
    required String userId,
  }) async {
    final shortRef = _db.collection('shorts').doc(shortId);
    final likeRef = shortRef.collection('likes').doc(userId);

    await _db.runTransaction((transaction) async {
      final likeDoc = await transaction.get(likeRef);
      final shortDoc = await transaction.get(shortRef);
      
      if (!shortDoc.exists) throw Exception('Short not found');

      if (likeDoc.exists) {
        transaction.delete(likeRef);
        final currentLikes = (shortDoc.data()?['likesCount'] as num?)?.toInt() ?? 0;
        final newLikes = currentLikes > 0 ? currentLikes - 1 : 0;
        transaction.update(shortRef, {'likesCount': newLikes});
      } else {
        transaction.set(likeRef, {'likedAt': FieldValue.serverTimestamp()});
        transaction.update(shortRef, {'likesCount': FieldValue.increment(1)});
      }
    });
  }

  Future<void> toggleFollow({
    required String followerId,
    required String followingId,
  }) async {
    final ref = _db
        .collection('users')
        .doc(followerId)
        .collection('following')
        .doc(followingId);
    final doc = await ref.get();
    doc.exists
        ? await ref.delete()
        : await ref.set({'followedAt': DateTime.now()});
  }

  Stream<Map<String, String>> watchUserInfo(String userId) {
    return _db
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((d) {
          final data = d.data() ?? {};
          final profileUrl = (data['profileUrl'] ?? data['profileImageUrl'] ?? data['photoUrl'] ?? '').toString();
          final username = (data['username'] ?? data['userName'] ?? data['displayName'] ?? '').toString();

          return {
            'username': username,
            'profileUrl': profileUrl,
          };
        });
  }

  Stream<bool> watchIsLiked(String shortId, String userId) {
    return _db
        .collection('shorts')
        .doc(shortId)
        .collection('likes')
        .doc(userId)
        .snapshots()
        .map((d) => d.exists);
  }

  Stream<bool> watchIsFollowing(String followerId, String followingId) {
    return _db
        .collection('users')
        .doc(followerId)
        .collection('following')
        .doc(followingId)
        .snapshots()
        .map((d) => d.exists);
  }
}

final shortsRepositoryProvider = Provider((ref) => ShortsRepository());
