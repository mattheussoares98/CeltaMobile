import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../utils/utils.dart';
import '../../../domain/entity/entity.dart';
import '../../controllers/controllers.dart';
import '../pages.dart';

class ProductsNotFoundPage extends ConsumerStatefulWidget {
  final int receiptCode;
  const ProductsNotFoundPage({super.key, required this.receiptCode});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProductsNotFoundPageState();
}

class _ProductsNotFoundPageState extends ConsumerState<ProductsNotFoundPage> {
  final eanController = TextEditingController();
  final quantityController = TextEditingController();
  final observationsController = TextEditingController();
  final quantityFocusNode = FocusNode();
  final observationsFocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    eanController.dispose();
    quantityController.dispose();
    observationsController.dispose();
    quantityFocusNode.dispose();
    observationsFocusNode.dispose();
  }

  Future<void> onSubmit(int? internalCode) async {
    if (formKey.currentState?.validate() != true) {
      return;
    }

    final succeds = await ref
        .read(
          insertProductNotFoundControllerProvider(widget.receiptCode).notifier,
        )
        .insert(
          quantity: quantityController.text.toDouble()!,
          ean: eanController.text,
          observations: observationsController.text,
          internalCode: internalCode,
        );

    if (succeds) {
      context.pop();
    }
  }

  void openInsertUpdateProductPage(ProductNotFoundEntity? product) {
    if (product != null) {
      eanController.text = product.ean;
      quantityController.text = product.quantity.toString().toBrazilianNumber();
      observationsController.text = product.observations == 'null'
          ? ""
          : product.observations ?? "";
    } else {
      eanController.clear();
      quantityController.clear();
      observationsController.clear();
    }
    showModalPage(
      InsertUpdateProductPage(
        isEditing: product != null,
        receiptCode: widget.receiptCode,
        formKey: formKey,
        quantityFocusNode: quantityFocusNode,
        observationsFocusNode: observationsFocusNode,
        eanController: eanController,
        quantityController: quantityController,
        observationsController: observationsController,
        onSubmit: () => onSubmit(product?.internalCode),
      ),
      context,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    return Scaffold(
      appBar: AppBar(
        title: FittedBox(child: Text('Produtos não encontrados'.hardcoded)),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(isIOS ? CupertinoIcons.add : Icons.add),
        onPressed: () => openInsertUpdateProductPage(null),
      ),
      body: AsyncValueWidget(
        value: ref.watch(
          productsNotFoundStateControllerProvider(widget.receiptCode),
        ),
        tryAgain: () => ref.invalidate(
          productsNotFoundStateControllerProvider(widget.receiptCode),
        ),
        data: (products) {
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(
                productsNotFoundStateControllerProvider(widget.receiptCode),
              );
            },
            child: ResponsiveListFlow(
              itemCount: products.length,
              itemBuilder: (_, index) {
                final product = products[index];

                return Padding(
                  padding: EdgeInsets.only(
                    bottom: (products.length == index + 1)
                        ? Sizes.p64
                        : 0, //avoid overlay the floating button
                  ),
                  child: Card(
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(Sizes.p8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TitleAndSubTitle(
                                title: 'EAN'.hardcoded,
                                subTitle: product.ean,
                              ),
                              TitleAndSubTitle(
                                title: 'Quantidade'.hardcoded,
                                subTitle: product.quantity
                                    .toString()
                                    .toBrazilianNumber(),
                              ),
                              if (product.observations != null &&
                                  product.observations!.isNotEmpty &&
                                  product.observations.toString() != 'null')
                                TitleAndSubTitle(
                                  title: 'Observações'.hardcoded,
                                  subTitle: product.observations,
                                ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: IconButton(
                            onPressed: () =>
                                openInsertUpdateProductPage(product),
                            icon: Icon(
                              isIOS ? CupertinoIcons.pencil : Icons.edit,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
