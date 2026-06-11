import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

/// Filter model
class FilterOption {
  final String name;
  final String icon;
  final int intensity; // 0-100

  FilterOption({
    required this.name,
    required this.icon,
    this.intensity = 0,
  });

  FilterOption copyWith({
    String? name,
    String? icon,
    int? intensity,
  }) {
    return FilterOption(
      name: name ?? this.name,
      icon: icon ?? this.icon,
      intensity: intensity ?? this.intensity,
    );
  }
}

/// Editor tool enum
enum EditorTool {
  crop,
  brush,
  text,
  sticker,
  adjust,
  more,
}

/// Edit state model
class EditState {
  final String? selectedFilter;
  final EditorTool selectedTool;
  final String textOverlay;
  final bool hasChanges;

  EditState({
    this.selectedFilter,
    this.selectedTool = EditorTool.text,
    this.textOverlay = '',
    this.hasChanges = false,
  });

  EditState copyWith({
    String? selectedFilter,
    EditorTool? selectedTool,
    String? textOverlay,
    bool? hasChanges,
  }) {
    return EditState(
      selectedFilter: selectedFilter ?? this.selectedFilter,
      selectedTool: selectedTool ?? this.selectedTool,
      textOverlay: textOverlay ?? this.textOverlay,
      hasChanges: hasChanges ?? this.hasChanges,
    );
  }
}

/// Available filters
final List<FilterOption> availableFilters = [
  FilterOption(name: 'Mono', icon: '⚫'),
  FilterOption(name: 'Vivid', icon: '🎨'),
  FilterOption(name: 'Retro', icon: '📷'),
  FilterOption(name: 'Neon', icon: '⚡'),
];

/// Riverpod providers

/// Edit state provider
final editStateProvider = StateNotifierProvider<EditStateNotifier, EditState>((ref) {
  return EditStateNotifier();
});

class EditStateNotifier extends StateNotifier<EditState> {
  EditStateNotifier() : super(EditState());

  void selectFilter(String filterName) {
    state = state.copyWith(
      selectedFilter: filterName,
      hasChanges: true,
    );
  }

  void selectTool(EditorTool tool) {
    state = state.copyWith(
      selectedTool: tool,
    );
  }

  void updateTextOverlay(String text) {
    state = state.copyWith(
      textOverlay: text,
      hasChanges: true,
    );
  }

  void clearChanges() {
    state = EditState();
  }

  void reset() {
    state = EditState();
  }
}

/// Selected filter provider (convenience)
final selectedFilterProvider = StateProvider<String?>((ref) {
  return ref.watch(editStateProvider).selectedFilter;
});

/// Selected tool provider (convenience)
final selectedToolProvider = StateProvider<EditorTool>((ref) {
  return ref.watch(editStateProvider).selectedTool;
});

/// Text overlay provider (convenience)
final textOverlayProvider = StateProvider<String>((ref) {
  return ref.watch(editStateProvider).textOverlay;
});

/// Has changes provider
final hasChangesProvider = StateProvider<bool>((ref) {
  return ref.watch(editStateProvider).hasChanges;
});

/// Available filters provider
final availableFiltersProvider = Provider<List<FilterOption>>((ref) {
  return availableFilters;
});