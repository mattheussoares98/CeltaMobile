import 'dart:async';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/presentation/controllers/products/products.dart';
import 'package:celta_inventario/features/process_authorization/presentation/controllers/controllers.dart';
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
          BaseText.title(context.l10n.searchForAndSelectTheProductToLink),
          gapH16,
          BaseTextFormField(
            controller: controller,
            hintText: context.l10n.name,
            labelText: context.l10n.viewProduct,
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
                  child: BaseText.error(context.l10n.noProductsFound),
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
                            title: context.l10n.attention2,
                            content: context.l10n.linkToThisProduct,
                            defaultActionText: context.l10n.yes,
                            cancelActionText: context.l10n.no,
                          );

                          if (ok == true) {
                            final succeeds = await ref
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
                            if (succeeds && context.mounted) {
                              Navigator.of(context).pop();
                            }
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
