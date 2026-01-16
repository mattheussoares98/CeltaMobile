import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../localization/string_hardcoded.dart';
import '../../../controllers/controllers.dart';

class InsertIndividuallySwitch extends ConsumerWidget {
  final int codigoInternoInventario;
  const InsertIndividuallySwitch({
    super.key,
    required this.codigoInternoInventario,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(top: Sizes.p8),
        child: Row(
          children: [
            Tooltip(
              triggerMode: TooltipTriggerMode.tap,
              showDuration: const Duration(seconds: 5),
              message:
                  'Quando essa opção está ativa, ao encontrar um único produto na busca, será somado automaticamente 1 quantidade'
                      .hardcoded,
              child: Padding(
                padding: const EdgeInsets.only(right: Sizes.p4),
                child: Icon(isIOS ? CupertinoIcons.info : Icons.info_outline),
              ),
            ),
            Flexible(
              child: DefaultSwitch(
                title: 'Inserir individualmente'.hardcoded,
                value: ref.watch(
                  uiStateControllerProvider(
                    codigoInternoInventario,
                  ).select((s) => s.insertIndividually),
                ),
                onChanged: (_) => ref
                    .read(
                      uiStateControllerProvider(
                        codigoInternoInventario,
                      ).notifier,
                    )
                    .updateInsertIndividually(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
