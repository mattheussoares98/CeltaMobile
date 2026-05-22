import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/sale_request/presentation/pages/create_sale_request/customer/components/components.dart';

class CustomerInfoAndRadio extends ConsumerWidget {
  final CustomerItem customerItem;
  final VoidCallback changeSelectedCustomer;
  final int enterpriseCode;
  const CustomerInfoAndRadio({
    super.key,
    required this.customerItem,
    required this.changeSelectedCustomer,
    required this.enterpriseCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: changeSelectedCustomer,
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p8),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitleAndSubTitle(
                    title: null,
                    subTitle: customerItem.customer.Name!,
                  ),
                  if (!customerItem.isConsumerCustomer) ...[
                    if (customerItem.customer.Code != null)
                      TitleAndSubTitle(
                        title: 'Código'.hardcoded,
                        subTitle: customerItem.customer.Code.toString(),
                      ),
                    if (customerItem.customer.PersonalizedCode != null)
                      TitleAndSubTitle(
                        title: 'Código personalizado'.hardcoded,
                        subTitle: customerItem.customer.PersonalizedCode,
                      ),
                    TitleAndSubTitle(
                      title: 'CPF/CNPJ'.hardcoded,
                      subTitle: customerItem.customer.CpfCnpjNumber,
                    ),
                  ],
                ],
              ),
            ),
            Consumer(
              builder: (_, ref, _) {
                final selectedCustomer = ref.watch(
                  pendingSaleRequestStateControllerProvider(
                    enterpriseCode,
                  ).select((s) => s.value?.customer),
                );

                return RadioGroup<SoapCustomerEntity>(
                  groupValue: selectedCustomer,
                  onChanged: (_) => changeSelectedCustomer(),
                  child: Radio(value: customerItem.customer, toggleable: true),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
