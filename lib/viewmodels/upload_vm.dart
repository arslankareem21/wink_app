//      import 'dart:io';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_riverpod/legacy.dart';
// import 'package:wink_app/models/media_model.dart';
// import 'package:wink_app/models/media_type.dart';
// import 'package:wink_app/models/post_models.dart';
// import 'package:wink_app/models/short_model.dart';
// import 'package:wink_app/models/story_model.dart';
// import 'package:wink_app/service/cloudinary_service.dart';
// import 'package:wink_app/service/firestore_service.dart';
// import 'package:wink_app/viewmodels/auth_viewmodel.dart';
// import 'package:wink_app/viewmodels/mediaservice_provider.dart';

// class UploadState {
//   final bool isUploading;
//   final double progress;
//   final String? error;
//   final String status;
//   final String? message;

//   const UploadState({
//     this.isUploading = false,
//     this.progress = 0.0,
//     this.error,
//     this.status = '',
//     this.message,
//   });

//   UploadState copyWith({
//     bool? isUploading,
//     double? progress,
//     String? error,
//     String? status,
//     String? message,
//   }) {
//     return UploadState(
//       isUploading: isUploading ?? this.isUploading,
//       progress: progress ?? this.progress,
//       error: error,
//       status: status ?? this.status,
//       message: message,
//     );
//   }
// }

// class UploadViewModel extends StateNotifier<UploadState> {
//   final CloudinaryService _cloudinary;
//   final FirestoreService _firestore;
//   final String userId;

//   UploadViewModel(this._cloudinary, this._firestore, this.userId) : super(const UploadState());

//   Future<void> uploadPost({required File image, required String caption}) async {
//     state = state.copyWith(isUploading: true, error: null, progress: 0.0, status: 'Uploading...');
//     try {
//       final upload = await _cloudinary.uploadFile(
//         file: image,
//         type: 'posts',
//         userId: userId,
//         onProgress: (p) => state = state.copyWith(progress: p),
//       );

//       final post = PostModels(
//         postId: _firestore.generateId("posts"),
//         userId: userId,
//         caption: caption,
//         hashtags: _extractHashtags(caption),
//         media: [MediaModel(url: upload["url"]!, publicId: upload["publicId"]!, type: MediaType.image)],
//         likesCount: 0,
//         commentsCount: 0,
//         createdAt: DateTime.now(),
//       );

//       await _firestore.savePost(post);
//       state = state.copyWith(isUploading: false, progress: 1.0, status: 'Done', message: 'Post uploaded');
//     } catch (e) {
//       state = state.copyWith(isUploading: false, error: e.toString().replaceAll('Exception: ', ''), status: '');
//       rethrow;
//     }
//   }

//   Future<void> uploadShort({required File video, required String caption}) async {
//     state = state.copyWith(isUploading: true, error: null, progress: 0.0, status: 'Uploading...');
//     try {
//       final upload = await _cloudinary.uploadFile(
//         file: video,
//         type: 'shorts',
//         userId: userId,
//         onProgress: (p) => state = state.copyWith(progress: p),
//       );

//       final short = ShortModel(
//         shortId: _firestore.generateId("shorts"),
//         userId: userId,
//         caption: caption,
//         videoUrl: upload["url"]!,
//         publicId: upload["publicId"]!,
//         likesCount: 0,
//         commentsCount: 0,
//         viewsCount: 0,
//         createdAt: DateTime.now(),
//       );

//       await _firestore.saveShort(short);
//       state = state.copyWith(isUploading: false, progress: 1.0, status: 'Done', message: 'Short uploaded');
//     } catch (e) {
//       state = state.copyWith(isUploading: false, error: e.toString().replaceAll('Exception: ', ''), status: '');
//       rethrow;
//     }
//   }

//   Future<void> uploadStory({required File file, required bool isVideo}) async {
//     state = state.copyWith(isUploading: true, error: null, progress: 0.0, status: 'Uploading...');
//     try {
//       final upload = await _cloudinary.uploadFile(
//         file: file,
//         type: 'stories',
//         userId: userId,
//         onProgress: (p) => state = state.copyWith(progress: p),
//       );

//       final story = StoryModel(
//         storyId: _firestore.generateId("stories"),
//         userId: userId,
//         mediaUrl: upload["url"]!,
//         publicId: upload["publicId"]!,
//         mediaType: isVideo ? MediaType.video : MediaType.image,
//         createdAt: DateTime.now(),
//         expiresAt: DateTime.now().add(const Duration(hours: 24)),
//       );

//       await _firestore.saveStory(story);
//       state = state.copyWith(isUploading: false, progress: 1.0, status: 'Done', message: 'Story uploaded');
//     } catch (e) {
//       state = state.copyWith(isUploading: false, error: e.toString().replaceAll('Exception: ', ''), status: '');
//       rethrow;
//     }
//   }

