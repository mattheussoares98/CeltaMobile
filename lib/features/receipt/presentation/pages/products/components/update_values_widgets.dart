import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../../../../core/validators/validators.dart';
import '../../../../../../localization/string_hardcoded.dart';
import '../../../../../../utils/utils.dart';
import '../../../controllers/controllers.dart';
import 'components.dart';

class UpdateValuesWidgets extends ConsumerStatefulWidget {
  final ProductEntity product;
  final TextEditingController quantityController;
  final SearchProductKey searchProductKey;
  final int receiptCode;
  final FocusNode quantityFocusNode;
  const UpdateValuesWidgets({
    super.key,
    required this.product,
    required this.quantityController,
    required this.searchProductKey,
    required this.receiptCode,
    required this.quantityFocusNode,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UpdateValuesWidgetsState();
}

class _UpdateValuesWidgetsState extends ConsumerState<UpdateValuesWidgets> {
  DateTime? newValidity;
  final formKey = GlobalKey<FormState>();

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        newValidity = widget.product.DataValidade_ProcRecebDocProEmb;
      }
    });
  }

  void update({bool? isSubtract, bool? isAnnul}) {
    if (isAnnul != true && formKey.currentState?.validate() != true) {
      return;
    }

    widget.quantityFocusNode.unfocus();
    FocusManager.instance.primaryFocus?.unfocus();

    ref
        .read(updateProductControllerProvider(widget.searchProductKey).notifier)
        .updateValues(
          grDocCode: widget.receiptCode,
          productPackingCode: widget.product.ProductPackingCode!,
          isSubtract: isSubtract == true || isAnnul == true,
          quantity: isAnnul == true
              ? widget.product.Quantidade_ProcRecebDocProEmb ?? 0
              : widget.quantityController.text.toDouble()!,
          newValidityDate: newValidity,
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool hasInsertedQuantity =
        widget.product.Quantidade_ProcRecebDocProEmb != null &&
        widget.product.Quantidade_ProcRecebDocProEmb! > 0;

    return Column(
      children: [
        const Divider(),
        Validity(
          product: widget.product,
          newValidityDate: newValidity,
          onValidityDateChanged: (value) => newValidity = value,
        ),
        gapH8,
        Row(
          children: [
            Expanded(
              child: PrimaryButton(
                text: 'Subtrair'.hardcoded,
                onPressed: () => update(isSubtract: true),
              ),
            ),
            gapW8,
            Expanded(
              flex: 2,
              child: PrimaryButton(
                text: 'Somar'.hardcoded,
                onPressed: () => update(isSubtract: false),
              ),
            ),
          ],
        ),
        gapH8,
        Row(
          children: [
            Expanded(
              child: PrimaryButton(
                text: 'Anular'.hardcoded,
                onPressed: hasInsertedQuantity
                    ? () {
                        showAlertDialog(
                          context: context,
                          title: 'Anular'.hardcoded,
                          content: 'Tem certeza que deseja anular a contagem?'
                              .hardcoded,
                          onOkPressed: () {
                            update(isAnnul: true);
                          },
                          defaultActionText: 'Sim'.hardcoded,
                          cancelActionText: 'Não'.hardcoded,
                        );
                      }
                    : null,
                backgroundColor: hasInsertedQuantity
                    ? Colors.red
                    : theme.disabledColor,
              ),
            ),
            gapW8,
            Expanded(
              flex: 3,
              child: Form(
                key: formKey,
                child: DefaultTextFormField(
                  hintText: 'Quantidade'.hardcoded,
                  labelText: 'Quantidade'.hardcoded,
                  controller: widget.quantityController,
                  focusNode: widget.quantityFocusNode,
                  maxLength: 10,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  validator: FormValidators.compose([
                    NumberValidator(allowDecimal: true, maxDecimalHouses: 3),
                  ]),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
