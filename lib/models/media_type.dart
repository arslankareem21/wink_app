enum MediaType {
  image,
  video,
}

extension MediaTypeX on MediaType {
  String get value {
    switch (this) {
      case MediaType.image:
        return "image";
      case MediaType.video:
        return "video";
    }
  }

  static MediaType fromString(String value) {
    switch (value) {
      case "video":
        return MediaType.video;
      case "image":
      default:
        return MediaType.image;
    }
  }
}