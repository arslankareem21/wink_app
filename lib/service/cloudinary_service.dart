// import 'dart:io';
// import 'package:dio/dio.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:image/image.dart' as img;

// class CloudinaryService {
//   final Dio _dio = Dio();
//   final String cloudName = 'dxtkhzk0a';
//   final String uploadPreset = 'wink_uploads';

//   Future<Map<String, String>> uploadFile({
//     required File file,
//     required String type, // 'posts', 'shorts', 'stories', 'profile'
//     required String userId,
//     void Function(double)? onProgress,
//   }) async {
//     File uploadFile = file;
//     try {
//       final ext = file.path.split('.').last.toLowerCase();
//       final isVideo = type == 'shorts' ||
//           (type == 'stories' && ['mp4', 'mov', 'avi', 'mkv', 'webm', '3gp'].contains(ext));

//       // HEIC convert
//       if (!isVideo && (ext == 'heic' || ext == 'heif')) {
//         final bytes = await file.readAsBytes();
//         final image = img.decodeImage(bytes);
//         if (image != null) {
//           final jpgBytes = img.encodeJpg(image, quality: 90);
//           uploadFile = File('${Directory.systemTemp.path}/temp_${DateTime.now().millisecondsSinceEpoch}.jpg');
//           await uploadFile.writeAsBytes(jpgBytes);
//         }
//       }

//       if (isVideo) {
//         const allowedVideo = ['mp4', 'mov', 'avi', 'mkv', 'webm', '3gp'];
//         if (!allowedVideo.contains(ext)) throw Exception('Unsupported video format');
//       }

//       final timestamp = DateTime.now().millisecondsSinceEpoch;
//       final safeUserId = userId.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');
//       final folder = 'wink/uploads/$type';
//       final publicId = '$folder/${safeUserId}_$timestamp';

//       final formData = FormData.fromMap({
//         'file': await MultipartFile.fromFile(uploadFile.path),
//         'upload_preset': uploadPreset,
//         'public_id': publicId,
//         'folder': folder,
//         if (isVideo) 'resource_type': 'video',
//       });

//       final response = await _dio.post(
//         'https://api.cloudinary.com/v1_1/$cloudName/${isVideo ? 'video' : 'image'}/upload',
//         data: formData,
//         options: Options(
//           sendTimeout: const Duration(minutes: 5),
//           receiveTimeout: const Duration(minutes: 5),
//         ),
//         onSendProgress: (sent, total) {
//           if (onProgress != null && total > 0) onProgress(sent / total);
//         },
//       );

//       if (uploadFile.path != file.path) await uploadFile.delete().catchError((_) {});

//       if (response.statusCode == 200) {
//         final data = response.data;
//         String secureUrl = data['secure_url'] as String? ?? '';
//         if (secureUrl.isEmpty) throw Exception('Cloudinary returned empty URL');
//         onProgress?.call(1.0);
//         return {
//           "url": secureUrl,
//           "publicId": data['public_id'] as String? ?? publicId,
//         };
//       } else if (response.statusCode == 420) {
//         throw Exception('Server busy. Try again later');
//       } else {
//         throw Exception('Upload failed: ${response.data['error']?['message']}');
//       }
//     } catch (e) {
//       if (uploadFile.path != file.path) await uploadFile.delete().catchError((_) {});
//       throw Exception('Upload failed: $e');
//     }
//   }
// }

import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;

class CloudinaryService {
  final Dio _dio = Dio();
  final String cloudName = 'dxtkhzk0a';
  final String uploadPreset = 'wink_uploads';
  // Add these from Cloudinary Dashboard > Settings > API Keys
  final String apiKey = 'YOUR_API_KEY';
  final String apiSecret = 'YOUR_API_SECRET';

  Future<Map<String, String>> uploadFile({
    required File file,
    required String type, // 'posts', 'shorts', 'stories', 'profile'
    required String userId,
    void Function(double)? onProgress,
  }) async {
    File uploadFile = file;
    try {
      final ext = file.path.split('.').last.toLowerCase();
      final isVideo = type == 'shorts' ||
          (type == 'stories' && ['mp4', 'mov', 'avi', 'mkv', 'webm', '3gp'].contains(ext));

      // HEIC convert
      if (!isVideo && (ext == 'heic' || ext == 'heif')) {
        final bytes = await file.readAsBytes();
        final image = img.decodeImage(bytes);
        if (image != null) {
          final jpgBytes = img.encodeJpg(image, quality: 90);
          uploadFile = File('${Directory.systemTemp.path}/temp_${DateTime.now().millisecondsSinceEpoch}.jpg');
          await uploadFile.writeAsBytes(jpgBytes);
        }
      }

      if (isVideo) {
        const allowedVideo = ['mp4', 'mov', 'avi', 'mkv', 'webm', '3gp'];
        if (!allowedVideo.contains(ext)) throw Exception('Unsupported video format');
      }

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final safeUserId = userId.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');
      final folder = 'wink/uploads/$type';
      final publicId = '$folder/${safeUserId}_$timestamp';

      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(uploadFile.path),
        'upload_preset': uploadPreset,
        'public_id': publicId,
        'folder': folder,
        if (isVideo) 'resource_type': 'video',
      });

      final response = await _dio.post(
        'https://api.cloudinary.com/v1_1/$cloudName/${isVideo ? 'video' : 'image'}/upload',
        data: formData,
        options: Options(
          sendTimeout: const Duration(minutes: 5),
          receiveTimeout: const Duration(minutes: 5),
        ),
        onSendProgress: (sent, total) {
          if (onProgress != null && total > 0) onProgress(sent / total);
        },
      );

      if (uploadFile.path != file.path) await uploadFile.delete().catchError((_) {});

      if (response.statusCode == 200) {
        final data = response.data;
        String secureUrl = data['secure_url'] as String? ?? '';
        if (secureUrl.isEmpty) throw Exception('Cloudinary returned empty URL');
        onProgress?.call(1.0);
        return {
          "url": secureUrl,
          "publicId": data['public_id'] as String? ?? publicId,
        };
      } else if (response.statusCode == 420) {
        throw Exception('Server busy. Try again later');
      } else {
        throw Exception('Upload failed: ${response.data['error']?['message']}');
      }
    } catch (e) {
      if (uploadFile.path != file.path) await uploadFile.delete().catchError((_) {});
      throw Exception('Upload failed: $e');
    }
  }



  Future<void> deleteFile(String publicId) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final signature = _generateSignature(publicId, timestamp);

    final uri = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/destroy');

    final response = await http.post(
      uri,
      body: {
        'public_id': publicId,
        'api_key': apiKey,
        'timestamp': timestamp.toString(),
        'signature': signature,
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Delete failed: ${response.body}');
    }
  }



  String _generateSignature(String publicId, int timestamp) {
    final toSign = 'public_id=$publicId&timestamp=$timestamp$apiSecret';
    final bytes = utf8.encode(toSign);
    return sha1.convert(bytes).toString();
  }
}



final cloudinaryProvider = Provider<CloudinaryService>((ref) => CloudinaryService());