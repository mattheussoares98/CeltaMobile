import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../constants/constants.dart';
import '../../../../../../../core/domain/entities/entities.dart';
import '../../../../../../../localization/string_hardcoded.dart';
import '../../../../../../../utils/utils.dart';
import '../../../../../domain/entities/entities.dart';
import '../../../../controllers/controller.dart';

class UpdateQuantities extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    void confirmQuantities() {
      final currentProducts = [...?buyQuotation.Products];
      int index = currentProducts.indexWhere(
        (e) =>
            e.Product?.ProductPackingCode ==
            product.Product?.ProductPackingCode,
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

      final selectedEnterpriseCodes =
          buyQuotation.Enterprises?.where(
            (e) => e.isSelected == true,
          ).map((e) => e.enterprise.Code).toSet() ??
          {};

      final oldProduct = currentProducts[index];
      final newProduct = oldProduct.copyWith(
        Code: oldProduct.Code,
        Product: oldProduct.Product,
        ProductEnterprises: selectedEnterpriseCodes.map((x) {
          return BuyQuotationProductEnterpriseEntity(
            Code: oldProduct.ProductEnterprises?.firstWhereOrNull(
              (y) => y.EnterpriseCode == x,
            )!.Code,
            EnterpriseCode: x,
            Quantity: quantityControllers[x.toString()]!.text.toDouble() ?? 0,
          );
        }).toList(),
      );

      currentProducts[index] = newProduct;
      ref
          .read(
            completeBuyQuotationsStateControllerProvider(
              enterpriseCode,
              code.toString(),
            ).notifier,
          )
          .updateValues(Products: currentProducts);
      updateIndex(null);
    }

    return Column(
      children: [
        ...quantityControllers.entries
            .where(
              (e) =>
                  buyQuotation.Enterprises?.any(
                    (y) => y.enterprise.Code.toString() == e.key,
                  ) ==
                  true,
            )
            .map((entry) {
              final correspondentEnterprise = enterprises.firstWhere(
                (x) => entry.key == x.Code.toString(),
              );
              return DefaultTextFormField(
                //TODO test in a real device if change the focus correctly and create different files to reduce the file size
                controller: entry.value,
                keyboardType: TextInputType.number,
                labelText:
                    '(${correspondentEnterprise.PersonalizedCode}) ${correspondentEnterprise.name}'
                        .hardcoded,
                hintText: 'Quantidade'.hardcoded,
              );
            }),
        gapH8,
        Row(
          children: [
            Expanded(
              flex: 4,
              child: PrimaryButton(
                text: 'Cancelar'.hardcoded,
                backgroundColor: Colors.red,
                onPressed: () => updateIndex(null),
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
    );
  }
}
