import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wink_app/core/config/theme/app_colors.dart';
import 'package:wink_app/core/config/theme/app_text_style.dart';

class SplashLoadingIndicator extends StatefulWidget {
  final double width;
  final bool showText;

  const SplashLoadingIndicator({
    super.key,
    this.width = 100,
    this.showText = true,
  });

  @override
  State<SplashLoadingIndicator> createState() => _SplashLoadingIndicatorState();
}

class _SplashLoadingIndicatorState extends State<SplashLoadingIndicator>
    with SingleTickerProviderStateMixin {

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(); // smooth infinite animation
  }

  @override
  void dispose() {
    _controller.dispose(); // ✅ no memory leak
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: widget.width.w,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return LinearProgressIndicator(
                value: _controller.value, // animated progress
                minHeight: 4.h,
                backgroundColor:
                    AppColors.primaryYellow.withOpacity(.2),
                valueColor: const AlwaysStoppedAnimation(
                  AppColors.primaryYellow,
                ),
              );
            },
          ),
        ),

        if (widget.showText) ...[
          SizedBox(height: 10.h),

          Text(
            "LOADING",
            style: AppTextStyles.loading,
          ),
        ],
      ],
    );
  }
}