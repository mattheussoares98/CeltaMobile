import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

    final selectedCovenant = ref.watch(
      insertUpdateStateControllerProvider.select(
        (s) => s.value?.customer?.covenants?.firstWhereOrNull(
          (e) => e.code == s.value?.customer?.selectedCovenant?.code,
        ),
      ),
    );

    if (selectedCovenant == null) {
      return Text(
        context.l10n.selectTheCustomerSAgreementToUseThisPaymentMethod,
        style: context.theme.textTheme.titleSmall?.copyWith(
          fontStyle: FontStyle.italic,
          color: Colors.red,
        ),
      );
    }

    return BaseDropDown<BsfCovenantEntity>(
      selectedItem: selectedCovenant,
      showLabelAtTopLeft: true,
      label: context.l10n.customerAgreement,
      items: [
        DropdownMenuItem(
          value: selectedCovenant,
          child: Center(child: Text(selectedCovenant.name)),
        ),
      ],
      onChanged: null,
    );
  }
}
