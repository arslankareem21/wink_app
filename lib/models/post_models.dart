import 'package:cloud_firestore/cloud_firestore.dart';
import 'media_model.dart';

class PostModels {
  final String postId;
  final String userId;
  final String caption;
  final List<String> hashtags;
  final List<MediaModel> media;
  final int likesCount;
  final int commentsCount;
  final DateTime? createdAt;

  PostModels({
    required this.postId,
    required this.userId,
    required this.caption,
    required this.hashtags,
    required this.media,
    required this.likesCount,
    required this.commentsCount,
    required this.createdAt,
  });

  // Helper to get first image URL safely
  String get firstImageUrl {
    if (media.isEmpty) return '';
    final img = media.firstWhere(
      (m) => m.type == 'image',
      orElse: () => media.first,
    );
    return img.url;
  }

  Map<String, dynamic> toMap() {
    return {
      "postId": postId,
      "userId": userId,
      "caption": caption,
      "hashtags": hashtags,
      "media": media.map((e) => e.toMap()).toList(),
      "likesCount": likesCount,
      "commentsCount": commentsCount,
      "createdAt": createdAt != null ? Timestamp.fromDate(createdAt!) : null,
    };
  }

  factory PostModels.fromMap(Map<String, dynamic> map) {
    return PostModels(
      postId: map["postId"]?? "",
      userId: map["userId"]?? "",
      caption: map["caption"]?? "",
      hashtags: List<String>.from(map["hashtags"]?? []),
      media: (map["media"] as List? ?? [])
          .map((e) => MediaModel.fromMap(e as Map<String, dynamic>))
          .toList(),
      likesCount: (map["likesCount"] as num?)?.toInt()?? 0,
      commentsCount: (map["commentsCount"] as num?)?.toInt()?? 0,
      createdAt: (map["createdAt"] as Timestamp?)?.toDate(),
    );
  }

  factory PostModels.fromDoc(DocumentSnapshot doc) {
    final data = doc.data();
    if (data == null) throw Exception('Post doc is null');
    return PostModels.fromMap(data as Map<String, dynamic>);
  }
}