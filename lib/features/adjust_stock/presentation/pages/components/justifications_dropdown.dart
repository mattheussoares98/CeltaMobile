import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/transfer_justification/transfer_justification.dart';
import 'package:celta_inventario/features/adjust_stock/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      selectedUIStateControllerProvider(
        enterpriseCode,
      ).select((s) => s.selectedJustification),
    );

    return RepaintBoundary(
      child: AsyncValueWidget(
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
          return DefaultDropDown<TransferJustificationEntity?>(
            onChanged: (value) async {
              ref
                  .read(
                    selectedUIStateControllerProvider(enterpriseCode).notifier,
                  )
                  .updateValues(selectedJustification: value);
            },
            validator: (value) {
              if (value == null) {
                return 'Justificativa obrigatória'.hardcoded;
              }
              return null;
            },
            items: justifications.map((e) {
              return DropdownMenuItem(
                value: e,
                child: DefaultText(e.Descricao_JustMov),
              );
            }).toList(),
            selectedItem: selectedJustification,
            label: 'Justificativas'.hardcoded,
            isSimple: true,
          );
        },
      ),
    );
  }
}
