// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:wink_app/models/auth/login_signup_model.dart';
// import '../models/user_model.dart';

// class AuthService {

// //final _auth = FirebaseAuth.instance;

// final FirebaseAuth _auth = FirebaseAuth.instance;

//    // ✅ Helper Method: Firebase errors ko user-friendly messages mein convert karein
//   void _handleAuthException(FirebaseAuthException e) {
//     switch (e.code) {
//       case 'user-not-found':
//         throw Exception('No user found with this email.');
//       case 'wrong-password':
//         throw Exception('Incorrect password.');
//       case 'email-already-in-use':
//         throw Exception('This email is already registered.');
//       case 'weak-password':
//         throw Exception('The password provided is too weak.');
//       case 'invalid-email':
//         throw Exception('The email address is badly formatted.');
//       case 'user-disabled':
//         throw Exception('This user account has been disabled.');
//       case 'too-many-requests':
//         throw Exception('Too many attempts. Please try again later.');
//       case 'operation-not-allowed':
//         throw Exception('This operation is not allowed.');
//       case 'network-request-failed':
//         throw Exception('Network error. Please check your connection.');
//       default:
//         throw Exception(e.message ?? 'Authentication failed. Please try again.');
//     }
//   }

//   // ✅ LOGIN Method with Error Handling
//   Future<UserModel> login(String email, String password) async {
//     try {
//       final credential = await _auth.signInWithEmailAndPassword(
//         email: email, 
//         password: password
//       );
      
//       final user = credential.user;
      
//       // ✅ Null check: Agar user null hai toh error pheko
//       if (user == null) {
//         throw Exception('Login failed. Please try again.');
//       }
      
//       // ✅ Firebase User → Your UserModel (Conversion)
//       return UserModel(
//         id: user.uid, 
//         name: user.displayName ?? '', 
//         email: user.email ?? '', username: ''
//       );
      
//     } on FirebaseAuthException catch (e) {
//       // ✅ Firebase error ko friendly message mein convert karke pheko
//       _handleAuthException(e);
//       // Ye line kabhi execute nahi hogi kyunki _handleAuthException hamesha throw karta hai
//       rethrow;
      
//     } catch (e) {
//       // ✅ Unknown errors ke liye generic message
//       throw Exception('An unexpected error occurred: ${e.toString()}');
//     }
//   }

//   // ✅ SIGNUP Method with Error Handling
//   Future<UserModel> signup( String email, String password) async {
//     try {
//       final credential = await _auth.createUserWithEmailAndPassword(
//         email: email, 
//         password: password,
//        // name: name
//       );
      
//       final user = credential.user;
      
//       // ✅ Null check
//       if (user == null) {
//         throw Exception('Signup failed. Please try again.');
//       }
      
//       // ✅ Display name update karein
//       // await user.updateDisplayName(name);
//       // await user.reload(); // Latest data load karein
      


//       // await _auth.collection('users').doc(user.uid).set({
//       //   'id': user.uid,
//       //   'name': user.displayName ?? '',
//       //   'email': email,
//       //   'username': email.split('@')[0], // Ek temporary username bana diya
//       //   'createdAt': FieldValue.serverTimestamp(),
//       // });

//       // ✅ Firebase User → Your UserModel (Conversion)
//       return UserModel(
//         id: user.uid, 
//         name: user.displayName ?? '', 
//         email: user.email ?? '', username: ''
//       );
      
//     } on FirebaseAuthException catch (e) {
//       // ✅ Firebase error ko friendly message mein convert karke pheko
//       _handleAuthException(e);
//       rethrow;
      
//     } catch (e) {
//       // ✅ Unknown errors ke liye generic message
//       throw Exception('An unexpected error occurred: ${e.toString()}');
//     }
//   }



// Future<void> signOut() async {
//     await GoogleSignIn.instance.signOut();
//     await _auth.signOut();
//   }


// Future<User?> signInWithGoogle() async {
//     final googleSignIn = GoogleSignIn.instance;

//     await googleSignIn.initialize(
//       serverClientId:
//           '621841020665-kr9g3ral0frjec3pgl22vbhtge419a90.apps.googleusercontent.com',
//     );

//     final googleUser = await googleSignIn.authenticate();

