import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../core/validators/validators.dart';
import '../../../../../localization/string_hardcoded.dart';
import '../../../../../utils/utils.dart';
import '../../controllers/controllers.dart';

class InsertUpdateProductPage extends ConsumerWidget {
  final int receiptCode;
  final GlobalKey<FormState> formKey;
  final FocusNode quantityFocusNode;
  final FocusNode observationsFocusNode;
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
              DefaultTextFormField(
                controller: eanController,
                enabled: !isLoading && !isEditing,
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
                enabled: !isLoading,
                focusNode: quantityFocusNode,
                onFieldSubmitted: (_) => observationsFocusNode.requestFocus(),
                validator: FormValidators.compose([
                  NumberValidator(allowDecimal: true),
                ]),
                labelText: 'Quantidade'.hardcoded,
                hintText: 'Quantidade'.hardcoded,
              ),
              DefaultTextFormField(
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
