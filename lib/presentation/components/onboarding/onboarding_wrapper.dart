import 'package:flutter/material.dart';
import 'package:wink_app/presentation/screens/onboarding/onboarding1_screen.dart' show Onboarding1Screen;
import 'package:wink_app/presentation/screens/onboarding/onboarding2_screen.dart' show Onboarding2Screen;
import 'package:wink_app/presentation/screens/onboarding/onboarding3_screen.dart';
import 'package:flutter/material.dart';
import 'package:wink_app/presentation/screens/onboarding/onboarding1_screen.dart';
import 'package:wink_app/presentation/screens/onboarding/onboarding2_screen.dart';
import 'package:wink_app/presentation/screens/onboarding/onboarding3_screen.dart';

class OnboardingWrapper extends StatefulWidget {
  const OnboardingWrapper({super.key});

  @override
  State<OnboardingWrapper> createState() => _OnboardingWrapperState();
}

class _OnboardingWrapperState extends State<OnboardingWrapper> {
  final PageController _controller = PageController();

  void _nextPage() {
    _controller.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _prevPage() {
    _controller.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        children: [
          Onboarding1Screen(onNext: _nextPage),
          Onboarding2Screen(onNext: _nextPage, onBack: _prevPage),
          Onboarding3Screen(onBack: _prevPage),
        ],
      ),
    );
  }
}