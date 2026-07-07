import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();
  bool _isPicking = false; // guard flag

  Future<XFile?> _safePick(Future<XFile?> Function() action) async {
    if (_isPicking) return null;
    _isPicking = true;
    try {
      return await action();
    } catch (e) {
      print('ImagePicker error: $e');
      return null;
    } finally {
      _isPicking = false;
    }
  }

  Future<XFile?> pickFromGallery() async {
    return _safePick(() => _picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 80,
        ));
  }

  Future<XFile?> captureWithCamera() async {
    return _safePick(() => _picker.pickImage(
          source: ImageSource.camera,
          imageQuality: 80,
        ));
  }

  Future<XFile?> pickVideoFromGallery() async {
    return _safePick(() => _picker.pickVideo(
          source: ImageSource.gallery,
          maxDuration: const Duration(minutes: 2),
        ));
  }
}
