import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuantityControlButton extends ConsumerWidget {
  final BSFProductItemEntity item;
  final bool isAdding;
  final double? size;

  const QuantityControlButton({
    super.key,
    required this.item,
    required this.isAdding,
    this.size,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentQuantity = item.quantity ?? 0;
    final isRemoving = !isAdding && currentQuantity <= 1;

    return IconButton(
      onPressed: () async {
        final notifier = ref.read(insertUpdateStateControllerProvider.notifier);

        final (errorMessage, actions) = notifier.increaseOrDecreaseUnit(
          item,
          isAdding,
          onlyValidating: true,
        );

        if (errorMessage?.isNotEmpty == true) {
          showToastMessage(errorMessage!, type: ToastType.error);
          return;
        } else if (actions.isNotEmpty) {
          final confirmed = await showAlertDialog(
            context: context,
            title: 'Atenção!'.hardcoded,
            cancelActionText: 'Cancelar'.hardcoded,
            defaultActionText: 'Continuar'.hardcoded,
            content: actions.map((a) => a.message).join('\n'),
          );
          if (confirmed != true) {
            return;
          }
        }

        notifier.increaseOrDecreaseUnit(item, isAdding);
      },
      icon: PlatformIcon(
        cupertinoIcon: isAdding
            ? CupertinoIcons.plus_circle
            : isRemoving
            ? CupertinoIcons.trash
            : CupertinoIcons.minus_circle,
        materialIcon: isAdding
            ? Icons.add_circle_outline
            : isRemoving
            ? Icons.delete_outline
            : Icons.remove_circle_outline,
        size: size,
        color: isRemoving
            ? (currentQuantity == 0
                  ? Colors.grey
                  : context.theme.colorScheme.error)
            : item.hasNoPrice
            ? context.theme.colorScheme.error
            : null,
      ),
      padding: const EdgeInsets.all(Sizes.p4),
      constraints: const BoxConstraints(),
    );
  }
}
