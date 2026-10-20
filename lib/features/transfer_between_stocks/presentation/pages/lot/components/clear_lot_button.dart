import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/transfer_between_stocks/presentation/controllers/controllers.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ClearLotButton extends ConsumerWidget {
  final int enterpriseCode;
  const ClearLotButton({super.key, required this.enterpriseCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDesktop = MediaQuery.sizeOf(context).width > Breakpoint.desktop;

    final hasProductsInCart = ref.watch(
      lotStateControllerProvider(
        enterpriseCode,
      ).select((s) => s.value?.isNotEmpty ?? true),
    );

    return PrimaryTextButton(
      text: isDesktop ? context.l10n.clearBatch : '',
      color: Colors.red,
      platformIcon: PlatformIcon(
        cupertinoIcon: CupertinoIcons.delete,
        materialIcon: Icons.delete,
        color: hasProductsInCart ? Colors.red : context.theme.disabledColor,
      ),
      onPressed: hasProductsInCart
          ? () async {
              final confirmed = await showAlertDialog(
                context: context,
                title: context.l10n.clearBatch2,
                cancelActionText: context.l10n.cancel,
                defaultActionText: context.l10n.clear,
              );

              if (confirmed != true || !context.mounted) return;
              ref
                  .read(lotStateControllerProvider(enterpriseCode).notifier)
                  .clearLot(enterpriseCode);
            }
          : null,
    );
  }
}
