import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wink_app/models/post_models.dart';

import '../models/short_model.dart';
import '../models/story_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String generateId(String collection) {
    return _db.collection(collection).doc().id;
  }

  // ---------------- POST ----------------
  Future<void> savePost(PostModels post) async {
    await _db.collection("posts").doc(post.postId).set(
          post.toMap(), // ✅ correct
        );
  }

  // ---------------- SHORT ----------------
  Future<void> saveShort(ShortModel short) async {
    await _db.collection("shorts").doc(short.shortId).set(
          short.toMap(),
        );
  }

  // ---------------- STORY ----------------
  Future<void> saveStory(StoryModel story) async {
    await _db.collection("stories").doc(story.storyId).set(
          story.toMap(),
        );
  }

  // ---------------- PROFILE ----------------
  Future<void> updateProfileImage({
    required String userId,
    required String url,
  }) async {
    await _db.collection("users").doc(userId).update({
      "profileImage": url,
    });
  }
}