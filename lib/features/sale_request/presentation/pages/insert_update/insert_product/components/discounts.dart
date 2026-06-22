import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/sale_request/presentation/pages/components/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Discounts extends ConsumerWidget {
  const Discounts({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final product = ref.watch(currentProductItemProvider);
    final uiProvider = insertProductUIControllerProvider(product);

    final discounts = ref.watch(uiProvider.select((s) => s.discounts));

    if (discounts.length <= 1) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }
    void removeDiscount(int index) {
      ref.read(uiProvider.notifier).removeDiscount(index);
    }

    return ResponsiveListFlow(
      isSliver: true,
      itemCount: discounts.length,
      itemBuilder: (context, index) {
        final discount = discounts[index];

        return Row(
          children: [
            Expanded(child: Text(discount.formattedDescription)),
            ExcludeFocus(
              child: IconButton(
                onPressed: () => removeDiscount(index),
                icon: const PlatformIcon(
                  cupertinoIcon: CupertinoIcons.delete,
                  materialIcon: Icons.delete,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
