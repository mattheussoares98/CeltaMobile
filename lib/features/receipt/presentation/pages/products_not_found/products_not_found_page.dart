import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../core/validators/validators.dart';
import '../../../../../utils/utils.dart';
import '../../controllers/controllers.dart';

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

  void onSave() {
    if (formKey.currentState?.validate() != true) {
      return;
    }

    // ref
    //     .read(
    //       productsNotFoundStateControllerProvider(widget.receiptCode).notifier,
    //     )
    //     .insert(
    //       internalCode: widget.receiptCode,
    //       quantity: quantityController.text.toDouble()!,
    //       ean: eanController.text,
    //       observations: observationsController.text,
    //     );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    ref.listen(productsNotFoundStateControllerProvider(widget.receiptCode), (
      p,
      n,
    ) {
      //TODO create another provider because in the previous page is treting the same error
      // n.doOnSuccess(p, () {
      //   context.pop();
      // });
      n.showAlertDialogOnError(context);
    });
    return Scaffold(
      appBar: AppBar(title: Text('Produtos não encontrados'.hardcoded)),
      floatingActionButton: FloatingActionButton(
        child: Icon(isIOS ? CupertinoIcons.add : Icons.add),
        onPressed: () {
          showModalPage(
            Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(Sizes.p8),
                  child: Column(
                    children: [
                      DefaultTextFormField(
                        controller: eanController,
                        onFieldSubmitted: (_) =>
                            quantityFocusNode.requestFocus(),
                        validator: FormValidators.compose([
                          NumberValidator(allowDecimal: false),
                          MinLengthValidator(8),
                        ]),
                        labelText: 'EAN'.hardcoded,
                        hintText: 'EAN'.hardcoded,
                      ),
                      DefaultTextFormField(
                        controller: quantityController,
                        focusNode: quantityFocusNode,
                        onFieldSubmitted: (_) =>
                            observationsFocusNode.requestFocus(),
                        validator: FormValidators.compose([
                          NumberValidator(allowDecimal: true),
                        ]),
                        labelText: 'Quantidade'.hardcoded,
                        hintText: 'Quantidade'.hardcoded,
                      ),
                      DefaultTextFormField(
                        controller: observationsController,
                        focusNode: observationsFocusNode,
                        onFieldSubmitted: (_) => onSave(),
                        labelText: 'Observações'.hardcoded,
                        hintText: 'Observações'.hardcoded,
                      ),
                      gapH32,
                      PrimaryButton(
                        text: 'Salvar',
                        onPressed: onSave,
                        isLoading: ref.watch(
                          productsNotFoundStateControllerProvider(
                            widget.receiptCode,
                          ).select((s) => s.isLoading),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
