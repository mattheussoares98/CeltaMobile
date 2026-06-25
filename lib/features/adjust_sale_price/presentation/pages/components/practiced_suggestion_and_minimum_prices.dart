import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/adjust_sale_price/domain/entities/entities.dart';
import 'package:celta_inventario/features/adjust_sale_price/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

extension _ProductPriceExt on ProductEntity {
  double? getSuggestion(SaleType? saleType) {
    if (PriceCost == null) return null;
    return switch (saleType) {
      SaleType.retail => PriceCost!.RetailSuggestionPrice,
      SaleType.whole => PriceCost!.WholeSuggestionPrice,
      SaleType.ecommerce => PriceCost!.ECommerceSuggestionPrice,
      _ => null,
    };
  }

  double? getMinimumPrice(SaleType? saleType) {
    if (PriceCost == null) return null;
    return switch (saleType) {
      SaleType.retail => PriceCost!.RetailMinimumPrice,
      SaleType.whole => PriceCost!.WholeMinimumPrice,
      SaleType.ecommerce => PriceCost!.ECommerceMinimumPrice,
      _ => null,
    };
  }

  double? getPracticed(SaleType? saleType, PriceType? priceType) {
    final isOffer = priceType == PriceType.offer;
    return switch (saleType) {
      SaleType.retail => isOffer ? RetailOfferPrice : RetailSalePrice,
      SaleType.whole => isOffer ? WholeOfferPrice : WholeSalePrice,
      SaleType.ecommerce => isOffer ? ECommerceOfferPrice : ECommerceSalePrice,
      _ => null,
    };
  }
}

class PracticedSuggestionAndMinimumPrices extends ConsumerWidget {
  final ProductEntity product;
  const PracticedSuggestionAndMinimumPrices({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedSaleType = ref.watch(
      uIStateControllerProvider(
        product.PLU!,
      ).select((s) => s.value?.selectedSaleType),
    );
    final selectedPriceType = ref.watch(
      uIStateControllerProvider(
        product.PLU!,
      ).select((s) => s.value?.selectedPriceType),
    );

    final practicedPrice = product.getPracticed(
      selectedSaleType,
      selectedPriceType,
    );
    final suggestionPrice = product.getSuggestion(selectedSaleType);
    final minimumPrice = product.getMinimumPrice(selectedSaleType);

    return RepaintBoundary(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RepaintBoundary(
            child: _SuggestionItem(
              title: 'Praticado '.hardcoded,
              value: practicedPrice,
              emptyMessage:
                  "Sem preço ${selectedPriceType?.name.toLowerCase()} ${selectedSaleType?.name.toLowerCase()} praticado"
                      .hardcoded,
              anotherMessage:
                  minimumPrice != null &&
                      minimumPrice > 0 &&
                      practicedPrice != null &&
                      practicedPrice < minimumPrice
                  ? TextSpan(
                      text: " MENOR QUE O MÍNIMO".hardcoded,
                      style: context.theme.textTheme.titleSmall!.copyWith(
                        color: Colors.red,
                      ),
                    )
                  : null,
            ),
          ),
          _SuggestionItem(
            title: 'Sugerido '.hardcoded,
            value: suggestionPrice,
            emptyMessage:
                "Sem preço ${selectedPriceType?.name.toLowerCase()} ${selectedSaleType?.name.toLowerCase()} sugerido"
                    .hardcoded,
          ),
          if (minimumPrice != null && minimumPrice > 0)
            _SuggestionItem(
              title: 'Mínimo '.hardcoded,
              value: minimumPrice,
              emptyMessage: "",
            ),
        ],
      ),
    );
  }
}

class _SuggestionItem extends StatelessWidget {
  final String title;
  final double? value;
  final String emptyMessage;
  final TextSpan? anotherMessage;
  const _SuggestionItem({
    required this.title,
    required this.value,
    required this.emptyMessage,
    this.anotherMessage,
  });

  @override
  Widget build(BuildContext context) {
    if (value == null || value == 0) {
      return DefaultText.title(
        emptyMessage,
        color: Colors.red,
        textAlign: TextAlign.start,
      );
    }
    return RichText(
      text: TextSpan(
        text: title,
        style: context.theme.textTheme.titleSmall,
        children: [
          TextSpan(
            text: "R\$ ".hardcoded,
            style: context.theme.textTheme.bodySmall?.copyWith(fontSize: 10),
          ),
          TextSpan(
            text: value.toString().toBrazilianNumber(),
            style: context.theme.textTheme.bodyMedium,
          ),
          ?anotherMessage,
        ],
      ),
    );
  }
}
