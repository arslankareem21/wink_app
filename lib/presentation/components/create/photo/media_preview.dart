// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class MediaPreviewCard extends StatelessWidget {
//   final String mediaPath;

//   const MediaPreviewCard({
//     super.key,
//     required this.mediaPath,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 320.h,
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: Colors.black,
//         borderRadius: BorderRadius.circular(16.r),
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(16.r),
//         child: Image.file(
//           File(mediaPath),
//           fit: BoxFit.contain,
//         ),
//       ),
//     );
//   }
// }