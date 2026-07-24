import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wink_app/models/auth/user_model.dart';
import 'package:wink_app/models/post_models.dart';
import 'package:wink_app/models/short_model.dart';
import 'package:wink_app/models/story_model.dart';
import 'package:wink_app/service/cloudinary_service.dart';
import 'package:wink_app/service/firestore_service.dart';
import 'package:wink_app/viewmodels/auth_viewmodel.dart';



//Database(Firestore) -> Providers -> UI (Screens).

// Providers - ONLY THESE 2
final cloudinaryProvider = Provider((ref) => CloudinaryService());
final firestoreProvider = Provider((ref) => FirestoreService());

// FOR SHORTS SCREEN
final shortStreamProvider = StreamProvider.autoDispose<List<ShortModel>>((ref) {
  final uid = ref.watch(currentUserIdProvider);
  if (uid == null) return Stream.value([]);

  return FirebaseFirestore.instance
      .collection("shorts")
      .orderBy("createdAt", descending: true)
      .limit(10)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) {
            try {
              return ShortModel.fromDoc(doc);
            } catch (_) {
              return null;
            }
          })
          .whereType<ShortModel>()
          .where((s) => s.videoUrl.isNotEmpty)
          .toList());
});

// FOR HOME FEED
final postsStreamProvider = StreamProvider.autoDispose<List<PostModels>>((ref) {
  final uid = ref.watch(currentUserIdProvider);
  if (uid == null) return Stream.value([]);

  return FirebaseFirestore.instance
      .collection('posts')
      .orderBy('createdAt', descending: true)
      .limit(50)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) {
            try {
              return PostModels.fromDoc(doc);
            } catch (_) {
              return null;
            }
          })
          .whereType<PostModels>()
          .where((p) => p.media.isNotEmpty)
          .toList());
});

// FOR STORIES
final storyStreamProvider = StreamProvider.autoDispose.family<List<StoryModel>, String>((ref, userId) {
  final now = DateTime.now();
  return FirebaseFirestore.instance
      .collection('stories')
      .where('userId', isEqualTo: userId)
      .where('expiresAt', isGreaterThan: Timestamp.fromDate(now))
      .orderBy('expiresAt')
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) {
            try {
              return StoryModel.fromDoc(doc);
            } catch (_) {
              return null;
            }
          })
          .whereType<StoryModel>()
          .where((s) => s.mediaUrl.isNotEmpty)
          .toList());
});

// LIVE USER DATA
final userByIdProvider = StreamProvider.family<UserModel?, String>((ref, userId) {
  return FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .snapshots()
      .map((doc) => doc.exists ? UserModel.fromDoc(doc) : null);
});

// FOLLOW STATUS
final isFollowingProvider = StreamProvider.family<bool, String>((ref, targetUserId) {
  final currentUserId = ref.watch(currentUserIdProvider);
  if (currentUserId == null) return Stream.value(false);

  return FirebaseFirestore.instance
      .collection('users')
      .doc(currentUserId)
      .collection('following')
      .doc(targetUserId)
      .snapshots()
      .map((doc) => doc.exists);
});