import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wink_app/models/profile/follow_user_model.dart';

class FollowListService {
  final _db = FirebaseFirestore.instance;

  Future<List<FollowUserModel>> getFollowers(String uid) async {
    final snap = await _db
        .collection('users')
        .doc(uid)
        .collection('followers')
        .get();

    return snap.docs
        .map((e) => FollowUserModel.fromMap(e.data()))
        .toList();
  }

  Future<List<FollowUserModel>> getFollowing(String uid) async {
    final snap = await _db
        .collection('users')
        .doc(uid)
        .collection('following')
        .get();

    return snap.docs
        .map((e) => FollowUserModel.fromMap(e.data()))
        .toList();
  }
}