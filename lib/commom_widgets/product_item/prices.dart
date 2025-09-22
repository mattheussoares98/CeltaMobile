import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/constants.dart';
import '../../core/domain/entities/entities.dart';
import '../../core/presentation/controllers/controllers.dart';
import '../../core/providers/providers.dart';
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
          offerPrice: widget.product.RetailOfferPrice,
          typeOfPrice: 'Venda'.hardcoded,
          practicedPrice: widget.product.RetailPracticedPrice,
          onFinishOffer: canAdjustSalePrice.value != true
              ? null
              : () {
                  //TODO finish the offer
                },
        ),
        _PracticedPrice(
          offerPrice: widget.product.WholeOfferPrice,
          typeOfPrice: 'Atacado'.hardcoded,
          practicedPrice: widget.product.WholePracticedPrice,
          onFinishOffer: canAdjustSalePrice.value != true
              ? null
              : () {
                  //TODO finish the offer
                },
        ),
        _PracticedPrice(
          offerPrice: widget.product.ECommerceOfferPrice,
          typeOfPrice: 'E-commerce'.hardcoded,
          practicedPrice: widget.product.ECommercePracticedPrice,
          onFinishOffer: canAdjustSalePrice.value != true
              ? null
              : () {
                  //TODO finish the offer
                },
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

class _PracticedPrice extends StatelessWidget {
  final double? offerPrice;
  final String typeOfPrice;
  final double practicedPrice;
  final VoidCallback? onFinishOffer;
  const _PracticedPrice({
    required this.offerPrice,
    required this.typeOfPrice,
    required this.practicedPrice,
    required this.onFinishOffer,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    return Row(
      children: [
        Expanded(
          flex: 60,
          child: TitleAndSubTitle(
            title: '$typeOfPrice ${(offerPrice ?? 0) > 0 ? '(oferta) ' : ''}'
                .hardcoded
                .hardcoded,
            subTitle: practicedPrice,
            subTitleIsPrice: true,
          ),
        ),
        if ((offerPrice ?? 0) > 0 && onFinishOffer != null)
          Expanded(
            flex: 40,
            child: PrimaryTextButton(
              onPressed: () {
                showAlertDialog(
                  context: context,
                  title: 'Encerrar oferta $typeOfPrice'.hardcoded,
                  cancelActionText: 'Cancelar'.hardcoded,
                  content:
                      'Tem certeza que deseja encerrar a oferta $typeOfPrice?'
                          .hardcoded,
                  onOkPressed: onFinishOffer,
                );
              },
              text: 'Encerrar'.hardcoded,
              color: Colors.red,
              icon: mediaQuery.size.width < 300
                  ? null
                  : Icon(
                      theme.platform != TargetPlatform.iOS
                          ? CupertinoIcons.clear
                          : Icons.close,
                      color: Colors.red,
                    ),
            ),
          ),
      ],
    );
  }
}
