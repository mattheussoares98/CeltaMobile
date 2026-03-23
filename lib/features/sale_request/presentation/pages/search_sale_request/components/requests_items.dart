import 'package:celta_inventario/features/sale_request/domain/entities/sale_request_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../routing/routing.dart';
import '../../../controllers/controllers.dart';
import '../../components/components.dart';

class RequestsItems extends ConsumerWidget {
  final int enterpriseCode;
  const RequestsItems({super.key, required this.enterpriseCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return AsyncValueWidget(
      value: ref.watch(saleRequestsStateControllerProvider(enterpriseCode)),
      tryAgain: null,
      data: (saleRequests) {
        if (saleRequests?.collection.isEmpty == true) {
          return const Center(child: Text('Nenhum pedido encontrado'));
        }

        return ResponsiveListFlow(
          itemCount: saleRequests?.collection.length ?? 0,
          itemBuilder: (context, index) {
            final saleRequest = saleRequests!.collection[index];
            return _SaleRequestItem(
              key: ValueKey(saleRequest.Id),
              saleRequest: saleRequest,
              dateFormat: dateFormat,
              enterpriseCode: enterpriseCode,
            );
          },
        );
      },
    );
  }
}

class _SaleRequestItem extends StatelessWidget {
  const _SaleRequestItem({
    super.key,
    required this.saleRequest,
    required this.dateFormat,
    required this.enterpriseCode,
  });

  final SaleRequestEntity saleRequest;
  final DateFormat dateFormat;
  final int enterpriseCode;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'sale_request_${saleRequest.Id}',
      child: RequestSummary(
        saleRequest: saleRequest,
        onTap: () {
          context.goNamed(
            Routes.saleRequestDetails.name,
            pathParameters: {
              'saleRequestId': saleRequest.Id.toString(),
              'enterpriseCode': enterpriseCode.toString(),
            },
          );
        },
      ),
    );
  }
}