//   Future<void> uploadProfilePic({required File file}) async {
//     state = state.copyWith(isUploading: true, error: null, progress: 0.0, status: 'Uploading...');
//     try {
//       final upload = await _cloudinary.uploadFile(
//         file: file,
//         type: 'profile',
//         userId: userId,
//         onProgress: (p) => state = state.copyWith(progress: p),
//       );

//       await _firestore.updateProfileImage(userId: userId, url: upload["url"]!, publicId: upload["publicId"]!);
//       state = state.copyWith(isUploading: false, progress: 1.0, status: 'Done', message: 'Profile updated');
//     } catch (e) {
//       state = state.copyWith(isUploading: false, error: e.toString().replaceAll('Exception: ', ''), status: '');
//       rethrow;
//     }
//   }

//   List<String> _extractHashtags(String text) {
//     final regex = RegExp(r"#[\w\p{L}]+", unicode: true);
//     return regex.allMatches(text).map((m) => m.group(0)!).toList();
//   }

//   void reset() => state = const UploadState();
// }

// final uploadProvider = StateNotifierProvider.autoDispose<UploadViewModel, UploadState>((ref) {
//   final userId = ref.watch(currentUserIdProvider)!;
//   return UploadViewModel(
//     ref.read(cloudinaryProvider),
//     ref.read(firestoreProvider),
//     userId,
//   );
// });


import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/legacy.dart';
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

  UploadViewModel(this._cloudinary, this._firestore, this.userId) : super(const UploadState());

  Future<void> uploadPost({required File image, required String caption}) async {
    state = state.copyWith(isUploading: true, error: null, progress: 0.0, status: 'Uploading...');
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
        media: [MediaModel(url: upload["url"]!, publicId: upload["publicId"]!, type: MediaType.image)],
        likesCount: 0,
        commentsCount: 0,
        createdAt: DateTime.now(),
      );

      await _firestore.savePost(post);
      state = state.copyWith(isUploading: false, progress: 1.0, status: 'Done', message: 'Post uploaded');
    } catch (e) {
      state = state.copyWith(isUploading: false, error: e.toString().replaceAll('Exception: ', ''), status: '');
      rethrow;
    }
  }

  Future<void> uploadShort({required File video, required String caption}) async {
    state = state.copyWith(isUploading: true, error: null, progress: 0.0, status: 'Uploading...');
    try {
      final upload = await _cloudinary.uploadFile(
        file: video,
        type: 'shorts',
        userId: userId,
        onProgress: (p) => state = state.copyWith(progress: p),
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
      state = state.copyWith(isUploading: false, progress: 1.0, status: 'Done', message: 'Short uploaded');
    } catch (e) {
      state = state.copyWith(isUploading: false, error: e.toString().replaceAll('Exception: ', ''), status: '');
      rethrow;
    }
  }

  
  Future<void> uploadStory({required File file, required bool isVideo}) async {
    state = state.copyWith(isUploading: true, error: null, progress: 0.0, status: 'Uploading...');
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

      await _firestore.saveStory(story);
      state = state.copyWith(isUploading: false, progress: 1.0, status: 'Done', message: 'Story uploaded');
    } catch (e) {
      print("E: $e");
      state = state.copyWith(isUploading: false, error: e.toString().replaceAll('Exception: ', ''), status: '');
      rethrow;
    }
  }




//expansile widget in flutter

  Future<void> uploadProfilePic({required File file}) async {
    if (state.isUploading) return;

    state = state.copyWith(isUploading: true, error: null, progress: 0.0, status: 'Uploading...');

    try {
      // 1. Get old publicId directly from Firestore without UserModel
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      final oldPublicId = userDoc.data()?['profilePublicId'] as String?;

      // 2. Upload new file first
      final upload = await _cloudinary.uploadFile(
        file: file,
        type: 'profile',
        userId: userId,
        onProgress: (p) => state = state.copyWith(progress: p, status: 'Uploading...'),
      );

      // 3. Delete old file if exists
      if (oldPublicId != null && oldPublicId.isNotEmpty) {
        try {
          await _cloudinary.deleteFile(oldPublicId);
        } catch (e) {
          print('Failed to delete old profile pic: $e');
        }
      }

      // 4. Update Firestore
      await _firestore.updateProfileImage(
        userId: userId,
        url: upload["url"]!,
        publicId: upload["publicId"]!,
      );

      state = state.copyWith(isUploading: false, progress: 1.0, status: 'Done', message: 'Profile updated');
    } catch (e) {
      state = state.copyWith(
        isUploading: false,
        error: e.toString().replaceAll('Exception: ', ''),
        status: ''
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

final uploadProvider = StateNotifierProvider<UploadViewModel, UploadState>((ref) {
  final userId = ref.watch(currentUserIdProvider)!;
  return UploadViewModel(
    ref.read(cloudinaryProvider),
    ref.read(firestoreProvider),
    userId,
  );
});