import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../localization/string_hardcoded.dart';

class InsertIndividuallySwitch extends StatelessWidget {
  final ValueNotifier<bool> insertIndividually;
  const InsertIndividuallySwitch({super.key, required this.insertIndividually});

  @override
  Widget build(BuildContext context) {
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
              child: ValueListenableBuilder<bool>(
                valueListenable: insertIndividually,
                builder: (_, isIndividually, _) {
                  return DefaultSwitch(
                    title: 'Inserir individualmente'.hardcoded,
                    value: isIndividually,
                    onChanged: (value) => insertIndividually.value = value,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
