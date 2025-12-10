import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../core/validators/validators.dart';
import '../../../../../localization/string_hardcoded.dart';
import '../../../../../utils/utils.dart';
import '../../controllers/controllers.dart';

class InsertNewProductPage extends ConsumerWidget {
  final int receiptCode;
  final GlobalKey<FormState> formKey;
  final FocusNode quantityFocusNode;
  final FocusNode observationsFocusNode;
  final TextEditingController eanController;
  final TextEditingController quantityController;
  final TextEditingController observationsController;
  const InsertNewProductPage({
    super.key,
    required this.receiptCode,
    required this.formKey,
    required this.quantityFocusNode,
    required this.observationsFocusNode,
    required this.eanController,
    required this.quantityController,
    required this.observationsController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> onSave() async {
      if (formKey.currentState?.validate() != true) {
        return;
      }

      final succeds = await ref
          .read(insertProductNotFoundControllerProvider(receiptCode).notifier)
          .insert(
            quantity: quantityController.text.toDouble()!,
            ean: eanController.text,
            observations: observationsController.text,
          );

      if (succeds) {
        eanController.clear();
        quantityController.clear();
        observationsController.clear();
        context.pop();
      }
    }

    return Consumer(
      builder: (_, ref, _) {
        ref.listen(insertProductNotFoundControllerProvider(receiptCode), (
          p,
          n,
        ) {
          n.showAlertDialogOnError(context);
        });
        return Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(Sizes.p8),
              child: Column(
                children: [
                  DefaultTextFormField(
                    controller: eanController,
                    onFieldSubmitted: (_) => quantityFocusNode.requestFocus(),
                    validator: FormValidators.compose([
                      NumberValidator(allowDecimal: false),
                      MinLengthValidator(8),
                    ]),
                    labelText: 'EAN'.hardcoded,
                    hintText: 'EAN'.hardcoded,
                  ),
                  DefaultTextFormField(
                    controller: quantityController,
                    focusNode: quantityFocusNode,
                    onFieldSubmitted: (_) =>
                        observationsFocusNode.requestFocus(),
                    validator: FormValidators.compose([
                      NumberValidator(allowDecimal: true),
                    ]),
                    labelText: 'Quantidade'.hardcoded,
                    hintText: 'Quantidade'.hardcoded,
                  ),
                  DefaultTextFormField(
                    controller: observationsController,
                    focusNode: observationsFocusNode,
                    onFieldSubmitted: (_) => onSave(),
                    labelText: 'Observações'.hardcoded,
                    hintText: 'Observações'.hardcoded,
                  ),
                  gapH32,
                  PrimaryButton(
                    text: 'Salvar',
                    onPressed: onSave,
                    isLoading: ref.watch(
                      productsNotFoundStateControllerProvider(
                        receiptCode,
                      ).select((s) => s.isLoading),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
