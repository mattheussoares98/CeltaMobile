import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../../../../localization/string_hardcoded.dart';
import '../../../../../../utils/utils.dart';
import '../../../../../enterprises/presentation/controllers/controllers.dart';
import '../../../../domain/entities/entities.dart';
import '../../../controllers/controller.dart';

class ProductsItems extends ConsumerWidget {
  final BuyQuotationEntity buyQuotation;
  final Map<String, TextEditingController> quantityControllers;
  final int enterpriseCode;
  final int code;
  const ProductsItems({
    super.key,
    required this.buyQuotation,
    required this.quantityControllers,
    required this.enterpriseCode,
    required this.code,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enterprises = ref.watch(enterprisesStateControllerProvider());
    final theme = Theme.of(context);
    final selectedIndex = ref.watch(
      selectedProductIndexStateControllerProvider,
    );

    void updateIndex(int? index) {
      final newIndex = (index == selectedIndex) ? null : index;

      ref
          .read(selectedProductIndexStateControllerProvider.notifier)
          .updateIndex(newIndex);

      if (newIndex != null) {
        final product = buyQuotation.Products?[newIndex];
        if (product == null) return;

        for (final entry in quantityControllers.entries) {
          final enterpriseCodeKey =
              entry.key; // String Code of the enterprise (e.g., '123')
          final controller = entry.value;

          if (buyQuotation.Enterprises?.any(
                (e) => e.enterprise.Code.toString() == enterpriseCodeKey,
              ) ==
              false) {
            controller.text = '0';
            continue;
          }

          final quantityEntity = product.ProductEnterprises?.firstWhereOrNull(
            (e) => e.EnterpriseCode.toString() == enterpriseCodeKey,
          );

          final quantity = quantityEntity?.Quantity;
          controller.text = quantity.toString().toBrazilianNumber().replaceAll(
            RegExp(r'\.'),
            '',
          );
        }
      }
    }

    return SliverList.builder(
      itemCount: buyQuotation.Products?.length ?? 0,
      itemBuilder: (_, index) {
        final product = buyQuotation.Products![index];

        final productEnterprises = buyQuotation.Enterprises?.map((e) {
          final productEnterprise =
              product.ProductEnterprises?.firstWhereOrNull(
                (x) => x.EnterpriseCode == e.enterprise.Code,
              );

          return productEnterprise ??
              BuyQuotationProductEnterpriseEntity(
                Code: productEnterprise?.Code,
                EnterpriseCode: e.enterprise.Code,
                Quantity: 0,
              );
        }).toList();
        productEnterprises?.sort(
          (a, b) => a.EnterpriseCode?.compareTo(b.EnterpriseCode ?? 0) ?? 0,
        );

        return ProductItemWidget(
          product: product.Product!,
          routine: BsRoutine.buyQuotation,
          showDropIcon: true,
          isSelected: index == selectedIndex,
          onTap: () => updateIndex(index),
          itemBeforeProductName: Column(
            children: [
              ...?productEnterprises?.map((e) {
                final correspondentEnterprise = enterprises.value!.firstWhere(
                  (x) => e.EnterpriseCode == x.Code,
                );
                return Row(
                  children: [
                    Expanded(
                      child: Text(
                        "(${correspondentEnterprise.PersonalizedCode}) - ${correspondentEnterprise.name}",
                        style: theme.textTheme.titleSmall,
                      ),
                    ),
                    Text((e.Quantity ?? 0).toString().toBrazilianNumber()),
                  ],
                );
              }),
            ],
          ),
          notClickableBottom: index == selectedIndex
              ? Column(
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
                          final correspondentEnterprise = enterprises.value!
                              .firstWhere(
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
                            onPressed: () {
                              final currentProducts = [
                                ...?buyQuotation.Products,
                              ];
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
                              //TODO improve this logic below

                              final selectedEnterpriseCodes =
                                  buyQuotation.Enterprises?.where(
                                    (e) => e.isSelected == true,
                                  ).map((e) => e.enterprise.Code).toSet() ??
                                  {};

                              final oldProduct = currentProducts[index];
                              final newProduct = oldProduct.copyWith(
                                Code: oldProduct.Code,
                                Product: oldProduct.Product,
                                ProductEnterprises: selectedEnterpriseCodes.map((
                                  x,
                                ) {
                                  return BuyQuotationProductEnterpriseEntity(
                                    Code:
                                        oldProduct
                                                .ProductEnterprises?.firstWhereOrNull(
                                              (y) => y.EnterpriseCode == x,
                                            )
                                            ?.Code,
                                    EnterpriseCode: x,
                                    Quantity:
                                        quantityControllers[x.toString()]!.text
                                            .toDouble() ??
                                        0,
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
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : null,
        );
      },
    );
  }
}
