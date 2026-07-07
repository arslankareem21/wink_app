import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pro_image_editor/pro_image_editor.dart';
import 'package:pro_video_editor/pro_video_editor.dart';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wink_app/core/config/theme/app_colors.dart';
import 'package:wink_app/presentation/screens/create/edit_preview.dart';

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
  bool _isSeeking = false;
  TrimDurationSpan? _durationSpan;

  // FIX: Track mute state ourselves — do NOT rely on _proVideoController.isAudioEnabled
  // because it may not reflect the user's in-editor toggle reliably.
  bool _isAudioMuted = false;

  final String _taskId = DateTime.now().millisecondsSinceEpoch.toString();
  String? _outputPath;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  void _initializePlayer() async {
    try {
      _videoPlayerController = VideoPlayerController.file(widget.videoFile);
      await _videoPlayerController.initialize();
      await _videoPlayerController.setLooping(false);

      // FIX: Explicitly set volume to 1.0 on init so audio always plays by default.
      // Without this, some platforms default to 0 and audio is silent from the start.
      await _videoPlayerController.setVolume(1.0);

      _proVideoController = ProVideoController(
        videoPlayer: Center(
          child: AspectRatio(
            aspectRatio: _videoPlayerController.value.size.aspectRatio,
            child: VideoPlayer(_videoPlayerController),
          ),
        ),
        videoDuration: _videoPlayerController.value.duration,
        initialResolution: _videoPlayerController.value.size,
        fileSize: await widget.videoFile.length(),
      );

      _videoPlayerController.addListener(_onDurationChange);

      setState(() {
        _isInitialized = true;
      });

      _videoPlayerController.play();
      _generateThumbnails();
    } catch (e) {
      debugPrint("Error initializing video player: $e");
    }
  }

  void _generateThumbnails() async {
    try {
      final durationMs = _videoPlayerController.value.duration.inMilliseconds;
      final thumbnailList = await ProVideoEditor.instance.getThumbnails(
        ThumbnailConfigs(
          video: EditorVideo.file(widget.videoFile),
          outputSize: const Size.square(150),
          timestamps: List.generate(7, (i) {
            final ms = (durationMs / 7) * (i + 0.5);
            return Duration(milliseconds: ms.round());
          }),
        ),
      );

      if (mounted) {
        setState(() {
          _proVideoController.thumbnails = thumbnailList
              .map((bytes) => MemoryImage(bytes))
              .toList();
        });
      }
    } catch (e) {
      debugPrint("Error generating thumbnails: $e");
    }
  }

  void _onDurationChange() {
    if (!mounted || !_isInitialized) return;

    var totalVideoDuration = _videoPlayerController.value.duration;
    var duration = _videoPlayerController.value.position;

    _proVideoController.setPlayTime(duration);

    if (_durationSpan != null && duration >= _durationSpan!.end) {
      _seekToPosition(_durationSpan!);
    } else if (duration >= totalVideoDuration) {
      _seekToPosition(
        TrimDurationSpan(start: Duration.zero, end: totalVideoDuration),
      );
    }
  }

  Future<void> _seekToPosition(TrimDurationSpan span) async {
    _durationSpan = span;

    if (_isSeeking) return;
    _isSeeking = true;

    _proVideoController.pause();
    _proVideoController.setPlayTime(span.start);

    await _videoPlayerController.pause();
    await _videoPlayerController.seekTo(span.start);

    _isSeeking = false;
  }

  @override
  void dispose() {
    _videoPlayerController.removeListener(_onDurationChange);
    _videoPlayerController.dispose();
    _proVideoController.dispose();
    super.dispose();
  }

  Future<void> _handleVideoExport(CompleteParameters params) async {
    try {
      _videoPlayerController.pause();

      final appDocDir = await getApplicationDocumentsDirectory();
      final editedVideosDir = Directory('${appDocDir.path}/edited_videos');

      if (!await editedVideosDir.exists()) {
        await editedVideosDir.create(recursive: true);
      }

      final fileName = 'video_${DateTime.now().millisecondsSinceEpoch}.mp4';
      final outputPath = '${editedVideosDir.path}/$fileName';

      final exportModel = VideoRenderData(
        id: _taskId,
        videoSegments: [
          VideoSegment(video: EditorVideo.file(widget.videoFile), volume: 1.0),
        ],
        outputFormat: VideoOutputFormat.mp4,
        // FIX: Use our own _isAudioMuted flag instead of _proVideoController.isAudioEnabled.
        // If the user muted during editing → _isAudioMuted = true → enableAudio = false → export is silent.
        // If the user left audio on   → _isAudioMuted = false → enableAudio = true  → export has audio.
        enableAudio: !_isAudioMuted,
        imageLayers: params.layers.isNotEmpty
            ? [ImageLayer(image: EditorLayerImage.memory(params.image))]
            : null,
        blur: params.blur,
        colorFilters: params.colorFilters
            .map((matrix) => ColorFilter(matrix: matrix))
            .toList(),
        startTime: params.startTime,
        endTime: params.endTime,
        transform: params.isTransformed
            ? ExportTransform(
                width: params.cropWidth,
                height: params.cropHeight,
                rotateTurns: params.rotateTurns,
                x: params.cropX,
                y: params.cropY,
                flipX: params.flipX,
                flipY: params.flipY,
              )
            : null,
      );

      _outputPath = await ProVideoEditor.instance.renderVideoToFile(
        outputPath,
        exportModel,
      );

      // Give the visual progress bar time to hit 100% before closing.
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      debugPrint('❌ Export error: $e');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Export failed: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _handleCloseEditor(EditorMode editorMode) {
    if (editorMode != EditorMode.main) {
      Navigator.pop(context);
      return;
    }

    if (_outputPath != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) =>
              EditedVideoPreviewScreen(videoFile: File(_outputPath!)),
        ),
      );
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Scaffold(
      
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: AppColors.iconAccent),
              const SizedBox(height: 20),
              Text(
                'Loading Video...',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: ProImageEditor.video(
          _proVideoController,
          configs: ProImageEditorConfigs(
            designMode: ImageEditorDesignMode.material,
            dialogConfigs: DialogConfigs(
              widgets: DialogWidgets(
                loadingDialog: (message, configs) =>
                    ExportProgressDialog(taskId: _taskId),
              ),
            ),
            imageGeneration: const ImageGenerationConfigs(
              enableBackgroundGeneration: false,
            ),
            videoEditor: const VideoEditorConfigs(
              maxTrimDuration: Duration(seconds: 30),
              minTrimDuration: Duration(seconds: 1),
              enableTrimBar: true,
              enablePlayButton: true,
              playTimeSmoothingDuration: Durations.long1,
              initialPlay: true,
              controlsPosition: VideoEditorControlPosition.bottom,
              showControls: true,
              isAudioSupported: true,
              enableEstimatedFileSize: true,
              style: VideoEditorStyle(playIndicatorBackground: Colors.white30),
            ),
          ),
          callbacks: ProImageEditorCallbacks(
            onCompleteWithParameters: _handleVideoExport,
            onCloseEditor: _handleCloseEditor,
            videoEditorCallbacks: VideoEditorCallbacks(
              onPause: () => _videoPlayerController.pause(),
              onPlay: () => _videoPlayerController.play(),
              onMuteToggle: (isMuted) {
                // FIX: isMuted = true  → user pressed mute   → silence VideoPlayer + remember muted
                //      isMuted = false → user pressed unmute → restore volume  + remember unmuted
                _isAudioMuted = isMuted;
                _videoPlayerController.setVolume(isMuted ? 0.0 : 1.0);
              },
              onTrimSpanUpdate: (durationSpan) {
                if (_videoPlayerController.value.isPlaying) {
                  _proVideoController.pause();
                }
              },
              onTrimSpanEnd: _seekToPosition,
            ),
          ),
        ),
      ),
    );
  }
}

class ExportProgressDialog extends StatelessWidget {
  final String taskId;

  const ExportProgressDialog({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black87,
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            StreamBuilder<ProgressModel>(
              stream: ProVideoEditor.instance.progressStreamById(taskId),
              builder: (context, snapshot) {
                var progress = snapshot.data?.progress ?? 0.0;

                return TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: progress),
                  duration: const Duration(milliseconds: 100),
                  builder: (context, animatedValue, _) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(
                          value: animatedValue == 0 ? null : animatedValue,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          animatedValue == 0
                              ? "Preparing Edits..."
                              : "Exporting: ${(animatedValue * 100).toStringAsFixed(1)}%",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
