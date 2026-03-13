import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/infraestructure/infrastructure.dart';
import '../../../core/presentation/controllers/bs_version/bs_version.dart';
import '../../../core/presentation/controllers/products/products.dart';
import '../../../utils/utils.dart';
import '../search_product.dart';

mixin DefaultSearchProductsMixin<T extends ConsumerStatefulWidget>
    on ConsumerState<T> {
  final _overlayManager = ShallowProductsOverlay();
  Timer? _debounce;

  void hideOverlay() => _overlayManager.hide();

  void disposeLogic() {
    _debounce?.cancel();
    _overlayManager.hide();
  }

  void onTextChanged({
    required LayerLink layerLink,
    required GlobalKey<FormState> formKey,
    required TextEditingController controller,
    required void Function(int?) onProductSelected,
  }) async {
    final bsVersion = await ref.read(bsVersionStateControllerProvider.future);
    if (bsVersion?.isBefore(DateTime(2026, 03, 11)) ?? false) {
      return;
    }

    if (controller.text.isEmpty) {
      ref.invalidate(shallowProductsStateControllerProvider);
      _overlayManager.hide();
    }
    if (controller.text.removeWhiteSpaces().length < 3 ||
        int.tryParse(controller.text) != null) {
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
        _overlayManager.hide();
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
        _overlayManager.hide();
      }
    });
  }

  void _showOverlay({
    required LayerLink layerLink,
    required GlobalKey<FormState> formKey,
    required TextEditingController controller,
    required void Function(int?) onProductSelected,
  }) {
    _overlayManager.show(
      context: context,
      layerLink: layerLink,
      groupId: 'groupId',
      // onTapOutside: () => _overlayManager.hide(),
      onSelected: (product) {
        // Logic to update the main controller and trigger the heavy search
        controller.text = product.PLU ?? product.Name ?? '';
        _overlayManager.hide();
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
    _overlayManager.hide();
    ref.invalidate(shallowProductsStateControllerProvider);
    if (searchByCamera == true) {
      final code = await BarcodeScannerService.scanBarcode(context);
      if (code == null) return;
      controller.text = code;
    }

    if (formKey.currentState?.validate() == true) {
      onProductSelected(null);
    }
  }

  void onTapDeleteIcon({
    required TextEditingController controller,
    required FocusNode? focusNode,
  }) {
    _overlayManager.hide();
    controller.clear();
    Future.delayed(const Duration(milliseconds: 100), () {
      focusNode?.requestFocus();
    });
  }
}
