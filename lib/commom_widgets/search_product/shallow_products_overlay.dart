import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import '../../core/domain/entities/entities.dart';
import 'components/components.dart';

class ShallowProductsOverlay {
  static final ShallowProductsOverlay _instance =
      ShallowProductsOverlay._internal();
  factory ShallowProductsOverlay() => _instance;
  ShallowProductsOverlay._internal();

  static OverlayEntry? _currentEntry;

  static void show({
    required BuildContext context,
    //! Uses a LayerLink to pin the suggestions exactly below the input field.
    required LayerLink layerLink,
    required void Function(ProductEntity) onSelected,
  }) {
    if (isShowing) return;
    final overlay = Overlay.of(context);
    _currentEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          width: MediaQuery.sizeOf(context).width - Sizes.p16,
          child: CompositedTransformFollower(
            link: layerLink,
            showWhenUnlinked: false,
            offset: const Offset(0, 57), // default DefaultTextFormField height
            child: Align(
              alignment: Alignment.topLeft,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: Breakpoint.desktop),
                child: ShallowResultsItems(
                  onSelected: (product) {
                    onSelected(product);
                    hide();
                  },
                ),
              ),
            ),
          ),
        );
      },
    );

    overlay.insert(_currentEntry!);
  }

  static void hide() {
    if (_currentEntry != null) {
      _currentEntry?.remove();
      _currentEntry = null;
    }
  }

  static bool get isShowing => _currentEntry != null;
}
