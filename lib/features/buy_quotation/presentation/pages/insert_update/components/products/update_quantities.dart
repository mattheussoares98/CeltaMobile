import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../constants/constants.dart';
import '../../../../../../../core/validators/validators.dart';
import '../../../../../../../localization/string_hardcoded.dart';
import '../../../../../../../utils/utils.dart';
import '../../../../../../enterprises/presentation/controllers/controllers.dart';
import '../../../../../domain/entities/entities.dart';
import '../../../../controllers/controller.dart';
import '../../../../models/models.dart';

class UpdateQuantities extends ConsumerStatefulWidget {
  final List<EnterpriseUIController> uiControllers;
  final BuyQuotationProductsEntity product;
  final int enterpriseCode;
  final int buyQuotationCode;
  const UpdateQuantities({
    super.key,
    required this.uiControllers,
    required this.product,
    required this.enterpriseCode,
    required this.buyQuotationCode,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UpdateQuantitiesState();
}

class _UpdateQuantitiesState extends ConsumerState<UpdateQuantities> {
  final formKey = GlobalKey<FormState>();
  void confirmQuantities() async {
    if (formKey.currentState?.validate() != true) {
      return;
    }
    final buyQuotationProducts = await ref.read(
      completeBuyQuotationsStateControllerProvider(
        widget.enterpriseCode,
        widget.buyQuotationCode.toString(),
      ).selectAsync((s) => s.Products),
    );

    final currentProducts = [...?buyQuotationProducts];
    int index = currentProducts.indexWhere(
      (e) =>
          e.Product?.ProductPackingCode ==
          widget.product.Product?.ProductPackingCode,
    );
    if (index == -1) {
      showAlertDialog(
        context: context,
        title: 'Erro'.hardcoded,
        content:
            'Esse erro jamais deveria ocorrer. Entre em contato com o suporte técnico'
                .hardcoded,
      );
      return;
    }

    final oldProduct = currentProducts[index];

    final newProduct = oldProduct.copyWith(
      Code: oldProduct.Code,
      Product: oldProduct.Product,
      ProductEnterprises: oldProduct.ProductEnterprises?.map((e) {
        return BuyQuotationProductEnterpriseEntity(
          Code: oldProduct.ProductEnterprises?.firstWhereOrNull(
            (y) => y.EnterpriseCode == e.EnterpriseCode,
          )?.Code,
          EnterpriseCode: e.EnterpriseCode,
          Quantity:
              widget.uiControllers
                  .firstWhere((x) => x.enterpriseCode == e.EnterpriseCode)
                  .controller
                  .text
                  .toDouble() ??
              0,
        );
      }).toList(),
    );

    currentProducts[index] = newProduct;
    ref
        .read(
          completeBuyQuotationsStateControllerProvider(
            widget.enterpriseCode,
            widget.buyQuotationCode.toString(),
          ).notifier,
        )
        .updateValues(Products: currentProducts);
    ref
        .read(selectedProductPackingCodeStateControllerProvider.notifier)
        .updateProductPackingCode(null);
  }

  @override
  Widget build(BuildContext context) {
    final enterprises = ref.watch(enterprisesStateControllerProvider()).value;
    final buyQuotationEnterprises = ref.watch(
      completeBuyQuotationsStateControllerProvider(
        widget.enterpriseCode,
        widget.buyQuotationCode.toString(),
      ).select((s) => s.value?.Enterprises),
    );

    final theme = Theme.of(context);

    final selectedEnterpriseCodes =
        buyQuotationEnterprises
            ?.where((e) => e.isSelected == true)
            .toSet()
            .toList() ??
        [];

    final selectedUIControllers = [...widget.uiControllers];
    selectedUIControllers.removeWhere(
      (e) => !selectedEnterpriseCodes.any(
        (x) => x.enterprise.Code == e.enterpriseCode,
      ),
    );

    return Form(
      key: formKey,
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                for (var x = 0; x < selectedUIControllers.length; x++)
                  Builder(
                    builder: (context) {
                      final controller = selectedUIControllers[x];
                      final correspondentEnterprise = enterprises?.firstWhere(
                        (x) => controller.enterpriseCode == x.Code,
                      );
                      return Padding(
                        padding: const EdgeInsets.only(bottom: Sizes.p8),
                        child: DefaultTextFormField(
                          maxLength: 10,
                          controller: controller.controller,
                          focusNode: controller.focusNode,
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () {
                            if (x == selectedUIControllers.length - 1) {
                              confirmQuantities();
                            } else {
                              Future.delayed(
                                const Duration(milliseconds: 100),
                                () {
                                  selectedUIControllers[x + 1].focusNode
                                      .requestFocus();
                                  selectedUIControllers[x + 1]
                                      .controller
                                      .selection = TextSelection(
                                    baseOffset: 0,
                                    extentOffset: selectedUIControllers[x + 1]
                                        .controller
                                        .text
                                        .length,
                                  );
                                },
                              );
                            }
                          },
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onTap: () {
                            if (!controller.focusNode.hasFocus) {
                              controller.controller.selection = TextSelection(
                                baseOffset: 0,
                                extentOffset: controller.controller.text.length,
                              );
                            }
                          },
                          labelText:
                              '(${correspondentEnterprise?.PersonalizedCode}) ${correspondentEnterprise?.name}'
                                  .hardcoded,
                          hintText: 'Quantidade'.hardcoded,
                          validator: FormValidators.compose([
                            NumberValidator(
                              allowDecimal: true,
                              allowEmptyValue: true,
                              maxDecimalHouses: 3,
                              needsBeGreaterThanZero: false,
                            ),
                          ]),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
          gapW8,
          PrimaryButton(
            text: 'Confirmar'.hardcoded,
            backgroundColor: theme.primaryColor,
            onPressed: confirmQuantities,
          ),
        ],
      ),
    );
  }
}
