import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../constants/constants.dart';
import '../../../../controllers/controllers.dart';

class LastSavedNumber extends ConsumerWidget {
  const LastSavedNumber({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return AsyncValueWidget(
      value: ref.watch(lastSavedNumberStateControllerProvider),
      tryAgain: null,
      data: (number) {
        if (number == null) {
          return const SizedBox.shrink();
        }

        return Center(
          child: Padding(
            padding: const EdgeInsets.all(Sizes.p8),
            child: TitleAndSubTitle(
              title: 'Último pedido salvo'.hardcoded,
              subTitle: RegExp(r'\((.*?)\)').firstMatch(number)?.group(1),
              subTitleStyle: theme.textTheme.titleMedium?.copyWith(
                color: theme.primaryColor,
              ),
            ),
          ),
        );
      },
    );
  }
}
