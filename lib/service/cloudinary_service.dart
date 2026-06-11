import 'dart:io';
import 'package:http/http.dart' as http;

class CloudinaryService {
  final String cloudName = "dxtkhzk0a";
  final String uploadPreset = "wink_uploads";

  Future<Map<String, String>?> uploadFile({
    required File file,
    required String folder,
    required bool isVideo,
  }) async {
    final url = Uri.parse(
      "https://api.cloudinary.com/v1_1/$cloudName/${isVideo ? "video" : "image"}/upload",
    );

    final request = http.MultipartRequest("POST", url);

    request.fields["upload_preset"] = uploadPreset;
    request.fields["folder"] = folder;

    request.files.add(
      await http.MultipartFile.fromPath("file", file.path),
    );

    final response = await request.send();

    final responseBody = await response.stream.bytesToString();

    if (response.statusCode != 200) return null;

    final data = Map<String, dynamic>.from(
      Uri.splitQueryString(responseBody),
    );

    return {
      "url": data["secure_url"] ?? "",
      "publicId": data["public_id"] ?? "",
    };
  }
}