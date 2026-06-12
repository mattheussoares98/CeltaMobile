import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/sale_request/presentation/pages/insert_update/customer/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomersPage extends ConsumerWidget {
  const CustomersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDesktop =
        (PlatformUtil.isDesktop || PlatformUtil.isWeb) &&
        MediaQuery.sizeOf(context).width > Breakpoint.desktop;

    Widget searchFieldAndConsumerCustomer = Column(
      children: [
        const SearchCustomerField(),
        gapH4,
        Consumer(
          builder: (context, ref, _) {
            final searchByPersonalizedCode = ref.watch(
              searchedCustomersStateControllerProvider.select(
                (s) => s.value?.searchByPersonalizedCode == true,
              ),
            );
            return DefaultSwitch(
              title: 'Pesquisar pelo código personalizado'.hardcoded,
              value: searchByPersonalizedCode,
              onChanged: (_) {
                ref
                    .read(searchedCustomersStateControllerProvider.notifier)
                    .toggleSearchByPersonalizedCode();
              },
            );
          },
        ),
        const ConsumerCustomer(),
      ],
    );

    if (isDesktop) {
      searchFieldAndConsumerCustomer = ResponsiveCenter(
        child: searchFieldAndConsumerCustomer,
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.p8),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: searchFieldAndConsumerCustomer),
          const SearchedCustomersItems(),
          gapSliverH32,
        ],
      ),
    );
  }
}
