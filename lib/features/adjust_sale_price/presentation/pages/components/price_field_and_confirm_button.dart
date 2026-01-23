import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../core/validators/validators.dart';
import '../../../../../utils/utils.dart';
import '../../controllers/controllers.dart';

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
  final formKey = GlobalKey<FormState>();

  @override
  dispose() {
    super.dispose();
    priceController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> onPressed() async {
      if (formKey.currentState?.validate() != true) {
        return;
      }

      FocusManager.instance.primaryFocus?.unfocus();

      bool? confirmed = await showAlertDialog(
        context: context,
        title: 'Confirmar?'.hardcoded,
        cancelActionText: 'Cencelar'.hardcoded,
        defaultActionText: 'Sim'.hardcoded,
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

    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.only(top: Sizes.p8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 65,
              child: DefaultTextFormField(
                controller: priceController,
                maxLength: 10,
                hintText: "Novo preço".hardcoded,
                labelText: "Novo preço".hardcoded,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onFieldSubmitted: (_) => onPressed(),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: FormValidators.compose([
                  NonEmptyValidator(),
                  NumberValidator(
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
                      text: 'Confirmar'.hardcoded,
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
