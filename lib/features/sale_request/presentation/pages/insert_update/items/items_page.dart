import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../providers.dart';
import '../../../controllers/controllers.dart';
import '../../components/components.dart';

class ItemsPage extends ConsumerWidget {
  const ItemsPage({super.key});

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
      data: (products) {
        final items = products ?? [];
        if (items.isEmpty) {
          return Center(child: Text('Nenhum item adicionado'.hardcoded));
        }
        return ResponsiveListFlow(
          padding: const EdgeInsets.all(Sizes.p8),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return BSFProductItemSummary(
              key: ValueKey(item.productPackingCode ?? item.code),
              product: item.toProductEntity(args.enterpriseCode),
              item: item,
              enterpriseCode: args.enterpriseCode,
              customerCode: args.customerCode,
              saleRequestId: args.saleRequestId,
              heroPrefix: 'items',
            );
          },
        );
      },
      tryAgain: () => ref.invalidate(insertUpdateStateControllerProvider),
    );
  }
}
