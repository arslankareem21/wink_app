import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wink_app/core/utils/validators.dart';
import 'package:wink_app/models/auth/user_model.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Bug 27 FIX: Don't pass clientId on Android. Let it read google-services.json
  // For iOS, it reads GoogleService-Info.plist automatically
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    // serverClientId: 'YOUR_WEB_CLIENT_ID', // Only if you need ID token for backend
  );

  User? get currentUser => _auth.currentUser;




  /// 1. Check karega ke kya user Google se logged in hai aur uske paas pehle se password provider nahi hai
  Future<bool> needsPasswordSetup() async {
    final user = _auth.currentUser;
    if (user == null) return false;

    // User ke saare login providers check karein (Google, Facebook, Email, etc.)
    final providerIds = user.providerData.map((info) => info.providerId).toList();

    // Agar user ke providers mein 'google.com' hai lekin 'password' (email/password) nahi hai, 
    // toh iska matlab use password set karne ki zaroorat hai.
    return providerIds.contains('google.com') && !providerIds.contains('password');
  }

  /// 2. Google user ke liye password set/link karne ka function
  Future<void> updatePassword(String password) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception("No authenticated user found.");
    }

    if (user.email == null) {
      throw Exception("User email not found.");
    }

    // 🌟 Step A: User ke current email aur naye password se credential banayein
    AuthCredential credential = EmailAuthProvider.credential(
      email: user.email!,
      password: password,
    );

    try {
      // 🌟 Step B: Is credential ko current Google account ke sath link kar dein
      // Is se user next time isi email aur password se bhi login kar sakega
      await user.linkWithCredential(credential);
    } on FirebaseException catch (e) {
      // Agar 'requires-recent-login' ka error aaye toh user ko re-authenticate karna parta hai
      if (e.code == 'requires-recent-login') {
        throw Exception("Security sensitive operation. Please re-login and try again.");
      } else if (e.code == 'provider-already-linked') {
        throw Exception("This account is already configured with a password.");
      } else {
        throw Exception(e.message ?? "Failed to set password.");
      }
    } catch (e) {
      throw Exception("An unexpected error occurred: $e");
    }
  }

  // Aapka current logged in user getter (agar file me pehle se na ho)





  Future<void> _syncUserToFirestore(
      User user,
      String provider, {
        String? name,
      }) async {
    final docRef = _db.collection('users').doc(user.uid);
    final doc = await docRef.get();

    if (!doc.exists) {
      final newUser = UserModel(
        userId: user.uid,
        name: name ?? user.displayName ?? 'New User',
        email: user.email ?? '',
        username: '${user.email?.split('@').first ?? 'user'}_${user.uid.substring(0, 5)}',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        authProvider: provider,
        hasPassword: provider == 'email',
      );
      await docRef.set(newUser.toMap());
    } else {
      await docRef.update({'updatedAt': Timestamp.now()});
    }
  }

  Future<UserCredential> signUp(
      String email,
      String password,
      String name,
      ) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = credential.user;
      if (user != null) {
        await user.updateDisplayName(name);
        await _syncUserToFirestore(user, 'email', name: name);
      }
      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleError(e, email);
    }
  }

  Future<UserCredential> signIn(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      await _syncUserToFirestore(cred.user!, 'email');
      return cred;
    } on FirebaseAuthException catch (e) {
      throw _handleError(e, email);
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) throw Exception('Sign in cancelled');

      final googleAuth = await googleUser.authentication;
      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        throw Exception('Google sign in failed. Try again.');
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      try {
        final userCredential = await _auth.signInWithCredential(credential);
        if (userCredential.user != null) {
          await _syncUserToFirestore(userCredential.user!, 'google');
        }
        return userCredential;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          throw Exception(
              'An account already exists with this email. Please login with Email & Password first.');
        }
        throw _handleError(e, null);
      }
    } catch (e) {
      // Catch GoogleSignIn exceptions too
      if (e is Exception) rethrow;
      throw Exception('Google sign in failed: ${e.toString()}');
    }
  }
  Future<bool> isUsernameAvailable(String username, {String? excludeUid}) async {
  final clean = username.trim().toLowerCase();

  // Use same validation as Validators.username
  if (Validators.username(clean)!= null) return false;

  final query = await _db
     .collection('users')
     .where('username', isEqualTo: clean)
     .limit(1)
     .get();

  if (query.docs.isEmpty) return true;
  if (excludeUid!= null && query.docs.first.id == excludeUid) return true;

  return false;
}

  Future<void> setPasswordForGoogleUser(String password) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');
    if (user.email == null) throw Exception('No email found');

    try {
      await user.reload();

      final hasEmailProvider = user.providerData
          .any((info) => info.providerId == EmailAuthProvider.PROVIDER_ID);

      if (hasEmailProvider) {
        await user.updatePassword(password);
      } else {
        final credential = EmailAuthProvider.credential(
          email: user.email!,
          password: password,
        );
        await user.linkWithCredential(credential);
      }

      await _db.collection('users').doc(user.uid).update({
        'hasPassword': true,
        'authProvider': 'google+email',
        'updatedAt': Timestamp.now(),
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login' || e.code == 'invalid-credential') {
        throw Exception('Session expired. Please login with Google again.');
      }
      if (e.code == 'email-already-in-use') {
        throw Exception('This email is already linked to another account.');
      }
      throw _handleError(e, user.email);
    }
  }

  // Future<bool> needsPasswordSetup() async {
  //   final user = _auth.currentUser;
  //   if (user == null) return false;

  //   try {
  //     final doc = await _db.collection('users').doc(user.uid).get();

  //     if (!doc.exists) {
  //       final isGoogle = user.providerData
  //           .any((info) => info.providerId == GoogleAuthProvider.PROVIDER_ID);
  //       return isGoogle;
  //     }

  //     final data = doc.data()!;
  //     final provider = data['authProvider'] as String? ?? 'email';
  //     final hasPassword = data['hasPassword'] as bool? ?? false;

  //     return provider.contains('google') && !hasPassword;
  //   } catch (e) {
  //     // If Firestore fails, block access for safety
  //     return true;
  //   }
  // }

  Future<void> sendResetLink(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw _handleError(e, email);
    }
  }

  Future<void> resetPassword(String newPassword) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not logged in');

      await user.reload();
      await user.updatePassword(newPassword);
      await _db.collection('users').doc(user.uid).update({
        'hasPassword': true,
        'updatedAt': Timestamp.now(),
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        throw Exception('Session expired. Please login again to reset password.');
      }
      throw _handleError(e, _auth.currentUser?.email);
    }
  }

  Future<void> signOut() async {

    try {
      await _googleSignIn.disconnect();
    } catch (_) {}
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
    await _auth.signOut();
  }

  Exception _handleError(FirebaseAuthException e, String? email) {
    final message = switch (e.code) {
      'user-not-found' => 'No account found with this email',
      'wrong-password' => 'Incorrect password',
      'invalid-credential' => 'Invalid credentials',
      'email-already-in-use' => 'Email already registered. Try logging in.',
      'weak-password' => 'Password must be at least 6 characters',
      'invalid-email' => 'Invalid email format',
      'user-disabled' => 'This account has been disabled',
      'too-many-requests' => 'Too many attempts. Try again later',
      'network-request-failed' => 'No internet connection',
      'operation-not-allowed' => 'Operation not allowed',
      'credential-already-in-use' => 'This account is already linked',
      'provider-already-linked' => 'Provider already linked',
      'account-exists-with-different-credential' =>
      'Account exists with different sign-in method. Use Email & Password.',
      'requires-recent-login' => 'Please login again to continue',
      _ => e.message ?? 'Authentication failed',
    };
    return Exception(message);
  }
}