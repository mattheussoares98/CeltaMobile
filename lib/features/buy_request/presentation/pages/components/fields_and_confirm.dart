import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../../../core/validators/validators.dart';
import '../../../../../localization/string_hardcoded.dart';
import '../../../../../utils/utils.dart';
import '../../../domain/entities/entities.dart';
import '../../controllers/controllers.dart';

class FieldsAndConfirm extends ConsumerWidget {
  final GlobalKey<FormState> fieldsFormKey;
  final GlobalKey<FormState> quantityFormKey;
  final TextEditingController quantityController;
  final TextEditingController costController;
  final FocusNode quantityFocusNode;
  final FocusNode costFocusNode;
  final ProductEntity product;
  final bool isConfirmationPage;
  const FieldsAndConfirm({
    super.key,
    required this.fieldsFormKey,
    required this.quantityFormKey,
    required this.quantityController,
    required this.costController,
    required this.quantityFocusNode,
    required this.costFocusNode,
    required this.product,
    required this.isConfirmationPage,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void insertProduct(ProductEntity product) async {
      if (quantityFormKey.currentState?.validate() != true) {
        quantityFocusNode.requestFocus();
        return;
      } else if (fieldsFormKey.currentState?.validate() != true) {
        costFocusNode.requestFocus();
        return;
      }

      final pending = await ref.read(
        pendingBuyRequestStateControllerProvider.future,
      );
      final products = pending.products ?? {};
      products.addAll({
        ProductKey(
          enterpriseCode: product.EnterpriseCode!,
          productPackingCode: product.ProductPackingCode!,
        ): BuyRequestProductItemEntity(
          product: product,
          quantity: quantityController.text.toDouble()!,
          cost: costController.text.toDouble()!,
        ),
      });
      ref
          .read(pendingBuyRequestStateControllerProvider.notifier)
          .updatePending(pending.copyWith(products: products));
      quantityController.clear();
      costController.clear();

      if (isConfirmationPage) {
        ref
            .read(uiStateControllerProvider.notifier)
            .updateSelectedCartProductIndex(null);
      } else {
        ref
            .read(uiStateControllerProvider.notifier)
            .updateSelectedProductIndex(null);
      }
    }

    return Form(
      key: fieldsFormKey,
      child: Row(
        children: [
          Expanded(
            child: Form(
              key: quantityFormKey,
              child: DefaultTextFormField(
                focusNode: quantityFocusNode,
                controller: quantityController,
                labelText: 'Quantidade'.hardcoded,
                hintText: 'Quantidade'.hardcoded,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: FormValidators.compose([
                  NonEmptyValidator(),
                  NumberValidator(allowDecimal: true, maxDecimalHouses: 3),
                ]),
                maxLength: 13,
                onFieldSubmitted: (_) {
                  if (quantityFormKey.currentState?.validate() != true) {
                    quantityFocusNode.requestFocus();
                  } else {
                    costController.selection = TextSelection(
                      baseOffset: 0,
                      extentOffset: costController.text.length,
                    );
                    costFocusNode.requestFocus();
                  }
                },
              ),
            ),
          ),
          gapW8,
          Expanded(
            child: DefaultTextFormField(
              onTap: () {
                if (costFocusNode.hasFocus) {
                  return;
                }
                costController.selection = TextSelection(
                  baseOffset: 0,
                  extentOffset: costController.text.length,
                );
              },
              focusNode: costFocusNode,
              controller: costController,
              labelText: 'Custo'.hardcoded,
              hintText: 'Custo'.hardcoded,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: FormValidators.compose([
                NonEmptyValidator(),
                NumberValidator(allowDecimal: true, maxDecimalHouses: 4),
              ]),
              maxLength: 13,
              onFieldSubmitted: (_) => insertProduct(product),
            ),
          ),
          gapW8,
          Expanded(
            child: PrimaryButton(
              text: 'Confirmar'.hardcoded,
              onPressed: () => insertProduct(product),
            ),
          ),
        ],
      ),
    );
  }
}
