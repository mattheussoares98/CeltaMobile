import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/constants.dart';
import '../../../core/domain/entities/entities.dart';
import '../../../core/presentation/controllers/resource/resource.dart';
import '../../../core/providers/resource/resource.dart';
import '../../../features/adjust_sale_price/domain/entities/entities.dart';
import '../../commom_widgets.dart';

class Prices extends ConsumerWidget {
  const Prices({super.key, required this.widget});
  final ProductInfoModal widget;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cost = widget.product.PriceCost;
    final retailSuggestion = cost?.RetailSuggestionPrice ?? 0;
    final wholeSuggestion = cost?.WholeSuggestionPrice ?? 0;
    final ecommerceSuggestion = cost?.ECommerceSuggestionPrice ?? 0;

    final retailMinimum = cost?.RetailMinimumPrice ?? 0;
    final wholeMinimum = cost?.WholeMinimumPrice ?? 0;
    final ecommerceMinimum = cost?.ECommerceMinimumPrice ?? 0;

    final canAdjustSalePrice = ref.watch(
      canAccessResourceStateControllerProvider(
        BsRoutine.adjustSalePrice,
        BsResource.adjustSalePrice,
      ),
    );

    return ResponsiveScrollableWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DefaultTitle(title: 'Preços praticados'.hardcoded),
          if (canAdjustSalePrice.hasError)
            Padding(
              padding: const EdgeInsets.all(Sizes.p8),
              child: PrimaryButton(
                text: 'Atualizar permissão para encerrar oferta'.hardcoded,
                isLoading: canAdjustSalePrice.isLoading,
                onPressed: () {
                  ref.invalidate(soapResourceDatasourceProvider);
                },
              ),
            ),
          gapH8,
          PracticedPrice(saleType: SaleType.retail, product: widget.product),
          PracticedPrice(saleType: SaleType.whole, product: widget.product),
          PracticedPrice(saleType: SaleType.ecommerce, product: widget.product),
          if (retailSuggestion > 0 ||
              wholeSuggestion > 0 ||
              ecommerceSuggestion > 0) ...[
            gapH32,
            DefaultTitle(title: 'Preços sugeridos'.hardcoded),
            gapH8,
            if (retailSuggestion > 0)
              TitleAndSubTitle(
                title: 'Venda '.hardcoded,
                subTitle: retailSuggestion,
                subTitleIsPrice: true,
              ),
            if (wholeSuggestion > 0)
              TitleAndSubTitle(
                title: 'Atacado '.hardcoded,
                subTitle: wholeSuggestion,
                subTitleIsPrice: true,
              ),
            if (ecommerceSuggestion > 0)
              TitleAndSubTitle(
                title: 'Ecommerce '.hardcoded,
                subTitle: ecommerceSuggestion,
                subTitleIsPrice: true,
              ),
          ],
          if (wholeMinimum > 0 ||
              retailMinimum > 0 ||
              ecommerceMinimum > 0) ...[
            gapH32,
            DefaultTitle(title: 'Preços mínimos'.hardcoded),
            gapH8,
            if (retailMinimum > 0)
              TitleAndSubTitle(
                title: 'Venda '.hardcoded,
                subTitle: retailMinimum,
                subTitleIsPrice: true,
              ),
            if (wholeMinimum > 0)
              TitleAndSubTitle(
                title: 'Atacado '.hardcoded,
                subTitle: wholeMinimum,
                subTitleIsPrice: true,
              ),
            if (ecommerceMinimum > 0)
              TitleAndSubTitle(
                title: 'Ecommerce '.hardcoded,
                subTitle: ecommerceMinimum,
                subTitleIsPrice: true,
              ),
          ],
        ],
      ),
    );
  }
}
