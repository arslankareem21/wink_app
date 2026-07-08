import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:video_player/video_player.dart';
import 'package:wink_app/service/reels/video_controller_manager.dart';
import 'package:wink_app/service/reels/reels_service.dart';
import 'package:wink_app/service/reels/controller-health-service.dart';
import 'package:wink_app/service/reels/network-service.dart';

import '../../models/short_model.dart';

class ShortsState {
  final List<ShortModel> shorts;
  final int currentIndex;
  final bool loading;
  final String? error;

  const ShortsState({
    this.shorts = const [],
    this.currentIndex = 0,
    this.loading = true,
    this.error,
  });

  ShortsState copyWith({
    List<ShortModel>? shorts,
    int? currentIndex,
    bool? loading,
    String? error,
  }) {
    return ShortsState(
      shorts: shorts ?? this.shorts,
      currentIndex: currentIndex ?? this.currentIndex,
      loading: loading ?? this.loading,
      error: error,
    );
  }
}

class ShortsViewModel extends StateNotifier<ShortsState> {
  ShortsViewModel(this._repo) : super(const ShortsState()) {
    _initialize();
  }

  final ShortsRepository _repo;
  final VideoControllerManager video = VideoControllerManager.instance;
  StreamSubscription<List<ShortModel>>? _sub;


  String get currentUserId => FirebaseAuth.instance.currentUser?.uid ?? "";

  void _initialize() {
    // Start health monitoring
    ControllerHealthService.instance.start();

    // Initialize network retry service
    NetworkRetryService.instance.init();

    _listen();
  }

  void _listen() {
    _sub?.cancel();
    _sub = _repo.watchShortsFeed().listen(
      (list) {
        unawaited(_handleFeedLoaded(list));
      },
      onError: (e) {
        state = state.copyWith(loading: false, error: e.toString());
      },
    );
  }

  Future<void> _handleFeedLoaded(List<ShortModel> list) async {
    try {
      state = state.copyWith(shorts: list, loading: false, error: null);

      if (list.isEmpty) {
        await video.pauseAll();
        return;
      }

      for (int i = 0; i < list.length; i++) {
        ControllerHealthService.instance.cacheUrl(i, list[i].videoUrl);
      }

      final currentIndex = state.currentIndex < list.length
          ? state.currentIndex
          : 0;
      await video.onPageChanged(
        newIndex: currentIndex,
        urls: list.map((e) => e.videoUrl).toList(),
      );
      state = state.copyWith(currentIndex: currentIndex);
    } catch (e) {
      state = state.copyWith(
        loading: false,
        error: 'Unable to load reels right now.',
      );
      debugPrint('Feed load failed: $e');
    }
  }

  Future<void> refreshFeed() async {
    try {
      state = state.copyWith(loading: true, error: null);
      final list = await _repo.fetchShortsFeed();
      await _handleFeedLoaded(list);
    } catch (e) {
      state = state.copyWith(
        loading: false,
        error: 'Unable to refresh reels right now.',
      );
      debugPrint('Refresh failed: $e');
    }
  }

  void onPageChanged(int index) {
    if (index < 0 || index >= state.shorts.length) return;

    state = state.copyWith(currentIndex: index);

    for (int i = index - 2; i <= index + 4; i++) {
      if (i >= 0 && i < state.shorts.length) {
        ControllerHealthService.instance.cacheUrl(i, state.shorts[i].videoUrl);
      }
    }

    unawaited(_loadPage(index));
  }

  Future<void> _loadPage(int index) async {
    try {
      await video.onPageChanged(
        newIndex: index,
        urls: state.shorts.map((e) => e.videoUrl).toList(),
      );
      unawaited(_repo.incrementView(state.shorts[index].shortId));
    } catch (e) {
      state = state.copyWith(error: 'Video could not be loaded.');
      debugPrint('Page load failed: $e');
    }
  }

  VideoPlayerController? controller(int index) => video.controller(index);

  bool isLoading(int index) => video.isLoading(index);
  bool hasError(int index) => video.hasError(index);
  bool isBuffering(int index) => video.isBuffering(index);

  Future<void> toggleVideo(int index) => video.toggle(index);

  Future<void> pauseAll() async {
    try {
      await video.pauseAll();
    } catch (_) {}
  }

  Future<void> resumeCurrent() async {
    try {
      await video.resume(state.currentIndex);
    } catch (_) {}
  }

  Future<void> toggleLike(String shortId) async {
    if (currentUserId.isEmpty) return;
    try {
      await _repo.toggleLike(shortId: shortId, userId: currentUserId);
    } catch (e) {
      debugPrint('Like failed: $e');
    }
  }

  Future<void> follow(String userId) async {
    if (currentUserId.isEmpty) return;
    if (userId == currentUserId) return;

    await _repo.toggleFollow(followerId: currentUserId, followingId: userId);
  }

  @override
  void dispose() {
    _sub?.cancel();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(pauseAll());
    });
    ControllerHealthService.instance.stop();
    NetworkRetryService.instance.dispose();
    super.dispose();
  }
}

final shortsViewModelProvider =
    StateNotifierProvider<ShortsViewModel, ShortsState>((ref) {
      return ShortsViewModel(ref.watch(shortsRepositoryProvider));
    });

final userInfoProvider = StreamProvider.family<Map<String, String>, String>((
  ref,
  id,
) {
  return ref.watch(shortsRepositoryProvider).watchUserInfo(id);
});

final isLikedProvider = StreamProvider.family<bool, String>((ref, id) {
  final uid = FirebaseAuth.instance.currentUser?.uid ?? "";
  return ref.watch(shortsRepositoryProvider).watchIsLiked(id, uid);
});

final isFollowingProvider = StreamProvider.family<bool, String>((ref, id) {
  final uid = FirebaseAuth.instance.currentUser?.uid ?? "";
  return ref.watch(shortsRepositoryProvider).watchIsFollowing(uid, id);
});
