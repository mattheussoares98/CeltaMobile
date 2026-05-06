import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../constants/constants.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../../domain/entities/entities.dart';
import '../../../controllers/controllers.dart';

class QuantityControlButton extends ConsumerWidget {
  final BSFProductItemEntity? item;
  final ProductEntity product;
  final int enterpriseCode;
  final int customerCode;
  final int saleRequestId;
  final bool isAdding;
  final double size;

  const QuantityControlButton({
    super.key,
    required this.item,
    required this.product,
    required this.enterpriseCode,
    required this.customerCode,
    required this.saleRequestId,
    required this.isAdding,
    this.size = 28,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final currentQuantity = item?.quantity ?? 0;

    return IconButton(
      onPressed: () {
        if (!isAdding && currentQuantity <= 1) {
          return;
        }

        final newQuantity = isAdding ? currentQuantity + 1 : currentQuantity - 1;

        ref
            .read(
              insertUpdateStateControllerProvider(
                enterpriseCode: enterpriseCode,
                customerCode: customerCode,
                saleRequestId: saleRequestId,
              ).notifier,
            )
            .updateItemQuantity(item, newQuantity, product);
      },
      icon: PlatformIcon(
        cupertinoIcon:
            isAdding ? CupertinoIcons.plus_circle : CupertinoIcons.minus_circle,
        materialIcon:
            isAdding ? Icons.add_circle_outline : Icons.remove_circle_outline,
        size: size,
        color: (!isAdding && currentQuantity <= 1) ? theme.hintColor : null,
      ),
      padding: const EdgeInsets.all(Sizes.p4),
      constraints: const BoxConstraints(),
    );
  }
}
