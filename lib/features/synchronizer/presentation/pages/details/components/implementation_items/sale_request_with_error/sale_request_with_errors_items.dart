import 'dart:async';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/presentation/controllers/products/products.dart';
import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';
import 'package:celta_inventario/features/synchronizer/presentation/controllers/controllers.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'associate_product_page.dart';

class SaleRequestWithErrorsItems extends ConsumerWidget {
  const SaleRequestWithErrorsItems({
    super.key,
    required this.items,
    required this.errorKey,
  });
  final List<EcSaleRequestWithErrorSynchronizerErrorDetailEntity> items;
  final String errorKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = selectedSynchronizerCodesStateControllerProvider(
      SynchronizerErrorDetailType.saleRequestWithError,
    );

    return ResponsiveListFlow(
      itemCount: items.length,
      padding: const EdgeInsets.all(Sizes.p8),
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          clipBehavior: .hardEdge,
          child: InkWell(
            onTap: () => ref.read(provider.notifier).select(item.code),
            child: Padding(
              padding: const EdgeInsets.all(Sizes.p8),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TitleAndSubTitle(
                          title: context.l10n.enterprise,
                          subTitle: item.enterprisePersonalizedCode,
                        ),
                      ),
                      Consumer(
                        builder: (_, ref, _) {
                          final isSelected = ref.watch(
                            provider.select((s) => s.contains(item.code)),
                          );
                          return BaseCheckBox(
                            name: context.l10n.selectOrder,
                            enabled: isSelected,
                            onChanged: (_) =>
                                ref.read(provider.notifier).select(item.code),
                            width: Sizes.p20,
                            height: Sizes.p20,
                          );
                        },
                      ),
                    ],
                  ),
                  TitleAndSubTitle(
                    title: context.l10n.lastRead,
                    subTitle: item.creationDate.formatDate(
                      DateFormatType.ddMMyyyyHHmm,
                    ),
                  ),
                  TitleAndSubTitle(
                    title: context.l10n.orderCreation,
                    subTitle: item.cadasterDate.formatDate(
                      DateFormatType.ddMMyyyyHHmm,
                    ),
                  ),
                  if (item.commerceSite.isNotEmpty)
                    TitleAndSubTitle(
                      title: context.l10n.website,
                      subTitle: item.commerceSite,
                    ),
                  if (item.saleRequestInvoiceCode.isNotEmpty)
                    TitleAndSubTitle(
                      title: context.l10n.invoice,
                      subTitle: item.saleRequestInvoiceCode,
                      copyableSubtitle: true,
                    ),
                  if (item.saleRequestNumber.isNotEmpty)
                    TitleAndSubTitle(
                      title: context.l10n.order,
                      subTitle: item.saleRequestNumber,
                      copyableSubtitle: true,
                    ),
                  for (var i = 0; i < item.details.length; i++)
                    Column(
                      children: [
                        if (i == 0 || i < item.details.length) const Divider(),
                        if (i == 0)
                          Align(child: BaseText.error(context.l10n.details)),
                        BaseText.title(
                          item.details[i],
                          color: Colors.red,
                          textAlign: .start,
                        ),
                      ],
                    ),
                  if (item.productsNotFound.isNotEmpty)
                    for (var i = 0; i < item.productsNotFound.length; i++)
                      Column(
                        crossAxisAlignment: .start,
                        children: [
                          if (i == 0 || i < item.productsNotFound.length)
                            const Divider(),
                          if (i == 0)
                            Align(
                              child: BaseText.error(
                                context.l10n.productsNotFound,
                              ),
                            ),
                          TitleAndSubTitle(
                            title: context.l10n.websiteCode,
                            subTitle: item.productsNotFound[i].eCommerceCode,
                            copyableSubtitle: true,
                          ),
                          TitleAndSubTitle(
                            title: context.l10n.product,
                            subTitle: item.productsNotFound[i].name,
                            copyableSubtitle: true,
                          ),
                          Align(
                            alignment: .centerRight,
                            child: PrimaryButton(
                              onPressed: () async {
                                await showModalPage(
                                  AssociateProductPage(
                                    errorKey: errorKey,
                                    productNotFound: item.productsNotFound[i],
                                  ),
                                  context,
                                );
                              },
                              text: context.l10n.link,
                            ),
                          ),
                        ],
                      ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
