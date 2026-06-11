import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wink_app/presentation/components/shorts/shorts_card.dart';
import 'package:wink_app/viewmodels/mediaservice_provider.dart';


class ShortsFeedScreen extends ConsumerStatefulWidget {
  const ShortsFeedScreen({super.key});

  @override
  ConsumerState<ShortsFeedScreen> createState() =>
      _ShortsFeedScreenState();
}

class _ShortsFeedScreenState
    extends ConsumerState<ShortsFeedScreen> {
  PageController controller = PageController();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final shortsAsync = ref.watch(shortStreamProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: shortsAsync.when(
        data: (shorts) {
          return PageView.builder(
            scrollDirection: Axis.vertical,
            controller: controller,
            onPageChanged: (i) {
              setState(() => currentIndex = i);
            },
            itemCount: shorts.length,
            itemBuilder: (context, index) {
              return ShortsCard(
                short: shorts[index],
                isActive: index == currentIndex,
              );
            },
          );
        },
        loading: () =>
            const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
      ),
    );
  }
}