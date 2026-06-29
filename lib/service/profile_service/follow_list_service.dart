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


//Yeh Firestore mein users -> [uid] -> followers wali sub-collection ke andar jati hai.

//.get() ke zariye un saare logon ka data mangwati hai jinhone is user ko follow kiya hua hai.

    return snap.docs
        .map((e) => FollowUserModel.fromMap(e.data()))
        .toList();

//Phir un saare documents ko map karke FollowUserModel (jo aapki model class hai, jisme naam, picture hoti hai) ki ek saaf-suthri List bana kar return kar deti hai.

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