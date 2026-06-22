import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wink_app/core/config/theme/app_colors.dart';

class PostsGrid extends StatelessWidget {
  final List<String> imageUrls;
  final Function(String)? onImageTap;

  const PostsGrid({
    super.key,
    required this.imageUrls,
    this.onImageTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics:  BouncingScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2.w,
        mainAxisSpacing: 2.h,
        //scrollDirection: Axis.vertical,
      ),scrollDirection: Axis.vertical,
      itemCount: imageUrls.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => onImageTap?.call(imageUrls[index]),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              image: DecorationImage(
                image: NetworkImage(imageUrls[index]),
                fit: BoxFit.cover,
                onError: (exception, stackTrace) => _buildPlaceholder(),
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: AppColors.border.withValues(alpha: 0.1),
                  width: 1.w,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Decoration _buildPlaceholder() {
    return const BoxDecoration(
      color: AppColors.grey,
    );
  }
}