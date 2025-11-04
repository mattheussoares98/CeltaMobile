import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/domain/entities/entities.dart';
import '../../features/adjust_sale_price/domain/entities/entities.dart';
import '../../features/adjust_sale_price/presentation/controllers/controllers.dart';
import '../commom_widgets.dart';

class PracticedPrice extends ConsumerWidget {
  final SaleType saleType;
  final ProductEntity product;
  final int enterpriseCode;
  const PracticedPrice({
    super.key,
    required this.saleType,
    required this.product,
    required this.enterpriseCode,
  });

  double get salePrice {
    switch (saleType) {
      case SaleType.retail:
        return product.RetailPracticedPrice;
      case SaleType.whole:
        return product.WholePracticedPrice;
      case SaleType.ecommerce:
        return product.ECommercePracticedPrice;
    }
  }

  double get offerPrice {
    switch (saleType) {
      case SaleType.retail:
        return product.RetailOfferPrice;
      case SaleType.whole:
        return product.WholeOfferPrice;
      case SaleType.ecommerce:
        return product.ECommerceOfferPrice;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    final finishOfferAsync = ref.watch(finishOfferControllerProvider);

    return Row(
      children: [
        Expanded(
          flex: 60,
          child: RichText(
            text: TextSpan(
              style: theme.textTheme.bodyMedium,
              children: [
                TextSpan(text: saleType.name),
                if (saleType == SaleType.whole &&
                    product.MinimumWholeQuantity > 0)
                  TextSpan(
                    text:
                        ' (min ${product.MinimumWholeQuantity.toString().toBrazilianNumber(2, true)})',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.secondary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                if (offerPrice > 0)
                  TextSpan(
                    text: ' (oferta) '.hardcoded,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.red,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (offerPrice > 0)
          Expanded(
            flex: 40,
            child: PrimaryTextButton(
              text: 'Encerrar'.hardcoded,
              color: Colors.red,
              isLoading: finishOfferAsync.isLoading,
              icon: mediaQuery.size.width < 300
                  ? null
                  : Icon(
                      theme.platform != TargetPlatform.iOS
                          ? CupertinoIcons.clear
                          : Icons.close,
                      color: Colors.red,
                    ),
              onPressed: () {
                showAlertDialog(
                  context: context,
                  title: 'Encerrar oferta ${saleType.name.toUpperCase()}'
                      .hardcoded,
                  cancelActionText: 'Cancelar'.hardcoded,
                  defaultActionText: 'Sim'.hardcoded,
                  content:
                      'Tem certeza que deseja encerrar a oferta ${saleType.name.toUpperCase()}?'
                          .hardcoded,
                  onOkPressed: () {
                    ref
                        .read(finishOfferControllerProvider.notifier)
                        .finish(
                          product: product,
                          saleType: saleType,
                          now: DateTime.now(),
                        );
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}
