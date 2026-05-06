import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wink_app/models/auth/user_model.dart';
import 'package:wink_app/service/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final authStateProvider = StreamProvider<UserModel?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});