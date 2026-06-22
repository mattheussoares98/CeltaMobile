import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/utils/extensions/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeleteSummaryButton extends ConsumerWidget {
  final BSFProductItemEntity item;

  const DeleteSummaryButton({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isInCart = ref.watch(
      insertUpdateStateControllerProvider.select(
        (s) =>
            s.value?.products?.any(
              (e) =>
                  e.product?.productPackingString ==
                  item.product?.productPackingString,
            ) ??
            false,
      ),
    );
    return IconButton(
      onPressed: () => ref
          .read(insertUpdateStateControllerProvider.notifier)
          .removeItem(item),
      icon: PlatformIcon(
        cupertinoIcon: CupertinoIcons.delete,
        materialIcon: Icons.delete_outline,
        size: 32,
        color: isInCart ? Colors.red : context.theme.disabledColor,
      ),
      padding: const EdgeInsets.all(Sizes.p4),
    );
  }
}
