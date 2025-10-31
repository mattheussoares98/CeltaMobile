import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../constants/constants.dart';
import 'components.dart';

class Covenants extends ConsumerWidget {
  final CustomerItem customerItem;
  const Covenants({super.key, required this.customerItem});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(Sizes.p8),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: customerItem.customer.CustomerCovenants!.length + 1,
        itemBuilder: (_, index) {
          if (index == 0) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Divider(height: 0),
                Text(
                  'Convênios'.hardcoded,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.primaryColor,
                  ),
                ),
                gapH4,
              ],
            );
          }
          final covenant = customerItem.customer.CustomerCovenants![index - 1];
          return TitleAndSubTitle(
            title: covenant.covenant?.Name ?? '',
            subTitle: covenant.covenant?.Code.toString(),
          );
        },
      ),
    );
  }
}
