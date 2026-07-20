import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/buy_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/buy_request/presentation/pages/search/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
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
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            floating: true,
            delegate: _SearchHeaderDelegate(
              child: SelectDateAndSearchButton(enterpriseCode: enterpriseCode),
            ),
          ),
          Consumer(
            builder: (_, ref, _) {
              final provider = shallowBuyRequestStateControllerProvider(
                enterpriseCode,
              );
              return AsyncValueWidget(
                value: ref.watch(provider),
                tryAgain: null,
                isSliver: true,
                data: (buyRequests) {
                  if (buyRequests.isEmpty) {
                    return SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: BaseText.error(
                          'Nenhum pedido de compra foi encontrado'.hardcoded,
                        ),
                      ),
                    );
                  }

                  return ResponsiveListFlow(
                    isSliver: true,
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

class _SearchHeaderDelegate extends SliverPersistentHeaderDelegate {
  static const _extent = kToolbarHeight;

  final Widget child;
  const _SearchHeaderDelegate({required this.child});

  @override
  double get minExtent => _extent;

  @override
  double get maxExtent => _extent;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return ColoredBox(
      color: context.theme.scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.only(bottom: Sizes.p12),
        child: child,
      ),
    );
  }

  @override
  bool shouldRebuild(_SearchHeaderDelegate oldDelegate) =>
      oldDelegate.child != child;
}
