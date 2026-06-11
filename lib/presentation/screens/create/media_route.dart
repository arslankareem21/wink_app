import 'dart:io';
import 'package:mime/mime.dart';

enum UploadType {
  post,
  short,
  story,
}

class MediaRouter {
  static bool isVideo(File file) {
    final mime = lookupMimeType(file.path);
    return mime?.startsWith("video") ?? false;
  }

  static bool isImage(File file) {
    final mime = lookupMimeType(file.path);
    return mime?.startsWith("image") ?? false;
  }

  static UploadType getUploadType(File file) {
    // default logic (you can override later with UI selection)
    if (isVideo(file)) {
      return UploadType.short; // reels default
    } else {
      return UploadType.post;
    }
  }
}