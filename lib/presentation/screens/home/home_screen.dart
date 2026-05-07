import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wink_app/core/config/theme/app_colors.dart';
import 'package:wink_app/core/config/theme/app_spacing.dart';
import 'package:wink_app/models/post_model.dart';
import 'package:wink_app/presentation/components/post/post_card.dart';
import 'package:wink_app/presentation/widgets/toogle_theme_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final posts = [
  PostModel(
    userName: 'sarah.creative',
    userImage:
        'https://i.pravatar.cc/300?img=5',
    location: 'Brooklyn, NY',
    timeAgo: '2 hours ago',
    postImage:
        'https://images.unsplash.com/photo-1518770660439-4636190af475',
    caption:
        'Throwback to when tech felt like magic! ✨ #retro #gaming #vibes',
    likes: 1200,
    comments: 84,
  ),
  PostModel(
    userName: 'sarah.creative',
    userImage:
        'https://i.pravatar.cc/300?img=5',
    location: 'Brooklyn, NY',
    timeAgo: '2 hours ago',
    postImage:
        'https://images.unsplash.com/photo-1518770660439-4636190af475',
    caption:
        'Throwback to when tech felt like magic! ✨ #retro #gaming #vibes',
    likes: 1200,
    comments: 84,
  ),
  PostModel(
    userName: 'sarah.creative',
    userImage:
        'https://i.pravatar.cc/300?img=5',
    location: 'Brooklyn, NY',
    timeAgo: '2 hours ago',
    postImage:
        'https://images.unsplash.com/photo-1518770660439-4636190af475',
    caption:
        'Throwback to when tech felt like magic! ✨ #retro #gaming #vibes',
    likes: 1200,
    comments: 84,
  ),
  PostModel(
    userName: 'sarah.creative',
    userImage:
        'https://i.pravatar.cc/300?img=5',
    location: 'Brooklyn, NY',
    timeAgo: '2 hours ago',
    postImage:
        'https://images.unsplash.com/photo-1518770660439-4636190af475',
    caption:
        'Throwback to when tech felt like magic! ✨ #retro #gaming #vibes',
    likes: 1200,
    comments: 84,
  ),
];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        leading: const ThemeToggleButton(),
      ),
      body: Stack(
        children: [
          Container(
            height: 200.h,
            width: 200.w,
            color: AppColors.primaryYellow,
          ),
          SizedBox(height: 16.h),
          ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return PostCard(
    post: posts[index],
        );
      },
    )
        ],
      ),
      );
    
  }
}