import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../constants/constants.dart';
import '../../../../domain/entities/entities.dart';
import '../../../controllers/controllers.dart';
import 'components/components.dart';

class CartPage extends ConsumerStatefulWidget {
  final DraftKey draftKey;
  final bool requestTypeAllowChangePrice;
  const CartPage({
    super.key,
    required this.draftKey,
    required this.requestTypeAllowChangePrice,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CartPageState();
}

class _CartPageState extends ConsumerState<CartPage> {
  final quantityController = TextEditingController();
  final quantityFocusNode = FocusNode();
  final priceController = TextEditingController();
  final priceFocusNode = FocusNode();
  int? selectedIndex;

  @override
  void dispose() {
    super.dispose();
    quantityController.dispose();
    quantityFocusNode.dispose();
    priceController.dispose();
    priceFocusNode.dispose();
  }

  void changeSelectedIndex(int? index, TransferRequestProductItemEntity item) {
    if (selectedIndex == index || index == null) {
      setState(() {
        selectedIndex = null;
      });
    } else {
      setState(() {
        selectedIndex = index;
      });
      quantityController.text = item.quantity.toString().replaceAll(
        RegExp(r'\.'),
        ',',
      );
      if (widget.requestTypeAllowChangePrice) {
        priceController.text = item.value.toString().replaceAll(
          RegExp(r'\.'),
          ',',
        );
      }
      Future.delayed(Duration(milliseconds: 100), () {
        quantityFocusNode.requestFocus();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final pendingAsync = ref.watch(
      cartProductsStateControllerProvider(widget.draftKey),
    );

    final lastSavedAsync = ref.watch(lastSavedNumberStateControllerProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.p8),
      child: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                if (lastSavedAsync.value != null)
                  LastSavedNumber(number: lastSavedAsync.value!),
                SliverList.builder(
                  itemCount: pendingAsync.value?.length ?? 0,
                  itemBuilder: (_, index) {
                    final item = pendingAsync.value![index];

                    return ProductItem(
                      item: item,
                      index: index,
                      changeSelectedIndex: (index) =>
                          changeSelectedIndex(index, item),
                      draftKey: widget.draftKey,
                      selectedIndex: selectedIndex,
                      requestTypeAllowChangePrice:
                          widget.requestTypeAllowChangePrice,
                      priceController: priceController,
                      priceFocusNode: priceFocusNode,
                      quantityController: quantityController,
                      quantityFocusNode: quantityFocusNode,
                    );
                  },
                ),
                if ((pendingAsync.value?.length ?? 0) > 2) ...[
                  ClearCartButton(draftKey: widget.draftKey),
                  gapSliverH16,
                ],
              ],
            ),
          ),
          Footer(draftKey: widget.draftKey),
        ],
      ),
    );
  }
}
