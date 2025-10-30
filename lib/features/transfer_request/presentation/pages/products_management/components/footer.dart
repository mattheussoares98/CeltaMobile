import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../domain/entities/entities.dart';
import '../../../controllers/controllers.dart';

class Footer extends ConsumerWidget {
  final DraftKey draftKey;
  const Footer({super.key, required this.draftKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final pendingAsync = ref.watch(
      cartProductsStateControllerProvider(draftKey),
    );

    final total =
        pendingAsync.value?.fold<double>(
          0,
          (p, e) => p + (e.value * e.quantity),
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
              onPressed: pendingAsync.value?.isEmpty == true
                  ? null
                  : () {
                      showAlertDialog(
                        context: context,
                        title: 'Salvar pedido?'.hardcoded,
                        cancelActionText: 'Cancelar'.hardcoded,
                        defaultActionText: 'Sim'.hardcoded,
                        onOkPressed: () {
                          ref
                              .read(
                                insertTransferRequestControllerProvider(
                                  draftKey,
                                ).notifier,
                              )
                              .insert();
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