//     final idToken = googleUser.authentication.idToken;

//     final credential = GoogleAuthProvider.credential(
//       idToken: idToken,
//     );

//     final result = await _auth.signInWithCredential(credential);

//     return result.user;
//   }



// Future<void> saveUserDataToFirestore({
//   required String name,
//   required String email,
//   required String username,


// }) async {
//   try {
//     // STEP 1: Pehle .doc() ko khali chor kar reference banayein (Ab computer ko pata chal gaya docRef kya hai)
//     final docRef = FirebaseFirestore.instance.collection("users").doc();

//     // STEP 2: Ab docRef banne ke BAAD uski auto-generated ID nikaalein
//     final String autoGeneratedId = docRef.id; 

//     // STEP 3: Map ke andar us ID ko rukhien
//     Map<String, dynamic> userData = {
//       "id": autoGeneratedId, 
//       "name": name,
//       "email": email,
//       "username": username,
//       "createdAt": FieldValue.serverTimestamp(),
//       "bio" : "",
//       "followersCount" : 0,
//       "followingCount" : 0,
//       "postsCount" : 0,
//       "updatedAt" : FieldValue.serverTimestamp(),
//       "profileImageUrl" : "",
//     };

//     // STEP 4: Ab data ko database mein set (save) kar dein
//     await docRef.set(userData);
    
//     print('User document successfully created with ID: $autoGeneratedId');
//   } catch (e) {
//     throw Exception('Database mein data save nahi ho saka: $e');
//   }
// }









// }


//-------------------------------------------------------------

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wink_app/models/auth/login_signup_model.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  /// check username exists
  Future<bool> usernameExists(String username) async {
    final res = await _firestore
        .collection('users')
        .where('username', isEqualTo: username)
        .limit(1)
        .get();

    return res.docs.isNotEmpty;
  }

  /// generate unique username
  Future<String> generateUsername(String base) async {
    String username = base.toLowerCase().replaceAll(' ', '');
    int i = 0;

    while (await usernameExists(username)) {
      i++;
      username = '${base.toLowerCase().replaceAll(' ', '')}$i';
    }

    return username;
  }

  /// EMAIL SIGNUP
  Future<UserModel> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = cred.user!;
    final username = await generateUsername(name);

    final model = UserModel(
      userId: user.uid,
      name: name,
      email: email,
      username: username,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      authProvider: 'email',
    );

    await _firestore.collection('users').doc(user.uid).set(model.toMap());

    return model;
  }

  /// EMAIL LOGIN
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final doc =
        await _firestore.collection('users').doc(cred.user!.uid).get();

    return UserModel.fromDoc(doc);
  }

  /// GOOGLE SIGN IN (NEW SDK FIXED)
  Future<UserModel> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn.instance;

    await googleSignIn.initialize(
      serverClientId:
          '621841020665-kr9g3ral0frjec3pgl22vbhtge419a90.apps.googleusercontent.com',
    );

    final googleUser = await googleSignIn.authenticate();

    final idToken = googleUser.authentication.idToken;

    final credential = GoogleAuthProvider.credential(
      idToken: idToken,
    );

    final result = await _auth.signInWithCredential(credential);

    final user = result.user!;

    final docRef = _firestore.collection('users').doc(user.uid);
    final doc = await docRef.get();

    // If user already exists in Firestore → return existing
    if (doc.exists) {
      return UserModel.fromDoc(doc);
    }

    // Create Firestore user
    final username = await generateUsername(user.displayName ?? 'user',);

    final model = UserModel(
      userId: user.uid,
      name: user.displayName ?? 'User',
      email: user.email ?? '',
      username: username,
      profileImageUrl: user.photoURL,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      authProvider: 'google',
    );

    await docRef.set(model.toMap());

    return model;
  }

  /// SIGN OUT (NEW FIXED)
  Future<void> signOut() async {
    await GoogleSignIn.instance.signOut();
    await _auth.signOut();
  }

  /// SESSION RESTORE
  Future<UserModel?> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final doc =
        await _firestore.collection('users').doc(user.uid).get();

    if (!doc.exists) return null;

    return UserModel.fromDoc(doc);
  }

  /// PASSWORD RESET
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}