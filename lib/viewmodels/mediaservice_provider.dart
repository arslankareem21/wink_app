import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:wink_app/models/post_models.dart';
import 'package:wink_app/models/short_model.dart';
import 'package:wink_app/service/media_service.dart';

/// PROVIDE SERVICE
final mediaServiceProvider = Provider<MediaService>((ref) {
  return MediaService();
});







final postStreamProvider = StreamProvider<List<PostModels>>((ref) {
  final stream = FirebaseFirestore.instance
      .collection("posts")
      .orderBy("createdAt", descending: true)
      .snapshots();

  return stream.map((snapshot) {
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return PostModels.fromMap(data);
    }).toList();
  });
});




final shortStreamProvider = StreamProvider<List<ShortModel>>((ref) {
  final stream = FirebaseFirestore.instance
      .collection("shorts")
      .orderBy("createdAt", descending: true)
      .snapshots();

  return stream.map((snapshot) {
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return ShortModel.fromMap(data);
    }).toList();
  });
});


