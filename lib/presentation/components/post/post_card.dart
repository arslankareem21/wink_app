import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:wink_app/core/config/theme/app_spacing.dart';
import 'package:wink_app/models/auth/user_model.dart';
import 'package:wink_app/models/post_model.dart';
import 'package:wink_app/models/post_models.dart';
import 'package:wink_app/models/user_model.dart';
import 'package:wink_app/viewmodels/post_viewmodel.dart';
import '../../../core/config/theme/app_colors.dart';

final userProvider = FutureProvider.family<UserModel, String>((
  ref,
  userId,
) async {
  final doc = await FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .get();
  return UserModel.fromDoc(doc);
});

final isLikedProvider =
    StreamProvider.family<bool, ({String postId, String userId})>((
      ref,
      params,
    ) {
      return ref
          .watch(postRepositoryProvider)
          .watchIsLiked(params.postId, params.userId);
    });

final isSavedProvider =
    StreamProvider.family<bool, ({String postId, String userId})>((
      ref,
      params,
    ) {
      return ref
          .watch(postRepositoryProvider)
          .watchIsSaved(params.postId, params.userId);
    });

class PostCard extends ConsumerWidget {
  final PostModels post;
  final String currentUserId;
  final VoidCallback? onComment;
  final VoidCallback? onShare;
  final ValueChanged<String>? onHashtagTap;
  final VoidCallback? onUserTap;

