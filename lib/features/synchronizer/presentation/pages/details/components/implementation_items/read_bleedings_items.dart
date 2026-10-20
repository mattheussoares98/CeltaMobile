import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';
import 'package:celta_inventario/features/synchronizer/presentation/controllers/controllers.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReadBleedingsItems extends ConsumerWidget {
  const ReadBleedingsItems({
    super.key,
    required this.items,
    required this.errorKey,
  });
  final List<EcReadBleedingSynchronizerErrorDetailEntity> items;
  final String errorKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = selectedSynchronizerCodesStateControllerProvider(
      SynchronizerErrorDetailType.readBleeding,
    );

    final isSelectable = errorKey.toLowerCase().contains('marcadas') == false;

    return ResponsiveListFlow(
      padding: const EdgeInsets.all(Sizes.p8),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final bleeding = items[index];
        return Card(
          clipBehavior: .hardEdge,
          child: InkWell(
            onTap: isSelectable
                ? () => ref.read(provider.notifier).select(bleeding.code)
                : null,
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
                          subTitle: bleeding.enterprisePersonalizedCode,
                        ),
                      ),
                      if (isSelectable)
                        Consumer(
                          builder: (_, ref, _) {
                            final isSelected = ref.watch(
                              provider.select((s) => s.contains(bleeding.code)),
                            );
                            return BaseCheckBox(
                              name: context.l10n.select2,
                              enabled: isSelected,
                              onChanged: (_) => ref
                                  .read(provider.notifier)
                                  .select(bleeding.code),
                              width: Sizes.p20,
                              height: Sizes.p20,
                            );
                          },
                        ),
                    ],
                  ),
                  TitleAndSubTitle(
                    title: context.l10n.register,
                    subTitle: bleeding.cashierNumber,
                  ),
                  TitleAndSubTitle(
                    title: context.l10n.errorDate,
                    subTitle: bleeding.creationDate.formatDate(.ddMMyyyyHHmm),
                  ),
                  TitleAndSubTitle(
                    title: context.l10n.cashWithdrawalDate,
                    subTitle: bleeding.movementDate.formatDate(.ddMMyyyyHHmm),
                  ),
                  TitleAndSubTitle(
                    title: context.l10n.description,
                    subTitle: null,
                    emptyMessage: bleeding.description,
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
