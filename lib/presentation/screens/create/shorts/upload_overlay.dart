import 'dart:io';
import 'package:flutter/material.dart';
import 'package:wink_app/presentation/screens/create/decision-screen.dart';


class UploadOverlay extends StatelessWidget {
  final File editedFile;
  final bool isVideo;

  const UploadOverlay({
    super.key,
    required this.editedFile,
    required this.isVideo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Text('Upload as', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        if (!isVideo)
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Post to Feed'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(
                builder: (_) => UploadDecisionScreen(file: editedFile, isVideo: false, uploadType: null),
              ));
            },
          ),
        if (isVideo)
          ListTile(
            leading: const Icon(Icons.video_library),
            title: const Text('Short'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(
                builder: (_) => UploadDecisionScreen(file: editedFile, isVideo: true, uploadType: null),
              ));
            },
          ),
        ListTile(
          leading: const Icon(Icons.add_circle_outline),
          title: const Text('Story'),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(
              builder: (_) => UploadDecisionScreen(file: editedFile, isVideo: isVideo, uploadType: 'story'),
            ));
          },
        ),
      ]),
    );
  }
}