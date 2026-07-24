import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wink_app/core/config/theme/app_spacing.dart';

class AppProfileAvatar extends StatelessWidget {
  final double radius;
  final File? imageFile; // State se aayi hui file receive karein
  final VoidCallback? onChangePhoto;

  /// Accepts [String] (Network URL / Asset path), [File] (Picked image), or [null].
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

  const AppProfileAvatar({
    super.key,
    this.imageSource,
    this.size = 48,
    this.hasStory = false,
    this.isOnline = false,
    this.borderColor,
    this.onTap,
    this.isNetwork = false,
    String? profileImageUrl,
    this.imageFile,
     this.onChangePhoto,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    final double computedSize = size.w;

    // Resolve ImageProvider natively without complicating the build body
    // ImageProvider? getImageProvider() {
    //   if (imageSource == null) return null;

    //   if (imageSource is File) {
    //     return FileImage(imageSource as File);
    //   }

    //   if (imageSource is String) {
    //     final String path = imageSource as String;
    //     if (path.isEmpty) return null;

    //     return isNetwork
    //         ? NetworkImage(path)
    //         : AssetImage(path) as ImageProvider;
    //   }
    //   return null;
    // }

    // final imageProvider = getImageProvider();

    // final avatar = Container(
    //   height: computedSize,
    //   width: computedSize,
    //   padding: hasStory ? EdgeInsets.all(3.w) : EdgeInsets.zero,
    //   decoration: BoxDecoration(
    //     shape: BoxShape.circle,
    //     border: hasStory
    //         ? Border.all(
    //             color: borderColor ?? AppColors.primaryYellow,
    //             width: 2.5.w,
    //           )
    //         : null,
    //   ),
    //   child: Stack(
    //     clipBehavior: Clip.none,
    //     children: [
    //       // Explicit surface box decoration allows stable vector rendering of icons
    //       // alongside local/remote image caches inside standard containers
    //       Container(
    //         width: double.infinity,
    //         height: double.infinity,
    //         decoration: BoxDecoration(
    //           shape: BoxShape.circle,
    //           color: AppColors.greyText,
    //           image: imageProvider != null
    //               ? DecorationImage(
    //                   image: imageProvider,
    //                   fit: BoxFit.cover,
    //                 )
    //               : null,
    //         ),
    //         child: imageProvider == null
    //             ? Icon(
    //                 Icons.person,
    //                 size: (size * 0.55).w, // Dynamically proportioned silhouette scale
    //                 color: Colors.grey[600],
    //               )
    //             : null,
    //       ),

    //       /// Online Indicator Badge
    //       if (isOnline)
    //         Positioned(
    //           bottom: 1.w,
    //           right: 1.w,
    //           child: Container(
    //             height: (size * 0.25).w.clamp(10.0, 16.0),
    //             width: (size * 0.25).w.clamp(10.0, 16.0),
    //             decoration: BoxDecoration(
    //               color: Colors.green,
    //               shape: BoxShape.circle,
    //               border: Border.all(
    //                 color: Theme.of(context).scaffoldBackgroundColor,
    //                 width: 2.w,
    //               ),
    //             ),
    //           ),
    //         ),
    //     ],
    //   ),
    // );

    // if (onTap != null) {
    //   return GestureDetector(
    //     onTap: onTap,
    //     behavior: HitTestBehavior.opaque,
    //     child: avatar,
    //   );
    // }

    // return avatar;

    return Column(
      children: [

        GestureDetector(
  onTap: 
  onChangePhoto,
  child: CircleAvatar(
    radius: radius,
    backgroundColor: Colors.grey[300],
    backgroundImage: imageFile != null
        ? FileImage(imageFile!) // 1. Agar abhi gallery se pick ki hai (File)
        : (imageSource is String && imageSource != null && imageSource.toString().isNotEmpty)
            ? NetworkImage(imageSource.toString()) // 2. Agar internet/firebase ki URL hai
            : const AssetImage('assets/image/default_avatar.jpg') as ImageProvider, // 3. Fallback placeholder
  ),
),
        // GestureDetector(
        //   onTap: onChangePhoto,
        //   child: CircleAvatar(
        //     radius: radius,
        //     backgroundColor: Colors.grey[300],
        //     backgroundImage: imageFile != null
        //         ? FileImage(imageFile!)
        //         : const AssetImage('assets/images/default_avatar.png')
        //               as ImageProvider,
        //   ),
        // ),
        // AppSpacing.vsm,

        // Text(text ?? "", style: TextStyle(fontSize: textSize)),
      ],
    );
  }
}
