import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/sale_request/presentation/pages/create_sale_request/customer/components/components.dart';

class CustomerItem extends ConsumerWidget {
  final SoapCustomerEntity customer;
  final bool isConsumerCustomer;
  final int enterpriseCode;
  const CustomerItem({
    super.key,
    required this.customer,
    required this.enterpriseCode,
    this.isConsumerCustomer = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCustomer = ref.watch(
      pendingSaleRequestStateControllerProvider(
        enterpriseCode,
      ).select((s) => s.value?.customer),
    );

    return Card(
      margin: const EdgeInsets.only(bottom: Sizes.p8),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          CustomerInfoAndRadio(
            customerItem: this,
            enterpriseCode: enterpriseCode,
            changeSelectedCustomer: () {
              if (customer.saleBlockade?.AllowSaleRequest == false) {
                showAlertDialog(
                  context: context,
                  title: 'Cliente bloqueado'.hardcoded,
                  content:
                      customer.saleBlockadeInstruction?.Description ??
                      'Este cliente está bloqueado!'.hardcoded,
                );
                return;
              }

              ref
                  .read(
                    pendingSaleRequestStateControllerProvider(
                      enterpriseCode,
                    ).notifier,
                  )
                  .changeCustomer(customer);
            },
          ),
          if (customer == selectedCustomer &&
              customer.CustomerCovenants != null &&
              customer.CustomerCovenants!.isNotEmpty) ...[
            Covenants(customerItem: this, enterpriseCode: enterpriseCode),
          ],
        ],
      ),
    );
  }
}
