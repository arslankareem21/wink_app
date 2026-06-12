import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:wink_app/models/media_model.dart';
import 'package:wink_app/models/media_type.dart';

import 'package:wink_app/models/post_models.dart';
import 'package:wink_app/models/short_model.dart';
import 'package:wink_app/models/story_model.dart';
import 'package:wink_app/service/media_service.dart';
import 'package:wink_app/viewmodels/auth_viewmodel.dart';

/// PROVIDE SERVICE
final mediaServiceProvider = Provider<MediaService>((ref) {
  return MediaService();
});




// shortsstreamprovider 

final shortStreamProvider = StreamProvider.autoDispose<List<ShortModel>>((ref) {
  final uid = ref.watch(currentUserIdProvider);
  if (uid == null) return Stream.value([]);

  return FirebaseFirestore.instance
     .collection("shorts")
     .orderBy("createdAt", descending: true)
     .limit(10)
     .snapshots()
     .map((snapshot) {
        return snapshot.docs
           .map((doc) {
              final data = doc.data();
              
              // Skip docs with empty videoUrl
              final videoUrl = data['videoUrl'] as String??'';
              if (videoUrl.isEmpty) return null;

              return ShortModel(
                shortId: doc.id,
                userId: data['userId']?? '',
                caption: data['caption']?? '',
                videoUrl: videoUrl,
                publicId: data['publicId']?? '',
                likesCount: data['likesCount']?? 0,
                commentsCount: data['commentsCount']?? 0,
                viewsCount: data['viewsCount']?? 0,
                createdAt: (data['createdAt'] as Timestamp).toDate(),
              );
            })
           .whereType<ShortModel>() // Remove nulls
           .toList();
      });
});


// ---------------- SINGLE POST STREAM ----------------
final postsStreamProvider = StreamProvider.autoDispose<List<PostModels>>((ref) {
  final uid = ref.watch(currentUserIdProvider);
  if (uid == null) return Stream.value([]);

  return FirebaseFirestore.instance
     .collection('posts')
     .orderBy('createdAt', descending: true)
     .limit(50)
     .snapshots()
     .map((snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data();

          // Only keep IMAGE media, ignore any video that sneaked in
          final mediaList = (data['media'] as List<dynamic>?? [])
             .map((m) => MediaModel(
                    url: m['url']?? '',
                    publicId: m['publicId']?? '',
                    type: MediaType.image, // Force image for posts
                  ))
             .where((m) => m.url.isNotEmpty)
             .toList();

          return PostModels(
            postId: doc.id,
            userId: data['userId']?? '',
            caption: data['caption']?? '',
            hashtags: List<String>.from(data['hashtags']?? []),
            media: mediaList,
            likesCount: data['likesCount']?? 0,
            commentsCount: data['commentsCount']?? 0,
            createdAt: (data['createdAt'] as Timestamp).toDate(),
          );
        })
        .where((post) => post.media.isNotEmpty) // Hide posts with no valid images
        .toList();
      });
});

//storry stream provider

final storyStreamProvider = StreamProvider.autoDispose.family<List<StoryModel>, String>((ref, userId) {
  final uid = ref.watch(currentUserIdProvider);
  if (uid == null) return Stream.value([]);

  final now = DateTime.now();

  return FirebaseFirestore.instance
     .collection('stories')
     .where('userId', isEqualTo: userId)
     .where('expiresAt', isGreaterThan: Timestamp.fromDate(now)) // Only active stories
     .orderBy('expiresAt')
     .orderBy('createdAt', descending: true)
     .snapshots()
     .map((snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data();
          final mediaUrl = data['mediaUrl'] as String?? '';
          if (mediaUrl.isEmpty) return null;

          // Trust the mediaType saved in Firestore, but default to image
          final mediaTypeStr = data['mediaType'] as String?? 'image';
          final mediaType = mediaTypeStr == 'video' 
             ? MediaType.video 
              : MediaType.image;

          return StoryModel(
            storyId: doc.id,
            userId: data['userId']?? '',
            mediaUrl: mediaUrl,
            publicId: data['publicId']?? '',
            mediaType: mediaType, // Can be video OR image
            createdAt: (data['createdAt'] as Timestamp).toDate(),
            expiresAt: (data['expiresAt'] as Timestamp).toDate(),
          );
        })
        .whereType<StoryModel>()
        .toList();
      });
});