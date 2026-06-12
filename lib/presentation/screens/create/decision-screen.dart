import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wink_app/presentation/screens/create/upload_overlay_progress.dart';
import 'package:wink_app/presentation/widgets/app_snackbar.dart';
import 'package:wink_app/viewmodels/auth_viewmodel.dart';
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
  ConsumerState<UploadDecisionScreen> createState() => _UploadDecisionScreenState();
}

class _UploadDecisionScreenState extends ConsumerState<UploadDecisionScreen> {
  final TextEditingController captionController = TextEditingController();
  bool _hasNavigatedBack = false;

  @override
  void dispose() {
    captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = ref.watch(currentUserIdProvider); // Use your provider
    
    // Handle success + error
    ref.listen(uploadProvider, (prev, next) {
      if (prev?.isUploading == true &&
          next.isUploading == false &&
          next.error == null &&
         !_hasNavigatedBack &&
          mounted) {
        _hasNavigatedBack = true;
        AppSnackBar.show("Upload successful", isError: false);
        Navigator.of(context).pop();
      }
    });

    final uploadState = ref.watch(uploadProvider);
    final isUploading = uploadState.isUploading;

    // Guard: if user somehow logged out, don't allow upload
    if (currentUserId == null) {
      return const Scaffold(
        body: Center(child: Text("Please login to upload")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Preview
                Expanded(
                  child: widget.isVideo
                    ? Container(
                          color: Colors.black,
                          child: const Center(
                            child: Icon(Icons.videocam, size: 80, color: Colors.white),
                          ),
                        )
                      : Image.file(widget.file, fit: BoxFit.contain),
                ),
                const SizedBox(height: 16),

                // Caption input
                TextField(
                  controller: captionController,
                  enabled:!isUploading,
                  decoration: const InputDecoration(
                    hintText: "Write a caption...",
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),

                // Upload buttons
                if (!isUploading)...[
                  ElevatedButton(
                    onPressed: () => _uploadAsPost(currentUserId),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text("Post to Feed"),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => _uploadAsStory(currentUserId),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text("Add to Story"),
                  ),
                  if (widget.isVideo)...[
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => _uploadAsShort(currentUserId),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text("Upload as Short"),
                    ),
                  ],
                ],
              ],
            ),
          ),
          const UploadProgressOverlay(),
        ],
      ),
    );
  }

  Future<void> _uploadAsPost(String userId) async {
    final hashtags = _extractHashtags(captionController.text);

    await ref.read(uploadProvider.notifier).uploadPost(
          userId: userId, // Now using real UID from provider
          file: widget.file,
          caption: captionController.text,
          hashtags: hashtags,
        );
  }

  Future<void> _uploadAsStory(String userId) async {
    await ref.read(uploadProvider.notifier).uploadStory(
          userId: userId,
          file: widget.file,
          isVideo: widget.isVideo,
        );
  }

  Future<void> _uploadAsShort(String userId) async {
    await ref.read(uploadProvider.notifier).uploadShort(
          userId: userId,
          video: widget.file,
          caption: captionController.text,
        );
  }

  List<String> _extractHashtags(String text) {
    final regex = RegExp(r'#\w+');
    return regex.allMatches(text).map((m) => m.group(0)!).toList();
  }
}