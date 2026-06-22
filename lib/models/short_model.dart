import 'package:cloud_firestore/cloud_firestore.dart';

class ShortModel {
  final String shortId;
  final String userId;
  final String caption;
  final String videoUrl;
  final String publicId;
  final int likesCount;
  final int commentsCount;
  final int viewsCount;
  final DateTime? createdAt;

  ShortModel({
    required this.shortId,
    required this.userId,
    required this.caption,
    required this.videoUrl,
    required this.publicId,
    required this.likesCount,
    required this.commentsCount,
    required this.viewsCount,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      "shortId": shortId,
      "userId": userId,
      "caption": caption,
      "videoUrl": videoUrl,
      "publicId": publicId,
      "likesCount": likesCount,
      "commentsCount": commentsCount,
      "viewsCount": viewsCount,
      "createdAt": createdAt != null ? Timestamp.fromDate(createdAt!) : null,
    };
  }

  factory ShortModel.fromMap(Map<String, dynamic> map) {
    return ShortModel(
      shortId: map["shortId"] ?? "",
      userId: map["userId"] ?? "",
      caption: map["caption"] ?? "",
      videoUrl: map["videoUrl"] ?? "",
      publicId: map["publicId"] ?? "",
      likesCount: map["likesCount"] ?? 0,
      commentsCount: map["commentsCount"] ?? 0,
      viewsCount: map["viewsCount"] ?? 0,
      createdAt: (map["createdAt"] as Timestamp?)?.toDate(),
    );
  }

  factory ShortModel.fromDoc(DocumentSnapshot doc) {
    return ShortModel.fromMap(doc.data() as Map<String, dynamic>);
  }

  
}