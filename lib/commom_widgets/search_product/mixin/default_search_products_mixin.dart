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
    } else {
      _showOverlay(
        layerLink: layerLink,
        formKey: formKey,
        controller: controller,
        onProductSelected: onProductSelected,
      );
    }

    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (!mounted) return;

      await ref
          .read(shallowProductsStateControllerProvider.notifier)
          .load(controller.text);

      if (controller.text.isEmpty) {
        // ref.invalidate(shallowProductsStateControllerProvider);
        ShallowProductsOverlay.hide();
        return;
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
