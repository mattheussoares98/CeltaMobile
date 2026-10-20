import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/buy_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

    final isDesktop = MediaQuery.sizeOf(context).width > Breakpoint.desktop;

    bool hasSelectedValues =
        pendingValue?.selectedBuyer != null ||
        pendingValue?.selectedRequestType != null ||
        pendingValue?.selectedSupplier != null;

    return RepaintBoundary(
      child: PrimaryTextButton(
        text: isDesktop ? context.l10n.clearOrder : '',
        onPressed: hasSelectedValues
            ? () async {
                final result = await showAlertDialog(
                  context: context,
                  title: context.l10n.deleteData,
                  content: context.l10n.clearOrderConfirmation,
                  cancelActionText: context.l10n.cancel,
                  defaultActionText: context.l10n.confirm,
                );

                if (result == true && context.mounted) {
                  ref
                      .read(
                        pendingBuyRequestStateControllerProvider(
                          enterpriseCode,
                        ).notifier,
                      )
                      .clearState(null);
                  observationsController.clear();
                }
              }
            : null,
        platformIcon: PlatformIcon(
          cupertinoIcon: CupertinoIcons.delete,
          materialIcon: Icons.delete,
          color: hasSelectedValues ? Colors.red : context.theme.disabledColor,
        ),
        color: hasSelectedValues ? Colors.red : context.theme.disabledColor,
      ),
    );
  }
}
