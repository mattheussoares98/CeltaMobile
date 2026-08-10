import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';
import 'package:celta_inventario/features/synchronizer/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CashierMovementItems extends ConsumerWidget {
  const CashierMovementItems({
    super.key,
    required this.items,
    required this.errorKey,
  });
  final List<EcCashierMovementSynchronizerErrorDetailEntity> items;
  final String errorKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = selectedSynchronizerCodesStateControllerProvider(
      SynchronizerErrorDetailType.cashierMovement,
    );

    final isSelectable = errorKey.toLowerCase().contains('marcados') == false;

    return ResponsiveListFlow(
      padding: const EdgeInsets.all(Sizes.p8),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final cashierMovement = items[index];
        return Card(
          clipBehavior: .hardEdge,
          child: InkWell(
            onTap: isSelectable
                ? () => ref.read(provider.notifier).select(cashierMovement.code)
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
                          title: 'Empresa'.hardcoded,
                          subTitle: cashierMovement.enterprisePersonalizedCode,
                        ),
                      ),
                      if (isSelectable)
                        Consumer(
                          builder: (_, ref, _) {
                            final isSelected = ref.watch(
                              provider.select(
                                (s) => s.contains(cashierMovement.code),
                              ),
                            );
                            return BaseCheckBox(
                              name: 'Selecionar'.hardcoded,
                              enabled: isSelected,
                              onChanged: (_) => ref
                                  .read(provider.notifier)
                                  .select(cashierMovement.code),
                              width: Sizes.p20,
                              height: Sizes.p20,
                            );
                          },
                        ),
                    ],
                  ),
                  TitleAndSubTitle(
                    title: 'Caixa'.hardcoded,
                    subTitle: cashierMovement.cashRegisterPersonalizedCode,
                  ),
                  TitleAndSubTitle(
                    title: 'Criação'.hardcoded,
                    subTitle: cashierMovement.creationDate.formatDate(
                      .ddMMyyyyHHmm,
                    ),
                  ),
                  TitleAndSubTitle(
                    title: 'Abertura/Fechamento'.hardcoded,
                    subTitle: cashierMovement.openOrCloseDate.formatDate(
                      .ddMMyyyyHHmm,
                    ),
                  ),
                  TitleAndSubTitle(
                    title: 'Descrição'.hardcoded,
                    subTitle: null,
                    emptyMessage: cashierMovement.description,
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
