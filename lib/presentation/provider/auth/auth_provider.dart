<<<<<<< HEAD
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wink_app/models/auth/user_model.dart';
import 'package:wink_app/service/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final authStateProvider = StreamProvider<UserModel?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});
=======
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:wink_app/models/auth/user_model.dart';
// import 'package:wink_app/service/login_auth_service.dart';

// final authServiceProvider = Provider<AuthService>((ref) {
//   return AuthService();
// });

// final authStateProvider = StreamProvider<UserModel?>((ref) {
//   return ref.watch(authServiceProvider).authStateChanges;
// });
>>>>>>> 695c57d403544df1debce3b0f216e0e23b4738b1
