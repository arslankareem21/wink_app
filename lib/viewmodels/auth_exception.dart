// import 'package:firebase_auth/firebase_auth.dart';
//
// class AuthLinkRequiredException implements Exception {
//   final String email;
//   final AuthCredential? pendingCredential;
//   final List<String> existingProviders;
//   final bool requiresGoogleReauth;
//
//   const AuthLinkRequiredException({
//     required this.email,
//     this.pendingCredential,
//     this.existingProviders = const [],
//     this.requiresGoogleReauth = false,
//   });
//
//   bool get existingIsGoogle =>
//       existingProviders.contains('google.com');
//
//   bool get existingIsPassword =>
//       existingProviders.contains('password');
//
//   @override
//   String toString() {
//     return 'Account already exists with a different sign in method.';
//   }
// }