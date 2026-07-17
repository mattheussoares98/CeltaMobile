import 'dart:async';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/presentation/controllers/products/products.dart';
import 'package:celta_inventario/features/process_authorization/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchProductToLink extends ConsumerStatefulWidget {
  final int processCode;
  final int productCode;
  const SearchProductToLink({
    super.key,
    required this.processCode,
    required this.productCode,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProductsWithoutRegisterPageState();
}

class _ProductsWithoutRegisterPageState
    extends ConsumerState<SearchProductToLink> {
  final controller = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    controller.dispose();
    super.dispose();
  }

  static const recordsByPage = 20;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Sizes.p8),
      child: Column(
        children: [
          BaseText.title(
            'Pesquise e selecione o produto a ser associado'.hardcoded,
          ),
          gapH16,
          BaseTextFormField(
            controller: controller,
            hintText: 'Nome'.hardcoded,
            labelText: 'Consultar produto'.hardcoded,
            onFieldSubmitted: (value) => ref
                .read(shallowProductsStateControllerProvider.notifier)
                .load(value, recordsByPage: recordsByPage),
            onChanged: (value) {
              if (_debounce?.isActive ?? false) _debounce!.cancel();
              _debounce = Timer(const Duration(milliseconds: 600), () {
                ref
                    .read(shallowProductsStateControllerProvider.notifier)
                    .load(value, recordsByPage: recordsByPage);
              });
            },
          ),
          AsyncValueWidget(
            value: ref.watch(shallowProductsStateControllerProvider),
            tryAgain: () =>
                ref.invalidate(shallowProductsStateControllerProvider),
            data: (products) {
              if (products == null || products.isEmpty) {
                return Center(
                  child: BaseText.error(
                    'Nenhum produto foi encontrado'.hardcoded,
                  ),
                );
              }
              return Expanded(
                child: ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];

                    return Card(
                      clipBehavior: .hardEdge,
                      child: InkWell(
                        onTap: () async {
                          final ok = await showAlertDialog(
                            context: context,
                            title: 'Atenção'.hardcoded,
                            content:
                                'Deseja associar a esse produto?'.hardcoded,
                            defaultActionText: 'Sim'.hardcoded,
                            cancelActionText: 'Não'.hardcoded,
                          );

                          if (ok == true) {
                            ref
                                .read(
                                  judgmentControllerProvider(
                                    widget.processCode,
                                  ).notifier,
                                )
                                .linkProductWithoutCadaster(
                                  productCode: product.ProductCode!,
                                  productWithoutCadasterCode:
                                      widget.productCode,
                                );
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(Sizes.p8),
                          child: Column(
                            crossAxisAlignment: .start,
                            children: [
                              BaseRichText(
                                texts: [
                                  BaseText.title(product.Name!),
                                  BaseText(
                                    ' (${product.PackingAbbreviation} ${product.PackingQuantity.toString().toBrazilianNumber(3, true)})',
                                    color: context.theme.colorScheme.secondary,
                                  ),
                                ],
                              ),
                              BaseText(
                                product.PLU.toString(),
                                color: context.theme.primaryColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
