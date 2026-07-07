import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:video_player/video_player.dart';
import 'package:wink_app/service/reels/video_controller_manager.dart';
import 'package:wink_app/service/reels/network-service.dart';


class ControllerHealthService {
  ControllerHealthService._();
  static final ControllerHealthService instance = ControllerHealthService._();

  Timer? _healthTimer;
  final Map<int, DateTime> _bufferStartTimes = {};
  final Map<int, int> _stallCount = {};
  final Map<int, String> _urlCache = {}; // Track URLs for recovery

  static const Duration healthCheckInterval = Duration(seconds: 2);
  static const Duration bufferTimeout = Duration(seconds: 10);
  static const int maxStalls = 3;

  void cacheUrl(int index, String url) {
    _urlCache[index] = url;
  }

  void start() {
    stop();
    _healthTimer = Timer.periodic(healthCheckInterval, (_) => _checkHealth());
  }

  void stop() {
    _healthTimer?.cancel();
    _healthTimer = null;
    _bufferStartTimes.clear();
    _stallCount.clear();
  }

  void _checkHealth() {
    final manager = VideoControllerManager.instance;

    for (final entry in manager.controllers.entries) {
      final index = entry.key;
      final controller = entry.value;
      final value = controller.value;

      // 1. Buffer timeout detector
      if (value.isBuffering) {
        _bufferStartTimes.putIfAbsent(index, () => DateTime.now());
        final bufferDuration = DateTime.now().difference(_bufferStartTimes[index]!);

        if (bufferDuration > bufferTimeout) {
          debugPrint('[HealthService] Buffer timeout at index $index. Recovering...');
          _recoverController(index);
          _bufferStartTimes.remove(index);
        }
      } else {
        _bufferStartTimes.remove(index);
      }

      // 2. Stall detector - playing but position not advancing
      if (value.isPlaying &&!value.isBuffering) {
        _detectStall(index, value);
      }

      // 3. Error recovery
      if (value.hasError) {
        debugPrint('[HealthService] Controller error at $index: ${value.errorDescription}');
        _recoverController(index);
      }
    }
  }

  final Map<int, Duration> _lastPositions = {};
  final Map<int, DateTime> _lastCheck = {};

  void _detectStall(int index, VideoPlayerValue value) {
    final now = DateTime.now();
    final lastPos = _lastPositions[index];
    final lastTime = _lastCheck[index];

    if (lastPos!= null && lastTime!= null) {
      final posDiff = value.position - lastPos;
      final timeDiff = now.difference(lastTime);

      // If 2+ seconds passed but position barely moved
      if (timeDiff.inSeconds >= 2 && posDiff.inMilliseconds < 100) {
        _stallCount[index] = (_stallCount[index]?? 0) + 1;
        debugPrint('[HealthService] Stall detected at $index. Count: ${_stallCount[index]}');

        if (_stallCount[index]! >= maxStalls) {
          debugPrint('[HealthService] Max stalls reached. Recovering $index');
          _recoverController(index);
          _stallCount[index] = 0;
        }
      } else {
        _stallCount[index] = 0; // Reset on progress
      }
    }

    _lastPositions[index] = value.position;
    _lastCheck[index] = now;
  }

  Future<void> _recoverController(int index) async {
    final manager = VideoControllerManager.instance;
    final controller = manager.controllerFor(index);
    if (controller == null) return;

    final url = _urlCache[index];
    if (url == null || url.isEmpty) {
      debugPrint('[HealthService] No cached URL for recovery at $index');
      return;
    }

    final wasPlaying = controller.value.isPlaying;
    final position = controller.value.position;

    await manager.disposeController(index);

    // Queue for retry via NetworkRetryService
    await NetworkRetryService.instance.addTask(
      id: 'recover_$index',
      priority: 10, // High priority
      task: () async {
        await manager.initializeVideo(
          index: index,
          url: url,
          autoPlay: wasPlaying,
        );
        if (position > Duration.zero) {
          await manager.controllerFor(index)?.seekTo(position);
        }
      },
    );
  }
}