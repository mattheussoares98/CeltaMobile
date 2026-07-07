import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/sale_request/presentation/pages/insert_update/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectedCustomer extends ConsumerWidget {
  const SelectedCustomer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customer = ref.watch(
      insertUpdateStateControllerProvider.select((v) => v.value?.customer),
    );

    if (customer == null) {
      return Center(child: BaseText.error('Selecione um cliente!'.hardcoded));
    }

    return CustomerItem(customer: customer, toggleable: false);
  }
}
