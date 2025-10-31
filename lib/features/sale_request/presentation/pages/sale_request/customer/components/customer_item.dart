import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../constants/constants.dart';
import '../../../../../../../core/domain/entities/entities.dart';
import '../../../../controllers/controllers.dart';

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

    void changeSelectedCustomer() {
      ref
          .read(pendingSaleRequestStateControllerProvider.notifier)
          .changeCustomer(customer);
    }

    return Card(
      margin: EdgeInsets.all(0),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          InkWell(
            onTap: changeSelectedCustomer,
            child: Padding(
              padding: const EdgeInsets.all(Sizes.p8),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TitleAndSubTitle(title: null, subTitle: customer.Name!),
                        if (!isConsumerCustomer) ...[
                          if (customer.Code != null)
                            TitleAndSubTitle(
                              title: 'Código'.hardcoded,
                              subTitle: customer.Code.toString(),
                            ),
                          if (customer.PersonalizedCode != null)
                            TitleAndSubTitle(
                              title: 'Código personalizado'.hardcoded,
                              subTitle: customer.PersonalizedCode,
                            ),
                          TitleAndSubTitle(
                            title: 'CPF/CNPJ'.hardcoded,
                            subTitle: customer.CpfCnpjNumber,
                          ),
                        ],
                      ],
                    ),
                  ),
                  RadioGroup<CustomerEntity>(
                    groupValue: selectedCustomer,
                    onChanged: (_) => changeSelectedCustomer(),
                    child: Radio(value: customer, toggleable: true),
                  ),
                ],
              ),
            ),
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
