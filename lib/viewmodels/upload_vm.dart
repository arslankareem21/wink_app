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

// ---------------- STATE ----------------
class UploadState {
  final bool isUploading;
  final double progress;
  final String? message;

  UploadState({
    required this.isUploading,
    required this.progress,
    this.message,
  });

  UploadState copyWith({
    bool? isUploading,
    double? progress,
    String? message,
  }) {
    return UploadState(
      isUploading: isUploading ?? this.isUploading,
      progress: progress ?? this.progress,
      message: message ?? this.message,
    );
  }
}

// ---------------- NOTIFIER ----------------
class UploadNotifier extends StateNotifier<UploadState> {
  final CloudinaryService cloudinary;
  final FirestoreService firestore;

  UploadNotifier(this.cloudinary, this.firestore)
      : super(UploadState(isUploading: false, progress: 0));

  // ---------------- HELPERS ----------------
  void _start(String msg) {
    state = state.copyWith(isUploading: true, progress: 0, message: msg);
  }

  void _update(double value, [String? msg]) {
    state = state.copyWith(progress: value, message: msg);
  }

  void _finish() {
    state = state.copyWith(isUploading: false, progress: 1, message: null);
  }

  // ---------------- POST ----------------
  Future<void> uploadPost({
    required String userId,
    required List<File> files,
    required String caption,
    required List<String> hashtags,
  }) async {
    _start("Uploading post...");

    try {
      List<MediaModel> mediaList = [];

      for (int i = 0; i < files.length; i++) {
        final file = files[i];

        _update(i / files.length, "Uploading image ${i + 1}");

        final result = await cloudinary.uploadFile(
          file: file,
          folder: "wink/posts",
          isVideo: false,
        );

        if (result == null) continue;

        mediaList.add(
          MediaModel(
            url: result["url"] ?? "",
            publicId: result["publicId"] ?? "",
            type: MediaType.image,
          ),
        );
      }

      final post = PostModels(
        postId: firestore.generateId("posts"),
        userId: userId,
        caption: caption,
        hashtags: hashtags,
        media: mediaList,
        likesCount: 0,
        commentsCount: 0,
        createdAt: DateTime.now(),
      );

      await firestore.savePost(post);

      _update(1.0, "Post uploaded");
    } finally {
      _finish();
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
      _update(0.3, "Uploading video...");

      final result = await cloudinary.uploadFile(
        file: video,
        folder: "wink/shorts",
        isVideo: true,
      );

      if (result == null) return;

      _update(0.8, "Saving short...");

      final short = ShortModel(
        shortId: firestore.generateId("shorts"),
        userId: userId,
        caption: caption,
        videoUrl: result["url"] ?? "",
        publicId: result["publicId"] ?? "",
        likesCount: 0,
        commentsCount: 0,
        viewsCount: 0,
        createdAt: DateTime.now(),
      );

      await firestore.saveShort(short);

      _update(1.0, "Uploaded");
    } finally {
      _finish();
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
      _update(0.3);

      final result = await cloudinary.uploadFile(
        file: file,
        folder: "wink/stories",
        isVideo: isVideo,
      );

      if (result == null) return;

      _update(0.8);

      final story = StoryModel(
        storyId: firestore.generateId("stories"),
        userId: userId,
        mediaUrl: result["url"] ?? "",
        publicId: result["publicId"] ?? "",
        mediaType: isVideo ? MediaType.video : MediaType.image,
        createdAt: DateTime.now(),
        expiresAt: DateTime.now().add(const Duration(hours: 24)),
      );

      await firestore.saveStory(story);

      _update(1.0);
    } finally {
      _finish();
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
      );

      if (result == null) return;

      await firestore.updateProfileImage(
        userId: userId,
        url: result["url"] ?? "",
      );

      _update(1.0);
    } finally {
      _finish();
    }
  }
}