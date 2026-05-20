// presentation/components/profile/profile_header.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wink_app/core/config/theme/app_colors.dart';
import 'package:wink_app/presentation/components/profile/other_profile/other_profile_status.dart';
import 'package:wink_app/presentation/widgets/circle_avatar.dart';

class OtherUserProfileHeader extends StatelessWidget {
  final String username;
  final String name;
  final String? profileImageUrl;

  const OtherUserProfileHeader({
    super.key,
    required this.username,
    required this.name,
    this.profileImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Profile Picture
        AppProfileAvatar(),
         OtherUserProfileStats(postsCount: 20, followersCount: 150.toString(), followingCount: 100)

      ],
    );
  }

  Widget _buildPlaceholder() {
    return Icon(
      Icons.person,
      size: 48.sp,
      color: AppColors.primaryYellow,
    );
  }
}