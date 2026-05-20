import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wink_app/core/config/theme/app_spacing.dart';
import 'package:wink_app/core/config/theme/app_text_style.dart';
import 'package:wink_app/presentation/components/profile/other_profile/other_profile_header.dart';
import 'package:wink_app/presentation/components/profile/other_profile/other_profile_bio.dart';
import 'package:wink_app/presentation/components/profile/other_profile/other_profile_tab_controller.dart';
import 'package:wink_app/presentation/components/profile/pofile_dafault_tab_controller.dart';
import 'package:wink_app/presentation/widgets/elevated_button.dart';

class OtherProfileScreen extends ConsumerStatefulWidget {
  const OtherProfileScreen({super.key});

  @override
  ConsumerState<OtherProfileScreen> createState() => _OtherProfileScreenState();
}

class _OtherProfileScreenState extends ConsumerState<OtherProfileScreen> {
  // Profile Data
  final String _username = 'sara_j';
  final String _name = 'Sara Jamison';
  final String _category = 'Lifestyle & Fashion';
  final String _description = 'Creating daily aesthetics';
  final String _location = 'Los Angeles / NYC';
  final String _email = 'Collaboration: hello@sara.co';

  final int _postsCount = 128;
  final String _followersCount = '14k';
  final int _followingCount = 842;
  final bool _isFollowing = true;

  final List<String> _postsImages = [
    'https://picsum.photos/300/300?random=1',
    'https://picsum.photos/300/300?random=2',
    'https://picsum.photos/300/300?random=3',
    'https://picsum.photos/300/300?random=4',
    'https://picsum.photos/300/300?random=5',
    'https://picsum.photos/300/300?random=6',
    'https://picsum.photos/300/300?random=7',
    'https://picsum.photos/300/300?random=8',
    'https://picsum.photos/300/300?random=9',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App Bar
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(_username, style: AppTextStyles.appBarTitle),
        actions: [
          IconButton(
            icon: Icon(Icons.settings_outlined, size: 24.sp),
            onPressed: () {
              // Add to story
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  AppSpacing.vxl,

                  // Profile Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: OtherUserProfileHeader(
                      username: _username,
                      name: _name,
                    ),
                  ),

                  AppSpacing.vxl,

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: OtherUserProfileBio(
                      category: 'lifestyle & fashion',
                      description: 'creating daily aesthetics',
                      location: 'Los Angeles / NYC',
                      collaborationEmail: 'collaborationEmail: hello@sara.co',
                      name: 'Sara Jamison',
                    ),
                  ),
                  AppSpacing.vxl,

                  // Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      AppButton(
                        text: "Following",
                        width: 130.w,
                        isGhost: false,
                        onPressed: () {},
                      ),
                      AppSpacing.hlg,
                      AppButton(
                        text: "Message",
                        width: 130.w,
                        isGhost: true,
                        onPressed: () {},
                      ),
                    ],
                  ),

                  AppSpacing.vxl,
                  SizedBox(
                    height: 500.h,
                    child: OtherUserProfileTabController
                    (),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
