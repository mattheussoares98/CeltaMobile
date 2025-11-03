import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../../../core/presentation/controllers/transfer_justification/transfer_justification.dart';

class JustificationsDropdown extends ConsumerWidget {
  final TransferJustificationEntity? selectedJustification;
  final int enterpriseCode;
  final void Function(TransferJustificationEntity? value) onChanged;
  const JustificationsDropdown({
    super.key,
    required this.selectedJustification,
    required this.enterpriseCode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final justificationsAsync = ref.watch(
      transferJustificationStateControllerProvider(
        enterpriseCode,
        TransferJustificationType.adjustStock,
      ),
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
          onChanged: onChanged,
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
