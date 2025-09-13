import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../commom_widgets/commom_widgets.dart';
import '../../../../constants/constants.dart';
import '../../../../features/adjust_sale_price/presentation/controllers/controllers.dart';

class AdjustSalePriceProductsPage extends ConsumerStatefulWidget {
  final int enterpriseCode;
  const AdjustSalePriceProductsPage({super.key, required this.enterpriseCode});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AdjustSalePriceProductsPageState();
}

class _AdjustSalePriceProductsPageState
    extends ConsumerState<AdjustSalePriceProductsPage> {
  final searchValueController = TextEditingController();

  @override
  void dispose() {
    super.dispose();

    searchValueController.dispose();
  }

  Future<void> searchProducts() async {
    await ref
        .read(productsStateControllerProvider(widget.enterpriseCode).notifier)
        .loadProducts(
          enterpriseCode: widget.enterpriseCode,
          searchValue: searchValueController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(productsStateControllerProvider(widget.enterpriseCode), (
      previous,
      next,
    ) {
      next.doOnSuccess(previous, () {
        searchValueController.clear();
      });
    });

    final productsState = ref.watch(
      productsStateControllerProvider(widget.enterpriseCode),
    );

    return ScrollingSliverPage(
      title: FittedBox(child: Text("Produtos (ajuste de preço)".hardcoded)),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(Sizes.p8),
            child: DefaultSearchProducts(
              searchValueController: searchValueController,
              isLoading: productsState.isLoading,
              searchProducts: searchProducts,
            ),
          ),
        ),
        AsyncValueSliverWidget(
          value: productsState,
          tryAgain: null,
          data: (products) {
            return ResponsiveSliverListFlow(
              itemCount: products.length,
              itemsPerRow:
                  (MediaQuery.of(context).size.width / Breakpoint.tablet)
                      .ceil(),
              padding: 0,
              itemBuilder: (_, index) {
                final e = products[index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(Sizes.p8),
                    child: Text(e.Name),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class ScrollingSliverPage extends StatelessWidget {
  const ScrollingSliverPage({
    super.key,
    required this.title,
    this.actions,
    this.itemsPerRow = 2,
    this.slivers,
    this.padding = 8,
  });

  final Widget title;
  final List<Widget>? actions;
  final int itemsPerRow;
  final List<Widget>? slivers;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            floating: true,
            snap: true,
            title: title,
            actions: actions,
          ),
          if (slivers != null) ...slivers!,
        ],
      ),
    );
  }
}

class ResponsiveSliverListFlow extends StatelessWidget {
  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final int itemsPerRow;
  final double padding;
  const ResponsiveSliverListFlow({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    required this.itemsPerRow,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      // Calculate how many rows are needed
      itemCount: (itemCount / itemsPerRow).ceil(),
      itemBuilder: (context, rowIndex) {
        // This builder is only called for the rows visible on screen.
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(itemsPerRow, (colIndex) {
            final itemIndex = (rowIndex * itemsPerRow) + colIndex;
            // If the item exists, build it. Otherwise, build an empty placeholder.
            if (itemIndex < itemCount) {
              return Expanded(
                child: Padding(
                  // Add padding between items in the same row
                  padding: EdgeInsets.symmetric(horizontal: padding / 2),
                  child: itemBuilder(context, itemIndex),
                ),
              );
            } else {
              return const Expanded(child: SizedBox());
            }
          }),
        );
      },
    );
  }
}
