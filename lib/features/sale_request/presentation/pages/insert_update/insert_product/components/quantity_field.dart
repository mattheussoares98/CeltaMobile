import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/validators/validators.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuantityField extends ConsumerWidget {
  final FocusNode focusNode;
  final TextEditingController controller;
  final TextInputAction textInputAction;
  final void Function(String)? onFieldSubmitted;

  const QuantityField({
    super.key,
    required this.focusNode,
    required this.controller,
    this.textInputAction = TextInputAction.next,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final product = ref.watch(currentProductItemProvider);
    return BaseTextFormField(
      focusNode: focusNode,
      controller: controller,
      labelText: 'Quantidade'.hardcoded,
      onChanged: (value) {
        ref
            .read(insertProductUIControllerProvider(product).notifier)
            .updateQuantity(value.toDouble() ?? 1);
      },
      onFieldSubmitted: onFieldSubmitted,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      textInputAction: textInputAction,
      validator: FormValidators.compose([
        const NonEmptyValidator(),
        NumberValidator(allowDecimal: true, maxDecimalHouses: 3),
      ]),
    );
  }
}
