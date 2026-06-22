import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. Riverpod Provider jo UI ko is service ka access dega
final editProfileServiceProvider = Provider<EditProfileService>((ref) {
  return EditProfileService();
});

// 2. Service Class jo actual Firestore operation handle karegi
class EditProfileService {
  // Firebase Firestore ka instance
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Yeh function users collection mein data update karega
  Future<void> updateProfile({
    required String uid,
    required String name,
    required String username,
    required String bio,
    required String website,
  }) async {
    try {
      // Input data ko check karna ke empty strings database mein ajeeb na lagayen
      await _db.collection('users').doc(uid).update({
        'displayName': name,
        'username': username.toLowerCase().trim(), // Username safe formatting ke sath
        'bio': bio,
        'website': website.trim(),
      });
    } catch (e) {
      print("Error in EditProfileService: $e");
      throw Exception("Failed to update profile data in Firestore: $e");
    }
  }
}