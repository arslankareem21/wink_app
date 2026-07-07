import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:video_player/video_player.dart';

/// Handles all VideoPlayerControllers.
/// One controller per page.
///
/// Responsibilities:
/// - Create controller
/// - Retry failed initialization
/// - Timeout slow internet
/// - Preload next videos
/// - Dispose old videos
/// - Play/Pause
/// - Never throw uncaught exceptions
class VideoControllerManager {
  VideoControllerManager._();

  static final VideoControllerManager instance = VideoControllerManager._();

  //---------------------------------------------------------------
  // SETTINGS - Point 1, 9
  //---------------------------------------------------------------
  static const Duration initializeTimeout = Duration(seconds: 15);
  static const int maxRetry = 3;
  static const int keepBehind = 2; // Point 1
  static const int keepAhead = 4; // Point 1, changed from 3 to 4

  //---------------------------------------------------------------
  // CACHE
  //---------------------------------------------------------------
  final Map<int, VideoPlayerController> _controllers = {};
  final Set<int> _initializing = {};
  final Set<int> _failed = {};
  int _currentIndex = 0;

  //---------------------------------------------------------------
  // GETTERS
  //---------------------------------------------------------------
  Map<int, VideoPlayerController> get controllers => _controllers;
  Set<int> get failed => _failed;

  bool isReady(int index) => _controllers[index]?.value.isInitialized?? false;
  bool isLoading(int index) => _initializing.contains(index);
  bool hasError(int index) => _failed.contains(index);

  VideoPlayerController? controller(int index) {
    return _controllers[index];
  }

  bool isBuffering(int index) {
    final controller = _controllers[index];
    if (controller == null) return true;
    if (!controller.value.isInitialized) return true;
    return controller.value.isBuffering;
  }

  bool isPlaying(int index) {
    final controller = _controllers[index];
    if (controller == null) return false;
    return controller.value.isPlaying;
  }

  bool isInitialized(int index) {
    final controller = _controllers[index];
    if (controller == null) return false;
    return controller.value.isInitialized;
  }

  //---------------------------------------------------------------
  // INITIALIZE - Point 2, 3, 11
  //---------------------------------------------------------------
  Future<void> initializeVideo({
    required int index,
    required String url,
    bool autoPlay = false,
  }) async {
    // Point 11: Don't recreate controller
    if (_controllers.containsKey(index)) {
      if (autoPlay) await play(index); // Point 2: play if requested
      return;
    }
    if (_initializing.contains(index)) return;
    if (_failed.contains(index)) return;

    _initializing.add(index);

    try {
      await _initializeWithRetry(
        index: index,
        url: url,
        autoPlay: autoPlay,
      );
    } finally {
      _initializing.remove(index);
    }
  }

  //---------------------------------------------------------------
  // RETRY INITIALIZATION - Point 8
  //---------------------------------------------------------------
  Future<void> _initializeWithRetry({
    required int index,
    required String url,
    required bool autoPlay,
  }) async {
    Exception? lastException;

    if (url.trim().isEmpty) {
      throw Exception("Empty video URL");
    }

    final uri = Uri.tryParse(url);
    if (uri == null ||!uri.hasScheme) {
      throw Exception("Invalid video URL: $url");
    }

    for (int attempt = 1; attempt <= maxRetry; attempt++) {
      VideoPlayerController? controller;

      try {
        controller = VideoPlayerController.networkUrl(uri);

        await controller.initialize().timeout(initializeTimeout);
        await controller.setLooping(true); // Point 3: Loop forever
        await controller.setVolume(1);

        if (autoPlay) {
          await controller.play();
        }

        controller.addListener(() {
          final value = controller!.value;
          if (value.hasError) {
            debugPrint("VIDEO ERROR [$index] : ${value.errorDescription}");
            _failed.add(index);
          }
          if (value.isBuffering) {
            debugPrint("VIDEO BUFFERING [$index]");
          }
        });

        _controllers[index] = controller;
        _failed.remove(index);

        debugPrint("Video initialized successfully [$index]");
        return;
      } on TimeoutException catch (_) {
        lastException = Exception("Video initialization timeout.");
        try {
          await controller?.dispose();
        } catch (_) {}
        debugPrint("Timeout initializing video [$index] Attempt $attempt");
      } catch (e) {
        lastException = Exception(e.toString());
        try {
          await controller?.dispose();
        } catch (_) {}
        debugPrint("Initialization failed [$index] Attempt $attempt\n$e");
      }

      // Point 8: Don't add to _failed on timeout, just retry
      if (attempt < maxRetry) {
        await Future.delayed(const Duration(seconds: 3));
      }
    }

    // Point 8: Only add to failed after all retries exhausted
    _failed.add(index);
    debugPrint("All retries failed for [$index]: $lastException");
  }

