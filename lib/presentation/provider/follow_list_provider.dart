import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wink_app/models/profile/follow_user_model.dart';
import 'package:wink_app/service/profile_service/follow_list_service.dart';

final followListServiceProvider =
    Provider((ref) => FollowListService());

final followersProvider =
    FutureProvider.family<List<FollowUserModel>, String>((ref, uid) {
  return ref.read(followListServiceProvider).getFollowers(uid);
});

final followingProvider =
    FutureProvider.family<List<FollowUserModel>, String>((ref, uid) {
  return ref.read(followListServiceProvider).getFollowing(uid);
});