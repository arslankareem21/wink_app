import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wink_app/models/profile/user_model.dart';
import 'package:wink_app/service/user_service.dart';

final userServiceProvider = Provider((ref) => UserService());

final userProvider = StreamProvider.family<UserModel?, String>((ref, uid) {

  return FirebaseFirestore.instance.collection('users').doc(uid).snapshots().map((doc) {
        if (!doc.exists || doc.data() == null) return null;
        return UserModel.fromMap(doc.data()!, doc.id);
      });
});
