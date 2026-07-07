import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:wink_app/core/config/theme/app_spacing.dart';
import 'package:wink_app/core/config/theme/app_text_style.dart';

class OtherUserProfileHeader extends StatelessWidget {
  final String username;
  final String name;
  final int postsCount;
  final int followersCount;
  final int followingCount;
  final String? profileImageUrl;

  const OtherUserProfileHeader({
    super.key,
    required this.username,
    required this.name,
    required this.postsCount,
    required this.followersCount,
    required this.followingCount,
    this.profileImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            // Profile Image
            Container(
              width: 90.w,
              height: 90.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey[800]!, width: 2),
              ),
              child: ClipOval(
                child: profileImageUrl!= null && profileImageUrl!.isNotEmpty
                   ? CachedNetworkImage(
                        imageUrl: profileImageUrl!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[800],
                          child: Icon(Icons.person, size: 45.sp, color: Colors.grey),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[800],
                          child: Icon(Icons.person, size: 45.sp, color: Colors.grey),
                        ),
                      )
                    : Container(
                        color: Colors.grey[800],
                        child: Icon(Icons.person, size: 45.sp, color: Colors.grey),
                      ),
              ),
            ),
            // Stats
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStat('Posts', postsCount),
                  _buildStat('Followers', followersCount),
                  _buildStat('Following', followingCount),
                ],
              ),
            ),
          ],
        ),
        AppSpacing.vsm,
        // Name and Username
        Align(
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (name.isNotEmpty)
                Text(
                  name,
                  style: AppTextStyles.appBarBrandName,
                ),
              if (username.isNotEmpty && username!= 'no_username')...[
                SizedBox(height: 2.h),
                Text(
                  '@$username',
                  style: AppTextStyles.postUsername.copyWith(color: Colors.grey),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStat(String label, int count) {
    return Column(
      children: [
        Text(
          _formatCount(count),
          style: AppTextStyles.appBarTitle,
        ),
        SizedBox(height: 2.h),
        Text(
          label,
          style: AppTextStyles.appBarTitle,
        ),
      ],
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }
}