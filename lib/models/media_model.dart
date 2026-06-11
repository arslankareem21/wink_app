import 'media_type.dart';

class MediaModel {
  final String url;
  final String publicId;
  final MediaType type;

  MediaModel({
    required this.url,
    required this.publicId,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      "url": url,
      "publicId": publicId,
      "type": type.value,
    };
  }

  factory MediaModel.fromMap(Map<String, dynamic> map) {
    return MediaModel(
      url: map["url"] ?? "",
      publicId: map["publicId"] ?? "",
      type: MediaTypeX.fromString(map["type"] ?? "image"),
    );
  }
}