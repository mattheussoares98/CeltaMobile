import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../constants/constants.dart';
import '../../../../../localization/string_hardcoded.dart';
import '../../controllers/controllers.dart';
import '../components/components.dart';

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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Hero(
              tag: 'sale_request_$saleRequestId',
              child: Material(
                type: MaterialType.transparency,
                child: Consumer(
                  builder: (context, ref, child) {
                    final saleRequest = ref.watch(
                      saleRequestsStateControllerProvider(
                        enterpriseCode,
                      ).select(
                        (s) => s.value?.collection.firstWhereOrNull(
                          (sr) => sr.Id == saleRequestId,
                        ),
                      ),
                    );

                    if (saleRequest == null) {
                      return const SizedBox.shrink();
                    }

                    return SingleChildScrollView(
                      child: RequestSummary(saleRequest: saleRequest),
                    );
                  },
                ),
              ),
            ),

            // PERFORMANCE: Other details like product lists should be
            // outside the Hero to keep the animation light.
            gapH16,
            const Text('Produtos do Pedido'),
            const Placeholder(fallbackHeight: 300),
          ],
        ),
      ),
    );
  }
}
