import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/buy_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/buy_request/presentation/pages/search/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShallowBuyRequestsPage extends ConsumerWidget {
  final int enterpriseCode;
  const ShallowBuyRequestsPage({super.key, required this.enterpriseCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BaseScaffold(
      isScrollable: false,
      appBar: BaseAppBar(
        title: 'Consulta de pedidos de compras'.hardcoded,
        selectedEnterpriseCode: enterpriseCode,
      ),
      body: Column(
        children: [
          SelectDateAndSearchButton(enterpriseCode: enterpriseCode),
          gapH12,
          Consumer(
            builder: (_, ref, _) {
              final provider = shallowBuyRequestStateControllerProvider(
                enterpriseCode,
              );
              return AsyncValueWidget(
                value: ref.watch(provider),
                tryAgain: null,
                data: (buyRequests) {
                  if (buyRequests.isEmpty) {
                    return Center(
                      child: BaseText.error(
                        'Nenhum pedido de compra foi encontrado'.hardcoded,
                      ),
                    );
                  }

                  return Expanded(
                    child: ResponsiveListFlow(
                      itemCount: buyRequests.length,
                      itemBuilder: (context, index) {
                        final item = buyRequests[index];

                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(Sizes.p8),
                            child: Text(item.toString()),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
