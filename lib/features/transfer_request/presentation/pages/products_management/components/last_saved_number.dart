import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';

class LastSavedNumber extends ConsumerWidget {
  final String number;
  const LastSavedNumber({super.key, required this.number});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(Sizes.p8),
      child: TitleAndSubTitle(
        title: 'Último pedido salvo'.hardcoded,
        subTitle: RegExp(r'\((.*?)\)').firstMatch(number)?.group(1),
        subTitleStyle: theme.textTheme.titleMedium?.copyWith(
          color: theme.colorScheme.secondary,
        ),
      ),
    );
  }
}
