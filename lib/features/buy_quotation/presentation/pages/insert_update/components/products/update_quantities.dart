import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../constants/constants.dart';
import '../../../../../../../core/domain/entities/entities.dart';
import '../../../../../../../core/validators/validators.dart';
import '../../../../../../../localization/string_hardcoded.dart';
import '../../../../../../../utils/utils.dart';
import '../../../../../domain/entities/entities.dart';
import '../../../../controllers/controller.dart';

class UpdateQuantities extends ConsumerStatefulWidget {
  final Map<String, TextEditingController> quantityControllers;
  final BuyQuotationEntity buyQuotation;
  final List<EnterpriseEntity> enterprises;
  final void Function(int? index) updateIndex;
  final BuyQuotationProductsEntity product;
  final int enterpriseCode;
  final int code;
  const UpdateQuantities({
    super.key,
    required this.quantityControllers,
    required this.buyQuotation,
    required this.enterprises,
    required this.updateIndex,
    required this.product,
    required this.enterpriseCode,
    required this.code,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UpdateQuantitiesState();
}

class _UpdateQuantitiesState extends ConsumerState<UpdateQuantities> {
  final formKey = GlobalKey<FormState>();
  void confirmQuantities() {
    if (formKey.currentState?.validate() != true) {
      return;
    }

    final currentProducts = [...?widget.buyQuotation.Products];
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
              widget.quantityControllers[e.EnterpriseCode.toString()]!.text
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
            widget.code.toString(),
          ).notifier,
        )
        .updateValues(Products: currentProducts);
    widget.updateIndex(null);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final controllers = widget.quantityControllers.entries.where(
      (e) =>
          widget.buyQuotation.Enterprises?.any(
            (y) =>
                y.enterprise.Code.toString() == e.key && y.isSelected == true,
          ) ==
          true,
    );

    return Form(
      key: formKey,
      child: Column(
        children: [
          for (var x = 0; x < controllers.length; x++)
            Builder(
              builder: (context) {
                final controller = controllers.elementAt(x);
                final correspondentEnterprise = widget.enterprises.firstWhere(
                  (x) => controller.key == x.Code.toString(),
                );
                return Padding(
                  padding: const EdgeInsets.only(bottom: Sizes.p8),
                  child: DefaultTextFormField(
                    //TODO test in a real device if change the focus correctly and create different files to reduce the file size
                    controller: controller.value,
                    keyboardType: TextInputType.number,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    labelText:
                        '(${correspondentEnterprise.PersonalizedCode}) ${correspondentEnterprise.name}'
                            .hardcoded,
                    hintText: 'Quantidade'.hardcoded,
                    onFieldSubmitted: (_) {
                      if (x == controllers.length - 1) {
                        confirmQuantities();
                      }
                    },
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
          gapH8,
          Row(
            children: [
              Expanded(
                flex: 4,
                child: PrimaryButton(
                  text: 'Cancelar'.hardcoded,
                  backgroundColor: Colors.red,
                  onPressed: () => widget.updateIndex(null),
                ),
              ),
              gapW8,
              Expanded(
                flex: 6,
                child: PrimaryButton(
                  text: 'Confirmar'.hardcoded,
                  backgroundColor: theme.primaryColor,
                  onPressed: confirmQuantities,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
