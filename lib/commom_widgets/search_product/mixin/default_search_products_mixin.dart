import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/infraestructure/infrastructure.dart';
import '../../../core/presentation/controllers/bs_version/bs_version.dart';
import '../../../core/presentation/controllers/products/products.dart';
import '../../../utils/utils.dart';
import '../search_product.dart';

mixin DefaultSearchProductsMixin on ConsumerState<DefaultSearchProducts> {
  final _overlayManager = ShallowProductsOverlay();
  Timer? _debounce;

  void hideOverlay() => _overlayManager.hide();

  void disposeLogic() {
    _debounce?.cancel();
    _overlayManager.hide();
  }

  void onTextChanged(
    String value,
    LayerLink layerLink,
    GlobalKey<FormState> formKey,
    String groupId,
  ) async {
    final bsVersion = await ref.read(bsVersionStateControllerProvider.future);
    if (bsVersion?.isBefore(DateTime(2026, 03, 11)) ?? false) {
      return;
    }

    if (value.isEmpty) {
      ref.invalidate(shallowProductsStateControllerProvider);
      _overlayManager.hide();
    }
    if (value.removeWhiteSpaces().length < 3 || int.tryParse(value) != null) {
      return;
    }

    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (!mounted) return;

      // The "Double-Check" Guard.
      // We check the LATEST value of the controller before triggering the API.
      // If the user erased the text while the timer was counting, we stop.
      final currentText = widget.searchValueController.text;
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
      if (mounted && widget.searchValueController.text.length >= 3) {
        _showOverlay(layerLink, formKey, groupId);
      } else {
        _overlayManager.hide();
      }
    });
  }

  void _showOverlay(
    LayerLink layerLink,
    GlobalKey<FormState> formKey,
    String groupId,
  ) {
    _overlayManager.show(
      context: context,
      layerLink: layerLink,
      groupId: groupId,
      // onTapOutside: () => _overlayManager.hide(),
      onSelected: (product) {
        // Logic to update the main controller and trigger the heavy search
        widget.searchValueController.text = product.PLU ?? product.Name ?? '';
        _overlayManager.hide();
        widget.searchProducts(product.codigoInternoProEmb);
      },
    );
  }

  void onSearch(GlobalKey<FormState> formKey, {bool? searchByCamera}) async {
    _overlayManager.hide();
    ref.invalidate(shallowProductsStateControllerProvider);
    if (searchByCamera == true) {
      final code = await BarcodeScannerService.scanBarcode(context);
      if (code == null) return;
      widget.searchValueController.text = code;
    }

    if (formKey.currentState?.validate() == true) {
      widget.searchProducts(null);
    }
  }

  void onTapDeleteIcon() {
    _overlayManager.hide();
    widget.searchValueController.clear();
    Future.delayed(const Duration(milliseconds: 100), () {
      widget.focusNode?.requestFocus();
    });
  }
}
