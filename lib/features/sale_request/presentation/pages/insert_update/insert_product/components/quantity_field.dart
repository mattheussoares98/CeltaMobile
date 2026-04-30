import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../core/validators/validators.dart';
import '../../../../../../../localization/string_hardcoded.dart';
import '../../../../../../../utils/utils.dart';
import '../../../../../domain/entities/entities.dart';
import '../../../../controllers/controllers.dart';

class QuantityField extends ConsumerStatefulWidget {
  final BSFProductItemEntity product;

  const QuantityField({
    super.key,
    required this.product,
  });

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
        _quantityController.text = (widget.product.quantity ?? 1)
            .toString()
            .toBrazilianNumber(3, true);
      }

      ref
          .read(insertProductUIControllerProvider(widget.product).notifier)
          .updateQuantity(_quantityController.text.toDouble() ?? 1);
    });
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextFormField(
      controller: _quantityController,
      labelText: 'Quantidade'.hardcoded,
      onChanged: (value) {
        ref
            .read(insertProductUIControllerProvider(widget.product).notifier)
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
