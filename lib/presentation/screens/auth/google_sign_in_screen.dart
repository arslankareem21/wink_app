// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:wink_app/viewmodels/google_sign_in_viewmodel.dart';

// class GoogleSignInScreen extends ConsumerWidget {
//   const GoogleSignInScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final state = ref.watch(authViewModelProvider);
//     final vm = ref.read(authViewModelProvider.notifier);

//     return Scaffold(
//       appBar: AppBar(title: const Text("Google Sign In")),

//       body: Center(
//         child: state.isLoading
//             ? const CircularProgressIndicator()

//             : state.user == null
//                 ? ElevatedButton(
//                     onPressed: () {
//                       /// 👇 THIS is the actual call to ViewModel
//                       vm.signInWithGoogle();
//                     },
//                     child: const Text("Sign in with Google"),
//                   )

//                 : Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text(state.user!.email ?? ""),
//                       const SizedBox(height: 10),

//                       ElevatedButton(
//                         onPressed: () {
//                           vm.signOut();
//                         },
//                         child: const Text("Sign out"),
//                       ),
//                     ],
//                   ),
//       ),
//     );
//   }
// }