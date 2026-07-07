import 'package:cloud_firestore/cloud_firestore.dart';

class ShortModel {
  final String shortId;
  final String userId;
  final String caption;
  final String videoUrl;
  final String thumbnailUrl;
  final String publicId;
  final int likesCount;
  final int commentsCount;
  final int viewsCount;
  final DateTime createdAt;

  ShortModel({
    required this.shortId,
    required this.userId,
    required this.caption,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.publicId,
    required this.likesCount,
    required this.commentsCount,
    required this.viewsCount,
    required this.createdAt,
  });

  factory ShortModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ShortModel.fromMap(data);
  }

  factory ShortModel.fromMap(Map<String, dynamic> map) {
    return ShortModel(
      shortId: map['shortId']?? '',
      userId: map['userId']?? '',
      caption: map['caption']?? '',
      videoUrl: map['videoUrl']?? '',
      thumbnailUrl: map['thumbnailUrl']?? '',
      publicId: map['publicId']?? '',
      likesCount: (map['likesCount'] as num?)?.toInt()?? 0,
      commentsCount: (map['commentsCount'] as num?)?.toInt()?? 0,
      viewsCount: (map['viewsCount'] as num?)?.toInt()?? 0,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate()?? DateTime.now(),
    );
  }
}