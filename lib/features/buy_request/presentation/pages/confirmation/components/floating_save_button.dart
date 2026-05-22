import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/presentation/controllers/keyboard/keyboard/keyboard.dart';
import 'package:celta_inventario/features/buy_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:celta_inventario/utils/utils.dart';

class FloatingSaveButton extends ConsumerWidget {
  final TextEditingController observationsController;
  final int enterpriseCode;
  const FloatingSaveButton({
    super.key,
    required this.observationsController,
    required this.enterpriseCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartIsEmpty = ref.watch(
      pendingBuyRequestStateControllerProvider(
        enterpriseCode,
      ).select((s) => s.value?.products?.isEmpty ?? true),
    );

    return Padding(
      padding: EdgeInsets.only(
        bottom: ref.watch(keyboardVisibilityStateControllerProvider)
            ? Sizes.p48
            : 0,
      ),
      child: FloatingActionButton(
        onPressed: cartIsEmpty
            ? null
            : () {
                showAlertDialog(
                  context: context,
                  title: 'Salvar pedido?'.hardcoded,
                  cancelActionText: 'Cancelar'.hardcoded,
                  defaultActionText: 'Sim'.hardcoded,
                  onOkPressed: () async {
                    FocusManager.instance.primaryFocus?.unfocus();
                    final succeeds = await ref
                        .read(
                          insertBuyRequestControllerProvider(
                            enterpriseCode,
                          ).notifier,
                        )
                        .insert(observationsController.text);

                    if (succeeds) {
                      showSnackBarMessage(
                        context,
                        'Pedido salvo com sucesso'.hardcoded,
                      );
                      observationsController.clear();
                    }
                  },
                );
              },
        backgroundColor: cartIsEmpty
            ? Colors.grey
            : context.theme.primaryColor.withAlpha(200),
        child: const PlatformIcon(
          cupertinoIcon: CupertinoIcons.checkmark,
          materialIcon: Icons.save,
        ),
      ),
    );
  }
}
