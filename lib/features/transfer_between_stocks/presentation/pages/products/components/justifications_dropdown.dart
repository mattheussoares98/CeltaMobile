import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../../../../core/presentation/controllers/transfer_justification/transfer_justification.dart';
import '../../../controllers/controllers.dart';

class JustificationsDropdown extends ConsumerWidget {
  final int enterpriseCode;
  const JustificationsDropdown({super.key, required this.enterpriseCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncValue = ref.watch(
      transferJustificationStateControllerProvider(
        enterpriseCode,
        TransferJustificationType.transferBetweenStocks,
      ),
    );
    final selectedJustification = ref.watch(
      selectedProductUIStateControllerProvider(
        enterpriseCode,
      ).select((s) => s.selectedJustification),
    );

    return AsyncValueWidget(
      value: asyncValue,
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
          isLoading: asyncValue.isLoading,
          onChanged: (value) {
            ref
                .read(
                  selectedProductUIStateControllerProvider(
                    enterpriseCode,
                  ).notifier,
                )
                .updateValues(justification: value);
            //! change the origin stock automatically in the controller when need
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
