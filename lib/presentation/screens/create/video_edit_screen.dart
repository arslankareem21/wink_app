import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pro_image_editor/pro_image_editor.dart';
import 'package:video_player/video_player.dart'; // Make sure this is in your pubspec.yaml

class VideoEditor extends StatefulWidget {
  final File videoFile;
  const VideoEditor({super.key, required this.videoFile});

  @override
  State<VideoEditor> createState() => _VideoEditorState();
}

class _VideoEditorState extends State<VideoEditor> {
  late VideoPlayerController _videoPlayerController;
  late ProVideoController _proVideoController;
  bool _isInitialized = false;

  @override
  void initState() {                            
    super.initState();
    _initializePlayer();
  }

  void _initializePlayer() async {
    // 1. Initialize standard video_player with your file
    _videoPlayerController = VideoPlayerController.file(widget.videoFile);
    await _videoPlayerController.initialize();

    // 2. Wrap it with ProVideoController
    _proVideoController = ProVideoController(
      videoPlayer: VideoPlayer(_videoPlayerController), // Pass the UI widget
      videoDuration: _videoPlayerController.value.duration,
      initialResolution: _videoPlayerController.value.size,
      fileSize: await widget.videoFile.length(),
    );

    setState(() {
      _isInitialized = true;
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _proVideoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return ProImageEditor.video(
      _proVideoController, // Pass the controller instance we built
      configs: const ProImageEditorConfigs(
        designMode: ImageEditorDesignMode.material,
      ),
      callbacks: ProImageEditorCallbacks(
        onImageEditingComplete: (bytes) async {
          // Handle saving/exporting here
        },
      ),
    );
  }
}