  //---------------------------------------------------------------
  // PRELOAD
  //---------------------------------------------------------------
  Future<void> preload({
    required int index,
    required String url,
  }) async {
    await initializeVideo(index: index, url: url, autoPlay: false);
  }

  //---------------------------------------------------------------
  // ON PAGE CHANGED - Point 1, 2
  //---------------------------------------------------------------
  Future<void> onPageChanged({
    required int newIndex,
    required List<String> urls,
  }) async {
    if (newIndex < 0 || newIndex >= urls.length) return;

    _currentIndex = newIndex;

    // Pause all except current
    for (final entry in _controllers.entries) {
      if (entry.key!= newIndex && entry.value.value.isPlaying) {
        await pause(entry.key);
      }
    }

    // Point 2: Current page should autoplay - use initializeVideo
    await initializeVideo(
      index: newIndex,
      url: urls[newIndex],
      autoPlay: true,
    );

    // Point 1: Only preload 4 ahead
    for (int i = newIndex + 1;
        i <= newIndex + keepAhead && i < urls.length;
        i++) {
      unawaited(preload(index: i, url: urls[i]));
    }

    // Dispose unused
    disposeUnused();
  }

  //---------------------------------------------------------------
  // DISPOSE UNUSED - Point 9
  //---------------------------------------------------------------
  void disposeUnused() {
    final minKeep = _currentIndex - keepBehind;
    final maxKeep = _currentIndex + keepAhead;

    final toRemove = _controllers.keys
       .where((index) => index < minKeep || index > maxKeep)
       .toList();

    for (final index in toRemove) {
      unawaited(disposeController(index));
      debugPrint("Disposed unused controller [$index]");
    }
  }

  //---------------------------------------------------------------
  // PLAY
  //---------------------------------------------------------------
  Future<void> play(int index) async {
    try {
      final controller = _controllers[index];
      if (controller == null) return;
      if (!controller.value.isInitialized) return;
      if (!controller.value.isPlaying) {
        await controller.play();
      }
    } catch (e) {
      debugPrint("Play Error: $e");
    }
  }

  //---------------------------------------------------------------
  // PAUSE
  //---------------------------------------------------------------
  Future<void> pause(int index) async {
    try {
      final controller = _controllers[index];
      if (controller == null) return;
      if (controller.value.isPlaying) {
        await controller.pause();
      }
    } catch (e) {
      debugPrint("Pause Error: $e");
    }
  }

  //---------------------------------------------------------------
  // TOGGLE
  //---------------------------------------------------------------
  Future<void> toggle(int index) async {
    try {
      final controller = _controllers[index];
      if (controller == null) return;
      if (controller.value.isPlaying) {
        await controller.pause();
      } else {
        await controller.play();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //---------------------------------------------------------------
  // PAUSE ALL
  //---------------------------------------------------------------
  Future<void> pauseAll() async {
    for (final controller in _controllers.values) {
      try {
        if (controller.value.isInitialized && controller.value.isPlaying) {
          await controller.pause();
        }
      } catch (_) {}
    }
  }

  //---------------------------------------------------------------
  // RESUME
  //---------------------------------------------------------------
  Future<void> resume(int index) async {
    try {
      final controller = _controllers[index];
      if (controller == null) return;
      if (!controller.value.isInitialized) return;
      if (!controller.value.isPlaying) {
        await controller.play();
      }
    } catch (_) {}
  }

  //---------------------------------------------------------------
  // DISPOSE ONE
  //---------------------------------------------------------------
  Future<void> disposeController(int index) async {
    try {
      await _controllers[index]?.dispose();
    } catch (_) {}
    _controllers.remove(index);
    _initializing.remove(index);
    _failed.remove(index);
  }

  //---------------------------------------------------------------
  // DISPOSE ALL
  //---------------------------------------------------------------
  Future<void> disposeAll() async {
    final list = _controllers.values.toList();
    _controllers.clear();
    _failed.clear();
    _initializing.clear();
    for (final controller in list) {
      try {
        await controller.dispose();
      } catch (_) {}
    }
    debugPrint("All video controllers disposed.");
  }
}