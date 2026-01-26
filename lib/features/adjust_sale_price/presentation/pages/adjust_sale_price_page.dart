import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../commom_widgets/commom_widgets.dart';
import '../../../../constants/constants.dart';
import '../../../../core/domain/entities/entities.dart';
import '../controllers/controllers.dart';
import 'components/components.dart';

class AdjustSalePricePage extends ConsumerStatefulWidget {
  final ProductEntity? product;
  final int enterpriseCode;
  final String plu;
  const AdjustSalePricePage({
    super.key,
    this.product,
    required this.enterpriseCode,
    required this.plu,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AdjustSalePricePageState();
}

class _AdjustSalePricePageState extends ConsumerState<AdjustSalePricePage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        ref
            .read(
              selectedProductStateControllerProvider(
                widget.enterpriseCode,
                widget.plu,
              ).notifier,
            )
            .updateSelectedProduct(widget.product);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedProductAsync = ref.watch(
      selectedProductStateControllerProvider(widget.enterpriseCode, widget.plu),
    );

    ref.listen(confirmAdjustControllerProvider, (previous, next) {
      next.showAlertDialogOnError(context);
      next.doOnSuccess(previous, () {
        showSnackBarMessage(context, 'Preço alterado com sucesso'.hardcoded);
        context.pop();
      });
    });

    final selectedProduct = widget.product ?? selectedProductAsync.value;

    ref.observeLoading([confirmAdjustControllerProvider]);

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 40,
        title: FittedBox(
          child: Text(
            selectedProduct == null
                ? ""
                : "(${selectedProduct.PLU}) ${selectedProduct.Name}",
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Sizes.p4),
          child: CustomScrollView(
            physics: const ClampingScrollPhysics(),
            slivers: [
              if (selectedProduct != null)
                PriceSchedules(
                  enterpriseCode: widget.enterpriseCode,
                  product: selectedProduct,
                ),
              AsyncValueSliverWidget(
                value: selectedProductAsync,
                tryAgain: () {
                  ref.invalidate(
                    selectedProductStateControllerProvider(
                      widget.enterpriseCode,
                      widget.plu,
                    ),
                  );
                },
                data: (product) {
                  return SliverToBoxAdapter(
                    child: ResponsiveScrollableWidget(
                      child: Column(
                        children: [
                          _DefaultDivider(),
                          SalesTypeWidget(plu: widget.plu),
                          _DefaultDivider(),
                          PricesTypesWidget(plu: widget.plu),
                          _DefaultDivider(),
                          ReplicationTypesWidget(plu: widget.plu),
                          _DefaultDivider(),
                          StartAndEndDates(plu: widget.plu),
                          _DefaultDivider(),
                          InfoButton(
                            ProductItemWidget(
                              product: selectedProduct!,
                              routine: BsRoutine.adjustSalePrice,
                            ),
                          ),
                          PracticedSuggestionAndMinimumPrices(
                            product: selectedProduct,
                          ),
                          _DefaultDivider(),
                          PriceFieldAndConfirmButton(
                            enterpriseCode: widget.enterpriseCode,
                            plu: widget.plu,
                          ),
                          gapH32,
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DefaultDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Divider(height: Sizes.p8);
  }
}
