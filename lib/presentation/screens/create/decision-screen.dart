import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:wink_app/presentation/widgets/app_snackbar.dart';
import 'package:wink_app/viewmodels/upload_vm.dart';

class UploadDecisionScreen extends ConsumerStatefulWidget {
  final File file;
  final bool isVideo;
  final String? uploadType; // 'story' if auto-upload

  const UploadDecisionScreen({
    super.key,
    required this.file,
    required this.isVideo,
    this.uploadType,
  });

  @override
  ConsumerState<UploadDecisionScreen> createState() => _UploadDecisionScreenState();
}

class _UploadDecisionScreenState extends ConsumerState<UploadDecisionScreen> {
  final TextEditingController _captionController = TextEditingController();
  String? _videoThumbnailPath;

  @override
  void initState() {
    super.initState();
    if (widget.isVideo) _generateVideoThumbnail();

    // Auto upload story
    if (widget.uploadType == 'story') {
      Future.microtask(() => _upload('story'));
    }
  }

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  Future<void> _generateVideoThumbnail() async {
    try {
      final thumbnail = await VideoThumbnail.thumbnailFile(
        video: widget.file.path,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 800,
        quality: 75,
      );
      if (mounted) setState(() => _videoThumbnailPath = thumbnail);
    } catch (e) {
      debugPrint('Thumbnail error: $e');
    }
  }

  Future<void> _upload(String type) async {
    final uploadNotifier = ref.read(uploadProvider.notifier);

    try {
      if (type == 'post') {
        await uploadNotifier.uploadPost(
          image: widget.file,
          caption: _captionController.text,
        );
      } else if (type == 'short') {
        await uploadNotifier.uploadShort(
          video: widget.file,
          caption: _captionController.text,
        );
      } else if (type == 'story') {
        await uploadNotifier.uploadStory(
          file: widget.file,
          isVideo: widget.isVideo,
        );
      }

      if (mounted) {
        AppSnackBar.show('Uploaded successfully');
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.show(e.toString().replaceAll('Exception: ', ''), isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final uploadState = ref.watch(uploadProvider);

    return WillPopScope(
      onWillPop: () async =>!uploadState.isUploading,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.black,
        appBar: widget.uploadType == 'story'
           ? null
            : AppBar(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                title: const Text('New Post'),
              ),
        body: widget.uploadType == 'story'
           ? _buildStoryUpload(uploadState)
            : _buildDecisionUI(uploadState),
      ),
    );
  }

  Widget _buildStoryUpload(UploadState uploadState) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (uploadState.isUploading)...[
            const CircularProgressIndicator(color: Colors.white),
            const SizedBox(height: 24),
            Text(
              '${uploadState.status} ${(uploadState.progress * 100).toInt()}%',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ] else if (uploadState.error!= null)...[
            const Icon(Icons.error_outline, color: Colors.red, size: 60),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                uploadState.error!,
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Back'),
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildDecisionUI(UploadState uploadState) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // THUMBNAIL PREVIEW - NO VIDEO PLAYBACK
          Container(
            height: 400,
            width: double.infinity,
            color: Colors.grey[900],
            child: widget.isVideo
               ? _videoThumbnailPath!= null
                   ? Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.file(
                            File(_videoThumbnailPath!),
                            fit: BoxFit.contain,
                            width: double.infinity,
                          ),
                          const Icon(
                            Icons.play_circle_outline,
                            size: 80,
                            color: Colors.white70,
                          ),
                        ],
                      )
                    : const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                : Image.file(widget.file, fit: BoxFit.contain),
          ),

          // Caption
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _captionController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Write a caption...',
                hintStyle: TextStyle(color: Colors.grey[600]),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[800]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                counterText: '',
              ),
              maxLines: 3,
              maxLength: 500,
              inputFormatters: [
                FilteringTextInputFormatter.deny(RegExp(r'[\u0000-\u001F]')),
              ],
            ),
          ),

          // Progress
          if (uploadState.isUploading)...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: LinearProgressIndicator(
                value: uploadState.progress,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 8),
            Text(uploadState.status, style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 16),
          ],

          // Error
          if (uploadState.error!= null)...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                uploadState.error!,
                style: const TextStyle(color: Colors.red),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Buttons
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                if (!widget.isVideo)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: uploadState.isUploading? null : () => _upload('post'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Share to post', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                if (!widget.isVideo) const SizedBox(height: 12),

                if (widget.isVideo)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: uploadState.isUploading? null : () => _upload('short'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Share as Short', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                if (widget.isVideo) const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: uploadState.isUploading? null : () => _upload('story'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Add to Story', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}