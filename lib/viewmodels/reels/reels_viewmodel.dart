import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:video_player/video_player.dart';
import 'package:wink_app/presentation/screens/reels/video_controller_manager.dart';
import 'package:wink_app/service/reels/reels_service.dart';

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
    _listen();
  }

  final ShortsRepository _repo;
  final VideoControllerManager video = VideoControllerManager.instance;
  StreamSubscription<List<ShortModel>>? _sub;

  String get currentUserId =>
      FirebaseAuth.instance.currentUser?.uid?? "";

  void _listen() {
    _sub?.cancel();
    _sub = _repo.watchShortsFeed().listen((list) async {
      state = state.copyWith(shorts: list, loading: false);

      if (list.isNotEmpty) {
        // Point 2: Let manager handle autoplay + preload
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
    await _repo.toggleLike(
      shortId: state.shorts[index].shortId,
      userId: currentUserId,
    );
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