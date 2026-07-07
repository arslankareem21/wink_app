import 'dart:async';
import 'package:flutter/foundation.dart';
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
      shorts: shorts?? this.shorts,
      currentIndex: currentIndex?? this.currentIndex,
      loading: loading?? this.loading,
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
  final Map<String, bool> _optimisticLikes = {}; // Local state for optimistic updates

  String get currentUserId =>
      FirebaseAuth.instance.currentUser?.uid?? "";

  void _initialize() {
    // Start health monitoring
    ControllerHealthService.instance.start();
    
    // Initialize network retry service
    NetworkRetryService.instance.init();
    
    _listen();
  }

  void _listen() {
    _sub?.cancel();
    _sub = _repo.watchShortsFeed().listen((list) async {
      state = state.copyWith(shorts: list, loading: false);

      if (list.isNotEmpty) {
        // Cache URLs in health service for recovery
        for (int i = 0; i < list.length; i++) {
          ControllerHealthService.instance.cacheUrl(i, list[i].videoUrl);
        }
        
        // Let manager handle autoplay + preload
        await video.onPageChanged(
          newIndex: 0,
          urls: list.map((e) => e.videoUrl).toList(),
        );
        state = state.copyWith(currentIndex: 0);
      }
    }, onError: (e) {
      state = state.copyWith(
        loading: false,
        error: e.toString(),
      );
    });
  }

  Future<void> onPageChanged(int index) async {
    if (index < 0 || index >= state.shorts.length) return;

    state = state.copyWith(currentIndex: index);

    // Cache current and nearby URLs
    for (int i = index - 2; i <= index + 4; i++) {
      if (i >= 0 && i < state.shorts.length) {
        ControllerHealthService.instance.cacheUrl(i, state.shorts[i].videoUrl);
      }
    }

    // Manager handles everything now
    await video.onPageChanged(
      newIndex: index,
      urls: state.shorts.map((e) => e.videoUrl).toList(),
    );

    unawaited(_repo.incrementView(state.shorts[index].shortId));
  }

  // Removed _preload - manager handles it

  VideoPlayerController? controller(int index)
      => video.controller(index);

  bool isLoading(int index)=>video.isLoading(index);
  bool hasError(int index)=>video.hasError(index);
  bool isBuffering(int index)=>video.isBuffering(index);

  Future<void> toggleVideo(int index)=>video.toggle(index);

  Future<void> pauseAll()=>video.pauseAll();

  Future<void> resumeCurrent()=>video.resume(state.currentIndex);

  Future<void> like(int index) async {
    if(currentUserId.isEmpty)return;
    if(index < 0 || index >= state.shorts.length) return;
    
    final shortId = state.shorts[index].shortId;
    
    // Optimistic update - toggle local state immediately
    _optimisticLikes[shortId] = !(_optimisticLikes[shortId] ?? false);
    
    // Update UI immediately
    state = state.copyWith();
    
    // Then update Firebase in background
    try {
      await _repo.toggleLike(
        shortId: shortId,
        userId: currentUserId,
      );
    } catch (e) {
      // Revert on failure
      _optimisticLikes.remove(shortId);
      state = state.copyWith();
      debugPrint('Like failed: $e');
    }
  }
  
  bool isLikedOptimistic(String shortId) {
    return _optimisticLikes[shortId] ?? false;
  }

  Future<void> follow(String userId) async {
    if(currentUserId.isEmpty)return;
    if(userId==currentUserId)return;

    await _repo.toggleFollow(
      followerId: currentUserId,
      followingId: userId,
    );
  }

  @override
  void dispose() {
    _sub?.cancel();
    ControllerHealthService.instance.stop();
    NetworkRetryService.instance.dispose();
    video.disposeAll();
    super.dispose();
  }
}

final shortsViewModelProvider =
StateNotifierProvider<ShortsViewModel, ShortsState>((ref){
  return ShortsViewModel(
    ref.watch(shortsRepositoryProvider),
  );
});

final userInfoProvider =
StreamProvider.family<Map<String,String>,String>((ref,id){
  return ref.watch(shortsRepositoryProvider)
     .watchUserInfo(id);
});

final isLikedProvider =
StreamProvider.family<bool,String>((ref,id){
  final uid=FirebaseAuth.instance.currentUser?.uid?? "";
  return ref.watch(shortsRepositoryProvider)
     .watchIsLiked(id,uid);
});

final isFollowingProvider =
StreamProvider.family<bool,String>((ref,id){
  final uid=FirebaseAuth.instance.currentUser?.uid?? "";
  return ref.watch(shortsRepositoryProvider)
     .watchIsFollowing(uid,id);
});