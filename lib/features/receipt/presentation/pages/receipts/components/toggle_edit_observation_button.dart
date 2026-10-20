import 'package:celta_inventario/utils/utils.dart';
import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/receipt/domain/entity/entity.dart';
import 'package:celta_inventario/features/receipt/presentation/controllers/controllers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ToggleUpdateObservationButton extends ConsumerWidget {
  final ReceiptEntity receipt;
  final int enterpriseCode;
  final int index;
  final TextEditingController observationsController;
  const ToggleUpdateObservationButton({
    super.key,
    required this.receipt,
    required this.enterpriseCode,
    required this.index,
    required this.observationsController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final observations =
        receipt.Observacoes_ProcRecebDoc ?? receipt.DefaultObservations;

    return PrimaryTextButton(
      text: observations == null || observations.isEmpty
          ? context.l10n.addNote
          : context.l10n.editNote,
      isLoading: ref.watch(
        receiptsStateControllerProvider(
          enterpriseCode,
        ).select((s) => s.isLoading),
      ),
      onPressed: () {
        ref
            .read(
              selectedIndexUpdateObservationsStateControllerProvider.notifier,
            )
            .updateSelectedIndex(index);

        observationsController.text =
            (receipt.Observacoes_ProcRecebDoc ??
                    receipt.DefaultObservations ??
                    '')
                .replaceAll(RegExp(r'\\r\\'), '')
                .replaceAll(RegExp(r'\\n'), '\n')
                .replaceAll(RegExp(r'\\'), '');
      },
      platformIcon: const PlatformIcon(
        cupertinoIcon: CupertinoIcons.pencil,
        materialIcon: Icons.edit,
      ),
    );
  }
}
