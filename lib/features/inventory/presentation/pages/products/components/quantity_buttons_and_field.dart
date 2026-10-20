import 'package:celta_inventario/utils/utils.dart';
import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/validators/validators.dart';
import 'package:celta_inventario/features/inventory/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuantityButtonsAndField extends ConsumerWidget {
  final FocusNode quantityFocusNode;
  final TextEditingController quantityController;
  final int codigoInternoInvCont;
  final int codigoInternoProEmb;
  final int enterpriseCode;
  final int codigoInternoInventario;
  final void Function(bool isSubtract) entryQuantity;
  const QuantityButtonsAndField({
    super.key,
    required this.quantityFocusNode,
    required this.quantityController,
    required this.codigoInternoInvCont,
    required this.codigoInternoProEmb,
    required this.enterpriseCode,
    required this.codigoInternoInventario,
    required this.entryQuantity,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(Sizes.p8),
      child: Column(
        children: [
          Consumer(
            builder: (_, ref, _) {
              final insertIndividually = ref.watch(
                uiStateControllerProvider(
                  codigoInternoInventario,
                ).select((s) => s.insertIndividually),
              );

              return Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: PrimaryButton(
                      text:
                          '${'Subtrair'.toUpperCase().hardcoded}${insertIndividually ? " 1" : ""}',
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
                          '${'Somar'.toUpperCase().hardcoded}${insertIndividually ? " 1" : ""}',
                      onPressed: () {
                        entryQuantity(false);
                      },
                    ),
                  ),
                ],
              );
            },
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
              Consumer(
                builder: (_, ref, _) {
                  final insertIndividually = ref.watch(
                    uiStateControllerProvider(
                      codigoInternoInventario,
                    ).select((s) => s.insertIndividually),
                  );

                  if (insertIndividually) {
                    return const Expanded(flex: 2, child: SizedBox.shrink());
                  }

                  return Expanded(
                    flex: 2,
                    child: BaseTextFormField(
                      focusNode: quantityFocusNode,
                      controller: quantityController,
                      labelText: 'Quantidade'.hardcoded,
                      hintText: 'Quantidade'.hardcoded,
                      onTap: () {
                        if (quantityFocusNode.hasFocus) return;
                        quantityController.selection = TextSelection(
                          baseOffset: 0,
                          extentOffset: quantityController.text.length,
                        );
                      },
                      validator: FormValidators.compose([
                        NonEmptyValidator(translations: context.l10n),
                        NumberValidator(
                          translations: context.l10n,
                          allowDecimal: true,
                          maxDecimalHouses: 3,
                        ),
                      ]),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      maxLength: 10,
                      onFieldSubmitted: (_) => entryQuantity(false),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
