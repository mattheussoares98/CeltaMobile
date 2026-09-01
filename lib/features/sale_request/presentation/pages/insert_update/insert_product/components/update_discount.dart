import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/validators/validators.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddDiscount extends ConsumerWidget {
  final FocusNode focusNode;
  final TextEditingController controller;
  final GlobalKey<FormState> formKey;
  final TextInputAction textInputAction;
  final void Function(String)? onFieldSubmitted;

  const AddDiscount({
    super.key,
    required this.focusNode,
    required this.controller,
    required this.formKey,
    this.textInputAction = TextInputAction.done,
    this.onFieldSubmitted,
  });

  Future<bool> _confirmRemoveAutomaticDiscounts(BuildContext context, WidgetRef ref) async {
    final product = ref.read(currentProductItemProvider);
    final uiProvider = insertProductUIControllerProvider(product);
    final hasNonManual = ref.read(uiProvider.notifier).hasNonManualDiscounts;

    if (!hasNonManual) return true;

    final proceed = await showAlertDialog(
      context: context,
      title: 'Atenção'.hardcoded,
      content:
          'Esta ação irá remover todos os descontos automáticos. Deseja continuar?'
              .hardcoded,
      cancelActionText: 'Não'.hardcoded,
      defaultActionText: 'Sim'.hardcoded,
    );

    return proceed == true;
  }

  void _updateDiscount(BuildContext context, WidgetRef ref, [String? value]) async {
    if (formKey.currentState!.validate() != true) return;

    final proceed = await _confirmRemoveAutomaticDiscounts(context, ref);
    if (!proceed) return;

    final product = ref.read(currentProductItemProvider);
    final uiProvider = insertProductUIControllerProvider(product);

    final type = ref.read(uiProvider.select((s) => s.discountType));

    ref
        .read(uiProvider.notifier)
        .updateDiscount(
          value: controller.text.toDouble() ?? 0,
          type: type,
        );
    if (context.mounted && onFieldSubmitted == null) {
      FocusScope.of(context).nextFocus();
    }
  }

  void _onTypeChanged(BuildContext context, WidgetRef ref, PercentageOrValue type) async {
    final proceed = await _confirmRemoveAutomaticDiscounts(context, ref);
    if (!proceed) return;

    final product = ref.read(currentProductItemProvider);
    ref
        .read(insertProductUIControllerProvider(product).notifier)
        .updateDiscountType(type);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final product = ref.watch(currentProductItemProvider);
    final uiProvider = insertProductUIControllerProvider(product);
    final uiState = ref.watch(uiProvider);
    final item = uiState.applyTo(product);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: context.theme.textTheme.titleSmall,
            children: [
              TextSpan(text: 'Descontos'.hardcoded),
              TextSpan(
                text:
                    ' (${item.totalDiscountValue.toString().toBrazilianNumber().addBrazilianCoin()}) ${item.discounts?.firstOrNull?.discountOrigin?.description ?? ''}',
                style: context.theme.textTheme.labelMedium?.copyWith(
                  color: context.theme.colorScheme.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 4,
              child: Form(
                key: formKey,
                child: Consumer(
                  builder: (_, ref, _) {
                    final discountType = ref.watch(
                      uiProvider.select((s) => s.discountType),
                    );

                    return BaseTextFormField(
                      focusNode: focusNode,
                      labelText: 'Desconto ${discountType.symbol}'.hardcoded,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      textInputAction: textInputAction,
                      controller: controller,
                      onFieldSubmitted: (v) {
                        _updateDiscount(context, ref, v);
                        onFieldSubmitted?.call(v);
                      },
                      onChanged: (_) => _updateDiscount(context, ref),
                      validator: FormValidators.compose([
                        NumberValidator(
                          allowDecimal: true,
                          allowEmptyValue: true,
                          needsBeGreaterThanZero: false,
                        ),
                      ]),
                    );
                  },
                ),
              ),
            ),
            gapW8,
            Expanded(
              flex: 6,
              child: Consumer(
                builder: (_, ref, _) {
                  final discountType = ref.watch(
                    uiProvider.select((s) => s.discountType),
                  );

                  return ExcludeFocus(
                    child: BaseSegmentedButtons<PercentageOrValue>(
                      items: PercentageOrValue.values,
                      selectedValue: discountType,
                      itemLabelBuilder: (item) => item.name,
                      onChanged: (type) => _onTypeChanged(context, ref, type),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
