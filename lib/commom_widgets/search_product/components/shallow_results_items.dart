import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../core/presentation/controllers/products/products.dart';
import '../../../../../../localization/string_hardcoded.dart';
import '../../../../../../utils/utils.dart';
import '../../../core/domain/entities/entities.dart';

class ShallowResultsItems extends ConsumerWidget {
  final Function(ProductEntity) onSelected;

  const ShallowResultsItems({super.key, required this.onSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final keyboardHeight = MediaQuery.viewInsetsOf(context).bottom;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final maxAllowedHeight = screenHeight - keyboardHeight - 220;

    return RepaintBoundary(
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(Sizes.p8),
        clipBehavior: Clip.none, // PERFORMANCE: Clip.none is faster on GPU
        child: Container(
          constraints: BoxConstraints(
            maxHeight: maxAllowedHeight > 120 ? maxAllowedHeight : 120,
          ),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(Sizes.p8),
            border: Border.all(color: theme.dividerColor.withAlpha(50)),
          ),
          child: Consumer(
            builder: (context, ref, child) {
              return AsyncValueWidget(
                useLinearProgressIndicator: true,
                value: ref.watch(shallowProductsStateControllerProvider),
                tryAgain: null,
                data: (products) {
                  if (products == null) {
                    return const SizedBox.shrink();
                  }
                  if (products.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(Sizes.p16),
                      child: Text('Nenhum produto'.hardcoded),
                    );
                  }
                  return ListView.separated(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: const ClampingScrollPhysics(),
                    itemCount: products.length,
                    separatorBuilder: (_, _) => const Divider(height: 0),
                    itemBuilder: (context, index) {
                      return _ShallowItemTile(
                        product: products[index],
                        onTap: () => onSelected(products[index]),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ShallowItemTile extends StatelessWidget {
  final ProductEntity product;
  final VoidCallback onTap;

  const _ShallowItemTile({required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;
    final packing =
        '(${product.PackingAbbreviation} ${product.PackingQuantity.toString().toBrazilianNumber(3, true)})';

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.p16,
          vertical: Sizes.p4,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitleAndSubTitle(
                    title: product.Name,
                    subTitle: packing,
                    titleStyle: theme.textTheme.bodyMedium,
                    subTitleStyle: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                  TitleAndSubTitle(
                    title: null,
                    subTitle: product.PLU,
                    subTitleStyle: theme.textTheme.titleSmall,
                  ),
                ],
              ),
            ),
            Icon(
              isIOS ? CupertinoIcons.search : Icons.search,
              size: 20,
              color: theme.disabledColor,
            ),
          ],
        ),
      ),
    );
  }
}
