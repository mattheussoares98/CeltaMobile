import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/resource/resource.dart';
import 'package:celta_inventario/core/providers/resource/resource.dart';
import 'package:celta_inventario/features/adjust_sale_price/domain/entities/entities.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

    return ResponsiveScrollableWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(child: BaseText.headline('Preços praticados'.hardcoded)),
              gapW12,
              IconButton(
                onPressed: () {
                  ref
                      .read(tryAccessModuleControllerProvider.notifier)
                      .tryAccess(
                        context: context,
                        module: Modules.adjustPrice,
                        route: Routes.adjustSalePrice,
                        enterpriseCode: widget.product.EnterpriseCode,
                        extra: widget.product,
                        pathParameters: {
                          'enterpriseCode': widget.product.EnterpriseCode
                              .toString(),
                          'plu': widget.product.PLU!,
                        },
                      );
                },
                icon: const PlatformIcon(
                  cupertinoIcon: CupertinoIcons.pencil,
                  materialIcon: Icons.edit,
                ),
              ),
            ],
          ),
          Consumer(
            builder: (context, ref, child) {
              final hasError = ref.watch(
                canAccessResourceStateControllerProvider(
                  BsRoutine.adjustSalePrice,
                  BsResource.adjustSalePrice,
                ).select((s) => s.hasError),
              );

              final isLoading = ref.watch(
                canAccessResourceStateControllerProvider(
                  BsRoutine.adjustSalePrice,
                  BsResource.adjustSalePrice,
                ).select((s) => s.isLoading),
              );

              if (hasError) {
                return Padding(
                  padding: const EdgeInsets.all(Sizes.p8),
                  child: PrimaryButton(
                    text: 'Atualizar permissão para encerrar oferta'.hardcoded,
                    isLoading: isLoading,
                    onPressed: () =>
                        ref.invalidate(soapResourceDatasourceProvider),
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
          gapH8,
          PracticedPrice(saleType: SaleType.retail, product: widget.product),
          PracticedPrice(saleType: SaleType.whole, product: widget.product),
          PracticedPrice(saleType: SaleType.ecommerce, product: widget.product),
          if (retailSuggestion > 0 ||
              wholeSuggestion > 0 ||
              ecommerceSuggestion > 0) ...[
            gapH32,
            BaseText.headline('Preços sugeridos'.hardcoded),
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
            BaseText.headline('Preços mínimos'.hardcoded),
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
