import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wink_app/models/profile/user_model.dart';

class UserService {
  final _db = FirebaseFirestore.instance;

  Future<UserModel?> getUser(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();

    if (!doc.exists) return null;

    return UserModel.fromMap(doc.data()!, doc.id);
  }
}