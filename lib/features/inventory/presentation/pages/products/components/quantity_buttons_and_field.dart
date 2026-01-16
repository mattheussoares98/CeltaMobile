import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../core/validators/validators.dart';
import '../../../controllers/controllers.dart';

class QuantityButtonsAndField extends ConsumerWidget {
  final ValueNotifier<bool> insertIndividually;
  final FocusNode quantityFocusNode;
  final TextEditingController quantityController;
  final int codigoInternoInvCont;
  final int codigoInternoProEmb;
  final int enterpriseCode;
  final int codigoInternoInventario;
  final void Function(bool isSubtract) entryQuantity;
  final GlobalKey<FormState> formKey;
  const QuantityButtonsAndField({
    super.key,
    required this.insertIndividually,
    required this.quantityFocusNode,
    required this.quantityController,
    required this.codigoInternoInvCont,
    required this.codigoInternoProEmb,
    required this.enterpriseCode,
    required this.codigoInternoInventario,
    required this.entryQuantity,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ValueListenableBuilder<bool>(
      valueListenable: insertIndividually,
      builder: (_, isInsertIndividually, _) {
        return Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(Sizes.p8),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: PrimaryButton(
                        text:
                            '${'Subtrair'.toUpperCase().hardcoded}${isInsertIndividually ? " 1" : ""}',
                        onPressed: () {
                          entryQuantity(true);
                        },
                      ),
                    ),
                    gapW8,
                    Expanded(
                      flex: 6,
                      child: PrimaryButton(
                        text:
                            '${'Somar'.toUpperCase().hardcoded}${isInsertIndividually ? " 1" : ""}',
                        onPressed: () {
                          entryQuantity(false);
                        },
                      ),
                    ),
                  ],
                ),
                gapH8,
                Row(
                  children: [
                    Expanded(
                      child: PrimaryButton(
                        text: 'Anular'.toUpperCase().hardcoded,
                        backgroundColor: Colors.red,
                        onPressed: () async {
                          final pressed = await showAlertDialog(
                            context: context,
                            title: 'Anular'.hardcoded,
                            content:
                                'Tem certeza que deseja anular a contagem desse produto?'
                                    .hardcoded,
                            defaultActionText: 'Sim'.hardcoded,
                            cancelActionText: 'Não'.hardcoded,
                          );

                          if (pressed == true) {
                            ref
                                .read(
                                  entryQuantityStateControllerProvider(
                                    codigoInternoInvCont,
                                  ).notifier,
                                )
                                .annul(
                                  codigoInternoProEmb,
                                  enterpriseCode,
                                  codigoInternoInventario,
                                );
                          }
                        },
                      ),
                    ),
                    gapW8,
                    if (!isInsertIndividually)
                      Expanded(
                        flex: 2,
                        child: DefaultTextFormField(
                          focusNode: quantityFocusNode,
                          controller: quantityController,
                          labelText: 'Quantidade'.hardcoded,
                          hintText: 'Quantidade'.hardcoded,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: FormValidators.compose([
                            NonEmptyValidator(),
                            NumberValidator(allowDecimal: true),
                          ]),
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          maxLength: 10,
                          onFieldSubmitted: (_) {
                            entryQuantity(false);
                          },
                        ),
                      )
                    else
                      const Expanded(flex: 2, child: SizedBox.shrink()),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
