import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../controllers/controllers.dart';
import '../../components/components.dart';

class ItemsPage extends ConsumerWidget {
  final int enterpriseCode;
  final int customerCode;
  final int saleRequestId;
  const ItemsPage({
    super.key,
    required this.enterpriseCode,
    required this.customerCode,
    required this.saleRequestId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = insertUpdateStateControllerProvider(
      enterpriseCode: enterpriseCode,
      customerCode: customerCode,
      saleRequestId: saleRequestId,
    );

    final productsAsync = ref.watch(
      provider.select((v) => v.whenData((data) => data.products)),
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
              product: item.toProductEntity(enterpriseCode),
              item: item,
              enterpriseCode: enterpriseCode,
              customerCode: customerCode,
              saleRequestId: saleRequestId,
              heroPrefix: 'items',
            );
          },
        );
      },
      tryAgain: () => ref.invalidate(provider),
    );
  }
}
