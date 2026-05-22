import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/buy_request/presentation/controllers/controllers.dart';

class ClearRequestButton extends ConsumerWidget {
  final TextEditingController observationsController;
  final int enterpriseCode;
  const ClearRequestButton({
    super.key,
    required this.observationsController,
    required this.enterpriseCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingAsync = ref.watch(
      pendingBuyRequestStateControllerProvider(enterpriseCode),
    );
    final pendingValue = pendingAsync.value;
    final theme = Theme.of(context);
    final isDesktop = MediaQuery.sizeOf(context).width > Breakpoint.desktop;

    bool hasSelectedValues =
        pendingValue?.selectedBuyer != null ||
        pendingValue?.selectedRequestType != null ||
        pendingValue?.selectedSupplier != null;

    return RepaintBoundary(
      child: PrimaryTextButton(
        text: isDesktop ? 'Limpar pedido'.hardcoded : '',
        onPressed: hasSelectedValues
            ? () {
                showAlertDialog(
                  context: context,
                  title: 'Apagar dados'.hardcoded,
                  content:
                      'Tem certeza que deseja remover todos dados inseridos?'
                          .hardcoded,
                  cancelActionText: 'Cancelar'.hardcoded,
                  defaultActionText: 'Confirmar'.hardcoded,
                  onOkPressed: () {
                    ref
                        .read(
                          pendingBuyRequestStateControllerProvider(
                            enterpriseCode,
                          ).notifier,
                        )
                        .clearState(null);
                    observationsController.clear();
                  },
                );
              }
            : null,
        icon: PlatformIcon(
          cupertinoIcon: CupertinoIcons.delete,
          materialIcon: Icons.delete,
          color: hasSelectedValues ? Colors.red : theme.disabledColor,
        ),
        color: hasSelectedValues ? Colors.red : theme.disabledColor,
      ),
    );
  }
}
