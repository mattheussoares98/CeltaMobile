import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../utils/utils.dart';
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

  Future<void> onSave() async {
    if (formKey.currentState?.validate() != true) {
      return;
    }

    await ref
        .read(
          insertProductNotFoundControllerProvider(widget.receiptCode).notifier,
        )
        .insert(
          quantity: quantityController.text.toDouble()!,
          ean: eanController.text,
          observations: observationsController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    return Scaffold(
      appBar: AppBar(title: Text('Produtos não encontrados'.hardcoded)),
      floatingActionButton: FloatingActionButton(
        child: Icon(isIOS ? CupertinoIcons.add : Icons.add),
        onPressed: () {
          showModalPage(
            InsertNewProductPage(
              receiptCode: widget.receiptCode,
              formKey: formKey,
              quantityFocusNode: quantityFocusNode,
              observationsFocusNode: observationsFocusNode,
              eanController: eanController,
              quantityController: quantityController,
              observationsController: observationsController,
            ),
            context,
          );
        },
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

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(Sizes.p8),
                    child: Column(children: [Text(product.ean)]),
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
