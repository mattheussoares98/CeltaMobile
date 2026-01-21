import 'package:celta_inventario/utils/utils.dart';
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

    widget.quantityFocusNode.unfocus();
    WidgetsBinding.instance.addPostFrameCallback((_) {
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

        final packingCode = item.product.ProductPackingCode;
        final destinyCode = item.selectedDestinyStock.CodigoInterno_TipoEstoque;
        final originCode = item.selectedOriginStock.CodigoInterno_TipoEstoque;
        final justificationCode =
            item.selectedJustification.CodigoInterno_JustMov;

        return _LotItem(
          key: ValueKey(
            '$packingCode-$destinyCode-$originCode-$justificationCode',
          ),
          index: index,
          item: item,
          items: widget.items,
          quantityController: widget.quantityController,
          quantityFocusNode: widget.quantityFocusNode,
          enterpriseCode: widget.enterpriseCode,
          onSubmit: () => onSubmit(index, item),
          changeSelectedIndex: () => changeSelectedIndex(index, item),
          formKey: formKey,
        );
      },
    );
  }
}

class _LotItem extends StatelessWidget {
  final int index;
  final ProductLotInfoEntity item;
  final List<ProductLotInfoEntity> items;
  final TextEditingController quantityController;
  final FocusNode quantityFocusNode;
  final int enterpriseCode;
  final VoidCallback onSubmit;
  final VoidCallback changeSelectedIndex;
  final GlobalKey<FormState> formKey;
  const _LotItem({
    super.key,
    required this.index,
    required this.item,
    required this.items,
    required this.quantityController,
    required this.quantityFocusNode,
    required this.enterpriseCode,
    required this.onSubmit,
    required this.changeSelectedIndex,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: (index == items.length - 1) ? Sizes.p32 : 0,
        ),
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              InkWell(
                onTap: changeSelectedIndex,
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
                            onTapEdit: changeSelectedIndex,
                            enterpriseCode: enterpriseCode,
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
                quantityController: quantityController,
                quantityFocusNode: quantityFocusNode,
                item: item,
                onSubmit: onSubmit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
