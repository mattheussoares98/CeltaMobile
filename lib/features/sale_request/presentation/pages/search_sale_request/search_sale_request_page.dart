import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../utils/utils.dart';
import '../../controllers/controllers.dart';
import 'components/components.dart';

class SearchSaleRequestPage extends ConsumerStatefulWidget {
  final int enterpriseCode;
  const SearchSaleRequestPage({super.key, required this.enterpriseCode});

  @override
  ConsumerState<SearchSaleRequestPage> createState() =>
      _SearchSaleRequestPageState();
}

class _SearchSaleRequestPageState extends ConsumerState<SearchSaleRequestPage> {
  final expansibleController = ExpansibleController();

  @override
  void dispose() {
    expansibleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(saleRequestsStateControllerProvider(widget.enterpriseCode), (
      p,
      n,
    ) {
      n.doOnSuccess(p, () {
        if (n.value != null) {
          expansibleController.collapse();
        }
      });
    });

    return Scaffold(
      appBar: AppBar(title: Text('Busca de pedidos'.hardcoded)),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SaleRequestFilters(
              expansibleController: expansibleController,
              enterpriseCode: widget.enterpriseCode,
            ),
          ),

          AsyncValueWidget(
            isSliver: true,
            value: ref.watch(
              saleRequestsStateControllerProvider(widget.enterpriseCode),
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
