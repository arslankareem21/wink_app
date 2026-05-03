import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wink_app/viewmodels/theme_viewmodel.dart';



class ThemeToggleButton extends ConsumerWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    
    return IconButton(
      icon: Icon(
        theme == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode,
      ),
      onPressed: () => ref.read(themeProvider.notifier).toggleTheme(),
    );
  }
}