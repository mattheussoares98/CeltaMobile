import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../commom_widgets/commom_widgets.dart';
import '../../../../constants/constants.dart';
import '../../../../core/domain/entities/entities.dart';
import '../controllers/controllers.dart';
import 'components/components.dart';

class AdjustSalePricePage extends ConsumerWidget {
  final String plu;
  final int enterpriseCode;
  final ProductEntity? product;
  const AdjustSalePricePage({
    super.key,
    required this.plu,
    required this.enterpriseCode,
    required this.product,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedProductAsync = ref.watch(
      selectedProductStateControllerProvider(enterpriseCode, plu),
    );

    ref.listen(confirmAdjustControllerProvider, (previous, next) {
      next.showAlertDialogOnError(context);
      next.doOnSuccess(previous, () {
        showSnackBarMessage(context, 'Preço alterado com sucesso'.hardcoded);
        context.pop();
      });
    });

    final selectedProduct = product ?? selectedProductAsync.value;

    return Stack(
      children: [
        Scaffold(
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
                      enterpriseCode: enterpriseCode,
                      product: selectedProduct,
                    ),
                  AsyncValueSliverWidget(
                    value: selectedProductAsync,
                    tryAgain: () {
                      ref.invalidate(
                        selectedProductStateControllerProvider(
                          enterpriseCode,
                          plu,
                        ),
                      );
                    },
                    data: (product) {
                      return SliverToBoxAdapter(
                        child: ResponsiveScrollableWidget(
                          child: Column(
                            children: [
                              _DefaultDivider(),
                              SalesTypeWidget(plu: plu),
                              _DefaultDivider(),
                              PricesTypesWidget(plu: plu),
                              _DefaultDivider(),
                              ReplicationTypesWidget(plu: plu),
                              _DefaultDivider(),
                              StartAndEndDates(plu: plu),
                              _DefaultDivider(),
                              InfoButton(
                                ProductItemWidget(
                                  product: product!,
                                  routine: BsRoutine.adjustSalePrice,
                                ),
                              ),
                              PracticedSuggestionAndMinimumPrices(
                                product: product,
                              ),
                              _DefaultDivider(),
                              PriceFieldAndConfirmButton(
                                enterpriseCode: enterpriseCode,
                                plu: plu,
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
        ),
        LoadingPage(providers: [confirmAdjustControllerProvider]),
      ],
    );
  }
}

class _DefaultDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Divider(height: Sizes.p8);
  }
}
