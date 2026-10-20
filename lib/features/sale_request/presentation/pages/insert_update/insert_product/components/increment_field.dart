import 'package:celta_inventario/features/sale_request/presentation/localization/localization.dart';
import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/validators/validators.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IncrementField extends ConsumerWidget {
  final FocusNode focusNode;
  final TextEditingController controller;
  final TextInputAction textInputAction;
  final void Function(String)? onFieldSubmitted;

  const IncrementField({
    super.key,
    required this.focusNode,
    required this.controller,
    this.textInputAction = TextInputAction.next,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              TextSpan(text: context.l10n.surcharge),
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
              child: BaseTextFormField(
                focusNode: focusNode,
                controller: controller,
                labelText: context.l10n.valueWithSymbol(incrementType.symbol),
                hintText: incrementType.symbol,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                onFieldSubmitted: onFieldSubmitted,
                textInputAction: textInputAction,
                onChanged: (value) {
                  ref
                      .read(uiProvider.notifier)
                      .updateIncrementValue(double.tryParse(value) ?? 0);
                },
                validator: FormValidators.compose([
                  NumberValidator(
                    translations: context.l10n,
                    allowDecimal: true,
                    allowEmptyValue: true,
                  ),
                ]),
              ),
            ),
            gapW8,
            Expanded(
              flex: 6,
              child: ExcludeFocus(
                child: BaseSegmentedButtons<PercentageOrValue>(
                  items: PercentageOrValue.values,
                  selectedValue: incrementType,
                  itemLabelBuilder: (item) =>
                      context.l10n.percentageOrValueName(item),
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
