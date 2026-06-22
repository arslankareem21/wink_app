import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wink_app/presentation/widgets/circle_avatar.dart';
import 'package:wink_app/presentation/widgets/elevated_button.dart';
import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_spacing.dart';
import '../../../core/config/theme/app_text_style.dart';

import '../../../models/notification_model.dart';

class NotificationTile extends StatelessWidget {
  final AppNotificationModel notification;
  final Function(String id) onDismissed;

  const NotificationTile({
    super.key,
    required this.notification,
    required this.onDismissed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      // Pass the deletion event up to the parent framework
      onDismissed: (_) => onDismissed(notification.id),
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
        color: AppColors.error,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w, vertical: AppSpacing.sm.h),
        child: Row(
          children: [
            // Uses your custom reusable AppProfileAvatar widget
            AppProfileAvatar(
              size: 44,
              imageSource: notification.userAvatar,
              isNetwork: notification.userAvatar != null, onChangePhoto: () {  }, textSize: 15.sp, radius: 35.r,
            ),
            AppSpacing.hlg,
            
            // Notification Text Context
            Expanded(
              child: RichText(
                text: TextSpan(
                  text: '${notification.username} ',
                  style: AppTextStyles.postUsername.copyWith(
                    color: isDark ? AppColors.white : AppColors.secondary,
                  ),
                  children: [
                    TextSpan(
                      text: notification.message,
                      style: AppTextStyles.bodyRegular.copyWith(
                        color: isDark ? AppColors.greyText : AppColors.subtitleLight,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AppSpacing.hmd,

            // Action elements: Follow CTA button or Thumbnail Preview
            _buildActionSlot(context),
          ],
        ),
      ),
    );
  }

  Widget _buildActionSlot(BuildContext context) {
    if (notification.type == NotificationType.follow) {
      return AppButton(
        text: 'Follow back',
        height: 28.h,
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.w),
        borderRadius: 8,
        onPressed: () {},
      );
    }

    if (notification.postImage != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8.r),
        child: SizedBox(
          width: 40.w,
          height: 40.w,
          child: Image.network(
            notification.postImage!,
            fit: BoxFit.cover,
            // ignore: unnecessary_underscores
            errorBuilder: (_, __, ___) => Container(color: AppColors.greyDark),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}