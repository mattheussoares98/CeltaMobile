import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../routing/routing.dart';
import '../../../controllers/controllers.dart';
import '../../components/components.dart';

class RequestsItems extends ConsumerWidget {
  final int enterpriseCode;
  const RequestsItems({super.key, required this.enterpriseCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AsyncValueWidget(
      value: ref.watch(saleRequestsStateControllerProvider(enterpriseCode)),
      tryAgain: null,
      data: (saleRequests) {
        if (saleRequests?.collection.isEmpty == true) {
          return const Center(child: Text('Nenhum pedido encontrado'));
        }

        return Expanded(
          child: ResponsiveListFlow(
            itemCount: saleRequests?.collection.length ?? 0,
            itemBuilder: (context, index) {
              final saleRequest = saleRequests!.collection[index];
              return _SaleRequestItem(
                key: ValueKey(saleRequest.Id),
                enterpriseCode: enterpriseCode,
                customerCode: saleRequest.customer!.Code!,
                saleRequestId: saleRequest.Id!,
              );
            },
          ),
        );
      },
    );
  }
}

class _SaleRequestItem extends ConsumerWidget {
  final int saleRequestId;
  final int enterpriseCode;
  final int customerCode;
  const _SaleRequestItem({
    super.key,
    required this.saleRequestId,
    required this.enterpriseCode,
    required this.customerCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Hero(
      tag: 'sale_request_$saleRequestId',
      child: RequestSummary(
        enterpriseCode: enterpriseCode,
        saleRequestId: saleRequestId,
        customerCode: customerCode,
        onTap: () {
          context.goNamed(
            Routes.saleRequestDetails.name,
            pathParameters: {
              'saleRequestId': saleRequestId.toString(),
              'enterpriseCode': enterpriseCode.toString(),
              'customerCode': customerCode.toString(),
            },
          );
        },
      ),
    );
  }
}
