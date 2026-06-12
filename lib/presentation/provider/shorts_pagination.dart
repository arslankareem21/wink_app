import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:wink_app/models/short_model.dart';


final shortsPaginationProvider = StateNotifierProvider.autoDispose<ShortsPagination, List<ShortModel>>((ref) {
  return ShortsPagination();
});

class ShortsPagination extends StateNotifier<List<ShortModel>> {
  ShortsPagination() : super([]) {
    fetchFirstBatch();
  }

  DocumentSnapshot? _lastDoc;
  bool _hasMore = true;
  bool _isLoading = false;

  Future<void> fetchFirstBatch() async {
    final snap = await FirebaseFirestore.instance
     .collection("shorts")
     .orderBy("createdAt", descending: true)
     .limit(5)
     .get();

    _lastDoc = snap.docs.isNotEmpty? snap.docs.last : null;
    _hasMore = snap.docs.length == 5;
    state = _parseShorts(snap);
  }

  Future<void> fetchMore() async {
    if (!_hasMore || _isLoading || _lastDoc == null) return;
    _isLoading = true;

    final snap = await FirebaseFirestore.instance
     .collection("shorts")
     .orderBy("createdAt", descending: true)
     .startAfterDocument(_lastDoc!)
     .limit(5)
     .get();

    _lastDoc = snap.docs.isNotEmpty? snap.docs.last : _lastDoc;
    _hasMore = snap.docs.length == 5;
    state = [...state,..._parseShorts(snap)];
    _isLoading = false;
  }

  List<ShortModel> _parseShorts(QuerySnapshot snap) {
    return snap.docs
     .map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final videoUrl = data['videoUrl'] as String?? '';
        if (videoUrl.isEmpty) return null; // Skip broken docs

        return ShortModel.fromMap(data);
      })
     .whereType<ShortModel>()
     .toList();
  }
}