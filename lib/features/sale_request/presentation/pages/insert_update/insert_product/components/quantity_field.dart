import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../core/validators/validators.dart';
import '../../../../../../../localization/string_hardcoded.dart';
import '../../../../../../../utils/utils.dart';
import '../../../../controllers/controllers.dart';

class QuantityField extends ConsumerStatefulWidget {
  const QuantityField({super.key});

  @override
  ConsumerState<QuantityField> createState() => _QuantityFieldState();
}

class _QuantityFieldState extends ConsumerState<QuantityField> {
  final _quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        final product = ref.read(currentProductItemProvider);
        _quantityController.text = (product.quantity ?? 1)
            .toString()
            .toBrazilianNumber(3, true);
      }
    });
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final product = ref.watch(currentProductItemProvider);
    return DefaultTextFormField(
      controller: _quantityController,
      labelText: 'Quantidade'.hardcoded,
      onChanged: (value) {
        ref
            .read(insertProductUIControllerProvider(product).notifier)
            .updateQuantity(value.toDouble() ?? 1);
      },
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      textInputAction: TextInputAction.next,
      validator: FormValidators.compose([
        NonEmptyValidator(),
        NumberValidator(allowDecimal: true, maxDecimalHouses: 3),
      ]),
    );
  }
}
