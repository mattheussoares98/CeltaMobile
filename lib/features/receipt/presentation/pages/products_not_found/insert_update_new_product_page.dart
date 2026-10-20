import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/validators/validators.dart';
import 'package:celta_inventario/features/receipt/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/localization.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InsertUpdateProductPage extends ConsumerWidget {
  final int receiptCode;
  final GlobalKey<FormState> formKey;
  final FocusNode quantityFocusNode;
  final FocusNode observationsFocusNode;
  final FocusNode eanFocusNode;
  final TextEditingController eanController;
  final TextEditingController quantityController;
  final TextEditingController observationsController;
  final VoidCallback onSubmit;
  final bool isEditing;
  const InsertUpdateProductPage({
    super.key,
    required this.receiptCode,
    required this.formKey,
    required this.quantityFocusNode,
    required this.observationsFocusNode,
    required this.eanFocusNode,
    required this.eanController,
    required this.quantityController,
    required this.observationsController,
    required this.onSubmit,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(insertProductNotFoundControllerProvider(receiptCode), (p, n) {
      n.showAlertDialogOnError(context);
    });

    final isLoading = ref.watch(
      insertProductNotFoundControllerProvider(
        receiptCode,
      ).select((s) => s.isLoading),
    );

    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Sizes.p8),
          child: Column(
            children: [
              BaseTextFormField(
                controller: eanController,
                enabled: !isLoading && !isEditing,
                focusNode: eanFocusNode,
                onFieldSubmitted: (_) => quantityFocusNode.requestFocus(),
                keyboardType: const TextInputType.numberWithOptions(),
                validator: FormValidators.compose([
                  NumberValidator(
                    translations: context.l10n,
                    allowDecimal: false,
                  ),
                  MinLengthValidator(8, translations: context.l10n),
                ]),
                labelText: 'EAN'.hardcoded,
                hintText: 'EAN'.hardcoded,
                maxLength: 22,
              ),
              BaseTextFormField(
                controller: quantityController,
                enabled: !isLoading,
                focusNode: quantityFocusNode,
                onFieldSubmitted: (_) => observationsFocusNode.requestFocus(),
                keyboardType: const TextInputType.numberWithOptions(),
                validator: FormValidators.compose([
                  NumberValidator(
                    translations: context.l10n,
                    allowDecimal: true,
                  ),
                ]),
                labelText: 'Quantidade'.hardcoded,
                hintText: 'Quantidade'.hardcoded,
                maxLength: 10,
              ),
              BaseTextFormField(
                controller: observationsController,
                enabled: !isLoading,
                focusNode: observationsFocusNode,
                onFieldSubmitted: (_) => onSubmit(),
                labelText: 'Observações'.hardcoded,
                hintText: 'Observações'.hardcoded,
              ),
              gapH32,
              PrimaryButton(
                text: 'Salvar',
                onPressed: onSubmit,
                isLoading: isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
