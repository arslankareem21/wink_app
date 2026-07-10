import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wink_app/models/post_models.dart';


class PostsGrid extends StatelessWidget {
  final List<PostModels> posts;
  final Function(int index)? onPostTap; // Add this


  const PostsGrid({
    super.key,
    required this.posts,
    this.onPostTap, // Add this
  });


  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Text(
            "No Posts Yet",
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ),
      );
    }


    return SliverPadding(
      padding: EdgeInsets.all(2.w),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final post = posts[index];
            final imageUrl = post.media.isNotEmpty? post.media.first.url : '';


            return GestureDetector(
              onTap: () => onPostTap?.call(index), // Use callback
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(4.r),
                ),
                clipBehavior: Clip.antiAlias,
                child: imageUrl.isEmpty
                  ? const Icon(Icons.image, color: Colors.grey)
                    : Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          );
                        },
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.broken_image,
                          color: Colors.grey,
                        ),
                      ),
              ),
            );
          },
          childCount: posts.length,
        ),
      ),
    );
  }
}