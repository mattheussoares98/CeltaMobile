import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/sale_request/presentation/pages/components/components.dart';
import 'package:celta_inventario/features/sale_request/providers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ItemsPage extends ConsumerWidget {
  final bool isSliver;
  const ItemsPage({super.key, this.isSliver = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final args = ref.read(saleRequestArgsProvider);

    return Consumer(
      builder: (_, ref, _) {
        final products = ref.watch(
          insertUpdateStateControllerProvider.select((v) => v.value?.products),
        );
        if (products?.isEmpty ?? true) {
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
        return ResponsiveListFlow(
          padding: isSliver ? null : const EdgeInsets.all(Sizes.p8),
          isSliver: isSliver,
          itemCount: products!.length,
          itemBuilder: (context, index) {
            final item = products[index];
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
    );
  }
}
