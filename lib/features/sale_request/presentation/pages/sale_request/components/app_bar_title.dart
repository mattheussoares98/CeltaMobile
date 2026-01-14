import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../localization/string_hardcoded.dart';
import '../../../../../../utils/utils.dart';
import '../../../controllers/controllers.dart';

class AppBarTitle extends ConsumerWidget {
  final int enterpriseCode;
  const AppBarTitle({super.key, required this.enterpriseCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appBarTitles = [
      'Inserir produtos'.hardcoded,
      'Cliente'.hardcoded,
      'Carrinho'.hardcoded,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FittedBox(
          child: Text(
            appBarTitles[ref.watch(pageIndexStateControllerProvider)],
          ),
        ),
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

            return FittedBox(
              child: TitleAndSubTitle(
                title: 'Últ ped'.hardcoded,
                subTitle: onlyNumber?.toInt(),
              ),
            );
          },
        ),
      ],
    );
  }
}
