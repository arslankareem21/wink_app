import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wink_app/presentation/components/notification/notification_tile.dart';
import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_spacing.dart';
import '../../../core/config/theme/app_text_style.dart';
import '../../../viewmodels/notification_viewmodel.dart';

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch our state notifier async data stream
    final notificationState = ref.watch(notificationViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications', style: AppTextStyles.appBarTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: notificationState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text('Something went wrong', style: AppTextStyles.bodyRegular.copyWith(color: AppColors.error)),
        ),
        data: (notifications) {
          if (notifications.isEmpty) {
            return Center(
              child: Text(
                'No notifications yet',
                style: AppTextStyles.bodyRegular.copyWith(color: AppColors.grey),
              ),
            );
          }

          // Use the clean functional model extensions for formatting groupings
          final todayList = notifications.filterToday;
          final earlierList = notifications.filterEarlier;
          return ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              if (todayList.isNotEmpty) ...[
                _buildSectionHeader(context, 'New'),
                ...todayList.map((notification) => NotificationTile(
                      key: ValueKey(notification.id),
                      notification: notification,
                      onDismissed: (id) => ref.read(notificationViewModelProvider.notifier).deleteNotification(id),
                    )),
              ],
              if (earlierList.isNotEmpty) ...[
                AppSpacing.vmd,
                _buildSectionHeader(context, 'Earlier'),
                ...earlierList.map((notification) => NotificationTile(
                      key: ValueKey(notification.id),
                      notification: notification,
                      onDismissed: (id) => ref.read(notificationViewModelProvider.notifier).deleteNotification(id),
                    )),
              ],
              AppSpacing.vxxl,
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg.w,
        vertical: AppSpacing.md.h,
      ),
      child: Text(
        title,
        style: AppTextStyles.sectionHeaderCaps.copyWith(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.white
              : AppColors.secondary,
        ),
      ),
    );
  }
}