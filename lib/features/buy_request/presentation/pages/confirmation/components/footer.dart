import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../core/presentation/controllers/keyboard/keyboard/keyboard.dart';
import '../../../controllers/controllers.dart';

class Footer extends ConsumerWidget {
  final TextEditingController observationsController;
  final bool treatCanSave;
  const Footer({
    super.key,
    required this.observationsController,
    required this.treatCanSave,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDesktop = MediaQuery.sizeOf(context).width > Breakpoint.desktop;

    if (isDesktop) {
      return const SizedBox.shrink();
    }

    final keyboardIsOpen = ref.watch(keyboardVisibilityStateControllerProvider);
    final canSave =
        treatCanSave &&
        ref.watch(
          pendingBuyRequestStateControllerProvider.select(
            (s) => s.value?.canSave == true,
          ),
        );

    if (!canSave && keyboardIsOpen) {
      return const SizedBox.shrink();
    } else if (canSave && !keyboardIsOpen) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.p4),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Text('Total'.hardcoded, style: theme.textTheme.titleSmall),
                Consumer(
                  builder: (_, ref, _) {
                    final total = ref.watch(
                      pendingBuyRequestStateControllerProvider.select(
                        (s) =>
                            s.value?.products?.values.fold<double>(
                              0,
                              (p, e) => p + (e.cost * e.quantity),
                            ) ??
                            0,
                      ),
                    );
                    return TitleAndSubTitle(
                      title: null,
                      subTitle: total,
                      subTitleIsPrice: true,
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer(
              builder: (_, ref, _) {
                final cartIsEmpty = ref.watch(
                  pendingBuyRequestStateControllerProvider.select(
                    (s) => s.value?.products?.isEmpty ?? true,
                  ),
                );

                return PrimaryButton(
                  text: cartIsEmpty
                      ? 'Adicione produtos'.hardcoded
                      : 'Salvar'.hardcoded,
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
                                    insertBuyRequestControllerProvider.notifier,
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
