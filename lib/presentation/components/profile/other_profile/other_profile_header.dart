import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wink_app/presentation/components/profile/other_profile/other_profile_status.dart';
import 'package:wink_app/presentation/widgets/circle_avatar.dart';
import 'package:wink_app/viewmodels/image_picker_vm.dart';

class OtherUserProfileHeader extends ConsumerWidget {
  final String username;
  final String name;
  final String? profileImageUrl;
  final int postsCount;
  final int followingCount;
  final int followersCount;

  const OtherUserProfileHeader({
    super.key,
    required this.username,
    required this.name,
    this.profileImageUrl,
    required this.postsCount,
    required this.followingCount,
    required this.followersCount,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pickedImageFile = ref.watch(imagePickerProvider);

    return Row(
      children: [
        // Profile Picture
        AppProfileAvatar(
          radius: 35.r,
          imageFile: pickedImageFile,
          //profileImageUrl: profileImageUrl,
          onChangePhoto: () {},
          textSize: 13.sp,
        ),

        OtherUserProfileStats(
          postsCount: postsCount,
          followersCount: followersCount.toString(),
          followingCount: followingCount,
        ),
      ],
    );
  }
}
