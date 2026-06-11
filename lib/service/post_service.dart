import 'dart:typed_data';

class ImageEditorService {
  /// HERE we will later plug:
  /// pro_image_editor processors / filters / crop logic
  static Future<Uint8List> applyEdits({
    required Uint8List image,
  }) async {
    // Step 1: filters (later)
    // Step 2: crop (later)
    // Step 3: stickers/text (later)

    return image;
  }
}