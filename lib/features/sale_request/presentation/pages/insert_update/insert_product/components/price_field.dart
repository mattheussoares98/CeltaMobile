import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/validators/validators.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/localization.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PriceField extends ConsumerWidget {
  final bool allowPriceChange;
  final FocusNode focusNode;
  final TextEditingController controller;
  final TextInputAction textInputAction;
  final void Function(String)? onFieldSubmitted;

  const PriceField({
    super.key,
    required this.allowPriceChange,
    required this.focusNode,
    required this.controller,
    this.textInputAction = TextInputAction.next,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final product = ref.watch(currentProductItemProvider);
    final uiProvider = insertProductUIControllerProvider(product);

    final currentProduct = ref.watch(
      uiProvider.select((s) => s.applyTo(product)),
    );
    final practicedPriceType = currentProduct.practicedPriceType;

    return BaseTextFormField(
      controller: controller,
      focusNode: focusNode,
      onFieldSubmitted: onFieldSubmitted,
      labelText: context.l10n.priceWithTypeAbbreviation(
        context.l10n.priceTypeName(practicedPriceType),
      ),
      enabled: allowPriceChange,
      onChanged: (value) {
        ref.read(uiProvider.notifier).updatePrice(value.toDouble() ?? 0);
      },
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      textInputAction: textInputAction,
      validator: FormValidators.compose([
        NonEmptyValidator(translations: context.l10n),
        NumberValidator(
          translations: context.l10n,
          allowDecimal: true,
          maxDecimalHouses: 3,
        ),
      ]),
    );
  }
}
