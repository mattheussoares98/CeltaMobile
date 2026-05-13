import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../localization/string_hardcoded.dart';
import '../../../controllers/controllers.dart';
import 'components/components.dart';

class CustomersPage extends ConsumerWidget {
  final int saleRequestId;
  final int customerCode;
  final int enterpriseCode;
  const CustomersPage({
    super.key,
    required this.saleRequestId,
    required this.customerCode,
    required this.enterpriseCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: SearchCustomerField(
            customerCode: customerCode,
            enterpriseCode: enterpriseCode,
            saleRequestId: saleRequestId,
          ),
        ),
        Consumer(
          builder: (context, ref, _) {
            final provider = searchedCustomersStateControllerProvider(
              customerCode: customerCode,
              enterpriseCode: enterpriseCode,
              saleRequestId: saleRequestId,
            );
            return AsyncValueWidget(
              value: ref.watch(provider),
              tryAgain: () => ref.invalidate(provider),
              isSliver: true,
              data: (customers) {
                if (customers.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(top: Sizes.p16),
                      child: Text(
                        'Nenhum cliente foi encontrado'.hardcoded,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
                return ResponsiveListFlow(
                  itemCount: customers.length,
                  isSliver: true,
                  itemBuilder: (context, index) {
                    final customer = customers[index];
                    return ListTile(
                      title: Text(customer.name ?? ''),
                      subtitle: Text(customer.cnpjCpfNumber ?? ''),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () {},
                    );
                  },
                );
              },
            );
          },
        ),
      ],
    );
  }
}
