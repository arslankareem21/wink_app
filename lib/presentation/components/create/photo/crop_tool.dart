import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pro_image_editor/pro_image_editor.dart';
import 'package:wink_app/core/config/theme/app_colors.dart';

class ProImageEditorComponent {
  /// Open crop editor with custom aspect ratios
  static Future<Uint8List?> openCrop({
    required BuildContext context,
    required String path,
  }) async {
    final result = await Navigator.push<Uint8List>(
      context,
      MaterialPageRoute(
        builder: (_) => ProImageEditorScreen(path: path),
      ),
    );

    return result;
  }
}

/// Separate widget for the editor
class ProImageEditorScreen extends StatefulWidget {
  final String path;

  const ProImageEditorScreen({
    super.key,
    required this.path,
  });

  @override
  State<ProImageEditorScreen> createState() => _ProImageEditorScreenState();
}

class _ProImageEditorScreenState extends State<ProImageEditorScreen> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ProImageEditor.file(
          File(widget.path),
          configs: ProImageEditorConfigs(
            cropRotateEditor: CropRotateEditorConfigs(
              aspectRatios: [
                AspectRatioItem(text: "Free", value: null),
                AspectRatioItem(text: "Square", value: 1.0),
                AspectRatioItem(text: "4:3", value: 4 / 3),
                AspectRatioItem(text: "16:9", value: 16 / 9),
                AspectRatioItem(text: "9:16", value: 9 / 16),
              ],
            ),
          ),
          callbacks: ProImageEditorCallbacks(
            onImageEditingComplete: (Uint8List bytes) async {
              await _handleImageComplete(bytes);
            },
          ),
        ),
        // ✅ Show loading indicator while processing
        if (_isProcessing)
          Container(
            color: Colors.black.withValues(alpha: 0.5),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primaryYellow,
                    ),
                    strokeWidth: 3,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Processing...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _handleImageComplete(Uint8List bytes) async {
    if (!mounted) return;

    setState(() => _isProcessing = true);

    try {
      // ✅ Save cropped image to file
      final file = File(widget.path);
      await file.writeAsBytes(bytes);

      if (!mounted) return;

      // ✅ Return edited bytes to previous screen
      Navigator.pop(context, bytes);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving image: $e'),
          backgroundColor: AppColors.error,
        ),
      );
      setState(() => _isProcessing = false);
    }
  }
}