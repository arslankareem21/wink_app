import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wink_app/presentation/screens/create/decision-screen.dart';

// Import your UploadDecisionScreen file here
// import 'upload_decision_screen.dart';

class EditPreviewScreen extends ConsumerWidget {
  final File file;

  const EditPreviewScreen({super.key, required this.file});

  void _navigateToUploadDecision(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UploadDecisionScreen(
          file: file,
          isVideo: false,
          // Add other required parameters for your UploadDecisionScreen here
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Edit & Preview",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // The Preview Area
            Expanded(
              child: InteractiveViewer(
                minScale: 1.0,
                maxScale: 3.0,
                child: Center(child: Image.file(file, fit: BoxFit.contain)),
              ),
            ),
        
            // Action Controls
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              color: Colors.black,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white),
                    label: const Text(
                      "Cancel",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  FilledButton(
                    onPressed: () => _navigateToUploadDecision(context),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: const Text("Next", style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
