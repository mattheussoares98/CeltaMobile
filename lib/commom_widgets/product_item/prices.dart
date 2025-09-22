import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/constants.dart';
import '../../core/domain/entities/entities.dart';
import '../../core/presentation/controllers/controllers.dart';
import '../../core/providers/providers.dart';
import '../../features/adjust_sale_price/domain/entities/entities.dart';
import '../../features/adjust_sale_price/presentation/controllers/controllers.dart';
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Title(title: 'Preços praticados'.hardcoded),
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
        _PracticedPrice(
          saleType: SaleType.retail,
          product: widget.product,
          enterpriseCode: enterpriseCode,
        ),
        _PracticedPrice(
          saleType: SaleType.whole,
          product: widget.product,
          enterpriseCode: enterpriseCode,
        ),
        _PracticedPrice(
          saleType: SaleType.ecommerce,
          product: widget.product,
          enterpriseCode: enterpriseCode,
        ),
        if (retailSuggestion > 0 ||
            wholeSuggestion > 0 ||
            ecommerceSuggestion > 0) ...[
          gapH32,
          _Title(title: 'Preços sugeridos'.hardcoded),
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
    );
  }
}

class _Title extends StatelessWidget {
  final String title;
  const _Title({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            title.hardcoded,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

class _PracticedPrice extends ConsumerWidget {
  final SaleType saleType;
  final ProductEntity product;
  final int enterpriseCode;
  const _PracticedPrice({
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
          child: TitleAndSubTitle(
            title: '${saleType.name} ${(offerPrice) > 0 ? '(oferta) ' : ''}'
                .hardcoded
                .hardcoded,
            subTitle: salePrice,
            subTitleIsPrice: true,
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
