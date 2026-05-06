import 'package:firebase_auth/firebase_auth.dart';
import 'package:wink_app/models/auth/login_model.dart';
import 'package:wink_app/models/auth/user_model.dart';


class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<UserModel> login(LoginRequest request) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: request.email,
        password: request.password,
      );
      return UserModel.fromFirebase(credential.user!);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Login failed');
    }
  }

  Future<void> logout() async => await _firebaseAuth.signOut();

  Stream<UserModel?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map(
          (user) => user != null ? UserModel.fromFirebase(user) : null,
        );
  }
}