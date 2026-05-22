import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';

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
