import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/sale_request/presentation/pages/components/components.dart'
    hide PrintButton;
import 'package:celta_inventario/features/sale_request/presentation/pages/sale_request_details/components/components.dart';
import 'package:celta_inventario/features/sale_request/providers.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    ref.listen(printSaleRequestControllerProvider, (p, n) {
      n.showToastOnSuccess(
        context,
        previous: p,
        message: context.l10n.printJobSentSuccessfully,
      );
    });

    final saleRequestArgs = SaleRequestArgs(
      enterpriseCode: enterpriseCode,
      customerCode: customerCode,
      saleRequestId: saleRequestId,
    );
    return ProviderScope(
      overrides: [saleRequestArgsProvider.overrideWithValue(saleRequestArgs)],
      child: BaseScaffold(
        isScrollable: false,
        refreshProvider: saleRequestDetailsStateControllerProvider(
          saleRequestArgs,
        ),
        appBar: BaseAppBar(
          title: context.l10n.orderDetails,
          selectedEnterpriseCode: enterpriseCode,
          actions: [
            const EditButton(),
            const ShowPdfButton(),
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
                    ],
                  ),
                ),
              ),
            ),
            const ProductsItems(),
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
    final args = SaleRequestArgs(
      enterpriseCode: enterpriseCode,
      customerCode: customerCode,
      saleRequestId: saleRequestId,
    );
    final saleRequestDetails = ref
        .watch(saleRequestDetailsStateControllerProvider(args))
        .value;
    return Hero(
      tag: 'sale_request_$saleRequestId',
      child: Material(
        type: MaterialType.transparency,
        child: RequestSummaryWidget(
          showDetails: true,
          showCustomer: false,
          saleRequestDetails: saleRequestDetails,
          args: args,
        ),
      ),
    );
  }
}
