import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../controllers/controllers.dart';

class ClearRequestButton extends ConsumerWidget {
  final TextEditingController observationsController;
  const ClearRequestButton({super.key, required this.observationsController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingAsync = ref.watch(pendingBuyRequestStateControllerProvider);
    final pendingValue = pendingAsync.value;
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;
    final isDesktop = MediaQuery.sizeOf(context).width > Breakpoint.desktop;

    bool hasSelectedValues =
        pendingValue?.selectedBuyer != null ||
        pendingValue?.selectedRequestType != null ||
        pendingValue?.selectedSupplier != null;

    return Visibility(
      visible: hasSelectedValues || isDesktop,
      child: PrimaryTextButton(
        text: 'Limpar pedido'.hardcoded,
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
                        .read(pendingBuyRequestStateControllerProvider.notifier)
                        .clearState(null);
                    observationsController.clear();
                  },
                );
              }
            : null,
        icon: Icon(
          isIOS ? CupertinoIcons.delete : Icons.delete,
          color: hasSelectedValues ? Colors.red : theme.disabledColor,
        ),
        color: hasSelectedValues ? Colors.red : theme.disabledColor,
      ),
    );
  }
}
