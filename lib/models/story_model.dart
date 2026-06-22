import 'package:cloud_firestore/cloud_firestore.dart';
import 'media_type.dart';

class StoryModel {
  final String storyId;
  final String userId;
  final String mediaUrl;
  final String publicId;
  final MediaType mediaType;
  final DateTime? createdAt;
  final DateTime? expiresAt;

  StoryModel({
    required this.storyId,
    required this.userId,
    required this.mediaUrl,
    required this.publicId,
    required this.mediaType,
    required this.createdAt,
    required this.expiresAt,
  });

  Map<String, dynamic> toMap() {
    return {
      "storyId": storyId,
      "userId": userId,
      "mediaUrl": mediaUrl,
      "publicId": publicId,
      "mediaType": mediaType.value,
      "createdAt": createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      "expiresAt": expiresAt != null ? Timestamp.fromDate(expiresAt!) : null,
    };
  }

  factory StoryModel.fromMap(Map<String, dynamic> map) {
    return StoryModel(
      storyId: map["storyId"] ?? "",
      userId: map["userId"] ?? "",
      mediaUrl: map["mediaUrl"] ?? "",
      publicId: map["publicId"] ?? "",
      mediaType: MediaTypeX.fromString(map["mediaType"] ?? "image"),
      createdAt: (map["createdAt"] as Timestamp?)?.toDate(),
      expiresAt: (map["expiresAt"] as Timestamp?)?.toDate(),
    );
  }

  factory StoryModel.fromDoc(DocumentSnapshot doc) {
    return StoryModel.fromMap(doc.data() as Map<String, dynamic>);
  }
}