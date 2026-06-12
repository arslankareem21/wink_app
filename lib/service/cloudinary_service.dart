import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CloudinaryService {
  final String cloudName = "dxtkhzk0a";
  final String uploadPreset = "wink_uploads";
  static const int maxImageMB = 10;
  static const int maxVideoMB = 100;

  Future<Map<String, String>?> uploadFile({
    required File file,
    required String folder,
    required bool isVideo,
    void Function(double progress)? onProgress,
  }) async {
    try {
      // 1. File size check first
      final fileSizeMB = await file.length() / (1024 * 1024);
      if (isVideo && fileSizeMB > maxVideoMB) {
        throw Exception("Video too large. Max ${maxVideoMB}MB");
      }
      if (!isVideo && fileSizeMB > maxImageMB) {
        throw Exception("Image too large. Max ${maxImageMB}MB");
      }

      final url = Uri.parse(
        "https://api.cloudinary.com/v1_1/$cloudName/${isVideo ? "video" : "image"}/upload",
      );

      final request = http.MultipartRequest("POST", url);
      request.fields["upload_preset"] = uploadPreset;
      request.fields["folder"] = folder;

      final fileLength = await file.length();
      final stream = http.ByteStream(file.openRead());
      
      int byteCount = 0;
      final multipartFile = http.MultipartFile(
        "file",
        stream.transform(
          StreamTransformer.fromHandlers(
            handleData: (data, sink) {
              byteCount += data.length;
              onProgress?.call(byteCount / fileLength);
              sink.add(data);
            },
            handleError: (error, stack, sink) {
              throw Exception("File read error: $error");
            },
          ),
        ),
        fileLength,
        filename: file.path.split("/").last,
      );

      request.files.add(multipartFile);

      // 2. Timeout + proper error handling
      final streamedResponse = await request.send().timeout(
        const Duration(minutes: 5),
        onTimeout: () => throw TimeoutException("Upload timed out. Check internet."),
      );
      
      final responseBody = await streamedResponse.stream.bytesToString();

      // 3. Check Cloudinary errors
      if (streamedResponse.statusCode != 200) {
        final error = json.decode(responseBody);
        throw Exception("Cloudinary: ${error['error']?['message'] ?? 'Upload failed'}");
      }

      // 4. Parse JSON correctly
      final data = json.decode(responseBody) as Map<String, dynamic>;
      final urlResult = data["secure_url"] as String?;
      final publicIdResult = data["public_id"] as String?;

      if (urlResult == null || urlResult.isEmpty) {
        throw Exception("Cloudinary returned empty URL");
      }

      return {
        "url": urlResult,
        "publicId": publicIdResult ?? "",
      };
    } on TimeoutException catch (e) {
      throw Exception("Network timeout. Try again.");
    } on SocketException {
      throw Exception("No internet connection");
    } on HandshakeException {
      throw Exception("Connection failed. Check internet.");
    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }
}