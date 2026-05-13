import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../localization/string_hardcoded.dart';
import '../../../providers.dart';
import '../components/components.dart';
import 'components/components.dart';

class SaleRequestDetailsPage extends ConsumerWidget {
  const SaleRequestDetailsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: DefaultAppBarTitle(title: 'Detalhes do pedido'.hardcoded),
        actions: [
          if (kDebugMode) const EditButton(),
          const ShowPdfButton(),
          Consumer(
            builder: (_, ref, _) {
              final args = ref.watch(saleRequestArgsProvider);

              return PrintButton(
                enterpriseCode: args.enterpriseCode,
                customerCode: args.customerCode,
                saleRequestId: args.saleRequestId,
              );
            },
          ),
        ],
      ),
      body: const CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: Breakpoint.desktop,
                child: Column(
                  children: [
                    _HeroRequestSummary(),
                    Customer(),
                    Financial(),
                    Divider(),
                  ],
                ),
              ),
            ),
          ),
          ProductsItems(),
          gapSliverH48,
        ],
      ),
    );
  }
}

class _HeroRequestSummary extends ConsumerWidget {
  const _HeroRequestSummary();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final args = ref.watch(saleRequestArgsProvider);

    return Hero(
      tag: 'sale_request_${args.saleRequestId}',
      child: const Material(
        type: MaterialType.transparency,
        child: RequestSummary(showDetails: true, showCustomer: false),
      ),
    );
  }
}
