import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wink_app/models/post_models.dart';
import 'package:wink_app/models/short_model.dart';
import 'package:wink_app/presentation/components/post/post_card.dart';

import 'package:wink_app/presentation/components/shorts/shorts_card.dart';
class PostViewer extends ConsumerStatefulWidget {
  final List<PostModels> posts;
  final int initialIndex;
  final String currentUserId;

  const PostViewer({
    super.key,
    required this.posts,
    required this.initialIndex,
    required this.currentUserId,
  });

  @override
  ConsumerState<PostViewer> createState() => _PostViewerState();
}

class _PostViewerState extends ConsumerState<PostViewer> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.posts.length,
        itemBuilder: (context, index) {
          final post = widget.posts[index];
          return PostCard(
            post: post,
            currentUserId: widget.currentUserId,
            onUserTap: () => Navigator.pop(context),
          );
        },
      ),
    );
  }
}