import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:wink_app/presentation/screens/create/decision-screen.dart';

class EditedVideoPreviewScreen extends StatefulWidget {
  final File videoFile;
  const EditedVideoPreviewScreen({super.key, required this.videoFile});

  @override
  State<EditedVideoPreviewScreen> createState() => _EditedVideoPreviewScreenState();
}

class _EditedVideoPreviewScreenState extends State<EditedVideoPreviewScreen> {
  late VideoPlayerController _previewController;
  bool _isPlayerInitialized = false;

  @override
  void initState() {
    super.initState();
    _previewController = VideoPlayerController.file(widget.videoFile)
      ..initialize().then((_) {
        setState(() {
          _isPlayerInitialized = true;
        });
        _previewController.setLooping(true);
        _previewController.play();
      });
  }

  @override
  void dispose() {
    _previewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Edit Preview', style: TextStyle(color: Colors.white, fontSize: 18)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.greenAccent, size: 28),
            onPressed: () {
  final file = widget.videoFile;

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => UploadDecisionScreen(file: file, isVideo: true,),
    ),
  );
}
          )
        ],
      ),
      body: Center(
        child: _isPlayerInitialized
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    _previewController.value.isPlaying 
                        ? _previewController.pause() 
                        : _previewController.play();
                  });
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AspectRatio(
                      aspectRatio: _previewController.value.aspectRatio,
                      child: VideoPlayer(_previewController),
                    ),
                    if (!_previewController.value.isPlaying)
                      const CircleAvatar(
                        backgroundColor: Colors.black54,
                        radius: 30,
                        child: Icon(Icons.play_arrow, size: 40, color: Colors.white),
                      ),
                  ],
                ),
              )
            : const CircularProgressIndicator(color: Colors.white),
      ),
    );
  }
}