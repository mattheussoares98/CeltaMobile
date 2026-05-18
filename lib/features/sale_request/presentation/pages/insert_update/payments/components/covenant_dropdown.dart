import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../controllers/controllers.dart';

class CovenantDropdown extends ConsumerWidget {
  const CovenantDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPayment = ref.watch(
      selectedPaymentTypeStateControllerProvider,
    );

    final isCovenantPayment =
        selectedPayment?.action?.type == PaymentFinalizationActionType.covenant;

    if (!isCovenantPayment) {
      return const SizedBox.shrink();
    }

    final customer = ref.watch(
      insertUpdateStateControllerProvider.select((s) => s.value?.customer),
    );

    final hasCovenants =
        customer?.covenants != null && customer!.covenants!.isNotEmpty;

    final theme = Theme.of(context);
    if (!hasCovenants) {
      return Text(
        'O cliente não possui convênios! Selecione outra forma de pagamento ou adicione um convênio para esse cliente'
            .hardcoded,
        style: theme.textTheme.titleSmall?.copyWith(
          fontStyle: FontStyle.italic,
          color: Colors.red,
        ),
      );
    }

    final items = customer.covenants!
        .map(
          (c) => DropdownMenuItem(
            value: c,
            child: Center(child: Text(c.name ?? '')),
          ),
        )
        .toList();

    return Consumer(
      builder: (context, ref, child) {
        final selectedCovenant = ref.watch(
          selectedCovenantStateControllerProvider,
        );
        return DefaultDropDown<BsfCovenantEntity>(
          selectedItem: selectedCovenant,
          label: 'Convênio'.hardcoded,
          hint: Text('Selecionar convênio'.hardcoded),
          validator: (_) {
            if (selectedCovenant == null) {
              return 'Selecione um convênio'.hardcoded;
            }
            return null;
          },
          items: items,
          onChanged: (value) {
            ref
                .read(selectedCovenantStateControllerProvider.notifier)
                .select(value);
          },
        );
      },
    );
  }
}
