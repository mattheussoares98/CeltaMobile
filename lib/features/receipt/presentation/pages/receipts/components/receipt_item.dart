import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../core/validators/validators.dart';
import '../../../../../../localization/string_hardcoded.dart';
import '../../../../domain/entity/entity.dart';
import '../../controllers/controllers.dart';
import 'components.dart';

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
    final selectedIndex = ref.watch(
      selectedIndexUpdateObservationsStateControllerProvider.select(
        (s) => s.value,
      ),
    );

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          InkWell(
            onTap: () {
              //TODO navigate to products page
            },
            child: Padding(
              padding: const EdgeInsets.all(Sizes.p8),
              child: Column(
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
                  if (selectedIndex != widget.index) ...[
                    gapH4,
                    Stack(
                      children: [
                        gapH8,
                        CurrentObservations(receipt: widget.receipt),
                        Positioned(
                          top: -5,
                          right: 0,
                          child: ToggleUpdateObservationButton(
                            receipt: widget.receipt,
                            enterpriseCode: widget.enterpriseCode,
                            index: widget.index,
                            observationsController:
                                widget.observationsController,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (selectedIndex == widget.index) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Sizes.p8),
              child: Column(
                children: [
                  Form(
                    key: formKey,
                    child: DefaultTextFormField(
                      maxLines: 5,
                      maxLength: 500,
                      controller: widget.observationsController,
                      hintText: 'Nova observação'.hardcoded,
                      labelText: 'Nova observação'.hardcoded,
                      validator: FormValidators.compose([NonEmptyValidator()]),
                    ),
                  ),
                  gapH8,
                  CancelAndConfirmUpdateObservationButtons(
                    index: widget.index,
                    observationsController: widget.observationsController,
                    updateObservations: updateObservations,
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: Sizes.p8),
              child: Divider(),
            ),
          ],
        ],
      ),
    );
  }
}
