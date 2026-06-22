
import 'package:cloud_firestore/cloud_firestore.dart';

class FollowService {
  final _db = FirebaseFirestore.instance;


  Future<bool> isFollowing(String me, String other) async {
  // Agar dono mein se koi ek ID bhi khaali hai, toh aage mat barhein
  if (me.isEmpty || other.isEmpty) {
    print("Warning: 'me' ya 'other' ID khaali hai!");
    return false; 
  }

  final doc = await _db
      .collection('users')
      .doc(me)
      .collection('following')
      .doc(other)
      .get();

  return doc.exists;
}

  Future<void> follow({
    required String me,
    required String other,
    required Map<String, dynamic> myData,
  }) async {
    final batch = _db.batch();

    final meRef = _db.collection('users').doc(me);
    final otherRef = _db.collection('users').doc(other);

    batch.set(
      otherRef.collection('followers').doc(me),
      {
        'uid': me,
        'username': myData['username'],
        'displayName': myData['displayName'],
        'profileImageUrl': myData['profileImageUrl'],
      },
    );

    batch.set(
      meRef.collection('following').doc(other),
      {
        'uid': other,
      },
    );

    batch.update(meRef, {
      'followingCount': FieldValue.increment(1),
    });

    batch.update(otherRef, {
      'followersCount': FieldValue.increment(1),
    });

    await batch.commit();
  }

  Future<void> unfollow({
    required String me,
    required String other,
  }) async {
    final batch = _db.batch();

    final meRef = _db.collection('users').doc(me);
    final otherRef = _db.collection('users').doc(other);

    batch.delete(otherRef.collection('followers').doc(me));
    batch.delete(meRef.collection('following').doc(other));

    batch.update(meRef, {
      'followingCount': FieldValue.increment(-1),
    });

    batch.update(otherRef, {
      'followersCount': FieldValue.increment(-1),
    });

    await batch.commit();
  }
}





// import 'package:cloud_firestore/cloud_firestore.dart';

// class FollowService {
//   final _db = FirebaseFirestore.instance;

//   // Check karna ke kya main is user ko already follow kar raha hu
//   Future<bool> isFollowing(String me, String other) async {
//     if (me.isEmpty || other.isEmpty) return false;

//     final doc = await _db
//         .collection('users')
//         .doc(me)            // Meri ID
//         .collection('following') // Meri following list
//         .doc(other)         // Samne wale ki ID
//         .get();

//     return doc.exists;
//   }

//   Future<void> follow({
//     required String me,
//     required String other,
//     required Map<String, dynamic> myData,
//   }) async {
//     if (me == other) return; // Koi banda khud ko follow nahi kar sakta

//     final batch = _db.batch();
//     final meRef = _db.collection('users').doc(me);
//     final otherRef = _db.collection('users').doc(other);

//     // 1. SAMNE WALE ke 'followers' mein MERA data jayega
//     batch.set(
//       otherRef.collection('followers').doc(me),
//       {
//         'uid': me,
//         'username': myData['username'] ?? '',
//         'displayName': myData['displayName'] ?? '',
//         'profileImageUrl': myData['profileImageUrl'] ?? '',
//       },
//     );

//     // 2. MERE 'following' mein SAMNE WALE ki sirf UID jayegi
//     batch.set(
//       meRef.collection('following').doc(other),
//       {
//         'uid': other,
//       },
//     );

//     // 3. 🎯 COUNTERS FIX:
//     // Meri sirf FOLLOWING barhegi
//     batch.update(meRef, {
//       'followingCount': FieldValue.increment(1),
//     });

//     // Doosre user ke sirf FOLLOWERS barhenge
//     batch.update(otherRef, {
//       'followersCount': FieldValue.increment(1),
//     });

//     await batch.commit();
//   }

//   Future<void> unfollow({
//     required String me,
//     required String other,
//   }) async {
//     if (me == other) return;

//     final batch = _db.batch();
//     final meRef = _db.collection('users').doc(me);
//     final otherRef = _db.collection('users').doc(other);

//     // Documents delete karna
//     batch.delete(otherRef.collection('followers').doc(me));
//     batch.delete(meRef.collection('following').doc(other));

//     // 🎯 COUNTERS DECREMENT FIX:
//     // Meri following kam hogi
//     batch.update(meRef, {
//       'followingCount': FieldValue.increment(-1),
//     });

//     // Uske followers kam honge
//     batch.update(otherRef, {
//       'followersCount': FieldValue.increment(-1),
//     });

//     await batch.commit();
//   }
// }