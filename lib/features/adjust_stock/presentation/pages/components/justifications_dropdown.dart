import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../../../core/presentation/controllers/stock/stock.dart';
import '../../../../../core/presentation/controllers/transfer_justification/transfer_justification.dart';
import '../../controllers/controllers.dart';

class JustificationsDropdown extends ConsumerWidget {
  final int enterpriseCode;
  const JustificationsDropdown({super.key, required this.enterpriseCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final justificationsAsync = ref.watch(
      transferJustificationStateControllerProvider(
        enterpriseCode,
        TransferJustificationType.adjustStock,
      ),
    );
    final selectedJustification = ref.watch(
      selectedUIStateControllerProvider.select((s) => s.selectedJustification),
    );

    return AsyncValueWidget(
      value: justificationsAsync,
      tryAgain: () {
        ref.invalidate(
          transferJustificationStateControllerProvider(
            enterpriseCode,
            TransferJustificationType.adjustStock,
          ),
        );
      },
      data: (justifications) {
        return DefaultSimpleDropDown<TransferJustificationEntity?>(
          isLoading: justificationsAsync.isLoading,
          onChanged: (value) async {
            ref
                .read(selectedUIStateControllerProvider.notifier)
                .udpateValues(selectedJustification: value);

            final stocks = await ref.read(
              stockTypeStateControllerProvider(enterpriseCode).future,
            );

            if (value?.CodigoInterno_TipoEstoque != null) {
              //TODO move to controller this logic
              ref
                  .read(selectedUIStateControllerProvider.notifier)
                  .udpateValues(
                    selectedStockType: stocks.firstWhere(
                      (e) =>
                          e.CodigoInterno_TipoEstoque ==
                          value?.CodigoInterno_TipoEstoque,
                    ),
                  );
            }

            ref
                .read(selectedUIStateControllerProvider.notifier)
                .udpateValues(selectedJustification: value);
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value == null) {
              return 'Justificativa obrigatória'.hardcoded;
            }
            return null;
          },
          items: justifications.map((e) {
            return DropdownMenuItem(
              value: e,
              child: Center(child: Text(e.Descricao_JustMov)),
            );
          }).toList(),
          value: selectedJustification,
          hint: 'Justificativas'.hardcoded,
        );
      },
    );
  }
}
