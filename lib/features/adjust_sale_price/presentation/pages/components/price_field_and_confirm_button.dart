import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/validators/validators.dart';
import 'package:celta_inventario/features/adjust_sale_price/presentation/controllers/controllers.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PriceFieldAndConfirmButton extends ConsumerStatefulWidget {
  final int enterpriseCode;
  final String plu;
  const PriceFieldAndConfirmButton({
    super.key,
    required this.enterpriseCode,
    required this.plu,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PriceFieldAndConfirmButtonState();
}

class _PriceFieldAndConfirmButtonState
    extends ConsumerState<PriceFieldAndConfirmButton> {
  final priceController = TextEditingController();
  final priceFocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  @override
  dispose() {
    super.dispose();
    priceController.dispose();
    priceFocusNode.dispose();
  }

  Future<void> onPressed() async {
    if (formKey.currentState?.validate() != true) {
      return;
    }

    if (priceFocusNode.hasFocus) {
      priceFocusNode.unfocus();
    }
    FocusManager.instance.primaryFocus?.unfocus();

    bool? confirmed = await showAlertDialog(
      context: context,
      title: context.l10n.confirmQuestion,
      cancelActionText: context.l10n.cancel,
      defaultActionText: context.l10n.yes,
    );

    if (confirmed != true) {
      return;
    }

    await ref
        .read(confirmAdjustControllerProvider.notifier)
        .confirm(
          enterpriseCode: widget.enterpriseCode,
          now: DateTime.now(),
          plu: widget.plu,
          price: priceController.text.toDouble() ?? 0,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.only(top: Sizes.p8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 65,
              child: BaseTextFormField(
                controller: priceController,
                focusNode: priceFocusNode,
                maxLength: 10,
                hintText: context.l10n.newPrice,
                labelText: context.l10n.newPrice,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onFieldSubmitted: (_) => onPressed(),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: FormValidators.compose([
                  NonEmptyValidator(translations: context.l10n),
                  NumberValidator(
                    translations: context.l10n,
                    allowDecimal: true,
                    needsBeGreaterThanZero: false,
                  ),
                ]),
              ),
            ),
            gapW8,
            Expanded(
              flex: 35,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: Sizes.p8),
                    child: PrimaryButton(
                      text: context.l10n.confirm,
                      onPressed: onPressed,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
