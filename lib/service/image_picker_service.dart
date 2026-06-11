import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  // Gallery (Images)
  Future<XFile?> pickFromGallery() async {
    try {
      return await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    } catch (e) {
      print('Error picking image from gallery: $e');
      return null;
    }
  }

  // Camera (Images)
  Future<XFile?> captureWithCamera() async {
    try {
      return await _picker.pickImage(source: ImageSource.camera, imageQuality: 80);
    } catch (e) {
      print('Error capturing image with camera: $e');
      return null;
    }
  }

  // Gallery (Videos)
  Future<XFile?> pickVideoFromGallery() async {
    try {
      return await _picker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(minutes: 2), // Optional: Limit length for shorts
      );
    } catch (e) {
      print('Error picking video from gallery: $e');
      return null;
    }
  }
}