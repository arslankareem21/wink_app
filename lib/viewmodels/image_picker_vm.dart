import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wink_app/service/image_picker_service.dart';

final imagePickerServiceProvider = Provider<ImagePickerService>((ref) => ImagePickerService());

class ImagePickerViewModel extends Notifier<File?> {
  @override
  File? build() => null;

  Future<void> pickFromGallery() async {
    final xFile = await ref.read(imagePickerServiceProvider).pickFromGallery();
    if (xFile != null) state = File(xFile.path);
  }

  Future<void> captureWithCamera() async {
    final xFile = await ref.read(imagePickerServiceProvider).captureWithCamera();
    if (xFile != null) state = File(xFile.path);
  }

  Future<void> pickVideoFromGallery() async {
    final xFile = await ref.read(imagePickerServiceProvider).pickVideoFromGallery();
    if (xFile != null) state = File(xFile.path);
  }

  void clear() => state = null;
}

final imagePickerProvider = NotifierProvider<ImagePickerViewModel, File?>(() {
  return ImagePickerViewModel();
});
