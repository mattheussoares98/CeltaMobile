import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../localization/string_hardcoded.dart';
import '../../../../../../utils/utils.dart';
import '../../../../domain/entities/entities.dart';
import '../../../controllers/controllers.dart';
import 'update_item.dart';

class UpdateItemWidget extends ConsumerWidget {
  final VoidCallback update;
  final DraftKey draftKey;
  final double price;
  final TextEditingController quantityController;
  final TextEditingController priceController;
  final FocusNode quantityFocusNode;
  final FocusNode priceFocusNode;
  final bool isAlreadyInCart;
  const UpdateItemWidget({
    super.key,
    required this.update,
    required this.draftKey,
    required this.price,
    required this.quantityController,
    required this.priceController,
    required this.quantityFocusNode,
    required this.priceFocusNode,
    required this.isAlreadyInCart,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestTypeAllowChangePrice = ref.watch(
      uiStateControllerProvider(
        draftKey.requestTypeCode,
      ).select((s) => s.value?.requestTypeAllowChangePrice ?? false),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              flex: 30,
              child: QuantityField(
                quantityController: quantityController,
                priceController: priceController,
                quantityFocusNode: quantityFocusNode,
                priceFocusNode: priceFocusNode,
                requestTypeAllowChangePrice: requestTypeAllowChangePrice,
                update: update,
              ),
            ),
            gapW4,
            Expanded(
              flex: 25,
              child: PriceField(
                priceController: priceController,
                priceFocusNode: priceFocusNode,
                update: update,
                requestTypeCode: draftKey.requestTypeCode,
              ),
            ),
            gapW4,
            Expanded(
              flex: 45,
              child: AnimatedBuilder(
                animation: Listenable.merge([
                  quantityController,
                  priceController,
                ]),
                builder: (_, _) {
                  final quantity = quantityController.text.toDouble() ?? 0;
                  final writtenPrice = priceController.text.toDouble() ?? 0;
                  final itemPrice = requestTypeAllowChangePrice
                      ? writtenPrice
                      : price;
                  final newValue = (itemPrice * quantity)
                      .toString()
                      .toBrazilianNumber()
                      .addBrazilianCoin();
                  return PrimaryButton(
                    text: isAlreadyInCart
                        ? 'Alterar $newValue'.hardcoded
                        : 'Adicionar $newValue'.hardcoded,
                    onPressed: update,
                  );
                },
              ),
            ),
          ],
        ),
        gapH8,
      ],
    );
  }
}
