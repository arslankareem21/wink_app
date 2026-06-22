import 'package:flutter/material.dart';
import 'package:wink_app/core/config/theme/app_colors.dart';


class ShortsScreen extends StatelessWidget {
  const ShortsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Shorts Screen', style: TextStyle(fontSize: 24, color: AppColors.primaryYellow)),
    );
  }
}