import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../commom_widgets/commom_widgets.dart';
import '../../../../constants/constants.dart';
import '../../../../core/presentation/controllers/products/products.dart';
import '../../../../localization/string_hardcoded.dart';
import 'components/components.dart';
import 'models/models.dart';

class ShallowSearchProductsPage extends ConsumerStatefulWidget {
  final String? initialText;
  const ShallowSearchProductsPage({super.key, required this.initialText});

  @override
  ConsumerState<ShallowSearchProductsPage> createState() =>
      _ShallowSearchProductsPageState();
}

class _ShallowSearchProductsPageState
    extends ConsumerState<ShallowSearchProductsPage> {
  late final TextEditingController _controller;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);

    // PERFORMANCE: If we arrived with text, trigger search immediately.
    if (widget.initialText != null && widget.initialText!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(shallowProductsStateControllerProvider.notifier)
            .load(widget.initialText!);
      });
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    if (value.trim().length < 3) {
      ref.invalidate(shallowProductsStateControllerProvider);
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(shallowProductsStateControllerProvider.notifier).load(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Hero(
          tag: 'search_bar_hero',
          child: Material(
            type: MaterialType.transparency,
            child: DefaultTextFormField(
              controller: _controller,
              autofocus: true,
              onChanged: _onChanged,
              hintText: 'Pesquisar produtos...'.hardcoded,
              onFieldSubmitted: (value) => context.pop(
                TappedProductModel(
                  codigoInternoProEmb: null,
                  textField: value,
                  closedShallowPageType: ClosePageAction.submit,
                ),
              ),
            ),
          ),
        ),
        actions: [CloseIcon(controller: _controller)],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.p4),
        child: RepaintBoundary(
          child: ShallowResultsItems(
            onSelected: (product) {
              context.pop(
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
    );
  }
}
