import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:wink_app/models/post_models.dart';
import 'package:wink_app/models/short_model.dart';
import 'package:wink_app/service/firestore_service.dart';

final userDataProvider = StreamProvider.family<DocumentSnapshot?, String>((ref, userId) {
  if (userId.trim().isEmpty) {
    return Stream.value(null);
  }
  return ref.read(firestoreServiceProvider).getUserStream(userId);
});

final userPostsProvider = StreamProvider.family<List<PostModels>, String>((ref, userId) {
  return ref.read(firestoreServiceProvider).getUserPosts(userId);
});

final userShortsProvider = StreamProvider.family<List<ShortModel>, String>((ref, userId) {
  return ref.read(firestoreServiceProvider).getUserShorts(userId);
});

// Real Firestore value
final isFollowingProvider = StreamProvider.family<bool, ({String currentUserId, String targetUserId})>((ref, params) {
  if (params.currentUserId == params.targetUserId) return Stream.value(false); // Can't follow yourself
  return ref.read(firestoreServiceProvider).isFollowing(params.currentUserId, params.targetUserId);
});

// Optimistic override: null = use stream, true/false = optimistic
final followOptimisticProvider = StateProvider.family<bool?, ({String currentUserId, String targetUserId})>((ref, params) {
  return null;
});

// Merged provider for UI
final isFollowingMergedProvider = Provider.family<AsyncValue<bool>, ({String currentUserId, String targetUserId})>((ref, params) {
  final optimistic = ref.watch(followOptimisticProvider(params));
  final stream = ref.watch(isFollowingProvider(params));
  if (optimistic!= null) return AsyncData(optimistic);
  return stream;
});