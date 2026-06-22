import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:wink_app/service/firestore_service.dart' hide firestoreProvider;
import 'package:wink_app/viewmodels/auth_viewmodel.dart';
import 'package:wink_app/viewmodels/mediaservice_provider.dart';

class ShortsViewModel extends StateNotifier<Map<String, dynamic>> {
  final FirestoreService _firestore;
  final String? currentUserId;
  final Ref _ref;

  ShortsViewModel(this._firestore, this.currentUserId, this._ref) : super({});

  // Track optimistic states: shortId -> isLiked
  Map<String, bool> get optimisticLikes => state['likes']?? {};
  // Track optimistic states: userId -> isFollowing
  Map<String, bool> get optimisticFollows => state['follows']?? {};
  // Track counted views: shortId -> bool
  Map<String, bool> get countedViews => state['views']?? {};

  Future<void> toggleLike(String shortId, bool currentlyLiked) async {
    if (currentUserId == null) return;

    // Optimistic update - instant UI
    final newLikes = Map<String, bool>.from(optimisticLikes);
    newLikes[shortId] =!currentlyLiked;
    state = {...state, 'likes': newLikes};

    try {
      if (!currentlyLiked) {
        await _firestore.likeShort(shortId, currentUserId!);
      } else {
        await _firestore.unlikeShort(shortId, currentUserId!);
      }
    } catch (e) {
      // Revert on error
      final revertLikes = Map<String, bool>.from(optimisticLikes);
      revertLikes[shortId] = currentlyLiked;
      state = {...state, 'likes': revertLikes};
      rethrow;
    }
  }

  Future<void> toggleFollow(String targetUserId, bool currentlyFollowing) async {
    if (currentUserId == null || currentUserId == targetUserId) return;

    // Optimistic update - instant UI
    final newFollows = Map<String, bool>.from(optimisticFollows);
    newFollows[targetUserId] =!currentlyFollowing;
    state = {...state, 'follows': newFollows};

    try {
      if (!currentlyFollowing) {
        await _firestore.followUser(currentUserId!, targetUserId);
      } else {
        await _firestore.unfollowUser(currentUserId!, targetUserId);
      }
      // Invalidate user provider to update profile followers count
      _ref.invalidate(userByIdProvider(targetUserId));
      _ref.invalidate(userByIdProvider(currentUserId!));
    } catch (e) {
      // Revert on error
      final revertFollows = Map<String, bool>.from(optimisticFollows);
      revertFollows[targetUserId] = currentlyFollowing;
      state = {...state, 'follows': revertFollows};
      rethrow;
    }
  }

  void markViewCounted(String shortId) {
    final newViews = Map<String, bool>.from(countedViews);
    newViews[shortId] = true;
    state = {...state, 'views': newViews};
  }

  bool isViewCounted(String shortId) => countedViews[shortId]?? false;
}

final shortsViewModelProvider = StateNotifierProvider<ShortsViewModel, Map<String, dynamic>>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  return ShortsViewModel(
    ref.read(firestoreProvider),
    userId,
    ref,
  );
});

// Check if short is liked - real-time from Firestore
final isShortLikedProvider = StreamProvider.family<bool, String>((ref, shortId) {
  final currentUserId = ref.watch(currentUserIdProvider);
  if (currentUserId == null) return Stream.value(false);

  return FirebaseFirestore.instance
     .collection('shorts')
     .doc(shortId)
     .collection('likes')
     .doc(currentUserId)
     .snapshots()
     .map((doc) => doc.exists);
});