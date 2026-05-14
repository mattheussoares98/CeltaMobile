import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../localization/string_hardcoded.dart';
import '../../../domain/entities/entities.dart';
import '../../../providers.dart';
import '../components/components.dart';
import 'components/components.dart';

class SaleRequestDetailsPage extends ConsumerWidget {
  final int enterpriseCode;
  final int customerCode;
  final int saleRequestId;
  const SaleRequestDetailsPage({
    super.key,
    required this.enterpriseCode,
    required this.customerCode,
    required this.saleRequestId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProviderScope(
      overrides: [
        saleRequestArgsProvider.overrideWithValue(
          SaleRequestArgs(
            enterpriseCode: enterpriseCode,
            customerCode: customerCode,
            saleRequestId: saleRequestId,
          ),
        ),
      ],
      //TODO create separated file
      child: Scaffold(
        appBar: AppBar(
          title: DefaultAppBarTitle(title: 'Detalhes do pedido'.hardcoded),
          actions: [
            if (kDebugMode) const EditButton(),
            const ShowPdfButton(),
            Consumer(
              builder: (_, ref, _) {
                return PrintButton(
                  enterpriseCode: enterpriseCode,
                  customerCode: customerCode,
                  saleRequestId: saleRequestId,
                );
              },
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
                        enterpriseCode: enterpriseCode,
                        customerCode: customerCode,
                        saleRequestId: saleRequestId,
                      ),
                      Customer(enterpriseCode: enterpriseCode),
                      const Financial(),
                      const Divider(),
                    ],
                  ),
                ),
              ),
            ),
            const ProductsItems(),
            gapSliverH48,
          ],
        ),
      ),
    );
  }
}

class _HeroRequestSummary extends ConsumerWidget {
  final int enterpriseCode;
  final int saleRequestId;
  final int customerCode;
  const _HeroRequestSummary({
    required this.enterpriseCode,
    required this.saleRequestId,
    required this.customerCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Hero(
      tag: 'sale_request_$saleRequestId',
      child: Material(
        type: MaterialType.transparency,
        child: RequestSummary(
          showDetails: true,
          showCustomer: false,
          enterpriseCode: enterpriseCode,
          customerCode: customerCode,
          saleRequestId: saleRequestId,
        ),
      ),
    );
  }
}
