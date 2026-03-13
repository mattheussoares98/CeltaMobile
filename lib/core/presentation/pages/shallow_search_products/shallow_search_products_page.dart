import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../commom_widgets/commom_widgets.dart';
import '../../../../constants/constants.dart';
import '../../../../core/presentation/controllers/products/products.dart';
import '../../../../localization/string_hardcoded.dart';
import '../../../../utils/utils.dart';
import 'components/components.dart';
import 'models/models.dart';

class ShallowSearchProductsPage extends ConsumerStatefulWidget {
  final TextEditingController? controller;
  const ShallowSearchProductsPage({super.key, required this.controller});

  @override
  ConsumerState<ShallowSearchProductsPage> createState() =>
      _ShallowSearchProductsPageState();
}

class _ShallowSearchProductsPageState
    extends ConsumerState<ShallowSearchProductsPage> {
  Timer? _debounce;

  @override
  void initState() {
    super.initState();

    // PERFORMANCE: If we arrived with text, trigger search immediately.
    if (widget.controller != null && widget.controller!.text.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(shallowProductsStateControllerProvider.notifier)
            .load(widget.controller!.text);
      });
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    if (value.removeWhiteSpaces().isEmpty) {
      ref.invalidate(shallowProductsStateControllerProvider);
      _handlePop(
        TappedProductModel(
          codigoInternoProEmb: null,
          textField: value,
          closedShallowPageType: ClosePageAction.cancel,
        ),
      );
      return;
    }

    if (value.removeWhiteSpaces().length < 3) {
      ref.invalidate(shallowProductsStateControllerProvider);
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(shallowProductsStateControllerProvider.notifier).load(value);
    });
  }

  void _handlePop(TappedProductModel result) {
    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        _handlePop(
          TappedProductModel(
            codigoInternoProEmb: null,
            textField: widget.controller?.text,
            closedShallowPageType: ClosePageAction.cancel,
          ),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: DefaultTextFormField(
            controller: widget.controller,
            textInputAction: TextInputAction.search,
            labelText: 'Nome'.hardcoded,
            autofocus: true,
            onChanged: _onChanged,
            hintText: 'Pesquisar produtos...'.hardcoded,
            onFieldSubmitted: (value) => _handlePop(
              TappedProductModel(
                codigoInternoProEmb: null,
                textField: value,
                closedShallowPageType: ClosePageAction.submit,
              ),
            ),
          ),
          actions: [
            if (widget.controller != null)
              CloseIcon(controller: widget.controller!),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Sizes.p4),
          child: RepaintBoundary(
            child: ShallowResultsItems(
              //TODO delete this page
              onSelected: (product) {
                _handlePop(
                  TappedProductModel(
                    codigoInternoProEmb: product.codigoInternoProEmb,
                    textField: product.PLU,
                    closedShallowPageType: ClosePageAction.tapProduct,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
