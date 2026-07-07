// shorts_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wink_app/models/short_model.dart';


class ShortsRepository {
  ShortsRepository(this._db);
  final FirebaseFirestore _db;
 
  CollectionReference<Map<String,dynamic>> get _shorts =>
      _db.collection('shorts');

  Stream<List<ShortModel>> watchShortsFeed({int limit=20}) {
    return _shorts
        .orderBy('createdAt', descending:true)
        .limit(limit)
        .snapshots()
        .map((s)=>s.docs.map((d)=>ShortModel.fromMap(d.data())).toList());
  }

  Future<void> incrementView(String id) async {
    try{
      await _shorts.doc(id)
          .update({'viewsCount':FieldValue.increment(1)});
    }catch(_){}
  }

  Future<void> toggleLike({
    required String shortId,
    required String userId,
  }) async {
    final short=_shorts.doc(shortId);
    final like=short.collection('likes').doc(userId);

    await _db.runTransaction((t) async{
      final doc=await t.get(like);
      if(doc.exists){
        t.delete(like);
        t.update(short,{'likesCount':FieldValue.increment(-1)});
      }else{
        t.set(like,{'createdAt':FieldValue.serverTimestamp()});
        t.update(short,{'likesCount':FieldValue.increment(1)});
      }
    });
  }

  Future<void> toggleFollow({
    required String followerId,
    required String followingId,
  }) async{
    final following=_db.collection('users').doc(followerId)
        .collection('following').doc(followingId);
    final followers=_db.collection('users').doc(followingId)
        .collection('followers').doc(followerId);

    await _db.runTransaction((t) async{
      final d=await t.get(following);
      if(d.exists){
        t.delete(following);
        t.delete(followers);
      }else{
        t.set(following,{'createdAt':FieldValue.serverTimestamp()});
        t.set(followers,{'createdAt':FieldValue.serverTimestamp()});
      }
    });
  }

  Stream<bool> watchIsLiked(String shortId,String uid){
    return _shorts.doc(shortId)
        .collection('likes').doc(uid)
        .snapshots().map((e)=>e.exists);
  }

  Stream<bool> watchIsFollowing(String me,String other){
    return _db.collection('users').doc(me)
        .collection('following').doc(other)
        .snapshots().map((e)=>e.exists);
  }

  Stream<Map<String,String>> watchUserInfo(String uid){
    return _db.collection('users').doc(uid).snapshots().map((d){
      final m=d.data()??{};
      return {
        'username':m['username']??'user',
        'profileUrl':m['profileImageUrl']??''
      };
    });
  }
}

final shortsRepositoryProvider=Provider<ShortsRepository>(
 (ref)=>ShortsRepository(FirebaseFirestore.instance),
);
