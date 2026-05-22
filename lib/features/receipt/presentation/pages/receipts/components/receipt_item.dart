import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/validators/validators.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/features/receipt/domain/entity/entity.dart';
import 'package:celta_inventario/features/receipt/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/receipt/presentation/pages/receipts/components/components.dart';

class ReceiptItem extends ConsumerStatefulWidget {
  final ReceiptEntity receipt;
  final int index;
  final int enterpriseCode;
  final TextEditingController observationsController;
  const ReceiptItem({
    super.key,
    required this.receipt,
    required this.index,
    required this.enterpriseCode,
    required this.observationsController,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ReceiptItemState();
}

class _ReceiptItemState extends ConsumerState<ReceiptItem> {
  final formKey = GlobalKey<FormState>();

  void updateObservations() {
    if (formKey.currentState?.validate() != true) {
      return;
    }

    ref
        .read(selectedIndexUpdateObservationsStateControllerProvider.notifier)
        .updateObservations(
          enterpriseCode: widget.enterpriseCode,
          observations: widget.observationsController.text,
          CodigoInterno_ProcRecebDoc: widget.receipt.CodigoInterno_ProcRecebDoc,
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSelected = ref.watch(
      selectedIndexUpdateObservationsStateControllerProvider.select(
        (s) => s.value == widget.index,
      ),
    );

    final shouldInsertObservations =
        widget.receipt.DefaultObservations != null &&
        widget.receipt.DefaultObservations!.isNotEmpty &&
        (widget.receipt.Observacoes_ProcRecebDoc == null ||
            widget.receipt.Observacoes_ProcRecebDoc!.isEmpty);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p8),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TitleAndSubTitle(
                  title: 'Recebimento'.hardcoded,
                  subTitle: widget.receipt.Numero_ProcRecebDoc.toString(),
                ),
                TitleAndSubTitle(
                  title: null,
                  subTitle: widget.receipt.status.description,
                  subTitleStyle: theme.textTheme.titleMedium?.copyWith(
                    color: widget.receipt.status.color,
                  ),
                ),
                if (widget.receipt.EmitterName != null)
                  TitleAndSubTitle(
                    title: 'Emitente'.hardcoded,
                    subTitle: widget.receipt.EmitterName,
                  ),
                if (widget.receipt.Grupo != null)
                  TitleAndSubTitle(
                    title: 'Grupo'.hardcoded,
                    subTitle: widget.receipt.Grupo,
                    subTitleStyle: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.amber,
                    ),
                  ),
                if (!isSelected) ...[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CurrentObservations(receipt: widget.receipt),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ToggleUpdateObservationButton(
                          receipt: widget.receipt,
                          enterpriseCode: widget.enterpriseCode,
                          index: widget.index,
                          observationsController: widget.observationsController,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
            if (isSelected) ...[
              Column(
                children: [
                  Form(
                    key: formKey,
                    child: DefaultTextFormField(
                      maxLines: 13,
                      maxLength: 500,
                      controller: widget.observationsController,
                      hintText: 'Nova observação'.hardcoded,
                      labelText: 'Nova observação'.hardcoded,
                      validator: shouldInsertObservations
                          ? FormValidators.compose([NonEmptyValidator()])
                          : null,
                    ),
                  ),
                  gapH8,
                  AnimatedBuilder(
                    animation: widget.observationsController,
                    builder: (_, _) {
                      bool updatedObservations =
                          widget.receipt.Observacoes_ProcRecebDoc !=
                          widget.observationsController.text;
                      return CancelAndConfirmUpdateObservationButtons(
                        index: widget.index,
                        observationsController: widget.observationsController,
                        updateObservations: updatedObservations
                            ? updateObservations
                            : null,
                      );
                    },
                  ),
                ],
              ),
            ],
            Column(
              children: [
                const Divider(height: Sizes.p12, thickness: 2),
                if (shouldInsertObservations)
                  Text(
                    'Observação pendente'.hardcoded,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontStyle: FontStyle.italic,
                      color: Colors.red,
                    ),
                  )
                else
                  LiberateAndConferButtons(
                    receipt: widget.receipt,
                    enterpriseCode: widget.enterpriseCode,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
