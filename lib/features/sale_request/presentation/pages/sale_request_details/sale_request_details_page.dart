import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../../../localization/string_hardcoded.dart';
import '../../controllers/controllers.dart';
import '../components/components.dart';
import 'components/components.dart';

class SaleRequestDetailsPage extends ConsumerWidget {
  final int saleRequestId;
  final int enterpriseCode;
  const SaleRequestDetailsPage({
    super.key,
    required this.saleRequestId,
    required this.enterpriseCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('Detalhes do pedido'.hardcoded)),
      body: CustomScrollView(
        slivers: [
          _HeroRequestSummary(
            saleRequestId: saleRequestId,
            enterpriseCode: enterpriseCode,
          ),
          ReloadButton(saleRequestId: saleRequestId),
          Customer(saleRequestId: saleRequestId),
          const SliverToBoxAdapter(child: Divider()),
          Consumer(
            builder: (context, ref, child) {
              final products = ref.watch(
                saleRequestDetailsStateControllerProvider(saleRequestId).select(
                  (s) => s.value?.collection.first.cart.values.toList() ?? [],
                ),
              );

              return ResponsiveListFlow(
                isSliver: true,
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final cartProduct = products[index];

                  return ProductItemWidget(
                    product: cartProduct.product!.copyWith(
                      Value: cartProduct.Value,
                    ),
                    hideCost: true,
                    hideCurrentAndSaleStocks: true,
                    hideWholeInformations: true,
                    routine: BsRoutine.saleRequest,
                    clickableBottom: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TitleAndSubTitle(
                          title: 'Quantidade',
                          subTitle: cartProduct.Quantity,
                        ),
                        TitleAndSubTitle(
                          title: 'Total',
                          subTitle: cartProduct.getTotalLiquid,
                          subTitleIsPrice: true,
                        ),
                      ],
                    ),
                  );
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
    return SliverToBoxAdapter(
      child: Hero(
        tag: 'sale_request_$saleRequestId',
        child: Material(
          type: MaterialType.transparency,
          child: Consumer(
            builder: (context, ref, child) {
              final saleRequest = ref.watch(
                saleRequestsStateControllerProvider(enterpriseCode).select(
                  (s) => s.value?.collection.firstWhereOrNull(
                    (sr) => sr.Id == saleRequestId,
                  ),
                ),
              );

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
      ),
    );
  }
}
