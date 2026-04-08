import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../localization/string_hardcoded.dart';
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
      appBar: AppBar(
        title: DefaultAppBarTitle(title: 'Detalhes do pedido'.hardcoded),
        actions: [
          ShowPdfButton(
            enterpriseCode: enterpriseCode,
            customerCode: customerCode,
            saleRequestCode: saleRequestId,
          ),
          PrintButton(
            enterpriseCode: enterpriseCode,
            customerCode: customerCode,
            saleRequestId: saleRequestId,
          ),
        ],
      ),
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
                      customerCode: customerCode,
                    ),
                    Customer(
                      saleRequestId: saleRequestId,
                      customerCode: customerCode,
                      enterpriseCode: enterpriseCode,
                    ),
                    Financial(
                      saleRequestId: saleRequestId,
                      customerCode: customerCode,
                      enterpriseCode: enterpriseCode,
                    ),
                    const Divider(),
                  ],
                ),
              ),
            ),
          ),
          ProductsItems(
            saleRequestId: saleRequestId,
            enterpriseCode: enterpriseCode,
            customerCode: customerCode,
          ),
          gapSliverH48,
        ],
      ),
    );
  }
}

class _HeroRequestSummary extends StatelessWidget {
  const _HeroRequestSummary({
    required this.saleRequestId,
    required this.enterpriseCode,
    required this.customerCode,
  });

  final int saleRequestId;
  final int enterpriseCode;
  final int customerCode;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'sale_request_$saleRequestId',
      child: Material(
        type: MaterialType.transparency,
        child: RequestSummary(
          saleRequestId: saleRequestId,
          enterpriseCode: enterpriseCode,
          showDetails: true,
          showCustomer: false,
          customerCode: customerCode,
        ),
      ),
    );
  }
}
