import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:wink_app/models/media_model.dart';
import 'package:wink_app/models/media_type.dart';
import 'package:wink_app/models/post_models.dart';
import 'package:wink_app/models/short_model.dart';
import 'package:wink_app/models/story_model.dart';
import 'package:wink_app/service/cloudinary_service.dart';
import 'package:wink_app/service/firestore_service.dart';
import 'package:wink_app/viewmodels/auth_viewmodel.dart';
import 'package:wink_app/viewmodels/mediaservice_provider.dart' hide cloudinaryProvider;

class UploadState {
  final bool isUploading;
  final double progress;
  final String? error;
  final String status;
  final String? message;

  const UploadState({
    this.isUploading = false,
    this.progress = 0.0,
    this.error,
    this.status = '',
    this.message,
  });

  UploadState copyWith({
    bool? isUploading,
    double? progress,
    String? error,
    String? status,
    String? message,
  }) {
    return UploadState(
      isUploading: isUploading ?? this.isUploading,
      progress: progress ?? this.progress,
      error: error,
      status: status ?? this.status,
      message: message,
    );
  }
}

class UploadViewModel extends StateNotifier<UploadState> {
  final CloudinaryService _cloudinary;
  final FirestoreService _firestore;
  final String userId;

  UploadViewModel(this._cloudinary, this._firestore, this.userId)
      : super(const UploadState());

  Future<void> uploadPost({required File image, required String caption}) async {
    if (state.isUploading) return;
    
    state = state.copyWith(
      isUploading: true,
      error: null,
      progress: 0.0,
      status: 'Uploading image...',
    );
    
    try {
      final upload = await _cloudinary.uploadFile(
        file: image,
        type: 'posts',
        userId: userId,
        onProgress: (p) => state = state.copyWith(progress: p),
      );

      final post = PostModels(
        postId: _firestore.generateId("posts"),
        userId: userId,
        caption: caption,
        hashtags: _extractHashtags(caption),
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

      state = state.copyWith(status: 'Saving...');
      await _firestore.savePost(post);
      
      state = state.copyWith(
        isUploading: false,
        progress: 1.0,
        status: 'Done',
        message: 'Post uploaded successfully',
      );
    } catch (e) {
      state = state.copyWith(
        isUploading: false,
        error: e.toString().replaceAll('Exception: ', ''),
        status: '',
      );
      rethrow;
    }
  }

  Future<void> uploadShort({
    required File video,
    required String caption,
  }) async {
    if (state.isUploading) return;
    
    state = state.copyWith(
      isUploading: true,
      error: null,
      progress: 0.0,
      status: 'Generating thumbnail...',
    );
    
    try {
      // 1. Generate thumbnail from video
      final thumbnailPath = await VideoThumbnail.thumbnailFile(
        video: video.path,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 400,
        quality: 75,
      );

      if (thumbnailPath == null) {
        throw Exception('Failed to generate thumbnail');
      }

      // 2. Upload video
      state = state.copyWith(status: 'Uploading video...', progress: 0.0);
      final videoUpload = await _cloudinary.uploadFile(
        file: video,
        type: 'shorts',
        userId: userId,
        onProgress: (p) => state = state.copyWith(progress: p * 0.7), // 70% for video
      );

      // 3. Upload thumbnail
      state = state.copyWith(status: 'Uploading thumbnail...', progress: 0.7);
      final thumbnailUpload = await _cloudinary.uploadFile(
        file: File(thumbnailPath),
        type: 'shorts_thumbs',
        userId: userId,
        onProgress: (p) => state = state.copyWith(progress: 0.7 + (p * 0.3)), // 30% for thumb
      );

      // 4. Save to Firestore with thumbnailUrl
      state = state.copyWith(status: 'Saving...', progress: 0.95);
      final short = ShortModel(
        shortId: _firestore.generateId("shorts"),
        userId: userId,
        caption: caption,
        videoUrl: videoUpload["url"]!,
        publicId: videoUpload["publicId"]!,
        thumbnailUrl: thumbnailUpload["url"]!, // Required
        likesCount: 0,
        commentsCount: 0,
        viewsCount: 0,
        createdAt: DateTime.now(),
      );

      await _firestore.saveShort(short);
      
      // 5. Clean up local thumbnail file
      await File(thumbnailPath).delete();
      
      state = state.copyWith(
        isUploading: false,
        progress: 1.0,
        status: 'Done',
        message: 'Short uploaded successfully',
      );
    } catch (e) {
      state = state.copyWith(
        isUploading: false,
        error: e.toString().replaceAll('Exception: ', ''),
        status: '',
      );
      rethrow;
    }
  }

  Future<void> uploadStory({required File file, required bool isVideo}) async {
    if (state.isUploading) return;
    
    state = state.copyWith(
      isUploading: true,
      error: null,
      progress: 0.0,
      status: 'Uploading...',
    );
    
    try {
      final upload = await _cloudinary.uploadFile(
        file: file,
        type: 'stories',
        userId: userId,
        onProgress: (p) => state = state.copyWith(progress: p),
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

      state = state.copyWith(status: 'Saving...');
      await _firestore.saveStory(story);
      
      state = state.copyWith(
        isUploading: false,
        progress: 1.0,
        status: 'Done',
        message: 'Story uploaded successfully',
      );
    } catch (e) {
      state = state.copyWith(
        isUploading: false,
        error: e.toString().replaceAll('Exception: ', ''),
        status: '',
      );
      rethrow;
    }
  }

  Future<void> uploadProfilePic({required File file}) async {
    if (state.isUploading) return;

    state = state.copyWith(
      isUploading: true,
      error: null,
      progress: 0.0,
      status: 'Uploading...',
    );

    try {
      final userDoc = await FirebaseFirestore.instance
         .collection('users')
         .doc(userId)
         .get();
      final oldPublicId = userDoc.data()?['profilePublicId'] as String?;

      final upload = await _cloudinary.uploadFile(
        file: file,
        type: 'profile',
        userId: userId,
        onProgress: (p) => state = state.copyWith(progress: p, status: 'Uploading...'),
      );

      // Delete old profile pic
      if (oldPublicId != null && oldPublicId.isNotEmpty) {
        try {
          await _cloudinary.deleteFile(oldPublicId);
        } catch (e) {
          print('Failed to delete old profile pic: $e');
        }
      }

      state = state.copyWith(status: 'Updating profile...');
      await _firestore.updateProfileImage(
        userId: userId,
        url: upload["url"]!,
        publicId: upload["publicId"]!,
      );

      state = state.copyWith(
        isUploading: false,
        progress: 1.0,
        status: 'Done',
        message: 'Profile picture updated',
      );
    } catch (e) {
      state = state.copyWith(
        isUploading: false,
        error: e.toString().replaceAll('Exception: ', ''),
        status: '',
      );
      rethrow;
    }
  }

  List<String> _extractHashtags(String text) {
    final regex = RegExp(r"#[\w\p{L}]+", unicode: true);
    return regex.allMatches(text).map((m) => m.group(0)!).toList();
  }

  void reset() => state = const UploadState();
}

final uploadProvider = StateNotifierProvider.autoDispose<UploadViewModel, UploadState>((ref) {
  final userId = ref.watch(currentUserIdProvider)!;
  return UploadViewModel(
    ref.read(cloudinaryProvider),
    ref.read(firestoreServiceProvider),
    userId,
  );
});