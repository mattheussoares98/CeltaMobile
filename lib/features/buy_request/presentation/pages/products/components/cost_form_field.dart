import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../core/validators/validators.dart';

class CostFormField extends ConsumerWidget {
  final FocusNode costFocusNode;
  final TextEditingController costController;
  final VoidCallback? insertProduct;
  const CostFormField({
    super.key,
    required this.costFocusNode,
    required this.costController,
    required this.insertProduct,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTextFormField(
      onTap: () {
        if (costFocusNode.hasFocus) {
          return;
        }
        costController.selection = TextSelection(
          baseOffset: 0,
          extentOffset: costController.text.length,
        );
      },
      focusNode: costFocusNode,
      controller: costController,
      labelText: 'Custo'.hardcoded,
      hintText: 'Custo'.hardcoded,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: const TextInputType.numberWithOptions(
        decimal: true,
        //TODO test in iOS
      ),
      validator: FormValidators.compose([
        NonEmptyValidator(),
        NumberValidator(allowDecimal: true, maxDecimalHouses: 4),
      ]),
      maxLength: 13,
      onFieldSubmitted: (_) {
        insertProduct?.call();
      },
    );
  }
}
