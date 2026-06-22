import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

Future<File> getFilePathFromBytes(Uint8List bytes, String fileName) async {
  // 1. Get the system's temporary directory
  final tempDir = await getTemporaryDirectory();
  
  // 2. Create a file reference in that directory
  final file = File('${tempDir.path}/$fileName');
  
  // 3. Write the bytes to the file
  return await file.writeAsBytes(bytes);
}