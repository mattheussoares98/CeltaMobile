import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/material.dart';

import '../../../../../core/domain/entities/entities.dart';
import '../../../domain/entities/entities.dart';

class PracticedSuggestionAndMinimumPrices extends StatelessWidget {
  final ProductEntity product;
  final SaleType? selectedSaleType;
  final PriceType selectedPriceType;
  const PracticedSuggestionAndMinimumPrices({
    super.key,
    required this.product,
    required this.selectedSaleType,
    required this.selectedPriceType,
  });

  double? get suggestion {
    switch (selectedSaleType) {
      case SaleType.retail:
        return product.PriceCost.RetailSuggestionPrice;
      case SaleType.whole:
        return product.PriceCost.WholeSuggestionPrice;
      case SaleType.ecommerce:
        return product.PriceCost.ECommerceSuggestionPrice;
      default:
        return null;
    }
  }

  double? get minimumPrice {
    switch (selectedSaleType) {
      case SaleType.retail:
        return product.PriceCost.RetailMinimumPrice;
      case SaleType.whole:
        return product.PriceCost.WholeMinimumPrice;
      case SaleType.ecommerce:
        return product.PriceCost.ECommerceMinimumPrice;
      default:
        return null;
    }
  }

  double? get practiced {
    switch (selectedSaleType) {
      case SaleType.retail:
        return selectedPriceType == PriceType.offer
            ? product.RetailOfferPrice
            : product.RetailSalePrice;
      case SaleType.whole:
        return selectedPriceType == PriceType.offer
            ? product.WholeOfferPrice
            : product.WholeSalePrice;
      case SaleType.ecommerce:
        return selectedPriceType == PriceType.offer
            ? product.ECommerceOfferPrice
            : product.ECommerceSalePrice;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SuggestionItem(
          title: 'Praticado '.hardcoded,
          value: practiced,
          emptyMessage:
              "Sem preço ${selectedPriceType.name.toLowerCase()} ${selectedSaleType?.name.toLowerCase()} praticado"
                  .hardcoded,
          anotherMessage:
              minimumPrice != null &&
                  minimumPrice! > 0 &&
                  practiced != null &&
                  practiced! < minimumPrice!
              ? TextSpan(
                  text: " MENOR QUE O MÍNIMO".hardcoded,
                  style: theme.textTheme.titleSmall!.copyWith(
                    color: Colors.red,
                  ),
                )
              : null,
        ),
        _SuggestionItem(
          title: 'Sugerido '.hardcoded,
          value: suggestion,
          emptyMessage:
              "Sem preço ${selectedPriceType.name.toLowerCase()} ${selectedSaleType?.name.toLowerCase()} sugerido"
                  .hardcoded,
        ),
        if (minimumPrice != null && minimumPrice! > 0)
          _SuggestionItem(
            title: 'Mínimo '.hardcoded,
            value: minimumPrice,
            emptyMessage: "",
          ),
      ],
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
    final theme = Theme.of(context);

    if (value == null || value == 0) {
      return Text(
        emptyMessage,
        style: theme.textTheme.titleSmall?.copyWith(color: Colors.red),
        textAlign: TextAlign.start,
      );
    }
    return RichText(
      text: TextSpan(
        text: title,
        style: theme.textTheme.titleSmall,
        children: [
          TextSpan(
            text: "R\$ ".hardcoded,
            style: theme.textTheme.bodySmall?.copyWith(fontSize: 10),
          ),
          TextSpan(
            text: value.toString().toBrazilianNumber(),
            style: theme.textTheme.bodyMedium,
          ),
          ?anotherMessage,
        ],
      ),
    );
  }
}
