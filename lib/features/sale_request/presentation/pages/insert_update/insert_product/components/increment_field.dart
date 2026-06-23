import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/validators/validators.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IncrementField extends ConsumerStatefulWidget {
  const IncrementField({super.key});

  @override
  ConsumerState<IncrementField> createState() => _IncrementFieldState();
}

class _IncrementFieldState extends ConsumerState<IncrementField> {
  final _incrementValueController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final product = ref.read(currentProductItemProvider);
      final incrementValue = product.increment?.value ?? 0;

      if (incrementValue <= 0) return;
      _incrementValueController.text = incrementValue
          .toString()
          .toBrazilianNumber();
    });
  }

  @override
  void dispose() {
    _incrementValueController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final product = ref.watch(currentProductItemProvider);
    final uiProvider = insertProductUIControllerProvider(product);

    final uiState = ref.watch(uiProvider);
    final item = uiState.applyTo(product);

    final incrementType = uiState.incrementType;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: context.theme.textTheme.titleSmall,
            children: [
              TextSpan(text: 'Acréscimo'.hardcoded),
              TextSpan(
                text:
                    ' (${item.totalIncrement.toString().toBrazilianNumber().addBrazilianCoin()})',
                style: context.theme.textTheme.labelMedium?.copyWith(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        gapH4,
        Row(
          children: [
            Expanded(
              flex: 4,
              child: DefaultTextFormField(
                focusNode: _focusNode,
                controller: _incrementValueController,
                labelText: 'Valor ${incrementType.symbol}'.hardcoded,
                hintText: incrementType.symbol,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                onFieldSubmitted: (_) =>
                    FocusManager.instance.primaryFocus?.nextFocus(),
                textInputAction: TextInputAction.next,
                onChanged: (value) {
                  ref
                      .read(uiProvider.notifier)
                      .updateIncrementValue(double.tryParse(value) ?? 0);
                },
                validator: FormValidators.compose([
                  NumberValidator(allowDecimal: true, allowEmptyValue: true),
                ]),
              ),
            ),
            gapW8,
            Expanded(
              flex: 6,
              child: ExcludeFocus(
                child: DefaultSegmentedButtons(
                  items: PercentageOrValue.values,
                  selectedValue: incrementType,
                  onChanged: (value) =>
                      ref.read(uiProvider.notifier).updateIncrementType(value),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
