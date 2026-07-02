import 'package:cloud_firestore/cloud_firestore.dart';

///Yeh class direct Firebase Firestore (Database) se baat karti hai. Iska kaam sirf database
/// ke andar files ko dhoondna, add karna ya mitaana hai. Iske paas 3 main functions hain:

//isFollowing(me, other): Yeh Firestore mein ja kar check karti hai ke kya aapne samne wale ko
// follow kiya hua hai? Yeh true ya false return karti hai.

//follow(...): Yeh database mein ja kar aapki following list mein samne wale ki ID dalti hai,
//samne wale ke followers mein aapka naam daaliti hai, aur dono ke counters (followersCount, followingCount) ko +1 kar deti hai.

//unfollow(...): Yeh follow ka bilkul ulta kaam karti hai. Folders se data mita kar counters
//ko -1 kar deti hai.

//Note: Yeh class sirf database badalti hai, iska mobile ki screen par text badalney se koi lena dena nahi hai.

class FollowService {
  final _db = FirebaseFirestore.instance;

  Future<bool> isFollowing(String me, String other) async {
    if (me.isEmpty || other.isEmpty) {
      print("Warning: 'me' ya 'other' ID khaali hai!");
      return false;
    }

    try {
      final doc = await _db
          .collection('users')
          .doc(me)
          .collection('following')
          .doc(other)
          .get(
            const GetOptions(source: Source.serverAndCache),
          ); // Cache + Server dono check karega

      return doc.exists;
    } on FirebaseException catch (e) {
      print("Firestore Error in isFollowing: ${e.code} - ${e.message}");
      // Agar server unavailable ho, toh locally cache se check karne ki koshish karein
      try {
        final docCache = await _db
            .collection('users')
            .doc(me)
            .collection('following')
            .doc(other)
            .get(const GetOptions(source: Source.cache));
        return docCache.exists;
      } catch (_) {
        return false;
      }
    } catch (e) {
      print("Generic Error in isFollowing: $e");
      return false;
    }
  }

  Future<void> follow({
    required String me,
    required String other,
    required Map<String, dynamic> myData,
  }) async {
    try {
      final batch = _db.batch();

      final meRef = _db.collection('users').doc(me);
      final otherRef = _db.collection('users').doc(other);

      batch.set(otherRef.collection('followers').doc(me), {
        'uid': me,
        'username': myData['username'],
        'displayName': myData['displayName'],
        'profileImageUrl': myData['profileImageUrl'],
      });

      batch.set(meRef.collection('following').doc(other), {'uid': other});

      batch.update(meRef, {'followingCount': FieldValue.increment(1)});

      batch.update(otherRef, {'followersCount': FieldValue.increment(1)});

      await batch.commit();
    } on FirebaseException catch (e) {
      print("Firestore Error in follow: ${e.code} - ${e.message}");
      rethrow; // Isay rethrow karein taake UI level par user ko alert dikha sakein
    }
  }

  Future<void> unfollow({required String me, required String other}) async {
    try {
      final batch = _db.batch();

      final meRef = _db.collection('users').doc(me);
      final otherRef = _db.collection('users').doc(other);

      batch.delete(otherRef.collection('followers').doc(me));
      batch.delete(meRef.collection('following').doc(other));

      batch.update(meRef, {'followingCount': FieldValue.increment(-1)});

      batch.update(otherRef, {'followersCount': FieldValue.increment(-1)});

      await batch.commit();
    } on FirebaseException catch (e) {
      print("Firestore Error in unfollow: ${e.code} - ${e.message}");
      rethrow;
    }
  }
}

