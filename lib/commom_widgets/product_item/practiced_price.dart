import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/resource/resource.dart';
import 'package:celta_inventario/features/adjust_sale_price/domain/entities/entities.dart';
import 'package:celta_inventario/features/adjust_sale_price/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PracticedPrice extends ConsumerWidget {
  final SaleType saleType;
  final ProductEntity product;
  const PracticedPrice({
    super.key,
    required this.saleType,
    required this.product,
  });

  double get salePrice {
    switch (saleType) {
      case SaleType.retail:
        return (product.RetailPracticedPrice ?? 0);
      case SaleType.whole:
        return (product.WholePracticedPrice ?? 0);
      case SaleType.ecommerce:
        return (product.ECommercePracticedPrice ?? 0);
    }
  }

  double get offerPrice {
    switch (saleType) {
      case SaleType.retail:
        return (product.RetailOfferPrice ?? 0);
      case SaleType.whole:
        return (product.WholeOfferPrice ?? 0);
      case SaleType.ecommerce:
        return (product.ECommerceOfferPrice ?? 0);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: Sizes.p8),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(Sizes.p8, Sizes.p8, 0, Sizes.p8),
        child: Row(
          children: [
            Expanded(
              flex: 60,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitleAndSubTitle(
                    title: saleType.name,
                    subTitle: salePrice,
                    subTitleIsPrice: true,
                  ),
                  if (offerPrice > 0)
                    TitleAndSubTitle(
                      title: null,
                      subTitle: 'Em oferta'.hardcoded,
                      subTitleStyle: context.theme.textTheme.bodyMedium
                          ?.copyWith(
                            color: Colors.red,
                            fontStyle: FontStyle.italic,
                          ),
                    ),
                  if (saleType == SaleType.whole &&
                      (product.MinimumWholeQuantity ?? 0) > 0)
                    TitleAndSubTitle(
                      title: 'Qtd mín atacado'.hardcoded,
                      subTitle: product.MinimumWholeQuantity.toString()
                          .toBrazilianNumber(2, true),
                      subTitleStyle: context.theme.textTheme.bodyMedium
                          ?.copyWith(
                            color: context.theme.colorScheme.secondary,
                            fontStyle: FontStyle.italic,
                          ),
                    ),
                ],
              ),
            ),
            if (offerPrice > 0)
              _FinishOffer(product: product, saleType: saleType),
          ],
        ),
      ),
    );
  }
}

class _FinishOffer extends ConsumerWidget {
  const _FinishOffer({required this.product, required this.saleType});

  final ProductEntity product;
  final SaleType saleType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaSize = MediaQuery.sizeOf(context);

    return AsyncValueWidget(
      value: ref.watch(
        canAccessResourceStateControllerProvider(
          BsRoutine.adjustSalePrice,
          BsResource.adjustSalePrice,
        ),
      ),
      tryAgain: () => ref.invalidate(
        canAccessResourceStateControllerProvider(
          BsRoutine.adjustSalePrice,
          BsResource.adjustSalePrice,
        ),
      ),
      data: (canAccess) {
        if (!canAccess) {
          return const SizedBox.shrink();
        }
        return Expanded(
          flex: 40,
          child: Consumer(
            builder: (_, ref, _) {
              return PrimaryTextButton(
                text: 'Encerrar'.hardcoded,
                color: Colors.red,
                isLoading: ref.watch(
                  finishOfferControllerProvider(
                    product.ProductPackingCode!,
                    product.EnterpriseCode!,
                  ).select((s) => s.isLoading),
                ),
                icon: mediaSize.width < 300
                    ? null
                    : const PlatformIcon(
                        cupertinoIcon: CupertinoIcons.clear,
                        materialIcon: Icons.close,
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
                          .read(
                            finishOfferControllerProvider(
                              product.ProductPackingCode!,
                              product.EnterpriseCode!,
                            ).notifier,
                          )
                          .finish(
                            product: product,
                            saleType: saleType,
                            now: DateTime.now(),
                          );
                    },
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
