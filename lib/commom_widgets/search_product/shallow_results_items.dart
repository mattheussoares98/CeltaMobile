import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../core/presentation/controllers/products/products.dart';
import '../../../../../localization/string_hardcoded.dart';
import '../../../../../utils/utils.dart';
import '../../core/domain/entities/entities.dart';

class ShallowResultsItems extends ConsumerWidget {
  final Function(ProductEntity) onSelected;
  const ShallowResultsItems({super.key, required this.onSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final keyboardHeight = MediaQuery.viewInsetsOf(context).bottom;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final maxAllowedHeight = screenHeight - keyboardHeight - 200;

    final titleStyle = theme.textTheme.bodyMedium;
    final packingStyle = theme.textTheme.titleSmall?.copyWith(
      color: theme.colorScheme.secondary,
    );
    final pluStyle = theme.textTheme.titleSmall?.copyWith();
    final isIOS = theme.platform == TargetPlatform.iOS;

    return RepaintBoundary(
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(Sizes.p8),
        clipBehavior: Clip.none, // PERFORMANCE: Clip.none is faster on GPU
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(
            maxHeight: maxAllowedHeight > 100 ? maxAllowedHeight : 100,
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
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: products.length,
                    separatorBuilder: (_, _) => const Divider(height: 0),
                    itemBuilder: (context, index) {
                      final product = products[index];

                      final packing =
                          '(${product.PackingAbbreviation} ${product.PackingQuantity.toString().toBrazilianNumber(3, true)})';

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Sizes.p16,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(0),
                                minTileHeight: Sizes.p24,
                                dense: true,
                                title: TitleAndSubTitle(
                                  title: product.Name,
                                  subTitle: packing,
                                  titleStyle: titleStyle,
                                  subTitleStyle: packingStyle,
                                ),
                                subtitle: TitleAndSubTitle(
                                  title: null,
                                  subTitle: product.PLU,
                                  titleStyle: titleStyle,
                                  subTitleStyle: pluStyle,
                                ),
                                onTap: () => onSelected(product),
                              ),
                            ),
                            Icon(isIOS ? CupertinoIcons.search : Icons.search),
                          ],
                        ),
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
