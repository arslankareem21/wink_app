import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:video_player/video_player.dart';
import 'package:wink_app/service/reels/preload_queue.dart';
import 'package:wink_app/service/reels/controller-health-service.dart';

class VideoControllerManager {
  VideoControllerManager._();

  static final VideoControllerManager instance = VideoControllerManager._();

  static const Duration initializeTimeout = Duration(seconds: 15);
  static const int maxRetry = 3;
  static const int keepBehind = 2;
  static const int keepAhead = 4;
  static const Duration baseRetryDelay = Duration(seconds: 2);

  final Map<int, VideoPlayerController> _controllers = {};
  final Set<int> _initializing = {};
  final Set<int> _failed = {};
  final Map<int, int> _retryAttempts = {};
  int _currentIndex = 0;
  List<String> _urls = [];

  Map<int, VideoPlayerController> get controllers => _controllers;
  Set<int> get failed => _failed;

  bool isReady(int index) => _controllers[index]?.value.isInitialized?? false;
  bool isLoading(int index) => _initializing.contains(index);
  bool hasError(int index) => _failed.contains(index);

  VideoPlayerController? controller(int index) {
    return _controllers[index];
  }

  // Alias for preload_queue compatibility
  VideoPlayerController? controllerFor(int index) {
    return _controllers[index];
  }

  bool isBuffering(int index) {
    final controller = _controllers[index];
    if (controller == null) return false;
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

  Future<void> initializeVideo({
    required int index,
    required String url,
    bool autoPlay = false,
  }) async {
    if (_controllers.containsKey(index)) {
      if (autoPlay) await play(index);
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

    // Reset retry count for fresh attempts
    _retryAttempts[index] = 0;

    for (int attempt = 1; attempt <= maxRetry; attempt++) {
      VideoPlayerController? controller;
      _retryAttempts[index] = attempt;

      try {
        controller = VideoPlayerController.networkUrl(uri);

        // Initialize with timeout
        await controller.initialize().timeout(initializeTimeout);
        await controller.setLooping(true);
        await controller.setVolume(1);

        if (autoPlay) {
          await controller.play();
        }

        // Add listener for error tracking
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
        _retryAttempts.remove(index);

        debugPrint("Video initialized successfully [$index]");
        return;
      } on TimeoutException catch (_) {
        // Handle timeout (Cloudinary slow response)
        lastException = Exception("Video initialization timeout (attempt $attempt)");
        try {
          await controller?.dispose();
        } catch (_) {}
        debugPrint("Timeout initializing video [$index] Attempt $attempt");
      } catch (e) {
        // Handle socket errors and other network issues
        lastException = Exception(e.toString());
        try {
          await controller?.dispose();
        } catch (_) {}
        debugPrint("Initialization failed [$index] Attempt $attempt: $e");
      }

      if (attempt < maxRetry) {
        // Exponential backoff: 2s, 4s, 8s
        final delaySeconds = (baseRetryDelay.inSeconds * (1 << (attempt - 1)));
        final delay = Duration(seconds: delaySeconds);
        debugPrint("Retrying in ${delay.inSeconds}s... [$index]");
        await Future.delayed(delay);
      }
    }

    _failed.add(index);
    _retryAttempts.remove(index);
    debugPrint("All retries failed for [$index]: $lastException");
  }

  Future<void> preload({
    required int index,
    required String url,
  }) async {
    // Delegate to PreloadQueue for background preloading
    PreloadQueue.instance.enqueue(
      index: index,
      url: url,
      priority: 0,
    );
  }

  Future<void> onPageChanged({
    required int newIndex,
    required List<String> urls,
  }) async {
    if (newIndex < 0 || newIndex >= urls.length) return;

    _currentIndex = newIndex;
    _urls = urls;

    // Pause all except current
    for (final entry in _controllers.entries) {
      if (entry.key!= newIndex && entry.value.value.isPlaying) {
        await pause(entry.key);
      }
    }

    // Current page should autoplay
    await initializeVideo(
      index: newIndex,
      url: urls[newIndex],
      autoPlay: true,
    );

    // Cache URL in health service
    ControllerHealthService.instance.cacheUrl(newIndex, urls[newIndex]);

    // Preload ahead using PreloadQueue with priority based on distance
    for (int i = newIndex + 1;
        i <= newIndex + keepAhead && i < urls.length;
        i++) {
      final distance = i - newIndex;
      final priority = keepAhead - distance + 1; // Higher priority for closer videos
      
      debugPrint('[VideoManager] Queuing preload for index $i (priority: $priority)');
      PreloadQueue.instance.enqueue(
        index: i,
        url: urls[i],
        priority: priority,
      );
      ControllerHealthService.instance.cacheUrl(i, urls[i]);
    }

    // Also preload behind for smooth backward scrolling
    for (int i = newIndex - 1; i >= newIndex - keepBehind && i >= 0; i--) {
      debugPrint('[VideoManager] Queuing preload for index $i (priority: 1)');
      PreloadQueue.instance.enqueue(
        index: i,
        url: urls[i],
        priority: 1, // Lower priority
      );
      ControllerHealthService.instance.cacheUrl(i, urls[i]);
    }

    disposeUnused();
  }

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

  Future<void> pauseAll() async {
    for (final controller in _controllers.values) {
      try {
        if (controller.value.isInitialized && controller.value.isPlaying) {
          await controller.pause();
        }
      } catch (_) {}
    }
  }

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

  Future<void> disposeController(int index) async {
    try {
      await _controllers[index]?.dispose();
    } catch (_) {}
    _controllers.remove(index);
    _initializing.remove(index);
    _failed.remove(index);
    _retryAttempts.remove(index);
  }

  Future<void> disposeAll() async {
    // Stop health monitoring
    ControllerHealthService.instance.stop();
    
    // Clear preload queue
    PreloadQueue.instance.clear();
    
    final list = _controllers.values.toList();
    _controllers.clear();
    _failed.clear();
    _initializing.clear();
    _retryAttempts.clear();
    
    for (final controller in list) {
      try {
        await controller.dispose();
      } catch (_) {}
    }
    debugPrint("All video controllers disposed.");
  }
}