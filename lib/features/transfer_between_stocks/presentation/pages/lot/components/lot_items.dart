import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../constants/constants.dart';
import '../../../../domain/entities/entities.dart';
import '../../../controllers/controllers.dart';
import 'components.dart';

class LotItems extends ConsumerWidget {
  final List<ProductLotInfoEntity> items;
  final int? selectedIndex;
  final void Function(int index, double quantity) changeSelectedIndex;
  final TextEditingController quantityController;
  final FocusNode quantityFocusNode;
  final int enterpriseCode;

  const LotItems({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.changeSelectedIndex,
    required this.quantityController,
    required this.quantityFocusNode,
    required this.enterpriseCode,
  });

  static final _formKey = GlobalKey<FormState>();
  //TODO change to statefull

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void onSubmit(int index, ProductLotInfoEntity item) {
      if (_formKey.currentState?.validate() != true) {
        return;
      }
      ref
          .read(lotStateControllerProvider(enterpriseCode).notifier)
          .addItem(
            product: item.product,
            quantity: quantityController.text.toDouble()!,
          );
      changeSelectedIndex(index, 0);
    }

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (_, index) {
        final item = items[index];
        return Padding(
          padding: EdgeInsets.only(
            bottom: (index == items.length - 1) ? Sizes.p32 : 0,
          ),
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                InkWell(
                  onTap: () => changeSelectedIndex(index, item.quantity),
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
                              changeSelectedIndex: changeSelectedIndex,
                              index: index,
                              enterpriseCode: enterpriseCode,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                UpdateQuantityField(
                  selectedIndex: selectedIndex,
                  index: index,
                  formKey: _formKey,
                  quantityController: quantityController,
                  quantityFocusNode: quantityFocusNode,
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
