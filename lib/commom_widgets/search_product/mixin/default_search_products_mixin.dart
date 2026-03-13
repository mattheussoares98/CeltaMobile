import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/infraestructure/infrastructure.dart';
import '../../../core/presentation/controllers/products/products.dart';
import '../search_product.dart';

mixin DefaultSearchProductsMixin<T extends ConsumerStatefulWidget>
    on ConsumerState<T> {
  Timer? _debounce;

  void onTextChanged({
    required LayerLink layerLink,
    required GlobalKey<FormState> formKey,
    required TextEditingController controller,
    required void Function(int?) onProductSelected,
  }) async {
    if (controller.text.isEmpty) {
      ref.invalidate(shallowProductsStateControllerProvider);
      ShallowProductsOverlay.hide();
      return;
    }

    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (!mounted) return;

      // The "Double-Check" Guard.
      // We check the LATEST value of the controller before triggering the API.
      // If the user erased the text while the timer was counting, we stop.
      final currentText = controller.text;
      if (currentText.length < 3) {
        ShallowProductsOverlay.hide();
        return;
      }

      await ref
          .read(shallowProductsStateControllerProvider.notifier)
          .load(currentText);

      // Second Guard.
      // After the 'await load' (network call), the user might have erased
      // the field. We only show the overlay if the field is still valid.
      if (mounted && controller.text.length >= 3) {
        _showOverlay(
          layerLink: layerLink,
          formKey: formKey,
          controller: controller,
          onProductSelected: onProductSelected,
        );
      } else {
        ShallowProductsOverlay.hide();
      }
    });
  }

  void _showOverlay({
    required LayerLink layerLink,
    required GlobalKey<FormState> formKey,
    required TextEditingController controller,
    required void Function(int?) onProductSelected,
  }) {
    ShallowProductsOverlay.show(
      context: context,
      layerLink: layerLink,
      onSelected: (product) {
        controller.text = product.PLU ?? product.Name ?? '';
        ShallowProductsOverlay.hide();
        onProductSelected(product.codigoInternoProEmb);
      },
    );
  }

  void onSearch(
    GlobalKey<FormState> formKey, {
    bool? searchByCamera,
    required TextEditingController controller,
    required void Function(int?) onProductSelected,
  }) async {
    ref.invalidate(shallowProductsStateControllerProvider);
    _debounce?.cancel();
    ShallowProductsOverlay.hide();
    if (searchByCamera == true) {
      final code = await BarcodeScannerService.scanBarcode(context);
      if (code == null) return;
      controller.text = code;
    }

    if (formKey.currentState?.validate() == true) {
      onProductSelected(null);
    }
  }
}
