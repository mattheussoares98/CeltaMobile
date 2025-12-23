import 'package:celta_intelligence/features/transfer_request/presentation/controllers/controllers.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../constants/constants.dart';
import '../../../../../domain/entities/entities.dart';
import 'components.dart';

class ProductItem extends ConsumerWidget {
  final void Function(int? index) changeSelectedIndex;
  final TransferRequestProductItemEntity item;
  final int index;
  final DraftKey draftKey;
  final int? selectedIndex;
  final bool requestTypeAllowChangePrice;
  final TextEditingController quantityController;
  final FocusNode quantityFocusNode;
  final TextEditingController priceController;
  final FocusNode priceFocusNode;
  const ProductItem({
    super.key,
    required this.item,
    required this.index,
    required this.changeSelectedIndex,
    required this.draftKey,
    required this.selectedIndex,
    required this.requestTypeAllowChangePrice,
    required this.quantityController,
    required this.quantityFocusNode,
    required this.priceController,
    required this.priceFocusNode,
  });

  static final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

      changeSelectedIndex(null);
    }

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
          if (selectedIndex == index) ...[
            Padding(
              padding: const EdgeInsets.all(Sizes.p8),
              child: Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          QuantityField(
                            quantityController: quantityController,
                            priceController: priceController,
                            quantityFocusNode: quantityFocusNode,
                            priceFocusNode: priceFocusNode,
                            requestTypeAllowChangePrice:
                                requestTypeAllowChangePrice,
                            update: update,
                          ),
                          if (requestTypeAllowChangePrice) ...[
                            gapH4,
                            PriceField(
                              priceController: priceController,
                              priceFocusNode: priceFocusNode,
                              update: update,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  gapW4,
                  Expanded(
                    flex: 4,
                    child: NewTotalAndUpdateButton(
                      quantityController: quantityController,
                      priceController: priceController,
                      update: update,
                      item: item,
                      requestTypeAllowChangePrice: requestTypeAllowChangePrice,
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
