import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class EditProfileService {
  final _db = FirebaseFirestore.instance;

  Future<void> updateProfile({
    required String uid,
    required String displayName,
    required String username,
    required String bio,
    required String website,
  }) async {
    await _db.collection('users').doc(uid).update({
      'displayName': displayName,
      'username': username.toLowerCase().trim(), 
      'bio': bio,
      'website': website,
    });
  }

void isUsernameTakenProvider = FutureProvider.family<bool, String>((ref, username) async {
  if (username.isEmpty || username.length < 3)
   return false;
  
  final querySnapshot = await FirebaseFirestore.instance
      .collection('users') // Make sure this matches your Firestore collection name
      .where('username', isEqualTo: username.toLowerCase())
      .limit(1)
      .get();

  return querySnapshot.docs.isNotEmpty;
});


}