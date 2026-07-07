import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

typedef RetryTask = Future<void> Function();

class NetworkRetryService {
  NetworkRetryService._();
  static final NetworkRetryService instance = NetworkRetryService._();

  final Connectivity _connectivity = Connectivity();
  final List<_RetryEntry> _queue = [];
  StreamSubscription? _connectivitySub;
  bool _isOnline = true;
  bool _processing = false;

  static const int maxRetry = 5;
  static const Duration baseDelay = Duration(seconds: 2);

  void init() {
    _connectivitySub?.cancel();
    _connectivitySub = _connectivity.onConnectivityChanged.listen((result) {
      final online = result!= ConnectivityResult.none;
      if (online &&!_isOnline) {
        debugPrint('[NetworkRetry] Internet recovered. Processing queue...');
        _isOnline = true;
        _processQueue();
      } else if (!online) {
        debugPrint('[NetworkRetry] Internet lost.');
        _isOnline = false;
      }
    });

    _checkInitialConnection();
  }

  Future<void> _checkInitialConnection() async {
    final result = await _connectivity.checkConnectivity();
    _isOnline = result!= ConnectivityResult.none;
  }

  Future<void> addTask({
    required String id,
    required RetryTask task,
    int priority = 0, // Higher = processed first
  }) async {
    // Remove duplicate
    _queue.removeWhere((e) => e.id == id);

    // If online, try immediately
    if (_isOnline) {
      try {
        await task();
        return;
      } on SocketException {
        // Network failed, queue it
      } catch (e) {
        debugPrint('[NetworkRetry] Task $id failed: $e');
        // Non-network error, don't retry
        return;
      }
    }

    // Queue for retry
    _queue.add(_RetryEntry(
      id: id,
      task: task,
      priority: priority,
      attempts: 0,
      nextRetry: DateTime.now(),
    ));

    _queue.sort((a, b) => b.priority.compareTo(a.priority));
    debugPrint('[NetworkRetry] Queued task: $id. Queue size: ${_queue.length}');
  }

  Future<void> _processQueue() async {
    if (_processing ||!_isOnline) return;
    _processing = true;

    while (_queue.isNotEmpty && _isOnline) {
      final entry = _queue.first;

      if (DateTime.now().isBefore(entry.nextRetry)) {
        await Future.delayed(entry.nextRetry.difference(DateTime.now()));
      }

      if (!_isOnline) break;

      try {
        await entry.task();
        _queue.removeAt(0);
        debugPrint('[NetworkRetry] Success: ${entry.id}');
      } on SocketException {
        entry.attempts++;
        if (entry.attempts >= maxRetry) {
          _queue.removeAt(0);
          debugPrint('[NetworkRetry] Max retries exceeded: ${entry.id}');
        } else {
          // Exponential backoff
          final delay = baseDelay * (1 << entry.attempts);
          entry.nextRetry = DateTime.now().add(delay);
          debugPrint('[NetworkRetry] Retry ${entry.attempts} for ${entry.id} in ${delay.inSeconds}s');
        }
      } catch (e) {
        _queue.removeAt(0);
        debugPrint('[NetworkRetry] Non-retryable error for ${entry.id}: $e');
      }
    }

    _processing = false;
  }

  void dispose() {
    _connectivitySub?.cancel();
    _queue.clear();
  }
}

class _RetryEntry {
  final String id;
  final RetryTask task;
  final int priority;
  int attempts;
  DateTime nextRetry;

  _RetryEntry({
    required this.id,
    required this.task,
    required this.priority,
    required this.attempts,
    required this.nextRetry,
  });
}