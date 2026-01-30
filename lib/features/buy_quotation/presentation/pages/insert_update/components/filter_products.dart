import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../localization/string_hardcoded.dart';
import '../../../controllers/controller.dart';

class FilterProducts extends ConsumerStatefulWidget {
  final int enterpriseCode;
  final int code;
  final TextEditingController filterProductsController;
  final FocusNode filterProductsFocusNode;
  const FilterProducts({
    super.key,
    required this.enterpriseCode,
    required this.code,
    required this.filterProductsController,
    required this.filterProductsFocusNode,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FilterProductsState();
}

class _FilterProductsState extends ConsumerState<FilterProducts> {
  bool expandedFilter = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: AnimatedBuilder(
                  animation: widget.filterProductsController,
                  builder: (_, _) {
                    final filteredProducts = ref
                        .read(
                          completeBuyQuotationsStateControllerProvider(
                            widget.enterpriseCode,
                            widget.code.toString(),
                          ).notifier,
                        )
                        .filterProducts(widget.filterProductsController.text);

                    return Text(
                      'Produtos (${filteredProducts.length})'.hardcoded,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: theme.primaryColor,
                      ),
                    );
                  },
                ),
              ),
              const Spacer(),
              Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: PrimaryTextButton(
                    text: 'Filtrar produtos'.hardcoded,
                    onPressed: () {
                      setState(() {
                        expandedFilter = !expandedFilter;
                      });
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        widget.filterProductsFocusNode.requestFocus();
                      });
                    },
                    icon: Icon(
                      expandedFilter
                          ? Icons.filter_alt
                          : Icons.filter_alt_outlined,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (expandedFilter)
            DefaultTextFormField(
              controller: widget.filterProductsController,
              focusNode: widget.filterProductsFocusNode,
              hintText: 'PLU | Nome'.hardcoded,
              labelText: 'Filtrar produtos'.hardcoded,
              suffixIcon: IconButton(
                onPressed: widget.filterProductsController.clear,
                icon: Icon(
                  isIOS ? CupertinoIcons.delete : Icons.delete,
                  color: Colors.red,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
