import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:wink_app/core/config/theme/app_spacing.dart';
import 'package:wink_app/core/config/theme/app_text_style.dart';
import 'package:wink_app/models/short_model.dart';
import 'package:wink_app/presentation/screens/reels/video_player_widget.dart';

class ShortsCard extends StatelessWidget {
  const ShortsCard({
    super.key,
    required this.short,
    required this.username,
    required this.profileUrl,
    required this.isLiked,
    required this.isFollowing,
    required this.isCurrentUser,
    required this.isLoading,
    required this.hasError,
    required this.controller,
    required this.onVideoTap,
    required this.onLike,
    required this.onFollow,
    required this.onComment,
    required this.onShare,
    required this.onUserTap,
  });

  final ShortModel short;

  final String username;
  final String profileUrl;

  final bool isLiked;
  final bool isFollowing;
  final bool isCurrentUser;

  final bool isLoading;
  final bool hasError;

  final controller;

  final VoidCallback onVideoTap;
  final VoidCallback onLike;
  final VoidCallback onFollow;
  final VoidCallback onComment;
  final VoidCallback onShare;
  final VoidCallback onUserTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [

        // Point 10: Tap to play/pause with opaque hit test
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onVideoTap,
          onDoubleTap: onLike,
          child: VideoPlayerWidget(
            controller: controller,
            isLoading: isLoading,
            hasError: hasError,
          ),
        ),

        IgnorePointer(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(.25),
                  Colors.black.withOpacity(.70),
                ],
              ),
            ),
          ),
        ),

        Positioned(
          left: 14.w,
          right: 90.w,
          bottom: 22.h,
          child: _LeftPanel(
            username: username,
            caption: short.caption,
            profileUrl: profileUrl,
            isCurrentUser: isCurrentUser,
            isFollowing: isFollowing,
            onFollow: onFollow,
            onUserTap: onUserTap,
          ),
        ),

        Positioned(
          right: 12.w,
          bottom: 24.h,
          child: _RightPanel(
            likes: short.likesCount,
            comments: short.commentsCount,
            views: short.viewsCount,
            isLiked: isLiked,
            onLike: onLike,
            onComment: onComment,
            onShare: onShare,
          ),
        ),
      ],
    );
  }
}

class _LeftPanel extends StatelessWidget {
  const _LeftPanel({
    required this.username,
    required this.caption,
    required this.profileUrl,
    required this.isCurrentUser,
    required this.isFollowing,
    required this.onFollow,
    required this.onUserTap,
  });

  final String username;
  final String caption;
  final String profileUrl;

  final bool isCurrentUser;
  final bool isFollowing;

  final VoidCallback onFollow;
  final VoidCallback onUserTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [

        GestureDetector(
          onTap: onUserTap,
          child: Row(
            children: [

              CircleAvatar(
                radius: 18.r,
                backgroundColor: Colors.grey.shade900,
                backgroundImage: profileUrl.isEmpty
                   ? null
                    : CachedNetworkImageProvider(profileUrl),
                child: profileUrl.isEmpty
                   ? const Icon(Icons.person)
                    : null,
              ),

              AppSpacing.hsm,

              Expanded(
                child: Text(
                  "@$username",
                  style: AppTextStyles.shortsUsername.copyWith(
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              if (!isCurrentUser)...[
                AppSpacing.hsm,

                GestureDetector(
                  onTap: onFollow,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 5.h,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      isFollowing
                         ? "Following"
                          : "Follow",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),

        AppSpacing.vmd,

        Text(
          caption,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.shortsCaption.copyWith(
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class _RightPanel extends StatelessWidget {
  const _RightPanel({
    required this.likes,
    required this.comments,
    required this.views,
    required this.isLiked,
    required this.onLike,
    required this.onComment,
    required this.onShare,
  });

  final int likes;
  final int comments;
  final int views;

  final bool isLiked;

  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        _ActionButton(
          icon: isLiked
             ? Icons.favorite
              : Icons.favorite_border,
          color: isLiked
             ? Colors.red
              : Colors.white,
          label: _format(likes),
          onTap: onLike,
        ),

        SizedBox(height: 20.h),

        _ActionButton(
          icon: Icons.chat_bubble_outline,
          label: _format(comments),
          onTap: onComment,
        ),

        SizedBox(height: 20.h),

        _ActionButton(
          icon: Icons.send_rounded,
          label: "",
          onTap: onShare,
        ),

        SizedBox(height: 20.h),

        _ActionButton(
          icon: Icons.remove_red_eye_outlined,
          label: _format(views),
          onTap: () {},
        ),
      ],
    );
  }

  static String _format(int value) {
    if (value >= 1000000) {
      return "${(value / 1000000).toStringAsFixed(1)}M";
    }

    if (value >= 1000) {
      return "${(value / 1000).toStringAsFixed(1)}K";
    }

    return value.toString();
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color = Colors.white,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [

          Icon(
            icon,
            color: color,
            size: 32.sp,
          ),

          SizedBox(height: 4.h),

          if (label.isNotEmpty)
            Text(
              label,
              style: AppTextStyles.shortsEngagementCount.copyWith(
                color: Colors.white,
              ),
            ),
        ],
      ),
    );
  }
}