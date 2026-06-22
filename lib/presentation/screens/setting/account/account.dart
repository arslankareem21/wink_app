import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as ref;
import 'package:wink_app/core/config/theme/app_colors.dart';
import 'package:wink_app/core/config/theme/app_spacing.dart';
import 'package:wink_app/presentation/components/setting/setting_list_item.dart';
import 'package:wink_app/viewmodels/auth_viewmodel.dart';

// class SettingsAccountScreen extends   ConsumerStatefulWidget {
//   const SettingsAccountScreen({super.key});

//   @override
//   ConsumerState<SettingsAccountScreen> createState() => _SettingsAccountScreenState();
// }

// class _SettingsAccountScreenState extends ConsumerState<SettingsAccountScreen> {
//   TextEditingController google_pass_controller = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//       final authState = ref.watch(authViewModelProvider);

//     return Scaffold(
//       body: Center(
//         child: Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//              Container(
//                       height: 229.h,
//                       width: 350.w,
//                       decoration: BoxDecoration(
//                         color: AppColors.appBarTextDark,
//                         borderRadius: BorderRadius.circular(20.r),
//                       ),
//                       child: SingleChildScrollView(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           children: [
//                             AppSpacing.vsm,
//                             SettingsRow(
//                               Icons.person_outlined,
//                               'email and password',
//                               AppColors.primaryYellow,
//                               () {
//                                final password = google_pass_controller.text.trim();
            
//             // Alag se password set karne ka function call ho gaya!
//                   ref.read(authViewModelProvider.notifier).setupGoogleUserPassword(password);
//                               },
//                             ),
//                             Divider(color: AppColors.border),
//                             SettingsRow(
//                               Icons.lock_outlined,
//                               'Privacy',
//                               AppColors.info,
//                               () {
//                                 // Navigator.push(
//                                 //   context,
//                                 //   MaterialPageRoute(
//                                 //     builder: (context) => const SignUpScreen(),
//                                 //   ),
//                                 // );
//                               },
//                             ),
//                             Divider(color: AppColors.border),
        
//                             SettingsRow(
//                               Icons.notifications_outlined,
//                               'Notifications',
//                               Colors.orange,
//                               () {
//                                 // Navigator.push(
//                                 //   context,
//                                 //   MaterialPageRoute(
//                                 //     builder: (context) => const ForgetPasswordScreen(),
//                                 //   ),
//                                 // );
//                               },
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//           ],
//         ),
//       ) ,
//     );
//   }
// }




//     final authState = ref.watch(authViewModelProvider);


//       TextEditingController google_pass_controller = TextEditingController();

// @override
//   Widget build(BuildContext context) {
//     // ❌ Pehle line par jo ref.watch tha, use yahan se REMOVE kar diya hai!

//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(title: const Text("Account Settings")),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             // --- Aapka Container aur SettingsRow bilkul same rahega ---
//             Container(
//               height: 229.h,
//               width: 350.w,
//               decoration: BoxDecoration(
//                 color: AppColors.appBarTextDark,
//                 borderRadius: BorderRadius.circular(20.r),
//               ),
//               child: SingleChildScrollView(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     AppSpacing.vsm,
//                     SettingsRow(
//                       Icons.person_outlined,
//                       'Account',
//                       AppColors.primaryYellow,
//                       () {
//                         final password = google_pass_controller.text.trim();
//                         if (password.isNotEmpty) {
//                           ref.read(authViewModelProvider.notifier).setupGoogleUserPassword(password);
//                         } else {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(content: Text("Please enter a password first")),
//                           );
//                         }
//                       },
//                     ),
//                     Divider(color: AppColors.border),
//                     SettingsRow(Icons.lock_outlined, 'Privacy', AppColors.info, () {}),
//                     Divider(color: AppColors.border),
//                     SettingsRow(Icons.notifications_outlined, 'Notifications', Colors.orange, () {}),
//                   ],
//                 ),
//               ),
//             ),
            
//             AppSpacing.vsm,

//             // 🌟 SOLUTION: Sirf Loader ko 'Consumer' mein wrap kiya taake sirf yeh hissa rebuild ho
//             Consumer(
//               builder: (context, ref, child) {
//                 // Yeh sirf loading status ko watch karega, poori screen ko disturb nahi karega
//                 final isLoading = ref.watch(authViewModelProvider.select((state) => state.isLoading));
                
//                 if (!isLoading) return const SizedBox.shrink(); // Agar loading nahi hai toh kuch nahi dikhega
                
//                 return Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: CircularProgressIndicator(color: AppColors.primaryYellow),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }