import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../domain/entities/entities.dart';
import '../../../controllers/controllers.dart';
import '../../components/components.dart';
import 'components/components.dart';

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

    final isDesktop = MediaQuery.of(context).size.width > Breakpoint.desktop;

    return Padding(
      padding: const EdgeInsets.all(Sizes.p4),
      child: Column(
        children: [
          if (productsInCartLength == 0)
            Expanded(
              child: Center(
                child: Text(
                  'Nenhum produto adicionado ao carrinho'.hardcoded,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.red,
                  ),
                ),
              ),
            )
          else
            Expanded(
              child: CustomScrollView(
                physics: const ClampingScrollPhysics(),
                slivers: [
                  if (productsInCartLength > 2 && !isDesktop) ...[
                    SliverToBoxAdapter(
                      child: ClearCartButton(draftKey: draftKey),
                    ),
                  ],
                  Consumer(
                    builder: (_, ref, _) {
                      return AsyncValueSliverWidget(
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
                                isLastItem: index == items.length - 1,
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
                ],
              ),
            ),
        ],
      ),
    );
  }
}
