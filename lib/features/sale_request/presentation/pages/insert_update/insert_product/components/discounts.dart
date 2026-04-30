import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../utils/utils.dart';
import '../../../../../domain/entities/entities.dart';
import '../../../../controllers/controllers.dart';

class Discounts extends ConsumerWidget {
  final BSFProductItemEntity product;

  const Discounts({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final discounts = ref.watch(
      insertProductUIControllerProvider(product).select((s) => s.discounts),
    );

    if (discounts.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }
    void removeDiscount(int index) {
      ref
          .read(insertProductUIControllerProvider(product).notifier)
          .removeDiscount(index);
    }

    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    return ResponsiveListFlow(
      isSliver: true,
      itemCount: discounts.length,
      itemBuilder: (context, index) {
        final discount = discounts[index].discount;

        final discountValue = discount?.value?.toString().toBrazilianNumber(
          2,
          discount.type == PercentageOrValue.percentage,
        );

        return Row(
          children: [
            Expanded(
              child: Text('$discountValue ${discount?.type?.symbol ?? ""} '),
            ),
            ExcludeFocus(
              child: IconButton(
                onPressed: () => removeDiscount(index),
                icon: Icon(
                  isIOS ? CupertinoIcons.delete : Icons.delete,
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
