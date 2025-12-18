import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../core/validators/validators.dart';
import '../../../../../../localization/string_hardcoded.dart';
import '../../../../domain/entities/entities.dart';

class UpdateQuantityField extends StatelessWidget {
  final int? selectedIndex;
  final int index;
  final GlobalKey<FormState> formKey;
  final TextEditingController quantityController;
  final FocusNode quantityFocusNode;
  final ProductLotInfoEntity item;
  final void Function(int index, ProductLotInfoEntity item) onSubmit;
  const UpdateQuantityField({
    super.key,
    required this.selectedIndex,
    required this.index,
    required this.formKey,
    required this.quantityController,
    required this.quantityFocusNode,
    required this.item,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

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
                        flex: 2,
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
                              onSubmit(index, item);
                            },
                            suffixIcon: mediaQuery.size.width > 300
                                ? IconButton(
                                    icon: Icon(
                                      isIOS
                                          ? CupertinoIcons.checkmark
                                          : Icons.check,
                                    ),
                                    onPressed: () => onSubmit(index, item),
                                  )
                                : null,
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
                          onPressed: () => onSubmit(index, item),
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
