import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wink_app/presentation/components/shorts/shorts_card.dart';
import 'package:wink_app/presentation/provider/shorts_pagination.dart';

class ShortsFeedScreen extends ConsumerStatefulWidget {
  const ShortsFeedScreen({super.key});

  @override
  ConsumerState<ShortsFeedScreen> createState() => _ShortsFeedScreenState();
}

class _ShortsFeedScreenState extends ConsumerState<ShortsFeedScreen> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shorts = ref.watch(shortsPaginationProvider);
    final shortsNotifier = ref.read(shortsPaginationProvider.notifier);

    if (shorts.isEmpty) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        controller: _pageController,
        onPageChanged: (index) {
          setState(() => _currentIndex = index);
          // Load more when 2 videos from end
          if (index >= shorts.length - 2) {
            shortsNotifier.fetchMore();
          }
        },
        itemCount: shorts.length,
        itemBuilder: (context, index) {
          // Only init current + prev + next. Max 3 controllers alive
          final shouldInit = (index - _currentIndex).abs() <= 1;

          return ShortsCard(
            key: ValueKey(shorts[index].shortId), // Critical for dispose
            short: shorts[index],
            isActive: index == _currentIndex,
            shouldInit: shouldInit,
          );
        },
      ),
    );
  }
}