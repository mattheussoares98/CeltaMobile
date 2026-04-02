import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../localization/string_hardcoded.dart';
import '../../../../../../utils/utils.dart';
import '../../../controllers/controllers.dart';

class AppBarTitle extends ConsumerWidget {
  final int enterpriseCode;
  const AppBarTitle({super.key, required this.enterpriseCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DefaultAppBarTitle(),
        Consumer(
          builder: (_, ref, _) {
            final lastSavedNumber = ref.watch(
              lastSavedSaleRequestStateControllerProvider(
                enterpriseCode,
              ).select((s) => s.value?.saleRequestNumber),
            );
            if (lastSavedNumber == null) {
              return const SizedBox.shrink();
            }

            final onlyNumber = RegExp(
              r'\((\d+)\)',
            ).firstMatch(lastSavedNumber)?.group(1)?.removeWhiteSpaces();

            if (onlyNumber?.toInt() == null) {
              return const SizedBox.shrink();
            }

            final theme = Theme.of(context);

            return FittedBox(
              child: TitleAndSubTitle(
                copyableSubtitle: true,
                title: 'Últ ped'.hardcoded,
                subTitle: onlyNumber,
                subTitleStyle: theme.textTheme.titleMedium?.copyWith(
                  color: theme.primaryColor,
                ),
              ),
            );
          },
        ),
        gapH4,
      ],
    );
  }
}
