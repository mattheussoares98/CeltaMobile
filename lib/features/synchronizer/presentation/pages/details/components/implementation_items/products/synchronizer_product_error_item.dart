import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';
import 'package:celta_inventario/features/synchronizer/presentation/controllers/controllers.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SynchronizerProductErrorItem extends ConsumerWidget {
  const SynchronizerProductErrorItem({super.key, required this.item});
  final EcProductWithErrorSynchronizerErrorDetailEntity item;

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
                        name: context.l10n.selectProduct,
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
                title: context.l10n.website,
                subTitle: item.commerceSite,
              ),
              if (item.productCommerceSiteId.isNotEmpty)
                TitleAndSubTitle(
                  title: context.l10n.productIdOnWebsite,
                  subTitle: item.productCommerceSiteId,
                  copyableSubtitle: true,
                ),
              if (item.errorDescription.isNotEmpty &&
                  item.errorDescription != item.errorMessage)
                TitleAndSubTitle(
                  title: context.l10n.errorDescription,
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
                          title: context.l10n.moreErrorInformation,
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
                  title: context.l10n.productUpload,
                  subTitle: item.lastChargeOfProduct!.formatDate(
                    DateFormatType.ddMMyyyyHHmm,
                  ),
                ),
              if (item.lastChargeOfSalePrice != null)
                TitleAndSubTitle(
                  title: context.l10n.priceUpload,
                  subTitle: item.lastChargeOfSalePrice!.formatDate(
                    DateFormatType.ddMMyyyyHHmm,
                  ),
                ),
              if (item.lastChargeOfStock != null)
                TitleAndSubTitle(
                  title: context.l10n.stockUpload,
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
                          ? context.l10n.notSentToWebsite
                          : context.l10n.sentToWebsite,
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
