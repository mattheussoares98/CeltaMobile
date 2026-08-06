import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';
import 'package:celta_inventario/features/synchronizer/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SynchronizerProductErrorItem extends ConsumerWidget {
  const SynchronizerProductErrorItem({super.key, required this.item});
  final BSFProductWithErrorSynchronizerErrorDetailEntity item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedProvider = selectedSynchronizerCodesStateControllerProvider(
      SynchronizerErrorDetailType.productWithError,
    );

    void onTap(int code) {
      ref.read(selectedProvider.notifier).select(code);
    }

    return Card(
      clipBehavior: .hardEdge,
      child: InkWell(
        onTap: () => onTap(item.code),
        child: Padding(
          padding: const EdgeInsets.all(Sizes.p8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: BaseRichText(
                      texts: [
                        BaseText.title(
                          '(${item.priceLookUp})',
                          color: context.theme.primaryColor,
                        ),
                        BaseText.titleMedium(' ${item.productName} '),
                        BaseText.title(
                          item.formattedPacking,
                          color: context.theme.colorScheme.secondary,
                        ),
                      ],
                    ),
                  ),
                  gapW4,
                  Consumer(
                    builder: (_, ref, _) {
                      final isSelected = ref.watch(
                        selectedProvider.select((s) => s.contains(item.code)),
                      );
                      return BaseCheckBox(
                        name: 'Selecionar produto'.hardcoded,
                        enabled: isSelected,
                        onChanged: (_) => onTap(item.code),
                        width: Sizes.p20,
                        height: Sizes.p20,
                      );
                    },
                  ),
                ],
              ),
              TitleAndSubTitle(
                title: 'Site'.hardcoded,
                subTitle: item.commerceSite,
              ),
              if (item.productCommerceSiteId.isNotEmpty)
                TitleAndSubTitle(
                  title: 'ID do Produto no Site'.hardcoded,
                  subTitle: item.productCommerceSiteId,
                  copyableSubtitle: true,
                ),
              if (item.errorDescription.isNotEmpty &&
                  item.errorDescription != item.errorMessage)
                TitleAndSubTitle(
                  title: 'Descrição do erro'.hardcoded,
                  subTitle: item.errorDescription,
                ),
              Row(
                children: [
                  Expanded(
                    child: BaseText.error(item.errorMessage, textAlign: .start),
                  ),
                  if (item.moreInfo.isNotEmpty)
                    IconButton(
                      onPressed: () {
                        showAlertDialog(
                          context: context,
                          title: 'Mais informações do erro'.hardcoded,
                          content: item.moreInfo,
                        );
                      },
                      icon: const PlatformIcon(
                        cupertinoIcon: CupertinoIcons.info_circle,
                        materialIcon: Icons.info_outline,
                      ),
                    ),
                ],
              ),
              if (item.lastChargeOfProduct != null)
                TitleAndSubTitle(
                  title: 'Carga do produto'.hardcoded,
                  subTitle: item.lastChargeOfProduct!.formatDate(
                    DateFormatType.ddMMyyyyHHmm,
                  ),
                ),
              if (item.lastChargeOfSalePrice != null)
                TitleAndSubTitle(
                  title: 'Carga de preços'.hardcoded,
                  subTitle: item.lastChargeOfSalePrice!.formatDate(
                    DateFormatType.ddMMyyyyHHmm,
                  ),
                ),
              if (item.lastChargeOfStock != null)
                TitleAndSubTitle(
                  title: 'Carga de estoques'.hardcoded,
                  subTitle: item.lastChargeOfStock!.formatDate(
                    DateFormatType.ddMMyyyyHHmm,
                  ),
                ),
              Row(
                children: [
                  PlatformIcon(
                    cupertinoIcon: item.hasSendingRestriction
                        ? CupertinoIcons.exclamationmark_triangle
                        : CupertinoIcons.check_mark,
                    materialIcon: item.hasSendingRestriction
                        ? Icons.warning
                        : Icons.check,
                    color: item.hasSendingRestriction
                        ? Colors.orange
                        : Colors.green,
                    size: 16,
                  ),
                  gapW4,
                  Expanded(
                    child: BaseText(
                      item.hasSendingRestriction
                          ? 'Não enviado ao site'.hardcoded
                          : 'Enviado ao site'.hardcoded,
                      color: item.hasSendingRestriction
                          ? Colors.orange
                          : Colors.green,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
