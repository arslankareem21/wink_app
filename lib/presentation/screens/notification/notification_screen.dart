import 'package:flutter/material.dart';
import 'package:wink_app/core/config/theme/app_colors.dart';


class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Notification Screen', style: TextStyle(fontSize: 24, color: AppColors.primaryYellow)),
    );
  }
}