  const PostCard({
    super.key,
    required this.post,
    required this.currentUserId,
    this.onComment,
    this.onShare,
    this.onHashtagTap,
    this.onUserTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider(post.userId));
    final isLikedAsync = ref.watch(
      isLikedProvider((postId: post.postId, userId: currentUserId)),
    );
    final isSavedAsync = ref.watch(
      isSavedProvider((postId: post.postId, userId: currentUserId)),
    );
    final firstMedia = post.media.isNotEmpty ? post.media.first : null;

    return userAsync.when(
      loading: () => SizedBox(height: 400.h),
      error: (_, __) => const SizedBox.shrink(),
      data: (user) => Container(
        margin: EdgeInsets.only(bottom: 8.h),
        decoration: BoxDecoration(color: Theme.of(context).cardColor),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, user),
            if (firstMedia != null)
              _buildPostImage(firstMedia.url, ref, isLikedAsync.value ?? false),
            _buildActionButtons(
              context,
              ref,
              isLikedAsync.value ?? false,
              isSavedAsync.value ?? false,
            ),
            if (post.likesCount > 0) _buildLikesCount(),
            if (post.caption.isNotEmpty) _buildCaption(context, user.username),
            if (post.commentsCount > 0) _buildViewComments(context),
            Padding(
              padding: EdgeInsets.fromLTRB(12.w, 4.h, 12.w, 12.h),
              child: Text(
                _timeAgo(post.createdAt),
                style: TextStyle(fontSize: 11.sp, color: AppColors.greyText),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, UserModel user) {
    final hasProfilePic = user.profileImageUrl != null && user.profileImageUrl!.isNotEmpty;
    
    return Padding(
      padding: AppSpacing.cardPadding,
      child: Row(
        children: [
          CircleAvatar(
            radius: 16.r,
            backgroundColor: Colors.grey.shade300,
            backgroundImage: hasProfilePic 
                ? CachedNetworkImageProvider(user.profileImageUrl!) 
                : null,
            child: !hasProfilePic 
                ? Icon(Icons.person, size: 18.sp, color: Colors.grey.shade600)
                : null,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: GestureDetector(
              onTap: onUserTap,
              child: Text(
                user.username,
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Icon(Icons.more_horiz_rounded, size: 20.sp),
        ],
      ),
    );
  }

  /// Dynamic IG-STYLE: 1.91:1 to 4:5, Max height 548.h
  /// Fixed: Proper aspect ratio without FutureBuilder jank
  Widget _buildPostImage(String imageUrl, WidgetRef ref, bool isLiked) {
    return GestureDetector(
      onDoubleTap: () => _handleLike(ref),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 548.h),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          imageBuilder: (context, imageProvider) {
            return LayoutBuilder(
              builder: (context, constraints) {
                return FutureBuilder<Size>(
                  future: _getImageSize(imageProvider),
                  builder: (context, snapshot) {
                    double aspectRatio = 1; // default square while loading
                    
                    if (snapshot.hasData) {
                      final size = snapshot.data!;
                      aspectRatio = size.width / size.height;
                      // IG clamp: min 0.8 (4:5), max 1.91
                      aspectRatio = aspectRatio.clamp(0.8, 1.91);
                    }
                    
                    return AspectRatio(
                      aspectRatio: aspectRatio,
                      child: Container(
                        color: AppColors.hintLight,
                        child: Image(
                          image: imageProvider,
                          fit: BoxFit.contain,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
          placeholder: (context, url) => AspectRatio(
            aspectRatio: 1,
            child: Container(
              color: AppColors.hintLight,
              child: const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          ),
          errorWidget: (_, __, ___) => AspectRatio(
            aspectRatio: 1,
            child: Container(
              color: Colors.grey.shade200,
              child: Icon(Icons.broken_image_outlined, size: 40.sp),
            ),
          ),
        ),
      ),
    );
  }

  Future<Size> _getImageSize(ImageProvider imageProvider) async {
    final completer = Completer<Size>();
    final imageStream = imageProvider.resolve(const ImageConfiguration());
    final listener = ImageStreamListener((info, _) {
      if (!completer.isCompleted) {
        completer.complete(Size(
          info.image.width.toDouble(), 
          info.image.height.toDouble()
        ));
      }
    }, onError: (exception, stackTrace) {
      if (!completer.isCompleted) {
        completer.complete(const Size(1, 1));
      }
    });
    imageStream.addListener(listener);
    return completer.future;
  }

  Widget _buildActionButtons(
    BuildContext context,
    WidgetRef ref,
    bool isLiked,
    bool isSaved,
  ) {
    return Padding(
      padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 6.h),
      child: Row(
        children: [
          _ActionIcon(
            onTap: () => _handleLike(ref),
            child: Icon(
              isLiked ? Icons.favorite : Icons.favorite_border_rounded,
              color: isLiked ? Colors.red : Theme.of(context).iconTheme.color,
              size: 26.sp,
            ),
          ),
          SizedBox(width: 16.w),
          _ActionIcon(
            onTap: onComment,
            child: Icon(Icons.chat_bubble_outline_rounded, size: 24.sp),
          ),
          SizedBox(width: 16.w),
          _ActionIcon(
            onTap: onShare,
            child: Icon(Icons.send_outlined, size: 24.sp),
          ),
          const Spacer(),
          _ActionIcon(
            onTap: () => _handleSave(ref),
            child: Icon(
              isSaved ? Icons.bookmark : Icons.bookmark_border_rounded,
              size: 26.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLikesCount() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Text(
        '${_formatCount(post.likesCount)} likes',
        style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildCaption(BuildContext context, String username) {
    return Padding(
      padding: EdgeInsets.only(left: 12.w, right: 12.w, top: 4.h),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$username ',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
              recognizer: TapGestureRecognizer()..onTap = onUserTap,
            ),
            ..._parseCaption(context, post.caption),
          ],
        ),
      ),
    );
  }

  List<TextSpan> _parseCaption(BuildContext context, String caption) {
    final List<TextSpan> spans = [];
    final RegExp exp = RegExp(r'(#\w+|@\w+)');
    final matches = exp.allMatches(caption);

    int lastIndex = 0;
    final defaultStyle = TextStyle(
      fontSize: 13.sp,
      color: Theme.of(context).textTheme.bodyLarge?.color,
    );
    final linkStyle = TextStyle(fontSize: 13.sp, color: Colors.blue.shade400);

    for (final match in matches) {
      if (match.start > lastIndex) {
        spans.add(
          TextSpan(
            text: caption.substring(lastIndex, match.start),
            style: defaultStyle,
          ),
        );
      }
      final matchedText = match.group(0)!;
      spans.add(
        TextSpan(
          text: matchedText,
          style: linkStyle,
          recognizer: TapGestureRecognizer()
            ..onTap = () => onHashtagTap?.call(matchedText),
        ),
      );
      lastIndex = match.end;
    }

    if (lastIndex < caption.length) {
      spans.add(
        TextSpan(text: caption.substring(lastIndex), style: defaultStyle),
      );
    }

    return spans.isEmpty
        ? [TextSpan(text: caption, style: defaultStyle)]
        : spans;
  }

  Widget _buildViewComments(BuildContext context) {
    return GestureDetector(
      onTap: onComment,
      child: Padding(
        padding: EdgeInsets.only(left: 12.w, top: 6.h),
        child: Text(
          'View all ${post.commentsCount} comments',
          style: TextStyle(fontSize: 13.sp, color: AppColors.greyText),
        ),
      ),
    );
  }

  void _handleLike(WidgetRef ref) {
    ref
        .read(postRepositoryProvider)
        .toggleLike(postId: post.postId, userId: currentUserId);
  }

  void _handleSave(WidgetRef ref) {
    ref
        .read(postRepositoryProvider)
        .toggleSave(postId: post.postId, userId: currentUserId);
  }

  String _formatCount(int count) {
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}m';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}k';
    return count.toString();
  }

  String _timeAgo(DateTime? date) {
    if (date == null) return '';
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 7) return '${date.day}/${date.month}/${date.year}';
    if (diff.inDays > 0) return '${diff.inDays}d';
    if (diff.inHours > 0) return '${diff.inHours}h';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m';
    return 'now';
  }
}

class _ActionIcon extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;

  const _ActionIcon({required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Padding(padding: EdgeInsets.all(4.w), child: child),
    );
  }
}