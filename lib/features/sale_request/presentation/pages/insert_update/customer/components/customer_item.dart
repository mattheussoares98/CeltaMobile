import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomerItem extends ConsumerWidget {
  final BSFCustomerEntity customer;
  const CustomerItem({super.key, required this.customer});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final enabled = ref.watch(
      insertUpdateStateControllerProvider.select(
        (s) => s.value?.customer?.code == customer.code,
      ),
    );

    final hasCovenants =
        customer.covenants != null && customer.covenants!.isNotEmpty;

    return DefaultCheckBox(
      name: customer.name ?? '',
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (customer.cnpjCpfNumber != null)
            Text(customer.cnpjCpfNumber!.toMaskedCnpjCpf()),
          if (hasCovenants) ...[
            const SizedBox(height: Sizes.p4),
            TitleAndSubTitle(
              title: null,
              subTitle: 'Convênios'.hardcoded,
              subTitleStyle: theme.textTheme.titleSmall?.copyWith(
                color: theme.primaryColorDark,
              ),
            ),
            const SizedBox(height: Sizes.p4),
            Consumer(
              builder: (context, ref, _) {
                final selectedCovenant = ref.watch(
                  insertUpdateStateControllerProvider.select(
                    (s) => s.value?.customer?.code == customer.code
                        ? s.value?.customer?.covenants?.firstWhereOrNull(
                            (e) => e.code == s.value?.customer?.covenantCode,
                          )
                        : null,
                  ),
                );
                return DefaultChoiceChip<BsfCovenantEntity>(
                  items: customer.covenants!,
                  selectedValue: selectedCovenant,
                  allowNullSelection: true,
                  onChanged: (covenant) {
                    ref
                        .read(insertUpdateStateControllerProvider.notifier)
                        .updateCovenant(customer, covenant);
                  },
                );
              },
            ),
          ],
        ],
      ),
      enabled: enabled,
      onChanged: (_) {
        ref
            .read(insertUpdateStateControllerProvider.notifier)
            .updateCustomer(customer);
      },
    );
  }
}
