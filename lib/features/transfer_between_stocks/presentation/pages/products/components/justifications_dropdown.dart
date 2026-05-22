import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/transfer_justification/transfer_justification.dart';
import 'package:celta_inventario/features/transfer_between_stocks/presentation/controllers/controllers.dart';

class JustificationsDropdown extends ConsumerWidget {
  final int enterpriseCode;
  const JustificationsDropdown({super.key, required this.enterpriseCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AsyncValueWidget(
      value: ref.watch(
        transferJustificationStateControllerProvider(
          enterpriseCode,
          TransferJustificationType.transferBetweenStocks,
        ),
      ),
      tryAgain: () {
        ref.invalidate(
          transferJustificationStateControllerProvider(
            enterpriseCode,
            TransferJustificationType.transferBetweenStocks,
          ),
        );
      },
      data: (justifications) {
        return DefaultSimpleDropDown<TransferJustificationEntity?>(
          onChanged: (value) {
            ref
                .read(
                  selectedProductUIStateControllerProvider(
                    enterpriseCode,
                  ).notifier,
                )
                .updateValues(justification: value);
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
              key: ValueKey(e.CodigoInterno_JustMov),
              value: e,
              child: Center(child: Text(e.Descricao_JustMov)),
            );
          }).toList(),
          value: ref.watch(
            selectedProductUIStateControllerProvider(
              enterpriseCode,
            ).select((s) => s.selectedJustification),
          ),
          hint: 'Justificativas'.hardcoded,
        );
      },
    );
  }
}
