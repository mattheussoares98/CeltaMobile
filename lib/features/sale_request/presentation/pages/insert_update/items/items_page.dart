import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/sale_request/presentation/pages/components/components.dart';
import 'package:celta_inventario/features/sale_request/providers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/extensions/extensions.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ItemsPage extends ConsumerWidget {
  final bool isSliver;
  const ItemsPage({super.key, this.isSliver = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsCount = ref.watch(
      insertUpdateStateControllerProvider.select(
        (v) => v.value?.products?.length ?? 0,
      ),
    );
    if (productsCount == 0) {
      final child = Center(
        child: Text(
          'Adicione produtos no pedido!'.hardcoded,
          style: context.theme.textTheme.titleMedium?.copyWith(
            color: Colors.red,
          ),
        ),
      );

      if (isSliver) {
        return SliverToBoxAdapter(child: child);
      }

      return child;
    }

    final args = ref.read(saleRequestArgsProvider);
    return ResponsiveListFlow(
      padding: isSliver ? null : const EdgeInsets.all(Sizes.p8),
      isSliver: isSliver,
      itemCount: productsCount,
      itemBuilder: (context, index) {
        return Consumer(
          builder: (_, ref, _) {
            final item = ref.watch(
              insertUpdateStateControllerProvider.select(
                (v) => v.value!.products?.firstWhereIndexedOrNull(
                  (i, _) => i == index,
                ),
              ),
            );
            if (item == null) {
              return const SizedBox.shrink();
            }
            return BSFProductItemSummary(
              key: ValueKey('${item.productPackingCode ?? item.code}$isSliver'),
              product: item.toProductEntity(args.enterpriseCode),
              item: item,
              heroPrefix: 'items$isSliver',
            );
          },
        );
      },
    );
  }
}
