import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import '../../core/domain/entities/entities.dart';
import 'components/components.dart';

/// PERFORMANCE: Singleton manager to handle floating search results.
/// It encapsulates the OverlayEntry lifecycle and uses TapRegion for
/// efficient "outside tap" detection.
class ShallowProductsOverlay {
  static final ShallowProductsOverlay _instance =
      ShallowProductsOverlay._internal();
  factory ShallowProductsOverlay() => _instance;
  ShallowProductsOverlay._internal();

  OverlayEntry? _currentEntry;

  /// PERFORMANCE: Uses a LayerLink to pin the suggestions exactly below the input field.
  void show({
    required BuildContext context,
    required LayerLink layerLink,
    required void Function(ProductEntity) onSelected,
    // required VoidCallback onTapOutside,
    required String groupId,
  }) {
    hide();

    final overlay = Overlay.of(context);
    _currentEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          width: MediaQuery.sizeOf(context).width - Sizes.p16,
          child: CompositedTransformFollower(
            link: layerLink,
            showWhenUnlinked: false,
            offset: const Offset(
              0,
              57,
            ), // Standard height for our DefaultTextFormField
            child: Align(
              alignment: Alignment.topLeft,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: Breakpoint.desktop, // Or a fixed value like 500
                ),
                child: ShallowResultsItems(onSelected: onSelected),
              ),
            ),
          ),
        );
      },
    );

    overlay.insert(_currentEntry!);
  }

  /// Removes the search suggestions from the screen.
  void hide() {
    if (_currentEntry != null) {
      _currentEntry?.remove();
      _currentEntry = null;
    }
  }

  bool get isShowing => _currentEntry != null;
}
