import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../routing/routing.dart';
import '../../../../providers.dart';
import '../../../controllers/controllers.dart';
import '../../components/components.dart';

class RequestsItems extends ConsumerWidget {
  const RequestsItems({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AsyncValueWidget(
      value: ref.watch(saleRequestsStateControllerProvider),
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
              return _SaleRequestItem(key: ValueKey(saleRequest.Id));
            },
          ),
        );
      },
    );
  }
}

class _SaleRequestItem extends ConsumerWidget {
  const _SaleRequestItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final args = ref.watch(saleRequestArgsProvider);

    return Hero(
      tag: 'sale_request_${args.saleRequestId}',
      child: RequestSummary(
        onTap: () {
          context.goNamed(
            Routes.saleRequestDetails.name,
            pathParameters: {
              'saleRequestId': args.saleRequestId.toString(),
              'enterpriseCode': args.enterpriseCode.toString(),
              'customerCode': args.customerCode.toString(),
            },
          );
        },
      ),
    );
  }
}
