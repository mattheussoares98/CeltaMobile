import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../constants/constants.dart';
import '../../../../domain/entities/entities.dart';
import '../../../controllers/controllers.dart';
import 'components.dart';

class LotItems extends ConsumerStatefulWidget {
  final List<ProductLotInfoEntity> items;
  final TextEditingController quantityController;
  final FocusNode quantityFocusNode;
  final int enterpriseCode;

  const LotItems({
    super.key,
    required this.items,
    required this.quantityController,
    required this.quantityFocusNode,
    required this.enterpriseCode,
  });
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LotItemsState();
}

class _LotItemsState extends ConsumerState<LotItems> {
  final formKey = GlobalKey<FormState>();

  void changeSelectedIndex(int? index, ProductLotInfoEntity item) {
    ref
        .read(selectedLotIndexStateControllerProvider.notifier)
        .updateIndex(index);

    widget.quantityController.text = item.quantity
        .toDouble()
        .toString()
        .toBrazilianNumber(3, true);
    widget.quantityController.selection = TextSelection.fromPosition(
      TextPosition(offset: widget.quantityController.text.length),
    );
    Future.delayed(const Duration(milliseconds: 100), () {
      widget.quantityFocusNode.requestFocus();
    });
  }

  void onSubmit(int index, ProductLotInfoEntity item) {
    if (formKey.currentState?.validate() != true) {
      return;
    }
    ref
        .read(lotStateControllerProvider(widget.enterpriseCode).notifier)
        .addItem(
          product: item.product,
          quantity: widget.quantityController.text.toDouble()!,
          selectedDestinyStock: item.selectedDestinyStock,
          selectedJustification: item.selectedJustification,
          selectedOriginStock: item.selectedOriginStock,
        );

    ref
        .read(selectedLotIndexStateControllerProvider.notifier)
        .updateIndex(null);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.items.length,
      itemBuilder: (_, index) {
        final item = widget.items[index];
        return Padding(
          padding: EdgeInsets.only(
            bottom: (index == widget.items.length - 1) ? Sizes.p32 : 0,
          ),
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                InkWell(
                  onTap: () => changeSelectedIndex(index, item),
                  child: Padding(
                    padding: const EdgeInsets.all(Sizes.p8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        NameAndJustification(item: item),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: OriginAndDestinyWithQuantities(item: item),
                            ),
                            EditAndRemoveIconButtons(
                              item: item,
                              onTapEdit: () => changeSelectedIndex(index, item),
                              enterpriseCode: widget.enterpriseCode,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                UpdateQuantityField(
                  index: index,
                  formKey: formKey,
                  quantityController: widget.quantityController,
                  quantityFocusNode: widget.quantityFocusNode,
                  item: item,
                  onSubmit: onSubmit,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
