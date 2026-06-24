import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:wink_app/models/auth/user_model.dart';
import 'package:wink_app/models/user_model.dart'; // ADD THIS
import 'package:wink_app/service/auth_service.dart';

enum AuthLoadingType {
  none,
  emailLogin,
  emailSignup,
  googleSignIn,
  resetRequest,
  setPassword,
}

class AuthState {
  final AuthLoadingType loadingType;
  final String? error;
  final String? message;
  final String? autofillEmail;
  final bool showPasswordDialog;
  final UserModel? user; // ADD THIS LINE

  const AuthState({
    this.loadingType = AuthLoadingType.none,
    this.error,
    this.message,
    this.autofillEmail,
    this.showPasswordDialog = false,
    this.user, // ADD THIS LINE
  });

  bool get isLoading => loadingType != AuthLoadingType.none;

  AuthState copyWith({
    AuthLoadingType? loadingType,
    String? error,
    String? message,
    String? autofillEmail,
    bool? showPasswordDialog,
    UserModel? user, // ADD THIS LINE
  }) {
    return AuthState(
      loadingType: loadingType ?? this.loadingType,
      error: error,
      message: message,
      autofillEmail: autofillEmail,
      showPasswordDialog: showPasswordDialog ?? this.showPasswordDialog,
      user: user ?? this.user, // ADD THIS LINE
    );
  }
}

class AuthViewModel extends StateNotifier<AuthState> {
  final AuthRepository _repo;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // ADD THIS
  
  AuthViewModel(this._repo) : super(const AuthState()) {
    _init(); // ADD THIS
  }

  // ADD THIS METHOD
  void _init() {
    FirebaseAuth.instance.authStateChanges().listen((firebaseUser) async {
      if (firebaseUser != null) {
        await _loadUser(firebaseUser.uid);
      } else {
        state = state.copyWith(user: null);
      }
    });
  }

  // ADD THIS METHOD
  Future<void> _loadUser(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        state = state.copyWith(user: UserModel.fromDoc(doc));
      }
    } catch (e) {
      print('Load user error: $e');
    }
  }

  // ADD THIS METHOD - call this after profile pic upload
  Future<void> refreshUser() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    await _loadUser(uid);
  }

  // Bug 10: Signup + auto logout
  Future<void> signup(String email, String password, String name) async {
    state = state.copyWith(
      loadingType: AuthLoadingType.emailSignup,
      error: null,
      message: null,
      autofillEmail: null,
    );
    try {
      await _repo.signUp(email, password, name);
      await _repo.signOut();
      state = state.copyWith(
        loadingType: AuthLoadingType.none,
        message: "Account created. Please login",
        autofillEmail: email,
        user: null, // Clear user on signup
      );
    } catch (e) {
      state = state.copyWith(
        loadingType: AuthLoadingType.none,
        error: _cleanError(e),
      );
    }
  }

  // Bug 8: Login
  Future<void> login(String email, String password) async {
    state = state.copyWith(
      loadingType: AuthLoadingType.emailLogin,
      error: null,
      message: null,
      autofillEmail: null,
    );
    try {
      await _repo.signIn(email, password);
      // _init listener will auto-load user
      state = state.copyWith(
        loadingType: AuthLoadingType.none,
        message: 'Login successful',
      );
    } catch (e) {
      state = state.copyWith(
        loadingType: AuthLoadingType.none,
        error: _cleanError(e),
      );
    }
  }

  // Bug 6, 7, 22, 27: Google Sign In + Stuck Button Fix
  Future<void> signInWithGoogle() async {
    state = state.copyWith(
      loadingType: AuthLoadingType.googleSignIn,
      error: null,
      message: null,
      autofillEmail: null,
      showPasswordDialog: false,
    );
    try {
      final result = await _repo.signInWithGoogle();
      
      if (result == null) {
        state = const AuthState();
        return;
      }

      final needsPassword = await _repo.needsPasswordSetup();
      if (needsPassword) {
        state = state.copyWith(
          loadingType: AuthLoadingType.none,
          showPasswordDialog: true,
        );
        return;
      }

      state = state.copyWith(
        loadingType: AuthLoadingType.none,
        message: 'Login successful',
      );
    } catch (e) {
      final msg = _cleanError(e);
      String? email;
      if (msg.contains('Please login with Email & Password')) {
        email = _repo.currentUser?.email;
      }
      state = state.copyWith(
        loadingType: AuthLoadingType.none,
        error: msg,
        autofillEmail: email,
      );
    }
  }

  // Bug 15, 20, 22, 25, 26, 29: Set password for Google user
  Future<void> setPasswordForGoogleUser(String password) async {
    state = state.copyWith(
      loadingType: AuthLoadingType.setPassword,
      error: null,
      autofillEmail: null,
    );
    try {
      await _repo.setPasswordForGoogleUser(password);
      state = state.copyWith(
        loadingType: AuthLoadingType.none,
        showPasswordDialog: false,
        message: 'Password set successfully',
      );
    } catch (e) {
      state = state.copyWith(
        loadingType: AuthLoadingType.none,
        error: _cleanError(e),
      );
    }
  }

  // Bug 20: Cancel password setup = logout
  Future<void> cancelPasswordSetup() async {
    await _repo.signOut();
    state = const AuthState(
      showPasswordDialog: false,
      message: 'Password setup required to continue',
      user: null,
    );
  }

  Future<void> signOut() async {
    await _repo.signOut();
    state = const AuthState(message: 'Signed out', user: null);
  }

  // Bug 15: Password reset
  Future<void> sendResetLink(String email) async {
    state = state.copyWith(
      loadingType: AuthLoadingType.resetRequest,
      error: null,
      message: null,
      autofillEmail: null,
    );
    try {
      await _repo.sendResetLink(email);
      state = state.copyWith(
        loadingType: AuthLoadingType.none,
        message: "Reset link sent to your email",
      );
    } catch (e) {
      state = state.copyWith(
        loadingType: AuthLoadingType.none,
        error: _cleanError(e),
      );
    }
  }

  void clearError() {
    state = state.copyWith(error: null, message: null, autofillEmail: null);
  }

  void clear() => state = const AuthState();

  String _cleanError(Object e) {
    return e.toString().replaceAll('Exception: ', '');
  }
}

final authViewModelProvider = StateNotifierProvider<AuthViewModel, AuthState>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return AuthViewModel(repo);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

final currentUserIdProvider = Provider<String?>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return authRepo.currentUser?.uid;
});


final currentUserProvider = StreamProvider<UserModel?>((ref) {
  final userId = FirebaseAuth.instance.currentUser?.uid;
  if (userId == null) return Stream.value(null);
  
  return FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .snapshots()
      .map((doc) => doc.exists ? UserModel.fromDoc(doc) : null);
});

final usernameAvailableProvider = FutureProvider.autoDispose.family<bool, ({String username, String uid})>((ref, params) async {
  if (params.username.trim().isEmpty) return true;
  final repo = ref.read(authRepositoryProvider);
  return await repo.isUsernameAvailable(params.username, excludeUid: params.uid);
});