import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../core/validators/validators.dart';
import '../../../../../../../localization/string_hardcoded.dart';
import '../../../../../../../utils/utils.dart';
import '../../../../../domain/entities/entities.dart';
import '../../../../controllers/controllers.dart';

class PriceField extends ConsumerStatefulWidget {
  final bool allowPriceChange;
  final FocusNode focusNode;
  final BSFProductItemEntity product;

  const PriceField({
    super.key,
    required this.allowPriceChange,
    required this.focusNode,
    required this.product,
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
        ref
            .read(insertProductUIControllerProvider(widget.product).notifier)
            .updatePrice(_valueController.text.toDouble() ?? 0);
        _valueController.text = (widget.product.value ?? 0)
            .toString()
            .toBrazilianNumber(2);
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
    return DefaultTextFormField(
      controller: _valueController,
      focusNode: widget.focusNode,
      labelText: 'Preço R\$'.hardcoded,
      //TODO show if is sale retail, whole or manual price
      enabled: widget.allowPriceChange,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      textInputAction: TextInputAction.next,
      validator: FormValidators.compose([
        NonEmptyValidator(),
        NumberValidator(allowDecimal: true, maxDecimalHouses: 3),
      ]),
    );
  }
}
