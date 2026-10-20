import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/validators/validators.dart';
import 'package:celta_inventario/features/buy_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/buy_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/localization.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FieldsAndConfirm extends ConsumerWidget {
  final GlobalKey<FormState> fieldsFormKey;
  final GlobalKey<FormState> quantityFormKey;
  final TextEditingController quantityController;
  final TextEditingController costController;
  final FocusNode quantityFocusNode;
  final FocusNode costFocusNode;
  final ProductEntity product;
  final bool isConfirmationPage;
  final int enterpriseCode;
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
    required this.enterpriseCode,
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
        pendingBuyRequestStateControllerProvider(enterpriseCode).future,
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
          .read(
            pendingBuyRequestStateControllerProvider(enterpriseCode).notifier,
          )
          .updatePending(products: products);
      quantityController.clear();
      costController.clear();

      if (isConfirmationPage) {
        ref
            .read(uiStateControllerProvider(enterpriseCode).notifier)
            .updateSelectedCartProductIndex(null);
      } else {
        ref
            .read(uiStateControllerProvider(enterpriseCode).notifier)
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
              child: BaseTextFormField(
                focusNode: quantityFocusNode,
                controller: quantityController,
                labelText: 'Quantidade'.hardcoded,
                hintText: 'Quantidade'.hardcoded,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                maxLength: 13,
                onTap: () {
                  if (quantityFocusNode.hasFocus) {
                    return;
                  }
                  quantityController.selection = TextSelection(
                    baseOffset: 0,
                    extentOffset: quantityController.text.length,
                  );
                },
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: FormValidators.compose([
                  NonEmptyValidator(translations: context.l10n),
                  NumberValidator(
                    translations: context.l10n,
                    allowDecimal: true,
                    maxDecimalHouses: 3,
                  ),
                ]),
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
            child: BaseTextFormField(
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
                NonEmptyValidator(translations: context.l10n),
                NumberValidator(
                  translations: context.l10n,
                  allowDecimal: true,
                  maxDecimalHouses: 4,
                ),
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
