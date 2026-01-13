import 'package:celta_intelligence/features/transfer_request/presentation/controllers/controllers.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../constants/constants.dart';
import '../../../../../../../localization/string_hardcoded.dart';
import '../../../../../domain/entities/entities.dart';
import 'components.dart';

class ProductItem extends ConsumerWidget {
  final TransferRequestProductItemEntity item;
  final int index;
  final DraftKey draftKey;
  final TextEditingController quantityController;
  final FocusNode quantityFocusNode;
  final TextEditingController priceController;
  final FocusNode priceFocusNode;
  const ProductItem({
    super.key,
    required this.item,
    required this.index,
    required this.draftKey,
    required this.quantityController,
    required this.quantityFocusNode,
    required this.priceController,
    required this.priceFocusNode,
  });

  static final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestTypeAllowChangePrice = ref.watch(
      uiStateControllerProvider(
        draftKey.requestTypeCode,
      ).select((s) => s.value?.requestTypeAllowChangePrice ?? false),
    );

    void changeSelectedIndex(int? index) {
      ref
          .read(uiStateControllerProvider(draftKey.requestTypeCode).notifier)
          .updateSelectedCartProductIndex(index);

      quantityController.text = item.quantity
          .toString()
          .toBrazilianNumber()
          .replaceAll(RegExp(r'\.'), '');

      priceController.text = item.value
          .toString()
          .toBrazilianNumber()
          .replaceAll(RegExp(r'\.'), '');
      Future.delayed(const Duration(milliseconds: 100), () {
        quantityFocusNode.requestFocus();
        quantityController.selection = TextSelection(
          baseOffset: 0,
          extentOffset: quantityController.text.length,
        );
      });
    }

    void update() {
      if (_formKey.currentState?.validate() != true) {
        return;
      }

      ref
          .read(cartProductsStateControllerProvider(draftKey).notifier)
          .addItem(
            item.copyWith(
              quantity: quantityController.text.toDouble() ?? 0,
              value: requestTypeAllowChangePrice
                  ? priceController.text.toDouble() ?? 0
                  : null,
            ),
          );

      ref
          .read(uiStateControllerProvider(draftKey.requestTypeCode).notifier)
          .updateSelectedCartProductIndex(null);
    }

    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          InkWell(
            onTap: () {
              changeSelectedIndex(index);
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                Sizes.p8,
                Sizes.p8,
                0,
                Sizes.p8,
              ),
              child: Row(
                children: [
                  Expanded(child: ProductInformations(item: item)),
                  RemoveAndEditIcons(draftKey: draftKey, item: item),
                ],
              ),
            ),
          ),
          if (ref.watch(
                uiStateControllerProvider(
                  draftKey.requestTypeCode,
                ).select((s) => s.value?.selectedCartProductIndex),
              ) ==
              index) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(
                Sizes.p8,
                0,
                Sizes.p8,
                Sizes.p8,
              ),
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 35,
                          child: QuantityField(
                            quantityController: quantityController,
                            priceController: priceController,
                            quantityFocusNode: quantityFocusNode,
                            priceFocusNode: priceFocusNode,
                            requestTypeAllowChangePrice:
                                requestTypeAllowChangePrice,
                            update: update,
                          ),
                        ),
                        gapW12,
                        Expanded(
                          flex: 30,
                          child: PriceField(
                            priceController: priceController,
                            priceFocusNode: priceFocusNode,
                            update: update,
                            requestTypeCode: draftKey.requestTypeCode,
                          ),
                        ),
                        gapW12,
                        Expanded(flex: 35, child: TotalPrice(widget: this)),
                      ],
                    ),
                  ),
                  gapH8,
                  PrimaryButton(
                    text: 'Alterar'.hardcoded,
                    onPressed: update,
                    icon: Icon(
                      isIOS
                          ? CupertinoIcons.shopping_cart
                          : Icons.shopping_cart,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
