import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../core/validators/validators.dart';
import '../../../../../../../localization/string_hardcoded.dart';
import '../../../../../../../utils/utils.dart';
import '../../../../controllers/controllers.dart';

class PriceField extends ConsumerStatefulWidget {
  final bool allowPriceChange;

  const PriceField({
    super.key,
    required this.allowPriceChange,
  });

  @override
  ConsumerState<PriceField> createState() => _PriceFieldState();
}

class _PriceFieldState extends ConsumerState<PriceField> {
  final _valueController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        final product = ref.read(currentProductItemProvider);
        _valueController.text =
            (product.value ?? 0).toString().toBrazilianNumber(2);
      }
    });
  }

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final product = ref.watch(currentProductItemProvider);
    final uiProvider = insertProductUIControllerProvider(product);

    return DefaultTextFormField(
      controller: _valueController,
      labelText: 'Preço R\$'.hardcoded,
      //TODO show if is sale retail, whole or manual price
      enabled: widget.allowPriceChange,
      onChanged: (value) {
        ref
            .read(uiProvider.notifier)
            .updatePrice(double.tryParse(value) ?? 0);
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
