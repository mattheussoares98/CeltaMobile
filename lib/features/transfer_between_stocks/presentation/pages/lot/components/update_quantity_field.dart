import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/validators/validators.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/features/transfer_between_stocks/domain/entities/entities.dart';
import 'package:celta_inventario/features/transfer_between_stocks/presentation/controllers/controllers.dart';

class UpdateQuantityField extends ConsumerWidget {
  final int index;
  final GlobalKey<FormState> formKey;
  final TextEditingController quantityController;
  final FocusNode quantityFocusNode;
  final ProductLotInfoEntity item;
  final VoidCallback onSubmit;
  const UpdateQuantityField({
    super.key,
    required this.index,
    required this.formKey,
    required this.quantityController,
    required this.quantityFocusNode,
    required this.item,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final selectedIndex = ref.watch(selectedLotIndexStateControllerProvider);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: selectedIndex != index
              ? const SizedBox()
              : Padding(
                  padding: const EdgeInsets.fromLTRB(
                    Sizes.p8,
                    0,
                    Sizes.p8,
                    Sizes.p8,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Form(
                          key: formKey,
                          child: DefaultTextFormField(
                            controller: quantityController,
                            focusNode: quantityFocusNode,
                            maxLength: 10,
                            hintText: 'Nova qtd'.hardcoded,
                            labelText: 'Nova qtd'.hardcoded,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            onFieldSubmitted: (_) {
                              onSubmit();
                            },
                            validator: FormValidators.compose([
                              NonEmptyValidator(),
                              NumberValidator(
                                allowDecimal: true,
                                maxDecimalHouses: 3,
                              ),
                            ]),
                          ),
                        ),
                      ),
                      gapW8,
                      Expanded(
                        child: PrimaryButton(
                          text: 'Alterar'.hardcoded,
                          onPressed: onSubmit,
                          icon: const PlatformIcon(
                            cupertinoIcon: CupertinoIcons.check_mark,
                            materialIcon: Icons.save,
                          ),
                          iconAlignment: IconAlignment.end,
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }
}
