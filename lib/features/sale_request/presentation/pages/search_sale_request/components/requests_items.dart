import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../controllers/controllers.dart';

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

        return ResponsiveListFlow(
          itemCount: saleRequests?.collection.length ?? 0,
          itemBuilder: (context, index) {
            final saleRequest = saleRequests!.collection[index];
            return Text(saleRequest.SaleRequestNumber.toString());
          },
        );
      },
    );
  }
}
