import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/validators/validators.dart';
import 'package:celta_inventario/features/receipt/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/receipt/presentation/pages/products/components/components.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdateValuesWidgets extends ConsumerStatefulWidget {
  final ProductEntity product;
  final TextEditingController quantityController;
  final SearchProductKey searchProductKey;
  final int receiptCode;
  final int productIndex;
  final FocusNode quantityFocusNode;
  const UpdateValuesWidgets({
    super.key,
    required this.product,
    required this.quantityController,
    required this.searchProductKey,
    required this.receiptCode,
    required this.productIndex,
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
      widget.quantityFocusNode.requestFocus();
      return;
    }

    widget.quantityFocusNode.unfocus();
    FocusManager.instance.primaryFocus?.unfocus();

    ref
        .read(updateProductControllerProvider(widget.searchProductKey).notifier)
        .updateValues(
          grDocCode: widget.receiptCode,
          productIndex: widget.productIndex,
          isSubtract: isSubtract == true || isAnnul == true,
          quantity: isAnnul == true
              ? widget.product.Quantidade_ProcRecebDocProEmb ?? 0
              : widget.quantityController.text.toDouble()!,
          newValidityDate: newValidity,
        );
  }

  @override
  Widget build(BuildContext context) {
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
                text: context.l10n.subtract,
                onPressed: () => update(isSubtract: true),
              ),
            ),
            gapW8,
            Expanded(
              flex: 2,
              child: PrimaryButton(
                text: context.l10n.add3,
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
                text: context.l10n.voidAction,
                onPressed: hasInsertedQuantity
                    ? () async {
                        final confirmed = await showAlertDialog(
                          context: context,
                          title: context.l10n.voidAction,
                          content: context.l10n.areYouSureYouWantToVoidTheCount,
                          defaultActionText: context.l10n.yes,
                          cancelActionText: context.l10n.no,
                        );

                        if (confirmed != true || !context.mounted) return;
                        update(isAnnul: true);
                      }
                    : null,
                backgroundColor: hasInsertedQuantity
                    ? Colors.red
                    : context.theme.disabledColor,
              ),
            ),
            gapW8,
            Expanded(
              flex: 3,
              child: RepaintBoundary(
                child: Form(
                  key: formKey,
                  child: BaseTextFormField(
                    hintText: context.l10n.quantity,
                    labelText: context.l10n.quantity,
                    controller: widget.quantityController,
                    focusNode: widget.quantityFocusNode,
                    maxLength: 10,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: FormValidators.compose([
                      NumberValidator(
                        translations: context.l10n,
                        allowDecimal: true,
                        maxDecimalHouses: 3,
                      ),
                    ]),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
