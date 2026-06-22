


import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wink_app/models/story_model.dart';

class StoryRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Firestore mein document save karne ka clean module
  Future<void> uploadStoryToFirestore(StoryModel story) async {
    await _firestore.collection('stories').doc(story.storyId).set(story.toMap());
  }

  // Realtime Active Stories Fetch karne ki Stream (Filter: Not Expired)
  Stream<List<StoryModel>> getActiveStoriesStream() {
    return _firestore
        .collection('stories')
        .where('expiresAt', isGreaterThan: Timestamp.fromDate(DateTime.now()))
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => StoryModel.fromDoc(doc)).toList();
    });
  }
}