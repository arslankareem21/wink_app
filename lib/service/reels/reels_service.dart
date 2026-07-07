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
       .map((s) => s.docs.map((d) {
         final data = d.data();
         data['shortId'] = d.id; // Include document ID as shortId
         return ShortModel.fromMap(data);
       }).toList());
  }

  Future<void> incrementView(String shortId) async {
    await _db.collection('shorts').doc(shortId).update({
      'viewsCount': FieldValue.increment(1),
    });
  }

  Future<void> toggleLike({required String shortId, required String userId}) async {
    final ref = _db.collection('shorts').doc(shortId).collection('likes').doc(userId);
    final doc = await ref.get();
    doc.exists? await ref.delete() : await ref.set({'likedAt': DateTime.now()});
  }

  Future<void> toggleFollow({required String followerId, required String followingId}) async {
    final ref = _db.collection('users').doc(followerId).collection('following').doc(followingId);
    final doc = await ref.get();
    doc.exists? await ref.delete() : await ref.set({'followedAt': DateTime.now()});
  }

  Stream<Map<String, String>> watchUserInfo(String userId) {
    return _db.collection('users').doc(userId).snapshots().map((d) => {
          'username': d.data()?['username']?? '',
          'profileUrl': d.data()?['profileUrl']?? '',
        });
  }

  Stream<bool> watchIsLiked(String shortId, String userId) {
    return _db.collection('shorts').doc(shortId).collection('likes').doc(userId).snapshots().map((d) => d.exists);
  }

  Stream<bool> watchIsFollowing(String followerId, String followingId) {
    return _db.collection('users').doc(followerId).collection('following').doc(followingId).snapshots().map((d) => d.exists);
  }
}

final shortsRepositoryProvider = Provider((ref) => ShortsRepository());