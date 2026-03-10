import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/infraestructure/infrastructure.dart';
import '../../../core/presentation/controllers/products/products.dart';
import '../search_products.dart';

mixin DefaultSearchProductsMixin on ConsumerState<DefaultSearchProducts> {
  final _overlayManager = ShallowProductsOverlay();
  Timer? _debounce;

  void disposeLogic() {
    _debounce?.cancel();
    _overlayManager.hide();
  }

  void onTextChanged(
    String value,
    LayerLink layerLink,
    GlobalKey<FormState> formKey,
  ) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    if (value.length < 3) {
      _overlayManager.hide();
      return;
    }

    //500ms debounce prevents UI freezing and API spam.
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        ref.read(shallowProductsStateControllerProvider.notifier).load(value);
        showOverlay(layerLink, formKey);
      }
    });
  }

  void showOverlay(LayerLink layerLink, GlobalKey<FormState> formKey) {
    _overlayManager.show(
      context: context,
      layerLink: layerLink,
      onTapOutside: () => _overlayManager.hide(),
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
    widget.searchValueController.clear();
    Future.delayed(const Duration(milliseconds: 100), () {
      widget.focusNode?.requestFocus();
    });
  }
}
