import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/sale_request/presentation/pages/components/components.dart';
import 'package:celta_inventario/features/sale_request/providers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ItemsPage extends ConsumerWidget {
  final bool isSliver;
  const ItemsPage({super.key, this.isSliver = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final args = ref.watch(saleRequestArgsProvider);

    final productsAsync = ref.watch(
      insertUpdateStateControllerProvider.select(
        (v) => v.whenData((data) => data.products),
      ),
    );

    return AsyncValueWidget(
      value: productsAsync,
      isSliver: isSliver,
      data: (products) {
        final items = products ?? [];
        if (items.isEmpty) {
          if (isSliver) {
            return const SliverToBoxAdapter(child: SizedBox.shrink());
          }

          return Center(child: Text('Nenhum item adicionado'.hardcoded));
        }
        return ResponsiveListFlow(
          padding: isSliver ? null : const EdgeInsets.all(Sizes.p8),
          isSliver: isSliver,
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return BSFProductItemSummary(
              key: ValueKey('${item.productPackingCode ?? item.code}$isSliver'),
              product: item.toProductEntity(args.enterpriseCode),
              item: item,
              enterpriseCode: args.enterpriseCode,
              customerCode: args.customerCode,
              saleRequestId: args.saleRequestId,
              heroPrefix: 'items$isSliver',
            );
          },
        );
      },
      tryAgain: () => ref.invalidate(insertUpdateStateControllerProvider),
    );
  }
}
