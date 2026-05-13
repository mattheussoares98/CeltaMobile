import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../localization/string_hardcoded.dart';
import '../../../controllers/controllers.dart';

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
    final provider = searchedCustomersStateControllerProvider(
      customerCode: customerCode,
      enterpriseCode: enterpriseCode,
      saleRequestId: saleRequestId,
    );

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: DefaultTextFormField(
            labelText: 'Pesquisar'.hardcoded,
            onFieldSubmitted: (value) {
              ref.read(provider.notifier).loadCustomer(value, false);
            },
          ),
        ),
        AsyncValueWidget(
          value: ref.watch(provider),
          tryAgain: () => ref.invalidate(provider),
          isSliver: true,
          data: (customers) {
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
        ),
      ],
    );
  }
}
