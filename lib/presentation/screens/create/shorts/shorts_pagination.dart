import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:wink_app/models/short_model.dart';

final shortsPaginationProvider = StateNotifierProvider.autoDispose<ShortsPagination, List<ShortModel>>((ref) {
  return ShortsPagination();
});

class ShortsPagination extends StateNotifier<List<ShortModel>> {
  ShortsPagination() : super([]);

  final _firestore = FirebaseFirestore.instance;
  final _random = Random();

  List<String> _allShortIds = [];
  final Set<String> _fetchedIds = {};
  bool _isLoading = false;
  bool _isRefreshing = false;
  bool _hasLoadedOnce = false;

  bool get isLoading => _isLoading;
  bool get isRefreshing => _isRefreshing;
  bool get hasLoadedOnce => _hasLoadedOnce;

  Future<void> fetchFirstBatch() async {
    if (_isRefreshing) return;
    _isRefreshing = true;

    try {
      // Get ALL IDs for random selection
      final idsSnap = await _firestore.collection("shorts").get();
      _allShortIds = idsSnap.docs.map((d) => d.id).toList();
      _allShortIds.shuffle(_random);

      _fetchedIds.clear();
      state = [];

      await _fetchRandomBatch(10);
      _hasLoadedOnce = true;
    } catch (e) {
      print('Error fetching shorts: $e');
    } finally {
      _isRefreshing = false;
    }
  }

  Future<void> refresh() async {
    if (_isRefreshing) return;
    await fetchFirstBatch();
  }

  Future<void> fetchMore() async {
    if (_isLoading || _allShortIds.isEmpty) return;
    _isLoading = true;

    try {
      await _fetchRandomBatch(5);
    } finally {
      _isLoading = false;
    }
  }

  Future<void> _fetchRandomBatch(int count) async {
    final availableIds = _allShortIds.where((id) => !_fetchedIds.contains(id)).toList();
    if (availableIds.isEmpty) return;

    final idsToFetch = availableIds.take(count).toList();
    _fetchedIds.addAll(idsToFetch);

    // Fetch docs - deleted ones won't return
    final futures = idsToFetch.map((id) =>
      _firestore.collection("shorts").doc(id).get()
    );

    final docs = await Future.wait(futures);

    final newShorts = docs
        .where((doc) => doc.exists)
        .map((doc) {
          try {
            return ShortModel.fromDoc(doc);
          } catch (_) {
            return null;
          }
        })
        .whereType<ShortModel>()
        .where((s) => s.videoUrl.isNotEmpty)
        .toList();

    state = [...state, ...newShorts];
  }
}