import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/constants.dart';
import '../../core/domain/entities/entities.dart';
import '../../core/presentation/controllers/products/products.dart';
import '../../localization/string_hardcoded.dart';
import '../../utils/utils.dart';
import '../commom_widgets.dart';

class ShallowResultsItems extends ConsumerWidget {
  final Function(ProductEntity) onSelected;
  const ShallowResultsItems({super.key, required this.onSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final titleStyle = theme.textTheme.bodyMedium;
    final subtitleStyle = theme.textTheme.titleSmall?.copyWith(
      color: theme.disabledColor,
    );

    final screenHeight = MediaQuery.sizeOf(context).height;
    final keyboardSize = MediaQuery.viewInsetsOf(context).bottom;
    const textFieldHeight = 55;
    final listHeight = screenHeight - textFieldHeight - keyboardSize;

    return RepaintBoundary(
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(Sizes.p8),
        clipBehavior: Clip.none, // PERFORMANCE: Clip.none is faster on GPU
        child: Container(
          height: listHeight - Sizes.p120,
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
                  if (products.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(Sizes.p16),
                      child: Text('Nenhum produto'.hardcoded),
                    );
                  }
                  return ListView.separated(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: products.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final product = products[index];

                      final packing =
                          '(${product.PackingAbbreviation} ${product.PackingQuantity.toString().toBrazilianNumber(3, true)})';

                      return ListTile(
                        dense: true,
                        title: TitleAndSubTitle(
                          title: product.Name,
                          subTitle: packing,
                          titleStyle: titleStyle,
                          subTitleStyle: subtitleStyle,
                        ),
                        subtitle: TitleAndSubTitle(
                          title: null,
                          subTitle: product.PLU,
                          titleStyle: titleStyle,
                          subTitleStyle: subtitleStyle,
                        ),
                        onTap: () => onSelected(product),
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
