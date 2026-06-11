import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'cloudinary_service.dart';

class MediaService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CloudinaryService _cloudinary = CloudinaryService();

  // ---------------- POSTS ----------------
  Future<void> createPost({
    required String userId,
    required List<File> files,
    required String caption,
    required List<String> hashtags,
  }) async {
    final postRef = _firestore.collection("posts").doc();

    List<Map<String, dynamic>> mediaList = [];

    for (final file in files) {
      final upload = await _cloudinary.uploadFile(
        file: file,
        folder: "wink/posts",
        isVideo: false,
      );

      if (upload != null) {
        mediaList.add({
          "url": upload["url"],
          "publicId": upload["publicId"],
          "type": "image",
          "createdAt": FieldValue.serverTimestamp(),
        });
      }
    }

    await postRef.set({
      "postId": postRef.id,
      "userId": userId,
      "caption": caption,
      "hashtags": hashtags,
      "media": mediaList,
      "likesCount": 0,
      "commentsCount": 0,
      "createdAt": FieldValue.serverTimestamp(),

    });
  }

  // ---------------- SHORTS ----------------
  Future<void> createShort({
    required String userId,
    required File video,
    required String caption,
    
  }) async {
    final ref = _firestore.collection("shorts").doc();

    final upload = await _cloudinary.uploadFile(
      file: video,
      folder: "wink/shorts",
      isVideo: true,
    );

    if (upload == null) return;

    await ref.set({
      "shortId": ref.id,
      "userId": userId,
      "videoUrl": upload["url"],
      "publicId": upload["publicId"],
      "caption": caption,
      "likesCount": 0,
      "commentsCount": 0,
      "viewsCount": 0,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  // ---------------- STORIES ----------------
  Future<void> createStory({
    required String userId,
    required File file,
    required bool isVideo,
  }) async {
    final ref = _firestore.collection("stories").doc();

    final upload = await _cloudinary.uploadFile(
      file: file,
      folder: "wink/stories",
      isVideo: isVideo,
    );

    if (upload == null) return;

    final now = DateTime.now();

    await ref.set({
      "storyId": ref.id,
      "userId": userId,
      "mediaUrl": upload["url"],
      "publicId": upload["publicId"],
      "mediaType": isVideo ? "video" : "image",
      "createdAt": FieldValue.serverTimestamp(),
      "expiresAt": now.add(const Duration(hours: 24)),
    });
  }

  // ---------------- PROFILE IMAGE ----------------
  Future<void> updateProfilePic({
    required String userId,
    required File file,
  }) async {
    final upload = await _cloudinary.uploadFile(
      file: file,
      folder: "wink/profiles",
      isVideo: false,
    );

    if (upload == null) return;

    await _firestore.collection("users").doc(userId).update({
      "photoUrl": upload["url"],
      "photoPublicId": upload["publicId"],
    });
  }
}