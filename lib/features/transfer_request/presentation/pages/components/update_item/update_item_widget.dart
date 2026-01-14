import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../localization/string_hardcoded.dart';
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
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

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
            gapW12,
            Expanded(
              flex: 35,
              child: PriceField(
                priceController: priceController,
                priceFocusNode: priceFocusNode,
                update: update,
                requestTypeCode: draftKey.requestTypeCode,
              ),
            ),
            gapW12,
            Expanded(
              flex: 35,
              child: TotalPrice(
                quantityController: quantityController,
                priceController: priceController,
                price: price,
                draftKey: draftKey,
              ),
            ),
          ],
        ),
        gapH8,
        PrimaryButton(
          text: isAlreadyInCart ? 'Alterar'.hardcoded : 'Adicionar'.hardcoded,
          onPressed: update,
          icon: Icon(
            isIOS ? CupertinoIcons.shopping_cart : Icons.shopping_cart,
          ),
        ),
      ],
    );
  }
}
