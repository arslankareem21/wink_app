import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_spacing.dart';

class AppProfileAvatar extends StatelessWidget {
  /// Accepts [String] (Network URL / Asset path / Local file path), [File] (Picked image), or [null].
  final dynamic imageSource;

  /// Diameter of the avatar. Scales dynamically via ScreenUtil.
  final double size;

  /// Draws a stylized ring container around the image for stories/rings.
  final bool hasStory;

  /// Places a badge element in the stack representing real-time presence.
  final bool isOnline;

  /// Custom override for the story ring border color. Defaults to `AppColors.primaryYellow`.
  final Color? borderColor;

  /// Executed when the user clicks or taps on the component.
  final VoidCallback? onTap;

  /// Instructs the image string interpreter to treat string inputs as URLs.
  final bool isNetwork;

  final dynamic onChangePhoto;

  const AppProfileAvatar({
    super.key,
    this.imageSource,
    this.size = 48,
    this.hasStory = false,
    this.isOnline = false,
    this.borderColor,
    this.onTap,
    this.isNetwork = false,
   this.onChangePhoto,
  });

  @override
  Widget build(BuildContext context) {
    final double computedSize = size.w;

    // Fixed: Handle File, Network URL, Local file path, and Asset path correctly
    ImageProvider? getImageProvider() {
      if (imageSource == null) return null;

      // Case 1: File object
      if (imageSource is File) {
        return FileImage(imageSource as File);
      }

      // Case 2: String
      if (imageSource is String) {
        final String path = imageSource as String;
        if (path.isEmpty) return null;

        if (isNetwork) {
          // Network URL from Firestore/Cloudinary
          return NetworkImage(path);
        } else {
          // Check if it's a local file path
          if (path.startsWith('/') || path.contains('cache') || path.contains('data/user')) {
            // Local file path from image_picker
            return FileImage(File(path));
          } else {
            // Asset path
            return AssetImage(path);
          }
        }
      }
      return null;
    }

    final imageProvider = getImageProvider();

    final avatar = Container(
      height: computedSize,
      width: computedSize,
      padding: hasStory? EdgeInsets.all(3.w) : EdgeInsets.zero,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: hasStory
           ? Border.all(
                color: borderColor?? AppColors.primaryYellow,
                width: 2.5.w,
              )
            : null,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.greyText,
              image: imageProvider!= null
                 ? DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: imageProvider == null
               ? Icon(
                    Icons.person,
                    size: (size * 0.55).w,
                    color: Colors.grey[600],
                  )
                : null,
          ),

          if (isOnline)
            Positioned(
              bottom: 1.w,
              right: 1.w,
              child: Container(
                height: (size * 0.25).w.clamp(10.0, 16.0),
                width: (size * 0.25).w.clamp(10.0, 16.0),
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    width: 2.w,
                  ),
                ),
              ),
            ),
        ],
      ),
    );

    if (onTap!= null) {
      return GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: avatar,
      );
    }

    return avatar;
  }
}