import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../constants/constants.dart';
import '../../../../../../../core/validators/validators.dart';
import '../../../../../../../localization/string_hardcoded.dart';
import '../../../../../../../utils/utils.dart';
import '../../../../../domain/entities/entities.dart';
import '../../../../controllers/controllers.dart';

class AddDiscount extends ConsumerStatefulWidget {
  final BSFProductItemEntity product;

  const AddDiscount({super.key, required this.product});

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

    final type = ref.read(
      insertProductUIControllerProvider(
        widget.product,
      ).select((s) => s.discountType),
    );

    final newDiscount = BSFDiscountEntity(
      order:
          (ref
              .read(insertProductUIControllerProvider(widget.product))
              .discounts
              .length) +
          1,
      discountOrigin: null,
      user: null,
      justification: null,
      discount: BSFValueTypeEntity(
        type: type,
        value: _valueController.text.toDouble() ?? 0,
      ),
    );
    ref
        .read(insertProductUIControllerProvider(widget.product).notifier)
        .addDiscount(newDiscount);
    _valueController.clear();
  }

  void _onTypeChanged(PercentageOrValue type) {
    ref
        .read(insertProductUIControllerProvider(widget.product).notifier)
        .updateDiscountType(type);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Descontos'.hardcoded,
          style: Theme.of(context).textTheme.titleSmall,
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
                      insertProductUIControllerProvider(
                        widget.product,
                      ).select((s) => s.discountType),
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
                    insertProductUIControllerProvider(
                      widget.product,
                    ).select((s) => s.discountType),
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
