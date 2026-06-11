import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wink_app/presentation/screens/create/upload_overlay_progress.dart';
import 'package:wink_app/viewmodels/upload_vm.dart';



class UploadDecisionScreen extends ConsumerStatefulWidget {
  final File file;
  final bool isVideo;

  const UploadDecisionScreen({
    super.key,
    required this.file,
    required this.isVideo,
  });

  @override
  ConsumerState<UploadDecisionScreen> createState() =>
      _UploadDecisionScreenState();
}

class _UploadDecisionScreenState
    extends ConsumerState<UploadDecisionScreen> {
  final captionController = TextEditingController();
  final hashtagController = TextEditingController();

  List<String> parseHashtags(String text) {
    return text
        .split(" ")
        .where((e) => e.startsWith("#"))
        .map((e) => e.replaceAll("#", ""))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final uploadState = ref.watch(uploadProvider);
    final upload = ref.read(uploadProvider.notifier);

    final userId = "demoUser"; // replace with auth

    return Scaffold(
      appBar: AppBar(title: const Text("Create Post")),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: captionController,
                  decoration: const InputDecoration(
                    hintText: "Write caption...",
                  ),
                ),

                const SizedBox(height: 10),

                TextField(
                  controller: hashtagController,
                  decoration: const InputDecoration(
                    hintText: "#tags",
                  ),
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: uploadState.isUploading
                      ? null
                      : () async {
                          final hashtags =
                              parseHashtags(hashtagController.text);

                          if (widget.isVideo) {
                            await upload.uploadShort(
                              userId: userId,
                              video: widget.file,
                              caption: captionController.text,
                            );

                            Navigator.pop(context);
                            Navigator.pop(context);
                          } else {
                            await upload.uploadPost(
                              userId: userId,
                              files: [widget.file],
                              caption: captionController.text,
                              hashtags: hashtags,
                            );

                            Navigator.pop(context);
                            Navigator.pop(context);
                          }
                        },
                  child: const Text("Upload"),
                ),
              ],
            ),
          ),

          // 🔥 OVERLAY
          const UploadProgressOverlay(),
        ],
      ),
    );
  }
}