import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'package:wink_app/service/cloudinary_service.dart';
import 'package:wink_app/service/firestore_service.dart';

import '../models/post_models.dart';
import '../models/short_model.dart';
import '../models/story_model.dart';
import '../models/media_model.dart';
import '../models/media_type.dart';

final uploadProvider =
    StateNotifierProvider<UploadNotifier, UploadState>((ref) {
  return UploadNotifier(
    CloudinaryService(),
    FirestoreService(),
  );
});

class UploadState {
  final bool isUploading;
  final double progress;
  final String? message;
  final String? error;

  UploadState({
    required this.isUploading,
    required this.progress,
    this.message,
    this.error,
  });

  UploadState copyWith({
    bool? isUploading,
    double? progress,
    String? message,
    String? error,
  }) {
    return UploadState(
      isUploading: isUploading ?? this.isUploading,
      progress: progress ?? this.progress,
      message: message ?? this.message,
      error: error,
    );
  }
}

class UploadNotifier extends StateNotifier<UploadState> {
  final CloudinaryService cloudinary;
  final FirestoreService firestore;

  UploadNotifier(this.cloudinary, this.firestore)
      : super(UploadState(isUploading: false, progress: 0));

  void _start(String msg) {
    if (!mounted) return;
    state = state.copyWith(isUploading: true, progress: 0, message: msg, error: null);
  }

  void _update(double value, [String? msg]) {
    if (!mounted) return;
    state = state.copyWith(progress: value, message: msg);
  }

  void _success([String msg = "Upload successful"]) {
    if (!mounted) return;
    state = state.copyWith(isUploading: false, progress: 1, message: msg, error: null);
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) state = UploadState(isUploading: false, progress: 0);
    });
  }

  void _error(String msg) {
    if (!mounted) return;
    state = state.copyWith(isUploading: false, error: msg, message: "Upload failed");
  }

  // ---------------- POST - 1 IMAGE ONLY ----------------
  Future<void> uploadPost({
    required String userId,
    required File file,
    required String caption,
    required List<String> hashtags,
  }) async {
    _start("Uploading post...");
    try {
      final result = await cloudinary.uploadFile(
        file: file,
        folder: "wink/posts",
        isVideo: false,
        onProgress: (p) => _update(p, "Uploading image..."),
      );

      if (result == null) throw Exception("Upload failed");

      _update(0.9, "Saving post...");

      final post = PostModels(
        postId: firestore.generateId("posts"),
        userId: userId,
        caption: caption,
        hashtags: hashtags,
        media: [
          MediaModel(
            url: result["url"]!,
            publicId: result["publicId"]!,
            type: MediaType.image,
          )
        ],
        likesCount: 0,
        commentsCount: 0,
        createdAt: DateTime.now(),
      );

      await firestore.savePost(post);
      _success("Post uploaded successfully");
    } catch (e) {
      _error(e.toString());
    }
  }

  // ---------------- SHORTS ----------------
  Future<void> uploadShort({
    required String userId,
    required File video,
    required String caption,
  }) async {
    _start("Uploading short...");
    try {
      final result = await cloudinary.uploadFile(
        file: video,
        folder: "wink/shorts",
        isVideo: true,
        onProgress: (p) => _update(p, "Uploading video..."),
      );

      if (result == null) throw Exception("Upload failed");

      _update(0.9, "Saving short...");

      final short = ShortModel(
        shortId: firestore.generateId("shorts"),
        userId: userId,
        caption: caption,
        videoUrl: result["url"]!,
        publicId: result["publicId"]!,
        likesCount: 0,
        commentsCount: 0,
        viewsCount: 0,
        createdAt: DateTime.now(),
      );

      await firestore.saveShort(short);
      _success("Short uploaded successfully");
    } catch (e) {
      _error(e.toString());
    }
  }

  // ---------------- STORY ----------------
  Future<void> uploadStory({
    required String userId,
    required File file,
    required bool isVideo,
  }) async {
    _start("Uploading story...");
    try {
      final result = await cloudinary.uploadFile(
        file: file,
        folder: "wink/stories",
        isVideo: isVideo,
        onProgress: (p) => _update(p, "Uploading..."),
      );

      if (result == null) throw Exception("Upload failed");

      _update(0.9, "Saving...");

      final story = StoryModel(
        storyId: firestore.generateId("stories"),
        userId: userId,
        mediaUrl: result["url"]!,
        publicId: result["publicId"]!,
        mediaType: isVideo ? MediaType.video : MediaType.image,
        createdAt: DateTime.now(),
        expiresAt: DateTime.now().add(const Duration(hours: 24)),
      );

      await firestore.saveStory(story);
      _success("Story uploaded successfully");
    } catch (e) {
      _error(e.toString());
    }
  }

  // ---------------- PROFILE ----------------
  Future<void> updateProfile({
    required String userId,
    required File file,
  }) async {
    _start("Updating profile...");
    try {
      final result = await cloudinary.uploadFile(
        file: file,
        folder: "wink/profilepics",
        isVideo: false,
        onProgress: (p) => _update(p, "Uploading..."),
      );

      if (result == null) throw Exception("Upload failed");

      _update(0.9, "Updating...");

      await firestore.updateProfileImage(
        userId: userId,
        url: result["url"]!,
      );

      _success("Profile updated successfully");
    } catch (e) {
      _error(e.toString());
    }
  }
}