import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/transfer_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/transfer_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/transfer_request/presentation/pages/products_management/cart/components/components.dart';

class CartPage extends ConsumerWidget {
  final DraftKey draftKey;
  const CartPage({super.key, required this.draftKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final productsInCartLength = ref.watch(
      cartProductsStateControllerProvider(
        draftKey,
      ).select((s) => s.value?.length ?? 0),
    );

    return productsInCartLength == 0
        ? Center(
            child: Text(
              'Nenhum produto adicionado ao carrinho'.hardcoded,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(color: Colors.red),
            ),
          )
        : CustomScrollView(
            physics: const ClampingScrollPhysics(),
            slivers: [
              Consumer(
                builder: (_, ref, _) {
                  return AsyncValueWidget(
                    isSliver: true,
                    value: ref.watch(
                      cartProductsStateControllerProvider(draftKey),
                    ),
                    tryAgain: () => ref.invalidate(
                      cartProductsStateControllerProvider(draftKey),
                    ),
                    data: (items) {
                      return ResponsiveListFlow(
                        isSliver: true,
                        itemCount: items.length,
                        itemBuilder: (_, index) {
                          final item = items[index];

                          return ProductItem(
                            key: ValueKey(
                              '${item.product.ProductPackingCode}${item.product.EnterpriseCode}',
                            ),
                            item: item,
                            index: index,
                            draftKey: draftKey,
                          );
                        },
                      );
                    },
                  );
                },
              ),
              gapSliverH120,
            ],
          );
  }
}
