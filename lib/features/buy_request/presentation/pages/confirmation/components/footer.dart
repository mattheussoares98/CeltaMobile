import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../domain/entities/entities.dart';

class Footer extends ConsumerWidget {
  final AsyncValue<PendingBuyRequestEntity> pendingAsync;
  const Footer({super.key, required this.pendingAsync});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

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
              text: 'Salvar',
              onPressed: () {
                showAlertDialog(
                  context: context,
                  title: 'Salvar pedido?'.hardcoded,
                  cancelActionText: 'Cancelar'.hardcoded,
                  defaultActionText: 'Sim'.hardcoded,
                  onOkPressed: () {
                    //TODO implement
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
