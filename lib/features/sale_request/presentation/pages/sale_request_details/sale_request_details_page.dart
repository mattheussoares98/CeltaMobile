import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../constants/constants.dart';
import '../../../../../localization/string_hardcoded.dart';

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
        child: Padding(
          padding: const EdgeInsets.all(Sizes.p8),
          child: Column(
            children: [
              Hero(
                tag: 'sale_request_$saleRequestId',
                child: Material(
                  type: MaterialType.transparency,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(Sizes.p16),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Informações do Pedido'.hardcoded,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            gapH16,
                            // This area will match the list item's content
                            Text('ID: #$saleRequestId'),
                            const Placeholder(fallbackHeight: 100),
                          ],
                        ),
                      ),
                    ),
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
      ),
    );
  }
}
