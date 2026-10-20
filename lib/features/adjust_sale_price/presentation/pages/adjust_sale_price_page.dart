import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/adjust_sale_price/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/adjust_sale_price/presentation/pages/components/components.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
    final provider = selectedProductStateControllerProvider(
      widget.enterpriseCode,
      widget.plu,
    );
    final selectedProduct =
        widget.product ?? ref.watch(provider.select((s) => s.value));

    ref.listen(confirmAdjustControllerProvider, (previous, next) {
      next.showAlertDialogOnError(context);
      next.doOnSuccess(previous, () {
        showToastMessage(context.l10n.priceChangedSuccessfully);
        context.pop();
      });
    });

    ref.observeLoading([confirmAdjustControllerProvider]);

    return BaseScaffold(
      isScrollable: false,
      resizeToAvoidBottomInset: true,
      appBar: BaseAppBar(
        selectedEnterpriseCode: widget.enterpriseCode,
        title: selectedProduct == null
            ? ""
            : "(${selectedProduct.PLU}) ${selectedProduct.Name}",
      ),
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          if (selectedProduct != null)
            PriceSchedules(
              enterpriseCode: widget.enterpriseCode,
              product: selectedProduct,
            ),
          OptimazedAsyncValueWidget(
            isSliver: true,
            provider: provider,
            tryAgain: null,
            child: SliverToBoxAdapter(
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
                    if (selectedProduct != null) ...[
                      RepaintBoundary(
                        child: InfoButton(
                          ProductItemWidget(
                            product: selectedProduct,
                            routine: BsRoutine.adjustSalePrice,
                          ),
                        ),
                      ),
                      PracticedSuggestionAndMinimumPrices(
                        product: selectedProduct,
                      ),
                      _DefaultDivider(),
                    ],
                    PriceFieldAndConfirmButton(
                      enterpriseCode: widget.enterpriseCode,
                      plu: widget.plu,
                    ),
                    gapH48,
                  ],
                ),
              ),
            ),
          ),
        ],
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
