import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wink_app/models/media_model.dart';
import 'package:wink_app/models/media_type.dart';
import 'package:wink_app/models/post_models.dart';
import 'package:wink_app/models/short_model.dart';
import 'package:wink_app/models/story_model.dart';
import 'package:wink_app/service/cloudinary_service.dart';
import 'package:wink_app/service/firestore_service.dart';

class MediaService {
  final CloudinaryService _cloudinary;
  final FirestoreService _firestore;

  MediaService(this._cloudinary, this._firestore);

  Future<void> createPost({
    required String userId,
    required File image,
    required String caption,
    required List<String> hashtags,
  }) async {
    final upload = await _cloudinary.uploadFile(
      file: image,
      type: 'posts',
      userId: userId,
    );

    final post = PostModels(
      postId: _firestore.generateId("posts"),
      userId: userId,
      caption: caption,
      hashtags: hashtags,
      media: [
        MediaModel(
          url: upload["url"]!,
          publicId: upload["publicId"]!,
          type: MediaType.image,
        )
      ],
      likesCount: 0,
      commentsCount: 0,
      createdAt: DateTime.now(),
    );

    await _firestore.savePost(post);
  }

  Future<void> createShort({
    required String userId,
    required File video,
    required String caption,
  }) async {
    final upload = await _cloudinary.uploadFile(
      file: video,
      type: 'shorts',
      userId: userId,
    );

    final short = ShortModel(
      shortId: _firestore.generateId("shorts"),
      userId: userId,
      caption: caption,
      videoUrl: upload["url"]!,
      publicId: upload["publicId"]!,
      likesCount: 0,
      commentsCount: 0,
      viewsCount: 0,
      createdAt: DateTime.now(),
    );

    await _firestore.saveShort(short);
  }

  Future<void> createStory({
    required String userId,
    required File file,
    required bool isVideo,
  }) async {
    final upload = await _cloudinary.uploadFile(
      file: file,
      type: 'stories',
      userId: userId,
    );

    final story = StoryModel(
      storyId: _firestore.generateId("stories"),
      userId: userId,
      mediaUrl: upload["url"]!,
      publicId: upload["publicId"]!,
      mediaType: isVideo ? MediaType.video : MediaType.image,
      createdAt: DateTime.now(),
      expiresAt: DateTime.now().add(const Duration(hours: 24)),
    );

    await _firestore.saveStory(story);
  }

  Future<void> updateProfilePic({
    required String userId,
    required File file,
  }) async {
    final upload = await _cloudinary.uploadFile(
      file: file,
      type: 'profile',
      userId: userId,
    );

    await _firestore.updateProfileImage(
      userId: userId,
      url: upload["url"]!,
      publicId: upload["publicId"]!,
    );
  }

  Future<void> followUser(String currentUserId, String targetUserId) {
    return _firestore.followUser(currentUserId, targetUserId);
  }

  Future<void> unfollowUser(String currentUserId, String targetUserId) {
    return _firestore.unfollowUser(currentUserId, targetUserId);
  }
}

final mediaServiceProvider = Provider((ref) {
  return MediaService(
    ref.read(cloudinaryProvider),
    ref.read(firestoreProvider),
  );
});