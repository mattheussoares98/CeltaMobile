import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../constants/constants.dart';
import '../../../../../../../core/domain/entities/entities.dart';
import '../../../../controllers/controllers.dart';
import 'components.dart';

class CustomerItem extends ConsumerWidget {
  final CustomerEntity customer;
  final bool isConsumerCustomer;
  const CustomerItem({
    super.key,
    required this.customer,
    this.isConsumerCustomer = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final selectedCustomer = ref
        .watch(pendingSaleRequestStateControllerProvider)
        .value
        ?.customer;

    return Card(
      margin: EdgeInsets.all(0),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          CustomerInfoAndRadio(
            customerItem: this,
            selectedCustomer: selectedCustomer,
          ),
          if (customer == selectedCustomer &&
              customer.CustomerCovenants != null &&
              customer.CustomerCovenants!.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.all(Sizes.p8),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: customer.CustomerCovenants!.length + 1,
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
                  final covenant = customer.CustomerCovenants![index - 1];
                  return TitleAndSubTitle(
                    title: covenant.covenant?.Name ?? '',
                    subTitle: covenant.covenant?.Code.toString(),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
