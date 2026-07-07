import 'dart:async';
import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:wink_app/service/reels/video_controller_manager.dart';


class PreloadQueue {
  PreloadQueue._();
  static final PreloadQueue instance = PreloadQueue._();

  final Queue<_PreloadJob> _queue = Queue();
  final Set<int> _inQueue = {};
  bool _processing = false;
  Timer? _throttleTimer;

  static const int maxConcurrent = 2; // Don't saturate bandwidth
  int _activeJobs = 0;

  void enqueue({
    required int index,
    required String url,
    int priority = 0,
  }) {
    if (_inQueue.contains(index)) return;
    if (VideoControllerManager.instance.controllerFor(index)!= null) return;

    _inQueue.add(index);
    _queue.add(_PreloadJob(index: index, url: url, priority: priority));

    // Sort by priority, then by distance from current
    final sorted = _queue.toList()
     ..sort((a, b) {
        final p = b.priority.compareTo(a.priority);
        if (p!= 0) return p;
        return a.index.compareTo(b.index);
      });

    _queue.clear();
    _queue.addAll(sorted);

    _scheduleProcess();
  }

  void _scheduleProcess() {
    _throttleTimer?.cancel();
    _throttleTimer = Timer(const Duration(milliseconds: 100), _process);
  }

  Future<void> _process() async {
    if (_processing) return;
    _processing = true;

    while (_queue.isNotEmpty && _activeJobs < maxConcurrent) {
      final job = _queue.removeFirst();
      _inQueue.remove(job.index);
      _activeJobs++;

      unawaited(_runJob(job));
    }

    _processing = false;
  }

  Future<void> _runJob(_PreloadJob job) async {
    try {
      debugPrint('[PreloadQueue] Preloading index ${job.index}');
      await VideoControllerManager.instance.preload(
        index: job.index,
        url: job.url,
      );
    } catch (e) {
      debugPrint('[PreloadQueue] Failed index ${job.index}: $e');
    } finally {
      _activeJobs--;
      if (_queue.isNotEmpty) _scheduleProcess();
    }
  }

  void clear() {
    _queue.clear();
    _inQueue.clear();
  }

  void dispose() {
    _throttleTimer?.cancel();
    clear();
  }
}

class _PreloadJob {
  final int index;
  final String url;
  final int priority;

  _PreloadJob({
    required this.index,
    required this.url,
    required this.priority,
  });
}