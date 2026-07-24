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
      padding: const EdgeInsets.fromLTRB(Sizes.p8, Sizes.p8, Sizes.p8, 0),
      appBar: BaseAppBar(
        title: 'Consulta de pedidos de compras'.hardcoded,
        selectedEnterpriseCode: enterpriseCode,
      ),
      pinnedBody: Padding(
        padding: const EdgeInsets.only(bottom: Sizes.p12),
        child: Consumer(
          builder: (_, ref, _) {
            final provider = shallowBuyRequestStateControllerProvider(
              enterpriseCode,
            );
            return SelectDateRangeAndSearchButton(
              maximumDaysDifference: const Duration(days: 90),
              isLoading: ref.watch(provider.select((state) => state.isLoading)),
              onSearch: (initialDate, finalDate) =>
                  ref.read(provider.notifier).load(initialDate, finalDate),
            );
          },
        ),
      ),
      body: Consumer(
        builder: (_, ref, _) {
          final provider = shallowBuyRequestStateControllerProvider(
            enterpriseCode,
          );
          return AsyncValueWidget(
            value: ref.watch(provider),
            tryAgain: null,
            data: (buyRequests) {
              if (buyRequests?.isEmpty == true) {
                return Center(
                  child: BaseText.error(
                    'Nenhum pedido de compra foi encontrado'.hardcoded,
                  ),
                );
              }

              return ShallowBuyRequestItems(enterpriseCode: enterpriseCode);
            },
          );
        },
      ),
    );
  }
}
