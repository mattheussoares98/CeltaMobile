import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../domain/entities/entities.dart';
import '../../../controllers/controllers.dart';
import 'components/components.dart';

class CartPage extends ConsumerWidget {
  final DraftKey draftKey;
  const CartPage({super.key, required this.draftKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingAsync = ref.watch(
      cartProductsStateControllerProvider(draftKey),
    );

    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.p4),
      child: Column(
        children: [
          if (pendingAsync.value == null || pendingAsync.value!.isEmpty) ...[
            const LastSavedNumber(),
            Expanded(
              child: Center(
                child: Text(
                  'Nenhum produto adicionado ao carrinho'.hardcoded,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          ] else
            Expanded(
              child: CustomScrollView(
                physics: const ClampingScrollPhysics(),
                slivers: [
                  const SliverToBoxAdapter(child: LastSavedNumber()),
                  AsyncValueSliverWidget(
                    value: pendingAsync,
                    tryAgain: () => ref.invalidate(
                      cartProductsStateControllerProvider(draftKey),
                    ),
                    data: (items) {
                      return ResponsiveListFlow(
                        isSliver: true,
                        itemCount: items.length,
                        itemBuilder: (_, index) {
                          final item = items[index];

                          return Consumer(
                            builder: (_, ref, _) {
                              return ProductItem(
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
                  if ((pendingAsync.value?.length ?? 0) > 2) ...[
                    ClearCartButton(draftKey: draftKey),
                    gapSliverH16,
                  ],
                ],
              ),
            ),
          Footer(draftKey: draftKey),
        ],
      ),
    );
  }
}
