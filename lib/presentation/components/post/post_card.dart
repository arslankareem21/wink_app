import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wink_app/models/post_model.dart';

import '../../../core/config/theme/app_colors.dart';


class PostCard extends StatelessWidget {
  final PostModel post;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onShare;
  final VoidCallback? onSave;

  const PostCard({
    super.key,
    required this.post,
    this.onLike,
    this.onComment,
    this.onShare,
    this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 10.h,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color:
                isDark ? AppColors.shadowDark : AppColors.shadowLight,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// ===================================================
          /// HEADER
          /// ===================================================

          Padding(
            padding: EdgeInsets.all(14.w),
            child: Row(
              children: [

                /// PROFILE IMAGE
                Container(
                  height: 42.h,
                  width: 42.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primaryYellow,
                      width: 1.5,
                    ),
                    image: DecorationImage(
                      image: NetworkImage(post.userImage),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                SizedBox(width: 12.w),

                /// NAME + TIME
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.userName,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      SizedBox(height: 2.h),

                      Text(
                        '${post.timeAgo} • ${post.location}',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.greyText,
                        ),
                      ),
                    ],
                  ),
                ),

                Icon(
                  Icons.more_horiz_rounded,
                  color: AppColors.greyText,
                  size: 22.sp,
                ),
              ],
            ),
          ),

          /// ===================================================
          /// POST IMAGE
          /// ===================================================

          ClipRRect(
            borderRadius: BorderRadius.circular(0.r),
            child: Image.network(
              post.postImage,
              height: 300.h,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          /// ===================================================
          /// ACTION BUTTONS
          /// ===================================================

          Padding(
            padding: EdgeInsets.only(
              left: 14.w,
              right: 14.w,
              top: 12.h,
            ),
            child: Row(
              children: [

                /// LIKE
                InkWell(
                  onTap: onLike,
                  child: Row(
                    children: [
                      Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: 22.sp,
                      ),

                      SizedBox(width: 4.w),

                      Text(
                        '${post.likes}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 18.w),

                /// COMMENT
                InkWell(
                  onTap: onComment,
                  child: Row(
                    children: [
                      Icon(
                        Icons.chat_bubble_outline_rounded,
                        size: 20.sp,
                      ),

                      SizedBox(width: 4.w),

                      Text(
                        '${post.comments}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 18.w),

                /// SHARE
                InkWell(
                  onTap: onShare,
                  child: Icon(
                    Icons.share_outlined,
                    size: 21.sp,
                  ),
                ),

                const Spacer(),

                /// SAVE
                InkWell(
                  onTap: onSave,
                  child: Icon(
                    Icons.bookmark_border_rounded,
                    size: 22.sp,
                  ),
                ),
              ],
            ),
          ),

          /// ===================================================
          /// CAPTION
          /// ===================================================

          Padding(
            padding: EdgeInsets.only(
              left: 14.w,
              right: 14.w,
              top: 12.h,
            ),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '${post.userName} ',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.color,
                    ),
                  ),

                  TextSpan(
                    text: post.caption,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.color,
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// VIEW COMMENTS
          Padding(
            padding: EdgeInsets.only(
              left: 14.w,
              top: 8.h,
              bottom: 16.h,
            ),
            child: Text(
              'View all ${post.comments} comments',
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.greyText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}