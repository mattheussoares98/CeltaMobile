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
    final totalProductsLength = ref.watch(
      completeBuyQuotationsStateControllerProvider(
        widget.enterpriseCode,
        widget.code.toString(),
      ).select((s) => s.value?.Products?.length ?? 0),
    );

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
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

                    final hasFiltered =
                        filteredProducts.length != totalProductsLength;

                    return Text(
                      'Produtos (${filteredProducts.length}${hasFiltered ? ' de $totalProductsLength' : ''})'
                          .hardcoded,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: theme.primaryColor,
                      ),
                    );
                  },
                ),
              ),
              // const Spacer(),
              Flexible(
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
                icon: const PlatformIcon(
                  cupertinoIcon: CupertinoIcons.delete,
                  materialIcon: Icons.delete,
                  color: Colors.red,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
