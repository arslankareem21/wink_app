import 'package:flutter/material.dart';
import 'package:wink_app/core/config/theme/app_colors.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Profile Screen', style: TextStyle(fontSize: 24, color: AppColors.primaryYellow)),
    );
  }
}