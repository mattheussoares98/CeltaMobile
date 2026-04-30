import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../localization/string_hardcoded.dart';
import '../../../controllers/controllers.dart';

class ClearLotButton extends ConsumerWidget {
  final int enterpriseCode;
  const ClearLotButton({super.key, required this.enterpriseCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDesktop = MediaQuery.sizeOf(context).width > Breakpoint.desktop;

    final hasProductsInCart = ref.watch(
      lotStateControllerProvider(
        enterpriseCode,
      ).select((s) => s.value?.isNotEmpty ?? true),
    );

    return PrimaryTextButton(
      text: isDesktop ? 'Limpar lote'.hardcoded : '',
      color: Colors.red,
      icon: PlatformIcon(
        cupertinoIcon: CupertinoIcons.delete,
        materialIcon: Icons.delete,
        color: hasProductsInCart ? Colors.red : theme.disabledColor,
      ),
      onPressed: hasProductsInCart
          ? () {
              showAlertDialog(
                context: context,
                title: 'Limpar lote?'.hardcoded,
                cancelActionText: 'Cancelar'.hardcoded,
                defaultActionText: 'Limpar'.hardcoded,
                onOkPressed: () {
                  ref
                      .read(lotStateControllerProvider(enterpriseCode).notifier)
                      .clearLot(enterpriseCode);
                },
              );
            }
          : null,
    );
  }
}
