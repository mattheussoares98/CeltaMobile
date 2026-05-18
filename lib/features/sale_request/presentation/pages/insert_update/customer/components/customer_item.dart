import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/cupertino.dart';
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
            Wrap(
              spacing: Sizes.p8,
              runSpacing: Sizes.p4,
              children: customer.covenants!
                  .map(
                    (c) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Sizes.p8,
                        vertical: Sizes.p4,
                      ),
                      decoration: BoxDecoration(
                        color: theme.primaryColorLight,
                        borderRadius: BorderRadius.circular(Sizes.p8),
                        border: Border.all(color: theme.primaryColorDark),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          PlatformIcon(
                            materialIcon: Icons.check_circle_outline,
                            cupertinoIcon: CupertinoIcons.checkmark_circle,
                            size: 13,
                            color: theme.primaryColorDark,
                          ),
                          const SizedBox(width: Sizes.p4),
                          Text(
                            c.name ?? '',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
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
