import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../constants/constants.dart';
import '../../../../../../../core/domain/entities/entities.dart';
import '../../../../controllers/controllers.dart';
import 'components.dart';

class Covenants extends ConsumerWidget {
  final CustomerItem customerItem;
  const Covenants({super.key, required this.customerItem});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final selectedCovenant = ref
        .watch(pendingSaleRequestStateControllerProvider)
        .value
        ?.covenant;

    void onTapCovenant(CustomerCovenantEntity covenant) {
      ref
          .read(pendingSaleRequestStateControllerProvider.notifier)
          .changeCovenant(covenant);
    }

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
                const Divider(height: 0),
                Text(
                  'Convênios'.hardcoded,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.primaryColor,
                  ),
                ),
              ],
            );
          }
          final covenant = customerItem.customer.CustomerCovenants![index - 1];
          return Card(
            clipBehavior: Clip.antiAlias,
            margin: const EdgeInsets.only(top: Sizes.p8),
            child: InkWell(
              onTap: () => onTapCovenant(covenant),
              child: RadioGroup<CustomerCovenantEntity>(
                groupValue: selectedCovenant,
                onChanged: (_) => onTapCovenant(covenant),
                child: Padding(
                  padding: const EdgeInsets.all(Sizes.p8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            TitleAndSubTitle(
                              title: null,
                              subTitle: covenant.covenant?.Name,
                            ),
                            if (covenant.LimitOfPurchase != null)
                              TitleAndSubTitle(
                                title: 'Limite'.hardcoded,
                                subTitle: covenant.LimitOfPurchase,
                                subTitleIsPrice: true,
                              ),
                          ],
                        ),
                      ),
                      Radio(value: covenant, toggleable: true),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
