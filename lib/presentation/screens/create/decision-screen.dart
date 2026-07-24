import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:wink_app/core/config/theme/app_colors.dart';
import 'package:wink_app/presentation/widgets/app_snackbar.dart';
import 'package:wink_app/presentation/widgets/textformfield.dart';
import 'package:wink_app/viewmodels/upload_vm.dart';

class UploadDecisionScreen extends ConsumerStatefulWidget {
  final File file;
  final bool isVideo;
  final String? uploadType;

  const UploadDecisionScreen({
    super.key,
    required this.file,
    required this.isVideo,
    this.uploadType,
  });

  @override
  ConsumerState<UploadDecisionScreen> createState() =>
      _UploadDecisionScreenState();
}

class _UploadDecisionScreenState extends ConsumerState<UploadDecisionScreen> {
  final TextEditingController _captionController = TextEditingController();
  String? _videoThumbnailPath;

  @override
  void initState() {
    super.initState();
    if (widget.isVideo) _generateVideoThumbnail();
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
      final path = await VideoThumbnail.thumbnailFile(
        video: widget.file.path,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 800,
        quality: 75,
      );
      if (mounted) setState(() => _videoThumbnailPath = path);
    } catch (e) {
      debugPrint('Thumbnail error: $e');
    }
  }

  Future<void> _upload(String type) async {
    final notifier = ref.read(uploadProvider.notifier);

    try {
      switch (type) {
        case 'post':
          await notifier.uploadPost(
            image: widget.file,
            caption: _captionController.text.trim(),
          );
          break;
        case 'short':
          await notifier.uploadShort(
            video: widget.file,
            caption: _captionController.text.trim(),
          );
          // uploadShort(
          //   video: widget.file,
          //   caption: _captionController.text.trim(),
          // );
          break;
        case 'story':
          await notifier.uploadStory(
            file: widget.file,
            isVideo: widget.isVideo,
          );
          break;
      }

      if (!mounted) return;
      AppSnackBar.show('Uploaded successfully');
      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        // Pop back to root/home instead of profile
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.show(
          e.toString().replaceAll('Exception: ', ''),
          isError: true,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(uploadProvider);
    final isStoryAuto = widget.uploadType == 'story';

    return PopScope(
      canPop: !state.isUploading,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: isStoryAuto
            ? null
            : AppBar(
                title: const Text('New Post'),
                backgroundColor: Colors.black,
              ),
        body: isStoryAuto
            ? _buildStoryUploadUI(state)
            : _buildDecisionUI(state),
      ),
    );
  }

  Widget _buildStoryUploadUI(UploadState state) {
    if (state.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 60),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                state.error!,
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Back'),
            ),
          ],
        ),
      );
    }
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: Colors.white),
          const SizedBox(height: 24),
          Text(
            '${state.status} ${(state.progress * 100).toInt()}%',
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildDecisionUI(UploadState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildPreviewBox(),
          const SizedBox(height: 16),
          _buildCaptionField(),
          if (state.isUploading) ...[_buildProgressIndicator(state)],
          if (state.error != null) ...[
            const SizedBox(height: 12),
            Text(state.error!, style: const TextStyle(color: Colors.red)),
          ],

          _buildActionButtons(state),
        ],
      ),
    );
  }

  Widget _buildPreviewBox() {
    return Container(
      height: 400,
      width: double.infinity,
      color: Colors.grey[900],
      child: widget.isVideo
          ? (_videoThumbnailPath != null
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
                  ))
          : Image.file(widget.file, fit: BoxFit.contain),
    );
  }

  Widget _buildCaptionField() {
    return AppTextField(
      controller: _captionController,
      maxLines: 3,
      maxLength: 100,
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r'[\u0000-\u001F]')),
      ],
      height: 100.h,
      keyboardType: TextInputType.text,
      hintText: 'Write a caption...',
    );
  }

  Widget _buildProgressIndicator(UploadState state) {
    return Column(
      children: [
        LinearProgressIndicator(value: state.progress, color: Colors.blue),
        const SizedBox(height: 8),
        Text(state.status, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }

  Widget _buildActionButtons(UploadState state) {
    final bool disabled = state.isUploading;
    return Column(
      children: [
        if (!widget.isVideo)
          _button(
            'Share to Feed',
            Colors.blue,
            disabled,
            () => _upload('post'),
          ),
        if (widget.isVideo)
          _button(
            'Share as Short',
            Colors.red,
            disabled,
            () => _upload('short'),
          ),
        const SizedBox(height: 12),
        _button(
          'Add to Story',
          Colors.transparent,
          disabled,
          () => _upload('story'),
          isOutlined: true,
        ),
      ],
    );
  }

  Widget _button(
    String text,
    Color color,
    bool disabled,
    VoidCallback onPressed, {
    bool isOutlined = false,
  }) {
    return SizedBox(
      width: double.infinity,
      child: isOutlined
          ? OutlinedButton(
              onPressed: disabled ? null : onPressed,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(text),
            )
          : ElevatedButton(
              onPressed: disabled ? null : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(text),
            ),
    );
  }
}
