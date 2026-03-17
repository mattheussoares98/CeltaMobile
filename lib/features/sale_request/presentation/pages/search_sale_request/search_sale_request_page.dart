import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../controllers/controllers.dart';
import 'components/components.dart';

class SearchSaleRequestPage extends ConsumerWidget {
  final int enterpriseCode;
  const SearchSaleRequestPage({super.key, required this.enterpriseCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('Busca de pedidos'.hardcoded)),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SaleRequestFilters(enterpriseCode: enterpriseCode),
          ),
          AsyncValueWidget(
            isSliver: true,
            value: ref.watch(
              saleRequestsStateControllerProvider(enterpriseCode),
            ),
            tryAgain: null,
            data: (saleRequests) {
              if (saleRequests?.collection.isEmpty == true) {
                return const SliverFillRemaining(
                  child: Center(child: Text('Nenhum pedido encontrado')),
                );
              }

              return ResponsiveListFlow(
                isSliver: true,
                itemCount: saleRequests?.collection.length ?? 0,
                itemBuilder: (context, index) {
                  final saleRequest = saleRequests!.collection[index];
                  return Text(saleRequest.SaleRequestNumber.toString());
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
