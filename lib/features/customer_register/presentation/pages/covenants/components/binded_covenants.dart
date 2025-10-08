import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/material.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../core/domain/entities/entities.dart';

class BindedCovenants extends StatelessWidget {
  final List<CustomerCovenantEntity> bindedCovenants;
  const BindedCovenants({super.key, required this.bindedCovenants});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView.builder(
      shrinkWrap: true,
      itemCount: bindedCovenants.length,
      itemBuilder: (_, index) {
        final covenant = bindedCovenants[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(Sizes.p8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  covenant.covenant?.Name ?? '',
                  style: theme.textTheme.titleMedium,
                ),
                TitleAndSubTitle(
                  title: 'Código '.hardcoded,
                  subTitle: covenant.covenant?.Code.toString(),
                ),
                TitleAndSubTitle(
                  title: 'Limite '.hardcoded,
                  subTitle:
                      'R\$ ${covenant.LimitOfPurchase.toString().toBrazilianNumber(2, false)}',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
