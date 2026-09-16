import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:celta_inventario/features/transfer_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/transfer_request/presentation/pages/components/update_item/update_item.dart';

class UpdateItemWidget extends StatelessWidget {
  final VoidCallback update;
  final DraftKey draftKey;
  final double price;
  final TextEditingController quantityController;
  final TextEditingController priceController;
  final FocusNode quantityFocusNode;
  final FocusNode priceFocusNode;
  final bool isCartPage;
  final bool requestTypeAllowChangePrice;
  const UpdateItemWidget({
    super.key,
    required this.update,
    required this.draftKey,
    required this.price,
    required this.quantityController,
    required this.priceController,
    required this.quantityFocusNode,
    required this.priceFocusNode,
    required this.isCartPage,
    required this.requestTypeAllowChangePrice,
  });

  @override
  Widget build(BuildContext context) {
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
              flex: 30,
              child: PriceField(
                priceController: priceController,
                priceFocusNode: priceFocusNode,
                update: update,
                requestTypeAllowChangePrice: requestTypeAllowChangePrice,
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
                    text: isCartPage
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
