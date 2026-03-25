import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../localization/string_hardcoded.dart';
import '../../controllers/controllers.dart';
import '../components/components.dart';
import 'components/components.dart';

class SaleRequestDetailsPage extends ConsumerWidget {
  final int saleRequestId;
  final int enterpriseCode;
  final int customerCode;
  const SaleRequestDetailsPage({
    super.key,
    required this.saleRequestId,
    required this.enterpriseCode,
    required this.customerCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('Detalhes do pedido'.hardcoded)),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: Breakpoint.desktop,
                child: Column(
                  children: [
                    _HeroRequestSummary(
                      saleRequestId: saleRequestId,
                      enterpriseCode: enterpriseCode,
                    ),
                    ReloadButton(
                      saleRequestId: saleRequestId,
                      customerCode: customerCode,
                      enterpriseCode: enterpriseCode,
                    ),
                    // Customer(saleRequestId: saleRequestId),
                    const Divider(),
                  ],
                ),
              ),
            ),
          ),
          Consumer(
            builder: (context, ref, child) {
              final products = ref.watch(
                saleRequestDetailsStateControllerProvider(
                  saleRequestCode: saleRequestId,
                  enterpriseCode: enterpriseCode,
                  customerCode: customerCode,
                ).select((s) => s.value?.products),
              );

              return ResponsiveListFlow(
                isSliver: true,
                itemCount: products?.length ?? 0,
                itemBuilder: (context, index) {
                  final cartProduct = products![index];

                  return Text(cartProduct.product!.name!);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class _HeroRequestSummary extends StatelessWidget {
  const _HeroRequestSummary({
    required this.saleRequestId,
    required this.enterpriseCode,
  });

  final int saleRequestId;
  final int enterpriseCode;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'sale_request_$saleRequestId',
      child: Material(
        type: MaterialType.transparency,
        child: Consumer(
          builder: (context, ref, child) {
            final saleRequest = ref
                .watch(
                  saleRequestsStateControllerProvider(enterpriseCode).select(
                    (s) => s.value?.collection.firstWhereOrNull(
                      (sr) => sr.Id == saleRequestId,
                    ),
                  ),
                ) /* ??
                ref.watch(
                  saleRequestDetailsStateControllerProvider(
                    saleRequestId,
                  ).select((s) => s.value?.collection.first),
                ) */;

            if (saleRequest == null) {
              return const SizedBox.shrink();
            }

            return RequestSummary(
              saleRequest: saleRequest,
              showCustomer: false,
            );
          },
        ),
      ),
    );
  }
}
