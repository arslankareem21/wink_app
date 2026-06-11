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

  Map<String, dynamic> toMap() {
    return {
      "postId": postId,
      "userId": userId,
      "caption": caption,
      "hashtags": hashtags,
      "media": media.map((e) => e.toMap()).toList(),
      "likesCount": likesCount,
      "commentsCount": commentsCount,
      "createdAt": createdAt,
    };
  }

  factory PostModels.fromMap(Map<String, dynamic> map) {
    return PostModels(
      postId: map["postId"] ?? "",
      userId: map["userId"] ?? "",
      caption: map["caption"] ?? "",
      hashtags: List<String>.from(map["hashtags"] ?? []),
      media: (map["media"] as List? ?? [])
          .map((e) => MediaModel.fromMap(e))
          .toList(),
      likesCount: map["likesCount"] ?? 0,
      commentsCount: map["commentsCount"] ?? 0,
      createdAt: map["createdAt"]?.toDate(),
    );
  }
}
