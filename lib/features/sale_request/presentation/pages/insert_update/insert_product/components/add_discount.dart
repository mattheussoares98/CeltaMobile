import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/validators/validators.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddDiscount extends ConsumerStatefulWidget {
  const AddDiscount({super.key});

  @override
  ConsumerState<AddDiscount> createState() => _DiscountsSectionState();
}

class _DiscountsSectionState extends ConsumerState<AddDiscount> {
  final formKey = GlobalKey<FormState>();
  final _valueController = TextEditingController();

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }

  void _addDiscount() {
    if (formKey.currentState!.validate() != true) return;

    final product = ref.read(currentProductItemProvider);
    final uiProvider = insertProductUIControllerProvider(product);

    final type = ref.read(uiProvider.select((s) => s.discountType));

    final newDiscount = BSFDiscountEntity(
      order: (ref.read(uiProvider).discounts.length) + 1,
      discountOrigin: DiscountOrigin.manual,
      user: null,
      justification: null,
      discount: BSFValueTypeEntity(
        type: type,
        value: _valueController.text.toDouble() ?? 0,
      ),
    );
    final success = ref.read(uiProvider.notifier).addDiscount(newDiscount);

    if (!success) {
      if (!mounted) return;
      showSnackBarMessage(
        context,
        'Limite de 10 descontos atingido'.hardcoded,
        backgroundColor: Colors.red,
      );
      return;
    }
    _valueController.clear();
  }

  void _onTypeChanged(PercentageOrValue type) {
    final product = ref.read(currentProductItemProvider);
    ref
        .read(insertProductUIControllerProvider(product).notifier)
        .updateDiscountType(type);
  }

  @override
  Widget build(BuildContext context) {
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
                    ' (${item.totalDiscountValue.toString().toBrazilianNumber().addBrazilianCoin()})',
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

                    return DefaultTextFormField(
                      labelText: 'Desconto ${discountType.symbol}'.hardcoded,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      textInputAction:
                          discountType == PercentageOrValue.percentage
                          ? TextInputAction.continueAction
                          : TextInputAction.next,
                      controller: _valueController,
                      onFieldSubmitted: (_) => _addDiscount(),
                      suffixIcon: ExcludeFocus(
                        child: IconButton(
                          onPressed: _addDiscount,
                          icon: const PlatformIcon(
                            materialIcon: Icons.add,
                            cupertinoIcon: CupertinoIcons.add,
                          ),
                        ),
                      ),
                      validator: FormValidators.compose([
                        NonEmptyValidator(),
                        NumberValidator(
                          allowDecimal: true,
                          maxDecimalHouses: 2,
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
                    child: DefaultSegmentedButtons<PercentageOrValue>(
                      items: PercentageOrValue.values,
                      selectedValue: discountType,
                      onChanged: _onTypeChanged,
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
