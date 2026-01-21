import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../controllers/controllers.dart';

class Footer extends ConsumerWidget {
  final TextEditingController observationsController;
  const Footer({super.key, required this.observationsController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final pendingAsync = ref.watch(pendingBuyRequestStateControllerProvider);

    final total =
        pendingAsync.value?.products?.values.fold<double>(
          0,
          (previousValue, element) =>
              previousValue + (element.cost * element.quantity),
        ) ??
        0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.p4),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Text('Total'.hardcoded, style: theme.textTheme.titleSmall),
                TitleAndSubTitle(
                  title: null,
                  subTitle: total,
                  subTitleIsPrice: true,
                ),
              ],
            ),
          ),
          Expanded(
            child: PrimaryButton(
              text: pendingAsync.value?.products?.values.isEmpty ?? true
                  ? 'Adicione produtos'.hardcoded
                  : 'Salvar'.hardcoded,
              onPressed: pendingAsync.value?.products?.values.isEmpty ?? true
                  ? null
                  : () {
                      showAlertDialog(
                        context: context,
                        title: 'Salvar pedido?'.hardcoded,
                        cancelActionText: 'Cancelar'.hardcoded,
                        defaultActionText: 'Sim'.hardcoded,
                        onOkPressed: () async {
                          final succeeds = await ref
                              .read(insertBuyRequestControllerProvider.notifier)
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
            ),
          ),
        ],
      ),
    );
  }
}
