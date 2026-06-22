import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:wink_app/models/media_type.dart';
import 'package:wink_app/models/story_model.dart';
import 'package:wink_app/presentation/provider/story/story_repository.dart';

// Repository instance provider
final storyRepositoryProvider = Provider((ref) => StoryRepository());

// Realtime dynamic Stream Provider jo Firestore se data sync rakhega
final activeStoriesStreamProvider = StreamProvider<List<StoryModel>>((ref) {
  return ref.watch(storyRepositoryProvider).getActiveStoriesStream();
});
