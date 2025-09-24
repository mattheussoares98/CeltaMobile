import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/constants.dart';
import '../../core/domain/entities/entities.dart';
import '../../core/presentation/controllers/controllers.dart';
import '../../core/providers/resource/resource.dart';
import '../../features/adjust_sale_price/domain/entities/entities.dart';
import '../commom_widgets.dart';

class Prices extends ConsumerWidget {
  const Prices({super.key, required this.widget, required this.enterpriseCode});

  final int enterpriseCode;
  final ProductInfoModal widget;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final retailSuggestion =
        widget.product.PriceCost.RetailSuggestionPrice ?? 0;
    final wholeSuggestion = widget.product.PriceCost.WholeSuggestionPrice ?? 0;
    final ecommerceSuggestion =
        widget.product.PriceCost.ECommerceSuggestionPrice ?? 0;

    final canAdjustSalePrice = ref.watch(
      canAccessResourceStateControllerProvider(
        BsRoutine.adjustSalePrice,
        BsResource.adjustSalePrice,
        enterpriseCode,
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
          PracticedPrice(
            saleType: SaleType.retail,
            product: widget.product,
            enterpriseCode: enterpriseCode,
          ),
          PracticedPrice(
            saleType: SaleType.whole,
            product: widget.product,
            enterpriseCode: enterpriseCode,
          ),
          PracticedPrice(
            saleType: SaleType.ecommerce,
            product: widget.product,
            enterpriseCode: enterpriseCode,
          ),
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
        ],
      ),
    );
  }
}
